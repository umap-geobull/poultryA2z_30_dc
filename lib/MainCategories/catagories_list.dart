import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:poultry_a2z/Utils/AppConfig.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Add_Vendor_Screen/Model/VendorListModel.dart';
import '../Consultant/Model/consultant_result_model.dart';
import '../Utils/App_Apis.dart';
import '../Vendor_Module/Vendor_details.dart';
import 'package:http/http.dart' as http;

import '../poultry_vendor/vendor_details_customer.dart';

class VendorCatagoriesList extends StatefulWidget {
  final String categoryId;
  const VendorCatagoriesList({Key? key, required this.categoryId}) : super(key: key);

  @override
  State<VendorCatagoriesList> createState() => _VendorCatagoriesListState();
}

class _VendorCatagoriesListState extends State<VendorCatagoriesList> {
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;
  Color bottomBarColor=Colors.white, bottomMenuIconColor=Color(0xFFFF7643);
  String baseUrl='',admin_auto_id='';
  String user_id = '',app_type_id='';
  bool isApiCallProcessing = false;
  List<GetVendorListCategory> data = [];
  getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');
    if(baseUrl!=null && adminId!=null && userId != null && apptypeid!=null){
      if(this.mounted){
        setState(() {
          this.admin_auto_id=adminId;
          this.baseUrl = baseUrl;
          this.user_id = userId;
          this.app_type_id=apptypeid;
         getVendor();

        });
      }
    }
  }


  void getVendor() async {
    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }

    var url = AppConfig.grobizBaseUrl + get_pountry_vendor;

    var uri = Uri.parse(url);

    final body = {
      "ADMIN_AUTO_ID": admin_auto_id,
      "APP_TYPE_ID": app_type_id,
      "CATEGORY_AUTO_ID": widget.categoryId,
    };

    print("vendor Body ${body}");
    print("vendor Url ${uri}");

    final response = await http.post(uri, body: body);
    print("vendor response ${response.body}");
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      String status = resp['status'];
      if (status == '1') {
        VendorListModel vendorListModel =
        VendorListModel.fromJson(json.decode(response.body));
        data = vendorListModel.data;

        print("Consult List ${data}");
        if (mounted) {
          setState(() {});
        }
        setState(() {
          isApiCallProcessing = false;
        });
      } else {  setState(() {
        isApiCallProcessing = false;
      });}
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child:isApiCallProcessing == true
            ? Container(
          height: MediaQuery.of(context).size.height * 0.8,
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: const GFLoader(type: GFLoaderType.circle),
        )
            :(isApiCallProcessing == false && data.isEmpty )?Container(
          height: MediaQuery.of(context).size.height * 0.8,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: const Text("Vendors not available"),
    ): Container(
            height: MediaQuery.of(context).size.height/1.15,
            padding: const EdgeInsets.only(top: 10),
            margin: EdgeInsets.only(left: 15,right: 15),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: data.length,
              itemBuilder: (context, index) =>
                  InkWell(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => VendorDetailsWithCustomer( vendor: data[index],)));
                    },
                    child: Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              data[index].SUPPLIERPROFILE.isEmpty? Expanded(
                                  flex: 5,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 220,
                                    color: Colors.grey[200],
                                    child: Icon(Icons.image,color: Colors.black,size: 45,),
                                  )):Expanded(
                                flex: 5,
                                    child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width,
                                height: 220,
                                imageUrl:
                                "https://grobiz.app/GRBCRM2022/PoultryEcommerce/images/products/${data[index].SUPPLIERPROFILE}",
                                placeholder: (context, url) =>
                                new Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 220,
                                    color: Colors.grey,
                                ),
                                errorWidget: (context, url, error) =>
                                      Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 220,
                                          color: Colors.grey,child: new Icon(Icons.error)),
                              ),
                                  ),
                              Expanded(
                                  flex: 1,
                                  child:  Padding(
                                    padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                    child: Text(data[index].FIRMNAME.isEmpty ? "N.A.":data[index].FIRMNAME,
                                      style: TextStyle(color: Colors.blueGrey,fontSize: 20), ),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child:Padding(
                                        padding: EdgeInsets.only(left: 10,right: 10,bottom: 2,top: 5),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            // Icon(Icons.location_on, color: kMainColor,size: 20,),
                                            // SizedBox(width: 5,),
                                            Flexible(child: Text(data[index].OWNERNAME.isEmpty ? "Supplier: N.A.":"Supplier: ${data[index].OWNERNAME}",))
                                          ],
                                        ),
                                      )
                                  )),


                              Padding(
                                padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    // Icon(Icons.location_on, color: kMainColor,size: 20,),
                                    // SizedBox(width: 5,),
                                    // Flexible(child: Text("Price: "+data[index].MINORDERVALUE)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        // Text(
                                        //   '4',
                                        //   style: TextStyle(
                                        //     color: Colors.yellowAccent,
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        // Icon(
                                        //   Icons.star,
                                        //   color: Colors.orangeAccent,
                                        //   size: 10,
                                        // ),
                                        // Text(
                                        //   '| ' + total_reviews.toString()+"  total reviews",
                                        //   style: TextStyle(
                                        //     color: kWhiteColor,
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        Container(
                                          width: 80,
                                          height: 35,
                                          // color: primaryButtonColor,
                                          child: ElevatedButton(
                                            onPressed: () async{

                                              const url = "tel:8390679867";
                                              if (await canLaunch(url)) {
                                                await launch(url);
                                              } else {
                                                throw 'Could not launch $url';
                                              }

                                            },
                                            child: const Text('Call'),
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(200,50),
                                              backgroundColor: primaryButtonColor,
                                              shape: const StadiumBorder(),
                                              shadowColor: Colors.grey,
                                              elevation: 5,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        SizedBox(width: 100,
                                          height: 35,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              const uri = 'sms:+ 9898765444?body=hello%20there';
                                              if (await canLaunch(uri)) {
                                                await launch(uri);
                                              } else {
                                                // iOS
                                                const uri = 'sms:0039-222-060-888?body=hello%20there';
                                                if (await canLaunch(uri)) {
                                                  await launch(uri);
                                                } else {
                                                  throw 'Could not launch $uri';
                                                }
                                              }
                                            },
                                            child: const Text('Message'),
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(200,50),
                                              backgroundColor: secondaryButtonColor,
                                              shape: const StadiumBorder(),
                                              shadowColor: Colors.grey,
                                              elevation: 5,
                                            ),
                                          ),)
                                      ],
                                    )
                                  ],
                                ),
                              ),

                              // Expanded(
                              //     flex: 1,
                              //     child:
                              //     SizedBox(
                              //     width: MediaQuery.of(context).size.width,
                              //     height: 50,
                              //     child:
                              //     Padding(
                              //       padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                              //       child: Row(
                              //         //crossAxisAlignment: CrossAxisAlignment.start,
                              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //         crossAxisAlignment: CrossAxisAlignment.center,
                              //         children: <Widget>[
                              //           // Icon(Icons.location_on, color: kMainColor,size: 20,),
                              //           // SizedBox(width: 5,),
                              //           Flexible(child: Text(vendorList[index].fees)),
                              //           contactUi()
                              //         ],
                              //       ),
                              //     )
                              // )
                              // ),

                              Divider(
                                height: 10,
                                thickness: 5,
                                color: Colors.grey[500],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              totalRatingUi(),
                              InkWell(
                                onTap: (){
                                  Share.share("${vendorList[index].name} \n\n Supplire: ${vendorList[index].supplier}\n\n Min-Max Price: ${vendorList[index].minMaxPrice}");
                                },
                                child: Container(
                                  height: 30,
                                  alignment: Alignment.center,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(.55),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child:   const Icon(
                                      Icons.share,
                                      color: Colors.white,
                                    ),




                                ),
                              )
                            ],),
                        ],),
                      ),
                    ),
                  ),
            )
        ),

    );
  }

  totalRatingUi() {

    return Container(
      width: MediaQuery.of(context).size.width/5,
      height: 25,
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 0, right: 10, bottom: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.55),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '4',
              style: TextStyle(
                color: Colors.yellowAccent,
                fontSize: 12,
              ),
            ),
            Icon(
              Icons.star,
              color: Colors.orangeAccent,
              size: 10,
            ),
            // Text(
            //   '| ' + total_reviews.toString()+"  total reviews",
            //   style: TextStyle(
            //     color: kWhiteColor,
            //     fontSize: 12,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  shareUi() {
    return Container(
      height: 20,
      alignment: Alignment.topRight,
      width: 40,
      child: IconButton(
        icon:  const Icon(
          Icons.share,
          color: Colors.grey,
        ),

        onPressed: () =>
        {

        },
      ),
    );
  }
}
