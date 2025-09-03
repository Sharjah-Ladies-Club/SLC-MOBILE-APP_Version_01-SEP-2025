// Project folder exists inside the repo root directory. Update your project folder name here. Ex: template
def PROJECT_FOLDER_NAME = 'slc'
def APK_PREFIX          = 'SLC-3.3.4.'

pipeline {
      //Instructs Jenkins to allocate an any available agent/node in the Jenkins environment and workspace.
      agent any
      options {
        //Skip checking out code from source control by default
        skipDefaultCheckout true
        // Stop the build early in case of compile or test failures
        skipStagesAfterUnstable()
      }
      //Parameters which a user should input when triggering the Build/Pipeline Job.
      parameters {
       //Update choices array with list of build types which you have configured in your build.gradle file. Ex: Debug, Beta, Release
        choice(name: 'appType', choices: ['APK', 'AppBundle','Split'], description: 'Select app type')

        //Update choices array with list of build types which you have configured in your build.gradle file. Ex: Debug, Beta, Release
        choice(name: 'buildType', choices: ['debug', 'release'], description: 'Select build type')

        //Update choices array with list of branch names required for your project to generate a build. Ex: develop, master
        choice(name: 'branchName', choices: ['develop','release_2.14'], description: 'Select branch name')

        //Update choices array with list of site names required for your project to generate a build. Ex: dev, beta
		 choice(name: 'flavor', choices: ['develop', 'qa','uat'], description: 'Select flavor')
      }
      stages {
        // Stage, is to tell the Jenkins that this is the new process/step that needs to be executed
        stage('Checkout') {
            steps {
            //Print choice parameters which user has selected
            echo "App Type: ${params.appType}"
            echo "Build Type: ${params.buildType}"
            echo "Branch Name: ${params.branchName}"
			echo "Flavor: ${params.flavor}"
            // Pull the code from the repo
            checkout changelog: true, poll: false, scm:[$class: 'GitSCM', branches: [[name: "${params.branchName}"]], , doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'Jenkins_Bitbucket_AzureVM', url: 'git@bitbucket.org:impiger/slc_mobileapp-phase1_android.git']]]
          }
        }
		stage('Flutter version setting') {
          steps {
            // Compile the app and its dependencies
            dir("c:/flutter/") {bat "git checkout 3.3.4"}
          }
        }
		stage('Flutter version') {
          steps {
            // Compile the app and its dependencies
            dir(PROJECT_FOLDER_NAME) {bat "flutter doctor -v"}
          }
        }
		stage('Clean') {
          steps {
            // Compile the app and its dependencies
            dir(PROJECT_FOLDER_NAME) {bat "flutter clean"}
          }
        }
        stage('GetPackages') {
          steps {
             // Compile the app and its dependencies
               dir(PROJECT_FOLDER_NAME) {bat "flutter pub get"}
          }
        }
        stage('Compile') {
          steps {
           script{
            if ("${params.appType}" == 'Split') {
                // Compile the app and its dependencies
                dir(PROJECT_FOLDER_NAME) {bat "flutter build apk --split-per-abi --${buildType} --flavor ${flavor} -t lib/main_${flavor}.dart"}
            }
             if ("${params.appType}" == 'AppBundle') {
                // Compile the app and its dependencies
                dir(PROJECT_FOLDER_NAME) {bat "flutter build appbundle --${buildType} --flavor ${flavor} -t lib/main_${flavor}.dart"}
            }
            if ("${params.appType}" == 'APK') {
                // Compile the app and its dependenciesō
                dir(PROJECT_FOLDER_NAME) {bat "flutter build apk --${buildType} --flavor ${flavor} -t lib/main_${flavor}.dart"}
            }
          }
         }
        }

		stage('Archive') {
          steps {
          script{
           if ("${params.appType}" == 'Split') {

           // Archive the APKs so that they can be downloaded from Jenkins
           //archiveArtifacts artifacts: '**/build/app/outputs/apk/**/*${APK_PREFIX}${env.BUILD_NUMBER}.apk , **/app/build/outputs/mapping/**/mapping.txt'
           archiveArtifacts artifacts: '**/build/app/outputs/apk/**/*.apk , **/app/build/outputs/mapping/**/mapping.txt'
         }

           if ("${params.appType}" == 'AppBundle') {
           dir(PROJECT_FOLDER_NAME) {
                         // Rename based on build number
                       fileOperations ( [
                               fileRenameOperation(
                               destination: "build/app/outputs/bundle/${flavor}${buildType}/${APK_PREFIX}${env.BUILD_NUMBER}-${buildType}-${flavor}.aab",
                               source: "build/app/outputs/bundle/${flavor}${buildType}/app-${flavor}-${buildType}.aab")
                           ]
                         )
                       }

                      // Archive the Bundles so that they can be downloaded from Jenkins
                      archiveArtifacts artifacts: "**/build/app/outputs/bundle/**/${APK_PREFIX}${env.BUILD_NUMBER}-${buildType}-${flavor}.aab"
           }

           if ("${params.appType}" == 'APK') {
                       dir(PROJECT_FOLDER_NAME) {
                         // Rename based on build number
                         fileOperations ( [
                               fileRenameOperation(
                               destination: "build/app/outputs/apk/${flavor}/${buildType}/${APK_PREFIX}${env.BUILD_NUMBER}-${buildType}-${flavor}.apk",
                               source: "build/app/outputs/apk/${flavor}/${buildType}/app-${flavor}-${buildType}.apk")
                           ]
                         )
                       }

                      // Archive the APKs so that they can be downloaded from Jenkins
                     archiveArtifacts artifacts: '**/build/app/outputs/apk/**/*.apk , **/app/build/outputs/mapping/**/mapping.txt'
                    }
          }
		}
		}
    }
}