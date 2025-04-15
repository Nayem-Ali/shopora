import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shopora/core/constants/asset_paths.dart';
import 'package:shopora/core/routes/routes.dart';
import 'package:shopora/features/customer/controller/auth_controller.dart';
import 'package:shopora/features/customer/controller/profile_controller.dart';
import 'package:shopora/features/customer/model/customer_model.dart' show Customer;
import 'package:shopora/features/customer/view/edit_profile.dart';
import 'package:shopora/features/customer/view/my_orders.dart';
import 'package:shopora/features/shared/view/order_details.dart';
import 'package:shopora/features/widgets/k_outlined_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key, required this.customer});

  final Customer customer;

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Personal Information",
                  style: TextStyle(decoration: TextDecoration.underline, fontSize: 18),
                ),
                SizedBox(height: 5),
                Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Theme.of(context).primaryColor, width: 3),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: Get.height * 0.15,
                        width: Get.height * 0.15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: widget.customer.image_url,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Text(widget.customer.name, style: Theme.of(context).textTheme.titleLarge),
                      Text(
                        "Email: ${widget.customer.email}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "Address: ${widget.customer.address}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "Contact: ${widget.customer.contact}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "General",
                  style: TextStyle(decoration: TextDecoration.underline, fontSize: 18),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: Get.width,
                  height: Get.height * 0.05,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.to(EditProfile(customer: widget.customer));
                    },
                    label: Text(
                      "Edit Profile",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(Icons.edit_note),
                  ),
                ),
                // Container(
                //   margin: const EdgeInsets.only(top: 8),
                //   width: Get.width,
                //   height: Get.height * 0.05,
                //   child: ElevatedButton.icon(
                //     onPressed: () => Get.toNamed(AppRoutes.favorite),
                //     label: Text(
                //       "Favorites",
                //       style: Theme.of(context).textTheme.titleMedium!.copyWith(
                //         color: Colors.white,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //     icon: Icon(Icons.favorite),
                //   ),
                // ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: Get.width,
                  height: Get.height * 0.05,
                  child: ElevatedButton.icon(
                    onPressed: () => Get.to(MyOrders(customerId: widget.customer.id)),
                    label: Text(
                      "Order History",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(Icons.list_alt),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Account",
                  style: TextStyle(decoration: TextDecoration.underline, fontSize: 18),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: Get.width,
                  height: Get.height * 0.05,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Supabase.instance.client.auth.signOut();
                      Get.offAllNamed(AppRoutes.forgetPassword);
                    },
                    label: Text(
                      "Change Password",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(Icons.lock),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: Get.width,
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
                SizedBox(height: 5),
                Text(
                  "Contact Us",
                  style: TextStyle(decoration: TextDecoration.underline, fontSize: 18),
                ),
                SizedBox(height: 5),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: Get.width,
                  height: Get.height * 0.05,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      String phoneNumber = "+8801321516025";
                      Uri whatsapp = Uri.parse("https://wa.me/$phoneNumber?text= ");
                      await launchUrl(whatsapp);
                      // await canLaunchUrl(whatsapp)
                      //     ? launchUrl(whatsapp)
                      //     : EasyLoading.showError("Something Went Wrong");
                    },
                    label: Text(
                      "Message Us",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(CupertinoIcons.mail),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: Get.width,
                  height: Get.height * 0.05,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      String phoneNumber = "+880 1317-873948";
                      final Uri url = Uri(scheme: 'tel', path: phoneNumber);
                      bool response = await launchUrl(url);
                      if (response == false) {
                        EasyLoading.showError("Something went wrong");
                      }
                    },
                    label: Text(
                      "Call Us",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(CupertinoIcons.phone),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
