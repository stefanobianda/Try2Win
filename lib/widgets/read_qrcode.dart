import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:try2win/business/app_firestore.dart';
import 'package:try2win/business/configuration.dart';
import 'package:try2win/models/customer.dart';
import 'package:try2win/providers/customer_notifier.dart';
import 'package:try2win/qrcode/qrcode_scanner.dart';

class ReadQRCode extends ConsumerStatefulWidget {
  final bool isSeller;

  const ReadQRCode({super.key, required this.isSeller});

  @override
  ConsumerState<ReadQRCode> createState() {
    return _ReadQRCodeState();
  }
}

class _ReadQRCodeState extends ConsumerState<ReadQRCode> {
  Customer? customer;

  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

  bool _isProcessing = false;

  String _result = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> setResult(String result) async {
    setState(() {
      _result = result;
    });
    await _processQRCode();
  }

  @override
  Widget build(BuildContext context) {
    customer = ref.read(customerProvider);

    Widget currentWidget = ElevatedButton(
      onPressed: _readQRCode,
      child: const Text('Read QR code'),
    );

    if (widget.isSeller) {
      currentWidget = GestureDetector(
        onTap: _readQRCode,
        child: Image.asset(
          'assets/images/readbarcode.gif',
          width: 300,
          height: 300,
        ),
      );
    }

    return Column(
      children: [
        currentWidget,
        if (_isProcessing)
          const SizedBox(
            height: 12,
          ),
        if (_isProcessing) const CircularProgressIndicator(),
      ],
    );
  }

  void _readQRCode() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            QrCodeScanner(controller: controller, setResult: setResult),
      ),
    );
  }

  Future<void> _processQRCode() async {
    setState(() {
      _isProcessing = true;
    });
    final split = _result.split(';;;');
    String feedback = '';
    String? readCustomerId;
    String? readSellerId;
    String? readCampaignId;
    String? readCouponId;
    for (String code in split) {
      if (code.startsWith(Configuration.CUSTOMER_CODE)) {
        readCustomerId = code.substring(Configuration.CUSTOMER_CODE.length + 1);
      } else if (code.startsWith(Configuration.SELLER_CODE)) {
        readSellerId = code.substring(Configuration.SELLER_CODE.length + 1);
      } else if (code.startsWith(Configuration.CAMPAIGN_CODE)) {
        readCampaignId = code.substring(Configuration.CAMPAIGN_CODE.length + 1);
      } else if (code.startsWith(Configuration.COUPONS_CODE)) {
        readCouponId = code.substring(Configuration.COUPONS_CODE.length + 1);
      }
    }
    if (readCouponId != null) {
      if (customer!.isSeller()) {
        if (readSellerId != null &&
            readCampaignId != null &&
            readCustomerId != null) {
          if (customer!.sellerId == readSellerId) {
            AppFirestore().processCoupon(
                readCustomerId, readCouponId, readSellerId, readCampaignId);
          } else {
            feedback = 'You are not the owner of this coupon!';
          }
        } else {
          feedback = 'Something is missing from QR code!';
        }
      } else {
        feedback = 'You are not allowed to process this QR code!';
      }
    } else if (readSellerId != null) {
      if (customer!.isSeller()) {
        //_processTicket(customer!.customerId, readSellerId);
        feedback =
            'You are a seller and you read a seller QR code, please decide your role';
      } else {
        AppFirestore().processTicket(customer!.customerId, readSellerId);
      }
    } else if (readCustomerId != null) {
      if (customer!.isSeller()) {
        AppFirestore().processTicket(readCustomerId, customer!.sellerId);
      } else {
        feedback = 'You cannot process this QR code!';
      }
    } else {
      feedback = 'The QR code is not valid!';
    }

    setState(() {
      _isProcessing = false;
      _result = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: feedback.isEmpty ? 2 : 5),
        content: Text(feedback.isEmpty ? 'Registration OK' : feedback),
      ),
    );
  }
}
