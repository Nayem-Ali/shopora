import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get/get.dart';
import 'package:shopora/core/routes/routes.dart';
import 'package:shopora/core/validations/validations.dart';
import 'package:shopora/features/admin/controller/product_controller.dart';
import 'package:shopora/features/admin/model/cart_model.dart';
import 'package:shopora/features/admin/model/product_model.dart';
import 'package:shopora/features/customer/controller/profile_controller.dart';
import 'package:shopora/features/customer/controller/review_controller.dart';
import 'package:shopora/features/customer/model/customer_model.dart';
import 'package:shopora/features/customer/model/reveiw_model.dart';
import 'package:shopora/features/customer/view/customer_home.dart';
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
  TextEditingController reviewController = TextEditingController();
  bool isFavourite = false;
  bool isCart = false;
  bool isReviewUpdate = false;
  String updateReviewId = "";
  Customer? customer;
  double productRating = 1;

  TextStyle? textStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium?.copyWith(
      // color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  void initState() {
    fetchProfile();
    checkData();

    super.initState();
  }

  fetchProfile() async {
    customer = await ProfileController.fetchUserData(userId: supabase.auth.currentUser!.id);
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
                    height: Get.height * 0.4,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: productImages[index].imageUrl,
                            fit: BoxFit.contain,
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
                            child: Center(child: Text("${index + 1}/${productImages.length}")),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Text(
                widget.product.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (widget.product.discountPrice == null || widget.product.discountPrice == 0)
                Text(
                  "৳ ${widget.product.price}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                          overflow: TextOverflow.ellipsis,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: " ৳${widget.product.price - widget.product.discountPrice!}",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextSpan(
                        text: " Off ৳${widget.product.discountPrice!}",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          // color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              Text(
                "Stock remaining ${widget.product.stock}",
                style: textStyle(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if(widget.product.totalReview != 0)
              RatingStars(
                value: widget.product.rating,
                maxValue: 5,
                starColor: Theme.of(context).primaryColor,
                starOffColor: Colors.blueGrey,
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
                        Get.off(CustomerHome(currentIndex: 2));
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
                        Get.off(CustomerHome(currentIndex: 1));
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
                    child: Text(widget.product.description),
                  ),
                ],
              ),
              ExpansionTile(
                expandedAlignment: Alignment.topLeft,
                title: Text("Product Review"),
                subtitle: Text("${widget.product.totalReview} review(s)"),
                children: [
                  RatingStars(
                    value: productRating,
                    maxValue: 5,
                    valueLabelColor: Theme.of(context).primaryColor,
                    starColor: Theme.of(context).primaryColor,
                    starOffColor: Colors.blueGrey,
                    onValueChanged: (value) {
                      setState(() {
                        productRating = value;
                      });
                    },
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: KTextFormField(
                          controller: reviewController,
                          prefixIcon: Icon(Icons.reviews),
                          hintText: "Write your review",
                          validator: Validations.nonEmptyValidator,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          Review review = Review(
                            id: const Uuid().v4(),
                            customerId: customer!.id,
                            customerName: customer!.name,
                            customerImage: customer!.image_url,
                            productId: widget.product.id,
                            review: reviewController.text.trim(),
                            rating: productRating,
                          );
                          if (isReviewUpdate) {
                            review.id = updateReviewId;
                            await ReviewController.updateReview(review: review);
                            isReviewUpdate = false;
                          } else {
                            await ReviewController.createReview(review: review);
                            await ProductController.updateProduct(product: widget.product);
                          }
                          List<double> data = await ReviewController.getAverageRating(
                            productId: widget.product.id,
                          );
                          widget.product.rating = data.first;
                          widget.product.totalReview = data.last.toInt();
                          await ProductController.updateProduct(product: widget.product);
                          reviewController.clear();
                          productRating = 1;
                          setState(() {});
                        },
                        icon: Icon(Icons.send),
                      ),
                    ],
                  ),
                  StreamBuilder(
                    stream: ReviewController.streamProductReviews(widget.product.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        List<Review> reviews =
                            (snapshot.data as List).map((e) => Review.fromJson(e)).toList();
                        if (reviews.isEmpty) {
                          return Center(child: Text("No Reviews Found"));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            Review review = reviews[index];
                            return Card(
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: review.customerImage,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                title: Text("${review.customerName} (${review.rating})"),
                                subtitle: Text(review.review),
                                trailing:
                                    review.customerId == customer!.id
                                        ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                productRating = review.rating;
                                                reviewController.text = review.review;
                                                isReviewUpdate = true;
                                                updateReviewId = review.id;
                                                setState(() {});
                                              },
                                              icon: Icon(Icons.edit_note),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        "Are you sure to delete this review",
                                                      ),
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            await ReviewController.deleteReview(
                                                              review: review,
                                                            );
                                                            Get.back();
                                                            setState(() {});
                                                          },
                                                          child: Text("Confirm"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: Text("Cancel"),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(Icons.delete),
                                            ),
                                          ],
                                        )
                                        : SizedBox.shrink(),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(child: Text("No Reviews Found"));
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
