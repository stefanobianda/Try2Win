import 'package:cloud_firestore/cloud_firestore.dart';

class Campaign {
  Campaign({this.title});

  final String? title;

  factory Campaign.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Campaign(
      title: data?['name'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) "name": title,
    };
  }
}
