import 'package:finance/src/utils/constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

addAnalyticsLogger(String event, Map<String, Object?> parameters) async {
  await FirebaseAnalytics.instance.logEvent(
    name: event,
    parameters: parameters,
  );
}

addScreenViewTracking(String screenName, String screenClass) async {
  addScreenViewLog(screenName, screenClass);
  await FirebaseAnalytics.instance.logEvent(
    name: Constants.firebaseScreenViewKey,
    parameters: {
      'firebase_screen': screenName,
      'firebase_screen_class': screenClass,
    },
  );
}

addScreenViewLog(String screenName, String screenClass) async {
  await FirebaseAnalytics.instance.logScreenView(
    screenName: screenName,
    screenClass: screenClass,
  );
}

logAppOpen() async {
  await FirebaseAnalytics.instance.logAppOpen();
}
