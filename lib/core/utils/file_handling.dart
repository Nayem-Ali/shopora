import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FileHandling {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<File?> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      compressionQuality: 50,
    );
    if (result != null) {
      File pickedImage = File(result.files.first.path!);
      return pickedImage;
    }
    return null;
  }

  static Future<List<File>?> pickProductImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      compressionQuality: 50,
    );
    if (result != null) {
      List<File> pickedImages = result.files.map((file) => File(file.path!)).toList();
      return pickedImages;
    }
    return null;
  }

  static Future<String?> uploadProfilePicture(File file, String userId) async {
    try {
      final path = '$userId/${file.path.split('/').last}';
      await _supabase.storage.from("profile-picture").upload(path, file);
      final url = _supabase.storage.from('profile-picture').getPublicUrl(path);
      EasyLoading.showSuccess("Profile Picture Uploaded Successfully");
      return url;
    } on StorageException catch (error) {
      print("File Upload Error: ${error.message}");
      EasyLoading.showError(error.message);
    } catch (error) {
      print("File Upload Error: ${error}");
      EasyLoading.showError("$error");
    }
    return null;
  }

  static Future<List<String>?> uploadProductImages(List<File> files, String productId) async {
    try {
      List<String> urls = [];
      for (File file in files) {
        final path = '$productId/${file.path.split('/').last}';
        await _supabase.storage.from("product-images").upload(path, file);
        urls.add(_supabase.storage.from('product-images').getPublicUrl(path));
      }
      return urls;
    } on StorageException catch (error) {
      print("File Upload Error: ${error.message}");
      EasyLoading.showError(error.message);
    } catch (error) {
      print("File Upload Error: ${error}");
      EasyLoading.showError("$error");
    }
    return null;
  }

  // static Future<void> deleteProductImage({required String url}) async {
  //   List<String> path = url.split("/");
  //   await _supabase.storage.from("product-images").remove([
  //     "${path[path.length - 2]}/${path[path.length - 1]}",
  //   ]);
  // }
}
