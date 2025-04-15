import 'package:flutter/material.dart';
import 'package:get/get.dart';
class KElevatedButton extends StatelessWidget {
  const KElevatedButton({super.key, required this.onPressed, required this.text});
  final Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.8,
      height: Get.height * 0.06,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
