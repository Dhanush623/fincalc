import 'package:finance/src/helper/platform_helper.dart';
import 'package:finance/src/utils/constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

addAnalyticsLogger(String event, Map<String, Object?> parameters) async {
  parameters[Constants.platform] = getCurrentPlatform();
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
      Constants.platform: getCurrentPlatform(),
    },
  );
}

addScreenViewLog(String screenName, String screenClass) async {
  await FirebaseAnalytics.instance.logScreenView(
    screenName: screenName,
    screenClass: screenClass,
    parameters: {
      Constants.platform: getCurrentPlatform(),
    },
  );
}

logAppOpen() async {
  await FirebaseAnalytics.instance.logAppOpen();
}
