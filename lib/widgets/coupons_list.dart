import 'package:flutter/material.dart';
import 'package:try2win/business/coupon_bo.dart';
import 'package:try2win/screens/coupon_detail.dart';
import 'package:try2win/widgets/container_coupon.dart';

class CouponsList extends StatelessWidget {
  const CouponsList({super.key, required this.couponsList});

  final List<CouponBO> couponsList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: couponsList.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            title: ContainerCoupon(coupon: couponsList[index]),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) =>
                          CouponDetailScreen(couponBO: couponsList[index])));
            },
          );
        });
  }
}
