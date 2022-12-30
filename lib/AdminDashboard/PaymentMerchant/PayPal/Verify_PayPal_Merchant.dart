
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/AppConfig.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/grobiz_start_pages/profile/admin_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


class Verify_PayPal_Merchant extends StatefulWidget {
  @override
  _Verify_PayPal_Merchant createState() => _Verify_PayPal_Merchant();
}

class _Verify_PayPal_Merchant extends State<Verify_PayPal_Merchant> {

  TextEditingController clientIdController=TextEditingController();
  TextEditingController secretkeyController=TextEditingController();
  String PAYMENT_GATEWAY_NAME="PayPal";
  bool isApiCallProcessing=false;
  List<Data> adminProfile=[];
  String baseUrl='', admin_auto_id='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text("Verify",
              style: TextStyle(color: appBarIconColor, fontSize: 16)),
          leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: const Icon(Icons.arrow_back, color: appBarIconColor),
          ),
        ),

        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text('Please enter your payment gateway details',style: TextStyle(color: Colors.black87,fontSize: 15),),

                  SizedBox(
                    height: 115,
                    width: 135,
                    child: Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.expand,
                      children: [
                              Image.asset("assets/paypal_logo1.png"),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text("ClientId",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        child: TextFormField(
                        controller: clientIdController,
                        decoration: InputDecoration(
                            filled: true,
                            hintText: "Enter the ClientId",
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.blue, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            )),
                          minLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          maxLines: null,
                        // style: AppTheme.form_field_text,
                      ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("Secret Key",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                          child: TextFormField(
                            controller: secretkeyController,
                            decoration: InputDecoration(
                                filled: true,
                                hintText: "Enter Secret Key",
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.blue, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            minLines: null,
                            textAlignVertical: TextAlignVertical.top,
                            maxLines: null,
                          )
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: kPrimaryColor,
                                    textStyle: const TextStyle(fontSize: 20)),
                                onPressed: () {
                                  if(validations()==true){
                                    print('true');
                                    updateAdminProfile();
                                  }
                                },
                                child: const Center(
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                      )

                    ],
                  ),
                ],
              ),
            )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
  }

  bool validations(){
    if(clientIdController.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please enter client id",
      );
      return false;
    }
    else if(secretkeyController.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please enter secret key",
      );
      return false;
    }

    return true;
  }

  Future getAdminProfile() async {

    print('user_id: '+admin_auto_id);

    final body = {
      "user_auto_id":admin_auto_id,
    };

    var url=AppConfig.grobizBaseUrl+get_admin_profile;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);
    print(response.statusCode.toString());

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      print('admin_profile: '+status.toString());
      if(status==1){
        AdminProfileModel adminProfileModel = AdminProfileModel.fromJson(json.decode(response.body));
        adminProfile=adminProfileModel.data;

        secretkeyController.text=adminProfile[0].secretKey;
        clientIdController.text=adminProfile[0].clientId;

        if(this.mounted){
          setState(() {
          });
        }
      }

      else {
        String msg=resp['msg'];
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
      }
    }
    else if (response.statusCode == 500) {
      Fluttertoast.showToast(msg: 'Server error', backgroundColor: Colors.grey,);
      setState(() {});
    }
  }

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? adminId =prefs.getString('admin_auto_id');

    if(adminId!=null && baseUrl!=null){

      if(this.mounted){
        setState(() {
          this.baseUrl=baseUrl;
          this.admin_auto_id=adminId;
          getAdminProfile();
        });
      }
    }


  }

  updateAdminProfile() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "user_auto_id":admin_auto_id,
      "app_name": adminProfile[0].appName,
      "app_type":adminProfile[0].appType,
      "country_code":adminProfile[0].countryCode,
      "contact":adminProfile[0].contact,
      "country":adminProfile[0].country,
      "city":adminProfile[0].city,
      "name":adminProfile[0].name,
      "email":adminProfile[0].email,
      "app_type_id":adminProfile[0].appType,
      "app_logo":adminProfile[0].appLogo,
      "payment_gateway_name":PAYMENT_GATEWAY_NAME,
      "merchant_name": adminProfile[0].merchantName,
      "razorpay_key": adminProfile[0].razorpayKey,
      "client_id":clientIdController.text,
      "secret_key":secretkeyController.text,
    };

    var url=AppConfig.grobizBaseUrl+update_profile;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        Fluttertoast.showToast(
          msg: "Payment gateway details added successfully",
          backgroundColor: Colors.grey,
        );
        Navigator.pop(context);
      }
      else {
        String  msg = resp['msg'];
        Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.grey,
        );      }

      if(mounted){
        setState(() {});
      }
    }
    else if (response.statusCode == 500) {
      Fluttertoast.showToast(msg: 'Server error', backgroundColor: Colors.grey,);
      setState(() {});
    }

  }
}
