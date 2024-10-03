import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:try2win/business/ticket_bo.dart';

class ContainerTicket extends StatelessWidget {
  const ContainerTicket({super.key, required this.ticketBO});

  final TicketBO ticketBO;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      ),
      margin: const EdgeInsets.all(5),
      height: 100,
      width: 400,
      child: Column(
        children: [
          Text(
            ticketBO.seller.title,
          ),
          Text(
            DateFormat('dd/MM/yyyy, HH:mm')
                .format(ticketBO.ticket.createdAt.toDate()),
          ),
          Text(
            ticketBO.ticket.customerId,
          ),
        ],
      ),
    );
  }
}
