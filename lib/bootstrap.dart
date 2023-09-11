import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:purchases_api/purchases_api.dart';
import 'package:purchases_repository/purchases_repository.dart';
import 'package:shopping_tracker/app/view/app.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap({
  required PurchasesApi purchasesApi,
}) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final purchasesRepository = PurchasesRepository(purchasesApi: purchasesApi);

  await runZonedGuarded(
    () async => runApp(App(purchasesRepository: purchasesRepository)),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
