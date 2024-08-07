import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/screens/coupons.dart';
import 'package:try2win/screens/home.dart';
import 'package:try2win/screens/tickets.dart';
import 'package:try2win/widgets/locale_menu.dart';
import 'package:try2win/widgets/sign_out.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    var activePageTitle = AppLocalizations.of(context)!.customerHome;

    if (selectedPageIndex == 1) {
      activePage = const TicketsScreen();
      activePageTitle = AppLocalizations.of(context)!.tickets;
    }

    if (selectedPageIndex == 2) {
      activePage = const CouponsScreen();
      activePageTitle = AppLocalizations.of(context)!.coupons;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        actions: const [
          LocaleMenu(),
          SignOut(),
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
          BottomNavigationBarItem(
            icon: const Icon(Icons.shop_two),
            label: AppLocalizations.of(context)!.tickets,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.card_giftcard),
            label: AppLocalizations.of(context)!.coupons,
          ),
        ],
      ),
    );
  }
}
