import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_repository/purchases_repository.dart';
import 'package:shopping_tracker/app/purchases_overview/view/purchases_overview_page.dart';
import 'package:shopping_tracker/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key, required PurchasesRepository purchasesRepository})
      : _purchasesRepository = purchasesRepository;

  final PurchasesRepository _purchasesRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _purchasesRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return const CupertinoApp(
        theme: CupertinoThemeData(brightness: Brightness.light),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: PurchasesOverviewPage(),
      );
    } else {
      return MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
          colorScheme: ColorScheme.fromSwatch(
            accentColor: const Color(0xFF13B9FF),
          ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const PurchasesOverviewPage(),
      );
    }
  }
}
