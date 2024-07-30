import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/providers/customer_notifier.dart';
import 'package:try2win/screens/coupons.dart';
import 'package:try2win/screens/seller_home.dart';
import 'package:try2win/screens/seller_tickets.dart';

class SellerTabsScreen extends ConsumerStatefulWidget {
  const SellerTabsScreen({super.key});

  @override
  ConsumerState<SellerTabsScreen> createState() {
    return _SellerTabsScreenState();
  }
}

class _SellerTabsScreenState extends ConsumerState<SellerTabsScreen> {
  int selectedPageIndex = 0;

  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const SellerHomeScreen();
    var activePageTitle = 'Seller Home';

    if (selectedPageIndex == 1) {
      activePage = const SellerTicketsScreen();
      activePageTitle = 'Tickets';
    }

    if (selectedPageIndex == 2) {
      activePage = const CouponsScreen();
      activePageTitle = 'Campaigns';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              ref.read(customerProvider.notifier).resetCustomer();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPage,
        currentIndex: selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop_two),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Campaign',
          ),
        ],
      ),
    );
  }
}
