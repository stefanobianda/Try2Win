import 'package:flutter/material.dart';
import 'package:try2win/business/app_firestore.dart';
import 'package:try2win/business/ticket_bo.dart';
import 'package:try2win/widgets/container_ticket.dart';

class LatestTicket extends StatelessWidget {
  const LatestTicket({super.key});

  Future<TicketBO> _laodLatestTicket() {
    return AppFirestore().getLatestTicket();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _laodLatestTicket(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          TicketBO? ticketBO = snapshot.data;
          if (ticketBO == null) {
            return const Text("null latest Coupon");
          } else {
            return ContainerTicket(
              ticketBO: ticketBO,
            );
          }
        } else {
          return const Text("no latest Coupon");
        }
      },
    );
  }
}
