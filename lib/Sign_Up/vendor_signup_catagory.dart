import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Home/Components/MainCategories/main_category_model.dart';
import '../Utils/App_Apis.dart';
import 'package:http/http.dart' as http;

class VendorSignupCatagory extends StatefulWidget {
  const VendorSignupCatagory({Key? key}) : super(key: key);

  @override
  State<VendorSignupCatagory> createState() => _VendorSignupCatagoryState();
}

class _VendorSignupCatagoryState extends State<VendorSignupCatagory> {
  String baseUrl='',admin_auto_id='',userId='',app_type_id='';
  List<String> selectedCategories=[];

  int iconStyle=100,layoutStyle=2;
  Color labelColor=Colors.grey,headerColor=Colors.black87;
  String labelFont='Lato',headerFont='Lato';
  double labelSize=12,headerSize=16;
  String headerTitle='';
  bool isApiCallProcessing=true;
  bool isAddProcessing=false;
  List<GetmainCategorylist> mainCategoryList=[];


  TextStyle labelStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:12,
      fontWeight: FontWeight.normal,
      color: Colors.grey);

  TextStyle headerStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:16,
      fontWeight: FontWeight.normal,
      color: Colors.black87);
  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');
    String? userId = prefs.getString('user_id');
    String? apptypeid= prefs.getString('app_type_id');

    if(baseUrl!=null && adminId!=null && userId!=null && apptypeid!=null){
      this.baseUrl=baseUrl;
      this.admin_auto_id=adminId;
      print("admin id"+admin_auto_id.toString());
      this.userId=userId;
      this.app_type_id=apptypeid;
      setState(() {});
      getMainCategories();
    }
  }

  void getMainCategories() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    var url=baseUrl+'api/'+get_main_categories;
    print(url);
    var uri = Uri.parse(url);
    print("url ${uri}");

    final body = {
      // "admin_auto_id":admin_auto_id,
      // "app_type_id": app_type_id,
    };
    print(body.toString());
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      print("status"+status.toString());
      if(status==1){
        MainCategoryModel mainCategoryModel=MainCategoryModel.fromJson(json.decode(response.body));
        mainCategoryList=mainCategoryModel.getmainCategorylist;

        print(mainCategoryList.toString());
        print("Size of shoes"+mainCategoryList.length.toString());
        if(mounted){
          setState(() {});
        }
      }
    }
    else if(response.statusCode==500){
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
      Fluttertoast.showToast(msg: "Server error in getting main categories", backgroundColor: Colors.grey,);
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();

  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
