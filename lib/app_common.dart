import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:slc/authentication/authentication.dart';
import 'package:slc/common/loading_indicator.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/view/splash/splash_page.dart';

import 'repo/user_repository.dart';
import 'view/dashboard/dashboard.dart';
import 'view/login/login_page.dart';

class App extends StatelessWidget {
  final UserRepository userRepository;

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  App({Key key, @required this.userRepository}) : super();
  @override
  Widget build(BuildContext context) {
//    var data = EasyLocalizationProvider.of(context).data;
//     Crashlytics.instance.enableInDevMode = true;
//     FirebaseCrashlytics.instance.crash();
    // FlutterError.onError = Crashlytics.instance.recordFlutterError;
    // Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

//    return _App(
//      observer: observer,
//      userRepository: this.userRepository,
//    );
    print("dddddddd" + context.locale.toString());
    return GetMaterialApp(
      localizationsDelegates: context.localizationDelegates,
//          supportedLocales: context.supportedLocales,
      navigatorKey: Get.key,
      theme: ThemeData(primaryColor: ColorData.loginBtnColor),
      supportedLocales: [Locale('en', 'US'), Locale('ar', 'DZ')],
      //key: ValueKey<Locale>(context.locale),
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      navigatorObservers: <NavigatorObserver>[observer],
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            // return HomePage(analytics, observer);
            return Dashboard(
              selectedIndex: 0,
            );
          }
          if (state is AuthenticationUnauthenticated) {
            return new LoginPage(userRepository: userRepository);
          }
          if (state is AuthenticationLoading) {
            return LoadingIndicator();
          }

          // return Dashboard(analytics, observer);
          SPUtil.putBool(Constants.IS_CAROUSEL_RETRY, true);
          SPUtil.putBool(Constants.IS_FACILITY_RETRY, true);
          SPUtil.putBool(Constants.IS_FACILITY_GROUP_RETRY, true);
          return SplashPage(
              userRepository: userRepository,
              analytics: analytics,
              observer: observer);
        },
      ),
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child);
      },
    );
  }
}

//class _App extends StatefulWidget {
//  final FirebaseAnalyticsObserver observer;
//  final UserRepository userRepository;
//
//  _App({this.userRepository, this.observer});
//
//  @override
//  __AppState createState() => __AppState();
//}
//
//class __AppState extends State<_App> {
//  @override
//  initState() {
//    // TODO: implement initState
//    super.initState();
//    print('user id  1-----> ${SPUtil.getInt(Constants.USERID, defValue: 0)}');
//    if (SPUtil.getInt(Constants.USERID, defValue: 0) > 0) {
////    if (Constants.USERID_CHECK > 0) {
//      BlocProvider.of<AuthenticationBloc>(context).add(Authendicated());
//    } else {
//      BlocProvider.of<AuthenticationBloc>(context).add(UnAuthendicated());
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    var data = EasyLocalizationProvider.of(context).data;
//    return EasyLocalizationProvider(
//      data: data,
//      child: MaterialApp(
//        navigatorKey: Get.key,
//        theme: ThemeData(primaryColor: ColorData.loginBtnColor
////          , dividerColor: ColorData.primaryTextColor,
//            ),
//        localizationsDelegates: [
//          GlobalMaterialLocalizations.delegate,
//          GlobalWidgetsLocalizations.delegate,
//          //app-specific localization
//          EasyLocalizationDelegate(locale: data.locale, path: 'resources/langs')
//        ],
//        supportedLocales: [Locale('en', 'US'), Locale('ar', 'DZ')],
//        locale: data.locale,
//        debugShowCheckedModeBanner: false,
//        navigatorObservers: <NavigatorObserver>[widget.observer],
//        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
//          builder: (context, state) {
//            if (state is AuthenticationAuthenticated) {
//              return new Dashboard(
//                selectedIndex: 0,
//              );
//            }
//            if (state is AuthenticationUnauthenticated) {
//              return new LoginPage(userRepository: widget.userRepository);
//            }
//            if (state is AuthenticationLoading) {
//              return LoadingIndicator();
//            }
//
//            // return Dashboard(analytics, observer);
//            SPUtil.putBool(Constants.IS_CAROUSEL_RETRY, true);
//            SPUtil.putBool(Constants.IS_FACILITY_RETRY, true);
//            SPUtil.putBool(Constants.IS_FACILITY_GROUP_RETRY, true);
//            return Container();
////            return SplashPage(
////                userRepository: userRepository,
////                analytics: analytics,
////                observer: observer);
//          },
//        ),
//      ),
//    );
//  }
//}
