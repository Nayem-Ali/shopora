import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopora/features/admin/controller/product_controller.dart';
import 'package:shopora/features/admin/model/product_model.dart';
import 'package:shopora/features/customer/model/customer_model.dart';
import 'package:shopora/features/customer/view/checkout.dart';
import 'package:shopora/features/customer/view/product_details.dart';
import 'package:shopora/features/widgets/k_elevated_button.dart';
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    Product product = products[index];
                    if (favorites.contains(product.id)) {
                      cartProducts.add(product);
                      return InkWell(
                        onTap: () => Get.to(ProductDetails(product: product)),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height:140,
                                        width: double.maxFinite,
                                        child: CachedNetworkImage(
                                          imageUrl: product.thumbnail,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      if (product.discountPrice != null && product.discountPrice != 0)
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            margin: const EdgeInsets.all(5),
                                            height: Get.height * 0.05,
                                            width: Get.height * 0.05,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "${((product.discountPrice! / product.price) * 100).toPrecision(2)}%",
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.labelMedium?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Text(
                                  product.title,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (product.discountPrice == null && product.discountPrice == 0)
                                  Text(
                                    "${product.price} TK Only",
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      // color: Theme.of(context).primaryColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                else
                                  Text(
                                    "${product.price - product.discountPrice!} TK Only",
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                        ),
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
