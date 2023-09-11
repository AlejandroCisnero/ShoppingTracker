import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:purchases_api/purchases_api.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template local_storage_purchases_api}
/// A Flutter implementation of the PurchasesApi that uses local storage.
/// {@endtemplate}
class LocalStoragePurchasesApi extends PurchasesApi {
  /// {@macro local_storage_purchases_api}
  LocalStoragePurchasesApi({required SharedPreferences plugin})
      : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  //The purpose of using a seeded BehaviorSubject is to provide an initial state
  //or value to subscribers immediately upon subscription
  final _purchaseStreamController =
      BehaviorSubject<List<Purchase>>.seeded(const []);

  /// The key used for storing the purchase locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kPurchaseCollectionKey = '__purchases_collection_key__';

  ///Gets a String from the device's local memory
  String? _getValue(String key) => _plugin.getString(key);

  ///Save a String into the device's local memory and return true
  /// if it was success and false if not
  Future<bool> _setValue(String key, String value) async {
    try {
      await _plugin.setString(key, value);
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Stream<List<Purchase>> getPurchases() =>
      _purchaseStreamController.asBroadcastStream();

  void _init() {
    final purchasesJson = _getValue(kPurchaseCollectionKey);
    if (purchasesJson != null) {
      final purchases =
          List<Map<dynamic, dynamic>>.from(json.decode(purchasesJson) as List)
              .map(
                (jsonMap) => Purchase.fromJson(
                  Map<String, dynamic>.from(jsonMap),
                ),
              )
              .toList();
      _purchaseStreamController.add(purchases);
    } else {
      _purchaseStreamController.add([]);
    }
  }

  @override
  Future<bool> deletePurchase(String id) async {
    final purchases = [..._purchaseStreamController.value];
    final purchaseIndex = purchases.indexWhere((p) => p.uuid == id);
    if (purchaseIndex == -1) {
      //The purchase doesnt exist
      throw PurchaseNotFoundException();
    } else {
      purchases.removeAt(purchaseIndex);
    }
    _purchaseStreamController.add(purchases);
    await _setValue(
      kPurchaseCollectionKey,
      jsonEncode(purchases),
    );
    return true;
  }

  @override
  Future<bool> savePurchase(Purchase purchase) async {
    final purchases = [..._purchaseStreamController.value];
    final purchaseIndex = purchases.indexWhere((p) => p.uuid == purchase.uuid);

    if (purchaseIndex == -1) {
      //we are adding a new one
      purchases.add(purchase);
    } else {
      //we are updating
      purchases[purchaseIndex] = purchase;
    }
    _purchaseStreamController.add(purchases);
    await _setValue(kPurchaseCollectionKey, jsonEncode(purchases));
    return true;
  }
}
