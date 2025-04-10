import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopora/core/routes/routes.dart';
import 'package:shopora/core/validations/validations.dart';
import 'package:shopora/features/customer/controller/auth_controller.dart';
import 'package:shopora/features/widgets/app_logo.dart';
import 'package:shopora/features/widgets/k_elevated_button.dart';
import 'package:shopora/features/widgets/k_outlined_button.dart';
import 'package:shopora/features/widgets/k_text_form_field.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
                  AppLogo(),
                  // SizedBox(height: 10),
                  // Text(
                  //   "Fill the text field with your email associated with account. A password "
                  //       "reset link will be sent to your email.",
                  //   style: Theme.of(context).textTheme.titleLarge,
                  //   textAlign: TextAlign.center,
                  // ),
                  SizedBox(height: 10),
                  KTextFormField(
                    controller: password,
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Password",
                    validator: Validations.passwordValidator,
                  ),

                  SizedBox(height: 10),
                  KElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        bool response = await AuthController.updatePassword(
                          password: password.text.trim(),
                        );
                        if(response){
                          Get.offAllNamed(AppRoutes.signIn);
                        }
                      }
                    },
                    text: "Update Password",
                  ),
                  SizedBox(height: 10),
                  KOutlinedButton(onPressed: () => Get.back(), text: "Get Back"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
