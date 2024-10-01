import 'package:flutter/material.dart';
import 'package:try2win/widgets/app_decoration.dart';
import 'package:try2win/widgets/customer_qrcode.dart';
import 'package:try2win/widgets/latest_coupon.dart';
import 'package:try2win/widgets/latest_ticket.dart';
import 'package:try2win/widgets/read_qrcode.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: AppDecoration.build(context),
          child: const Column(
            children: [
              SizedBox(
                height: 32,
              ),
              CustomerQRCode(),
              SizedBox(
                height: 20,
              ),
              ReadQRCode(
                isSeller: false,
              ),
              SizedBox(
                height: 48,
              ),
              LatestCoupon(),
              SizedBox(
                height: 16,
              ),
              LatestTicket(),
            ],
          ),
        ),
      ),
    );
  }
}
