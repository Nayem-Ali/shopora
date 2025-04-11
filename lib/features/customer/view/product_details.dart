import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopora/core/validations/validations.dart';
import 'package:shopora/features/admin/controller/product_controller.dart';
import 'package:shopora/features/admin/model/cart_model.dart';
import 'package:shopora/features/admin/model/product_model.dart';
import 'package:shopora/features/widgets/k_text_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<ProductImage> productImages = [];
  int index = 0;
  TextEditingController review = TextEditingController();
  bool isFavourite = false;
  bool isCart = false;

  TextStyle? textStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge?.copyWith(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  void initState() {
    checkData();
    super.initState();
  }

  checkData() async {
    final response1 =
        await supabase
            .from("favorites")
            .select()
            .eq("product_id", widget.product.id)
            .eq("customer_id", supabase.auth.currentUser!.id)
            .maybeSingle();
    final response2 =
        await supabase
            .from("carts")
            .select()
            .eq("product_id", widget.product.id)
            .eq("customer_id", supabase.auth.currentUser!.id)
            .maybeSingle();
    isFavourite = response1 != null;
    isCart = response2 != null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Product Details")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: ProductController.fetchProductImages(productId: widget.product.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      productImages.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }
                  productImages = snapshot.data ?? [];
                  return SizedBox(
                    height: Get.height * 0.27,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: productImages[index].imageUrl,
                            fit: BoxFit.fill,
                            width: Get.width,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.all(5),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (index > 0) index -= 1;
                                });
                              },
                              icon: Icon(Icons.skip_previous, color: Colors.white),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (index < productImages.length - 1) index += 1;
                                });
                              },
                              icon: Icon(Icons.skip_next, color: Colors.white),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(child: Text("${index+1}/${productImages.length}")),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Text(
                widget.product.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Price: ${widget.product.price} TK Only",
                style: textStyle(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (widget.product.discountPrice != null && widget.product.discountPrice != 0)
                Text(
                  "Discount Price: ${widget.product.price - widget.product.discountPrice!} TK Only",
                  style: textStyle(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              Text(
                "Stock remaining ${widget.product.stock}",
                style: textStyle(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Divider(thickness: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    onPressed: () async {
                      Cart cart = Cart(
                        id: const Uuid().v4(),
                        productId: widget.product.id,
                        customerId: supabase.auth.currentUser!.id,
                      );
                      if (isFavourite) {
                        await ProductController.removeFromFavourite(cart: cart);
                      } else {
                        await ProductController.addToFavourite(cart: cart);
                      }
                      setState(() {
                        isFavourite = !isFavourite;
                      });
                    },
                    label: Text(isFavourite ? "Remove from Favorite" : "Add to Favorite"),
                    icon: Icon(isFavourite ? Icons.favorite : Icons.favorite_outline),
                  ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      Cart cart = Cart(
                        id: const Uuid().v4(),
                        productId: widget.product.id,
                        customerId: supabase.auth.currentUser!.id,
                      );
                      if (isCart) {
                        await ProductController.removeFromCart(cart: cart);
                      } else {
                        await ProductController.addToCart(cart: cart);
                      }
                      setState(() {
                        isCart = !isCart;
                      });
                    },
                    label: Text(isCart ? "Remove from Cart" : "Add to Cart"),
                    icon: Icon(isCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart),
                  ),
                ],
              ),
              Divider(thickness: 2),
              ExpansionTile(
                expandedAlignment: Alignment.topLeft,
                title: Text("Product Description"),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.product.description ?? "No Description Given"),
                  ),
                ],
              ),
              // ExpansionTile(
              //   expandedAlignment: Alignment.topLeft,
              //   title: Text("Product Review"),
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Text(widget.product.description ?? "No Description Given"),
              //     ),
              //     Row(
              //       children: [
              //         Flexible(
              //           child: KTextFormField(
              //             controller: review,
              //             prefixIcon: Icon(Icons.reviews),
              //             hintText: "Write your review",
              //             validator: Validations.nonEmptyValidator,
              //           ),
              //         ),
              //         IconButton(onPressed: () {}, icon: Icon(Icons.send)),
              //       ],
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
