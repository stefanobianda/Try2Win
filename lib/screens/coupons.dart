import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:try2win/models/coupon.dart';
import 'package:try2win/widgets/coupons_list.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  List<Coupon> userCoupons = [];

  final db = FirebaseFirestore.instance;
  var _isLoaded = false;

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
    return current;
  }

  void _getCoupons() async {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    final couponsRef = db.collection('coupons');
    List<Coupon> readCoupons = [];

    await couponsRef
        .where('userId', isEqualTo: authenticatedUser.uid)
        .get()
        .then((snapshot) {
      print("Running");
      for (var item in snapshot.docs) {
        print('${item.id} => ${item.data()}');
        final data = item.data();
        final coupon = Coupon(
            item.id,
            data['userId'],
            item.data()['customerId'],
            item.data()['campaignId'],
            item.data()['value'].toDouble(),
            item.data()['issuedAt']);
        readCoupons.add(coupon);
        print('A Coupons: ${readCoupons.length}');
      }
    });
    print('B Coupons: ${readCoupons.length}');
    setState(() {
      userCoupons = readCoupons.toList();
    });
  }
}
