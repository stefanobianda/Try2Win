import 'package:try2win/models/customer.dart';
import 'package:try2win/models/seller.dart';
import 'package:try2win/models/ticket.dart';

class TicketBO {
  TicketBO({
    required this.ticket,
    required this.seller,
    required this.customer,
  });

  final Ticket ticket;
  final Seller seller;
  final Customer customer;
}
