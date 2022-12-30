import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Admin_add_Product/constants.dart';
import '../Vendor_Home/Utils/App_Apis.dart';
import 'Components/Model/VendorOrder_Model.dart';
import 'Components/Rest_Apis.dart';
import 'package:fluttertoast/fluttertoast.dart';

class order_details extends StatefulWidget {

  order_details(
      {Key? key,
        required this.order_auto_id,
        required this.vendor_id,
      })
      : super(key: key);

  String order_auto_id;
  String vendor_id;
  @override
  State<order_details> createState() => OrderDetailsState();
}

class OrderDetailsState extends State<order_details> {
  final int _index = 0;
  List<String> Order_status_list = [
    'Accept',
    'Reject',
    'Prepared',
    'Dispatched',
    'Completed',
    'Cancelled',
  ];
  VendorOrder_Model? vendor_new_order_model;
  List<Data>? Order_dataList = [];
  String? order_status;
  String product_name = "", color = "", MOQ = "", size = "", order_date = "", product_img = "", product_price = "", final_price = "", orderstatus = "";
  String user_id = "",baseUrl="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.order_auto_id);
    getBaseUrl();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text("Order Details",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),

        ),
        bottomSheet: Checkout_Section(context),
        body: Container(
            margin: const EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
                child: Column(

              children: [
                Card(
                    margin: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Container(
                          child: const Align(
                            alignment: Alignment.topLeft,
                            child:  Text(
                              'Order Details',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                              textScaleFactor: 1,
                              softWrap: true,
                            ),
                          ),
                          margin: const EdgeInsets.only(left: 15),
                        ),
                        const Divider(
                          thickness: 1,
                          // thickness of the line
                          indent: 0,
                          // empty space to the leading edge of divider.
                          endIndent: 0,
                          // empty space to the trailing edge of the divider.
                          color: Colors.black12,

                          height: 15, // The divider's height extent.
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child:  Text(
                                       product_name,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                        textScaleFactor: 1,
                                        softWrap: true,
                                      ),

                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Color:',
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          color,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'MOQ:',
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          MOQ,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Status:',
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          orderstatus,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Size:',
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          size,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child:  Container(
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
                                    product_img_base_url + product_img,
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
                              flex: 1,
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 15, bottom: 10),
                          child: Column(
                            children: [

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 0, top: 5, bottom: 5, right: 5),
                                    child: const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Order Date:',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                        textScaleFactor: 1,
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 5, top: 5, bottom: 5, right: 18),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child:  Text(
                                         order_date,
                                        style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                        textScaleFactor: 1,
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                Divider(color: Colors.grey.shade300),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Order Status",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                          textScaleFactor: 1,
                          softWrap: true,),
                        const SizedBox(
                          height: 8,
                        ),
                        Center(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              hint: Row(
                                children: const [
                                  Expanded(
                                    child: Text(
                                      'Select Order Status',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              items: Order_status_list.map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )).toList(),
                              value: order_status,
                              onChanged: (value) {
                                setState(() {
                                  order_status = value as String;
                                });
                              },
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                              ),
                              iconEnabledColor: Colors.black,
                              iconDisabledColor: Colors.grey,
                              buttonHeight: 45,
                              buttonWidth: MediaQuery.of(context).size.width,
                              buttonPadding:
                              const EdgeInsets.only(left: 14, right: 14),
                              buttonDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.black26,
                                ),
                              ),
                              itemHeight: 30,
                              itemPadding: const EdgeInsets.only(left: 14, right: 14),
                              dropdownMaxHeight: 150,
                              dropdownWidth: MediaQuery.of(context).size.width,
                              dropdownPadding: const EdgeInsets.only(left: 10, right: 10),
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              dropdownElevation: 8,
                              scrollbarRadius: const Radius.circular(40),
                              scrollbarThickness: 1,
                              scrollbarAlwaysShow: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(color: Colors.grey.shade300),
                Card(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          child: const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Shipping Address',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                              textScaleFactor: 1,
                              softWrap: true,
                            ),
                          ),
                          margin: const EdgeInsets.only(left: 15, top: 5),
                        ),
                        const Divider(
                          thickness: 1,
                          // thickness of the line
                          indent: 0,
                          // empty space to the leading edge of divider.
                          endIndent: 0,
                          // empty space to the trailing edge of the divider.
                          color: Colors.black12,
                          // The color to use when painting the line.
                          height: 15, // The divider's height extent.
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: const SizedBox(
                            width: 320,
                            child: Text(
                              'Gandhi Nagar,\nnear Laxmi Complex,\nPune,Maharshtra - 448855',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                              textScaleFactor: 1,
                              softWrap: true,
                            ),
                          ),
                        ),
                      ]),
                ),
                Card(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          child: const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Payment Details',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                              textScaleFactor: 1,
                              softWrap: true,
                            ),
                          ),
                          margin: const EdgeInsets.only(left: 0),
                        ),
                        const Divider(
                          thickness: 1,
                          // thickness of the line
                          indent: 0,
                          // empty space to the leading edge of divider.
                          endIndent: 0,
                          // empty space to the trailing edge of the divider.
                          color: Colors.black12,
                          // The color to use when painting the line.
                          height: 15, // The divider's height extent.
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Original Price:',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Rs."+product_price,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Offer Price:',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Rs."+final_price+"  ",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Order Total:',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Rs."+final_price+"  ",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),

              ],
            ))));
  }

  Widget Checkout_Section(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.grey.shade50,
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () {
                Change_Order_Status(widget.order_auto_id, user_id, order_status as String);
              },
              child: const Center(
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if(baseUrl!=null){
      setState(() {
        this.baseUrl=baseUrl;
        get_Order_Details();
      });
    }
    return null;
  }
  void get_Order_Details() async {
    Rest_Apis restApis = Rest_Apis();

    restApis.getOrder_Details(user_id, widget.order_auto_id,baseUrl).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            vendor_new_order_model = value;
          });
        }

        if (vendor_new_order_model != null) {
          if (mounted) {
            setState(() {
              Order_dataList = vendor_new_order_model?.data!;
              product_name = Order_dataList![0].productName as String;
              orderstatus = Order_dataList![0].orderStatus as String;
              color = Order_dataList![0].colorName as String;
              order_date = Order_dataList![0].orderDate as String;
              MOQ = Order_dataList![0].quantity as String;
              size = Order_dataList![0].size as String;
              product_price = Order_dataList![0].productPrice as String;
              final_price = Order_dataList![0].productFinalPrice as String;
              product_img = Order_dataList![0].productImage as String;

            });
          }
        } else {

        }
      } else {}
    });
  }

  void Change_Order_Status(String orderAutoId, String userAutoId, String status) {

    if(status == 'Accept')
      {
        setState(() {
          status = "Prepared";
        });
      }

    Rest_Apis restApis=Rest_Apis();

    restApis.Change_Order_Status(orderAutoId, userAutoId, status,baseUrl).then((value){

      if(value!=null){

        int status =value;

        if(status == 1){

          Fluttertoast.showToast(msg: "Success", backgroundColor: Colors.grey,);
          get_Order_Details();

        }
        else if(status==0){

          Fluttertoast.showToast(msg: "Something went wrong", backgroundColor: Colors.grey,);
        }
        else{
          Fluttertoast.showToast(msg: "Something went wrong", backgroundColor: Colors.grey,);

        }
      }
    });

  }

}
