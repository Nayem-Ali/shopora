import 'dart:core';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shopora/core/constants/asset_paths.dart';
import 'package:shopora/core/routes/routes.dart';
import 'package:shopora/core/utils/file_handling.dart';
import 'package:shopora/core/validations/validations.dart';
import 'package:shopora/features/admin/controller/product_controller.dart';
import 'package:shopora/features/admin/model/product_model.dart';
import 'package:shopora/features/widgets/k_elevated_button.dart';
import 'package:shopora/features/widgets/k_outlined_button.dart';
import 'package:shopora/features/widgets/k_text_form_field.dart';
import 'package:uuid/uuid.dart';

class ManageProducts extends StatefulWidget {
  const ManageProducts({super.key, required this.product});

  final Product product;

  @override
  State<ManageProducts> createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  List<File> files = [];
  List<ProductImage> productImages = [];
  int index = 0;
  final formKey = GlobalKey<FormState>();
  TextEditingController productTitle = TextEditingController();
  TextEditingController productCategory = TextEditingController();
  TextEditingController productDescription = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  TextEditingController productDiscount = TextEditingController();
  TextEditingController productStock = TextEditingController();

  @override
  void initState() {
    productTitle.text = widget.product.title;
    productCategory.text = widget.product.category;
    productDescription.text = widget.product.description ?? "";
    productPrice.text = widget.product.price.toString();
    productDiscount.text = widget.product.discountPrice.toString();
    productStock.text = widget.product.stock.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (files.isNotEmpty)
                  SizedBox(
                    height: Get.height * 0.27,
                    child: Stack(
                      children: [
                        Image.file(files[index], fit: BoxFit.fill, width: Get.width),
                        Align(
                          alignment: Alignment.bottomLeft,
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
                          alignment: Alignment.bottomRight,
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
                                  if (index < files.length - 1) index += 1;
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
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  files.removeAt(index);
                                  if (index == files.length) index -= 1;
                                  if (index < 0) index = 0;
                                });
                              },
                              icon: Icon(Icons.cancel, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                FutureBuilder(
                  future: ProductController.fetchProductImages(productId: widget.product.id),
                  builder: (context, snapshot) {
                    productImages = snapshot.data ?? [];
                    return SizedBox(
                      height: Get.height * 0.15,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: productImages[index].imageUrl,
                                  ),
                                ),
                              ),
                              InkWell(
                                onLongPress: () async {
                                  // FileHandling.deleteProductImage(
                                  //   url: productImages[index].imageUrl,
                                  // );
                                  ProductController.deleteProductImage(
                                    imageUrl: productImages[index].imageUrl,
                                  );
                                  setState(() {});
                                },
                                child: Icon(
                                  CupertinoIcons.delete,
                                  size: Get.height * 0.05,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: KOutlinedButton(
                    onPressed: () async {
                      files = await FileHandling.pickProductImages() ?? [];
                      setState(() {});
                    },
                    text: "Select Product Images",
                  ),
                ),
                KTextFormField(
                  controller: productTitle,
                  prefixIcon: Icon(CupertinoIcons.gift),
                  hintText: "Product Title",
                  validator: Validations.nonEmptyValidator,
                ),
                KTextFormField(
                  controller: productCategory,
                  prefixIcon: Icon(Icons.category),
                  hintText: "Product Category",
                  validator: Validations.nonEmptyValidator,
                ),
                KTextFormField(
                  controller: productPrice,
                  prefixIcon: Icon(CupertinoIcons.money_dollar),
                  hintText: "Product Price",
                  validator: Validations.nonEmptyValidator,
                  inputType: TextInputType.number,
                ),
                KTextFormField(
                  controller: productDiscount,
                  prefixIcon: Icon(CupertinoIcons.money_dollar),
                  hintText: "Product Discount Price",
                  inputType: TextInputType.number,
                  validator: (value) {
                    double discount = double.tryParse(value!.trim()) ?? 0;
                    double price = double.tryParse(productPrice.text) ?? 0;
                    if(discount > price){
                      return "Discount price exceed price limit";
                    }
                    return null;
                  },
                ),
                KTextFormField(
                  controller: productStock,
                  prefixIcon: Icon(CupertinoIcons.number_circle),
                  hintText: "Product Stock",
                  validator: Validations.nonEmptyValidator,
                  inputType: TextInputType.number,
                ),
                KTextFormField(
                  controller: productDescription,
                  prefixIcon: Icon(CupertinoIcons.doc_text),
                  hintText: "Product Description",
                  maxLine: null,
                ),
                KElevatedButton(
                  onPressed: () async {
                    List<ProductImage> newImages = [];
                    if (files.isNotEmpty) {
                      List<String>? urls = await FileHandling.uploadProductImages(
                        files,
                        widget.product.id,
                      );
                      newImages =
                          urls
                              ?.map(
                                (url) => ProductImage(
                                  imageUrl: url,
                                  productId: widget.product.id,
                                  id: const Uuid().v4(),
                                ),
                              )
                              .toList() ??
                          [];
                    }
                    if (formKey.currentState!.validate()) {
                      EasyLoading.show();
                      widget.product.title = productTitle.text.trim();
                      widget.product.category = productCategory.text.trim();
                      widget.product.price = double.parse(productPrice.text.trim());
                      widget.product.stock = int.parse(productStock.text.trim());
                      productDescription.text.trim().isEmpty
                          ? "No description added"
                          : productDescription.text;
                      widget.product.thumbnail =
                          productImages.isEmpty
                              ? newImages.first.imageUrl
                              : widget.product.thumbnail;
                      widget.product.discountPrice =
                          double.tryParse(productDiscount.text.trim()) ??
                          widget.product.discountPrice;

                      await Future.wait([
                        ProductController.updateProduct(product: widget.product),
                        ProductController.addImages(productImages: newImages),
                      ]);
                      EasyLoading.dismiss();
                      EasyLoading.showSuccess("Product Updated Successfully");
                      Get.back();
                    }
                  },
                  text: "Update Product",
                ),
                SizedBox(height: 10),
                KOutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Are you sure to delete this product."),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                bool response = await ProductController.deleteProduct(
                                  product: widget.product,
                                );
                                if (response) {
                                  EasyLoading.showSuccess("Product Deleted Successfully");
                                  Get.offNamed(AppRoutes.adminHome);
                                }
                              },
                              child: Text("Confirm"),
                            ),
                            TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
                          ],
                        );
                      },
                    );
                  },
                  text: "Delete Product",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
