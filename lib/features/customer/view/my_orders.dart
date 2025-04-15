import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopora/features/customer/controller/order_controller.dart';
import 'package:shopora/features/customer/model/order_model.dart';
import 'package:shopora/features/shared/view/order_details.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key, required this.customerId});

  final String customerId;

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Order History")),
      body: StreamBuilder(
        stream: OrderController.streamMyOrders(customerId: widget.customerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            List<Order> orders = (snapshot.data as List).map((e) => Order.fromJson(e)).toList();
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                Order order = orders[index];
                return Card(
                  child: ListTile(
                    onTap: ()=> Get.to(OrderDetails(order: order)),
                    title: Text("Order ID: ${order.id.split("-").last}"),
                    subtitle: Text("Status: ${order.status}"),
                    trailing: Text("${order.subTotal}"),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No order placed"));
          }
        },
      ),
    );
  }
}
