import 'package:cloud_firestore/cloud_firestore.dart';

class Campaign {
  Campaign({
    required this.name,
    required this.createdAt,
    required this.campaignId,
  });

  final String name;
  final Timestamp createdAt;
  final String campaignId;

  factory Campaign.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Campaign(
      name: data?['name'],
      createdAt: data?['createdAt'],
      campaignId: data?['campaignId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "createdAt": createdAt,
      "campaignId": campaignId,
    };
  }
}
