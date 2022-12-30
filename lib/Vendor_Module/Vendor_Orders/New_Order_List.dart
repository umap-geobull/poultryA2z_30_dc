import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import '../Vendor_Home/Utils/App_Apis.dart';
import 'Components/Model/VendorOrder_Model.dart';
import 'Components/Rest_Apis.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Order_Details.dart';

class New_Order_List extends StatefulWidget {
  late String Vendorid;
  New_Order_List(String vendorId)
  {
    Vendorid=vendorId;
  }

  @override
  State<New_Order_List> createState() => New_Order_ListState();
}

class New_Order_ListState extends State<New_Order_List> {
  VendorOrder_Model? vendor_new_order_model;
  List<Data>? Order_dataList = [];
  String user_id = "";
  bool isApiCallProcess = false;
  String baseUrl='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child:isApiCallProcess == true?
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GFLoader(type: GFLoaderType.circle),
          ): Order_dataList!.isNotEmpty ?
          ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: Order_dataList!.length,
              itemBuilder: (context, index) => Brandcard(
                Order_dataList![index].productOrderAutoId as String,
                Order_dataList![index].productAutoId as String,
                Order_dataList![index].orderId as String,
                Order_dataList![index].productName as String,
                Order_dataList![index].orderStatus as String,
                Order_dataList![index].productImage as String,
                Order_dataList![index].colorName as String,
                Order_dataList![index].size as String,
                Order_dataList![index].orderDate as String,
                Order_dataList![index].quantity as String,
              )):Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Text("No Order found", style:  TextStyle(fontSize: 14, color: Colors.black),),
          ),
        ));
  }

  Widget Brandcard(
      String product_order_auto_id,
      String product_auto_id,
      String order_id,
      String product_name,
      String order_status,
      String product_img,
      String color,
      String size,
      String orderdate,
      String quantity)
  {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => order_details(order_auto_id: product_order_auto_id,vendor_id: user_id,)));

      },
      child: SizedBox(
        // height: 230,
        child: Card(
          shadowColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 10,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 10, top: 5, right: 5, bottom: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: product_img != ''
                                  ? CachedNetworkImage(
                                height: 90,
                                width: 90,
                                imageUrl:
                                baseUrl+product_img_base_url + product_img,
                                placeholder: (context, url) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[400],
                                    )),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                                  : Container(
                                  child: Icon(Icons.error),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[400],
                                  )),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Color:',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                color,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Size:',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                size,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product_name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                                textScaleFactor: 1,
                                softWrap: true,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Product Quantity: ',
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                        softWrap: true,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        quantity,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Order Status: ',
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                        softWrap: true,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        order_status,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: Text(
                                      'Order Date:',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                      softWrap: true,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  SizedBox(
                                    height: 20,
                                    child: Text(
                                      orderdate,
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? userId = prefs.getString('user_id');
    String? baseUrl =prefs.getString('base_url');
    if(baseUrl!=null){
      this.baseUrl=baseUrl;
      setState(() {
        user_id=widget.Vendorid;
        get_Vendor_new_order_products();
      });
    }
    return null;
  }

  void get_Vendor_new_order_products() async {
    if (this.mounted) {
      setState(() {
        isApiCallProcess = true;
        print('isapicall=' + isApiCallProcess.toString());
      });
    }
    Rest_Apis restApis = new Rest_Apis();

    restApis.getVendor_New_orders(user_id,baseUrl).then((value) {
      if (value != null) {

        if (mounted) {
          setState(() {
            isApiCallProcess = false;
            vendor_new_order_model = value;
          });
        }

        if (vendor_new_order_model != null) {
          if (mounted) {
            setState(() {
              isApiCallProcess = false;
              Order_dataList = vendor_new_order_model?.data!;
            });
          }
        } else {
          setState(() {
            isApiCallProcess = false;
            Fluttertoast.showToast(
              msg: "No data",
              backgroundColor: Colors.grey,
            );
          });
        }
      } else {
        setState(() {
          isApiCallProcess = false;
          Fluttertoast.showToast(
            msg: "Something went wrong",
            backgroundColor: Colors.grey,
          );
        });
      }
    });
  }
}
