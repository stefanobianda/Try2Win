import 'package:flutter/material.dart';
import 'package:try2win/widgets/app_decoration.dart';
import 'package:try2win/widgets/current_campaign_option.dart';
import 'package:try2win/widgets/new_campaign_option.dart';

class CampaignOptionScreen extends StatelessWidget {
  const CampaignOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: AppDecoration.build(context),
      padding: const EdgeInsets.all(32),
      child: const Column(
        children: [
          NewCampaignOption(),
          SizedBox(
            height: 32,
          ),
          CurrentCampaignOption(),
        ],
      ),
    );
  }
}
