import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:try2win/business/configuration.dart';
import 'package:try2win/models/customer.dart';
import 'package:try2win/widgets/app_decoration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Type { seller, customer }

class SellerQRCodeScreen extends StatefulWidget {
  const SellerQRCodeScreen({super.key, required this.customer});

  final Customer customer;

  @override
  State<SellerQRCodeScreen> createState() => _SellerQRCodeScreenState();
}

class _SellerQRCodeScreenState extends State<SellerQRCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seller QR codes"),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: AppDecoration.build(context),
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              Text('${AppLocalizations.of(context)!.seller} QR code'),
              const SizedBox(
                height: 16,
              ),
              QrImageView(
                data:
                    '${Configuration.SELLER_CODE}=${widget.customer.sellerId}',
                version: QrVersions.auto,
                size: 300,
                backgroundColor: Colors.white,
              ),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
