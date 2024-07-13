import 'package:cloud_firestore/cloud_firestore.dart';

class Seller {
  Seller({required this.title});

  final String title;

  factory Seller.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Seller(
      title: data?['name'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": title,
    };
  }
}
