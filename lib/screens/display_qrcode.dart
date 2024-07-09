import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:try2win/models/configuration.dart';
import 'package:try2win/qrcode/qrcode_scanner.dart';
import 'package:try2win/themes/app_theme.dart';

class DisplayQRCode extends StatefulWidget {
  const DisplayQRCode({super.key});

  @override
  State<DisplayQRCode> createState() => _DisplayQRCodeState();
}

class _DisplayQRCodeState extends State<DisplayQRCode> {
  final db = FirebaseFirestore.instance;

  String _result = '';
  bool _isProcessing = false;

  Future<void> setResult(String result) async {
    setState(() {
      _result = result;
    });
    _registerPurchase();
  }

  void _readQRCode() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QrCodeScanner(setResult: setResult),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    var qrcode = '${Configuration.USER_CODE}=${authenticatedUser.uid}';

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
              data: qrcode,
              version: QrVersions.auto,
              size: 300,
              backgroundColor: Colors.white,
            ),
            const SizedBox(
              height: 48,
            ),
            ElevatedButton(
              onPressed: _readQRCode,
              child: const Text('Read QR code'),
            ),
            Text(_result),
            if (_isProcessing) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Future<void> _registerPurchase() async {
    setState(() {
      _isProcessing = true;
    });
    final split = _result.split(';;;');
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
    final userId = userIdFromBarcode ?? FirebaseAuth.instance.currentUser!.uid;
    final supplierId = supplierIdFromBarcode ?? 'PmcMh340Kn5n1ong27Kg';
    final campaignId = campaignIdFromBarcode ?? 'KNgaqgkJ26pun7TMHORE';

    db.collection('purchases').add({
      'userId': userId,
      'supplierId': supplierId,
      'campaignId': campaignId,
      'createdAt': Timestamp.now(),
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
      _result = '';
    });
  }
}
