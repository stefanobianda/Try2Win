import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/business/app_firestore.dart';
import 'package:try2win/business/campaign_bo.dart';
import 'package:try2win/providers/customer_notifier.dart';
import 'package:try2win/widgets/app_decoration.dart';
import 'package:try2win/widgets/campaign_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CampaignsScreen extends ConsumerStatefulWidget {
  const CampaignsScreen({super.key});

  @override
  ConsumerState<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends ConsumerState<CampaignsScreen> {
  List<CampaignBO> userCampaigns = [];

  final db = FirebaseFirestore.instance;
  bool _isLoading = false;

  @override
  void initState() {
    _getCampaigns();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget current = Text(AppLocalizations.of(context)!.zeroCampaigns);
    if (userCampaigns.isNotEmpty) {
      current = CampaignsList(campaignsList: userCampaigns);
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: current),
        ],
      ),
    );
  }

  void _getCampaigns() async {
    setState(() {
      _isLoading = true;
    });

    final customer = ref.read(customerProvider.notifier).getCustomer();
    List<CampaignBO> readCampaigns =
        await AppFirestore().getCampaigns(customer);

    setState(() {
      userCampaigns = readCampaigns.toList();
      _isLoading = false;
    });
  }
}
