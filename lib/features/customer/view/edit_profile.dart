import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shopora/core/routes/routes.dart';
import 'package:shopora/core/utils/file_handling.dart';
import 'package:shopora/core/validations/validations.dart';
import 'package:shopora/features/customer/controller/profile_controller.dart';
import 'package:shopora/features/customer/model/customer_model.dart';
import 'package:shopora/features/widgets/k_elevated_button.dart';
import 'package:shopora/features/widgets/k_text_form_field.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key, required this.customer});

  Customer customer;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController contact = TextEditingController();
  File? profilePicture;

  @override
  void initState() {
    name.text = widget.customer.name;
    address.text = widget.customer.address;
    contact.text = widget.customer.contact;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
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
                            ? Image.network(widget.customer.image_url, fit: BoxFit.fill)
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
                SizedBox(height: 10),
                KElevatedButton(
                  onPressed: () async {
                    String? imageUrl;
                    if (profilePicture != null) {
                      imageUrl = await FileHandling.uploadProfilePicture(
                        profilePicture!,
                        widget.customer.email,
                      );
                    }
                    if (formKey.currentState!.validate()) {
                      widget.customer.name = name.text;
                      widget.customer.contact = contact.text;
                      widget.customer.address = address.text;
                      widget.customer.image_url = imageUrl ?? widget.customer.image_url;
                      await ProfileController.updateUserData(customer: widget.customer);
                      Get.offNamed(AppRoutes.customerHome);
                    }
                  },
                  text: "Update",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
