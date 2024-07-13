import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  Ticket({
    required this.customerId,
    required this.sellerId,
    required this.createdAt,
  });

  final String customerId;
  final String sellerId;
  final Timestamp createdAt;

  factory Ticket.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Ticket(
      customerId: data?['customerId'],
      sellerId: data?['sellerId'],
      createdAt: data?['createdAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "customerId": customerId,
      "sellerId": sellerId,
      "createdAt": createdAt,
    };
  }
}
