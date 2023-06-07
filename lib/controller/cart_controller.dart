import 'package:get/get.dart';
import 'package:keepit/model/products/products.dart';

// import '../model/services/product_services.dart';

class CartController extends GetxController {
  var cartList = <Products>[].obs;
  var cartItems = <Products>[];
  int get count => cartList.length;
  int get totalPrice =>
      cartList.fold(0, (sum, element) => sum + element.price!.toInt());
  int totalCount = 0;
  void addToCart(Products product) {
    cartList.add(product);
    cartItems.add(product);
    totalCount = cartItems.length;
    update();
  }

  // void addItemsToCart(Products product) {
  //   cartList.add(product);
  // }
}
