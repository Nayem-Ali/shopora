import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopora/core/routes/routes.dart';
import 'package:shopora/features/customer/controller/auth_controller.dart';

class DummyHome extends StatefulWidget {
  const DummyHome({super.key});

  @override
  State<DummyHome> createState() => _DummyHomeState();
}

class _DummyHomeState extends State<DummyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to Shopora"),
            TextButton(onPressed: () async {
              bool response =  await AuthController.signOut();
              if(response){
                Get.offAllNamed(AppRoutes.signIn);
              }
            }, child: Text("Logout")),
          ],
        ),
      ),
    );
  }
}
