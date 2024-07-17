import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  Customer({required this.customerId, required this.uuid, this.sellerId});

  final String customerId;
  final String uuid;
  final String? sellerId;

  factory Customer.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Customer(
      customerId: data?['customerId'],
      uuid: data?['uuid'],
      sellerId: data?['sellerId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'customerId': customerId,
      'uuid': uuid,
      if (sellerId != null) 'sellerId': sellerId,
    };
  }

  bool isSeller() {
    return sellerId != null;
  }
}
