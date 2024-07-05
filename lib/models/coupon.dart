import 'package:cloud_firestore/cloud_firestore.dart';

class Coupon {
  const Coupon(this.couponId, this.userId, this.customerId, this.campaignId,
      this.value, this.issuedAt);

  final String couponId;
  final String userId;
  final String customerId;
  final String campaignId;
  final double value;
  final Timestamp issuedAt;
}
