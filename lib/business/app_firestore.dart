import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:try2win/models/campaign.dart';
import 'package:try2win/models/supplier.dart';

class AppFirestore {
  final db = FirebaseFirestore.instance;

  HashMap<String, Supplier> supplierMap = HashMap<String, Supplier>();

  Future<Campaign> getCampaign(String supplierId, String campaignId) async {
    final campaignRef = db
        .collection('suppliers')
        .doc(supplierId)
        .collection('campaigns')
        .doc(campaignId)
        .withConverter(
          fromFirestore: Campaign.fromFirestore,
          toFirestore: (Campaign campaign, _) => campaign.toFirestore(),
        );
    final docSnap = await campaignRef.get();
    var campaign = docSnap.data();
    campaign ??= Campaign(title: "NotFound");
    return campaign;
  }

  Future<Supplier> getSupplier(String supplierId) async {
    final supplierRef = db.collection('suppliers').doc(supplierId);
    if (supplierMap.containsKey(supplierId)) {
      return supplierMap[supplierId]!;
    }
    Supplier supplier = await supplierRef.get().then(
      (doc) async {
        final data = doc.data();
        return Supplier(data?['name']);
      },
    );
    supplierMap[supplierId] = supplier;
    return supplier;
  }
}
