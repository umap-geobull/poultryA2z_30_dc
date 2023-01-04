import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_a2z/Sign_Up/vendor_catagory_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Add_Vendor_Screen/vendor_detail_form.dart';
import '../Home/Components/MainCategories/main_category_model.dart';
import '../Utils/AppConfig.dart';
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
  // List<GetmainCategorylist> mainCategoryList=[];


  TextStyle labelStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:12,
      fontWeight: FontWeight.normal,
      color: Colors.grey);

  TextStyle headerStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:16,
      fontWeight: FontWeight.normal,
      color: Colors.black87);

  Color appBarColor = Colors.white,
      appBarIconColor = Colors.black,
      primaryButtonColor = Colors.orange,
      secondaryButtonColor = Colors.orangeAccent;

  FocusNode _focus = FocusNode();
  bool isLocationAllowed = false, isLocationPermissionChecked = false;
  String businessDetailsId = '', businessName = '', businessLogo = '';

  String token = '';


  List< VendorData> mainCategoryList = [];

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
    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }
    var url = AppConfig.grobizBaseUrl + get_main_category_lists;
    print(url);
    var uri = Uri.parse(url);
    print("url ${uri}");

    final body = {
      // "admin_auto_id":admin_auto_id,
      // "app_type_id": app_type_id,
    };
    print(body.toString());
    final response = await http.get(uri);
    print("response ${response.body}");
    if (response.statusCode == 200) {
      isApiCallProcessing = false;

      final resp = jsonDecode(response.body);
      int status = resp['status'];
      print("status" + status.toString());
      if (status == 1) {
        VendorCatagories vendorCatagoryModel =
        VendorCatagories.fromJson(json.decode(response.body));
        // mainCategoryList=(vendorCatagoryModel!=null?vendorCatagoryModel.data:[])!;

        if (vendorCatagoryModel != null) {
          if (vendorCatagoryModel.data != null) {
            mainCategoryList = vendorCatagoryModel.data!;
          }
        }

        print(mainCategoryList.toString());
        print("Size of shoes" + mainCategoryList.length.toString());
        if (mounted) {
          setState(() {});
        }
      }
    } else if (response.statusCode == 500) {
      if (this.mounted) {
        setState(() {
          isApiCallProcessing = false;
        });
      }
      Fluttertoast.showToast(
        msg: "Server error in getting main categories",
        backgroundColor: Colors.grey,
      );
    }
  }

  getAppLogo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var appLogo = prefs.getString('app_logo');

    if (appLogo != null) {
      if (this.mounted) {
        setState(() {
          businessLogo = appLogo;
        });
      }
    }
  }

  void getappUi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? appBarColor = prefs.getString('appbarColor');
    String? appbarIcon = prefs.getString('appbarIconColor');
    String? primaryButtonColor = prefs.getString('primaryButtonColor');
    String? secondaryButtonColor = prefs.getString('secondaryButtonColor');

    if (appBarColor != null) {
      this.appBarColor = Color(int.parse(appBarColor));
    }

    if (appbarIcon != null) {
      this.appBarIconColor = Color(int.parse(appbarIcon));
    }

    if (primaryButtonColor != null) {
      this.primaryButtonColor = Color(int.parse(primaryButtonColor));
    }

    if (secondaryButtonColor != null) {
      this.secondaryButtonColor = Color(int.parse(secondaryButtonColor));
    }

    if (this.mounted) {
      setState(() {});
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
    getappUi();
    getAppLogo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryButtonColor,
        title: const Text("Select vendor Category"),
      ),
      body: isApiCallProcessing == false && mainCategoryList.isNotEmpty
          ? Container(
        margin: EdgeInsets.all(8),
        child: GridView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 2.3),
            mainAxisSpacing: 10,
          ),
          itemCount: mainCategoryList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => VendorDetailsForm(
                        vendorData: mainCategoryList[index],
                      )),
                );
              },
              child: Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                    border: Border.all(color: primaryButtonColor),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          offset: Offset(1, 6),
                          blurRadius: 12)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: primaryButtonColor.withOpacity(0.1),
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                        ),

                        child: Image.asset(

                          "assets/images/default.png",
                          height: 100,
                          width: MediaQuery.of(context).size.width / 2,
                        )),
                    SizedBox(
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "${mainCategoryList[index].categoryName.toLowerCase()}",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: appBarIconColor)
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      )
          : Text("Catagories Not available"),
    );
  }
}
