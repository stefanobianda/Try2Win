import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:try2win/business/app_firestore.dart';
import 'package:try2win/business/campaign_bo.dart';
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

    List<CampaignBO> readCampaigns = await AppFirestore().getUserCampaign();

    setState(() {
      userCampaigns = readCampaigns.toList();
      _isLoading = false;
    });
  }
}
