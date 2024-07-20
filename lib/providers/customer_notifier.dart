import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/business/app_firestore.dart';
import 'package:try2win/models/customer.dart';

class CustomerNotifier extends StateNotifier<Customer?> {
  CustomerNotifier() : super(null);

  void setCustomer(Customer customer) {
    print('Set customer');
    state = customer;
  }

  Customer? getCustomer() {
    print('Get customer');
    return state;
  }

  void resetCustomer() {
    print('Reset customer');
    state = null;
  }

  Future<void> loadCustomer() async {
    print('Start loading customer ${DateTime.now()}');
    final customer = await AppFirestore().getCustomer();
    state = customer;
    print('Loaded customer ${DateTime.now()}');
  }
}

final customerProvider = StateNotifierProvider<CustomerNotifier, Customer?>(
  (ref) => CustomerNotifier(),
);
