import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../Utils/alert_dialog.dart';

class Add_Vendor extends StatefulWidget {
  // Add_Vendor() ;
  // String main_cat_id;
  // String main_cat_name;

  Add_Vendor( this.main_cat_id, this.main_cat_name) ;
  String main_cat_id;
  String main_cat_name;
  @override
  State<Add_Vendor> createState() => _Add_VendorState();
}

class _Add_VendorState extends State<Add_Vendor> {

  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;
  String baseUrl='', admin_auto_id='',app_type_id='',user_id='';

  @override
  void initState() {
    super.initState();

    getappUi();
    getBaseUrl();
    //getImage_List();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text("Upload Product",
            style: TextStyle(
                color: appBarIconColor,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: ()=>{},
          icon: Icon(Icons.arrow_back, color: appBarIconColor),
        ),
      ),
      body: Container(),
    );
  }
  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');
    if(baseUrl!=null && userId!=null && adminId!=null && apptypeid!=null){
      if(this.mounted){
        this.admin_auto_id=adminId;
        this.baseUrl=baseUrl;
        this.user_id=userId;
        this.app_type_id=apptypeid;
      }
    }
  }

  void getappUi() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? appBarColor =prefs.getString('appbarColor');
    String? appbarIcon =prefs.getString('appbarIconColor');
    String? primaryButtonColor =prefs.getString('primaryButtonColor');
    String? secondaryButtonColor =prefs.getString('secondaryButtonColor');

    if(appBarColor!=null){
      this.appBarColor=Color(int.parse(appBarColor));
    }

    if(appbarIcon!=null){
      this.appBarIconColor=Color(int.parse(appbarIcon));
    }

    if(primaryButtonColor!=null){
      this.primaryButtonColor=Color(int.parse(primaryButtonColor));
      print(this.primaryButtonColor.value.toString());
    }

    if(secondaryButtonColor!=null){
      this.secondaryButtonColor=Color(int.parse(secondaryButtonColor));
      print(this.secondaryButtonColor.value.toString());
    }


    if(this.mounted){
      setState(() {});
    }
  }

}
