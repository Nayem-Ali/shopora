import 'package:shopora/features/customer/model/reveiw_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewController {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static streamProductReviews(String productId) {
    return _supabase.from('reviews').stream(primaryKey: ['id']).eq('product_id', productId);
  }

  static Future<void> createReview({required Review review}) async {
    await _supabase.from('reviews').insert(review.toJson()).select().single();
  }

  static Future<void> updateReview({required Review review}) async {
    await _supabase.from('reviews').update(review.toJson()).eq('id', review.id);
  }

  static Future<void> deleteReview({required Review review}) async {
    await _supabase
        .from('reviews')
        .delete()
        .eq('id', review.id)
        .eq('customer_id', review.customerId);
  }


  static Future<List<double>> getAverageRating({required String productId}) async {
    final List<Map<String, dynamic>> response = await _supabase
        .from('reviews')
        .select()
        .eq("product_id", productId);
    List<Review> reviews = response.map((e) => Review.fromJson(e)).toList();
    double sum = 0;
    for (Review review in reviews) {
      sum += review.rating;
    }
    return [sum / reviews.length, reviews.length * 1.0];
  }
}
