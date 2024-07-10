import 'package:flutter/material.dart';
import 'package:try2win/models/campaign_bo.dart';

class CampaignList extends StatelessWidget {
  const CampaignList({super.key, required this.campaignList});

  final List<CampaignBO> campaignList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: campaignList.length,
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
                  Text(campaignList[index].supplier.title),
                  Text(campaignList[index].campaign.title),
                ],
              ),
            ),
            // onTap: () {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (ctx) =>
            //               CouponDetailScreen(couponBO: campaignList[index])));
            // },
          );
        });
  }
}
