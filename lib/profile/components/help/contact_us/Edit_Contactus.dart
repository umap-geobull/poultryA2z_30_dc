import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../../../Admin_add_Product/constants.dart';
import '../../../../Utils/App_Apis.dart';

class Edit_Contactus extends StatefulWidget {
  late final String contact_id;
  late final String contact_no;
  late final String contact_email;
  late final String contact_add;


  Edit_Contactus(
      this.contact_id, this.contact_no, this.contact_email, this.contact_add);

  @override
  State<Edit_Contactus> createState() => Edit_ContactusState();
}
class Edit_ContactusState extends State<Edit_Contactus> {

  TextEditingController tv_address = TextEditingController();
  TextEditingController tv_email = TextEditingController();
  TextEditingController tv_mobile = TextEditingController();
  //late String contactid="", contactno='Loading...', contactemail='Loading...',contactadd='Loading...';
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

    tv_mobile.text = widget.contact_no;
    tv_email.text = widget.contact_email;
    tv_address.text = widget.contact_add;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Contact Us", style: TextStyle(color: appBarIconColor, fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.arrow_back, color: appBarIconColor),
        ),

      ),
      body:Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 20),
            color: Colors.white,
            child: Column(
              children: [

                Container(
                  margin: const EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 5),
                  child: const Text(
                      'You can reach our customer support team to address any of your queries or complaints related to product and services on below ',
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45)),
                ),
                const Divider(
                  thickness: 1,
                  // thickness of the line
                  indent: 20,
                  // empty space to the leading edge of divider.
                  endIndent: 20,
                  // empty space to the trailing edge of the divider.
                  color: Colors.black12,
                  // The color to use when painting the line.
                  height: 15, // The divider's height extent.
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 20, bottom: 5, left: 15, right: 20),
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.call, color: Colors.black45,size: 19,),
                          SizedBox(width: 10,),
                          Expanded(
                            child:
                            Text('Call Us On :', style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45)),flex: 1,),
                          Expanded(
                            child:TextField(
                              maxLines: 1,
                              maxLength: 10,
                              controller: tv_mobile,
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize:14,color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  backgroundColor: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Contact No.',
                                contentPadding: EdgeInsets.only(left: 14),
                              ),
                            ),
                            flex: 2,),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.email, color: Colors.black45,size: 19,),
                          const SizedBox(width: 10,),
                          const Expanded(child: Text('Email us at :', style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45)),flex: 1,),
                          Expanded(child: TextField(
                            maxLines: 1,
                            controller: tv_email,
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontSize:14,color: Colors.black,
                                fontWeight: FontWeight.w300,
                                backgroundColor: Colors.white),
                            decoration: const InputDecoration(hintText: "Email Id",
                              contentPadding: EdgeInsets.only(
                                  left: 14.0, bottom: 18.0, top: 15.0),
                            ),
                          ),flex: 2,),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded,color: Colors.black45,size: 19,),
                          const SizedBox(width: 10,),
                          const Expanded(child: Text('Address :', style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45)),flex: 1,
                          ),
                          Expanded(child: TextField(
                            maxLines: 1,
                            controller: tv_address,
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontSize:14,color: Colors.black,
                                fontWeight: FontWeight.w300,
                                backgroundColor: Colors.white),
                            decoration: const InputDecoration(
                              // border: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.black, height: 3),
                              hintText: "Address",
                              contentPadding: EdgeInsets.only(
                                  left: 14.0, bottom: 18.0, top: 15.0),
                            ),
                          ),flex: 2,),
                        ],
                      ),
                    ],
                  ),
                ),

                const Divider(
                  thickness: 1,
                  // thickness of the line
                  indent: 20,
                  // empty space to the leading edge of divider.
                  endIndent: 20,
                  // empty space to the trailing edge of the divider.
                  color: Colors.black12,
                  // The color to use when painting the line.
                  height: 25, // The divider's height extent.
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      addContactUs();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orangeAccent,
                      shadowColor: Colors.orangeAccent,
                      elevation: 5,
                    ),
                    child: const Text('Update'),
                  ),)

              ],
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
      )

    );
  }

  addContactUs() async {
    if(mounted){
      setState(() {
        isloading=true;
      });
    }

    final body = {
      "id":widget.contact_id,
      "contact": tv_mobile.text,
      "email": tv_email.text,
      "address": tv_address.text,
      "admin_auto_id" : admin_auto_id,
    };

    var url = baseUrl+'api/' + add_contact_details;

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
              msg: 'Contact us updated successfully',
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

}
