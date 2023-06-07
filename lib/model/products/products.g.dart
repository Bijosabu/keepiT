// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Products _$$_ProductsFromJson(Map<String, dynamic> json) => _$_Products(
      id: json['id'] as int?,
      title: json['title'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      image: json['image'] as String,
    );

Map<String, dynamic> _$$_ProductsToJson(_$_Products instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'image': instance.image,
    };
