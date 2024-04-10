import 'package:finance/src/helper/analytics_helper.dart';
import 'package:finance/src/helper/crashlytics_helper.dart';
import 'package:finance/src/helper/storage_helper.dart';
import 'package:finance/src/helper/theme_manager.dart';
import 'package:finance/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with WidgetsBindingObserver {
  bool isDarkTheme = false;
  bool isNotification = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _initializeApp() async {
    getThemeDetails();
    getNotificationDetails();
    addScreenViewTracking(Constants.settings, widget.runtimeType.toString());
    addLog(Constants.screen, Constants.settings);
  }

  Future<void> addLog(String name, String value) async {
    addAnalyticsLogger(
      Constants.settings,
      {
        "name": name,
        "value": value,
      },
    );
    addCrashlyticsLogger(
      Constants.settings,
      {
        "name": name,
        "value": value,
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      getNotificationDetails();
    }
  }

  getNotificationDetails() async {
    PermissionStatus status = await Permission.notification.status;
    if (status.isGranted) {
      setState(() {
        isNotification = true;
      });
    } else {
      setState(() {
        isNotification = false;
      });
    }
  }

  changeNotificationPermission() async {
    openAppSettings();
  }

  Future<void> requestNotificationPermission() async {
    await Permission.notification.request();
  }

  getThemeDetails() async {
    String? selectedTheme = await getData(Constants.selectedTheme);
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
        title: const Text(Constants.settings),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        height: 50.0,
        child: Center(
          child: Text(
            "${Constants.copyrightLabel}${DateTime.now().year}",
          ),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text(
              Constants.darkTheme,
              style: TextStyle(fontSize: 18),
            ),
            trailing: Switch(
              value: isDarkTheme,
              onChanged: (bool value) {
                Provider.of<ThemeManager>(context, listen: false).toggleTheme();
                saveData(
                  Constants.selectedTheme,
                  isDarkTheme ? ThemeMode.light.name : ThemeMode.dark.name,
                );
                setState(() {
                  isDarkTheme = !isDarkTheme;
                });
                addLog(Constants.button, "Changing Theme");
              },
            ),
          ),
          ListTile(
            title: const Text(
              Constants.notifications,
              style: TextStyle(fontSize: 18),
            ),
            trailing: Switch(
              value: isNotification,
              onChanged: (bool value) {
                changeNotificationPermission();
                addLog(Constants.button, "Notification changes");
              },
            ),
          ),
        ],
      ),
    );
  }
}
