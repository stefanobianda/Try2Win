import 'package:flutter/material.dart';
import 'package:try2win/widgets/app_decoration.dart';
import 'package:try2win/widgets/customer_qrcode.dart';
import 'package:try2win/widgets/read_qrcode.dart';

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
            SizedBox(
              height: 32,
            ),
            CustomerQRCode(),
            SizedBox(
              height: 20,
            ),
            ReadQRCode(
              isSeller: false,
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
  }
}
