import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Home/Home_Screen.dart';
import '../Sign_Up/vendor_catagory_model.dart';
import '../Utils/AppConfig.dart';
import '../Utils/App_Apis.dart';
import 'package:http/http.dart' as http;

class VendorDetailsForm extends StatefulWidget {
  final VendorData vendorData;
  const VendorDetailsForm({Key? key, required this.vendorData})
      : super(key: key);

  @override
  State<VendorDetailsForm> createState() => _VendorDetailsFormState();
}

class _VendorDetailsFormState extends State<VendorDetailsForm> {
  Color appBarColor = Colors.white,
      appBarIconColor = Colors.black,
      primaryButtonColor = Colors.orange,
      secondaryButtonColor = Colors.orangeAccent;
  String token = '';
  FocusNode _focus = FocusNode();
  bool isLocationAllowed = false, isLocationPermissionChecked = false;
  String businessDetailsId = '', businessName = '', businessLogo = '';
  String baseUrl = '', admin_auto_id = '';

  late List<TextEditingController> textController = [];

  bool isApiProcessing = false;

  void initState() {
    // TODO: implement initState
    super.initState();
    print(
        "Text editing lenth ${textController.length} field length ${widget.vendorData.fields.length}");
    widget.vendorData.fields.forEach((e) => textController.insert(
        textController.length, new TextEditingController()));
    getAppLogo();

    print(
        "Text editing lenth ${textController.length} field length ${widget.vendorData.fields.length}");
    generateFirebaseToken();
    getBaseUrl();
    getappUi();
  }

  void generateFirebaseToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken != null) {
      token = fcmToken;
      if (this.mounted) {
        setState(() {});
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

  void getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');
    // String? appName =prefs.getString('app_name');
    String? adminId = prefs.getString('admin_auto_id');

    if (baseUrl != null && adminId != null) {
      if (mounted) {
        setState(() {
          this.baseUrl = baseUrl;
          this.admin_auto_id = adminId;
        });
      }
    }
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryButtonColor,
        title: Text("${widget.vendorData.categoryName}"),
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 16, bottom: 60),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        widget.vendorData.fields.length,
                        (index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "${widget.vendorData.fields[index].fieldName.toLowerCase()}",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black)),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 45,
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: TextFormField(
                                      controller: textController[index],
                                      validator: (name) {},
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 15, 0, 0),
                                          hintText:
                                              'Please enter ${widget.vendorData.fields[index].fieldName.toLowerCase()}',
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.black, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                      // style: AppTheme.form_field_text,
                                      keyboardType: TextInputType.name,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                              ],
                            ))),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.white,
                child: isApiProcessing == true?Container(
                  height: 60,
                  alignment: Alignment.center,
                  width: 80,
                  child: const GFLoader(type: GFLoaderType.circle),
                )
                      : InkWell(
                  onTap: () async {
                    await addVendor();
                  },
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),    color: primaryButtonColor,),

                    height: 40,
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.center,
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future addVendor() async {
    setState(() {
      isApiProcessing=true;
    });

    Map<String,dynamic> body = {
      "CATEGORY_AUTO_ID":widget.vendorData.id,
      "ADMIN_AUTO_ID":widget.vendorData.adminAutoId,
      "APP_TYPE_ID":widget.vendorData.appTypeId,
    };

    for(int i = 0; i < widget.vendorData.fields.length;i++){
      body['${widget.vendorData.fields[i].fieldName}'] = textController[i].text;
    }

    print("login body ${body}");

    var url=AppConfig.grobizBaseUrl+add_pountry_vendor;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);
    print("login response  ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        isApiProcessing=false;
      });

      final resp=jsonDecode(response.body);
      int status=resp['status'];

      // if(status=="1"){
      //   Navigator.of(context).push(
      //       MaterialPageRoute(
      //           builder: (context) => OtpScreen(mobileNumber,country_code+'-'+phone_code)));
      // }
      // else if(status=="0"){
      Fluttertoast.showToast(msg: response.statusCode.toString());
      Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (Route<dynamic> route) => false);
      // }
    }
    else{
      setState(() {
        isApiProcessing=false;
      });

      Fluttertoast.showToast(msg: response.statusCode.toString());
      if(this.mounted){
        setState(() {
        });
      }
    }
  }
}
