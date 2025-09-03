import 'package:firebase_analytics/firebase_analytics.dart';

class SlcAnalytics {
  Future<void> sendAnalyticsEvent(
    FirebaseAnalytics analytics,
    String event,
  ) async {
    await analytics.logEvent(
      name: event,
//      parameters: <String, dynamic>{
//        'string': 'string',
//        'int': 42,
//        'long': 12345678910,
//        'double': 42.0,
//        'bool': true,
//      },
    );
  }

  Future<void> setAppOpened(FirebaseAnalytics analytics) async {
    await analytics.logAppOpen();
  }

  Future<void> setUserId(FirebaseAnalytics analytics) async {
    await analytics.setUserId();
    // await analytics.setUserId(SPUtil.getInt(Constants.USERID).toString());
  }

  Future<void> testSetCurrentScreen(FirebaseAnalytics analytics) async {
    // await analytics.setCurrentScreen(
    //   screenName: 'Analytics Demo',
    //   screenClassOverride: 'AnalyticsDemo',
    // );
  }

  Future<void> setAnalyticsCollectionEnabled(
      FirebaseAnalytics analytics) async {
    await analytics.setAnalyticsCollectionEnabled(false);
    await analytics.setAnalyticsCollectionEnabled(true);
  }

  Future<void> testSetSessionTimeoutDuration(
      FirebaseAnalytics analytics) async {
    await analytics.android?.setSessionTimeoutDuration(2000000);
  }

  Future<void> testSetUserProperty(FirebaseAnalytics analytics) async {
    await analytics.setUserProperty(name: 'regular', value: 'indeed');
  }
}
