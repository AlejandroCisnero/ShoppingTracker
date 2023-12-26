import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_repository/purchases_repository.dart';
import 'package:shopping_tracker/app/purchases_overview/view/purchases_overview_page.dart';
import 'package:shopping_tracker/app/ui/theme/bloc/theme_bloc.dart';
import 'package:shopping_tracker/app/ui/theme/shopping_themes.dart';
import 'package:shopping_tracker/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key, required PurchasesRepository purchasesRepository})
      : _purchasesRepository = purchasesRepository;

  final PurchasesRepository _purchasesRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _purchasesRepository,
      child: BlocProvider(
        create: (context) => ThemeBloc(),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          theme: state.isDark
              ? appThemeData[AppThemeMode.dark]!
              : appThemeData[AppThemeMode.light]!,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PurchasesOverviewPage(),
        );
      },
    );
    // if (Platform.isIOS) {
    //   return CupertinoApp(
    //     theme: CupertinoThemeData(
    //       textTheme:
    //           MediaQuery.of(context).platformBrightness == Brightness.dark
    //               ? const CupertinoTextThemeData(
    //                   navActionTextStyle: TextStyle(
    //                     fontFamily: 'SF-Pro-Display',
    //                     fontWeight: FontWeight.normal,
    //                   ),
    //                   textStyle: TextStyle(
    //                     fontFamily: 'SF-Pro-Display',
    //                     fontWeight: FontWeight.normal,
    //                   ),
    //                   navTitleTextStyle: TextStyle(
    //                     fontFamily: 'SF-Pro-Display',
    //                     fontWeight: FontWeight.normal,
    //                     fontSize: 19,
    //                   ),
    //                 )
    //               : const CupertinoTextThemeData(
    //                   navActionTextStyle: TextStyle(
    //                     fontFamily: 'SF-Pro-Display',
    //                     fontWeight: FontWeight.normal,
    //                   ),
    //                   textStyle: TextStyle(
    //                     fontFamily: 'SF-Pro-Display',
    //                     fontWeight: FontWeight.normal,
    //                   ),
    //                 ),
    //     ),
    //     localizationsDelegates: AppLocalizations.localizationsDelegates,
    //     supportedLocales: AppLocalizations.supportedLocales,
    //     home: PurchasesOverviewPage(),
    //   );
    // } else {

    // }
  }
}
