import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:try2win/models/campaign.dart';
import 'package:try2win/models/coupon.dart';
import 'package:try2win/models/coupon_bo.dart';
import 'package:try2win/models/supplier.dart';
import 'package:try2win/widgets/app_decoration.dart';
import 'package:try2win/widgets/coupons_list.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
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
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    final couponsRef = db.collection('coupons');
    List<CouponBO> readCoupons = [];

    await couponsRef
        .where('userId', isEqualTo: authenticatedUser.uid)
        .where('used', isEqualTo: false)
        .get()
        .then((snapshot) async {
      for (var item in snapshot.docs) {
        final data = item.data();
        final coupon = Coupon(
            item.id,
            data['userId'],
            item.data()['customerId'],
            item.data()['campaignId'],
            item.data()['value'].toDouble(),
            item.data()['issuedAt']);
        CouponBO couponBO = CouponBO(
          coupon: coupon,
          supplier: await _getSupplier(coupon.customerId),
          campaign: await _getCampaign(
            coupon.customerId,
            coupon.campaignId,
          ),
        );
        readCoupons.add(couponBO);
      }
    });
    setState(() {
      userCoupons = readCoupons.toList();
      _isLoading = false;
    });
  }

  Future<Supplier> _getSupplier(String supplierId) async {
    final supplierRef = db.collection('suppliers').doc(supplierId);
    return await supplierRef.get().then(
      (doc) async {
        final data = doc.data();
        return Supplier(data?['name']);
      },
    );
  }

  Future<Campaign> _getCampaign(String supplierId, String campaignId) async {
    final campaignRef = db
        .collection('suppliers')
        .doc(supplierId)
        .collection('campaigns')
        .doc(campaignId);
    return await campaignRef.get().then(
      (doc) async {
        final data = doc.data();
        return Campaign(data?['name']);
      },
    );
  }
}
