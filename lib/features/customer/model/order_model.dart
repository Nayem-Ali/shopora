class Order {
  String id;
  String customerId;
  String customerName;
  String customerPhoto;
  String address;
  String contact;
  String transactionId;
  String status;
  double subTotal;
  DateTime? orderDate;
  List<OrderItem>? orderItems;

  Order({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhoto,
    required this.address,
    required this.contact,
    required this.transactionId,
    required this.status,
    required this.subTotal,
    this.orderDate,
    this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      customerPhoto: json['customer_photo'],
      address: json['address'],
      contact: json['contact'],
      transactionId: json['transaction_id'],
      status: json['status'],
      subTotal: json['sub_total'].toDouble(),
      orderDate: DateTime.parse(json['created_at']),
      orderItems:
          json['order_items'] != null
              ? (json['order_items'] as List).map((i) => OrderItem.fromJson(i)).toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_photo': customerPhoto,
      'address': address,
      'contact': contact,
      'transaction_id': transactionId,
      'status': status,
      'sub_total': subTotal,
    };
  }
}

class OrderItem {
  String id;
  String title;
  String orderId;
  int quantity;
  double price;
  String thumbnail;
  DateTime? created_at;

  OrderItem({
    required this.id,
    required this.title,
    required this.orderId,
    required this.quantity,
    required this.price,
    required this.thumbnail,
    this.created_at,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      title: json['title'],
      orderId: json['order_id'],
      quantity: json['quantity'],
      price: json['price'] * 1.0,
      thumbnail: json['thumbnail'],
      created_at: DateTime.tryParse(json['created_at'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'order_id': orderId,
      'quantity': quantity,
      'price': price,
      'thumbnail': thumbnail,
    };
  }
}
