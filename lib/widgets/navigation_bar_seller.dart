import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavigationBarSeller extends StatelessWidget {
  final int pageIndex;
  final Function(int) onSelectedPage;

  const NavigationBarSeller(
      {super.key, required this.pageIndex, required this.onSelectedPage});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: onSelectedPage,
      currentIndex: pageIndex,
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
          icon: const Icon(Icons.settings),
          label: AppLocalizations.of(context)!.settings,
        ),
      ],
    );
  }
}
