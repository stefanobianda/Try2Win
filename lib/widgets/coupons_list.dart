import 'package:flutter/material.dart';
import 'package:try2win/business/coupon_bo.dart';
import 'package:try2win/screens/coupon_detail.dart';

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
            title: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: couponsList[index].coupon.used == true
                    ? Theme.of(ctx).colorScheme.secondary.withOpacity(0.5)
                    : Theme.of(ctx).colorScheme.primary.withOpacity(0.5),
              ),
              margin: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Text(couponsList[index].supplier.title),
                  Text(couponsList[index].campaign.name),
                  if (couponsList[index].coupon.used == true)
                    const Text('Already used'),
                ],
              ),
            ),
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
