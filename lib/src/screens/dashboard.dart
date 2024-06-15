import 'package:finance/src/helper/analytics_helper.dart';
import 'package:finance/src/helper/crashlytics_helper.dart';
import 'package:finance/src/helper/storage_helper.dart';
import 'package:finance/src/helper/theme_manager.dart';
import 'package:finance/src/screens/calculation.dart';
import 'package:finance/src/screens/settings/settings.dart';
import 'package:finance/src/utils/constants.dart';
import 'package:finance/src/widgets/my_banner_ad.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isDarkTheme = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    getThemeDetails(true);
    addScreenViewTracking(Constants.dashboard, widget.runtimeType.toString());
    _firebaseMessaging.requestPermission();
    _requestAndPrintFCMToken();
    _configureFirebaseMessaging();
  }

  Future<void> _requestAndPrintFCMToken() async {
    final String? token = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $token');
  }

  Future<void> _configureFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(message.toString());
      _showNotification(message);
    });
  }

  Future<void> addLog(String name, String value) async {
    addAnalyticsLogger(
      Constants.dashboard,
      {
        "name": name,
        "value": value,
      },
    );
    addCrashlyticsLogger(
      Constants.dashboard,
      {
        "name": name,
        "value": value,
      },
    );
  }

  void _showNotification(RemoteMessage message) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      message.notification?.android?.channelId ?? Constants.channelId,
      Constants.channelName,
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      message.notification?.android?.count ?? DateTime.now().millisecond,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
    );
  }

  getThemeDetails(bool isFirstTime) async {
    String? selectedTheme = await getData(Constants.selectedTheme);
    if (selectedTheme == ThemeMode.dark.name && isFirstTime) {
      // ignore: use_build_context_synchronously
      Provider.of<ThemeManager>(context, listen: false).toggleTheme();
    }
    if (selectedTheme == ThemeMode.dark.name) {
      setState(() {
        isDarkTheme = true;
      });
    } else {
      setState(() {
        isDarkTheme = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: const Text(Constants.finCalc),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Settings(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 0.0,
                bottom: 16.0,
              ),
              itemCount: Constants.categoryList.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    Constants.categoryList[index].name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  shape: const Border(),
                  children: [
                    Card(
                      child: SizedBox(
                        height:
                            Constants.categoryList[index].subCategories.length *
                                56.0,
                        child: ListView.builder(
                          // shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: Constants
                              .categoryList[index].subCategories.length,
                          itemBuilder:
                              (subCategoriesContext, subCategoriesIndex) {
                            return ListTile(
                              title: Text(
                                Constants.categoryList[index]
                                    .subCategories[subCategoriesIndex].name,
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                              ),
                              onTap: () {
                                addLog(
                                  Constants.screen,
                                  Constants.categoryList[index]
                                      .subCategories[subCategoriesIndex].name,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Calculation(
                                      subCategories: Constants
                                          .categoryList[index]
                                          .subCategories[subCategoriesIndex],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            width: AdSize.banner.width.toDouble(),
            height: AdSize.banner.height.toDouble(),
            child: const MyBannerAdWidget(),
          ),
        ],
      ),
    );
  }
}
