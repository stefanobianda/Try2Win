import 'package:flutter/material.dart';
import 'package:try2win/screens/display_qrcode.dart';

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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => const DisplayQRCode(),
              ),
            );
          },
          child: const Text('Show the QR code'),
        ),
      ],
    );
  }
}
