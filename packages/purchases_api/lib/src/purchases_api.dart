import 'package:purchases_api/src/exceptions/purchase_exceptions.dart';
import 'package:purchases_api/src/models/models.dart';

/// {@template purchases_api}
/// The interface and models for an API providing access to purchases.
/// {@endtemplate}
abstract class PurchasesApi {
  /// {@macro purchases_api}
  const PurchasesApi();

  /// Provides a [Stream] of all Purchases.
  Stream<List<Purchase>> getPurchases();

  ///Saves a [Purchase].
  ///
  /// If a [Purchase] with the same id already exists, it will be replaced.
  Future<bool> savePurchase(Purchase purchase);

  /// Deletes the `Purchase` with the given id.
  ///
  /// If no `Purchase` with the given id exists, a [PurchaseNotFoundException]
  /// error is thrown.
  Future<bool> deletePurchase(String id);
}
