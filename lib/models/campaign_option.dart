import 'package:cloud_firestore/cloud_firestore.dart';

class CampaignOption {
  CampaignOption({
    required this.ticketsNumber,
    required this.renumeration,
    required this.value,
    required this.createdAt,
  });

  final int ticketsNumber;
  final int renumeration;
  final int value;
  final Timestamp createdAt;

  factory CampaignOption.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CampaignOption(
      ticketsNumber: data?['ticketsNumber'],
      renumeration: data?['renumeration'],
      value: data?['value'],
      createdAt: data?['createdAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "ticketsNumber": ticketsNumber,
      "renumeration": renumeration,
      "value": value,
      "createdAt": createdAt,
    };
  }
}
