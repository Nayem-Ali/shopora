import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopora/core/routes/routes.dart';
import 'package:shopora/core/validations/validations.dart';
import 'package:shopora/features/customer/controller/auth_controller.dart';
import 'package:shopora/features/widgets/app_logo.dart';
import 'package:shopora/features/widgets/k_elevated_button.dart';
import 'package:shopora/features/widgets/k_outlined_button.dart';
import 'package:shopora/features/widgets/k_text_form_field.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  final appLinks = AppLinks();
  @override
  void initState() {
    appLinks.uriLinkStream.listen(
      (uri) {
        print("Uri Host: ${uri.host}");
        if(uri.host == "forget-password"){
          Get.toNamed(AppRoutes.updatePassword);
        }
      },
    );
    super.initState();
  }

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
                  SizedBox(height: 10),
                  Text(
                    "Fill the text field with your email associated with account. A password "
                        "reset link will be sent to your email.",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  KTextFormField(
                    controller: email,
                    prefixIcon: Icon(Icons.email),
                    hintText: "Email",
                    validator: Validations.emailValidator,
                  ),

                  SizedBox(height: 10),
                  KElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        AuthController.resetPassword(email: email.text.trim());
                      }
                    },
                    text: "Sent Link",
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
  }
}
