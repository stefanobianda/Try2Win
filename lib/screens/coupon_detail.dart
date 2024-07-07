import 'package:flutter/material.dart';
import 'package:try2win/models/coupon_bo.dart';

class CouponDetailScreen extends StatelessWidget {
  const CouponDetailScreen({super.key, required this.couponBO});

  final CouponBO couponBO;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coupon Detail"),
      ),
      body: const Text("Coupon Detail Screen"),
    );
  }
}
