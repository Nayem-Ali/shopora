import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shopora/core/routes/routes.dart';
import 'package:shopora/core/validations/validations.dart';
import 'package:shopora/features/customer/controller/auth_controller.dart';
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
                      if (formKey.currentState!.validate()) {
                        AuthResponse? response = await AuthController.signUp(
                          email: email.text.trim(),
                          password: password.text.trim(),
                        );
                        if(response != null){
                          EasyLoading.showInfo("Account Created Successfully.");
                        }
                        // Customer customer = Customer();
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
