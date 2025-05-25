import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopora/features/admin/controller/product_controller.dart';
import 'package:shopora/features/admin/model/cart_model.dart';
import 'package:shopora/features/admin/model/product_model.dart';
import 'package:shopora/features/customer/view/product_details.dart';
import 'package:shopora/features/widgets/product_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  String customerId = Supabase.instance.client.auth.currentUser!.id;
  List<Product> products = [];

  @override
  void initState() {
    fetchAllProducts();
    super.initState();
  }

  fetchAllProducts() async {
    products = await ProductController.fetchAllProducts();
    setState(() {});
  }

  filterFavouriteProducts(List<String> favouriteProduct) {
    List<Product> favouritesProducts = [];
    for (Product product in products) {
      if (favouriteProduct.contains(product.id)) {
        favouritesProducts.add(product);
      }
    }
    products = List.from(favouritesProducts);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ProductController.fetchFavoriteProducts(customerId: customerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        List<String> favorites =
            (snapshot.data as List).map((e) => e['product_id'].toString()).toList();
        filterFavouriteProducts(favorites);
        if (favorites.isNotEmpty) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.5,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              Product product = products[index];
                print("Favourites $favorites ${product.id}");
              if (favorites.contains(product.id)) {
                return InkWell(
                  onTap: () => Get.to(ProductDetails(product: product)),
                  child: ProductCard(product: product),
                );
              } else{
                return SizedBox.shrink();
              }
            },
          );
        } else {
          return Center(child: Text("No Favorite Product Found"));
        }
      },
    );
  }
}
