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


class Verify_Razorpay_Merchant extends StatefulWidget {

  @override
  _Verify_Razorpay_Merchant createState() => _Verify_Razorpay_Merchant();
}

class _Verify_Razorpay_Merchant extends State<Verify_Razorpay_Merchant> {

  TextEditingController merchant_nameController=TextEditingController();
  TextEditingController razorpay_keyController=TextEditingController();
  String PAYMENT_GATEWAY_NAME="RazorPay";
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
                              Image.asset("assets/razorpaylogo.png"),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text("Merchant Name",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        child: TextFormField(
                          controller: merchant_nameController,
                          decoration: InputDecoration(
                              filled: true,
                              hintText: "Enter the merchant name",
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
                      const Text("Razorpay Key",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                          child: TextFormField(
                            controller: razorpay_keyController,
                            decoration: InputDecoration(
                                filled: true,
                                hintText: "Enter Razorpay Key",
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
                            // style: AppTheme.form_field_text,

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
            )
        )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
  }

  bool validations(){
    if(merchant_nameController.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please enter merchant name",
      );
      print('false');
      return false;
    }
    else if(razorpay_keyController.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please enter razorpay key",
      );
      print('false');
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

        razorpay_keyController.text=adminProfile[0].razorpayKey;
        merchant_nameController.text=adminProfile[0].merchantName;
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
      "mobile_number":adminProfile[0].mobileNumber,
      "country":adminProfile[0].country,
      "city":adminProfile[0].city,
      "name":adminProfile[0].name,
      "email_id":adminProfile[0].emailId,
      "app_type_id":adminProfile[0].appType,
      "app_logo":adminProfile[0].appLogo,
      "payment_gateway_name":PAYMENT_GATEWAY_NAME,
      "merchant_name":merchant_nameController.text,
      "razorpay_key":razorpay_keyController.text,
      "client_id":adminProfile[0].clientId,
      "secret_key":adminProfile[0].secretKey,
    };

    // //print(body.toString());

    var url=AppConfig.grobizBaseUrl+update_profile;

    //print(url);

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

        savePaymentDetails(
            PAYMENT_GATEWAY_NAME,
            adminProfile[0].clientId,
            adminProfile[0].secretKey,
            merchant_nameController.text,
            razorpay_keyController.text);

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

  Future savePaymentDetails(String payment_gateway_name,
      String clientd, String secretkey, String marchant_name,String razorpay_key) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('payment_gateway_name', payment_gateway_name );
    prefs.setString('clientd', clientd );
    prefs.setString('secretkey', secretkey );
    prefs.setString('marchant_name', marchant_name );
    prefs.setString('razorpay_key', razorpay_key );
    print('session set');
  }


}
