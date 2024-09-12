import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/models/customer.dart';
import 'package:try2win/providers/customer_notifier.dart';
import 'package:try2win/providers/seller_view_notifier.dart';
import 'package:try2win/screens/seller_tabs.dart';
import 'package:try2win/screens/splash.dart';
import 'package:try2win/screens/tabs.dart';

class TopScreen extends ConsumerStatefulWidget {
  const TopScreen({super.key});

  @override
  ConsumerState<TopScreen> createState() {
    return _TopScreenState();
  }
}

class _TopScreenState extends ConsumerState<TopScreen> {
  Customer? customer;
  bool isSellerView = false;

  @override
  void initState() {
    ref.read(customerProvider.notifier).loadCustomer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const SplashScreen();
    customer = ref.watch(customerProvider);
    isSellerView = ref.watch(isSellerViewProvider);

    if (customer != null) {
      if (isSellerView) {
        activePage = const SellerTabsScreen();
      } else {
        activePage = TabsScreen(isSeller: customer!.isSeller());
      }
    }

    return Scaffold(
      body: activePage,
    );
  }
}
