import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:try2win/business/app_firestore.dart';
import 'package:try2win/business/configuration.dart';
import 'package:try2win/models/customer.dart';
import 'package:try2win/providers/customer_notifier.dart';
import 'package:try2win/qrcode/qrcode_scanner.dart';

class CustomerQRCode extends ConsumerStatefulWidget {
  const CustomerQRCode({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CustomerQRCodeState();
  }
}

class _CustomerQRCodeState extends ConsumerState<ConsumerStatefulWidget> {
  final db = FirebaseFirestore.instance;
  late Future<void> _customerFuture;

  Customer? customer;

  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

  bool _isProcessing = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _customerFuture = ref.read(customerProvider.notifier).loadCustomer();
  }

  String _result = '';

  Future<void> setResult(String result) async {
    setState(() {
      _result = result;
    });
    _registerTicket();
  }

  @override
  Widget build(BuildContext context) {
    customer = ref.watch(customerProvider);

    return Column(
      children: [
        FutureBuilder(
          future: _customerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (customer == null) {
              return const Text(
                  'Something is wrong, please Logout and restart!');
            } else {
              return QrImageView(
                data: '${Configuration.CUSTOMER_CODE}=${customer!.customerId}',
                version: QrVersions.auto,
                size: 300,
                backgroundColor: Colors.white,
              );
            }
          },
        ),
        const SizedBox(
          height: 20,
        ),
        if (customer != null)
          ElevatedButton(
            onPressed: _readQRCode,
            child: const Text('Read QR code'),
          ),
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
}
