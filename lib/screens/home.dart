import 'package:flutter/material.dart';
import 'package:try2win/themes/app_theme.dart';
import 'package:try2win/widgets/read_qrcode.dart';
import 'package:try2win/widgets/show_qrcode.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kTicinoRed,
              kTicinoBlue,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Column(
          children: [
            Text("Home Screen"),
            SizedBox(
              height: 20,
            ),
            ShowQRCode(),
            SizedBox(
              height: 20,
            ),
            ReadQRCode(),
          ],
        ),
      ),
    );
  }
}
