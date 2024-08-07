import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/providers/customer_notifier.dart';
import 'package:try2win/screens/seller_qrcode.dart';
import 'package:try2win/widgets/app_decoration.dart';
import 'package:try2win/widgets/read_qrcode.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SellerHomeScreen extends ConsumerWidget {
  const SellerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.read(customerProvider);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: AppDecoration.build(context),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(AppLocalizations.of(context)!.readQRCode),
            const SizedBox(
              height: 32,
            ),
            const ReadQRCode(),
            const Expanded(
              child: SizedBox(
                height: 16,
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        SellerQRCodeScreen(customer: customer!),
                  ),
                );
              },
              child: const Text('Show your QR codes'),
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
