import 'package:flutter/material.dart';
import 'package:try2win/business/campaign_bo.dart';
import 'package:try2win/widgets/app_decoration.dart';

class CampaignDetailScreen extends StatelessWidget {
  const CampaignDetailScreen({super.key, required this.campaignBO});

  final CampaignBO campaignBO;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campaign Detail"),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: AppDecoration.build(context),
          child: Column(
            children: [
              Text('Coupon from ${campaignBO.campaign.name}'),
              const SizedBox(
                height: 10,
              ),
              Text('Campaign name ${campaignBO.campaign.name}'),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
