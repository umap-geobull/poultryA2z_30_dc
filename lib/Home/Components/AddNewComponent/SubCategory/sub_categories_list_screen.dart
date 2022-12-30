import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/product_color_model.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/product_price_model.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/add_price_screen.dart';
import 'package:poultry_a2z/AppUi/app_ui_model.dart';
import 'package:poultry_a2z/grobiz_start_pages/UserBusiness/BusinessDetailsModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:async/async.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../MainCategories/catagories_list.dart';
import '../../../../MainCategories/catagories_list.dart';
import '../../../../Utils/App_Apis.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/Rest_Apis.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../settings/Select_Filter/Components/filter_menu_model.dart';


class SubCategoriesListScreen extends StatefulWidget {
  const SubCategoriesListScreen({Key? key}) : super(key: key);

  @override
  State<SubCategoriesListScreen> createState() => _SubCategoriesListScreenState();
}

class _SubCategoriesListScreenState extends State<SubCategoriesListScreen> {
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;
  String icon_type='1';

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
    }

    if(secondaryButtonColor!=null){
      this.secondaryButtonColor=Color(int.parse(secondaryButtonColor));
    }

    if(this.mounted){
      setState(() {});
    }
  }

  String baseUrl='',admin_auto_id='';
  String user_id = '',app_type_id='';
  bool isApiCallProcessing = false;
  List<String> categories = [];

  getAppUiDetails() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.getAppUi(admin_auto_id, baseUrl).then((value) {
      if (value != null) {
        if(mounted){
          setState(() {
            isApiCallProcessing=false;
          });
        }

        AppUiModel appUiModel=value;

        if(appUiModel!=null && appUiModel.status==1){
          icon_type=appUiModel.allAppUiStyle![0].productLayoutType;
          if(this.mounted){
            setState(() {
            });
          }
        }
      }
    });
  }

  getFilterList() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body={
      "admin_auto_id":admin_auto_id,
    };
    var url = baseUrl+'api/' + get_filter_menu;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri,body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      if (status == 1) {
        FilterMenuModel filterMenuModel=FilterMenuModel.fromJson(json.decode(response.body));
        filterMenuModel.allfiltermenus.forEach((element) {
          categories.add(element.filterMenuName);
        });
      }
      else {
      }
      if(mounted){
        setState(() {});
      }
    }
  }


  getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');
    if(baseUrl!=null && adminId!=null && userId != null && apptypeid!=null){
      if(this.mounted){
        setState(() {
          this.admin_auto_id=adminId;
          this.baseUrl = baseUrl;
          this.user_id = userId;
          this.app_type_id=apptypeid;
          getAppUiDetails();
          // getData();
          getFilterList();

        });
      }
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getappUi();
    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text("Vendors",
            style: TextStyle(
                color: appBarIconColor,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: () => {Navigator.of(context).pop()},
          icon: Icon(Icons.arrow_back, color: appBarIconColor),
        ),
        // actions: [
        //   IconButton(
        //       onPressed: ()=>{
        //         showFilter()
        //       },
        //       icon: Icon(Icons.filter_alt_outlined,color: appBarIconColor,)),
        //
        //   _shoppingCartBadge(),
        // ]
      ),
      body:  Container(
        child: VendorCatagoriesList(),
      ),
      // bottomSheet: filter_Section(context),

    );
  }
}
