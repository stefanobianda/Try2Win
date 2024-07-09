import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:try2win/themes/app_theme.dart';

class DisplayQRCode extends StatelessWidget {
  const DisplayQRCode({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Your QR code'),
      ),
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
        child: Column(
          children: [
            const Text('QRCode'),
            const SizedBox(
              height: 16,
            ),
            QrImageView(
              data: authenticatedUser.uid,
              version: QrVersions.auto,
              size: 300,
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
