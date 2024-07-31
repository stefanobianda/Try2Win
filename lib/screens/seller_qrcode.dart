import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:try2win/business/configuration.dart';
import 'package:try2win/models/customer.dart';
import 'package:try2win/widgets/app_decoration.dart';

enum Type { seller, customer }

class SellerQRCodeScreen extends StatefulWidget {
  const SellerQRCodeScreen({super.key, required this.customer});

  final Customer customer;

  @override
  State<SellerQRCodeScreen> createState() => _SellerQRCodeScreenState();
}

class _SellerQRCodeScreenState extends State<SellerQRCodeScreen> {
  Type selectedType = Type.seller;

  @override
  Widget build(BuildContext context) {
    var qrcode = '${Configuration.SELLER_CODE}=${widget.customer.sellerId}';
    String text = 'Seller QR code';
    if (selectedType == Type.customer) {
      qrcode = '${Configuration.CUSTOMER_CODE}=${widget.customer.customerId}';
      text = 'Customer QR code';
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your QR codes"),
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
              Text(text),
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
                height: 32,
              ),
              SegmentedButton<Type>(
                segments: const <ButtonSegment<Type>>[
                  ButtonSegment<Type>(
                      value: Type.seller, label: Text('Seller')),
                  ButtonSegment<Type>(
                      value: Type.customer, label: Text('Customer')),
                ],
                onSelectionChanged: (Set<Type> newSelection) {
                  setState(() {
                    // By default there is only a single segment that can be
                    // selected at one time, so its value is always the first
                    // item in the selected set.
                    selectedType = newSelection.first;
                  });
                },
                selected: <Type>{selectedType},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
