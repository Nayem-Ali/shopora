import 'package:flutter/material.dart';

enum OrderStatus { Pending, Approved, Shipped, Delivered, Cancelled }

class ManageOrders extends StatefulWidget {
  const ManageOrders({super.key});

  @override
  State<ManageOrders> createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
