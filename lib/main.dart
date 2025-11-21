// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';

import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
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
