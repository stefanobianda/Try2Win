import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:try2win/business/app_firestore.dart';
import 'package:try2win/business/campaign_bo.dart';
import 'package:try2win/models/purchase.dart';
import 'package:try2win/widgets/app_decoration.dart';
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
      decoration: AppDecoration.build(context),
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
            (item.data()['createdAt'] as Timestamp).toDate());
        CampaignBO campaignBO = CampaignBO(
          purchase: purchase,
          supplier: await AppFirestore().getSupplier(
            purchase.supplierId,
          ),
          campaign: await AppFirestore().getCampaign(
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
}
