import 'package:flutter/material.dart';
import 'package:try2win/models/configuration.dart';
import 'package:try2win/themes/app_theme.dart';
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
            Dummy(),
          ],
        ),
      ),
    );
  }
}

class Dummy extends StatelessWidget {
  const Dummy({super.key});

  @override
  Widget build(BuildContext context) {
    const result =
        'CODE001=regfregergwergw;;;CODE002=fvfdsnvjnslkjntour;;;CODE003=dsjfnlsdjkfnlfdjvns';
    final split = result.split(';;;');
    String? userIdFromBarcode;
    String? supplierIdFromBarcode;
    String? campaignIdFromBarcode;
    for (String code in split) {
      if (code.startsWith(Configuration.USER_CODE)) {
        userIdFromBarcode = code.substring(Configuration.USER_CODE.length + 1);
      } else if (code.startsWith(Configuration.SUPPLIER_CODE)) {
        supplierIdFromBarcode =
            code.substring(Configuration.SUPPLIER_CODE.length + 1);
      } else if (code.startsWith(Configuration.CAMPAIGN_CODE)) {
        campaignIdFromBarcode =
            code.substring(Configuration.CAMPAIGN_CODE.length + 1);
      }
    }
    return Column(
      children: [
        Text('user: $userIdFromBarcode'),
        Text('supplier: $supplierIdFromBarcode'),
        Text('campaign: $campaignIdFromBarcode'),
      ],
    );
  }
}
