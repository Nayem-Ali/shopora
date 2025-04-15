import 'package:flutter/foundation.dart';

class Cart {
  String id;
  String productId;
  String customerId;

  Cart({required this.id, required this.productId, required this.customerId});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(id: json['id'], productId: json['product_id'], customerId: json['customer_id']);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "product_id": productId, "customer_id": customerId};
  }
}
