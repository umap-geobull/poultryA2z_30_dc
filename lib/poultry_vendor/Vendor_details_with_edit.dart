import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:poultry_a2z/Vendor_Module/Vendor_Home/Components/Show_Rating_Screen.dart';
import 'package:poultry_a2z/Vendor_Module/Vendor_Home/Components/Vendor_Menu.dart';
import 'package:poultry_a2z/poultry_vendor/product_model.dart';
import 'package:poultry_a2z/poultry_vendor/vendor_details_vendor.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Consultant/Model/consultant_result_model.dart';
import '../Home/Components/MainCategories/categories.dart';
import '../Utils/AppConfig.dart';
import '../Utils/App_Apis.dart';
import '../Utils/coustom_bottom_nav_bar.dart';
import '../Utils/coustom_bottom_nav_bar_vendor.dart';
import '../Utils/enums.dart';
import '../Vendor_Module/Vendor_Home/Components/Rest_Apis.dart';
import '../Vendor_Module/Vendor_Home/Components/Model/Vendor_Info_Model.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'add_product dialgo.dart';

class VendorDetailsWithEdit extends StatefulWidget {
  static String routeName = "/vendorDetailsEdit";
  late String Vendor_id;
  VendorDetailsWithEdit(String id) {
    Vendor_id = id;
    print(Vendor_id);
  }

  @override
  _VendorDetailsWithEditState createState() => _VendorDetailsWithEditState();
}

class _VendorDetailsWithEditState extends State<VendorDetailsWithEdit> {
  String user_id = "", baseUrl = "";
  bool isApiCallProcess = false;
  Vendor_info_Model? vendor_info_model;
  Vendor_Profile? vendor_profile;
  var shopnameController = TextEditingController();
  var shopAddressController = TextEditingController();
  var shopCityController = TextEditingController();
  var shopMin_OrderController = TextEditingController();
  var shopPrice_RangeController = TextEditingController();

  Color appBarColor = Colors.white,
      appBarIconColor = Colors.black,
      primaryButtonColor = Colors.orange,
      secondaryButtonColor = Colors.orangeAccent;
  Color bottomBarColor = Colors.white, bottomMenuIconColor = Color(0xFFFF7643);
  bool isApiCallProcessing = true;
  bool isApiCallProcessingProduct = true;
  String admin_auto_id = '63b2612f9821ce37456a4b31';


  List<ProductVListData> data =[];
  void getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');

    if (baseUrl != null) {
      this.baseUrl = baseUrl;
      // get_Vendor_Info();
    }

    await getVendorDetails();
     getProduct();
  }
  List<Vendor> vendor =[];
  getVendorDetails() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();

    String? userID = prefs.getString('user_id');
    String? apptypeId = prefs.getString('app_type_id');

    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }
    var url = AppConfig.grobizBaseUrl + get_pountry_vendor_details;
    //print(url);
    var uri = Uri.parse(url);
    print("url ${uri}");

    final body = {
      "APP_TYPE_ID": apptypeId,
      "ADMIN_AUTO_ID": admin_auto_id,
      "USER_AUTO_ID": userID,
      // "CATEGORY_AUTO_ID": "",
      // "POULTRY_VENDOR_AUTO_ID": ""
    };
    //print(body.toString());
    final response = await http.post(uri, body: body);
    print("response vendor ${response.body}");
    if (response.statusCode == 200) {
      isApiCallProcessing = false;

      final resp = jsonDecode(response.body);
      String status = resp['status'];
      print("status" + status.toString());
      if (status == "1") {
        print("status ${status}");
        VendorDetailsVendor vendorDetailsVendor =
        VendorDetailsVendor.fromJson(json.decode(response.body));

        // // mainCategoryList=(vendorCatagoryModel!=null?vendorCatagoryModel.data:[])!;
        //
        vendor = vendorDetailsVendor.data;
        print("vendor list ${vendor}");
        if (vendorDetailsVendor != null) {
          if (vendorDetailsVendor.data != null) {
            vendor = vendorDetailsVendor.data;
          }
        }
        setState(() {
          isApiCallProcessing = false;
        });
        //
        // print(mainCategoryList.toString());
        // print("Size of shoes" + mainCategoryList.length.toString());
        // if (mounted) {
        //   setState(() {});
        // }
      }
    } else if (response.statusCode == 500) {
      if (this.mounted) {
        setState(() {
          isApiCallProcessing = false;
        });
      }
      Fluttertoast.showToast(
        msg: "Server error in getting main categories",
        backgroundColor: Colors.grey,
      );
    }
  }

  void getProduct() async {
    if (mounted) {
      setState(() {
        isApiCallProcessingProduct = true;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('user_id');

    var url = AppConfig.grobizBaseUrl + get_vproduct;

    var uri = Uri.parse(url);

    final body = {
      "user_auto_id": userID,
    };

    print("Body ${body}");
    print("Url ${uri}");

    final response = await http.post(uri, body: body);
    print("Body response ${response.body}");
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      String status = resp['status'];
      if (status == '1') {
        ProductVListModel productVListModel = ProductVListModel.fromJson(json.decode(response.body));
        data = productVListModel.data;

        setState(() {
          isApiCallProcessingProduct = false;
        });
      } else {  setState(() {
        isApiCallProcessingProduct = false;
      });}
    } else if (response.statusCode == 500) {
      if (this.mounted) {
        setState(() {
          isApiCallProcessingProduct = false;
        });
      }
      Fluttertoast.showToast(
        msg: "Server error in getting main categories",
        backgroundColor: Colors.grey,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();

    user_id = widget.Vendor_id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 10,
        //   elevation: 0,
        //   backgroundColor: Colors.white,
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back,color: appBarIconColor,size: 20,),
          //   onPressed: ()=>{Navigator.of(context).pop()},
          // ),
          automaticallyImplyLeading: false,
          backgroundColor: appBarColor,
          title: Text(
            "Vendor Details",
            style: TextStyle(color: Colors.black),
          ),
          // Transform.translate(
          //   offset: const Offset(-15.0, 0.0),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Text(shopnameController.text,
          //           style: const TextStyle(
          //               color: appBarIconColor,
          //               fontSize: 16,
          //               fontWeight: FontWeight.bold)),
          //       Text(shopCityController.text,
          //           style:
          //               const TextStyle(color: appBarIconColor, fontSize: 13)),
          //     ],
          //   ), // here you can put the search bar
          // ),
          actions: [
            IconButton(
              onPressed: () {
                // Update_Vendor();
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
                child:  Icon(
                  Icons.edit,
                  size: 20,
                  color: appBarIconColor,
                ),
              ),
            ),
          ]
      ),
      body: SingleChildScrollView(
        child:  isApiCallProcessing == true
            ? Container(
          height: MediaQuery.of(context).size.height * 0.8,
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: const GFLoader(type: GFLoaderType.circle),
        )
            :Container(
          child: Column(
            children: [
              // Container(
              //     margin: const EdgeInsets.only(top: 5, bottom: 5),
              //     child: Vendor_Menu(widget.Vendor_id)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: vendor[0].VENDORPROFILE.isEmpty? Image.asset(
                    vendorList[0].image,
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                  ):  CachedNetworkImage(
                  fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                  imageUrl:
                  "https://grobiz.app/GRBCRM2022/PoultryEcommerce/images/profiles/${vendor[0].VENDORPROFILE}",
                  placeholder: (context, url) =>
                  new Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    color: Colors.grey,
                  ),
                  errorWidget: (context, url, error) =>
                      Container(height: 70,
                          width: 70,
                          color: Colors.grey,child: new Icon(Icons.error)),
                ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Icon(Icons.location_on, color: kMainColor,size: 20,),
                            // SizedBox(width: 5,),
                            Flexible(
                                child: Text(vendor[0].COMPANYNAME,
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)))
                          ],
                        ),
                      ))),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, bottom: 2, top: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Icon(Icons.location_on, color: kMainColor,size: 20,),
                          // SizedBox(width: 5,),
                          Flexible(child: Text("${vendor[0].ADDRESS}"))
                        ],
                      ),
                    )),
              ),
              Divider(color: Colors.grey.shade300),
              SizedBox(
                height: 5,
              ),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
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
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       flex: 1,
                          //       child: Column(
                          //         children: [
                          //           Text(
                          //             "Min Order Value",
                          //             style: TextStyle(
                          //               fontSize: 12,
                          //             ),
                          //           ),
                          //           Container(
                          //             height: 20,
                          //             alignment: Alignment.center,
                          //             child: TextFormField(
                          //                 autocorrect: true,
                          //                 enabled: false,
                          //                 controller: shopMin_OrderController,
                          //                 textAlign: TextAlign.center,
                          //                 cursorColor: Color(0xffF5591F),
                          //                 decoration: InputDecoration(
                          //                   hintText: vendor[0].MINORDERVALUE.isEmpty ? "N.A,":"${vendor[0].MINORDERVALUE}",
                          //                   border: InputBorder.none,
                          //                   contentPadding: EdgeInsets.only(
                          //                       left: 0,
                          //                       right: 0,
                          //                       top: 0,
                          //                       bottom:
                          //                           10 // HERE THE IMPORTANT PART
                          //                       ),
                          //                   enabledBorder: InputBorder.none,
                          //                   focusedBorder: InputBorder.none,
                          //                 ),
                          //                 onChanged: (value) =>
                          //                     shopMin_OrderController.text =
                          //                         value,
                          //                 style: TextStyle(
                          //                     fontSize: 14,
                          //                     color: Colors.black)),
                          //           )
                          //         ],
                          //       ),
                          //     ),
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
                          //     Expanded(
                          //       flex: 1,
                          //       child: Column(
                          //         children: [
                          //           Text(
                          //             "Price Range",
                          //             style: TextStyle(
                          //               fontSize: 12,
                          //             ),
                          //           ),
                          //           Container(
                          //             height: 20,
                          //             alignment: Alignment.center,
                          //             child: TextFormField(
                          //                 enabled: false,
                          //                 controller: shopPrice_RangeController,
                          //                 textAlign: TextAlign.center,
                          //                 decoration: InputDecoration(
                          //                   hintText: vendor[0].PRICERANGE.isEmpty ? "N.A,":"${vendor[0].PRICERANGE}",
                          //                   border: InputBorder.none,
                          //                   contentPadding: EdgeInsets.only(
                          //                       left: 0,
                          //                       right: 0,
                          //                       top: 0,
                          //                       bottom:
                          //                           10 // HERE THE IMPORTANT PART
                          //                       ),
                          //                   enabledBorder: InputBorder.none,
                          //                   focusedBorder: InputBorder.none,
                          //                 ),
                          //                 onChanged: (value) =>
                          //                     shopPrice_RangeController.text =
                          //                         value,
                          //                 style: TextStyle(
                          //                     fontSize: 14,
                          //                     color: Colors.black)),
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // Center(
                          //   child: Wrap(
                          //     crossAxisAlignment: WrapCrossAlignment.center,
                          //     children: [
                          //       Text('Show Rating',
                          //           style: TextStyle(
                          //               fontSize: 12, color: Colors.blue)),
                          //       Icon(
                          //         Icons.keyboard_arrow_down,
                          //         color: Colors.blue,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  )),
              SizedBox(
                height: 5,
              ),
              Divider(color: Colors.grey.shade300),
              SizedBox(
                height: 5,
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 5),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Icon(Icons.location_on, color: kMainColor,size: 20,),
                            // SizedBox(width: 5,),
                            Text("Supplier",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ))),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                height: 70,
                width: MediaQuery.of(context).size.width,
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
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                            height: 40,
                            width: 40,
                            child:vendor[0].SUPPLIERPROFILE.isEmpty? Image.asset('assets/thumbnail.jpeg'):CachedNetworkImage(
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context).size.width,
                              height: 170,
                              imageUrl:
                              "https://grobiz.app/GRBCRM2022/PoultryEcommerce/images/profiles/${vendor[0].SUPPLIERPROFILE}",
                              placeholder: (context, url) =>
                              new Container(
                                width: MediaQuery.of(context).size.width,
                                height: 170,
                                color: Colors.grey,
                              ),
                              errorWidget: (context, url, error) =>
                                  Container(height: 70,
                                      width: 70,
                                      color: Colors.grey,child: new Icon(Icons.error)),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey[400],
                            )),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(vendor[0].NAME.isEmpty ?"N.A" :vendor[0].NAME,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 80,
                            height: 35,
                            // color: primaryButtonColor,
                            child: ElevatedButton(
                              onPressed: () async {
                                var url = "tel:${vendor[0].PHONENUMBER}";
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: const Text('Call'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 50),
                                backgroundColor: primaryButtonColor,
                                shape: const StadiumBorder(),
                                shadowColor: Colors.grey,
                                elevation: 5,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 90,
                            height: 35,
                            child: ElevatedButton(
                              onPressed: () async {
                                var uri =
                                    'sms:+ ${vendor[0].PHONENUMBER}?body=hello%20there';
                                if (await canLaunch(uri)) {
                                  await launch(uri);
                                } else {
                                  // iOS
                                  const uri =
                                      'sms:0039-222-060-888?body=hello%20there';
                                  if (await canLaunch(uri)) {
                                    await launch(uri);
                                  } else {
                                    throw 'Could not launch $uri';
                                  }
                                }
                              },
                              child: const Text('Message'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 50),
                                backgroundColor: secondaryButtonColor,
                                shape: const StadiumBorder(),
                                shadowColor: Colors.grey,
                                elevation: 5,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(color: Colors.grey.shade300),
              SizedBox(
                height: 5,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // Icon(Icons.location_on, color: kMainColor,size: 20,),
                            // SizedBox(width: 5,),
                            Flexible(
                                child: Text("More Related Product",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (builder){
                                          return AddProduct(
                                            getProduct: (){
                                              getProduct();
                                            },
                                          );
                                        }
                                    );
                                  },
                                  child:Icon(Icons.add_circle,color: primaryButtonColor),
                                ),
                                // //const SizedBox(height: 2),
                                // SizedBox(
                                //   // width: 70,
                                //     child: Text(
                                //       "Add new Product",
                                //       maxLines: 2,
                                //       textAlign: TextAlign.center,
                                //       style: TextStyle(color: Colors.black),
                                //     ))
                              ],
                            ),
                          ],
                        ),
                      ))),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  isApiCallProcessingProduct == true
                      ? Container(
                    height: 100,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: const GFLoader(type: GFLoaderType.circle),
                  )
                      : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 130,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (context, index) => GestureDetector(
                                onTap: () {},
                                // onLongPress: longpressed,
                                child: Container(
                                  //width: 90,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2)),
                                  child: Column(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(5),
                                          height: 70,
                                          width: 70,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(5),
                                            child:  data[index]
                                                .productImage
                                                .isEmpty
                                                ? Image.asset(
                                              "assets/images/default.png",
                                              height: 70,
                                              width: 70,
                                            )
                                                : CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              height: 70,
                                              width: 70,
                                              imageUrl:
                                              "https://grobiz.app/GRBCRM2022/PoultryEcommerce/images/products/${data[index].productImage}",
                                              placeholder: (context, url) =>
                                              new Container(
                                                height: 100,
                                                width:
                                                MediaQuery.of(context).size.width /
                                                    2,
                                                color: Colors.grey,
                                              ),
                                              errorWidget: (context, url, error) =>
                                                  Container(height: 70,
                                                      width: 70,
                                                      color: Colors.grey,child: new Icon(Icons.error)),
                                            ) )),
                                      //const SizedBox(height: 2),
                                      SizedBox(
                                          width: 70,
                                          child: Text(
                                            "${data[index].productName}",
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.black),
                                          ))
                                    ],
                                  ),
                                ),
                              )),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomSheet: CustomBottomNavBarVendor(
        MenuStateVendor.home,
        bottomBarColor,
        bottomMenuIconColor,
      ),
    );
  }

  // void get_Vendor_Info() async {
  //   Rest_Apis restApis = Rest_Apis();
  //
  //   restApis.getProfile(widget.Vendor_id, baseUrl).then((value) {
  //     if (value != null) {
  //       if (mounted) {
  //         setState(() {
  //           isApiCallProcess = false;
  //           vendor_info_model = value;
  //         });
  //       }
  //
  //       if (vendor_info_model != null) {
  //         if (mounted) {
  //           setState(() {
  //             vendor_profile = vendor_info_model?.profile!;
  //             shopnameController.text = vendor_profile?.name as String;
  //             shopCityController.text = vendor_profile?.city as String;
  //             shopMin_OrderController.text =
  //                 vendor_profile?.minOrderValue as String;
  //             //  shopMin_OrderController.text = vendor_profile?.minOrderValue as String;
  //             shopPrice_RangeController.text =
  //                 vendor_profile?.priceRange as String;
  //
  //             shopAddressController.text = vendor_profile?.address as String;
  //           });
  //         }
  //       }
  //     }
  //   });
  // }
  //
  // Update_Vendor() {
  //   return showModalBottomSheet<void>(
  //       context: context,
  //       isScrollControlled: true,
  //       shape: const RoundedRectangleBorder(
  //         // <-- SEE HERE
  //         borderRadius: BorderRadius.vertical(
  //           top: Radius.circular(25.0),
  //         ),
  //       ),
  //       builder: (BuildContext context) {
  //         return Padding(
  //           padding: MediaQuery.of(context).viewInsets,
  //           child: Update_Vendor_Info(
  //               user_id,
  //               shopPrice_RangeController.text,
  //               shopnameController.text,
  //               shopCityController.text,
  //               shopMin_OrderController.text,
  //               shopAddressController.text),
  //         );
  //       });
  // }
  //
  // Widget Update_Vendor_Info(String userId, String priceRange, String shopName,
  //     String city, String minOrderPrice, String address) {
  //   return Container(
  //     child: SingleChildScrollView(
  //       child: Container(
  //         margin: const EdgeInsets.all(15),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const Text("Shop Name",
  //                 style: TextStyle(fontSize: 16, color: Colors.black)),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             SizedBox(
  //               height: 45,
  //               child: SizedBox(
  //                 height: MediaQuery.of(context).size.height,
  //                 child: TextFormField(
  //                   controller: shopnameController,
  //                   decoration: InputDecoration(
  //                       filled: true,
  //                       fillColor: Colors.white,
  //                       contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
  //                       hintText: 'Please enter your shop name',
  //                       focusedBorder: OutlineInputBorder(
  //                         borderSide:
  //                             const BorderSide(color: Colors.grey, width: 1),
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       enabledBorder: OutlineInputBorder(
  //                         borderSide:
  //                             const BorderSide(color: Colors.black, width: 1),
  //                         borderRadius: BorderRadius.circular(10),
  //                       )),
  //
  //                   // style: AppTheme.form_field_text,
  //                   keyboardType: TextInputType.name,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 10.0),
  //             const Text("Shop Address",
  //                 style: TextStyle(fontSize: 16, color: Colors.black)),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             SizedBox(
  //               height: 45,
  //               child: SizedBox(
  //                 height: MediaQuery.of(context).size.height,
  //                 child: TextFormField(
  //                   controller: shopAddressController,
  //                   decoration: InputDecoration(
  //                       filled: true,
  //                       fillColor: Colors.white,
  //                       contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
  //                       hintText: 'Please enter your shop address',
  //                       focusedBorder: OutlineInputBorder(
  //                         borderSide:
  //                             const BorderSide(color: Colors.grey, width: 1),
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       enabledBorder: OutlineInputBorder(
  //                         borderSide:
  //                             const BorderSide(color: Colors.black, width: 1),
  //                         borderRadius: BorderRadius.circular(10),
  //                       )),
  //
  //                   // style: AppTheme.form_field_text,
  //                   keyboardType: TextInputType.name,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 10.0),
  //             const Text("Shop City",
  //                 style: TextStyle(fontSize: 16, color: Colors.black)),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             SizedBox(
  //               height: 45,
  //               child: SizedBox(
  //                 height: MediaQuery.of(context).size.height,
  //                 child: TextFormField(
  //                   controller: shopCityController,
  //                   decoration: InputDecoration(
  //                       filled: true,
  //                       fillColor: Colors.white,
  //                       contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
  //                       hintText: 'Please enter your city',
  //                       focusedBorder: OutlineInputBorder(
  //                         borderSide:
  //                             const BorderSide(color: Colors.grey, width: 1),
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       enabledBorder: OutlineInputBorder(
  //                         borderSide:
  //                             const BorderSide(color: Colors.black, width: 1),
  //                         borderRadius: BorderRadius.circular(10),
  //                       )),
  //
  //                   // style: AppTheme.form_field_text,
  //                   keyboardType: TextInputType.name,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 10.0),
  //             const Text("Min Order Price",
  //                 style: TextStyle(fontSize: 16, color: Colors.black)),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             SizedBox(
  //               height: 45,
  //               child: SizedBox(
  //                 height: MediaQuery.of(context).size.height,
  //                 child: TextFormField(
  //                   controller: shopMin_OrderController,
  //                   decoration: InputDecoration(
  //                       filled: true,
  //                       fillColor: Colors.white,
  //                       contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
  //                       hintText: 'Please enter your shop min order price',
  //                       focusedBorder: OutlineInputBorder(
  //                         borderSide:
  //                             const BorderSide(color: Colors.grey, width: 1),
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       enabledBorder: OutlineInputBorder(
  //                         borderSide:
  //                             const BorderSide(color: Colors.black, width: 1),
  //                         borderRadius: BorderRadius.circular(10),
  //                       )),
  //
  //                   // style: AppTheme.form_field_text,
  //                   keyboardType: TextInputType.name,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 10.0),
  //             const Text("Order Price Range",
  //                 style: TextStyle(fontSize: 16, color: Colors.black)),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             SizedBox(
  //               height: 45,
  //               child: SizedBox(
  //                 height: MediaQuery.of(context).size.height,
  //                 child: TextFormField(
  //                   controller: shopPrice_RangeController,
  //                   decoration: InputDecoration(
  //                       filled: true,
  //                       fillColor: Colors.white,
  //                       contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
  //                       hintText: 'Please enter your order price range',
  //                       focusedBorder: OutlineInputBorder(
  //                         borderSide:
  //                             const BorderSide(color: Colors.grey, width: 1),
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       enabledBorder: OutlineInputBorder(
  //                         borderSide:
  //                             const BorderSide(color: Colors.black, width: 1),
  //                         borderRadius: BorderRadius.circular(10),
  //                       )),
  //
  //                   // style: AppTheme.form_field_text,
  //                   keyboardType: TextInputType.name,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 10.0),
  //             isApiCallProcess == true
  //                 ? Center(
  //                     child: Container(
  //                       height: 60,
  //                       alignment: Alignment.center,
  //                       width: 80,
  //                       child: const GFLoader(type: GFLoaderType.circle),
  //                     ),
  //                   )
  //                 : GestureDetector(
  //                     onTap: () {
  //                       if (shopCityController.text == "" ||
  //                           shopCityController.text.isEmpty) {
  //                         Fluttertoast.showToast(
  //                           msg: "Enter shop name",
  //                           backgroundColor: Colors.grey,
  //                         );
  //                       } else if (shopAddressController.text == "" ||
  //                           shopAddressController.text.isEmpty) {
  //                         Fluttertoast.showToast(
  //                           msg: "Enter shop address",
  //                           backgroundColor: Colors.grey,
  //                         );
  //                       } else if (shopCityController.text == "" ||
  //                           shopCityController.text.isEmpty) {
  //                         Fluttertoast.showToast(
  //                           msg: "Enter shop city",
  //                           backgroundColor: Colors.grey,
  //                         );
  //                       } else if (shopMin_OrderController.text == "" ||
  //                           shopMin_OrderController.text.isEmpty) {
  //                         Fluttertoast.showToast(
  //                           msg: "Enter shop min order price",
  //                           backgroundColor: Colors.grey,
  //                         );
  //                       } else if (shopPrice_RangeController.text == "" ||
  //                           shopPrice_RangeController.text.isEmpty) {
  //                         Fluttertoast.showToast(
  //                           msg: "Enter shop order price range",
  //                           backgroundColor: Colors.grey,
  //                         );
  //                       } else {
  //                         Update_Vendor_Information(
  //                             userId,
  //                             shopPrice_RangeController.text,
  //                             shopnameController.text,
  //                             shopCityController.text,
  //                             shopMin_OrderController.text,
  //                             shopAddressController.text);
  //                       }
  //                     },
  //                     child: Container(
  //                       alignment: Alignment.center,
  //                       margin: const EdgeInsets.only(left: 10, right: 10),
  //                       height: 45,
  //                       decoration: BoxDecoration(
  //                         gradient: const LinearGradient(
  //                             colors: [(Color(0xffF5591F)), Color(0xffF2861E)],
  //                             begin: Alignment.centerLeft,
  //                             end: Alignment.centerRight),
  //                         borderRadius: BorderRadius.circular(10),
  //                         color: Colors.grey[200],
  //                         boxShadow: const [
  //                           BoxShadow(
  //                               offset: Offset(0, 10),
  //                               blurRadius: 50,
  //                               color: Color(0xffEEEEEE)),
  //                         ],
  //                       ),
  //                       child: const Text(
  //                         "Update",
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                     ),
  //                   )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
        .update_vendor_info(
            userId, shopName, address, city, minOrderPrice, priceRange, baseUrl)
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
          // get_Vendor_Info();
        } else {
          Fluttertoast.showToast(
            msg: "Something went wrong",
            backgroundColor: Colors.grey,
          );
        }
      }
    });
  }



  // Widget priorityDialog(BuildContext context) {
  //   return
  // }
}


class PopularProduct {
  String name;
  String image;
  PopularProduct(this.name, this.image);
}

List<PopularProduct> popularProduct = [
  PopularProduct('Milkana', 'assets/images/cat2.jpeg'),
  PopularProduct('C cal D3', 'assets/images/cat3.jpeg'),
  PopularProduct('Farmy Blend Cattle Feed', 'assets/images/car4.jpeg'),
  PopularProduct('Liv ek', 'assets/images/cat1.jpeg'),
  PopularProduct('Milkana', 'assets/images/cat2.jpeg'),
  PopularProduct('C cal D3', 'assets/images/cat3.jpeg'),
];
