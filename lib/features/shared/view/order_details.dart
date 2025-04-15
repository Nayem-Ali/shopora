import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopora/features/admin/view/manage_orders.dart';
import 'package:shopora/features/customer/controller/order_controller.dart';
import 'package:shopora/features/customer/model/order_model.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key, required this.order});

  final Order order;

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  String userEmail = Supabase.instance.client.auth.currentUser!.email!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Order Details")),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: OrderController.fetchOrderItems(orderId: widget.order.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              List<OrderItem> orderItems =
                  (snapshot.data as List).map((e) => OrderItem.fromJson(e)).toList();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "Order Placed: ${DateFormat.yMMMMEEEEd().format(widget.order.orderDate!)}",
                      ),
                    ),
                    ListTile(title: Text("Ordered By: ${widget.order.customerName}")),
                    ListTile(title: Text("Contact: ${widget.order.contact}")),
                    ListTile(title: Text("Status: ${widget.order.status}")),
                    ListTile(title: Text("SubTotal: ${widget.order.subTotal}")),
                    ListTile(title: Text("Delivery Address: ${widget.order.address}")),
                    if (userEmail != "samiajannatproject@gmail.com" &&
                        widget.order.status == OrderStatus.Pending.name)
                      SizedBox(
                        height: Get.height * 0.05,
                        width: Get.width,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.order.status = OrderStatus.Cancelled.name;
                            OrderController.updateOrder(order: widget.order);
                          },
                          child: Text("Cancel Order"),
                        ),
                      ),
                    if (userEmail == "samiajannatproject@gmail.com")
                      Row(
                        children: [
                          Flexible(
                            child: DropdownButtonFormField(
                              value: widget.order.status,
                              items:
                                  OrderStatus.values
                                      .map(
                                        (e) =>
                                            DropdownMenuItem(value: e.name, child: Text(e.name)),
                                      )
                                      .toList(),
                              onChanged: (value) {
                                widget.order.status = value!;
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                OrderController.updateOrder(order: widget.order);
                              },
                              child: Text("Update"),
                            ),
                          ),
                        ],
                      ),
                    Divider(),
                    Text("Order Items"),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: orderItems.length,
                      itemBuilder: (context, index) {
                        OrderItem item = orderItems[index];
                        return Card(
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: item.thumbnail,
                                height: 60,
                                width: 60,
                                fit: BoxFit.fill,
                              ),
                            ),
                            title: Text(item.title),
                            subtitle: Text("Qty: ${item.quantity} Price: ${item.price}"),
                            trailing: Text("${item.price * item.quantity}"),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text("Something Went Wrong"));
            }
          },
        ),
      ),
    );
  }
}
