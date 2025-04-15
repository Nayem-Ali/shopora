class Product {
  final String id;
  String title;
  String description;
  double price;
  double? discountPrice;
  String category;
  int stock;
  String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.category,
    required this.stock,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      discountPrice:
          json['discount_price'] != null ? (json['discount_price'] as num).toDouble() : null,
      category: json['category'],
      stock: json['stock'],
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'discount_price': discountPrice,
      'category': category,
      'stock': stock,
      'thumbnail': thumbnail,
    };
  }
}

class ProductImage {
  final String? id;
  final String productId;
  final String imageUrl;

  ProductImage({this.id, required this.productId, required this.imageUrl});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      productId: json['product_id'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'product_id': productId, 'image_url': imageUrl};
  }
}
