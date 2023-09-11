import 'package:flutter/material.dart';
import 'package:local_storage_purchases_api/local_storage_purchases_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_tracker/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localStoragePurchasesApi = LocalStoragePurchasesApi(
    plugin: await SharedPreferences.getInstance(),
  );
  await bootstrap(purchasesApi: localStoragePurchasesApi);
}
