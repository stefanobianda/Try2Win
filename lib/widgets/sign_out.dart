import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/providers/customer_notifier.dart';

class SignOut extends ConsumerWidget {
  const SignOut({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        FirebaseAuth.instance.signOut();
        ref.read(customerProvider.notifier).resetCustomer();
      },
      icon: Icon(
        Icons.exit_to_app,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
