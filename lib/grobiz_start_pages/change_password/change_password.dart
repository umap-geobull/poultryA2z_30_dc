import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Utils/AppConfig.dart';
import '../../Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/constants.dart';


class ChangePassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  TextEditingController _oldPasswordController=new TextEditingController();
  TextEditingController _newPasswordController=new TextEditingController();

  bool isApiProcessing=false;
  final _formKey = GlobalKey < FormState > ();

  String admin_auto_id='';

  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;

  bool _oldPasswordVisible=false;
  bool _newPasswordVisible=false;

  void getappUi() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? appBarColor =prefs.getString('appbarColor');
    String? appbarIcon =prefs.getString('appbarIconColor');
    String? primaryButtonColor =prefs.getString('primaryButtonColor');
    String? secondaryButtonColor =prefs.getString('secondaryButtonColor');
    String? adminId =prefs.getString('admin_auto_id');

    if(adminId!=null){
      this.admin_auto_id=adminId;
    }

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
          title: Text('Change Password',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: () => {Navigator.of(context).pop()},
            icon: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        body:
        Container(
          padding: EdgeInsets.only(left: 15,right: 15,top: 50),
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,

              children: <Widget>[
                Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Old Password", style: TextStyle(fontSize: 16, color: Colors.black)),
                        SizedBox(height: 10,),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 45,
                                child:
                                Container(
                                  //height: MediaQuery.of(context).size.height,
                                  margin: EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: TextFormField(
                                    controller: _oldPasswordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    autocorrect: true,
                                    textAlign: TextAlign.left,
                                    obscureText: _oldPasswordVisible,
                                    cursorColor: Color(0xffF5591F),
                                    decoration: InputDecoration(
                                        suffixIcon:IconButton(
                                          icon: _oldPasswordVisible==true?
                                          Icon(Icons.visibility_off):
                                          Icon(Icons.visibility),
                                          onPressed: ()=>{
                                            setState(() {
                                              _oldPasswordVisible = !_oldPasswordVisible;
                                            })
                                          },
                                        ),

                                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                                        hintText: "Please enter old password",
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

                Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("New Password", style: TextStyle(fontSize: 16, color: Colors.black)),
                        SizedBox(height: 10,),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                               //height: 45,
                                child:
                                Container(
                                  //height: MediaQuery.of(context).size.height,
                                  margin: EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: TextFormField(
                                    controller: _newPasswordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    autocorrect: true,
                                    textAlign: TextAlign.left,
                                    obscureText: _newPasswordVisible,
                                    cursorColor: Color(0xffF5591F),
                                    validator: (password) {
                                      if (isPasswordValid(password!)) return null;
                                      else return 'Password should be combination of capital letters,small letters,numbers and at least one special character(any of this)(@,!-_#%^&*"/;:)';
                                    },
                                    decoration: InputDecoration(
                                        suffixIcon:IconButton(
                                          icon: _newPasswordController==true?
                                          Icon(Icons.visibility_off):
                                          Icon(Icons.visibility),
                                          onPressed: ()=>{
                                            setState(() {
                                              _newPasswordVisible = !_newPasswordVisible;
                                            })
                                          },
                                        ),

                                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                                        hintText: "Please enter new password",
                                        errorStyle: TextStyle(fontSize: 15),
                                        errorMaxLines: 4,
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
                      if(_formKey.currentState!.validate())
                      changePasswordApi();
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
                      "UPDATE PASSWORD",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  bool isPasswordValid(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r"[a-z]"))) return false;
    if (!password.contains(RegExp(r"[A-Z]"))) return false;
    if (!password.contains(RegExp(r"[0-9]"))) return false;
    if (!password.contains(RegExp(r'[@,!-_#$%^&*"/;:]'))) return false;
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

  bool chechValidations(){
    if(_oldPasswordController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please enter old password", backgroundColor: Colors.grey,);
      return false;
    }
    else if(_newPasswordController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please enter new password", backgroundColor: Colors.grey,);
      return false;
    }
    else if(_newPasswordController.text.length<8){
      Fluttertoast.showToast(msg: "New Password length must be atleast 8 characters", backgroundColor: Colors.grey,);
      return false;
    }
    return true;
  }

  Future changePasswordApi() async {
    setState(() {
      isApiProcessing=true;
    });

    final body = {
      "user_auto_id":admin_auto_id,
      "new_password":_newPasswordController.text,
      "old_password":_oldPasswordController.text,
    };

    var url=AppConfig.grobizBaseUrl+change_password;

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
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.blueGrey,);
        if(this.mounted){
          setState(() {});
        }
      }
    }
    else if(response.statusCode==500){
      isApiProcessing=false;
      Fluttertoast.showToast(msg: "Server Error", backgroundColor: Colors.blueGrey,);

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
        title: Text('Password changed successfully'),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
              Navigator.pop(context);
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

