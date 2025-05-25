import 'package:supabase_flutter/supabase_flutter.dart';

class Review {
  String id;
  String customerId;
  String customerName;
  String customerImage;
  String productId;
  String review;
  double rating;

  Review({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerImage,
    required this.productId,
    required this.review,
    required this.rating,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      customerImage: json['customer_image'] ,
      productId: json['product_id'] ,
      review: json['review'],
      rating: (json['rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_image': customerImage,
      'product_id': productId,
      'review': review,
      'rating': rating,
    };
  }
}