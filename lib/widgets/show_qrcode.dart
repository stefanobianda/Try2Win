import 'package:flutter/material.dart';
import 'package:try2win/business/app_firestore.dart';
import 'package:try2win/screens/qrcode.dart';

class ShowQRCode extends StatelessWidget {
  const ShowQRCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
          onPressed: () async {
            final customer = await AppFirestore().getCustomer();
            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                builder: (ctx) => QRCodeScreen(customer: customer),
              ),
            );
          },
          child: const Text('Show the QR code'),
        ),
      ],
    );
  }
}
