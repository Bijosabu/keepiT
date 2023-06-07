import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:keepit/model/products/products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductService extends GetxController {
  // final products = <Products>[].obs;

  Future<List<Products>> fetchAllProducts() async {
    final url = Uri.parse('https://fakestoreapi.com/products');
    final response = await http.get(url);
    final jsonDecoded = jsonDecode(response.body) as List<dynamic>;
    final products = jsonDecoded
        .map((json) => Products.fromJson(json as Map<String, dynamic>))
        .toList();
    print(products);
    return products;
  }
}
