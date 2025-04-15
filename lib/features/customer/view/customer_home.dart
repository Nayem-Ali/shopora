import 'package:flutter/material.dart';
import 'package:shopora/features/customer/controller/profile_controller.dart';
import 'package:shopora/features/customer/model/customer_model.dart';
import 'package:shopora/features/customer/view/cart.dart';
import 'package:shopora/features/customer/view/favourites.dart';
import 'package:shopora/features/customer/view/view_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'explore_product.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key, required this.currentIndex});
  final int currentIndex;
  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  Customer? customer;

  @override
  void initState() {
    fetchCustomerData();
    super.initState();
  }

  void fetchCustomerData() async {
    currentPageIndex = widget.currentIndex;
    final supabase = Supabase.instance.client;
    customer = await ProfileController.fetchUserData(userId: supabase.auth.currentUser!.id);
    pages.add(ExploreProduct());
    pages.add(ViewCart(customer: customer!));
    pages.add(Favourites());
    pages.add(ViewProfile(customer: customer!));
    setState(() {});
  }
  int currentPageIndex = 0;
  List<Widget> pages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shopora"), centerTitle: true),
      body: customer == null ? Center(child: CircularProgressIndicator()) : pages[currentPageIndex],
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
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favourite"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
