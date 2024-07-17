import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:try2win/business/app_firestore.dart';
import 'package:try2win/business/configuration.dart';
import 'package:try2win/models/customer.dart';
import 'package:try2win/qrcode/qrcode_scanner.dart';
import 'package:try2win/widgets/app_decoration.dart';

class QRCodeScreen extends StatefulWidget {
  final Customer customer;

  const QRCodeScreen({super.key, required this.customer});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  final db = FirebaseFirestore.instance;

  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String _result = '';
  bool _isProcessing = false;
  bool _isShowingSeller = false;

  Future<void> setResult(String result) async {
    setState(() {
      _result = result;
    });
    _registerTicket();
  }

  void _readQRCode() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            QrCodeScanner(controller: controller, setResult: setResult),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String qrcode =
        '${Configuration.CUSTOMER_CODE}=${widget.customer.customerId}';
    String? qrcodeSeller;
    if (widget.customer.isSeller()) {
      qrcodeSeller = '${Configuration.SELLER_CODE}=${widget.customer.sellerId}';
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Your QR code'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: AppDecoration.build(context),
        child: Column(
          children: [
            Text(_isShowingSeller ? 'Seller QRCode' : 'Customer QRCode'),
            if (qrcodeSeller != null)
              const SizedBox(
                height: 16,
              ),
            if (qrcodeSeller != null)
              ElevatedButton(
                onPressed: _changeQRCode,
                child: Text(_isShowingSeller
                    ? 'Shows customer QRCode'
                    : 'Shows seller QRCode'),
              ),
            const SizedBox(
              height: 16,
            ),
            if (!_isShowingSeller)
              QrImageView(
                data: qrcode,
                version: QrVersions.auto,
                size: 300,
                backgroundColor: Colors.white,
              ),
            if (_isShowingSeller)
              QrImageView(
                data: qrcodeSeller!,
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

  Future<void> _registerTicket() async {
    setState(() {
      _isProcessing = true;
    });
    final customer = await AppFirestore().getCustomer();
    final split = _result.split(';;;');
    String customerId = customer.customerId;
    String? sellerId;
    for (String code in split) {
      if (code.startsWith(Configuration.CUSTOMER_CODE)) {
        customerId = code.substring(Configuration.CUSTOMER_CODE.length + 1);
        if (customer.isSeller()) {
          sellerId = customer.sellerId;
        }
      } else if (code.startsWith(Configuration.SELLER_CODE)) {
        sellerId = code.substring(Configuration.SELLER_CODE.length + 1);
      }
    }
    if (sellerId != null) {
      db.collection('tickets').add({
        'customerId': customerId,
        'sellerId': sellerId,
        'createdAt': Timestamp.now(),
      });
    }

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
      _result = '';
    });
  }

  void _changeQRCode() {
    setState(() {
      _isShowingSeller = !_isShowingSeller;
    });
  }
}
