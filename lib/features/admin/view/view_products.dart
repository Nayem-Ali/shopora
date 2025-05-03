import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shopora/features/admin/controller/product_controller.dart';
import 'package:shopora/features/admin/model/product_model.dart';
import 'package:shopora/features/admin/view/manage_products.dart';
import 'package:shopora/features/widgets/product_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewProducts extends StatefulWidget {
  const ViewProducts({super.key});

  @override
  State<ViewProducts> createState() => _ViewProductsState();
}

class _ViewProductsState extends State<ViewProducts> {
  final _supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ProductController.fetchAllProductsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          List<Product> products =
              (snapshot.data as List).map((e) => Product.fromJson(e)).toList();
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              Product product = products[index];
              return InkWell(
                onTap: () => Get.to(ManageProducts(product: product)),
                child: ProductCard(product: product),
              );
            },
          );
        } else {
          return Text("No Data Found");
        }
      },
    );
  }
}
