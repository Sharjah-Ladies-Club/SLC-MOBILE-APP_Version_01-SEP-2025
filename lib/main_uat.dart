import 'dart:io';

import 'package:bloc/bloc.dart' as prefix0;
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/app_common.dart';
import 'package:slc/authentication/authentication_bloc.dart';
import 'package:slc/repo/splash_repository.dart';
import 'package:slc/repo/user_repository.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/slc_analytics.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'flavor.dart';
import 'gmcore/storage/SPUtils.dart';

class SimpleBlocDelegate extends prefix0.BlocObserver {
  final SlcAnalytics slcAnalytics;

  final FirebaseAnalytics analytics;

  SimpleBlocDelegate({this.analytics, this.slcAnalytics});

  @override
  void onEvent(prefix0.Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    // print(event);
    // slcAnalytics.sendAnalyticsEvent(analytics, event.toString());
  }

  void prefix0onTransition(prefix0.Bloc bloc, prefix0.Transition transition) {
    super.onTransition(bloc, transition);
    // print(transition);
  }

  // @protected
  // @mustCallSuper
  // void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
  //   super.onError(bloc, error, stackTrace);
  // }
  void prefix0onError(prefix0.Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    // print(error);
  }
}

Future<void> main() async {
  // print("=====> main() called");
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  final SlcAnalytics slcAnalytics = SlcAnalytics();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  slcAnalytics.setAppOpened(analytics);
  if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  prefix0.Bloc.observer =
      SimpleBlocDelegate(analytics: analytics, slcAnalytics: slcAnalytics);
  final userRepository = UserRepository();
  final splashRepository = SplashRepository();
//  const platform = const MethodChannel("app_data");
//  AppInfo appInfoValue;
//  print("=====> calling run");
//  try {
//    Injector.configure(Flavor.RELEASE);
//    await SPUtil.getInstance();
//    var appBaseInfo =
//        await platform.invokeMethod('getBaseData', {"checkVersion": true});
//    appInfoValue = AppInfo.fromJson(jsonDecode(appBaseInfo));
////    await Future.delayed(Duration(milliseconds: 500));
//    print('=====> appBaseInfo----> ${jsonEncode(appInfoValue)}');
//  } on PlatformException catch (e) {
//    print('e----> ${e.toString()}');
//  } on Exception catch (e1) {
//    print('e1----> ${e1.toString()}');
//  }
//
//  PackageInfo packageInfo = await PackageInfo.fromPlatform();
//  String buildNumber = packageInfo.buildNumber;

//  runApp(
//    BlocProvider<AuthenticationBloc>(
//      create: (context) {
//        return AuthenticationBloc(
//            userRepository: userRepository, splashRepository: splashRepository);
////          ..add(AppStarted());
//      },
//      child: EasyLocalization(
//        child: appInfoValue.appVersionNum > int.parse(buildNumber)
//            ? Container()
//            : App(
//                userRepository: userRepository,
//              ),
//      ),
//    ),
//  );

  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(
            userRepository: userRepository, splashRepository: splashRepository);
//          ..add(AppStarted());
      },
      child: EasyLocalization(
        child: App(userRepository: userRepository),
        path: 'resources/langs',
        supportedLocales: [Locale('en', 'US'), Locale('ar', 'DZ')],
        fallbackLocale: Locale('en', 'US'),
      ),
    ),
  );
//  print("=====> called run");
//  SPUtil.putBool(Constants.CHECK_APP_UPDATE, false);
//
//  if (appInfoValue.netSpeed <= 500) {
//    SPUtil.putInt(Constants.INTERNET_SPEED, Constants.NET_SPEED_LOW);
//  } else {
//    SPUtil.putInt(Constants.INTERNET_SPEED, Constants.NET_SPEED_HIGH);
//  }
//
//  SPUtil.putString(Constants.SecretKey, appInfoValue.secretKey);
//  SPUtil.putString(Constants.VectorKey, appInfoValue.vectorKey);
//  SPUtil.putString(Constants.AppKey, appInfoValue.appKey);
//  SPUtil.putString(Constants.EventRegistrationCount,
//      appInfoValue.eventRegistrationCount.toString());
//  await FirebaseMessaging().getToken().then((token) async {
//    SPUtil.putString(Constants.FCM_TOKEN, token);
//  });
//  AESCrypt().configure(appInfoValue.secretKey, appInfoValue.vectorKey);
//  GMAPIService().configAPI();
//
//  await GeneralRepo().getOnlineCountryList();
//
//  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
//
//  firebaseMessaging.requestNotificationPermissions();

  Injector.configure(Flavor.RELEASE);
  await SPUtil.getInstance();
  SPUtil.putBool(Constants.CHECK_APP_UPDATE, true);
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // requestNotificationPermissions();
  firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);
}
