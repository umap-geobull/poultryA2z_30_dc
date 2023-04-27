import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:poultry_a2z/Vendor_Module/Vendor_Home/Components/Show_Rating_Screen.dart';
import 'package:poultry_a2z/poultry_vendor/product_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Utils/AppConfig.dart';
import '../Utils/App_Apis.dart';
import '../Utils/coustom_bottom_nav_bar_vendor.dart';
import '../Utils/enums.dart';
import '../Vendor_Module/Vendor_Home/Components/Rest_Apis.dart';
import '../Vendor_Module/Vendor_Home/Components/Model/Vendor_Info_Model.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Color bottomBarColor = Colors.white, bottomMenuIconColor = const Color(0xFFFF7643);
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

  List vendorData = [];
  getVendorDetails() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    // 63b2612f9821ce37456a4b31
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
    print("body is....  63b2612f9821ce37456a4b31 ${body.toString()}");
    final response = await http.post(uri, body: body);
    print("response vendor ${response.body}");
    if (response.statusCode == 200) {
      isApiCallProcessing = false;

      final resp = jsonDecode(response.body);
      String status = resp['status'];
      print("status    $status");
      if (status == "1") {
        print("status $status");
        vendorData = resp["data"];
        log("vendorData...@@@@.$vendorData");
        getAddess();


        // VendorDetailsVendor vendorDetailsVendor = VendorDetailsVendor.fromJson(json.decode(response.body));
        // vendor = vendorDetailsVendor.data;
        // print("vendor list ${vendor}");
        // if (vendorDetailsVendor != null) {
        //   if (vendorDetailsVendor.data != null) {
        //     vendor = vendorDetailsVendor.data;
        //   }
        // }
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

  var address;
  var phoneNumber;

  getAddess(){
     phoneNumber = vendorData[vendorData.length-1]["fields"].where((f)=>f["field_name"] == "PHONE_NUMBER").toList();
     address = vendorData[vendorData.length-1]["fields"].where((f)=>f["field_name"].toString().startsWith("ADDRESS") /*== "ADDRESS"*/).toList();
     log("address is ${vendorData[vendorData.length-1]["fields"]}");
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
    return WillPopScope(
      onWillPop: () => showAlertExit(),
      child: Scaffold(
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
            title: const Text(
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
            actions: const [
              // IconButton(
              //   onPressed: () {
              //     // Update_Vendor();
              //   },
              //   icon: Container(
              //     height: 35,
              //     width: 35,
              //     padding: const EdgeInsets.all(5),
              //     decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(100),
              //         border: Border.all(width: 2, color: Colors.white),
              //         boxShadow: const [
              //           BoxShadow(
              //             color: Colors.grey,
              //             blurRadius: 5.0,
              //           )
              //         ]),
              //     child:  Icon(
              //       Icons.edit,
              //       size: 20,
              //       color: appBarIconColor,
              //     ),
              //   ),
              // ),
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
                    child: vendorData[vendorData.length-1]["VENDOR_PROFILE"].isEmpty? Image.asset(
                      // vendorList[0].image,
                      'assets/thumbnail.jpeg',
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                    ):  CachedNetworkImage(
                    fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                    imageUrl:
                    "https://grobiz.app/GRBCRM2022/PoultryEcommerce/images/profiles/${vendorData[vendorData.length-1]["VENDOR_PROFILE"].toString()}",
                    placeholder: (context, url) =>
                    Container(
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
                              const EdgeInsets.only(left: 10, right: 10, bottom: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Icon(Icons.location_on, color: kMainColor,size: 20,),
                              // SizedBox(width: 5,),
                              Flexible(
                                  child: vendorData[vendorData.length-1]["fields"].toString().isEmpty &&
                                      vendorData[vendorData.length-1]["fields"][0]["field_value"].toString() == " "
                                      ?SizedBox():Text(
                                      // vendor[0].COMPANYNAME,
                                      vendorData[vendorData.length-1]["fields"][0]["field_value"],
                                      style: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)))
                            ],
                          ),
                        ))),
                ///address
                // Padding(
                //   padding: const EdgeInsets.only(left: 8.0, right: 8),
                //   child: SizedBox(
                //       width: MediaQuery.of(context).size.width,
                //       child: Padding(
                //         padding: const EdgeInsets.only(
                //             left: 10, right: 10, bottom: 2, top: 5),
                //         child: Row(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: <Widget>[
                //             // Icon(Icons.location_on, color: kMainColor,size: 20,),
                //             // SizedBox(width: 5,),
                //             // Flexible(child: Text("${vendor[0].ADDRESS}"))
                //             Flexible(child: Text("${address[0]['field_value']}"))
                //           ],
                //         ),
                //       )),
                // ),
                //Divider(color: Colors.grey.shade300),
                const SizedBox(height: 5),
                ///seller rating
                // Container(
                //     margin: EdgeInsets.only(left: 10, right: 10),
                //     height: 90,
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       border: Border.all(color: Colors.grey.shade100),
                //       borderRadius: BorderRadius.circular(10),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.grey.withOpacity(0.5),
                //           spreadRadius: 1,
                //           blurRadius: 5,
                //           // changes position of shadow
                //         ),
                //       ],
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.all(10.0),
                //       child: GestureDetector(
                //         onTap: () => {_showSimpleDialog()},
                //         child: Column(
                //           children: [
                //             // Row(
                //             //   children: [
                //             //     Expanded(
                //             //       flex: 1,
                //             //       child: Column(
                //             //         children: [
                //             //           Text(
                //             //             "Min Order Value",
                //             //             style: TextStyle(
                //             //               fontSize: 12,
                //             //             ),
                //             //           ),
                //             //           Container(
                //             //             height: 20,
                //             //             alignment: Alignment.center,
                //             //             child: TextFormField(
                //             //                 autocorrect: true,
                //             //                 enabled: false,
                //             //                 controller: shopMin_OrderController,
                //             //                 textAlign: TextAlign.center,
                //             //                 cursorColor: Color(0xffF5591F),
                //             //                 decoration: InputDecoration(
                //             //                   hintText: vendor[0].MINORDERVALUE.isEmpty ? "N.A,":"${vendor[0].MINORDERVALUE}",
                //             //                   border: InputBorder.none,
                //             //                   contentPadding: EdgeInsets.only(
                //             //                       left: 0,
                //             //                       right: 0,
                //             //                       top: 0,
                //             //                       bottom:
                //             //                           10 // HERE THE IMPORTANT PART
                //             //                       ),
                //             //                   enabledBorder: InputBorder.none,
                //             //                   focusedBorder: InputBorder.none,
                //             //                 ),
                //             //                 onChanged: (value) =>
                //             //                     shopMin_OrderController.text =
                //             //                         value,
                //             //                 style: TextStyle(
                //             //                     fontSize: 14,
                //             //                     color: Colors.black)),
                //             //           )
                //             //         ],
                //             //       ),
                //             //     ),
                //             ///seller
                //                 Expanded(
                //                   flex: 1,
                //                   child: Column(
                //                     children: [
                //                       Text(
                //                         "Seller Rating",
                //                         style: TextStyle(
                //                           fontSize: 12,
                //                         ),
                //                       ),
                //                       Wrap(
                //                         crossAxisAlignment:
                //                             WrapCrossAlignment.center,
                //                         children: [
                //                           Text('4.4',
                //                               style: TextStyle(
                //                                   fontSize: 16,
                //                                   color: Colors.black)),
                //                           Icon(
                //                             Icons.star,
                //                             color: Colors.yellow,
                //                           ),
                //                         ],
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //             //     Expanded(
                //             //       flex: 1,
                //             //       child: Column(
                //             //         children: [
                //             //           Text(
                //             //             "Price Range",
                //             //             style: TextStyle(
                //             //               fontSize: 12,
                //             //             ),
                //             //           ),
                //             //           Container(
                //             //             height: 20,
                //             //             alignment: Alignment.center,
                //             //             child: TextFormField(
                //             //                 enabled: false,
                //             //                 controller: shopPrice_RangeController,
                //             //                 textAlign: TextAlign.center,
                //             //                 decoration: InputDecoration(
                //             //                   hintText: vendor[0].PRICERANGE.isEmpty ? "N.A,":"${vendor[0].PRICERANGE}",
                //             //                   border: InputBorder.none,
                //             //                   contentPadding: EdgeInsets.only(
                //             //                       left: 0,
                //             //                       right: 0,
                //             //                       top: 0,
                //             //                       bottom:
                //             //                           10 // HERE THE IMPORTANT PART
                //             //                       ),
                //             //                   enabledBorder: InputBorder.none,
                //             //                   focusedBorder: InputBorder.none,
                //             //                 ),
                //             //                 onChanged: (value) =>
                //             //                     shopPrice_RangeController.text =
                //             //                         value,
                //             //                 style: TextStyle(
                //             //                     fontSize: 14,
                //             //                     color: Colors.black)),
                //             //           )
                //             //         ],
                //             //       ),
                //             //     ),
                //             //   ],
                //             // ),
                //             // Center(
                //             //   child: Wrap(
                //             //     crossAxisAlignment: WrapCrossAlignment.center,
                //             //     children: [
                //             //       Text('Show Rating',
                //             //           style: TextStyle(
                //             //               fontSize: 12, color: Colors.blue)),
                //             //       Icon(
                //             //         Icons.keyboard_arrow_down,
                //             //         color: Colors.blue,
                //             //       ),
                //             //     ],
                //             //   ),
                //             // ),
                //           ],
                //         ),
                //       ),
                //     )),
                // SizedBox(
                //   height: 5,
                // ),
                //Divider(color: Colors.grey.shade300),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8, bottom: 5),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 10, right: 10, bottom: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const <Widget>[
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
                  margin: const EdgeInsets.only(left: 10, right: 10),
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
                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.grey[400],
                              ),
                              child:vendorData[vendorData.length-1]["SUPPLIER_PROFILE"].isEmpty? Image.asset('assets/thumbnail.jpeg'):CachedNetworkImage(
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width,
                                height: 170,
                                imageUrl:
                                "https://grobiz.app/GRBCRM2022/PoultryEcommerce/images/profiles/${vendorData[vendorData.length-1]["SUPPLIER_PROFILE"]}",
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
                              )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                            // "lll",
                            vendorData[vendorData.length-1]["fields"][1]["field_value"].isEmpty ?"N.A" :vendorData[vendorData.length-1]["fields"][1]["field_value"],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          width: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: Get.width*0.19,
                              height: Get.width*0.08,
                              // color: primaryButtonColor,
                              child: ElevatedButton(
                                onPressed: () async {
                                  // vendorData[vendorData.length-1]["fields"][1]["field_value"]
                                  var url = "tel:${phoneNumber[0]["field_value"]}";
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(200, 50),
                                  backgroundColor: primaryButtonColor,
                                  shape: const StadiumBorder(),
                                  shadowColor: Colors.grey,
                                  elevation: 5,
                                ),
                                child: const Text('Call'),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: Get.width*0.19,
                              height: Get.width*0.08,
                              child: ElevatedButton(
                                onPressed: () async {
                                  var uri =
                                      'sms: ${phoneNumber[0]["field_value"]}?body=hello%20there';
                                  if (await canLaunch(uri)) {
                                    await launch(uri);
                                  } else {
                                    // iOS
                                    var uri =
                                        'sms:${phoneNumber[0]["field_value"]}?body=hello%20there';
                                    if (await canLaunch(uri)) {
                                      await launch(uri);
                                    } else {
                                      throw 'Could not launch $uri';
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(200, 50),
                                  backgroundColor: secondaryButtonColor,
                                  shape: const StadiumBorder(),
                                  shadowColor: Colors.grey,
                                  elevation: 5,
                                ),
                                child: FittedBox(child: const Text('Message')),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Divider(color: Colors.grey.shade300),
                const SizedBox(
                  height: 5,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:vendorData[vendorData.length-1]["fields"].length,
                  itemBuilder: (context, index) {
                    var a = vendorData[vendorData.length-1]["fields"][index];
                    return /*a["field_name"] == "FIRM_NAME"  ||
                        a["field_name"] == "OWNER_NAME"  ||*/
                        a["field_name"] == "PHONE_NUMBER"
                        ?const SizedBox()
                        :Padding(
                      padding:  EdgeInsets.only(left: Get.width*0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${a["field_name"].toString().replaceAll("_", " ")}",style: const TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w400),),
                          const SizedBox(height: 5,),
                          Text(a["field_value"] == " " ?"N.A.": "${a["field_value"]}"),
                          const SizedBox(height: 10,)
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 10, right: 10, bottom: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // Icon(Icons.location_on, color: kMainColor,size: 20,),
                              // SizedBox(width: 5,),
                              const Flexible(
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
                                            padding: const EdgeInsets.all(5),
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
                                              style: const TextStyle(color: Colors.black),
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
      ),
    );
  }

  Future<bool> showAlertExit() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: const Text(
            'Are you sure?',
            style: TextStyle(color: Colors.black87),
          ),
          content: Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Do you want to exit App',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            child: ElevatedButton(
                              onPressed: () {
                                SystemNavigator.pop();
                              },
                              child: const Text("Yes",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[200],
                                minimumSize: const Size(70, 30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                            child: ElevatedButton(
                              onPressed: () => {Navigator.pop(context)},
                              child: const Text("No",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[200],
                                minimumSize: const Size(70, 30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
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
