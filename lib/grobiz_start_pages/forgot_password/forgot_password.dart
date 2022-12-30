import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/grobiz_start_pages/login/grobiz_login.dart';
import '../../Utils/AppConfig.dart';
import '../../Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/constants.dart';


class ForgotPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ForgotPassword();
}

class _ForgotPassword extends State<ForgotPassword> {
  TextEditingController _emailController=new TextEditingController();

  bool isApiProcessing=false;
  final _formKey = GlobalKey < FormState > ();

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

    getappUi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.white,
      title: Text('Forgot Password',
          style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold)),
      leading: IconButton(
        onPressed: () => {Navigator.of(context).pop()},
        icon: Icon(Icons.arrow_back, color: Colors.black),
      ),
    ),
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
                              "Forgot Password",
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
                              forgotPasswordApi();
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
                              "SEND",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
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

  bool chechValidations(){
    if(_emailController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please enter email id", backgroundColor: Colors.grey,);
      return false;
    }
    else if(!emailValidatorRegExp.hasMatch(_emailController.text)){
      Fluttertoast.showToast(msg: "Please enter valid email id", backgroundColor: Colors.grey,);
      return false;
    }
    return true;
  }

  Future forgotPasswordApi() async {
    setState(() {
      isApiProcessing=true;
    });

    final body = {
      "email":_emailController.text,
    };

    var url=AppConfig.grobizBaseUrl+forgot_password;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      isApiProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];

      if(status==1){
        passwordChangedAlert();
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

  void passwordChangedAlert() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.yellow[50],
        title: Text('Password recovered successfully'),
        content:Wrap(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  const Text('Please login using new password shared on your registered email id',style: TextStyle(color: Colors.black54),),
                ],
              ),
            )
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => GrobizLogin()));
            },
            child: const Text("Ok",
                style: TextStyle(color: Colors.white,fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(70,30),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
              ),
            ),
          )
        ],),
    );
  }

}

