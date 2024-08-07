import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/screens/campaigns.dart';
import 'package:try2win/screens/coupons.dart';
import 'package:try2win/screens/seller_home.dart';
import 'package:try2win/screens/seller_tickets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:try2win/widgets/locale_menu.dart';
import 'package:try2win/widgets/sign_out.dart';

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
    var activePageTitle = AppLocalizations.of(context)!.sellerHome;

    if (selectedPageIndex == 1) {
      activePage = const SellerTicketsScreen();
      activePageTitle = AppLocalizations.of(context)!.tickets;
    }

    if (selectedPageIndex == 2) {
      activePage = const CampaignsScreen();
      activePageTitle = AppLocalizations.of(context)!.campaigns;
    }

    if (selectedPageIndex == 3) {
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
        type: BottomNavigationBarType.fixed,
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
            icon: const Icon(Icons.assignment_turned_in),
            label: AppLocalizations.of(context)!.campaigns,
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
