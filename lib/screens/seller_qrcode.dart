import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:try2win/business/configuration.dart';
import 'package:try2win/models/customer.dart';
import 'package:try2win/widgets/app_decoration.dart';

class SellerQRCodeScreen extends StatelessWidget {
  const SellerQRCodeScreen({super.key, required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seller QR code"),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: AppDecoration.build(context),
          child: Column(
            children: [
              const Text('Seller QR code'),
              const SizedBox(
                height: 10,
              ),
              QrImageView(
                data: '${Configuration.SELLER_CODE}=${customer.sellerId}',
                version: QrVersions.auto,
                size: 300,
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
