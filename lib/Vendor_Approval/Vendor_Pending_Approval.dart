import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../../Utils/App_Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;

import '../poultry_vendor/vendor_details_customer.dart';
import 'Model/VendorApprovalModule.dart';

class Vendor_Pending_Approval extends StatefulWidget {
  Vendor_Pending_Approval({
    Key? key,
    // required this.type,
    // required this.main_cat_id,
    // required this.sub_cat_id,
    // required this.brand_id,
    // required this.home_componet_id,
    // required this.offer_id
  }) : super(key: key);

  // String type;
  // String main_cat_id;
  // String sub_cat_id;
  // String brand_id;
  // String home_componet_id;
  // String offer_id;

  @override
  _Vendor_Pending_ApprovalState createState() =>
      _Vendor_Pending_ApprovalState();
}

class _Vendor_Pending_ApprovalState extends State<Vendor_Pending_Approval> {
  late Route routes;
  bool isApiCallProcessing = false;
  bool isDeleteProcessing = false;
  String baseUrl = '',
      user_id = '',
      admin_auto_id = '',
      app_type_id = '',
      user_type = '';
  List<String> categories = [];
  bool isfilter = false;
  late File icon_img;
  late XFile pickedImageFile;
  Color appBarColor = Colors.white,
      appBarIconColor = Colors.black,
      primaryButtonColor = Colors.orange,
      secondaryButtonColor = Colors.orangeAccent;

  Color bottomBarColor = Colors.white, bottomMenuIconColor = Color(0xFFFF7643);

  List<GetVendorListCategory> vendor_list = [];

  void getappUi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? appBarColor = prefs.getString('appbarColor');
    String? appbarIcon = prefs.getString('appbarIconColor');
    String? primaryButtonColor = prefs.getString('primaryButtonColor');
    String? secondaryButtonColor = prefs.getString('secondaryButtonColor');
    String? bottomBarColor = prefs.getString('bottomBarColor');
    String? bottombarIcon = prefs.getString('bottomBarIconColor');

    if (appBarColor != null) {
      this.appBarColor = Color(int.parse(appBarColor));
    }

    if (appbarIcon != null) {
      this.appBarIconColor = Color(int.parse(appbarIcon));
    }

    if (primaryButtonColor != null) {
      this.primaryButtonColor = Color(int.parse(primaryButtonColor));
    }

    if (secondaryButtonColor != null) {
      this.secondaryButtonColor = Color(int.parse(secondaryButtonColor));
    }
    if (bottomBarColor != null) {
      this.bottomBarColor = Color(int.parse(bottomBarColor));
      setState(() {});
    }

    if (bottombarIcon != null) {
      this.bottomMenuIconColor = Color(int.parse(bottombarIcon));
      setState(() {});
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  void getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid = prefs.getString('app_type_id');
    String? userType = prefs.getString('user_type');

    if (baseUrl != null &&
        userId != null &&
        adminId != null &&
        apptypeid != null &&
        userType != null) {
      if (this.mounted) {
        this.admin_auto_id = adminId;
        this.baseUrl = baseUrl;
        this.user_id = userId;
        this.app_type_id = apptypeid;
        this.user_type = userType;
        getVendorData();
      }
    }
  }

  void getVendorData() async {
    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }

    var url = baseUrl + 'api/' + get_vendor_approval_list;

    var uri = Uri.parse(url);

    final body = {
      "admin_auto_id": admin_auto_id,
      //"user_auto_id":user_id,
    };
    //print(body.toString());
    //print(url);
    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing = false;

      final resp = jsonDecode(response.body);
      int status = resp['status'];
      if (status == 1) {
        VendorApprovalList Jobsmodel =
            VendorApprovalList.fromJson(json.decode(response.body));
        vendor_list = Jobsmodel.data;

        print(vendor_list.toString());
        if (mounted) {
          setState(() {});
        }
      } else {
        isApiCallProcessing = false;
        if (mounted) {
          setState(() {});
        }
      }
    } else if (response.statusCode == 500) {
      if (this.mounted) {
        setState(() {
          isApiCallProcessing = false;
        });
      }
      Fluttertoast.showToast(
        msg: "Server error ",
        backgroundColor: Colors.grey,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getappUi();
    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: <Widget>[
          vendor_list.isNotEmpty? SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height / 1.3,
                padding: const EdgeInsets.only(top: 10),
                margin: EdgeInsets.only(left: 15, right: 15),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: vendor_list.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      // Navigator.push(context,
                      // MaterialPageRoute(builder: (context) => VendorDetailsWithCustomer( vendor: vendor_list[index],)));
                    },
                    child: Container(
                      height: 280,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                vendor_list[index].SUPPLIERPROFILE.isEmpty
                                    ? Expanded(
                                        flex: 5,
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 220,
                                          color: Colors.grey[200],
                                          child: Image(
                                            image: AssetImage(
                                                'assets/thumbnail.jpeg'),
                                          ),
                                        ))
                                    : Expanded(
                                        flex: 5,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 220,
                                          imageUrl:
                                              "https://grobiz.app/GRBCRM2022/PoultryEcommerce/images/products/${vendor_list[index].SUPPLIERPROFILE}",
                                          placeholder: (context, url) =>
                                              new Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 220,
                                            color: Colors.grey,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 220,
                                                  color: Colors.grey,
                                                  child: new Icon(Icons.error)),
                                        ),
                                      ),
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 5,
                                          bottom: 5),
                                      child: Text(
                                        vendor_list[index].FIRMNAME.isEmpty
                                            ? "N.A."
                                            : vendor_list[index].FIRMNAME,
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 20),
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              bottom: 2,
                                              top: 5),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              // Icon(Icons.location_on, color: kMainColor,size: 20,),
                                              // SizedBox(width: 5,),
                                              Flexible(
                                                  child: Text(
                                                vendor_list[index]
                                                        .OWNERNAME
                                                        .isEmpty
                                                    ? "Supplier: N.A."
                                                    : "Supplier: ${vendor_list[index].OWNERNAME}",
                                              ))
                                            ],
                                          ),
                                        ))),

                                Expanded(
                                    child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 3),
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: SizedBox(
                                          height: 35,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    primaryButtonColor,
                                                textStyle: const TextStyle(
                                                    fontSize: 20)),
                                            onPressed: () {
                                              showAlert(
                                                  vendor_list[index].id,
                                                  vendor_list[index]
                                                      .CATEGORYAUTOID);
                                            },
                                            child: const Center(
                                              child: Text(
                                                'Approve',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: SizedBox(
                                          height: 35,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    secondaryButtonColor,
                                                textStyle: const TextStyle(
                                                    fontSize: 20)),
                                            onPressed: () {
                                              showAlertDisapprove(
                                                  vendor_list[index].id,
                                                  vendor_list[index]
                                                      .CATEGORYAUTOID);
                                            },
                                            child: const Center(
                                              child: Text(
                                                'Disapprove',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),

                                Divider(
                                  height: 5,
                                  thickness: 5,
                                  color: Colors.grey[500],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //totalRatingUi(),
                                // InkWell(
                                // onTap: (){
                                // //Share.share("${vendorList[index].name} \n\n Supplire: ${vendorList[index].supplier}\n\n Min-Max Price: ${vendorList[index].minMaxPrice}");
                                // },
                                // child: Container(
                                // height: 30,
                                // alignment: Alignment.center,
                                // width: 40,
                                // decoration: BoxDecoration(
                                // color: Colors.black.withOpacity(.55),
                                // borderRadius: BorderRadius.circular(0),
                                // ),
                                // child:   const Icon(
                                // Icons.share,
                                // color: Colors.white,
                                // ),
                                // ),
                                // )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ):Container(),
          isApiCallProcessing == false && vendor_list.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: const Text('No vendors available'))
              : Container(),
          isApiCallProcessing == true
              ? Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: const GFLoader(type: GFLoaderType.circle),
                )
              : Container()
        ],
      ),
    );
  }

  Future<void> SendApproval_vendor(
      String vendor_id, String approval, String category_id) async {
    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }

    final body = {
      "vendor_auto_id": vendor_id,
      "category_auto_id": category_id,
      "admin_auto_id": admin_auto_id,
      //"user_auto_id": user_id,
      "status": approval,
    };

    var url = baseUrl + 'api/' + approve_vendor;
    print(body.toString());
    print(url);
    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing = false;

      final resp = jsonDecode(response.body);
      int status = resp['status'];
      print("status=>" + status.toString());
      if (status == 1) {
        Fluttertoast.showToast(
          msg: "Vendor " + approval + " successfully",
          backgroundColor: Colors.grey,
        );
        vendor_list.clear();
        getVendorData();
      } else {
        print('empty');
      }
      // if(mounted){
      //   setState(() {});
      // }
    } else if (response.statusCode == 500) {
      isApiCallProcessing = false;
      Fluttertoast.showToast(
        msg: "server error",
        backgroundColor: Colors.grey,
      );
    }
  }

  Future<bool> showAlert(String jobid, String category_id) async {
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
                      'Do you want to approve this vendor',
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
                            Navigator.pop(context);
                            SendApproval_vendor(jobid, 'Approved', category_id);
                          },
                          child: const Text("Yes",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[200],
                            //minimumSize: Size(70, 30),
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
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("No",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[200],
                            // minimumSize: Size(70, 30),
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

  Future<bool> showAlertDisapprove(String jobid, String category_id) async {
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
                      'Do you want to disapprove this vendor',
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
                            Navigator.pop(context);
                            SendApproval_vendor(
                                jobid, 'Disapproved', category_id);
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

  FutureOr onGoBack(dynamic value) {
    getVendorData();
  }
}
