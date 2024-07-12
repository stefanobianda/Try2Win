import 'package:flutter/material.dart';
import 'package:try2win/themes/app_theme.dart';

class AppDecoration {
  static BoxDecoration build(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          kTicinoRed,
          kTicinoBlue,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}
