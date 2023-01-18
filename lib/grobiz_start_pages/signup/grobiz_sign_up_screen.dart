import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Home/Home_Screen.dart';
import 'package:poultry_a2z/Utils/AppConfig.dart';
import 'package:poultry_a2z/Utils/theme.dart';
import 'package:poultry_a2z/grobiz_start_pages/signup/sign_up_response.dart';
import 'package:poultry_a2z/grobiz_start_pages/welcome/welcome_page.dart';
import '../../Utils/App_Apis.dart';
import '../../Utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GrobizSignup extends StatefulWidget {
  @override
  _GrobizSignup createState() => _GrobizSignup();

  GrobizSignup();
}

class _GrobizSignup extends State<GrobizSignup> {
  bool isCheck = false, isCheck1 = false;

  TextEditingController _nameController=new TextEditingController();
  TextEditingController _emailController=new TextEditingController();
  TextEditingController _passwordController=new TextEditingController();

  String token='';

  final formGlobalKey = GlobalKey < FormState > ();
  bool isSignUpApiprocessing=false,isSendOtpApiProcessing=false,isVerifyOtpApiProcessing=false,isOtpSend=false,isOtpVerified=false;

  // String baseUrl='';

  bool showCity=false;

  FocusNode _focus = FocusNode();

  String user_type='Admin';
  String app_base_url='https://grobiz.app/GRBCRM2022/PoultryEcommerce/';

  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;

  bool _passwordVisible=false;

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

  saveAppBaseUrl() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('base_url',app_base_url);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateFirebaseToken();
    saveAppBaseUrl();
    getappUi();
  }

  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  initWidget() {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    //color: primaryButtonColor,
                  ),
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 70),
                            child: Image.asset(
                              "assets/app_logo.png",
                              height: 150,
                              width: 150,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 20, top: 20),
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "Sign Up",
                              style: TextStyle(fontSize: 35, color: primaryButtonColor,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )),
                ),

                /* Container(
                    margin: EdgeInsets.only(top: 40, left: 10,bottom: 30),
                    alignment: Alignment.center,
                    child: Text(
                      "Sign-Up",
                      style: TextStyle(fontSize: 30, color: primaryButtonColor,fontWeight: FontWeight.bold),
                    ),
                  ),*/
                formUi()

              ],
            )));
  }

  bool isNameValid(String name) {
    if(name.isEmpty){
      return false;
    }
    return true;
  }

  bool isEmailValid(String email) {
    if(email.isEmpty){
      return false;
    }
    else if(!emailValidatorRegExp.hasMatch(email)){
      return false;
    }
    return true;
  }

  bool isPasswordValid(String password) {
    if(password.isEmpty){
      return false;
    }
    return true;
  }

  Widget formUi() {
    return Container(
      margin: EdgeInsets.only(right: 20, top: 20, left: 20),
      child: Form(
        key: formGlobalKey,
        child: Column(
          children: [
            Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name", style: TextStyle(fontSize: 16, color: Colors.black)),
                    SizedBox(height: 10,),
                    Container(
                      child: Container(
                        child:
                        TextFormField(
                          controller: _nameController,
                          validator: (name) {
                            if (isNameValid(name!)) return null;
                            else
                              return 'Please enter your name';
                          },
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                              hintText: 'Please enter your name',

                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              )

                          ),
                          // style: AppTheme.form_field_text,
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ),
                  ],

                )
            ),
            SizedBox(height: 20.0),

            Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email Id", style: TextStyle(fontSize: 16, color: Colors.black)),
                    SizedBox(height: 10,),
                    Container(
                      child: Container(
                        child:
                        TextFormField(
                          controller: _emailController,
                          validator: (email) {
                            if (isEmailValid(email!)) return null;
                            else return 'Please enter valid email id';
                          },
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                              hintText: 'Please enter your email id',

                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              )

                          ),
                          // style: AppTheme.form_field_text,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ),
                  ],

                )
            ),
            SizedBox(height: 20.0),

            Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Password", style: TextStyle(fontSize: 16, color: Colors.black)),
                    SizedBox(height: 10,),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child:
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: _passwordVisible,
                                validator: (password) {
                                  if (isPasswordValid(password!)) return null;
                                  else return 'Please enter password';
                                },
                                keyboardType: TextInputType.visiblePassword,
                                autocorrect: true,
                                textAlign: TextAlign.left,
                                cursorColor: Color(0xffF5591F),
                                decoration: InputDecoration(
                                    suffixIcon:IconButton(
                                      icon: _passwordVisible==true?
                                      Icon(Icons.visibility_off):
                                      Icon(Icons.visibility),
                                      onPressed: ()=>{
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        })
                                      },
                                    ),

                                    contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                                    hintText: "Please enter password",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],


                )
            ),
            SizedBox(height: 40.0),

            isSignUpApiprocessing==true?
            Container(
              height: 60,
              alignment: Alignment.center,
              width: 80,
              child: GFLoader(
                  type:GFLoaderType.circle
              ),
            ):
            GestureDetector(
              onTap: () {
                if (formGlobalKey.currentState!.validate()) {
                  signUpApi();
                }
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 10, right: 10),

                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primaryButtonColor,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 50,
                        color: Color(0xffEEEEEE)),
                  ],
                ),
                child: Text(
                  "SIGN UP",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future signUpApi() async {
    setState(() {
      isSignUpApiprocessing=true;
    });

    print('1');

    final body = {
      "name":_nameController.text,
      "email":_emailController.text,
      "password":_passwordController.text,
      "token" : token,
    };

    //print(body.toString());
    var url=AppConfig.grobizBaseUrl+sign_up_grobiz_ecomemrce;
    print(url.toString());

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);
    print(response.toString());

    if (response.statusCode == 200) {
      print(response.statusCode.toString());
      isSignUpApiprocessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];

      if(status==1){
        SignUpResponse signUpResponse=SignUpResponse.fromJson(json.decode(response.body));

        print('sign up success');

        String user_auto_id=signUpResponse.profile.id;
        Fluttertoast.showToast(msg: "You have signed up successfully", backgroundColor: Colors.grey,);
        saveLoginSession(user_auto_id,user_type);

        if(this.mounted){
          setState(() {});
        }
      }
      else {
        String msg=resp['msg'];
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
        if(this.mounted){
          setState(() {});
        }
      }
    }
    else if(response.statusCode==500){
      print(response.statusCode.toString());
      isSignUpApiprocessing=false;
      Fluttertoast.showToast(msg: "Server Error", backgroundColor: Colors.grey,);

      if(this.mounted){
        setState(() {});
      }
    }
  }

  Future<void> saveLoginSession(String user_auto_id, String user_type) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();

    prefs.setBool('is_login', true);
    prefs.setString('user_id', user_auto_id);
    prefs.setString('user_type', user_type);
    prefs.setString('admin_auto_id', user_auto_id);

    print("set");

    Navigator.popUntil(context, ModalRoute.withName("/"));
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => WelcomePage()),);
  }


  void generateFirebaseToken() async{
    final fcmToken = await FirebaseMessaging.instance.getToken();

    if(fcmToken != null){
      token = fcmToken;
      print('token: '+ token);
      if(this.mounted){
        setState(() {
        });
      }
    }
  }

}
