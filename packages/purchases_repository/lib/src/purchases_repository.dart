import 'package:purchases_api/purchases_api.dart';

/// {@template purchases_repository}
/// A repository that handles purchase related requests.
/// {@endtemplate}
class PurchasesRepository {
  /// {@macro purchases_repository}
  const PurchasesRepository({required PurchasesApi purchasesApi})
      : _purchasesApi = purchasesApi;

  final PurchasesApi _purchasesApi;

  ///Get all purchases as a Stream of a list of purchases
  Stream<List<Purchase>> getPurchases() => _purchasesApi.getPurchases();

  ///Saves a [Purchase], if the purchase already exist, it will be replaced
  Future<void> savePurchase(Purchase purchase) =>
      _purchasesApi.savePurchase(purchase);

  ///Deletes a [Purchase] with the given id
  ///If no [Purchase] is found, a [PurchaseNotFoundException] will be throw
  Future<void> deletePurchase(String uuid) =>
      _purchasesApi.deletePurchase(uuid);
}
