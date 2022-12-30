
import 'package:poultry_a2z/Vendor_Module/Vendor_Home/Components/Show_Rating_Screen.dart';
import 'package:poultry_a2z/Vendor_Module/Vendor_Home/Components/Vendor_Menu.dart';

import 'Vendor_Home/Components/Rest_Apis.dart';
import '../Vendor_Module/Vendor_Home/Components/Model/Vendor_Info_Model.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Vendor_details extends StatefulWidget
{
  late String Vendor_id;
  Vendor_details(String id)
  {
    Vendor_id=id;
    print(Vendor_id);
  }

  @override
  _Vendor_detailsState createState() => _Vendor_detailsState();
}

class _Vendor_detailsState extends State<Vendor_details>{
  String user_id = "",baseUrl="";
  bool isApiCallProcess = false;
  Vendor_info_Model? vendor_info_model;
  Vendor_Profile? vendor_profile;
  var shopnameController = TextEditingController();
  var shopAddressController = TextEditingController();
  var shopCityController = TextEditingController();
  var shopMin_OrderController = TextEditingController();
  var shopPrice_RangeController = TextEditingController();

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if(baseUrl!=null){
      this.baseUrl=baseUrl;
      get_Vendor_Info();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
    user_id=widget.Vendor_id;
  }
    @override
    Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: appBarColor,
              title: Transform.translate(
                offset: const Offset(-15.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(shopnameController.text,
                        style: const TextStyle(
                            color: appBarIconColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Text(shopCityController.text,
                        style: const TextStyle(color: appBarIconColor, fontSize: 13)),
                  ],
                ), // here you can put the search bar
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Update_Vendor();
                  },
                  icon: Container(
                    height: 35,
                    width: 35,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(width: 2, color: Colors.white),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                          )
                        ]),
                    child: const Icon(
                      Icons.edit,
                      size: 20,
                      color: appBarIconColor,
                    ),
                  ),
                ),
              ]),
          body: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Vendor_Menu(widget.Vendor_id)),
              Container(
                  margin: EdgeInsets.only(left: 3, right: 3),
                  height: 90,
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
                                          enabled:false,
                                          controller: shopMin_OrderController,
                                          textAlign: TextAlign.center,
                                          cursorColor: Color(0xffF5591F),
                                          decoration: InputDecoration(
                                            hintText: "Rs.0000",
                                            border: InputBorder.none,
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
                                          enabled:false,
                                          controller: shopPrice_RangeController,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            hintText: "Rs.000-0000",
                                            border: InputBorder.none,
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
            ],
          ),
        );

    }

    void get_Vendor_Info() async {
      Rest_Apis restApis = Rest_Apis();

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

    Update_Vendor() {
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
              padding: MediaQuery.of(context).viewInsets,
              child: Update_Vendor_Info(user_id, shopPrice_RangeController.text, shopnameController.text, shopCityController.text,
                  shopMin_OrderController.text, shopAddressController.text),
            );
          });
    }

    Widget Update_Vendor_Info(String userId, String priceRange,
        String shopName, String city, String minOrderPrice, String address) {
      return Container(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Shop Name",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 45,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TextFormField(
                      controller: shopnameController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                          hintText: 'Please enter your shop name',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          )),


                      // style: AppTheme.form_field_text,
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text("Shop Address",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 45,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TextFormField(
                      controller: shopAddressController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                          hintText: 'Please enter your shop address',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          )),


                      // style: AppTheme.form_field_text,
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text("Shop City",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 45,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TextFormField(
                      controller: shopCityController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                          hintText: 'Please enter your city',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          )),


                      // style: AppTheme.form_field_text,
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text("Min Order Price",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 45,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TextFormField(
                      controller: shopMin_OrderController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                          hintText: 'Please enter your shop min order price',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          )),

                      // style: AppTheme.form_field_text,
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text("Order Price Range",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 45,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TextFormField(
                      controller: shopPrice_RangeController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                          hintText: 'Please enter your order price range',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          )),

                      // style: AppTheme.form_field_text,
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                isApiCallProcess == true
                    ? Center(
                  child: Container(
                    height: 60,
                    alignment: Alignment.center,
                    width: 80,
                    child: const GFLoader(type: GFLoaderType.circle),
                  ),
                )
                    : GestureDetector(
                  onTap: () {
                    if (shopCityController.text == "" || shopCityController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Enter shop name",
                        backgroundColor: Colors.grey,
                      );
                    } else if (shopAddressController.text == "" || shopAddressController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Enter shop address",
                        backgroundColor: Colors.grey,
                      );
                    } else if (shopCityController.text == "" || shopCityController.text .isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Enter shop city",
                        backgroundColor: Colors.grey,
                      );
                    } else if (shopMin_OrderController.text == "" || shopMin_OrderController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Enter shop min order price",
                        backgroundColor: Colors.grey,
                      );
                    } else if (shopPrice_RangeController.text == "" || shopPrice_RangeController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Enter shop order price range",
                        backgroundColor: Colors.grey,
                      );
                    } else {
                      Update_Vendor_Information(
                          userId,
                          shopPrice_RangeController.text,
                          shopnameController.text,
                          shopCityController.text,
                          shopMin_OrderController.text,
                          shopAddressController.text);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [
                            (Color(0xffF5591F)),
                            Color(0xffF2861E)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: Color(0xffEEEEEE)),
                      ],
                    ),
                    child: const Text(
                      "Update",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
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
              padding: MediaQuery.of(context).viewInsets,
              child: const Show_Rating_Screen(),
            );
          });
    }

    void Update_Vendor_Information(String userId, String priceRange,
        String shopName, String city, String minOrderPrice, String address) {
      print("data=>" +
          userId +
          " " +
          priceRange +
          " " +
          shopName +
          " " +
          city +
          " " +
          minOrderPrice +
          " " +
          address);

      if (mounted) {
        setState(() {
          isApiCallProcess = true;
        });
      }

      Rest_Apis restApis = Rest_Apis();

      restApis
          .update_vendor_info(userId, shopName, address, city, minOrderPrice, priceRange,baseUrl)
          .then((value) {
        if (value != null) {
          int status = value;

          if (status == 1) {
            isApiCallProcess = false;
            // Navigator.pop(context);
            Navigator.of(context).pop();
            Fluttertoast.showToast(
              msg: "Vendor info updated successfully",
              backgroundColor: Colors.grey,
            );
            get_Vendor_Info();
          } else {
            Fluttertoast.showToast(
              msg: "Something went wrong",
              backgroundColor: Colors.grey,
            );
          }
        }
      });
    }
}