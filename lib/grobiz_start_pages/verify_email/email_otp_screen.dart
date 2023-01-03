import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/InAppReview/check_app_review.dart';
import 'package:poultry_a2z/Utils/AppConfig.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/Utils/size_config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/grobiz_start_pages/create_dynamic_link.dart';
import 'package:poultry_a2z/grobiz_start_pages/order_history/order_history_model.dart';
import 'package:poultry_a2z/grobiz_start_pages/plans/grobiz_plans.dart';
import 'package:poultry_a2z/grobiz_start_pages/profile/admin_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Home/Home_Screen.dart';
import '../../Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';

class OtpScreen extends StatefulWidget {

  List<GetOrderHistoryList> getOrderHistoryList;
  String appName;
  File app_logo;

  OtpScreen(this.getOrderHistoryList, this.appName, this.app_logo);

  @override
  _OtpScreen createState() => _OtpScreen();

}

class _OtpScreen extends State<OtpScreen> {
  String email='';

  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  String otp='',token='';
  String val_one='',val_two='',val_three='',val_four='';

  bool isVerifyOtpApiProcessing=false,isResendApiProcessing=false;

  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;

  String admin_auto_id='';

  String message='';
  String errorMessage='';

  late Timer _timer;
  int _start = 40;
  bool showTimer=false;
  bool showResendButton=false;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserId();

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
      body:Scaffold(
        body:Container(
          child: SingleChildScrollView(
            child:
            Column(
              children: [
                SizedBox(height: 100),
                Text(
                  "OTP Verification",
                  style: headingStyle,
                ),
                SizedBox(height: 10),
                Text(message,style: TextStyle(color: Colors.black54,fontSize: 15,
                    fontWeight: FontWeight.bold),textAlign: TextAlign.center,),

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

                Text(errorMessage,style: TextStyle(color: Colors.black54,fontSize: 12,
                    fontWeight: FontWeight.bold),textAlign: TextAlign.center,),

                isResendApiProcessing==true?
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ):
                showResendButton==true?
                GestureDetector(
                  onTap: () {
                    sendOtpApi();
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

                //  SizedBox(height: 15),

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
                      verifyEmailOtpApi();
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
              showTimer=false,
              showResendButton=true,
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

  Future<void> saveLoginSession(String userAutoId, String userType) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();

    prefs.setBool('is_login', true);
    prefs.setString('user_id', userAutoId);
    prefs.setString('user_type', userType);

    print("set");

    Fluttertoast.showToast(msg: "Signed in successfully", backgroundColor: Colors.grey,);

    Navigator.of(context)
        .pushNamedAndRemoveUntil(HomeScreen.routeName, (Route<dynamic> route) => false);
  }

  void getUserId() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? adminId = prefs.getString('admin_auto_id');

    if(adminId!=null){
      this.admin_auto_id=adminId;
      setState(() {
        getAdminProfile();
      });
    }
  }

  Future getAdminProfile() async {
    setState(() {
      isResendApiProcessing=true;
    });

    final body = {
      "user_auto_id":admin_auto_id,
    };

    var url=AppConfig.grobizBaseUrl+get_admin_profile;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      isResendApiProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        AdminProfileModel adminProfileModel=AdminProfileModel.fromJson(json.decode(response.body));
        email=adminProfileModel.data[0].emailId;
        sendOtpApi();
        if(this.mounted){
          setState(() {});
        }
      }
      else {
        String msg=resp['msg'];
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
      }
    }
    else if (response.statusCode == 500) {
      isVerifyOtpApiProcessing=false;
      Fluttertoast.showToast(msg: 'Server error', backgroundColor: Colors.grey,);
      setState(() {});
    }
  }

  Future verifyEmailOtpApi() async {
    setState(() {
      isVerifyOtpApiProcessing=true;
    });

    final body = {
      "email":email,
      "otp":otp,
      "user_auto_id":admin_auto_id,
    };

    var url=AppConfig.grobizBaseUrl+verify_email_otp;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      isVerifyOtpApiProcessing=false;

      final resp=jsonDecode(response.body);
      String status=resp['status'];

      if(status=="1"){
        print(resp.toString());
        Fluttertoast.showToast(msg: 'Email verfication has been done successfully', backgroundColor: Colors.grey,);

        if(widget.getOrderHistoryList.isNotEmpty){
          shareApp();
        }
        else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GrobizPlans()));
        }
      }
      else {
        String msg=resp['msg'];
        errorMessage=msg;
        //Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
      }

      setState(() {});
    }
    else {
      isVerifyOtpApiProcessing=false;
      Fluttertoast.showToast(msg: 'Server error: '+ response.statusCode.toString(), backgroundColor: Colors.grey,);
      setState(() {});
    }
  }

  Future sendOtpApi() async {
    setState(() {
      message='Sending OTP to your registered email ID\n'+email;
      errorMessage='';
      isResendApiProcessing=true;
    });

    final body = {
      "email":email,
      "user_auto_id":admin_auto_id,
    };

    var url=AppConfig.grobizBaseUrl+send_email_verification_otp;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      isResendApiProcessing=false;

      final resp=jsonDecode(response.body);
      String status=resp['status'];

      if(status=="1"){
        message='OTP has been sent to your registered email ID\n'+email+'\n\nIf you dont receive otp, please check your spam folder';

        showTimer=true;
        showResendButton=false;
        //Fluttertoast.showToast(msg: 'OTP has been sent', backgroundColor: Colors.grey,);
      }
      else {
        String msg=resp['msg'];
        errorMessage=msg;
       // Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
      }
      if(this.mounted){
        setState(() {});
      }
    }
    else if (response.statusCode == 500) {
      isResendApiProcessing=false;
      Fluttertoast.showToast(msg: 'Server error', backgroundColor: Colors.grey,);
      if(this.mounted){
        setState(() {});
      }
    }
  }

  shareApp() async{
    ShareAppLink.shareApp(widget.appName, widget.app_logo, admin_auto_id);
  }

}
