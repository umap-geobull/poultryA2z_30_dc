import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Admin_OrderDetails.dart';
import 'Components/Model/VendorOrder_Model.dart';
import 'Components/Rest_Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';

class Preparing_Order_List extends StatefulWidget {
  @override
  State<Preparing_Order_List> createState() => Preparing_Order_ListState();
}

class Preparing_Order_ListState extends State<Preparing_Order_List> {

  VendorOrder_Model? vendor_new_order_model;
  List<Data>? Order_dataList = [];
  String user_id = "",admin_auto_id='';
  String baseUrl='',select_color='Select Color Name';
  bool isApiCallProcess = false;
  late Route routes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
  }

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId=prefs.getString('admin_auto_id');
    if (userId != null && baseUrl!=null && adminId!=null) {
      setState(() {
        user_id = userId;
        this.baseUrl=baseUrl;
        this.admin_auto_id=adminId;

        get_Vendor_Preparing_order_products();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: isApiCallProcess == true?
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const GFLoader(type: GFLoaderType.circle),
          ) : Order_dataList!.isNotEmpty ?
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
              )):
          Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: const Text("No Order found", style:  TextStyle(fontSize: 14, color: Colors.black),),
        )
        ));
  }

  Widget Brandcard(
      String productOrderAutoId,
      String productAutoId,
      String orderId,
      String productName,
      String orderStatus,
      String productImg,
      String color,
      String size,
      String orderdate,
      String quantity)
  {
    return GestureDetector(
      onTap: (){
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Order_detail(orderId,productOrderAutoId)));
        gotoOrderScreen(orderId,productOrderAutoId);
      },
      child: SizedBox(
        height: 150,
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
                      margin: const EdgeInsets.only(
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
                              child: productImg != ''
                                  ? CachedNetworkImage(
                                height: 90,
                                width: 90,
                                imageUrl:baseUrl+product_base_url + productImg,
                                placeholder: (context, url) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[400],
                                    )),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )
                                  : Container(
                                  child: const Icon(Icons.error),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[400],
                                  )),
                            ),
                          ),
                          color!=select_color?Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Color:',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                color,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ):Container(),
                          size!=''?Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Size:',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                size,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ):Container()
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      margin: const EdgeInsets.only(
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
                                productName,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                                textScaleFactor: 1,
                                softWrap: true,
                              ),
                              const SizedBox(
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
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        quantity,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
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
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        orderStatus,
                                        style: const TextStyle(
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
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
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
                                  const SizedBox(width: 6),
                                  SizedBox(
                                    height: 20,
                                    child: Text(
                                      orderdate,
                                      style: const TextStyle(
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
  
  gotoOrderScreen(String orderId, String productOrderAutoId,){
    routes = MaterialPageRoute(builder: (context) => Order_detail(orderId,productOrderAutoId));
    Navigator.push(context, routes).then(onGoOrderScreen);
  }

  FutureOr onGoOrderScreen(dynamic value) {
    get_Vendor_Preparing_order_products();
    if(this.mounted) {
      setState(() {});
    }
  }
  
  void get_Vendor_Preparing_order_products() async {
    if (mounted) {
      setState(() {
        isApiCallProcess = true;
      });
    }
    Rest_Apis restApis = Rest_Apis();

    restApis.getVendor_Preparing_orders(user_id,admin_auto_id,baseUrl).then((value) {
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
        }
      } else {
        if (mounted) {
          setState(() {
            isApiCallProcess = false;
          });
        }
      }
    });
  }
}


