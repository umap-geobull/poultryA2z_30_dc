import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Login/Login_Screen.dart';
import 'package:poultry_a2z/Utils/AppConfig.dart';
import 'package:poultry_a2z/grobiz_start_pages/login/select_action_welcome.dart';
import 'package:poultry_a2z/grobiz_start_pages/profile/admin_profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/App_Apis.dart';
import 'package:getwidget/getwidget.dart';


class AdminProfile extends StatefulWidget {
  @override
  State<AdminProfile> createState() => AdminProfileState();
}

class AdminProfileState extends State<AdminProfile> {
  String baseUrl='';
  TextEditingController tv_name = TextEditingController();
  TextEditingController tv_email = TextEditingController();
  TextEditingController tv_mobile = TextEditingController();
  TextEditingController tv_businessName = TextEditingController();
  String user_id='';
  String user_type='';
  String admin_auto_id='';
  bool isApiCallProcessing=false,isDeleteApiCallProcessing=false;
  String country_code = "Select",country_name='',mobile_number='';
  late AdminProfileModel adminProfileModel;

  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;

  String super_id='6306fc8918573a0e5ba5a218';

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
    String? baseUrl =prefs.getString('base_url');
    String? adminId =prefs.getString('admin_auto_id');

    if(userId!=null && baseUrl!=null && adminId!=null){
      if(mounted){
        setState(() {
          this.user_id=userId;
          this.admin_auto_id=adminId;
          this.baseUrl=baseUrl;

          getAdminProfile();

        });
      }
    }
    return null;
  }

  Future editProfileApi() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    var url=AppConfig.grobizBaseUrl+update_profile;

    print(url);

    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);

    request.fields["app_logo"] = '';
    request.fields["user_auto_id"] = user_id;
    request.fields["app_name"] = tv_businessName.text;
    request.fields["app_type"] = adminProfileModel.data[0].appType;
    request.fields["country_code"] = adminProfileModel.data[0].countryCode;
    request.fields["contact"] = adminProfileModel.data[0].contact;
    request.fields["country"] = adminProfileModel.data[0].country;
    request.fields["city"] = adminProfileModel.data[0].city;
    request.fields["name"] = tv_name.text;
    request.fields["email"] = tv_email.text;
    request.fields["app_type_id"] = adminProfileModel.data[0].appTypeId!;

    http.Response response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){

        Fluttertoast.showToast(msg: "Profile updated successfully", backgroundColor: Colors.grey,);
        Navigator.pop(context);
      }
      else{
        String message=resp['msg'];
        Fluttertoast.showToast(msg: message, backgroundColor: Colors.grey,);
      }

      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
    }
    else if(response.statusCode==500){
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
      Fluttertoast.showToast(msg: "Server Error", backgroundColor: Colors.grey,);
    }
  }

  Future deleteProfileApi() async {
    if(mounted){
      setState(() {
        isDeleteApiCallProcessing=true;
      });
    }

    var url=baseUrl+'api/'+delete_profile;

    final body={
      "admin_auto_id" : admin_auto_id,
      "customer_id" : adminProfileModel.data[0].customerId,
    };

    var uri = Uri.parse(url);

    final response = await http.post(uri, body: body );

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){

        Fluttertoast.showToast(msg: "Profile deleted successfully", backgroundColor: Colors.grey,);
        _LogoutUser();
      }
      else{
        String message=resp['msg'];
        Fluttertoast.showToast(msg: message, backgroundColor: Colors.grey,);
      }

      if(this.mounted){
        setState(() {
          isDeleteApiCallProcessing=false;
        });
      }


    }
    else if(response.statusCode==500){
      if(this.mounted){
        setState(() {
          isDeleteApiCallProcessing=false;
        });
      }
      Fluttertoast.showToast(msg: "Server Error", backgroundColor: Colors.grey,);
    }
  }

  Future getAdminProfile() async {
    setState(() {
      isApiCallProcessing=true;
    });

    print('iser_id: '+user_id);

    final body = {
      "user_auto_id":user_id,
    };

    var url=AppConfig.grobizBaseUrl+get_admin_profile;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        adminProfileModel=AdminProfileModel.fromJson(json.decode(response.body));

        tv_name.text=adminProfileModel.data[0].name;
        tv_email.text=adminProfileModel.data[0].email;
        tv_mobile.text=adminProfileModel.data[0].countryCode+ ' '+adminProfileModel.data[0].contact!;
        tv_businessName.text=adminProfileModel.data[0].appName;
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
      isApiCallProcessing=false;
      Fluttertoast.showToast(msg: 'Server error', backgroundColor: Colors.grey,);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: appBarIconColor,),
          onPressed: ()=>{Navigator.pop(context)},
        ),
        title: Text('My Profile',style: TextStyle(color: appBarIconColor),),
        backgroundColor: appBarColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 450,
              height: 200,
              decoration:const BoxDecoration(
                // image: DecorationImage(
                //     image: AssetImage("assets/bgmyaccount.jpg"), fit: BoxFit.cover),
              ),

              child: Card(
                  margin: const EdgeInsets.only(
                      top: 45, left: 120, right: 120, bottom: 45),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80)),
                  child: Image.asset('assets/myprofile.png')),
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
                    color: Colors.black,
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
                maxLines: 1,
                controller: tv_businessName,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    backgroundColor: Colors.white),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.verified_user),
                  labelStyle: TextStyle(color: Colors.black, height: 3),
                  hintText: "App Name",
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
                    color: Colors.black,
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
                enabled: false,
                maxLines: 1,
                controller: tv_mobile,
                style: const TextStyle(
                    color: Colors.grey,
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

            SizedBox(
              height: 40,
            ),

            SizedBox(
              height: 50.0,
              width: 150,
              child: Container(
                child:
                isDeleteApiCallProcessing==true?
                Container():
                isApiCallProcessing==true?
                Center(
                  child: const GFLoader(
                      type:GFLoaderType.circle
                  ),
                ):
                ElevatedButton(
                  onPressed: () {
                    if(adminProfileModel!=null){
                      if(tv_name.text.isEmpty){
                        Fluttertoast.showToast(msg: "Please enter your name", backgroundColor: Colors.grey,);
                      }
                      else if(tv_email.text.isEmpty){
                        Fluttertoast.showToast(msg: "Please enter your email id", backgroundColor: Colors.grey,);
                      }
                      else if(tv_businessName.text.isEmpty){
                        Fluttertoast.showToast(msg: "Please enter your business name", backgroundColor: Colors.grey,);
                      }
                      else{
                        editProfileApi();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: primaryButtonColor,
                    shadowColor: primaryButtonColor,
                    elevation: 5,
                  ),
                  child: const Text('Save Details'),
                ),
              ),
            ),

            SizedBox(
              height: 30,
            ),

            SizedBox(
              height: 40.0,
              width: 150,
              child: Container(
                child:
                isApiCallProcessing==true?
                Container():
                isDeleteApiCallProcessing==true?
                Center(
                  child: const GFLoader(
                      type:GFLoaderType.circle
                  ),
                ):
                ElevatedButton(
                  onPressed: () {
                    if(admin_auto_id!=null && admin_auto_id!= super_id){
                        deleteProfileApi();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red ,
                    shadowColor: Colors.grey[100],
                    elevation: 5,
                  ),
                  child: const Text('Delete Profile'),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  Future _LogoutUser() async{

    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? userType=prefs.getString('user_type');

    prefs.setBool('is_login', false);
    prefs.remove('user_id');
    prefs.remove('user_address');
    prefs.remove('user_pincode');
    prefs.remove('user_latitude');
    prefs.remove('user_longitude');
    prefs.remove('user_city');
    prefs.remove('app_type');
    prefs.remove('showLocationOnHomescreen');
    prefs.remove('payment_gateway_name');
    prefs.remove('clientd');
    prefs.remove('secretkey');
    prefs.remove('marchant_name');
    prefs.remove('razorpay_key');
    prefs.remove('payment_gateway_name');
    prefs.remove('isEditSwitched');

    if(userType!=null){
      print(userType);
      if(userType=='Admin'){
        prefs.remove('admin_auto_id');

        Future.delayed(Duration.zero, () {
          Navigator.popUntil(context, ModalRoute.withName("/"));
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectOption()));
        });

        // Navigator.push(context,  MaterialPageRoute(builder: (context) => GrobizLogin()));
      }
      else{
        Future.delayed(Duration.zero, () {
          Navigator.popUntil(context, ModalRoute.withName("/"));
          Navigator.push(context,  MaterialPageRoute(builder: (context) => LoginScreen()));
        });

      }
    }
  }

}
