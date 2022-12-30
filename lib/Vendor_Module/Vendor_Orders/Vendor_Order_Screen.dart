import 'package:flutter/material.dart';

import '../Vendor_Home/Utils/constants.dart';
import 'Completed_order_Screen.dart';
import 'Dispatched_order_screen.dart';
import 'New_Order_List.dart';
import 'Preparing_orders_Screen.dart';
import 'Vendor_Cancelled_Orders.dart';
import 'Vendor_Orders_Reports_Screen.dart';
import 'Vendor_Returns_Orders.dart';

class Vendor_Order_Screen extends StatefulWidget {
  late String Vendorid;
   Vendor_Order_Screen(String vendorId)
   {
     this.Vendorid=vendorId;
   }

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
          backgroundColor: kPrimaryColor,
          title: const Text("Vendor Orders",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => Vendor_Orders_Reports(s_date: '',e_date: '', s_date1: '',e_date1: '',vendor_id: widget.Vendorid,)),
                );
              },
              icon: const Icon(Icons.assessment, color: Colors.white),
            ),
          ],
          bottom: const TabBar(
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
            New_Order_List(widget.Vendorid),
            Preparing_Order_List(widget.Vendorid),
            Dispatched_Order_List(widget.Vendorid),
            Completed_Order_List(widget.Vendorid),
            Returned_Order(widget.Vendorid),
            Cancelled_Order(widget.Vendorid)
          ],
        ),
      ),
    );
  }
}
