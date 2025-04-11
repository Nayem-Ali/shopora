import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shopora/core/constants/asset_paths.dart';
import 'package:shopora/core/utils/file_handling.dart';
import 'package:shopora/core/validations/validations.dart';
import 'package:shopora/features/admin/controller/product_controller.dart';
import 'package:shopora/features/admin/model/product_model.dart';
import 'package:shopora/features/widgets/k_elevated_button.dart';
import 'package:shopora/features/widgets/k_outlined_button.dart';
import 'package:shopora/features/widgets/k_text_form_field.dart';
import 'package:uuid/uuid.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  List<File> files = [];
  int index = 0;
  final formKey = GlobalKey<FormState>();
  TextEditingController productTitle = TextEditingController();
  TextEditingController productCategory = TextEditingController();
  TextEditingController productDescription = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  TextEditingController productDiscount = TextEditingController();
  TextEditingController productStock = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                )
              else
                Image.asset(AssetsPath.appLogo, height: Get.height * 0.27),
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
                  if (files.isEmpty) {
                    EasyLoading.showError("Please add product images");
                  } else if (formKey.currentState!.validate()) {
                    EasyLoading.show();
                    String productId = const Uuid().v4();
                    List<String>? urls = await FileHandling.uploadProductImages(files, productId);
                    Product product = Product(
                      id: productId,
                      title: productTitle.text.trim(),
                      price: double.parse(productPrice.text.trim()),
                      discountPrice: double.tryParse(productDiscount.text.trim()) ?? 0,
                      category: productCategory.text.trim(),
                      stock: int.parse(productStock.text.trim()),
                      description: productDescription.text.trim(),
                      thumbnail: urls?.first ?? "",
                    );
                    if (urls != null) {
                      List<ProductImage> productImages =
                          urls
                              .map(
                                (url) => ProductImage(
                                  imageUrl: url,
                                  productId: productId,
                                  id: const Uuid().v4(),
                                ),
                              )
                              .toList();
                      await Future.wait([
                        ProductController.addProduct(product: product),
                        ProductController.addImages(productImages: productImages),
                      ]);
                      EasyLoading.dismiss();
                      EasyLoading.showSuccess("Product Added Successfully");
                    }
                  }
                },
                text: "Add Product",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
