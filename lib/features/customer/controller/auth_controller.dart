import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shopora/core/constants/database_credentials.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<AuthResponse?> signUp({required String email, required String password}) async {
    try {
      AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: DatabaseCredentials.redirectUrl,
      );
      return response;
    } on AuthException catch (error) {
      EasyLoading.showError(error.message);
    } catch (error) {
      EasyLoading.showError("$error");
    }
    return null;
  }

  static Future<AuthResponse?> signIn({required String email, required String password}) async {
    try {
      AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (error) {
      EasyLoading.showError(error.message);
    } catch (error) {
      EasyLoading.showError("$error");
    }
    return null;
  }

  static Future<void> resetPassword({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: DatabaseCredentials.forgetPasswordUrl,
      );
      EasyLoading.showSuccess("A password reset link sent to your email.");
    } on AuthApiException catch (error) {
      EasyLoading.showError(error.message);
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
  }

  static Future<bool> updatePassword({required String password}) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: password),
        emailRedirectTo: DatabaseCredentials.redirectUrl,
      );
      EasyLoading.showSuccess("Your Password is changed successfully");
      return true;
    } on AuthApiException catch (error) {
      EasyLoading.showError(error.message);
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
    return false;
  }

  static Future<bool> signOut() async {
    try {
      await _supabase.auth.signOut();
      return true;
    } on AuthApiException catch (error) {
      EasyLoading.showError(error.message);
    }
    return false;
  }
}
