import 'package:flutter/material.dart';
import 'package:try2win/models/coupon.dart';

class CouponsList extends StatelessWidget {
  const CouponsList({super.key, required this.couponsList});

  final List<Coupon> couponsList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: couponsList.length,
      itemBuilder: (ctx, index) => const ListTile(
        title: Text('title'),
        subtitle: Text('subtitle'),
      ),
    );
  }
}
