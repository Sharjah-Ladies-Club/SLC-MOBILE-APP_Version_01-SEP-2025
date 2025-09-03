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

class SimpleBlocObserver extends prefix0.BlocObserver {
  final SlcAnalytics slcAnalytics;

  final FirebaseAnalytics analytics;

  SimpleBlocObserver({this.analytics, this.slcAnalytics});

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
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final SlcAnalytics slcAnalytics = SlcAnalytics();
  slcAnalytics.setAppOpened(analytics);
  if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  prefix0.Bloc.observer =
      SimpleBlocObserver(analytics: analytics, slcAnalytics: slcAnalytics);
  final userRepository = UserRepository();
  final splashRepository = SplashRepository();

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

  Injector.configure(Flavor.BETA);
  await SPUtil.getInstance();
  SPUtil.putBool(Constants.CHECK_APP_UPDATE, false);
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // firebaseMessaging.requestNotificationPermissions();
  // print("This is First Linet");
  firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);
}
