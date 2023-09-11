import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:purchases_api/src/models/json_map.dart';
import 'package:purchases_api/src/models/product.dart';
import 'package:purchases_api/src/models/supermarket.dart';
import 'package:uuid/uuid.dart';

part 'purchase.g.dart';

/// {@template purchase_item}
/// A single `purchase` item.
///
/// Contains a [products], [supermarket], and [uuid]
/// flag.
///
/// If an [uuid] is provided, it cannot be empty. If no [uuid] is provided, one
/// will be generated.
///
/// [Purchase]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}

@JsonSerializable()
class Purchase extends Equatable {
  /// {@macro purchase_item}
  Purchase({
    this.products = const [],
    this.label = '',
    this.supermarket,
    String? uuid,
  })  : assert(
          uuid == null || uuid.isNotEmpty,
          'id can not be null and should be empty',
        ),
        uuid = uuid ?? const Uuid().v4(),
        createdAt = DateTime.now();

  ///An unique identifier for this purchase
  final String uuid;

  ///A list of products that this purchase contains
  final List<Product> products;

  ///A short comment about why or under which circumstances this purchase is made
  final String label;

  ///The supermarket where the purchase was made
  final Supermarket? supermarket;

  ///The date when this purchase was made
  final DateTime createdAt;

  ///Converts a json response into a Purchase object
  static Purchase fromJson(JsonMap jsonMap) => _$PurchaseFromJson(jsonMap);

  ///Get the total spent amount of a purchase
  double getSpentAmount() {
    var spentAmount = 0.00;
    for (final product in products) {
      spentAmount += product.price * product.quantity;
    }
    return spentAmount;
  }

  ///Converts a Puschase object into a json
  JsonMap toJson() => _$PurchaseToJson(this);

  /// Returns a copy of this `purchase` with the given values updated.
  ///
  /// {@macro purchase_item}
  Purchase copyWith({
    String? uuid,
    List<Product>? cart,
    String? label,
    Supermarket? supermarket,
  }) {
    return Purchase(
      uuid: uuid ?? this.uuid,
      products: cart ?? products,
      label: label ?? this.label,
      supermarket: supermarket ?? this.supermarket,
    );
  }

  @override
  List<Object?> get props => [uuid, label, supermarket, products, createdAt];
}
