import 'package:cloud_firestore/cloud_firestore.dart';

class Supplier {
  Supplier({required this.title});

  final String title;

  factory Supplier.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Supplier(
      title: data?['name'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": title,
    };
  }
}
