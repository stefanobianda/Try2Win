import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:try2win/business/coupon_bo.dart';
import 'package:try2win/widgets/app_decoration.dart';

class CouponDetailScreen extends StatelessWidget {
  const CouponDetailScreen({super.key, required this.couponBO});

  final CouponBO couponBO;

  @override
  Widget build(BuildContext context) {
    var date = DateFormat("EEE, d MMM yyyy HH:mm:ss")
        .format(couponBO.coupon.issuedAt.toDate());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coupon Detail"),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: AppDecoration.build(context),
          child: Column(
            children: [
              Text('Coupon from ${couponBO.supplier.title}'),
              const SizedBox(
                height: 10,
              ),
              Text('Campaign name ${couponBO.campaign.name}'),
              const SizedBox(
                height: 10,
              ),
              Text('Issued at $date'),
              const SizedBox(
                height: 30,
              ),
              if (!couponBO.coupon.used)
                QrImageView(
                  data: couponBO.getQRCode(),
                  version: QrVersions.auto,
                  size: 300,
                  backgroundColor: Colors.white,
                ),
              if (couponBO.coupon.used)
                const Text(
                  'Coupon already used!',
                  style: TextStyle(fontSize: 32),
                )
            ],
          ),
        ),
      ),
    );
  }
}
