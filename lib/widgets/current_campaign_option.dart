import 'package:flutter/material.dart';
import 'package:try2win/business/app_firestore.dart';
import 'package:try2win/models/quota.dart';

class CurrentCampaignOption extends StatefulWidget {
  const CurrentCampaignOption({super.key});

  @override
  State<CurrentCampaignOption> createState() => _CurrentCampaignOptionState();
}

class _CurrentCampaignOptionState extends State<CurrentCampaignOption> {
  late Quota readQuota;
  bool initDone = false;
  int registeredTickets = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    readQuota = await AppFirestore().getSellerCampaignCurrentQuota();
    registeredTickets = await AppFirestore().getSellerTicketsCount();
    setState(() {
      initDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!initDone) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        Row(
          children: [
            const Text("Current quoota is:"),
            const Spacer(),
            SizedBox(
              width: 100,
              child: InputDecorator(
                textAlign: TextAlign.right,
                decoration: const InputDecoration(),
                child: Text(
                  readQuota.quota.toString(),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text("Current renumeration is:"),
            const Spacer(),
            SizedBox(
              width: 100,
              child: InputDecorator(
                textAlign: TextAlign.right,
                decoration: const InputDecoration(),
                child: Text(
                  readQuota.renumeration.toString(),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text("Current value is:"),
            const Spacer(),
            SizedBox(
              width: 100,
              child: InputDecorator(
                textAlign: TextAlign.right,
                decoration: const InputDecoration(),
                child: Text(
                  readQuota.value.toString(),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text("Current tickets:"),
            const Spacer(),
            SizedBox(
              width: 100,
              child: InputDecorator(
                decoration: const InputDecoration(),
                child: Text(
                  registeredTickets.toString(),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
