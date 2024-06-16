import 'package:flutter/material.dart';
import 'package:try2win/screens/home_page.dart';

final themeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
);
final themeDarkData = ThemeData.dark().copyWith();

void main() {
  runApp(const Try2WinApp());
}

class Try2WinApp extends StatelessWidget {
  const Try2WinApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Try 2 Win',
      theme: themeData,
      darkTheme: themeDarkData,
      home: const HomePageScreen(),
    );
  }
}
