import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FileHandling {
  static SupabaseClient _supabase = Supabase.instance.client;

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
}
