import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavigationBarCustomer extends StatelessWidget {
  final int pageIndex;
  final Function(int) onSelectedPage;

  const NavigationBarCustomer(
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
          icon: const Icon(Icons.card_giftcard),
          label: AppLocalizations.of(context)!.coupons,
        ),
      ],
    );
  }
}
