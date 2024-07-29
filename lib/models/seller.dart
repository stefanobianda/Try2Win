import 'package:cloud_firestore/cloud_firestore.dart';

class Seller {
  Seller(
      {required this.title,
      this.isProcessing = false,
      required this.ticketLimit});

  final String title;
  final int ticketLimit;
  bool isProcessing;

  factory Seller.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Seller(
      title: data?['name'],
      ticketLimit: data?['ticketLimit'],
      isProcessing: data?['isProcessing'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": title,
      "ticketLimit": ticketLimit,
      "isProcessing": isProcessing,
    };
  }

  bool isProcessingCampaign() {
    return isProcessing;
  }
}
