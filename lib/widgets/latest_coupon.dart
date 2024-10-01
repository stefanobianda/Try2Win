import 'package:flutter/material.dart';
import 'package:try2win/business/app_firestore.dart';
import 'package:try2win/business/coupon_bo.dart';
import 'package:try2win/widgets/container_coupon.dart';

class LatestCoupon extends StatelessWidget {
  const LatestCoupon({super.key});

  Future<CouponBO> _latestCoupon() {
    return AppFirestore().getLatestCoupon();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _latestCoupon(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          CouponBO? coupon = snapshot.data;
          if (coupon == null) {
            return const Text("null latest Coupon");
          } else {
            return ContainerCoupon(
              coupon: coupon,
            );
          }
        } else {
          return const Text("no latest Coupon");
        }
      },
    );
  }
}
