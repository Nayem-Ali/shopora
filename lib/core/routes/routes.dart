import 'package:get/get.dart';
import 'package:shopora/features/customer/view/authentication/create_account.dart';
import 'package:shopora/features/customer/view/authentication/forget_password.dart';
import 'package:shopora/features/customer/view/authentication/sign_in.dart';
import 'package:shopora/features/customer/view/authentication/update_password.dart';
import 'package:shopora/features/shared/view/splash.dart';

class AppRoutes {
  static String splash = "/splash";
  static String signIn = "/signIn";
  static String createAccount = "/createAccount";
  static String forgetPassword = "/forgetPassword";
  static String updatePassword = "/updatePassword";
  static String adminHome = "/adminHome";
  static String updateProduct = "/updateProduct";
  static String viewOrders = "/viewOrder";
  static String viewProduct = "/viewOrder";
  static String customerHome = "/customerHome";
  static String updateOrder = "/updateOrder";

  static List<GetPage> pages = [
    GetPage(name: splash, page: () => const Splash()),
    GetPage(name: signIn, page: () => const SignInPage()),
    GetPage(name: createAccount, page: () => const CreateAccount()),
    GetPage(name: forgetPassword, page: () => const ForgetPassword()),
    GetPage(name: updatePassword, page: () => const UpdatePassword()),
  ];
}
