
import 'package:flutter/material.dart';
import 'package:shopora/features/customer/controller/order_controller.dart';
import 'package:shopora/features/customer/model/order_model.dart';

class GenerateReport extends StatefulWidget {
  const GenerateReport({super.key});

  @override
  State<GenerateReport> createState() => _GenerateReportState();
}

class _GenerateReportState extends State<GenerateReport> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales Report", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Monthly Sales"),
            Tab(text: "Yearly Sales"),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 4,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Monthly Sales Tab
          _buildMonthlySalesTable(),

          // Yearly Sales Tab
          _buildYearlySalesTable(),
        ],
      ),
    );
  }

  Widget _buildMonthlySalesTable() {
    // Sample monthly data
    final List<Map<String, dynamic>> monthlyData = [
      {'month': 'January', 'sales': 12500, 'growth': '+12%'},
      {'month': 'February', 'sales': 11800, 'growth': '+8%'},
      {'month': 'March', 'sales': 14200, 'growth': '+15%'},
      {'month': 'April', 'sales': 13600, 'growth': '+10%'},
      {'month': 'May', 'sales': 15200, 'growth': '+18%'},
      {'month': 'June', 'sales': 14800, 'growth': '+16%'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DataTable(
            columnSpacing: 20,
            headingRowColor: MaterialStateProperty.resolveWith((states) => Colors.grey[200]),
            columns: const [
              DataColumn(label: Text('Month', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Sales (\$)', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
              DataColumn(label: Text('Growth', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
            ],
            rows: monthlyData.map((data) {
              return DataRow(
                cells: [
                  DataCell(Text(data['month'])),
                  DataCell(Text(data['sales'].toString())),
                  DataCell(
                      Text(data['growth'],
                          style: TextStyle(
                              color: data['growth'].startsWith('+') ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold
                          )
                      )
                  ),
                ],
              );
            }).toList(),
          ),
          // ElevatedButton(onPressed: (){
          //   OrderController.fetchOrdersWithItems();
          // }, child: Text("Call")),
          // FutureBuilder(future: OrderController.fetchOrdersWithItems(),  builder: (context, snapshot) {
          //   print(snapshot.data);
          //   if(snapshot.connectionState == ConnectionState.waiting){
          //     return SizedBox();
          //   }
          //   else if(snapshot.hasData){
          //     List<Order> orders = snapshot.data ?? [];
          //     return ListView.builder(
          //       shrinkWrap: true,
          //       physics: NeverScrollableScrollPhysics(),
          //       itemBuilder: (context, index) {
          //       return ExpansionTile(title: Text("$index"));
          //     },);
          //   } else{
          //     return Text("No orders found");
          //   }
          // },)
        ],
      ),
    );
  }

  Widget _buildYearlySalesTable() {
    final List<Map<String, dynamic>> yearlyData = [
      {'year': '2020', 'sales': 125000, 'growth': '+5%'},
      {'year': '2021', 'sales': 142000, 'growth': '+14%'},
      {'year': '2022', 'sales': 158000, 'growth': '+11%'},
      {'year': '2023', 'sales': 175000, 'growth': '+11%'},
      {'year': '2024', 'sales': 192000, 'growth': '+10%'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: DataTable(
        columnSpacing: 20,
        headingRowColor: MaterialStateProperty.resolveWith((states) => Colors.grey[200]),
        columns: const [
          DataColumn(label: Text('Year', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Sales (\$)', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
          DataColumn(label: Text('Growth', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
        ],
        rows: yearlyData.map((data) {
          return DataRow(
            cells: [
              DataCell(Text(data['year'])),
              DataCell(Text(data['sales'].toString())),
              DataCell(
                  Text(data['growth'],
                      style: TextStyle(
                          color: data['growth'].startsWith('+') ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold
                      )
                  )
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
