import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shopora/core/validations/validations.dart';
import 'package:shopora/features/admin/model/product_model.dart';
import 'package:shopora/features/admin/view/manage_orders.dart';
import 'package:shopora/features/customer/controller/order_controller.dart';
import 'package:shopora/features/customer/model/customer_model.dart';
import 'package:shopora/features/customer/model/order_model.dart';
import 'package:shopora/features/widgets/k_outlined_button.dart';
import 'package:shopora/features/widgets/k_text_form_field.dart';
import 'package:uuid/uuid.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key, required this.cartProducts, required this.customer});

  final Customer customer;
  final List<Product> cartProducts;

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  TextEditingController address = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController payment = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final List<int> quantity = [];
  double subTotal = 0;

  @override
  void initState() {
    address.text = widget.customer.address;
    contact.text = widget.customer.contact;
    for (Product product in widget.cartProducts) {
      quantity.add(0);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Checkout")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: Get.height * 0.45,
              child: ListView.builder(
                itemCount: widget.cartProducts.length,
                itemBuilder: (context, index) {
                  Product product = widget.cartProducts[index];
                  return Card(
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: product.thumbnail,
                          height: 60,
                          width: 60,
                        ),
                      ),
                      title: Text(product.title),
                      subtitle: Text("${product.price} TK"),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (quantity[index] > 0) {
                                  quantity[index] -= 1;
                                  subTotal -= (product.price - product.discountPrice!);
                                }
                                setState(() {});
                              },
                              icon: Icon(Icons.remove),
                            ),
                            Text("${quantity[index]}"),
                            IconButton(
                              onPressed: () {
                                if (quantity[index] < product.stock) {
                                  quantity[index] += 1;
                                  subTotal += (product.price - product.discountPrice!);
                                  setState(() {});
                                } else {
                                  EasyLoading.showInfo("Out of Stock");
                                }
                              },
                              icon: Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Text("Sub Total: $subTotal TK Only", style: Theme.of(context).textTheme.headlineSmall),
            ExpansionTile(
              title: Text("Delivery Charge"),

              children: [
                SizedBox(height: 5),
                Text("Inside Sylhet 60 TK Only"),
                Text("Outside Sylhet 120 TK Only"),
                Text("Order Above 2000 TK, Delivery Charge Free"),
                SizedBox(height: 5),
              ],
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  KTextFormField(
                    controller: address,
                    prefixIcon: Icon(CupertinoIcons.location),
                    hintText: "Delivery Address",
                    validator: Validations.nonEmptyValidator,
                  ),
                  KTextFormField(
                    controller: contact,
                    prefixIcon: Icon(CupertinoIcons.phone),
                    hintText: "Delivery Address",
                    validator: Validations.nonEmptyValidator,
                  ),
                  KTextFormField(
                    controller: payment,
                    prefixIcon: Icon(Icons.password),
                    hintText: "Transaction ID / Cash on Delivery",
                  ),
                ],
              ),
            ),
            KOutlinedButton(
              onPressed: () async {
                if (subTotal == 0) {
                  EasyLoading.showInfo("Please Add Items to Confirm Order");
                } else if (formKey.currentState!.validate()) {
                  List<OrderItem> orderItems = [];
                  String orderId = const Uuid().v4();
                  for (int i = 0; i < widget.cartProducts.length; i++) {
                    if (quantity[i] != 0) {
                      OrderItem orderItem = OrderItem(
                        id: const Uuid().v4(),
                        title: widget.cartProducts[i].title,
                        thumbnail: widget.cartProducts[i].thumbnail,
                        orderId: orderId,
                        price:
                            widget.cartProducts[i].price - (widget.cartProducts[i].discountPrice!),
                        quantity: quantity[i],
                      );
                      orderItems.add(orderItem);
                    }
                  }
                  Order order = Order(
                    id: orderId,
                    customerId: widget.customer.id,
                    customerName: widget.customer.name,
                    customerPhoto: widget.customer.image_url,
                    address: address.text.trim(),
                    contact: contact.text.trim(),
                    transactionId: payment.text.trim().isEmpty ? "Cash on Delivery" : payment.text,
                    status: OrderStatus.values.first.name,
                    subTotal: subTotal,
                  );

                  await OrderController.addOrder(order: order);
                  await OrderController.addOrderItems(orderItems: orderItems);
                  Get.back();
                }
              },
              text: "Confirm Order",
            ),
          ],
        ),
      ),
    );
  }
}
