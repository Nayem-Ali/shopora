import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopora/features/admin/controller/product_controller.dart';
import 'package:shopora/features/admin/model/product_model.dart';
import 'package:shopora/features/customer/view/product_details.dart';
import 'package:shopora/features/widgets/product_card.dart';

class ExploreProduct extends StatefulWidget {
  const ExploreProduct({super.key});

  @override
  State<ExploreProduct> createState() => _ExploreProductState();
}

class _ExploreProductState extends State<ExploreProduct> {
  String selectedCategory = "all";
  List<String> allCategories = [];

  @override
  void initState() {
    fetchAllCategories();
    super.initState();
  }

  void fetchAllCategories() async {
    allCategories = await ProductController.fetchAllCategories();
    allCategories.insert(0, "all");
    setState(() {});
  }

  List<Product> productCategorization(List<Product> products) {
    selectedCategory = selectedCategory.toLowerCase();
    if (selectedCategory != "all") {
      products =
          products.where((element) => element.category.toLowerCase() == selectedCategory).toList();
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(2),
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: allCategories.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                child: OutlinedButton(
                  onPressed: () {
                    selectedCategory = allCategories[index];
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        allCategories[index] == selectedCategory
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Colors.transparent,
                  ),
                  child: Text(
                    allCategories[index].capitalizeFirst!,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              );
            },
          ),
        ),
        Flexible(
          child: StreamBuilder(
            stream: ProductController.fetchAllProductsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                List<Product> products =
                    (snapshot.data as List).map((e) => Product.fromJson(e)).toList();
                products = productCategorization(products);
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.5,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    Product product = products[index];
                    return InkWell(
                      onTap: () => Get.to(ProductDetails(product: product)),
                      child: ProductCard(product: product),
                    );
                  },
                );
              } else {
                return Text("No Products Found");
              }
            },
          ),
        ),
      ],
    );
    ;
  }
}
