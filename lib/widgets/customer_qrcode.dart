import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:try2win/business/configuration.dart';
import 'package:try2win/models/customer.dart';
import 'package:try2win/providers/customer_notifier.dart';

class CustomerQRCode extends ConsumerStatefulWidget {
  const CustomerQRCode({super.key});

  @override
  ConsumerState<CustomerQRCode> createState() {
    return _CustomerQRCodeState();
  }
}

class _CustomerQRCodeState extends ConsumerState<CustomerQRCode> {
  late Future<void> _customerFuture;

  Customer? customer;

  @override
  void initState() {
    super.initState();
    _customerFuture = ref.read(customerProvider.notifier).loadCustomer();
  }

  @override
  Widget build(BuildContext context) {
    customer = ref.watch(customerProvider);

    return FutureBuilder(
      future: _customerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (customer == null) {
          return const Text('Something is wrong, please Logout and restart!');
        } else {
          return QrImageView(
            data: '${Configuration.CUSTOMER_CODE}=${customer!.customerId}',
            version: QrVersions.auto,
            size: 300,
            backgroundColor: Colors.white,
          );
        }
      },
    );
  }
}
