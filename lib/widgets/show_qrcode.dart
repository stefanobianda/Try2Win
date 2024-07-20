import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/business/app_firestore.dart';
import 'package:try2win/models/customer.dart';
import 'package:try2win/providers/customer_notifier.dart';
import 'package:try2win/screens/qrcode.dart';

class ShowQRCode extends ConsumerStatefulWidget {
  const ShowQRCode({super.key});

  @override
  ConsumerState<ShowQRCode> createState() => _ShowQRCodeState();
}

class _ShowQRCodeState extends ConsumerState<ShowQRCode> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
          onPressed: () async {
            Customer? customer =
                ref.read(customerProvider.notifier).getCustomer();
            if (customer == null) {
              customer = await AppFirestore().getCustomer();
              ref.read(customerProvider.notifier).setCustomer(customer);
            }
            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                builder: (ctx) => QRCodeScreen(customer: customer!),
              ),
            );
          },
          child: const Text('Show the QR code'),
        ),
      ],
    );
  }
}
