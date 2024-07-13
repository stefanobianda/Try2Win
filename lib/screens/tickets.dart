import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:try2win/business/app_firestore.dart';
import 'package:try2win/business/ticket_bo.dart';
import 'package:try2win/widgets/app_decoration.dart';
import 'package:try2win/widgets/tickets_list.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  List<TicketBO> userTickets = [];

  final db = FirebaseFirestore.instance;
  var _isLoaded = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      _getTickets();
      _isLoaded = true;
    }
    Widget current = const Text('Go to a resturant and register a ticket!');
    if (userTickets.isNotEmpty) {
      current = TicketList(ticketList: userTickets);
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

  Future<void> _getTickets() async {
    setState(() {
      _isLoading = true;
    });

    List<TicketBO> readTickets = await AppFirestore().getUserTickets();

    setState(() {
      userTickets = readTickets.toList();
      _isLoading = false;
    });
  }
}
