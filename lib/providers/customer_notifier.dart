import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/business/app_firestore.dart';
import 'package:try2win/models/customer.dart';

class CustomerNotifier extends StateNotifier<Customer?> {
  CustomerNotifier() : super(null);

  void setCustomer(Customer customer) {
    state = customer;
  }

  Customer? getCustomer() {
    return state;
  }

  void resetCustomer() {
    state = null;
  }

  Future<void> loadCustomer() async {
    final customer = await AppFirestore().getCustomer();
    state = customer;
  }
}

final customerProvider = StateNotifierProvider<CustomerNotifier, Customer?>(
  (ref) => CustomerNotifier(),
);
