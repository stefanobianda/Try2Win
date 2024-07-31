import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:try2win/business/campaign_bo.dart';
import 'package:try2win/screens/campaign_detai.dart';

class CampaignsList extends StatelessWidget {
  const CampaignsList({super.key, required this.campaignsList});

  final List<CampaignBO> campaignsList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: campaignsList.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            title: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Theme.of(ctx).colorScheme.primary.withOpacity(0.5),
              ),
              margin: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Text(campaignsList[index].campaign.name),
                  Text(
                    DateFormat('dd/MM/yyyy, HH:mm').format(
                        campaignsList[index].campaign.createdAt.toDate()),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => CampaignDetailScreen(
                          campaignBO: campaignsList[index])));
            },
          );
        });
  }
}
