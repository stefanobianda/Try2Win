import 'package:flutter/material.dart';
import 'package:try2win/business/ticket_bo.dart';
import 'package:try2win/widgets/container_ticket.dart';

class TicketList extends StatelessWidget {
  const TicketList({super.key, required this.ticketList});

  final List<TicketBO> ticketList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: ticketList.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            title: ContainerTicket(
              ticketBO: ticketList[index],
            ),
          );
        });
  }
}
