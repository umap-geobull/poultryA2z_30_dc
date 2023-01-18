import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/constants.dart';

import 'Approved_Job_screen.dart';
import 'Pending_Approval_screen.dart';
import 'disapproved_Job_screen.dart';

class Job_Approval_Screen extends StatefulWidget {
  const Job_Approval_Screen({Key? key}) : super(key: key);

  @override
  State<Job_Approval_Screen> createState() => _Job_Approval_ScreenState();
}

class _Job_Approval_ScreenState extends State<Job_Approval_Screen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            title: Text("Job Approvals",
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
                Tab(text: "Job Approval",),
                Tab(text: "Approved Jobs"),
                Tab(text: "Disapproved Jobs"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Pending_Approval_List(),
              Approved_Job_screen(),
              Disapproved_Job_screen(),
            ],
          ),
        ));
  }
}
