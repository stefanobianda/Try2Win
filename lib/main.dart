import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/firebase_options.dart';
import 'package:try2win/providers/customer_notifier.dart';
import 'package:try2win/providers/locale_notifier.dart';
import 'package:try2win/providers/seller_view_notifier.dart';
import 'package:try2win/screens/login.dart';
import 'package:try2win/screens/splash.dart';
import 'package:try2win/screens/top.dart';
import 'package:try2win/themes/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(child: Try2WinApp()),
  );
}

class Try2WinApp extends ConsumerWidget {
  const Try2WinApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var isLoggedIn = false;
    return MaterialApp(
      title: 'Try 2 Win',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: ref.read(localeProvider.notifier).getLocaleList(),
      locale: ref.watch(localeProvider),
      theme: themeData,
      darkTheme: themeDarkData,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            return const TopScreen();
          }
          ref.read(customerProvider.notifier).resetCustomer();
          ref.read(isSellerViewProvider.notifier).setSellerView(true);
          return const LoginScreen();
        },
      ),
    );
  }
}
