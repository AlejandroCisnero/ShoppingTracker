import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:purchases_api/src/models/json_map.dart';
import 'package:uuid/uuid.dart';

part 'supermarket.g.dart';

/// {@template Supermarket}
/// A single `Supermarket` item.
///
/// Contains a [name], [address], and [uuid]
/// flag.
///
/// If an [uuid] is provided, it cannot be empty. If no [uuid] is provided, one
/// will be generated.
///
/// [Supermarket]s are immutable and can be copied using copyWith, in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}

@JsonSerializable()
class Supermarket extends Equatable {
  /// {@macro supermarket_item}
  Supermarket({
    String? uuid,
    required this.address,
    required this.name,
  })  : assert(
          uuid == null || uuid.isNotEmpty,
          'uuid can not be null and should be empty',
        ),
        uuid = uuid ?? const Uuid().v4();

  ///The id of the supermarket
  final String uuid;

  ///The address of this supermarket
  final String address;

  ///The name of this supermarket
  final String name;

  /// Deserializes the given [JsonMap] into a [Supermarket].
  static Supermarket fromJson(JsonMap jsonMap) =>
      _$SupermarketFromJson(jsonMap);

  /// Converts this [Supermarket] into a [JsonMap].
  JsonMap toJson() => _$SupermarketToJson(this);

  @override
  List<Object?> get props => [address, name];
}
