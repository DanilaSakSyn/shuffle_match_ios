import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuffle_match/firebase_options.dart';
import 'core/services/sdk_initializer.dart';
import 'core/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if (DateTime.now().isBefore(DateTime(2025, 11, 24))) {
  //   runApp(ClearApp());
  //   return;
  // }
  initTrackingAppTransparency();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SdkInitializer.prefs = await SharedPreferences.getInstance();
  await SdkInitializer.loadRuntimeStorageToDevice();
  var isFirstStart = !SdkInitializer.hasValue("isFirstStart");
  var isOrganic = SdkInitializer.getValue("Organic");
  print('add af2 $isFirstStart $isOrganic');
  if (isFirstStart) SdkInitializer.initAppsFlyer();
  FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  runApp(const App());
}

void _onMessageOpenedApp(RemoteMessage message) {
  print('2 Notification caused the app to open: ${message.data.toString()}');
  SdkInitializer.pushURL = message.data['url'];
  // TODO: Add navigation or specific handling based on message data
}

Future<void> initTrackingAppTransparency() async {
  try {
    final TrackingStatus status =
        await AppTrackingTransparency.requestTrackingAuthorization();
    print('App Tracking Transparency status: $status');
    int timeout = 0;
    while (status == TrackingStatus.notDetermined && timeout < 10) {
      final TrackingStatus newStatus =
          await AppTrackingTransparency.requestTrackingAuthorization();
      await Future.delayed(const Duration(milliseconds: 200));
      timeout++;
    }
  } catch (e) {
    print('Error requesting App Tracking Transparency authorization: $e');
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFFFF8A38),
        primaryContrastingColor: Color(0xFF0C0F16),
        scaffoldBackgroundColor: Color(0xFF3B0A21),
        barBackgroundColor: Color(0xFF121621),
        textTheme: CupertinoTextThemeData(
          primaryColor: Color(0xFFF7F7F7),
          navTitleTextStyle: TextStyle(
            color: Color(0xFFF7F7F7),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          tabLabelTextStyle: TextStyle(
            color: Color(0xCCF7F7F7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
