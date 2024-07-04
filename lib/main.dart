import 'package:flutter/material.dart';
import 'package:try2win/screens/login.dart';
import 'package:try2win/screens/tabs.dart';
import 'package:try2win/themes/theme.dart';

void main() {
  runApp(const Try2WinApp());
}

class Try2WinApp extends StatelessWidget {
  const Try2WinApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var isLoggedIn = false;

    Widget current = const LoginScreen();
    if (isLoggedIn) {
      current = const TabsScreen();
    }
    return MaterialApp(
      title: 'Try 2 Win',
      theme: themeData,
      darkTheme: themeDarkData,
      home: current,
    );
  }
}
