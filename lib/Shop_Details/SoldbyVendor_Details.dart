import 'dart:convert';

import 'package:poultry_a2z/Vendor_Module/Vendor_Home/Components/Show_Rating_Screen.dart';

import '../Vendor_Module/Vendor_Home/Components/Brand_List.dart';
import '../Vendor_Module/Vendor_Home/Components/Category_List.dart';
import '../Vendor_Module/Vendor_Home/Components/Rest_Apis.dart';
import '../Vendor_Module/Vendor_Home/Components/Model/Vendor_Info_Model.dart';
import '../Vendor_Module/Vendor_Home/Components/Best_Selling_Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';

class SoldByVendor_details extends StatefulWidget
{
  late String Vendor_id;
  SoldByVendor_details(String id)
  {
    this.Vendor_id=id;
    print(Vendor_id);
  }

  @override
  _SoldByVendor_detailsState createState() => _SoldByVendor_detailsState();
}

class _SoldByVendor_detailsState extends State<SoldByVendor_details> {
  String user_id = "",
      baseUrl = "";
  bool isApiCallProcess = false;
  Vendor_info_Model? vendor_info_model;
  Vendor_Profile? vendor_profile;
  var shopnameController = TextEditingController();
  var shopAddressController = TextEditingController();
  var shopCityController = TextEditingController();
  var shopMin_OrderController = TextEditingController();
  var shopPrice_RangeController = TextEditingController();

  void getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');

    if (baseUrl != null) {
      this.baseUrl = baseUrl;
      get_Vendor_Info();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user_id = widget.Vendor_id;
    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Transform.translate(
            offset: Offset(0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(shopnameController.text,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Text(shopCityController.text,
                    style: TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ), // here you can put the search bar
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Share.share('check out this Vendor Profile:- https://play.google.com/');
              },
              icon: Container(
                height: 35,
                width: 35,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 2, color: Colors.white),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      )
                    ]),
                child: Icon(
                  Icons.share,
                  size: 20,
                ),
              ),
            ),
          ]),
      body: Column(
        children: [
          // Container(
          //     margin: EdgeInsets.only(top: 5, bottom: 5),
          //     child: Vendor_Menu(widget.Vendor_id)),
          Container(
              margin: EdgeInsets.only(left: 3, right: 3,top: 10),
              height: 85,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade100),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () => {_showSimpleDialog()},
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(
                                  "Min Order Value",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  alignment: Alignment.center,
                                  child: TextFormField(
                                      autocorrect: true,
                                      controller: shopMin_OrderController,
                                      textAlign: TextAlign.center,
                                      cursorColor: Color(0xffF5591F),
                                      decoration: InputDecoration(
                                        hintText: "Rs.0000",
                                        contentPadding: EdgeInsets.only(
                                            left: 0,
                                            right: 0,
                                            top: 0,
                                            bottom:
                                            10 // HERE THE IMPORTANT PART
                                        ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                      onChanged: (value) =>
                                      shopMin_OrderController.text =
                                          value,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black)),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(
                                  "Seller Rating",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Wrap(
                                  crossAxisAlignment:
                                  WrapCrossAlignment.center,
                                  children: [
                                    Text('4.4',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black)),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(
                                  "Price Range",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  alignment: Alignment.center,
                                  child: TextFormField(
                                      autocorrect: true,
                                      controller: shopPrice_RangeController,
                                      textAlign: TextAlign.center,
                                      cursorColor: Color(0xffF5591F),
                                      decoration: InputDecoration(
                                        hintText: "Rs.000-0000",
                                        contentPadding: EdgeInsets.only(
                                            left: 0,
                                            right: 0,
                                            top: 0,
                                            bottom:
                                            10 // HERE THE IMPORTANT PART
                                        ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                      onChanged: (value) =>
                                      shopPrice_RangeController.text =
                                          value,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text('Show Rating',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.blue)),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Divider(color: Colors.grey.shade300),
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            child: Brand_List(user_id),
          ),
          Divider(color: Colors.grey.shade300),
          Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            child: Container(child: Category_List(user_id)),
          ),
          Divider(color: Colors.grey.shade300),
          Best_Selling_Product(user_id),
        ],
      ),
    );
  }

  // Future<bool> showAlert() async {
  //   return await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //         backgroundColor: Colors.yellow[50],
  //         title: Text(
  //           'Are you sure?',
  //           style: TextStyle(color: Colors.black87),
  //         ),
  //         content: Wrap(
  //           children: <Widget>[
  //             Container(
  //               child: Column(
  //                 children: <Widget>[
  //                   Text(
  //                     'Do you want to exit App',
  //                     style: TextStyle(color: Colors.black54),
  //                   ),
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   Row(
  //                     crossAxisAlignment: CrossAxisAlignment.end,
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: <Widget>[
  //                       Container(
  //                           child: ElevatedButton(
  //                             onPressed: () {
  //                               SystemNavigator.pop();
  //                             },
  //                             child: Text("Yes",
  //                                 style: TextStyle(
  //                                     color: Colors.black54, fontSize: 13)),
  //                             style: ElevatedButton.styleFrom(
  //                               primary: Colors.green[200],
  //                               onPrimary: Colors.green,
  //                               minimumSize: Size(70, 30),
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius:
  //                                 BorderRadius.all(Radius.circular(2.0)),
  //                               ),
  //                             ),
  //                           )),
  //                       SizedBox(
  //                         width: 10,
  //                       ),
  //                       Container(
  //                           child: ElevatedButton(
  //                             onPressed: () => {Navigator.pop(context)},
  //                             child: Text("No",
  //                                 style: TextStyle(
  //                                     color: Colors.black54, fontSize: 13)),
  //                             style: ElevatedButton.styleFrom(
  //                               primary: Colors.blue[200],
  //                               onPrimary: Colors.blue,
  //                               minimumSize: Size(70, 30),
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius:
  //                                 BorderRadius.all(Radius.circular(2.0)),
  //                               ),
  //                             ),
  //                           )),
  //                     ],
  //                   )
  //                 ],
  //               ),
  //             )
  //           ],
  //         )),
  //   );
  // }


  void get_Vendor_Info() async {
    Rest_Apis restApis = new Rest_Apis();

    restApis.getProfile(widget.Vendor_id,baseUrl).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            isApiCallProcess = false;
            vendor_info_model = value;
          });
        }

        if (vendor_info_model != null) {
          if (mounted) {
            setState(() {
              vendor_profile = vendor_info_model?.profile!;
              shopnameController.text = vendor_profile?.name as String;
              shopCityController.text = vendor_profile?.city as String;
              shopMin_OrderController.text =
              vendor_profile?.minOrderValue as String;
              //  shopMin_OrderController.text = vendor_profile?.minOrderValue as String;
              shopPrice_RangeController.text =
              vendor_profile?.priceRange as String;

              shopAddressController.text = vendor_profile?.address as String;
            });
          }
        }
      }
    });
  }

  _showSimpleDialog() {
    return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery
                .of(context)
                .viewInsets,
            child: Show_Rating_Screen(),
          );
        });
  }
}