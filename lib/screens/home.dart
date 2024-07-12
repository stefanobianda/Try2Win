import 'package:flutter/material.dart';
import 'package:try2win/widgets/app_decoration.dart';
import 'package:try2win/widgets/show_qrcode.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: AppDecoration.build(context),
        child: const Column(
          children: [
            Text("Home Screen"),
            SizedBox(
              height: 20,
            ),
            ShowQRCode(),
          ],
        ),
      ),
    );
  }
}
