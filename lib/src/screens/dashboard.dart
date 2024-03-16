import 'package:finance/src/helper/analytics_helper.dart';
import 'package:finance/src/helper/storage_helper.dart';
import 'package:finance/src/helper/theme_manager.dart';
import 'package:finance/src/screens/calculation.dart';
import 'package:finance/src/screens/settings/settings.dart';
import 'package:finance/src/utils/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isDarkTheme = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    getThemeDetails(true);
    addScreenViewTracking("Dashboard", widget.runtimeType.toString());
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      debugPrint('FCM Token: $token');
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(message.toString());
      _showNotification(message);
    });
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
      body: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        Constants.categoryList[index].subCategories.length,
                    itemBuilder: (subCategoriesContext, subCategoriesIndex) {
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
                          addAnalyticsLogger(
                            Constants.firebaseEventKey,
                            {
                              "name": Constants.firebasePageEventKey,
                              "value": Constants.categoryList[index]
                                  .subCategories[subCategoriesIndex].name
                            },
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Calculation(
                                subCategories: Constants.categoryList[index]
                                    .subCategories[subCategoriesIndex],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
