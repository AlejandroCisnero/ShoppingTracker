// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      name: json['name'] as String,
      price: (json['price'] as num?)?.toDouble() ?? 0.00,
      imagePath: json['photo'] as String? ?? '',
      isPreSaved: json['isPreSaved'] as bool? ?? false,
      uuid: json['uuid'] as String?,
      quantity: json['quantity'] as int? ?? 1,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'photo': instance.imagePath,
      'isPreSaved': instance.isPreSaved,
      'uuid': instance.uuid,
      'quantity': instance.quantity,
    };
