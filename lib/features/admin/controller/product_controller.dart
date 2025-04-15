import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shopora/features/admin/model/cart_model.dart';
import 'package:shopora/features/admin/model/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductController {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future addProduct({required Product product}) async {
    try {
      await _supabase.from('products').insert(product.toJson());
    } catch (error) {
      print("Add Product Error $error");
      EasyLoading.showError(error.toString());
    }
  }

  static fetchAllProductsStream() async* {
    yield* _supabase.from('products').stream(primaryKey: ['id']);
  }

  static Future<List<Product>> fetchAllProducts() async {
    try {
      final List<Map<String, dynamic>> response = await _supabase.from('products').select();
      return response.map((e) => Product.fromJson(e)).toList();
    } catch (error) {
      print("Fetch All Product $error");
      EasyLoading.showError(error.toString());
    }
    return [];
  }

  static Future updateProduct({required Product product}) async {
    try {
      await _supabase.from('products').update(product.toJson()).eq("id", product.id);
    } catch (error) {
      print("Update Product Error $error");
      EasyLoading.showError(error.toString());
    }
  }

  static Future<bool> deleteProduct({required Product product}) async {
    try {
      await _supabase.from('products').delete().eq("id", product.id);
      return true;
    } catch (error) {
      print("Delete Product Error $error");
      EasyLoading.showError(error.toString());
    }
    return false;
  }

  static Future<List<String>> fetchAllCategories() async {
    List<String> categories = [];
    try {
      final response = await _supabase.from("products").select("category");
      categories = response.map((e) => e['category'].toString()).toList();
      return categories;
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
    return categories;
  }

  static Future addImages({required List<ProductImage> productImages}) async {
    try {
      final List<Future> addImages = [];
      for (ProductImage productImage in productImages) {
        addImages.add(_supabase.from('product_images').insert(productImage.toJson()));
      }
      await Future.wait(addImages);
    } catch (error) {
      print("Add Images DB Error $error");
      EasyLoading.showError(error.toString());
    }
  }

  static Future<List<ProductImage>> fetchProductImages({required String productId}) async {
    try {
      List<Map<String, dynamic>> data = await _supabase
          .from('product_images')
          .select("*")
          .eq("product_id", productId);
      return data.map((e) => ProductImage.fromJson(e)).toList();
    } catch (error) {
      print("Fetch Product Images Error $error");
      EasyLoading.showError(error.toString());
    }
    return [];
  }

  static Future<void> deleteProductImage({required String imageUrl}) async {
    try {
      List<Map<String, dynamic>> data = await _supabase
          .from('product_images')
          .delete()
          .eq("image_url", imageUrl);
    } catch (error) {
      print("Delete Product Images Error $error");
      EasyLoading.showError(error.toString());
    }
  }

  static Future<bool> addToCart({required Cart cart}) async {
    try {
      await _supabase.from('carts').insert(cart.toJson());
      return true;
    } catch (error) {
      print("Add to Cart Error $error");
      EasyLoading.showError(error.toString());
    }
    return false;
  }

  static fetchCartProducts({required String customerId}) async* {
    yield* _supabase.from("carts").stream(primaryKey: ['id']).eq("customer_id", customerId);
  }

  static Future<bool> removeFromCart({required Cart cart}) async {
    try {
      await _supabase
          .from('carts')
          .delete()
          .eq("customer_id", cart.customerId)
          .eq("product_id", cart.productId);
      return true;
    } catch (error) {
      print("Remove from Cart Error $error");
      EasyLoading.showError(error.toString());
    }
    return false;
  }

  static Future<bool> addToFavourite({required Cart cart}) async {
    try {
      await _supabase.from('favorites').insert(cart.toJson());
      return true;
    } catch (error) {
      print("Add to Favourite Error $error");
      EasyLoading.showError(error.toString());
    }
    return false;
  }

  static fetchFavoriteProducts({required String customerId}) async* {
    yield* _supabase.from("favorites").stream(primaryKey: ['id']).eq("customer_id", customerId);
  }

  static Future<bool> removeFromFavourite({required Cart cart}) async {
    try {
      await _supabase
          .from('favorites')
          .delete()
          .eq("customer_id", cart.customerId)
          .eq("product_id", cart.productId);
      return true;
    } catch (error) {
      print("Add to Favourite Error $error");
      EasyLoading.showError(error.toString());
    }
    return false;
  }
}
