import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/firebase_options.dart';
import 'package:try2win/screens/login.dart';
import 'package:try2win/screens/splash.dart';
import 'package:try2win/screens/top.dart';
import 'package:try2win/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(child: Try2WinApp()),
  );
}

class Try2WinApp extends StatelessWidget {
  const Try2WinApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // var isLoggedIn = false;

    return MaterialApp(
      title: 'Try 2 Win',
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
          return const LoginScreen();
        },
      ),
    );
  }
}
