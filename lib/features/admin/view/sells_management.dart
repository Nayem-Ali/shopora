import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shopora/features/widgets/k_elevated_button.dart';
import 'package:shopora/features/widgets/k_text_form_field.dart';

import '../controller/product_controller.dart';
import '../model/product_model.dart';

class SellsManagement extends StatefulWidget {
  const SellsManagement({super.key});

  @override
  State<SellsManagement> createState() => _SellsManagementState();
}

class _SellsManagementState extends State<SellsManagement> {
  TextEditingController stock = TextEditingController();
  TextEditingController sold = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void updateStock(Product product) {
    stock.text = product.stock.toString();
    sold.text = product.sold.toString();
    showBottomSheet(
      backgroundColor: Colors.grey[100],
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(product.title, style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 5),
              Text("Product ID: ${product.id}", style: Theme.of(context).textTheme.titleSmall),
              Form(
                key: formKey,
                child: Row(
                  children: [
                    Flexible(
                      child: KTextFormField(
                        controller: stock,
                        prefixIcon: Icon(CupertinoIcons.number_circle),
                        hintText: "Stock",
                      ),
                    ),
                    Flexible(
                      child: KTextFormField(
                        controller: sold,
                        prefixIcon: Icon(Icons.sell),
                        hintText: "Sold",
                      ),
                    ),
                  ],
                ),
              ),
              KElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    EasyLoading.show();

                    product.stock = int.tryParse(stock.text.trim()) ?? product.stock;

                    product.sold = int.tryParse(sold.text.trim()) ?? product.sold;

                    await ProductController.updateProduct(product: product);
                    EasyLoading.dismiss();
                    EasyLoading.showSuccess(
                      "Product Stock Updated "
                      "Successfully",
                    );
                    Get.back();
                  }
                },
                text: "Update Stock",
              ),
            ],
          ),
        );
      },
    );
  }

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
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DataTable(
                      border: TableBorder.all(),
                      dividerThickness: 2,
                      columnSpacing: 20,
                      headingTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      columns: [
                        DataColumn(label: const Text('Title')),
                        DataColumn(label: const Text('Stock'), numeric: true),
                        DataColumn(label: const Text('Sold'), numeric: true),
                        DataColumn(label: const Text('Price'), numeric: true),
                        DataColumn(label: const Text('Discount'), numeric: true),
                        DataColumn(label: const Text('Rating'), numeric: true),
                        DataColumn(label: const Text('Reviews'), numeric: true),
                      ],
                      rows:
                          products.map((product) {
                            return DataRow(
                              onLongPress: () {
                                updateStock(product);
                              },
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      product.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(Text(product.stock.toString())),
                                DataCell(Text(product.sold.toString())),
                                DataCell(Text(product.price.toString())),
                                DataCell(Text(product.discountPrice.toString())),
                                DataCell(Text(product.rating.toString())),
                                DataCell(Text(product.totalReview.toString())),
                              ],
                            );
                          }).toList(),
                    ),

                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(child: Text("No Data Found"));
        }
      },
    );
  }
}
