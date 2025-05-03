import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopora/core/constants/asset_paths.dart';
import 'package:shopora/core/routes/routes.dart';
import 'package:shopora/features/customer/controller/auth_controller.dart';
import 'package:shopora/features/customer/model/customer_model.dart';
import 'package:shopora/features/customer/view/view_profile.dart';

import 'k_elevated_button.dart';

class EndDrawer extends StatefulWidget {
  const EndDrawer({super.key, required this.customer});

  final Customer customer;

  @override
  State<EndDrawer> createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Container(
        height: Get.height * .17,
        width: Get.width * 0.6,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: Get.width * 0.5,
              height: Get.height * 0.05,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(ViewProfile(customer: widget.customer));
                },
                label: Text(
                  "My Profile",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: Get.width * 0.5,
              height: Get.height * 0.05,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        icon: Image.asset(AssetsPath.appLogo, height: 80, width: 80),
                        title: Text("Shopora"),
                        content: Text("Are you sure to logout?"),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          TextButton(
                            onPressed: () async {
                              bool response = await AuthController.signOut();
                              if (response) {
                                Get.offAllNamed(AppRoutes.signIn);
                              }
                            },
                            child: Text("YES"),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("NO"),
                          ),
                        ],
                      );
                    },
                  );
                },
                label: Text(
                  "Logout Shopora",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: Icon(Icons.logout),
              ),
            ),
            // Spacer(),
          ],
        ),
      ),
    );
  }
}
