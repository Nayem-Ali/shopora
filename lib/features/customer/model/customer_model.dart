class Customer {
  String id;
  String name;
  String email;
  String address;
  String image_url;
  String contact;
  bool order_status;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.image_url,
    required this.contact,
    required this.order_status,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      address: json['address'],
      image_url: json['image_url'],
      contact: json['contact'],
      order_status: json['order_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'image_url': image_url,
      'contact': contact,
      'order_status': order_status
    };
  }
}
