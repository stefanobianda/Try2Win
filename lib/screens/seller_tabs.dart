import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/providers/customer_notifier.dart';
import 'package:try2win/providers/locale_notifier.dart';
import 'package:try2win/providers/seller_view_notifier.dart';
import 'package:try2win/screens/campaign_option.dart';
import 'package:try2win/screens/campaigns.dart';
import 'package:try2win/screens/seller_home.dart';
import 'package:try2win/screens/seller_tickets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:try2win/widgets/navigation_bar_seller.dart';

class SellerTabsScreen extends ConsumerStatefulWidget {
  const SellerTabsScreen({super.key});

  @override
  ConsumerState<SellerTabsScreen> createState() {
    return _SellerTabsScreenState();
  }
}

class _SellerTabsScreenState extends ConsumerState<SellerTabsScreen> {
  int selectedPageIndex = 0;
  int selectedLocale = 0;
  bool isSellerView = false;

  Future<void> selectPage(int index) async {
    setState(() {
      selectedPageIndex = index;
    });
  }

  void onChangedSwitch(bool value) {
    setState(() {
      ref.read(isSellerViewProvider.notifier).setSellerView(value);
      selectedPageIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    isSellerView = ref.watch(isSellerViewProvider);

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
      activePage = const CampaignOptionScreen();
      activePageTitle = AppLocalizations.of(context)!.settings;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        actions: [
          Switch(
            value: isSellerView,
            onChanged: onChangedSwitch,
          ),
          PopupMenuButton(
            initialValue: selectedLocale,
            onSelected: (int item) {
              setState(() {
                selectedLocale = item;
                ref.read(localeProvider.notifier).setLocaleIndex(item);
              });
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<int>>[
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text('EN'),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: Text('IT'),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text('DE'),
                ),
                const PopupMenuItem(
                  value: 3,
                  child: Text('FR'),
                ),
              ];
            },
          ),
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
      bottomNavigationBar: NavigationBarSeller(
          pageIndex: selectedPageIndex, onSelectedPage: selectPage),
    );
  }
}
