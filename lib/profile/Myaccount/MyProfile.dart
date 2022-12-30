import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/App_Apis.dart';
import 'Myprofile_model.dart';

class MyProfile extends StatefulWidget {
  @override
  State<MyProfile> createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile> {
  String baseUrl='';
  late MyProfile_model profile_model;
  TextEditingController tv_name = TextEditingController();
  TextEditingController tv_email = TextEditingController();
  TextEditingController tv_mobile = TextEditingController();
  String user_id='';
  String user_type='';
  String admin_auto_id='';
  bool isApiCallProcessing=false;

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
  }

  @override
  void initState() {
    super.initState();
    getappUi();
    getUserId();
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? userType =prefs.getString('user_type');
    String? baseUrl =prefs.getString('base_url');
    String? adminId =prefs.getString('admin_auto_id');

    if(userId!=null && baseUrl!=null && adminId!=null){
      if(mounted){
        setState(() {
          this.user_id=userId;
          this.admin_auto_id=adminId;
          this.baseUrl=baseUrl;

          GetProfileData();

        });
      }
    }
    return null;
  }

  Future<void> _onSave() async {
    final name = tv_name.text;
    final mobile = tv_mobile.text;
    final email = tv_email.text;
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "user_auto_id":user_id,
      "name": name,
      "mobile_number":mobile,
      "email_id":email,
      "admin_auto_id":admin_auto_id,
    };

    var url = baseUrl+'api/' + update_user_profile;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        Fluttertoast.showToast(
          msg: "Profile Updated successfully",
          backgroundColor: Colors.grey,
        );
        Navigator.pop(context);
      }
      else {
        print('empty');
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  GetProfileData() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    var url = baseUrl+'api/' + get_user_profile;

    Uri uri=Uri.parse(url);

    final body = {
      "user_auto_id": user_id,
    };
    var response = await http.post(uri, body: body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {

      profile_model = MyProfile_model.fromJson(json.decode(response.body));
      var userDataList = profile_model.data;
      var status =profile_model.status;
      print(status);
      if(status=='1') {
        tv_name.text = userDataList.name;
        tv_email.text = userDataList.emailId;
        tv_mobile.text = userDataList.mobileNumber;
        admin_auto_id=userDataList.admin_auto_id!;
        setState(() {
          isApiCallProcessing = false;
        });
      }else{
        print('Data not available');
      }
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: appBarIconColor,),
          onPressed: ()=>{Navigator.pop(context)},
        ),
        title: Text('My Profile',style: TextStyle(color: appBarIconColor),),
        backgroundColor: appBarColor,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  width: 450,
                  height: 200,
                  child: Card(
                      margin: const EdgeInsets.only(
                          top: 45, left: 120, right: 120, bottom: 45),
                      shape: CircleBorder(),
                      child: Icon(Icons.person_outline_rounded,size: 100,color: primaryButtonColor,)),
                ),
                Container(
                  height: 50,
                  margin:
                      const EdgeInsets.only(top: 20, bottom: 5, left: 30, right: 30),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  // decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
                  child: TextField(
                    maxLines: 1,
                    controller: tv_name,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w300,
                        backgroundColor: Colors.white),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.verified_user),
                      labelStyle: TextStyle(color: Colors.black, height: 3),
                      hintText: "Full Name",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      contentPadding: EdgeInsets.only(
                          left: 14.0, bottom: 18.0, top: 15.0),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  margin:
                      const EdgeInsets.only(top: 20, bottom: 5, left: 30, right: 30),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  // decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
                  child: TextField(
                    controller: tv_email,
                    style: const TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w300,
                        backgroundColor: Colors.white),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelStyle: TextStyle(color: Colors.black, height: 3),
                      hintText: "Email",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      contentPadding: EdgeInsets.only(
                          left: 14.0, bottom: 18.0, top: 15.0),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  margin:
                      const EdgeInsets.only(top: 20, bottom: 5, left: 30, right: 30),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  // decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
                  child: TextField(
                    maxLines: 1,
                    controller: tv_mobile,
                    style: const TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w300,
                        backgroundColor: Colors.white),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.call),
                      labelStyle: TextStyle(color: Colors.black, height: 3),
                      hintText: "Mobile No.",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      contentPadding: EdgeInsets.only(
                          left: 14.0, bottom: 18.0, top: 15.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 50.0,
                  width: 150,
                  child: Container(
                    child: ElevatedButton(
                      onPressed: () {
                        _onSave();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryButtonColor,
                        shadowColor: primaryButtonColor,
                        elevation: 5,
                      ),
                      child: const Text('Save Details'),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
