import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/providers/customer_notifier.dart';
import 'package:try2win/screens/seller_qrcode.dart';

class SellerQRCode extends ConsumerWidget {
  const SellerQRCode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(customerProvider);
    return Column(
      children: [
        if (customer != null && customer.isSeller())
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SellerQRCodeScreen(customer: customer),
                ),
              );
            },
            child: const Text('Show your seller QR code'),
          ),
      ],
    );
  }
}
