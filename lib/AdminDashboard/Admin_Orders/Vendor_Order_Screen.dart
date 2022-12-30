import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/constants.dart';

import 'Completed_order_Screen.dart';
import 'Dispatched_order_screen.dart';
import 'New_Order_List.dart';
import 'Preparing_orders_Screen.dart';
import 'Vendor_Cancelled_Orders.dart';
import 'Vendor_Orders_Reports_Screen.dart';
import 'Vendor_Returns_Orders.dart';

class Vendor_Order_Screen extends StatefulWidget {
  const Vendor_Order_Screen({Key? key}) : super(key: key);

  @override
  _Vendor_Order_ScreenState createState() => _Vendor_Order_ScreenState();
}

class _Vendor_Order_ScreenState extends State<Vendor_Order_Screen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text("Admin Orders",
              style: TextStyle(color: Colors.black, fontSize: 18)),
          leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => Vendor_Orders_Reports(s_date: '',
                        e_date: '', s_date1: '',e_date1: '',  )),
                );
              },
              icon: const Icon(Icons.assessment, color: Colors.black),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.orangeAccent,
            labelColor: Colors.black,
            isScrollable: true,
            tabs: [
              Tab(text: "New Orders"),
              Tab(text: "Preparing Order"),
              Tab(text: "Dispatched Order"),
              Tab(text: "Completed Order"),
              Tab(text: "Returned Order"),
              Tab(text: "Canceled Order")
            ],
          ),
        ),
        body: TabBarView(
          children: [
            New_Order_List(),
            Preparing_Order_List(),
            Dispatched_Order_List(),
            Completed_Order_List(),
            Returned_Order(),
            Cancelled_Order()
          ],
        ),
      ),
    );
  }
}
