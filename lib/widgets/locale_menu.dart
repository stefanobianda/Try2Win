import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/providers/locale_notifier.dart';

class LocaleMenu extends ConsumerStatefulWidget {
  const LocaleMenu({super.key});

  @override
  ConsumerState<LocaleMenu> createState() => _LocaleMenuState();
}

class _LocaleMenuState extends ConsumerState<LocaleMenu> {
  int selectedLocale = 0;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      initialValue: selectedLocale,
      onSelected: (int item) {
        setState(() {
          selectedLocale = item;
          ref.read(localeProvider.notifier).setLocaleIndex(item);
        });
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<int>>[
          const PopupMenuItem<int>(
            value: 0,
            child: Text('EN'),
          ),
          const PopupMenuItem(
            value: 1,
            child: Text('IT'),
          ),
          const PopupMenuItem(
            value: 2,
            child: Text('DE'),
          ),
          const PopupMenuItem(
            value: 3,
            child: Text('FR'),
          ),
        ];
      },
    );
  }
}
