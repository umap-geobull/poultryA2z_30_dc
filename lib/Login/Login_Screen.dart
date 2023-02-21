import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Login/otp_screen.dart';
import 'package:poultry_a2z/grobiz_start_pages/welcome/phone_field.dart';
import '../Sign_Up/b_to_c_sign_up_screen.dart';
import '../Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<LoginScreen> {
  String country_code='IN',phone_code='91';

  final TextEditingController _mobileController= TextEditingController();
  bool isApiProcessing=false;

  String error_msg="";

  String app_base_url='https://grobiz.app/GRBCRM2022/PoultryEcommerce/';

  String admin_auto_id='63b2612f9821ce37456a4b31';
  String appName='';
  String businessDetailsId='',businessName='',businessLogo='';

  //FocusNode _focus = FocusNode();
  bool isLocationAllowed=false,isLocationPermissionChecked=false;

  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;

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

    prefs.setString('base_url',app_base_url);

    var appLogo= prefs.getString('app_logo');

    if(appLogo!=null){
      if(this.mounted){
        setState(() {
          businessLogo = appLogo;
        });
      }
    }
    if(this.mounted){
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //_focus.addListener(_onFocusChange);
    getappUi();
    //getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 60,bottom: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    color: primaryButtonColor,
                  ),
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          businessLogo.isNotEmpty?
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: CachedNetworkImage(
                              imageUrl: app_logo_base_url+businessLogo,
                              placeholder:(context, url) => Container(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ):
                          Container(),

                          SizedBox(height: 20,),

                          Text(
                            "Login",
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ],
                      )),
                ),
                SizedBox(height: 40.0),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: IntlPhoneField(
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                        hintText: 'Please enter your mobile no',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        )

                    ),
                    //focusNode: _focus,
                    initialCountryCode: country_code,
                    controller: _mobileController,
                    onCountryChanged: (country) {
                      setState(() {
                        country_code = country.code;
                        phone_code = country.dialCode;
                      });
                    },
                  ),
                ),

                SizedBox(height: 50,),
                isApiProcessing==true?
                Container(
                  height: 60,
                  alignment: Alignment.center,
                  width: 80,
                  child: const GFLoader(
                      type:GFLoaderType.circle
                  ),
                ):
                GestureDetector(
                  onTap: () {
                    if(loginValiidation()){
                      sendLoginOtpApi(_mobileController.text);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: primaryButtonColor,
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: Color(0xffEEEEEE)),
                      ],
                    ),
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't Have Any Account?  "),
                      GestureDetector(
                        child: Text(
                          "Sign Up Now",
                          style: TextStyle(color: secondaryButtonColor),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const BtoCSignup("","",'')),
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ));
  }

  // void _onFocusChange() {
  //   if(isLocationAllowed==false && isLocationPermissionChecked==false){
  //     _getCurrentLocation();
  //   }
  // }
  //
  // _getCurrentLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     if(this.mounted){
  //       setState(() {
  //         //_showCity=true;
  //       });
  //     }
  //
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       if(this.mounted){
  //         // _showCity=true;
  //         //_showCountry=true;
  //         isLocationAllowed=false;
  //         isLocationPermissionChecked=true;
  //         setState(() {});
  //       }
  //       return Future.error('Location permissions are denied');
  //     }
  //
  //     else if (permission == LocationPermission.deniedForever) {
  //       // Permissions are denied forever, handle appropriately.
  //       if(this.mounted){
  //         //  _showCity=true;
  //         // _showCountry=true;
  //         isLocationAllowed=false;
  //         isLocationPermissionChecked=true;
  //         setState(() {});
  //       }
  //       return Future.error(
  //           'Location permissions are permanently denied, we cannot request permissions.');
  //     }
  //
  //     else{
  //       isLocationAllowed=true;
  //       isLocationPermissionChecked=true;
  //
  //       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //
  //       if(position!=null){
  //         double latitude=position.latitude;
  //         double longitude=position.longitude;
  //
  //         List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude,localeIdentifier: 'en_US',);
  //         if(placemarks!=null){
  //           String countrycode=placemarks[0].isoCountryCode.toString();
  //
  //           country_code=countrycode;
  //
  //           if(country_code=='IN'){
  //             phone_code='91';
  //           }
  //
  //           if(this.mounted){
  //             setState(() {
  //               //  _showCountry=true;
  //               // _showCity=true;
  //             });
  //           }
  //         }
  //       }
  //     }
  //
  //   }
  //
  //   else if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     if(this.mounted){
  //       // _showCity=true;
  //       //_showCountry=true;
  //       setState(() {});
  //     }
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //
  //   else{
  //     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //
  //     if(position!=null){
  //       double latitude=position.latitude;
  //       double longitude=position.longitude;
  //
  //       List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
  //       if(placemarks!=null){
  //         String countrycode=placemarks[0].isoCountryCode.toString();
  //
  //         country_code=countrycode;
  //
  //         if(country_code=='IN'){
  //           phone_code='91';
  //         }
  //
  //         if(this.mounted){
  //           setState(() {
  //             //  _showCity=true;
  //             //  _showCountry=true;
  //           });
  //         }
  //       }
  //     }
  //   }
  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  // }

  // void dispose() {
  //   super.dispose();
  //   _focus.removeListener(_onFocusChange);
  //   _focus.dispose();
  // }

  Future sendLoginOtpApi(String mobileNumber) async {
    setState(() {
      isApiProcessing=true;
    });

    final body = {
      "mobile_number":mobileNumber,
      "country_code":"IN-91",
      "admin_auto_id":admin_auto_id,
    };

    print("login body ${body}");

    var url=app_base_url+'api/'+send_login_otp;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);
    print("login response  ${response.body}");
    if (response.statusCode == 200) {
      isApiProcessing=false;

      final resp=jsonDecode(response.body);
      String status=resp['status'];

      if(status=="1"){
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => OtpScreen(mobileNumber,"IN-91")));
      }
      else if(status=="0"){
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => BtoCSignup(mobileNumber,"IN","91")));
      }
    }
    else{
      isApiProcessing=false;

      Fluttertoast.showToast(msg: response.statusCode.toString());
      if(this.mounted){
        setState(() {
        });
      }
    }
  }

  bool loginValiidation() {
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);

    // if(country_code.isEmpty || phone_code.isEmpty){
    //   Fluttertoast.showToast(msg: 'Please select country code');
    //   return false;
    // }
     if(_mobileController.text.isEmpty){
      Fluttertoast.showToast(msg: 'Please enter mobile number');
      return false;
    }
    else if(_mobileController.text.length<10){
      Fluttertoast.showToast(msg: 'Please enter valid mobile no.');
      return false;
    }

    return true;
  }

  void getBaseUrl() async {
    // SharedPreferences prefs= await SharedPreferences.getInstance();
    // String? adminId =prefs.getString('admin_auto_id');
    //
    // if(adminId!=null){
    //   this.admin_auto_id=adminId;
    //   setState(() {});
    // }
  }
}

