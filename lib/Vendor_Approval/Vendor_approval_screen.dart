import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/constants.dart';

import 'Approved_Vendors.dart';
import 'Disapproved_Vendors.dart';
import 'Vendor_Pending_Approval.dart';

class Vendor_Approval_Screen extends StatefulWidget {
  const Vendor_Approval_Screen({Key? key}) : super(key: key);

  @override
  State<Vendor_Approval_Screen> createState() => _Vendor_Approval_ScreenState();
}

class _Vendor_Approval_ScreenState extends State<Vendor_Approval_Screen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            title: Text("Vendor Approvals",
                style: TextStyle(color: appBarIconColor, fontSize: 18)),
            leading: IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: Icon(Icons.arrow_back, color: appBarIconColor),
            ),
            actions: [],
            bottom: TabBar(
              isScrollable: true,
              labelColor: appBarIconColor,
              tabs: [
                Tab(text: "Vendor Approval",),
                Tab(text: "Approved Vendors"),
                Tab(text: "Disapproved Vendors"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Vendor_Pending_Approval(),
              Approved_Vendors(),
              Disapproved_Vendors(),
            ],
          ),
        ));
  }
}
