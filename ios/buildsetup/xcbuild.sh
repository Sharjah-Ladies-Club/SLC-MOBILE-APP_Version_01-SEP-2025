#! /bin/bash
##############################################################
##   Flutter iOS Build system                               ##
##       Based on : iOS Script v8                           ##
##       Release notes at EOF                               ##
##############################################################
source ~/.bash_profile
# Added below line to fix localization settings faced pod install by flutter.
# Error Message:ArgumentError - invalid byte sequence in US-ASCII
#export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8


#--------------------------------------------------------------
#HELPER VARIABLES
CI_KEYCHAIN="$JOB_NAME-$BUILD_VERSION.keychain"
BUILD_OUTPUT_PATH="$WORKSPACE/build"
rm -rf "$BUILD_OUTPUT_PATH"
#--------------------------------------------------------------

#--------------------------------------------------------------
#DEV CONFIGURATION
CERT_PASSWORD="123456"
PROJECT_ROOT_DIR="$WORKSPACE/slc/"
BUILD_SETUP_PATH="$WORKSPACE/slc/ios/buildsetup"
EXPORT_OPTION_PLIST_PATH="$BUILD_SETUP_PATH/*.plist"
#--------------------------------------------------------------



main() {
    AppBuildFor="development"
    CodeSignName="Apple Development: Kadeeja Mansoor (JD2HHCH732)"
    
    echo "Reciving build request for flavour : $FlavourName"
    if ! [ -x "$(command -v flutter)" ];then
        echo 'Error: flutter is not installed. Contact Jenkins administrator.' >&2
        exit 9
    else
    
        trap job_cleanup 0 1 2 3 6 9 14 15
        
        setupKeychainAndProfiles

        cd $PROJECT_ROOT_DIR
        flutter clean
        if [ $? -ne 0 ];then
          echo ">>>Flutter clean failed<<<"
        fi
        
        FlavourName="DEV"
        echo ">>>Running flutter build command <<<<"
#        flutter build ios --flavor $FlavourName -t "lib/main_$FlavourName.dart" --no-codesign
        
        flutter build ios --no-codesign
        
        if [ $? -ne 0 ];then
            echo "Error: Flutter build get's failed."
            job_cleanup
            exit 8
        fi
        echo ">>>Ending flutter build command <<<<"
    fi

    echo ">>>Running Xcode build command <<<<"

    cd "$PROJECT_ROOT_DIR"
    #format for workspace build: workspace_archive_build "WorkspaceFilePath" "SchemeName" "ConfigType" "Team ID" "development/app-store/enterprise" "Profile Name" "iPhone Distribution/iPhone Developer" "Bundle Identifier"

    Profile="Sharjah Ladies Club Dev"
    workspace_archive_build "ios/Runner.xcworkspace" "Runner" "Release" "JD2HHCH732" "${AppBuildFor}" "${Profile}" "${CodeSignName}" "com.sharjah.ladiesclub"

   


}

function setupKeychainAndProfiles {
    pushd $BUILD_SETUP_PATH

    create_new_kc
    copy_mobileprovision
    update_appversion

    popd
}

# END OF DEV CONFIGURATION
########################################################

#------------------                 ------------------
#------------------                 ------------------
#------------------ CREATE KEYCHAIN ------------------
function create_new_kc {
    echo $'\n\n\n'
    echo "---------- Creating Keychain ----------"
    CI_KEYCHAIN_PASSWORD=$(dd if=/dev/urandom count=1 2> /dev/null | uuencode -m - | sed -ne 2p | cut -c-12)
    security create-keychain -p "$CI_KEYCHAIN_PASSWORD" "$CI_KEYCHAIN"
    echo "Created Keychain $CI_KEYCHAIN"
    # Append keychain to the search list
    security list-keychains -d user -s "$CI_KEYCHAIN" $(security list-keychains -d user | sed s/\"//g)
    #trap "{ job_cleanup }" EXIT
    # Unlock the keychain
    security set-keychain-settings "$CI_KEYCHAIN"
    echo "Unlocking Keychain $CI_KEYCHAIN"
    security unlock-keychain -p "$CI_KEYCHAIN_PASSWORD" "$CI_KEYCHAIN"
    # Import certificate
    echo "Importing Certificates"
    ImportCert=$BUILD_SETUP_PATH/*.p12
    echo $ImportCert
    security import $ImportCert -k "$CI_KEYCHAIN" -P "$CERT_PASSWORD" -T "/usr/bin/codesign"
    #security show-keychain-info $CI_KEYCHAIN
    SIGN_IDEN=$(security find-identity -p codesigning -v $CI_KEYCHAIN|head -n1|cut -d "\"" -f 2)
    if [ "$SIGN_IDEN" == "" ];then
        exit 5
    fi

    # For macOS 10.12+, new security enforcement need following command.
    #security set-key-partition-list -S apple: -k $CI_KEYCHAIN_PASSWORD -D "$SIGN_IDEN" -t private $CI_KEYCHAIN
    security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k $CI_KEYCHAIN_PASSWORD $CI_KEYCHAIN
}

#------------------                  ------------------
#------------------                  ------------------
#------------------ MOBILE PROVISION ------------------
function copy_mobileprovision {
    echo $'\n\n\n'
    echo "---------- Attempting to copy Mobile Provision ----------"
    echo `find $BUILD_SETUP_PATH -name "*.mobileprovision"`
    #$PROVISION_PATH configured in Jenkins envronment variable
    cp `find $BUILD_SETUP_PATH -name "*.mobileprovision"` "$PROVISION_PATH"
    if test $? -eq 0
    then
        echo "** Provisioning profile copied successfully **"
    else
        echo "** Provisioning profile copy command failed **"
        exit 1
    fi

}

#------------------            ------------------
#------------------            ------------------
#------------------ VERSIONING ------------------
function update_appversion {
    echo $'\n\n\n'
    echo "---------- Versioning Build ----------"
    pushd $PROJECT_ROOT_DIR/ios
    /usr/bin/xcrun agvtool new-version -all "$SPRINT_VERSION.$BUILD_NUMBER" # sets CFBundleVersion
    /usr/bin/xcrun agvtool new-marketing-version "$MAJOR_VERSION.$MINOR_VERSION" # sets CFBundleShortVersionString
    popd
}


#------------------ XC BUILD WORKSPACE PROJECT -----------------
# Usage with Input: workspace_archive_build "WorkspacePath" "SchemeName" "ConfigType"
function workspace_archive_build {

    outputFileNameFormat=$2-$BUILD_VERSION-$3
    archiveFileName=$outputFileNameFormat.xcarchive
    archivePath=$BUILD_OUTPUT_PATH/$archiveFileName
    keychainPath=$(security list-keychain | grep "$CI_KEYCHAIN")
    echo $'\n\n\n'
    echo "---------- Building Archive ----------"
    xcodebuild -workspace $1 -scheme $2 -configuration $3 clean archive -archivePath $archivePath DEVELOPMENT_TEAM=$4 OTHER_CODE_SIGN_FLAGS="--keychain $keychainPath"
    if test $? -eq 0
    then
        echo "Build successful"
    else
        echo "** Build command failed **"
        exit 1
    fi
    
    
    archive_deployment "${1}" "${2}" "${3}" "${outputFileNameFormat}" "${archiveFileName}" "${archivePath}" "${4}" "${5}" "${6}" "${7}" "${8}"
}

#------------------ XC BUILD ARTIFACT HELPERS -----------------
function archive_deployment {
    outputFileNameFormat=$4
    archiveFileName=$5
    archivePath=$6
    echo $'\n\n\n'
    echo "---------- Exporting ipa ----------"
    echo $@
 

    echo "method : ${8}"
    echo "AppID : ${11}"
    echo "ProfileName : ${9}"
    echo "CodeSignName : ${10}"
    echo "TeamID : ${7}"
 

     buildexportPlist "$8" "${11}" "${9}" "${10}" "${7}"
    
       
    xcodebuild -exportArchive -exportOptionsPlist $EXPORT_OPTION_PLIST_PATH -archivePath $archivePath -exportPath $BUILD_OUTPUT_PATH DEVELOPMENT_TEAM=$7 OTHER_CODE_SIGN_FLAGS="--keychain $keychainPath"
         
     
    if test $? -eq 0
    then
        echo "ipa conversion success"
    else
        echo "** ipa conversion command failed **"
        exit 2
    fi
    
    echo "---------- rename ipa ----------"
    cd $BUILD_OUTPUT_PATH
    mv $BUILD_OUTPUT_PATH/$2.ipa $BUILD_OUTPUT_PATH/$outputFileNameFormat.ipa
    if test $? -eq 0
    then
        echo "rename ipa success"
    else
        echo "** rename ipa failed **"
        exit 3
    fi
    
    cd $WORKSPACE
    echo $'\n\n\n'
    echo "---------- zip the archive ----------"
    cd $BUILD_OUTPUT_PATH
    zip -r ${archivePath}.zip ${archiveFileName}
    if test $? -eq 0
    then
        echo "zip archive success"
    else
        echo "** zip archive command failed **"
        exit 4
    fi
    
    cd $WORKSPACE
}

function buildexportPlist {
pushd $BUILD_SETUP_PATH
rm exportoptions.plist

method="$1"  #$8
AppID="$2" # $11
ProfileName="$3" # $9
CodeSignName="$4" # $10
TeamID="$5" # $7


cat > exportoptions.plist <<EOF
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict> <key>beta-reports-active</key> <true/>
       <key>method</key> <string>$method</string>
       <key>provisioningProfiles</key>
       <dict>
           <key>$AppID</key>
           <string>$ProfileName</string>
       </dict>
       <key>signingCertificate</key> <string>$CodeSignName</string>
       <key>signingStyle</key> <string>manual</string>
       <key>stripSwiftSymbols</key> <true/>
       <key>teamID</key> <string>$TeamID</string>
       <key>uploadBitcode</key> <false/>
       <key>uploadSymbols</key> <true/>
   </dict>
   </plist>
EOF

popd

}

#------------------             -----------------
#------------------             -----------------
#------------------ JOB CLEANUP -----------------
function job_cleanup {
    echo $'\n\n\n'
    echo "---------- JOB CLEANUP ----------"
    remove_profiles
    remove_new_kc
}

#------------------                   -----------------
#------------------                   -----------------
#------------------ DELETING KEYCHAIN -----------------
function remove_new_kc {
    security delete-keychain "$CI_KEYCHAIN"
    echo "REMOVED Keychain $CI_KEYCHAIN"
}

#------------------                   -----------------
#------------------                   -----------------
#------------------ DELETING PROFILES -----------------
function remove_profiles {
    cd "$PROVISION_PATH"
    rm -rf *.mobileprovision
    echo "REMOVED PROFILES"
    cd $WORKSPACE
}

function lowerCase {
    # Added below line for tr: Illegal byte sequence
#    export LC_CTYPE=C
    echo "$1" | tr '[:upper:]' '[:lower:]'
}


main "$@"










##############################################################
##   iOS Flutter build system release notes                 ##
##                                                          ##
##   Version : 2.0                                          ##
##   *************                                          ##
##         1. Support to get Artifcats for the builds       ##
##         2. Allow to takes build for multiple flavour     ##
##                                                          ##
##   Version : 1.0                                          ##
##   *************                                          ##
##         1. Unofficial version of Flutter build released  ##
##            for people 1                                  ##
##                                                          ##
##                                                          ##
##                                                          ##
##   iOS Release History:                                   ##
##   ********************                                   ##
##      Script v8:                                          ##
##      -----------                                         ##
##                1.Multiple environment based build using  ##
##                  jenkins env variables                   ##
##                                                          ##
##                                                          ##
##      Script v7:                                          ##
##      -----------                                         ##
##                1.Build script updated for Xcode 9        ##
##                2.Added additional parameters in          ##
##                  ExportOptions.plist file for exporting  ##
##                  IPA.                                    ##
##                                                          ##
##                                                          ##
##      Script v6:                                          ##
##      -----------                                         ##
##                1.security keychain unlock command        ##
##                  added for Mac OS 10.12                  ##
##                                                          ##
##                                                          ##
##      Script v5:                                          ##
##      -----------                                         ##
##                1.Workspace and project build:            ##
##                  certificate matching from leftover      ##
##                  KC fixed (aborted jobs)                 ##
##                                                          ##
##                                                          ##
##      Script v4:                                          ##
##      -----------                                         ##
##                1.Support for universal library build     ##
##                2.Support for test case report generation ##
##                                                          ##
##                                                          ##
##                                                          ##
##############################################################

