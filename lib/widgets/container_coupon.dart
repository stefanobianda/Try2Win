import 'package:flutter/material.dart';
import 'package:try2win/business/coupon_bo.dart';

class ContainerCoupon extends StatelessWidget {
  const ContainerCoupon({super.key, required this.coupon});

  final CouponBO coupon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        color: coupon.coupon.used == true
            ? Theme.of(context).colorScheme.inversePrimary
            : Theme.of(context).colorScheme.primary,
      ),
      margin: const EdgeInsets.all(5),
      height: 150,
      width: 400,
      child: Column(
        children: [
          Text(coupon.supplier.title),
          Text(coupon.campaign.name),
          if (coupon.coupon.used == true) const Text('Already used'),
        ],
      ),
    );
  }
}
