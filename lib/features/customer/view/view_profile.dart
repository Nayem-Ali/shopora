import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopora/core/constants/asset_paths.dart';
import 'package:shopora/core/routes/routes.dart';
import 'package:shopora/features/customer/controller/auth_controller.dart';
import 'package:shopora/features/customer/controller/profile_controller.dart';
import 'package:shopora/features/customer/model/customer_model.dart' show Customer;
import 'package:shopora/features/customer/view/edit_profile.dart';
import 'package:shopora/features/widgets/k_outlined_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: Get.width,
                height: Get.height * 0.05,
                child: ElevatedButton.icon(
                  onPressed: () async {},
                  label: Text(
                    "Favourites",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: Icon(Icons.favorite),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: Get.width,
                height: Get.height * 0.05,
                child: ElevatedButton.icon(
                  onPressed: () async {},
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
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: Get.width,
                height: Get.height * 0.05,
                child: ElevatedButton.icon(
                  onPressed: ()  {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          icon: Image.asset(AssetsPath.appLogo, height: 80, width: 80,),
                          title: Text("Shopora"),
                          content: Text("Are you sure to logout?"),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            TextButton(
                              onPressed: () async{
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
                    "Logout",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: Icon(Icons.logout),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
