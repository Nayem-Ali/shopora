import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopora/features/admin/controller/product_controller.dart';
import 'package:shopora/features/admin/model/product_model.dart';
import 'package:shopora/features/customer/model/customer_model.dart';
import 'package:shopora/features/customer/view/checkout.dart';
import 'package:shopora/features/customer/view/product_details.dart';
import 'package:shopora/features/widgets/k_elevated_button.dart';
import 'package:shopora/features/widgets/product_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewCart extends StatefulWidget {
  const ViewCart({super.key, required this.customer});

  final Customer customer;

  @override
  State<ViewCart> createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart> {
  String customerId = Supabase.instance.client.auth.currentUser!.id;
  List<Product> products = [];
  List<Product> cartProducts = [];

  @override
  void initState() {
    fetchAllProducts();
    super.initState();
  }

  fetchAllProducts() async {
    products = await ProductController.fetchAllProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ProductController.fetchCartProducts(customerId: customerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        List<String> favorites =
            (snapshot.data as List).map((e) => e['product_id'].toString()).toList();
        if (favorites.isEmpty) {
          return Center(child: Text("No Cart Product Found"));
        } else {
          return Column(
            children: [
              Flexible(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 columns
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    Product product = products[index];
                    if (favorites.contains(product.id)) {
                      cartProducts.add(product);
                      return InkWell(
                        onTap: () => Get.to(ProductDetails(product: product)),
                        child: ProductCard(product: product),
                      );
                    }
                  },
                ),
              ),
              KElevatedButton(
                onPressed: () {
                  Get.to(
                    Checkout(
                      cartProducts: cartProducts.toSet().toList(),
                      customer: widget.customer,
                    ),
                  );
                },
                text: "Checkout",
              ),
            ],
          );
        }
      },
    );
  }
}
