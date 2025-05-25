import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shopora/core/constants/asset_paths.dart';
import 'package:shopora/core/routes/routes.dart';
import 'package:shopora/core/utils/file_handling.dart';
import 'package:shopora/core/validations/validations.dart';
import 'package:shopora/features/customer/controller/auth_controller.dart';
import 'package:shopora/features/customer/controller/profile_controller.dart';
import 'package:shopora/features/customer/model/customer_model.dart';
import 'package:shopora/features/widgets/app_logo.dart';
import 'package:shopora/features/widgets/k_elevated_button.dart';
import 'package:shopora/features/widgets/k_outlined_button.dart';
import 'package:shopora/features/widgets/k_text_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  File? profilePicture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: Get.height * 0.2,
                    width: Get.height * 0.2,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child:
                          profilePicture == null
                              ? Image.asset(AssetsPath.appLogo, fit: BoxFit.fill)
                              : Image.file(profilePicture!, fit: BoxFit.fill),
                    ),
                  ),

                  Container(
                    width: Get.height * 0.2,
                    height: Get.height * 0.06,
                    padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        profilePicture = await FileHandling.pickImage();
                        setState(() {});
                      },
                      child: const Text("Select Image"),
                    ),
                  ),
                  KTextFormField(
                    controller: name,
                    prefixIcon: Icon(Icons.person),
                    hintText: "Full Name",
                    validator: Validations.nameValidator,
                  ),
                  KTextFormField(
                    controller: email,
                    prefixIcon: Icon(Icons.email),
                    hintText: "Email",
                    validator: Validations.emailValidator,
                  ),
                  KTextFormField(
                    controller: contact,
                    prefixIcon: Icon(Icons.phone),
                    hintText: "Contact",
                    validator: Validations.numberValidator,
                  ),
                  KTextFormField(
                    controller: address,
                    prefixIcon: Icon(CupertinoIcons.location),
                    hintText: "Address",
                    validator: Validations.nonEmptyValidator,
                  ),
                  KTextFormField(
                    controller: password,
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Password",
                    validator: Validations.passwordValidator,
                  ),

                  SizedBox(height: 10),
                  KElevatedButton(
                    onPressed: () async {
                      if (profilePicture == null) {
                        EasyLoading.showInfo("Please Select a Profile Picture");
                      } else if (formKey.currentState!.validate()) {
                        AuthResponse? response = await AuthController.signUp(
                          email: email.text.trim(),
                          password: password.text.trim(),
                        );
                        if (response != null) {
                          String? imageUrl = await FileHandling.uploadProfilePicture(
                            profilePicture!,
                            response.user!.email!,
                          );
                          print(imageUrl);
                          Customer customer = Customer(
                            id: response.user!.id,
                            name: name.text.trim(),
                            email: email.text.trim(),
                            address: address.text.trim(),
                            image_url: imageUrl ?? "",
                            contact: contact.text.trim(),
                            order_status: true,
                          );
                          await ProfileController.addUserData(customer: customer);
                          Get.offAllNamed(AppRoutes.signIn);
                          // EasyLoading.showInfo("Account Created Successfully.");
                        }
                      }
                    },
                    text: "Create Account",
                  ),
                  SizedBox(height: 10),
                  KOutlinedButton(
                    onPressed: () => Get.offNamed(AppRoutes.signIn),
                    text: "Sign In",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
