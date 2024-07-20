import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/business/app_firestore.dart';
import 'package:try2win/business/coupon_bo.dart';
import 'package:try2win/providers/customer_notifier.dart';
import 'package:try2win/widgets/app_decoration.dart';
import 'package:try2win/widgets/coupons_list.dart';

class CouponsScreen extends ConsumerStatefulWidget {
  const CouponsScreen({super.key});

  @override
  ConsumerState<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends ConsumerState<CouponsScreen> {
  List<CouponBO> userCoupons = [];

  final db = FirebaseFirestore.instance;
  var _isLoaded = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      _getCoupons();
      _isLoaded = true;
    }
    Widget current =
        const Text('Go to a resturant and get the chance to win a coupons!');
    if (userCoupons.isNotEmpty) {
      current = CouponsList(couponsList: userCoupons);
    }
    if (_isLoading) {
      current = const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: AppDecoration.build(context),
      child: current,
    );
  }

  void _getCoupons() async {
    setState(() {
      _isLoading = true;
    });

    final customer = ref.read(customerProvider.notifier).getCustomer();

    List<CouponBO> readCoupons = await AppFirestore().getCoupons(customer);

    setState(() {
      userCoupons = readCoupons.toList();
      _isLoading = false;
    });
  }
}
