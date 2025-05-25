import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get/get.dart';
import 'package:shopora/features/admin/model/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final SupabaseClient supabase = Supabase.instance.client;
  bool isCart = false;
  bool isFavourite = false;

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
    double discount = ((widget.product.discountPrice! / widget.product.price) * 100).toPrecision(
      2,
    );
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                height: Get.height * 0.25,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(imageUrl: widget.product.thumbnail, fit: BoxFit.cover),
                ),
              ),
              if (widget.product.discountPrice != null && widget.product.discountPrice != 0)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    height: Get.height * 0.02,
                    width: Get.width * 0.2,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Text(
                        "Save $discount%",
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              if (widget.product.stock == 0)
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    height: Get.height * 0.02,
                    width: Get.width * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Text(
                        "Out of Stock",
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              if (isCart)
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(Icons.shopping_cart, size: 15, color: Colors.white),
                  ),
                ),
              if (isFavourite)
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(Icons.favorite, size: 15, color: Colors.white),
                  ),
                ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            widget.product.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              // color: Theme.of(context).primaryColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5),
          if (widget.product.discountPrice == null || widget.product.discountPrice == 0)
            Text(
              "৳ ${widget.product.price}",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          else
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "৳${widget.product.price}",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                      overflow: TextOverflow.ellipsis,
                      decoration: TextDecoration.lineThrough,
                      decorationThickness: 1.5,
                    ),
                  ),
                  TextSpan(
                    text: " ৳${widget.product.price - widget.product.discountPrice!}",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextSpan(
                    text: " Off ৳${widget.product.discountPrice!}",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      // color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          if(widget.product.totalReview != 0)
          Row(
            children: [
              RatingStars(
                value: widget.product.rating,
                starSize: 15,
                maxValue: 5,
                starColor: Theme.of(context).primaryColor,
                starOffColor: Colors.blueGrey,
                valueLabelVisibility: true,
                maxValueVisibility: false,
                valueLabelColor: Theme.of(context).primaryColor,
              ),
              Text(" (${widget.product.totalReview})"),
            ],
          )
          else
            Text("No reviews yet"),
          if(widget.product.sold > 0)
            Text("Total Sold (${widget.product.sold})")
          else
            Text("Be the first buyer"),
        ],
      ),
    );
  }
}
