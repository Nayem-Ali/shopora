import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shopora/features/customer/model/customer_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<void> addUserData({required Customer customer}) async {
    try {
      await _supabase.from('customer').insert(customer.toJson());

    } catch (error) {
      print("Customer Error $error");
      EasyLoading.showError(error.toString());
    }
  }

  static Future<void> updateUserData({required Customer customer}) async {
    try {
      await _supabase.from('customer').update(customer.toJson()).eq("id", customer.id);
      EasyLoading.showSuccess("Data Updated Successfully");
    } catch (error) {
      print("Customer Error $error");
      EasyLoading.showError(error.toString());
    }
  }

  static Future<Customer?> fetchUserData({required String userId}) async {
    try {
      final customerData = await _supabase.from('customer').select().eq("id", userId).single();
      print(customerData.cast());
      return Customer.fromJson(customerData.cast());
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
    return null;
  }

  static Future banCustomerFromOrdering({required bool status, required String id}) async {
   try{
     await _supabase.from('customer').update({'order_status': status}).eq('id', id);
     EasyLoading.showSuccess("Customer blocked");
   } catch(e){
     print("Blocking customer error: $e");
   }
  }

  static streamBannedCustomer() async* {
    yield* _supabase
        .from("customer")
        .stream(primaryKey: ['id'])
        .eq("order_status", false);
  }
}
