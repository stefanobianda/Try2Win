import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/models/customer.dart';
import 'package:try2win/providers/customer_notifier.dart';
import 'package:try2win/screens/coupons.dart';
import 'package:try2win/screens/home.dart';
import 'package:try2win/screens/splash.dart';
import 'package:try2win/screens/tickets.dart';

class SellerTabsScreen extends ConsumerStatefulWidget {
  const SellerTabsScreen({super.key});

  @override
  ConsumerState<SellerTabsScreen> createState() {
    return _SellerTabsScreenState();
  }
}

class _SellerTabsScreenState extends ConsumerState<SellerTabsScreen> {
  int selectedPageIndex = 0;

  Customer? customer;

  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    customer = ref.watch(customerProvider);
    Widget activePage = const HomeScreen();
    var activePageTitle = 'Seller Home';

    print('Page Number: $selectedPageIndex');
    if (customer == null) {
      ref.read(customerProvider.notifier).loadCustomer();
      activePage = const SplashScreen();
    }

    if (selectedPageIndex == 1) {
      activePage = const TicketsScreen();
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
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shop_two),
            label: 'Tickets',
          ),
          if (customer!.isSeller())
            const BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard),
              label: 'Campaign',
            ),
          if (!customer!.isSeller())
            const BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard),
              label: 'Coupons',
            ),
        ],
      ),
    );
  }
}
