import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/providers/customer_notifier.dart';
import 'package:try2win/screens/coupons.dart';
import 'package:try2win/screens/home.dart';
import 'package:try2win/screens/tickets.dart';
import 'package:try2win/widgets/navigation_bar_customer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int selectedPageIndex = 0;

  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const HomeScreen();
    var activePageTitle = 'Home';

    if (selectedPageIndex == 1) {
      activePage = const TicketsScreen();
      activePageTitle = 'Tickets';
    }

    if (selectedPageIndex == 2) {
      activePage = const CouponsScreen();
      activePageTitle = 'Coupons';
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
      bottomNavigationBar: NavigationBarCustomer(
          pageIndex: selectedPageIndex, onSelectedPage: selectPage),
    );
  }
}
