import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_Product_Opreation/Approve_Product_List.dart';

import '../Utils/constants.dart';
import 'Approve_Brand_List.dart';
import 'Approve_Category_List.dart';

class Approval_Screen extends StatefulWidget {
  const Approval_Screen({Key? key}) : super(key: key);

  @override
  _Approval_ScreenState createState() => _Approval_ScreenState();
}

class _Approval_ScreenState extends State<Approval_Screen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text("Admin Approvals",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: [
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "Product Approval"),
              Tab(text: "Brand Approval"),
              Tab(text: "Category Approval"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Approve_Product_List(),
            Approve_Brand_List(),
            Approve_Category_List(),
          ],
        ),
      ),
    );
  }
}
