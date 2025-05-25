import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopora/features/customer/controller/profile_controller.dart';
import 'package:shopora/features/customer/model/customer_model.dart';

class BlockedCustomers extends StatefulWidget {
  const BlockedCustomers({super.key});

  @override
  State<BlockedCustomers> createState() => _BlockedCustomersState();
}

class _BlockedCustomersState extends State<BlockedCustomers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Blocked Customer"),centerTitle: true,),
      body: StreamBuilder(
        stream: ProfileController.streamBannedCustomer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            List<Customer> customers =
                (snapshot.data as List).map((e) => Customer.fromJson(e)).toList();
            if (customers.isEmpty) {
              return Center(child: Text("No Blocked Customer"));
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  Customer customer = customers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(customer.image_url),
                    ),
                    title: Text(customer.name.capitalize!),
                    subtitle: Text(customer.contact),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        await ProfileController.banCustomerFromOrdering(
                          status: true,
                          id: customer.id,
                        );
                        setState(() {});
                      },
                      child: Text("Unblock"),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(child: Text("No Blocked Customer"));
          }
        },
      ),
    );
  }
}
