import 'package:flutter/material.dart';

Color kTicinoRed = const Color.fromARGB(255, 232, 66, 63);
Color kTicinoBlue = const Color.fromARGB(255, 38, 139, 204);

var kColorScheme = ColorScheme.fromSeed(
  seedColor: kTicinoBlue,
);
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: kTicinoBlue,
);

final themeData = ThemeData(
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: kColorScheme.primaryContainer,
  ),
  useMaterial3: true,
);
final themeDarkData = ThemeData.dark().copyWith(
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: kDarkColorScheme.primaryContainer,
  ),
);

class Theme {}
