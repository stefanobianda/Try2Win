import 'package:cloud_firestore/cloud_firestore.dart';

class Quota {
  Quota({
    required this.quota,
    required this.renumeration,
    required this.value,
    required this.createdAt,
  });

  final int quota;
  final int renumeration;
  final int value;
  final Timestamp createdAt;

  factory Quota.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Quota(
      quota: data?['quota'],
      renumeration: data?['renumeration'],
      value: data?['value'],
      createdAt: data?['createdAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "quota": quota,
      "renumeration": renumeration,
      "value": value,
      "createdAt": createdAt,
    };
  }
}
