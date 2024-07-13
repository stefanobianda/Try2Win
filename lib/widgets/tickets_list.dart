import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:try2win/business/ticket_bo.dart';

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
            title: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Theme.of(ctx).colorScheme.primary.withOpacity(0.5),
              ),
              margin: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Text(
                    ticketList[index].seller.title,
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy, HH:mm')
                        .format(ticketList[index].ticket.createdAt.toDate()),
                  )
                ],
              ),
            ),
          );
        });
  }
}
