import 'package:freezed_annotation/freezed_annotation.dart';
part 'products.freezed.dart';
part 'products.g.dart';

@freezed
class Products with _$Products {
  const factory Products({
    required int? id,
    required String? title,
    required double? price,
    required String image,
  }) = _Products;

  factory Products.fromJson(Map<String, dynamic> json) =>
      _$ProductsFromJson(json);
}
