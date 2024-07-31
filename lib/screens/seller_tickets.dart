import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:try2win/business/app_firestore.dart';
import 'package:try2win/business/ticket_bo.dart';
import 'package:try2win/widgets/app_decoration.dart';
import 'package:try2win/widgets/tickets_list.dart';

class SellerTicketsScreen extends StatefulWidget {
  const SellerTicketsScreen({super.key});

  @override
  State<SellerTicketsScreen> createState() => _SellerTicketsScreenState();
}

class _SellerTicketsScreenState extends State<SellerTicketsScreen> {
  List<TicketBO> sellerTickets = [];

  final db = FirebaseFirestore.instance;
  var _isLoaded = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      _getSellerTickets();
      _isLoaded = true;
    }
    Widget current = const Text('Go to a resturant and register a ticket!');
    if (sellerTickets.isNotEmpty) {
      current = TicketList(ticketList: sellerTickets);
    }
    if (_isLoading) {
      current = const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: AppDecoration.build(context),
      child: current,
    );
  }

  Future<void> _getSellerTickets() async {
    setState(() {
      _isLoading = true;
    });

    List<TicketBO> readTickets = await AppFirestore().getSellerTickets();

    setState(() {
      sellerTickets = readTickets.toList();
      _isLoading = false;
    });
  }
}
