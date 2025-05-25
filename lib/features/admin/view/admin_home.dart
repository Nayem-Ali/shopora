import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shopora/core/constants/asset_paths.dart';
import 'package:shopora/core/routes/routes.dart';
import 'package:shopora/features/admin/view/add_products.dart';
import 'package:shopora/features/admin/view/blocked_customers.dart';
import 'package:shopora/features/admin/view/generate_report.dart';
import 'package:shopora/features/admin/view/sells_management.dart';
import 'package:shopora/features/admin/view/view_orders.dart';
import 'package:shopora/features/admin/view/view_products.dart';
import 'package:shopora/features/customer/controller/auth_controller.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int currentPageIndex = 0;
  List<Widget> pages = [ViewProducts(), AddProducts(), ViewOrders(), SellsManagement()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => GenerateReport());
            },
            icon: Icon(Icons.bar_chart),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => BlockedCustomers());
            },
            icon: Icon(Icons.people_alt_outlined),
          ),
          IconButton(
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
            icon: Icon(Icons.logout),
          ),
        ],
        title: Text("Shopora"),
        centerTitle: true,
      ),
      body: pages[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            currentPageIndex = value;
          });
        },
        currentIndex: currentPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "Add Product"),
          BottomNavigationBarItem(icon: Icon(Icons.reorder), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Inventory"),
        ],
      ),
    );
  }
}
