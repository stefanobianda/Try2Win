import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:try2win/models/campaign.dart';
import 'package:try2win/models/campaign_bo.dart';
import 'package:try2win/models/purchase.dart';
import 'package:try2win/models/supplier.dart';
import 'package:try2win/themes/app_theme.dart';
import 'package:try2win/widgets/campaigns_list.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  List<CampaignBO> userCampaigns = [];

  final db = FirebaseFirestore.instance;
  var _isLoaded = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      _getCampaigns();
      _isLoaded = true;
    }
    Widget current =
        const Text('Go to a resturant and get the chance to win a coupons!');
    if (userCampaigns.isNotEmpty) {
      current = CampaignList(campaignList: userCampaigns);
    }
    if (_isLoading) {
      current = const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            kTicinoRed,
            kTicinoBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: current,
    );
  }

  Future<void> _getCampaigns() async {
    setState(() {
      _isLoading = true;
    });
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    final purchasesRef = db.collection('purchases');
    List<CampaignBO> readCampaigns = [];

    await purchasesRef
        .where('userId', isEqualTo: authenticatedUser.uid)
        .get()
        .then((snapshot) async {
      for (var item in snapshot.docs) {
        final data = item.data();
        final purchase = Purchase(
            item.id,
            data['userId'],
            item.data()['supplierId'],
            item.data()['campaignId'],
            item.data()['createdAt']);
        CampaignBO campaignBO = CampaignBO(
          purchase: purchase,
          supplier: await _getSupplier(purchase.supplierId),
          campaign: await _getCampaign(
            purchase.supplierId,
            purchase.campaignId,
          ),
        );
        readCampaigns.add(campaignBO);
      }
    });
    setState(() {
      userCampaigns = readCampaigns.toList();
      _isLoading = false;
    });
  }

  Future<Supplier> _getSupplier(String supplierId) async {
    final supplierRef = db.collection('suppliers').doc(supplierId);
    return await supplierRef.get().then(
      (doc) async {
        final data = doc.data();
        return Supplier(data?['name']);
      },
    );
  }

  Future<Campaign> _getCampaign(String supplierId, String campaignId) async {
    final campaignRef = db
        .collection('suppliers')
        .doc(supplierId)
        .collection('campaigns')
        .doc(campaignId);
    return await campaignRef.get().then(
      (doc) async {
        final data = doc.data();
        return Campaign(data?['name']);
      },
    );
  }
}
