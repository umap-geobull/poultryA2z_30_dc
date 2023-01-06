import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/Rest_Apis.dart';
import 'package:poultry_a2z/AppUi/app_ui_model.dart';
import 'package:poultry_a2z/Home/Home_Screen.dart';
import 'package:poultry_a2z/grobiz_start_pages/forgot_password/forgot_password.dart';
import 'package:poultry_a2z/grobiz_start_pages/signup/grobiz_sign_up_screen.dart';
import 'package:poultry_a2z/grobiz_start_pages/login/login_response.dart';
import 'package:poultry_a2z/grobiz_start_pages/welcome/welcome_page.dart';
import '../../Utils/AppConfig.dart';
import '../../Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/constants.dart';


class GrobizLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GrobizLogin();
}

class _GrobizLogin extends State<GrobizLogin> {
  TextEditingController _emailController=new TextEditingController();
  TextEditingController _passwordController=new TextEditingController();
  String token='';

  bool isApiProcessing=false;
  final _formKey = GlobalKey < FormState > ();
  String app_base_url='https://grobiz.app/GRBCRM2022/PoultryEcommerce/';

  String error_msg="";

  String user_type='Admin';

  bool _passwordVisible=false;

  String super_id='6306fc8918573a0e5ba5a218';

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

    if(this.mounted){
      setState(() {});
    }
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
    return Scaffold(
        body: SingleChildScrollView(
            child:
            Column(
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
                              "Login",
                              style: TextStyle(fontSize: 35, color: primaryButtonColor,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )),
                ),
                SizedBox(height: 40.0),

                Container(
                  padding: EdgeInsets.only(left: 15,right: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Email Id", style: TextStyle(fontSize: 16, color: Colors.black)),
                                SizedBox(height: 10,),
                                Container(
                                  height: 45,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height,
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
                                        height: 45,
                                        child:
                                        Container(
                                          height: MediaQuery.of(context).size.height,
                                          margin: EdgeInsets.only(right: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: TextFormField(
                                            controller: _passwordController,
                                            validator: (password) {
                                              if (isPasswordValid(password!)) return null;
                                              else return 'Please enter password';
                                            },
                                            keyboardType: TextInputType.visiblePassword,
                                            autocorrect: true,
                                            textAlign: TextAlign.left,
                                            obscureText: _passwordVisible,
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
                        SizedBox(height: 20.0),

                        isApiProcessing==true?
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
                            if(chechValidations()==true){
                              signUpApi();
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 20, right: 20,top: 30, bottom: 20),
                            padding: EdgeInsets.only(left: 20, right: 20),
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
                              "LOGIN",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't Have Any Account?  "),
                              GestureDetector(
                                child: Text(
                                  "Sign Up Now",
                                  style: TextStyle(color: secondaryButtonColor),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => GrobizSignup()),
                                  );
                                },
                              )
                            ],
                          ),
                        ),

                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 10),
                          child: TextButton(
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(color: secondaryButtonColor,fontSize: 17),
                            ),
                            onPressed: ()=> {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()),
                              )
                            },
                          )
,
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
        )
    );
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

  bool chechValidations(){
    if(_emailController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please enter email id", backgroundColor: Colors.grey,);
      return false;
    }
    else if(!emailValidatorRegExp.hasMatch(_emailController.text)){
      Fluttertoast.showToast(msg: "Please enter valid email id", backgroundColor: Colors.grey,);
      return false;
    }
    else if(_passwordController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please enter password", backgroundColor: Colors.grey,);
      return false;
    }
    // else if(_passwordController.text.length<8){
    //   Fluttertoast.showToast(msg: "Password must be atleast 8 characters", backgroundColor: Colors.grey,);
    //   return false;
    // }

    return true;
  }

  Future signUpApi() async {
    setState(() {
      isApiProcessing=true;
    });

    final body = {
      "email":_emailController.text,
      "password":_passwordController.text,
      "token" : token,
    };

    print(token);
    var url=AppConfig.grobizBaseUrl+login_grobiz_ecommerce;
    var uri = Uri.parse(url);
    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      isApiProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        String user_auto_id=loginResponse.profile[0].id;
        String app_type=loginResponse.profile[0].appType;
        String categoryId=loginResponse.profile[0].categoryId;

        Fluttertoast.showToast(msg: "You have logged in successfully", backgroundColor: Colors.grey,);

        getAppUiDetails(user_auto_id,user_type,app_type,categoryId);

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
      isApiProcessing=false;
      Fluttertoast.showToast(msg: "Server Error", backgroundColor: Colors.grey,);

      if(this.mounted){
        setState(() {});
      }
    }
  }

  Future<void> saveLoginSession(String user_auto_id, String user_type,String app_type,String categoryId) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();

    prefs.setBool('is_login', true);
    prefs.setString('user_id', user_auto_id);
    prefs.setString('user_type', user_type);
    prefs.setString('app_type', app_type);
    prefs.setString('admin_auto_id', user_auto_id);
    prefs.setString('app_type_id',categoryId);

    if(app_type!=null && app_type.isNotEmpty){
      Navigator.popUntil(context, ModalRoute.withName("/"));
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));

      //Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (Route<dynamic> route) => false);
    }
    else{
      Navigator.popUntil(context, ModalRoute.withName("/"));
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => WelcomePage()));
    }
  }

  Future getAppUiDetails(String user_auto_id, String user_type,String app_type,String categoryId ) async {
    Rest_Apis restApis = Rest_Apis();

    restApis.getAppUi(user_auto_id,app_base_url).then((value) {
      if (value != null) {

        AppUiModel appUiModel=value;

        if(appUiModel!=null && appUiModel.status==1){
          List<AllAppUiStyle> appUiStyle=appUiModel.allAppUiStyle!;

          saveAppUiSession(appUiStyle, user_auto_id, user_type, app_type,categoryId);
        }
      }
    });
  }

  Future<void> saveAppUiSession(List<AllAppUiStyle> appUiStyle, String user_auto_id,
      String user_type,String app_type,String categoryId) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();

    if(appUiStyle[0].appbarColor.isNotEmpty){
      prefs.setString('appbarColor', appUiStyle[0].appbarColor);
    }

    if(appUiStyle[0].appbarIconColor.isNotEmpty){
      prefs.setString('appbarIconColor', appUiStyle[0].appbarIconColor);
    }

    if(appUiStyle[0].bottomBarColor.isNotEmpty){
      prefs.setString('bottomBarColor', appUiStyle[0].bottomBarColor);
    }

    if(appUiStyle[0].bottomBarIconColor.isNotEmpty){
      prefs.setString('bottomBarIconColor', appUiStyle[0].bottomBarIconColor);
    }

    if(appUiStyle[0].loginRegisterButtonColor.isNotEmpty){
      prefs.setString('primaryButtonColor', appUiStyle[0].loginRegisterButtonColor);
    }

    if(appUiStyle[0].addToCartButtonColor.isNotEmpty){
      prefs.setString('secondaryButtonColor', appUiStyle[0].addToCartButtonColor);
    }

    if(appUiStyle[0].showLocationOnHomescreen.isNotEmpty){
      prefs.setString('showLocationOnHomescreen', appUiStyle[0].showLocationOnHomescreen);
    }

    saveLoginSession(user_auto_id, user_type, app_type,categoryId);
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

