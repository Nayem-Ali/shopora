import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shopora/core/routes/routes.dart';
import 'package:shopora/core/validations/validations.dart';
import 'package:shopora/features/customer/controller/auth_controller.dart';
import 'package:shopora/features/widgets/app_logo.dart';
import 'package:shopora/features/widgets/k_elevated_button.dart';
import 'package:shopora/features/widgets/k_outlined_button.dart';
import 'package:shopora/features/widgets/k_text_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

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
                  KTextFormField(
                    controller: email,
                    prefixIcon: Icon(Icons.email),
                    hintText: "Email",
                    validator: Validations.emailValidator,
                  ),
                  KTextFormField(
                    controller: password,
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Password",
                    validator: Validations.passwordValidator,
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.forgetPassword),
                      child: Text(
                        "Forget Password?",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  KElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        AuthResponse? response = await AuthController.signIn(
                          email: email.text.trim(),
                          password: password.text.trim(),
                        );
                        if(response != null){
                          EasyLoading.showSuccess("Welcome to Shopora ${response.user!.email}");
                          if (response.user!.email == "samiajannatproject@gmail.com") {
                            Get.offAllNamed(AppRoutes.adminHome);
                          } else {
                            Get.offAllNamed(AppRoutes.customerHome);
                          }
                        }
                      }
                    },
                    text: "Sign In",
                  ),
                  SizedBox(height: 10),
                  KOutlinedButton(
                    onPressed: () => Get.offNamed(AppRoutes.createAccount),
                    text: "Create Account",
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
