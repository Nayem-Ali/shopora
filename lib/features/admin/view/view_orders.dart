import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopora/features/customer/controller/order_controller.dart';
import 'package:shopora/features/customer/model/order_model.dart';
import 'package:shopora/features/shared/view/order_details.dart';

class ViewOrders extends StatefulWidget {
  const ViewOrders({super.key});

  @override
  State<ViewOrders> createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: OrderController.streamAllOrders(),
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
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: order.customerPhoto,
                      height: 60,
                      width: 60,
                      fit: BoxFit.fill,
                    ),
                  ),
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
    );
  }
}
