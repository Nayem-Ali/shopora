import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shopora/features/customer/model/order_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderController {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static addOrder({required Order order}) async {
    try {
      await _supabase.from('orders').insert(order.toJson());
    } catch (error) {
      print("Add Order Error $error");
      EasyLoading.showError(error.toString());
    }
  }

  static streamAllOrders() async* {
    yield* _supabase.from("orders").stream(primaryKey: ['id']);
  }

  static streamMyOrders({required String customerId}) async* {
    yield* _supabase
        .from("orders")
        .stream(primaryKey: ['id'])
        .eq("customer_id", customerId)
        .order('created_at', ascending: false);
  }

  static updateOrder({required Order order}) async {
    try {
      await _supabase.from('orders').update(order.toJson()).eq("id", order.id);
      EasyLoading.showSuccess("Order Status Updated");
    } catch (error) {
      print("Update Order Error $error");
      EasyLoading.showError(error.toString());
    }
  }

  static deleteOrder({required Order order}) async {
    try {
      await _supabase.from('orders').delete().eq("id", order.id);
    } catch (error) {
      print("Delete Order Error $error");
      EasyLoading.showError(error.toString());
    }
  }

  static addOrderItems({required List<OrderItem> orderItems}) async {
    try {
      List<Future> functions =
          orderItems.map((item) => _supabase.from('order_items').insert(item.toJson())).toList();
      await Future.wait(functions);
      EasyLoading.showSuccess("Order Placed Successfully");
    } catch (error) {
      print("Order Item Error $error");
      EasyLoading.showError(error.toString());
    }
  }

  static fetchOrderItems({required String orderId}) async {
    try {
      return _supabase.from('order_items').select().eq("order_id", orderId);
    } catch (error) {
      print("Order Item Error $error");
      EasyLoading.showError(error.toString());
    }
  }

  //Future<List<Order>>
  static Future<List<Order>> fetchOrdersWithItems() async {
    final response = await _supabase
        .from('orders')
        .select('''
        *,
        order_items:order_items(*)
      ''')
        // .neq("status", 'Cancelled')
        .order('created_at', ascending: false);
    // print(response.first);
    List<Order> orders = response.map((order) => Order.fromJson(order)).toList();
    return orders;
  }

  static Future csvData() async {
    final response = await _supabase
        .from('orders')
        .select('''
        *,
        order_items:order_items(*)
      ''')
        .neq("status", 'Cancelled')
        .csv()
        .order('created_at', ascending: false);
    print("CSV $response");
  }
}
