import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:http/http.dart' as http;

import '../../../../Admin_add_Product/constants.dart';
import '../../../../Utils/App_Apis.dart';
import 'PrivacyPolicyModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';


class EditPrivacyPolicy extends StatefulWidget {
  final String privacyid;
  final String privacy;


  const EditPrivacyPolicy(this.privacyid, this.privacy);

  @override
  State<EditPrivacyPolicy> createState() => EditPrivacyPolicyState(privacyid,privacy);
}

class EditPrivacyPolicyState extends State<EditPrivacyPolicy> {
  late String privacy_id,privacypolicy;

  EditPrivacyPolicyState(
      this.privacy_id, this.privacypolicy);


  TextEditingController PrivacyPolicy_text = TextEditingController();
  late PrivacyPolicyModel privacyPolicyModel;

  bool isloading=false;

  String baseUrl='', admin_auto_id='';

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? userType =prefs.getString('user_type');
    String? baseUrl =prefs.getString('base_url');
    String? adminId =prefs.getString('admin_auto_id');

    if (baseUrl!=null && adminId!=null) {
      if(mounted){
        setState(() {
          this.baseUrl=baseUrl;
          this.admin_auto_id = adminId;
        });
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    getUserId();

    PrivacyPolicy_text.text=privacypolicy;
  }

  addPrivacyPolicy() async {
    if(mounted){
      setState(() {
        isloading=true;
      });
    }

    final body = {
      "id":privacy_id,
      "privacy": PrivacyPolicy_text.text,
      "admin_auto_id" : admin_auto_id,
    };

    var url = baseUrl+'api/' + add_Privacy;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri,body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isloading=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        if(mounted){
          setState(() {
            isloading=false;
            Fluttertoast.showToast(
              msg: 'Privacy policy updated successfully',
              backgroundColor: Colors.grey,
            );
            Navigator.of(context).pop();
          });
        }
      }
      else {
        String  msg = resp['msg'];
        isloading=false;
        Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.grey,
        );

        if(mounted){
          setState(() {
          });
        }
      }
    }
    else if(response.statusCode==500){
      if(mounted){
        setState(() {
          isloading=false;
          Fluttertoast.showToast(
            msg: 'Server error',
            backgroundColor: Colors.grey,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Privacy Policy", style: TextStyle(color: appBarIconColor, fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.arrow_back, color: appBarIconColor),
        ),
          actions: [
            TextButton(
              child: Text('SAVE'),
              onPressed: () {
                addPrivacyPolicy();
              },
            )
          ]

      ),
      body:Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top:10,left: 20,right: 20,bottom: 5),
                        child: TextField(
                          controller: PrivacyPolicy_text,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              border: InputBorder.none,
                              hintText: 'Please enter privacy policy'
                          ),
                          maxLines: 100,
                          style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                    ),
/*
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        addPrivacyPolicy();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orangeAccent,
                        shadowColor: Colors.orangeAccent,
                        elevation: 5,
                      ),
                      child: const Text('Save'),
                    ),)
*/

                  ]
              ),
            ),
          ),

          isloading==true?
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: const GFLoader(
                type:GFLoaderType.circle
            ),
          ):
          Container()
        ],
      ),
    );
  }
}
