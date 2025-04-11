import 'package:flutter/material.dart';
import 'package:shopora/core/routes/routes.dart';
import 'package:shopora/features/widgets/app_logo.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    redirectRoute();
    super.initState();
  }

  void redirectRoute() async {
    final supabase = Supabase.instance.client;
    await Future.delayed(const Duration(seconds: 3));
    if (supabase.auth.currentSession == null) {
      Get.offAllNamed(AppRoutes.signIn);
    } else {
      User? user = supabase.auth.currentUser;
      //TODO: Extract user role and redirect to admin or customer pages
      if (user!.email! == "samiajannatproject@gmail.com") {
        Get.offAllNamed(AppRoutes.adminHome);
      } else {
        Get.offAllNamed(AppRoutes.customerHome);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: AppLogo()));
  }
}
