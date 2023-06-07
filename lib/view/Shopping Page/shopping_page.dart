import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keepit/controller/cart_controller.dart';
// import 'package:keepit/model/services/product_services.dart';

import '../../controller/shopping_controller.dart';

class ShoppingPage extends StatelessWidget {
  ShoppingPage({super.key});
  final shoppingController = Get.put(ShoppingController());
  final cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ProductService().fetchAllProducts();
    // });
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey[100],
          body: Column(
            children: [
              Expanded(
                child: GetX<ShoppingController>(builder: (shoppingController) {
                  return ListView.builder(
                    itemCount: shoppingController.products.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Card(
                            color: Colors.grey[200],
                            child: Container(
                              height: 80,
                              child: ListTile(
                                leading: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Image.network(
                                    shoppingController.products[index].image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(shoppingController
                                    .products[index].title!
                                    .substring(0, 10)),
                                subtitle: Text(
                                    '\$ ${shoppingController.products[index].price.toString()}'),
                                trailing: ElevatedButton(
                                    onPressed: () {
                                      cartController.addToCart(
                                          shoppingController.products[index]);
                                    },
                                    child: const Text('Add to Cart')),
                              ),
                            ),
                          ));
                    },
                  );
                }),
              ),
              // ElevatedButton(
              //     onPressed: () {
              //       ProductService().fetchAllProducts();
              //     },
              //     child: Text('Get data')),
              GetX<CartController>(builder: (cartController) {
                return Text(
                  'Total amount : \$${cartController.totalPrice} ',
                  style: const TextStyle(fontSize: 24),
                );
              }),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {},
            label: Obx(() => Text(cartController.cartList.length.toString())),
            // label: GetBuilder<CartController>(builder: (cartController) {
            //   return Text(cartController.totalCount.toString());
            // }),

            // label: GetX<CartController>(builder: (cartController) {
            //   return Text(cartController.cartList.length.toString());
            // }),
            icon: const Icon(Icons.add_to_queue_rounded),
          )),
    );
  }
}
