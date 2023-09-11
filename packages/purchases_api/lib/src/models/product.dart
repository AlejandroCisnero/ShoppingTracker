import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:purchases_api/src/models/json_map.dart';
import 'package:uuid/uuid.dart';

part 'product.g.dart';

/// {@template product_item}
/// A single `product` item.
///
/// Contains a [name], [price], [imagePath], [isPreSaved] and [uuid]
/// flag.
///
/// If an [uuid] is provided, it cannot be empty. If no [uuid] is provided, one
/// will be generated.
///
/// [Product]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}

@JsonSerializable()
class Product extends Equatable {
  /// {@macro product_item}
  Product({
    required this.name,
    required this.price,
    required this.quantity,
    this.imagePath = '',
    this.isPreSaved = false,
    String? uuid,
  })  : assert(
          uuid == null || uuid.isNotEmpty,
          'uuid can not be null and should be empty',
        ),
        uuid = uuid ?? const Uuid().v4();

  ///The name of a [Product]
  final String name;

  ///The price of a [Product]
  final double price;

  ///The amount of units you are buying of this product
  final int quantity;

  ///The photo of a [Product], this is an optional field
  final String? imagePath;

  ///This tells if the produc should be auto added whenever a new Purchase
  /// is created
  final bool? isPreSaved;

  ///An unique identifier of a [Product]
  final String uuid;

  /// Deserializes the given [JsonMap] into a [Product].
  static Product fromJson(JsonMap json) => _$ProductFromJson(json);

  /// Converts this [Product] into a [JsonMap].
  JsonMap toJson() => _$ProductToJson(this);

  /// Returns a copy of this `product` with the given values updated.
  ///
  /// {@macro product_item}
  Product copyWith({
    String? name,
    double? price,
    String? imagePath,
    bool? isPreSaved,
    int? quantity,
  }) {
    return Product(
      uuid: uuid,
      name: name ?? this.name,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      isPreSaved: isPreSaved ?? this.isPreSaved,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [
        uuid,
        name,
        price,
        imagePath,
        isPreSaved,
        quantity,
      ];
}
