import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
// import 'package:package_info/package_info.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/network/GMCore.dart';
import 'package:slc/gmcore/security/AESCrypt.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/SlcDateUtils.dart';
import 'package:slc/gmcore/utils/GMUtils.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/url_utils.dart';
import 'package:slc/utils/utils.dart';

class SplashRepository {
  static const platform = const MethodChannel("app_data");

  getFCMToken() async {
    Meta meta = Meta();
    if (await GMUtils().isInternetConnected()) {
      await FirebaseMessaging.instance.getToken().then((token) async {
        meta.statusCode = 200;
        meta.statusMsg = token;
        final FirebaseRemoteConfig remoteConfig =
            await FirebaseRemoteConfig.instance;
        // print("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
        await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: Duration(minutes: 1),
          minimumFetchInterval: Duration(seconds: 0),
        ));
        await remoteConfig.fetchAndActivate();
        // print("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTSSSS");
        // remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: false));
        // await remoteConfig.fetch(expiration: const Duration(seconds: 10));
        // await remoteConfig.activateFetched();

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        //String version = packageInfo.version;
        String buildNumber =
            //"0";
            packageInfo.buildNumber;

//        var versionCode = remoteConfig.getString(Constants.VersionCode);
        var androidVersionCode =
            remoteConfig.getString(Constants.AndroidVersionCode);
        var iosVersionCode = remoteConfig.getString(Constants.IOSVersionCode);

        if (SPUtil.getBool(Constants.CHECK_APP_UPDATE, defValue: false)) {
          if (Platform.isAndroid) {
            int playstoreVersion = 0;
            try {
              playstoreVersion = await platform.invokeMethod('appForceUpdate');
              print('SLCisUpdateAvailable----> $playstoreVersion');
            } on PlatformException catch (e) {
              print('e----> ${e.toString()}');
            } on Exception catch (e1) {
              print('e1----> ${e1.toString()}');
            }
            _sendAnalyticsEvent(
                buildNumber: packageInfo.buildNumber,
                androidVersionNumber: androidVersionCode,
                iOSVersionNumber: iosVersionCode,
                playstoreVersion: playstoreVersion.toString());

//          if (isAndroidUpdateAvailable) {
//            meta.statusCode = 10000;
//            meta.statusMsg = "Version Number invalidate";
//          }
//            if (int.parse(buildNumber) < 1000) {
//              //For development
//              if (int.parse(androidVersionCode) > int.parse(buildNumber)) {
//                meta.statusCode = 10000;
//                meta.statusMsg = "Version Number invalidate";
//              }
//            } else {
            if (playstoreVersion > int.parse(buildNumber)) {
              meta.statusCode = 10000;
              meta.statusMsg = "Version Number invalidate";
//              }
//            var x = int.parse(buildNumber) - int.parse(androidVersionCode);
//
//            var y = x % 1000;
//            if (y != 0) {
//              meta.statusCode = 10000;
//              meta.statusMsg = "Version Number invalidate";
//            }
            }
          } else if (Platform.isIOS) {
            if (iosVersionCode != null && iosVersionCode.length > 0) {
              if (int.parse(iosVersionCode) > int.parse(buildNumber)) {
                meta.statusCode = 10000;
                meta.statusMsg = "Version Number invalidate";
              }
            }
          }
        }
      }).catchError((err) {
        meta.statusCode = 201;
        meta.statusMsg = err.toString();
      });
    } else {
      meta.statusCode = 201;
      meta.statusMsg =
          SPUtil.getInt(Constants.CURRENT_LANGUAGE) == Constants.LANGUAGE_ARABIC
              ? Strings.chknetArbStr
              : Strings.chknetEngStr;
    }
    return meta;
  }

//  getABINumber(String name) {
//    switch (name.toLowerCase()) {
//      case "armeabi-v7a":
//      case "armeabi":
//        return 1000;
//        break;
//      case "arm64-v8a":
//        return 2000;
//        break;
//      case "x86":
//        return 3000;
//        break;
//      case "x86_64":
//        return 4000;
//        break;
//    }
//  }

  Future<void> _sendAnalyticsEvent(
      {String buildNumber,
      String androidVersionNumber,
      String iOSVersionNumber,
      String playstoreVersion}) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'VersionChecking',
      parameters: <String, dynamic>{
        'LocalVersionNumber': buildNumber,
        'AndroidVersionNumber': androidVersionNumber,
        'iOSVersionNumber': iOSVersionNumber,
        'playstoreVersion': playstoreVersion,
      },
    );
  }

  // ignore: missing_return
  Future<List<Meta>> getRemoteKeys() async {
    List<Meta> meta = [];
    try {
      final FirebaseRemoteConfig remoteConfig =
          await FirebaseRemoteConfig.instance;
      // remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: false));
      // await remoteConfig.fetch(expiration: const Duration(seconds: 1));
      // await remoteConfig.activateFetched();
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(minutes: 1),
        minimumFetchInterval: Duration(seconds: 0),
      ));
      await remoteConfig.fetchAndActivate();
      var secretKey = remoteConfig.getString(Constants.SecretKey);
      var vectorKey = remoteConfig.getString(Constants.VectorKey);
      var appKey = remoteConfig.getString(Constants.AppKey);

      var eventRegistrationCount =
          remoteConfig.getString(Constants.EventRegistrationCount);
//      print("Remote Config Version  Code0-------->" + versionCode);
      SPUtil.putString(Constants.SecretKey, secretKey);
      SPUtil.putString(Constants.VectorKey, vectorKey);
      SPUtil.putString(Constants.AppKey, appKey);
      SPUtil.putString(
          Constants.EventRegistrationCount, eventRegistrationCount);

      AESCrypt().configure(secretKey, vectorKey);
      GMAPIService().configAPI();

      Meta metaCountry = await Utils().getOfflineData(TableDetails.CID_COUNTRY);

      if (await GMUtils().isInternetConnected()) {
        double speed =
            await GMAPIService().getNetSpeed(URLUtils().getNetSpeedUrl());
        if (speed <= 500) {
          SPUtil.putInt(Constants.INTERNET_SPEED, Constants.NET_SPEED_LOW);
        } else {
          SPUtil.putInt(Constants.INTERNET_SPEED, Constants.NET_SPEED_HIGH);
        }

        if (metaCountry.statusCode != 200) {
          meta = await Future.wait([getCountryList()]);
        } else if (metaCountry.statusCode == 200 &&
            SPUtil.getString(Constants.SaveDate)
                    .compareTo(SlcDateUtils().getTodayDateDefaultFormat()) !=
                0) {
          meta = await Future.wait([getCountryList()]);
        }
      }
    } catch (e) {
      print("Firebase Error--> " + e.toString());
    }
    return meta;
  }

  Future<Meta> getCountryList() async {
    GMAPIService gmapiService = GMAPIService();
    return await gmapiService.processGetURL(URLUtils().getCountryListUrl(), "");
  }

  Future<Meta> getNationalityList() async {
    GMAPIService gmapiService = GMAPIService();

    return await gmapiService.processGetURL(
        URLUtils().getNationalityListUrl(), "");
  }

  Future<Meta> getGender() async {
    GMAPIService gmapiService = GMAPIService();

    return await gmapiService.processGetURL(URLUtils().getGenderUrl(), "");
  }

  Future<Meta> getSpeedTestImageUrl() async {
    GMAPIService gmapiService = GMAPIService();

    return await gmapiService.processGetURL(URLUtils().getNetSpeedUrl(), "");
  }
}
