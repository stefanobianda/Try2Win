import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/business/app_firestore.dart';
import 'package:try2win/business/coupon_bo.dart';
import 'package:try2win/providers/customer_notifier.dart';
import 'package:try2win/widgets/app_decoration.dart';
import 'package:try2win/widgets/coupons_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CouponsScreen extends ConsumerStatefulWidget {
  const CouponsScreen({super.key});

  @override
  ConsumerState<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends ConsumerState<CouponsScreen> {
  List<CouponBO> userCoupons = [];

  final db = FirebaseFirestore.instance;
  bool _isLoading = false;
  bool all = false;

  @override
  void initState() {
    _getCoupons(all);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget current = Text(AppLocalizations.of(context)!.zeroCoupons);
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('All'),
              Switch(
                value: all,
                onChanged: (bool value) {
                  setState(() {
                    all = value;
                  });
                  _getCoupons(all);
                },
              ),
            ],
          ),
          Expanded(child: current),
        ],
      ),
    );
  }

  void _getCoupons(bool all) async {
    setState(() {
      _isLoading = true;
    });

    final customer = ref.read(customerProvider.notifier).getCustomer();
    List<CouponBO> readCoupons = await AppFirestore().getCoupons(customer, all);

    setState(() {
      userCoupons = readCoupons.toList();
      _isLoading = false;
    });
  }
}
