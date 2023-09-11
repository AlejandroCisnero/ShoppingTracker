// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Purchase _$PurchaseFromJson(Map<String, dynamic> json) => Purchase(
      products: (json['cart'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      label: json['label'] as String? ?? '',
      supermarket: json['supermarket'] == null
          ? null
          : Supermarket.fromJson(json['supermarket'] as Map<String, dynamic>),
      uuid: json['uuid'] as String?,
    );

Map<String, dynamic> _$PurchaseToJson(Purchase instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'cart': instance.products,
      'label': instance.label,
      'supermarket': instance.supermarket,
    };
