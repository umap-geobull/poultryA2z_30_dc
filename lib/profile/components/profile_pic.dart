import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Utils/App_Apis.dart';
import '../Myaccount/Myprofile_model.dart';

class ProfilePic extends StatefulWidget {
  // const ProfilePic({
  //   Key? key,
  // }) : super(key: key);

  @override
  State<ProfilePic> createState() => ProfilePicState();
}

class ProfilePicState extends State<ProfilePic>{
  String baseUrl='';
  late MyProfile_model profile_model;
  late String cust_name="loading", cust_email="loading", cust_mobile="loading";
  String user_id='';
  String user_type='';
  bool isApiCallProcessing=false;

  @override
  void initState() {
    getUserId();
    super.initState();
  }
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? userType =prefs.getString('user_type');
    String? baseUrl =prefs.getString('base_url');

    if(userId!=null && userType!=null){
      user_id=userId;
      user_type=userType;

      if(mounted){
        setState(() {});
      }
    }
    if (baseUrl!=null) {
      if(mounted){
        setState(() {
          this.baseUrl=baseUrl;

          GetProfileData();
        });
      }
    }
    return null;
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
        cust_name = userDataList.name;
        cust_email = userDataList.emailId;
        cust_mobile = userDataList.mobileNumber;
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
    return isApiCallProcessing==false?
    SizedBox(
      height: 115,
      width: MediaQuery.of(context).size.width,
      child: Container(
          height: 200,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/bgaccount.png"),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          margin: const EdgeInsets.only(top: 0, left: 2, right: 2, bottom: 2),
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MyProfile()),
              // );
            },
            child: Container(
              // margin: EdgeInsets.all(5),
              //   color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      // width: 250,
                      // height: 200,
                      // margin: EdgeInsets.only(top: 20),
                      // color: Colors.white,
                      child: Card(
                          margin: const EdgeInsets.only(
                              top: 0, left: 20, right: 30, bottom: 0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80)),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.asset('assets/myprofile.png'),
                          )),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          cust_name,
                          softWrap: true,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          cust_mobile,
                          softWrap: true,
                          style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                        Text(
                          cust_email,
                          softWrap: true,
                          style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ],),
                  ],
                )),
          )),
    ):Container();
  }
}
