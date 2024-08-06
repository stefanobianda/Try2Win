import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('us'));

  void setLocale(Locale locale) {
    state = locale;
  }

  void setLocaleIndex(int localeIndex) {
    state = getLocaleList().toList()[localeIndex];
  }

  Locale getLocale() {
    return state;
  }

  Iterable<Locale> getLocaleList() {
    return const [
      Locale('en'), // English
      Locale('it'), // Italian
      Locale('de'), // German
      Locale('fr'), // Franch
    ];
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);
