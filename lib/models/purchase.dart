import 'package:cloud_firestore/cloud_firestore.dart';

class Purchase {
  Purchase(
      {this.purchaseId,
      required this.userId,
      required this.supplierId,
      required this.campaignId,
      required this.createdAt});

  final String? purchaseId;
  final String userId;
  final String supplierId;
  final String campaignId;
  final Timestamp createdAt;

  factory Purchase.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Purchase(
      userId: data?['userId'],
      supplierId: data?['supplierId'],
      campaignId: data?['campaignId'],
      createdAt: data?['createdAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "userId": userId,
      "supplierId": supplierId,
      "campaignId": campaignId,
      "createdAt": createdAt,
    };
  }
}
