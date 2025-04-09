import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopora/core/constants/asset_paths.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(AssetsPath.appLogo, height: Get.height * 0.2, width: Get.height * 0.2),
        Text("Shopora", style: Theme.of(context).textTheme.headlineLarge),
      ],
    );
  }
}
