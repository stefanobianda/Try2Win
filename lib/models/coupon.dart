import 'package:cloud_firestore/cloud_firestore.dart';

class Coupon {
  Coupon(
      {this.couponId,
      required this.sellerId,
      required this.customerId,
      required this.campaignId,
      required this.value,
      required this.issuedAt,
      this.usedAt,
      required this.used});

  String? couponId;
  final String sellerId;
  final String customerId;
  final String campaignId;
  final double value;
  final Timestamp issuedAt;
  Timestamp? usedAt;
  bool used = false;

  factory Coupon.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Coupon(
      // couponId: data?['couponId'],
      sellerId: data?['sellerId'],
      customerId: data?['customerId'],
      campaignId: data?['campaignId'],
      value: (data?['value']).toDouble(),
      issuedAt: data?['issuedAt'],
      usedAt: data?['usedAt'],
      used: data?['used'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      // "couponId": couponId,
      "sellerId": sellerId,
      "customerId": customerId,
      "campaignId": campaignId,
      "value": value,
      "issuedAt": issuedAt,
      if (usedAt != null) "usedAt": usedAt,
      "used": used,
    };
  }
}
