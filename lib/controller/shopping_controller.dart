import 'package:get/get.dart';
import 'package:keepit/model/products/products.dart';

import '../model/services/product_services.dart';

class ShoppingController extends GetxController {
  var products = <Products>[].obs;
  // double get totalPrice =>
  //     products.fold(0, (sum, item) => sum + item.price!.toInt());
  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    final productService = Get.put(ProductService());
    final fetchedProducts = await productService.fetchAllProducts();
    products.assignAll(fetchedProducts);
  }
}
