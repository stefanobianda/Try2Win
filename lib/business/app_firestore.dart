import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:try2win/business/coupon_bo.dart';
import 'package:try2win/models/campaign.dart';
import 'package:try2win/models/coupon.dart';
import 'package:try2win/models/supplier.dart';

class AppFirestore {
  final db = FirebaseFirestore.instance;

  HashMap<String, Supplier> supplierMap = HashMap<String, Supplier>();

  Future<Campaign> getCampaign(String supplierId, String campaignId) async {
    final campaignRef = db
        .collection('suppliers')
        .doc(supplierId)
        .collection('campaigns')
        .doc(campaignId)
        .withConverter(
          fromFirestore: Campaign.fromFirestore,
          toFirestore: (Campaign campaign, _) => campaign.toFirestore(),
        );
    final docSnap = await campaignRef.get();
    var campaign = docSnap.data();
    campaign ??= Campaign(title: "NotFound");
    return campaign;
  }

  Future<Supplier> getSupplier(String supplierId) async {
    final supplierRef = db.collection('suppliers').doc(supplierId);
    if (supplierMap.containsKey(supplierId)) {
      return supplierMap[supplierId]!;
    }
    Supplier supplier = await supplierRef.get().then(
      (doc) async {
        final data = doc.data();
        return Supplier(data?['name']);
      },
    );
    supplierMap[supplierId] = supplier;
    return supplier;
  }

  Future<List<CouponBO>> getCoupons() async {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    List<CouponBO> readCoupons = [];
    final couponsRef = db
        .collection('coupons')
        .where('userId', isEqualTo: authenticatedUser.uid)
        .where('used', isEqualTo: false)
        .withConverter(
          fromFirestore: Coupon.fromFirestore,
          toFirestore: (Coupon coupon, _) => coupon.toFirestore(),
        );
    final docSnap = await couponsRef.get();
    print('go here');
    for (var item in docSnap.docs) {
      print('go here too');
      final coupon = item.data();
      coupon.couponId = item.id;
      print(coupon.couponId);
      CouponBO couponBO = CouponBO(
        coupon: coupon,
        supplier: await getSupplier(coupon.customerId),
        campaign: await getCampaign(
          coupon.customerId,
          coupon.campaignId,
        ),
      );
      readCoupons.add(couponBO);
    }
    return readCoupons;
  }
}
