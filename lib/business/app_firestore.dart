import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:try2win/business/campaign_bo.dart';
import 'package:try2win/business/coupon_bo.dart';
import 'package:try2win/models/campaign.dart';
import 'package:try2win/models/coupon.dart';
import 'package:try2win/models/purchase.dart';
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
    final supplierRef =
        db.collection('suppliers').doc(supplierId).withConverter(
              fromFirestore: Supplier.fromFirestore,
              toFirestore: (Supplier supplier, _) => supplier.toFirestore(),
            );
    if (supplierMap.containsKey(supplierId)) {
      return supplierMap[supplierId]!;
    }
    final docSnap = await supplierRef.get();
    var supplier = docSnap.data();
    supplier ??= Supplier(title: 'Not Found');
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
    for (var item in docSnap.docs) {
      final coupon = item.data();
      coupon.couponId = item.id;
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

  Future<List<CampaignBO>> getUserCampaign() async {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    final purchasesRef = db
        .collection('purchases')
        .where('userId', isEqualTo: authenticatedUser.uid)
        .withConverter(
          fromFirestore: Purchase.fromFirestore,
          toFirestore: (Purchase purchase, _) => purchase.toFirestore(),
        );
    List<CampaignBO> readCampaigns = [];
    final docSnap = await purchasesRef.get();
    for (var item in docSnap.docs) {
      final purchase = item.data();
      CampaignBO campaignBO = CampaignBO(
        purchase: purchase,
        supplier: await AppFirestore().getSupplier(
          purchase.supplierId,
        ),
        campaign: await AppFirestore().getCampaign(
          purchase.supplierId,
          purchase.campaignId,
        ),
      );
      readCampaigns.add(campaignBO);
    }
    return readCampaigns;
  }
}
