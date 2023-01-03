import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/FirebaseSetup/setup_notifcations.dart';
import 'package:poultry_a2z/Home/Home_Screen.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/Utils/size_config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';

class OtpScreen extends StatefulWidget {
  String mobile_number;
  String country_code;


  OtpScreen(this.mobile_number,this.country_code);

  @override
  _OtpScreen createState() => _OtpScreen(mobile_number,country_code);

}

class _OtpScreen extends State<OtpScreen> {
  _OtpScreen(this.mobile_number,this.country_code);

  String mobile_number;
  String country_code;

  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  String otp='',token='';
  String val_one='',val_two='',val_three='',val_four='';
  String app_base_url='https://grobiz.app/GRBCRM2022/PoultryEcommerce/';
  bool isVerifyOtpApiProcessing=false,isResendApiProcessing=false;

  String admin_auto_id='63b2612f9821ce37456a4b31';

  late Timer _timer;
  int _start = 40;
  bool showTimer=true;
  bool showResendButton=false;

  Color appBarColor=Colors.white,appBarIconColor=Colors.black, primaryButtonColor=Colors.orange, secondaryButtonColor=Colors.orangeAccent;

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

    print('appbar '+this.appBarColor.value.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateFirebaseToken();
    getappUi();
    getBaseUrl();

    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      /* appBar: AppBar(
        title: const Text("OTP Verification"),
      ),*/
      body:SafeArea(
        child: SingleChildScrollView(
          child:
          Column(
            children: [
              SizedBox(height: 100),
              Text(
                "OTP Verification",
                style: headingStyle,
              ),
              const SizedBox(height: 10),
              Text("OTP have been sent to "+mobile_number),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: TextFormField(
                      autofocus: true,
                      // obscureText: true,
                      style: const TextStyle(fontSize: 20),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        val_one=value;
                        nextField(value, pin2FocusNode);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: TextFormField(
                      focusNode: pin2FocusNode,
                      // obscureText: true,
                      style: const TextStyle(fontSize: 20),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value){
                        val_two=value;
                        nextField(value, pin3FocusNode);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: TextFormField(
                      focusNode: pin3FocusNode,
                      // obscureText: true,
                      style: const TextStyle(fontSize: 20),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value){
                        val_three=value;
                        nextField(value, pin4FocusNode);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: TextFormField(
                      focusNode: pin4FocusNode,
                      // obscureText: true,
                      style: const TextStyle(fontSize: 20),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        val_four=value;
                        if (value.length == 1) {
                          pin4FocusNode!.unfocus();
                          // Then you need to check is the code is correct or not
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),

              isResendApiProcessing==true?
              Container(
                margin: EdgeInsets.only(bottom: 20),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ):
              showResendButton==true?
              GestureDetector(
                onTap: () {
                  resendOtpApi();
                },
                child: const Text(
                  "Resend OTP Code",
                  style: TextStyle(decoration: TextDecoration.underline,fontSize: 16, fontWeight: FontWeight.bold,color:
                  Colors.blue),
                ),
              ):
              showTimer==true?
              buildTimer():
              Container(),

              /*  isResendApiProcessing==true?
              Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ):
              GestureDetector(
                onTap: () {
                  resendOtpApi();
                },
                child: const Text(
                  "Resend OTP Code",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              //  SizedBox(height: 15),
*/
              isVerifyOtpApiProcessing==true?
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
                  if(validationOtp()){
                    verifySignUpOtpApi();
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(15),

                  height: 40,
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
                    "Verify",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Resend OTP in " , style: TextStyle(fontSize: 14),),
        TweenAnimationBuilder(
          onEnd: ()=>{
            if(this.mounted){
              setState(() {
                print('0000');
                showTimer=false;
                showResendButton=true;
              })
            }
          },
          tween: Tween(begin: 40.0, end: 0.0),
          duration: const Duration(seconds: 40),
          builder: (_, dynamic value, child) => Text(
            "00:${value.toInt()}",
            style: const TextStyle(color: Colors.blue,fontSize: 17,fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future resendOtpApi() async {
    setState(() {
      isResendApiProcessing=true;
    });

    final body = {
      "mobile_number":mobile_number,
      "country_code":country_code,
      "admin_auto_id":admin_auto_id,
    };

    print(body.toString());

    var url=app_base_url+'api/'+send_login_otp;

    print(url.toString());

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      isResendApiProcessing=false;

      final resp=jsonDecode(response.body);

      print(resp.toString());

      String status=resp['status'];
      if(status=="1"){
        showTimer=true;
        showResendButton=false;
        Fluttertoast.showToast(msg: 'OTP has been sent to your mobile number', backgroundColor: Colors.grey,);
      }
      else{
        String msg=resp['msg'];
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
      }
      if(this.mounted){
        setState(() {});
      }

    }
    else{
      isResendApiProcessing=false;
      Fluttertoast.showToast(msg: 'Server error: '+response.statusCode.toString(), backgroundColor: Colors.grey,);
      if(this.mounted){
        setState(() {});
      }
    }

/*
    if (response.statusCode == 200) {
      isResendApiProcessing=false;

      final resp=jsonDecode(response.body);
      String status=resp['status'];

      if(status=="1"){

      }
      else {
        String msg=resp['msg'];
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
      }
    }
*/
  }

  bool validationOtp(){
    otp=val_one+val_two+val_three+val_four;

    if(otp.isEmpty){
      Fluttertoast.showToast(msg: "Please enter otp", backgroundColor: Colors.grey,);
      return false;
    }
    else if(otp.length<4){
      Fluttertoast.showToast(msg: "Please enter valid otp", backgroundColor: Colors.grey,);
      return false;
    }
    return true;
  }

  Future verifySignUpOtpApi() async {
    setState(() {
      isVerifyOtpApiProcessing=true;
    });

    final body = {
      "mobile_number":mobile_number,
      "otp":otp,
      "token":token,
      "country_code":country_code,
      "admin_auto_id":admin_auto_id,
    };
    print(body.toString());

    var url=app_base_url+'api/'+login;
    print('baseurl'+url);
    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    print("B to c sign up OTP verify ${response.body}");
    if (response.statusCode == 200) {
      isVerifyOtpApiProcessing=false;

      final resp=jsonDecode(response.body);
      String status=resp['status'];

      if(status=="1"){
        print(resp.toString());
        // Fluttertoast.showToast(msg: 'Signed in successfully', backgroundColor: Colors.grey,);
        String userAutoId=resp['user_id'];
        String userType=resp['user_type'];
        String admin_auto_id=resp['admin_auto_id'];
        String category_id=resp['category_id'];
        saveLoginSession(userAutoId,userType,admin_auto_id,category_id);
      }
      else {
        String msg=resp['msg'];
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
      }

      setState(() {});
    }
  }

  Future<void> saveLoginSession(String userAutoId, String userType, String admin_auto_id, String category_id) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();

    prefs.setBool('is_login', true);
    prefs.setString('user_id', userAutoId);
    prefs.setString('user_type', userType);
    prefs.setString('admin_auto_id', admin_auto_id);
    prefs.setString('app_type_id',category_id);
    print("userType "+userType);
    print("app type id "+ category_id);
    print("set");

    Fluttertoast.showToast(msg: "Signed in successfully", backgroundColor: Colors.grey,);

    Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (Route<dynamic> route) => false);
  }

  void getBaseUrl() async {
    // SharedPreferences prefs= await SharedPreferences.getInstance();
    // //String? baseUrl =prefs.getString('base_url');
    // String? adminId =prefs.getString('admin_auto_id');
    //
    // if( adminId!=null){
    //   this.admin_auto_id=adminId;
    //   //this.app_base_url=baseUrl;
    //   //print('baseurl'+baseUrl);
    //   print('adminid'+admin_auto_id);
    //   setState(() {});
    // }
  }

  void generateFirebaseToken() async{
    final fcmToken = await FirebaseMessaging.instance.getToken();

    if(fcmToken != null){
      token = fcmToken;
      // print('token: '+ token);
      if(this.mounted){
        setState(() {
        });
      }
    }
  }
}
