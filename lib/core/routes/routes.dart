import 'package:get/get.dart';
import 'package:shopora/features/admin/view/admin_home.dart';
import 'package:shopora/features/authentication/create_account.dart';
import 'package:shopora/features/authentication/forget_password.dart';
import 'package:shopora/features/authentication/sign_in.dart';
import 'package:shopora/features/authentication/update_password.dart';
import 'package:shopora/features/customer/view/customer_home.dart';
import 'package:shopora/features/customer/view/edit_profile.dart';
import 'package:shopora/features/customer/view/favourites.dart';
import 'package:shopora/features/shared/view/splash.dart';

class AppRoutes {
  static String splash = "/splash";
  static String signIn = "/signIn";
  static String createAccount = "/createAccount";
  static String forgetPassword = "/forgetPassword";
  static String updatePassword = "/updatePassword";
  static String customerHome = "/customerHome";
  static String adminHome = "/adminHome";
  static String favorite = "/favorite";

  static List<GetPage> pages = [
    GetPage(name: splash, page: () => const Splash()),
    GetPage(name: signIn, page: () => const SignInPage()),
    GetPage(name: createAccount, page: () => const CreateAccount()),
    GetPage(name: forgetPassword, page: () => const ForgetPassword()),
    GetPage(name: updatePassword, page: () => const UpdatePassword()),
    GetPage(name: customerHome, page: () => const CustomerHome()),
    GetPage(name: adminHome, page: () => const AdminHome()),
    GetPage(name: favorite, page: () => const Favourites()),
  ];
}
