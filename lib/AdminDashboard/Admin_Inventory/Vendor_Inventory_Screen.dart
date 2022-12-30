import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:poultry_a2z/AdminDashboard/Admin_Inventory/Edit_Inventory.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Products/all_products_model.dart';
import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/Vendor_Module/Vendor_Home/Utils/scrollable_widget.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Add_Market_List.dart';
import 'Add_Product_Inventory.dart';
import 'Components/Model/Vendor_Inventory_Model.dart';
import 'Components/Rest_Apis.dart';
import 'Vendor_BestSelling_Report.dart';
import 'Vendor_Tranding_Report.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';


class Venders_Invetory extends StatefulWidget {
  Venders_Invetory(
      {Key? key,
        required this.vendor_id,
        required this.admin_id,
      })
      : super(key: key);
  String vendor_id;
  String admin_id;

  @override
  _Venders_InvetoryState createState() => _Venders_InvetoryState();
}

class _Venders_InvetoryState extends State<Venders_Invetory> {
  //String user_id = "",

  String start_date = "", end_date = "",admin_id='',app_type_id='';
  List<Vendor_Inventory_data> vendor_inventory_DataList = [];
  late List<Vendor_Inventory_data> inventory_models;
//  List<ProductModel> getProduct_List = [];
  String baseUrl="";

  ScrollController _headerScrollController = ScrollController();
  ScrollController _rowScrollController = ScrollController();
  LinkedScrollControllerGroup? commonScrollController;

  bool isloading=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    commonScrollController = LinkedScrollControllerGroup();
    _headerScrollController = commonScrollController!.addAndGet();
    _rowScrollController = commonScrollController!.addAndGet();

    getUserId();

   // this.user_id=widget.vendor_id;
   // this.admin_id=widget.admin_id;
    inventory_models = List.of(vendor_inventory_DataList);
  }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Inventory",
            style: TextStyle(color: Colors.black, fontSize: 18)),
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, left: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    flex: 8,
                    child: Text("INVENTORY OVER LAST 30 DAYS",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(right: 10),
                        height: 30,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,

                              // changes position of shadow
                            ),
                          ],
                        ),
                        child: const Icon(Icons.more_horiz,
                            color: Colors.black, size: 22),
                      ),
                      onTap: () => {show_PrintMenu()},
                    ),
                  )
                ],
              ),
              Container(
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                      "Track and understand the movement of your products for more efficient inventory management",
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                ),
              ),
              Divider(color: Colors.grey.shade300),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Flexible(
                            flex: 8,
                            child: Container(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  width: 250,
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text("See Inventory List",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                )),
                          ),
                          Flexible(
                            flex: 1,
                            child: GestureDetector(
                              child: Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.grey.shade100),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,

                                      // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.more_horiz,
                                    color: Colors.black, size: 22),
                              ),
                              onTap: () => {show_DropDown()},
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade300),
              Container(
                  child: vendor_inventory_DataList!.isEmpty
                      ? Container(
                          alignment: Alignment.center,
                          height: 400,
                          width: MediaQuery.of(context).size.height,
                          child: const Text(
                            "No Inventory found",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        )
                      : ScrollableWidget(child: buildDataTable())),
            ],
          ),
        ),
      ),
    );
  }
*/

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text("Inventory",
              style: TextStyle(color: Colors.black, fontSize: 18)),
          leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        body:Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      const Expanded(
                        flex: 8,
                        child: Text("INVENTORY OVER LAST 30 DAYS",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 10),
                            height: 30,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade100),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,

                                  // changes position of shadow
                                ),
                              ],
                            ),
                            child: const Icon(Icons.more_horiz,
                                color: Colors.black, size: 22),
                          ),
                          onTap: () => {show_PrintMenu()},
                        ),
                      )
                    ],
                  ),
                  Container(
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                          "Track and understand the movement of your products for more efficient inventory management",
                          style: TextStyle(color: Colors.black, fontSize: 14)),
                    ),
                  ),
                  Divider(color: Colors.grey.shade300),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Flexible(
                                flex: 8,
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      width: 250,
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text("See Inventory List",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    )),
                              ),
                              Flexible(
                                flex: 1,
                                child: GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 30,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border:
                                      Border.all(color: Colors.grey.shade100),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,

                                          // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.more_horiz,
                                        color: Colors.black, size: 22),
                                  ),
                                  onTap: () => {show_DropDown()},
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey.shade300),

                  vendor_inventory_DataList.isNotEmpty?
                  Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 1.2,
                          width: 1000,
                          child: Column(
                            children: [
                              Container(
                                  height: 55,
                                  padding: EdgeInsets.all(10),
                                  //  color: Colors.black12,
                                  child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Product Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black, fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                      flex: 3,
                                    ),
                                    Expanded(
                                        child: Text(
                                          'Stock',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black, fontSize: 14),
                                          textAlign: TextAlign.center,
                                        ),
                                        flex: 2),
                                    Expanded(
                                        child: Text(
                                          'Available Stock',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black, fontSize: 14),
                                          textAlign: TextAlign.center,
                                        ),
                                        flex: 2),
                                    Expanded(
                                        child: Text(
                                          'Required Stock',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black, fontSize: 15),
                                          textAlign: TextAlign.center,
                                        ),
                                        flex: 2),
                                    Expanded(
                                        child: Text(
                                          'Stock Alert Limit',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black, fontSize: 14),
                                          textAlign: TextAlign.center,
                                        ),
                                        flex: 2),
                                    Expanded(
                                        child: Text(
                                          'Out Of stock',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black, fontSize: 14),
                                          textAlign: TextAlign.center,
                                        ),
                                        flex: 2),
                                    Expanded(
                                        child: Text(
                                          '',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black, fontSize: 14),
                                          textAlign: TextAlign.center,
                                        ),
                                        flex: 2)
                                  ])),
                              Divider(height: 2,),
                              Expanded(
                                  child: ListView.builder(
                                      itemCount: vendor_inventory_DataList.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return
                                        Container(
                                          //height: 35,
                                            margin: EdgeInsets.only(
                                                left: 2, right: 2 ),
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child:Column(
                                              children: <Widget>[
                                                Container(
                                                  child: Row(children: [
                                                    Expanded(
                                                      child:Container(
                                                        child: Text(
                                                          vendor_inventory_DataList[index].productName!,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              //fontWeight: FontWeight.bold,
                                                              color: Colors.black),
                                                        ),
                                                        margin: EdgeInsets.only(left: 5,right: 5),
                                                      ),
                                                      flex: 3,
                                                    ),
                                                    Expanded(
                                                        child:Container(
                                                          margin: EdgeInsets.only(left: 5,right: 5),
                                                          child: Text(
                                                            vendor_inventory_DataList[index].totalProductStock!,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                // fontWeight: FontWeight.bold,
                                                                color: Colors.black),
                                                          ),
                                                          alignment: Alignment.center,
                                                        ),
                                                        flex: 2
                                                    ),
                                                    Expanded(
                                                        child:Container(
                                                          margin: EdgeInsets.only(left: 5,right: 5),
                                                          child: Text(
                                                            vendor_inventory_DataList[index].availableProductStock!,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                // fontWeight: FontWeight.bold,
                                                                color: Colors.black),
                                                          ),
                                                          alignment: Alignment.center,
                                                        ),
                                                        flex: 2),
                                                    Expanded(flex: 2,

                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        margin: EdgeInsets.only(left: 5,right: 5),
                                                        child: Text(
                                                          vendor_inventory_DataList[index].requiredStock!,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              // fontWeight: FontWeight.bold,
                                                              color: Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child:Container(
                                                          alignment: Alignment.center,
                                                          margin: EdgeInsets.only(left: 5,right: 5),
                                                          child: Text(
                                                            vendor_inventory_DataList[index].productStockAlertLimit!,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                //  fontWeight: FontWeight.bold,
                                                                color: Colors.black),
                                                          ),
                                                        ),
                                                        flex: 2),
                                                    Expanded(
                                                        child:Container(
                                                          alignment: Alignment.center,
                                                          margin: EdgeInsets.only(left: 5,right: 5),
                                                          child: Text(
                                                            vendor_inventory_DataList[index].status!,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                // fontWeight: FontWeight.bold,
                                                                color: Colors.black),
                                                          ),
                                                        ),
                                                        flex: 2),
                                                    Expanded(
                                                        child:
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(builder: (context) =>
                                                                    EditInventory(
                                                                        vendor_inventory_DataList[index].productAutoId!,
                                                                        admin_id,
                                                                        app_type_id))).then(onGoBack);
                                                          },
                                                          child: Container(
                                                            // margin: EdgeInsets.all(10),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  color: Colors.white,
                                                                  width: 10,
                                                                ),
                                                                color: Colors.orangeAccent,
                                                                borderRadius: BorderRadius.circular(10)
                                                            ),
                                                            alignment: Alignment.center,
                                                            width: 30,
                                                            height: 50,
                                                            child: Text('Edit',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                                                                fontSize: 15),),
                                                          ),
                                                        ),
                                                        flex: 2),
                                                  ]
                                                  ),
                                                ),
                                                Divider(height: 2,)
                                              ],
                                            ));
                                      })
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ):
                  Container(),

                ],
              ),
            ),

            isloading == false && vendor_inventory_DataList.isEmpty ?
            Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.height,
                height: MediaQuery.of(context).size.width,
                child: Text('No Inventory Available')):
            Container(),

            isloading == true ?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.height,
              height: MediaQuery.of(context).size.width,
              child: const GFLoader(type: GFLoaderType.circle),):
            Container()
          ],
        )
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text("Inventory",
              style: TextStyle(color: Colors.black, fontSize: 18)),
          leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        body:Stack(
          children: <Widget>[
            SingleChildScrollView(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(bottom: 60),
                    height: MediaQuery.of(context).size.height,
                    child:Column(
                      children: <Widget>[
                        Row(
                          children: [
                            const Expanded(
                              flex: 8,
                              child: Text("INVENTORY OVER LAST 30 DAYS",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(right: 10),
                                  height: 30,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey.shade100),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,

                                        // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.more_horiz,
                                      color: Colors.black, size: 22),
                                ),
                                onTap: () => {show_PrintMenu()},
                              ),
                            )
                          ],
                        ),
                        Container(
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                                "Track and understand the movement of your products for more efficient inventory management",
                                style: TextStyle(color: Colors.black, fontSize: 14)),
                          ),
                        ),
                        Divider(color: Colors.grey.shade300),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 8,
                                      child: Container(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            width: 250,
                                            child: const Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Text("See Inventory List",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold)),
                                            ),
                                          )),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: GestureDetector(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 30,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border:
                                            Border.all(color: Colors.grey.shade100),
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 1,

                                                // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: const Icon(Icons.more_horiz,
                                              color: Colors.black, size: 22),
                                        ),
                                        onTap: () => {show_DropDown()},
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Colors.grey.shade300),

                        SingleChildScrollView(
                            controller: _headerScrollController,
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: <Widget>[
                                headingrow()
                              ],
                            )
                        ),

                        Expanded(
                            flex:1,
                            child:  vendor_inventory_DataList!=null && vendor_inventory_DataList.isNotEmpty?
                            SingleChildScrollView(
                              controller: _rowScrollController,
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                  children: <Widget>[
                                    Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: _createRow(),
                                          ),
                                        )
                                    )
                                  ]),
                            ):
                            Container()
                        ),
                      ],
                    )
                )
            ),

            isloading == false && vendor_inventory_DataList.isEmpty ?
            Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.height,
                height: MediaQuery.of(context).size.width,
                child: Text('No Inventory Available')):
            Container(),

            isloading == true ?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.height,
              height: MediaQuery.of(context).size.width,
              child: const GFLoader(type: GFLoaderType.circle),):
            Container()
          ],
        )
    );
  }

  Widget headingrow() {
    return Container(
      color: Colors.white,
      height: 50,
      //margin: EdgeInsets.only(left: 102, right: 8),
      child:
      ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              alignment: Alignment.center,
              width: 200,
              child: Text(
                'Product Name',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black, fontSize: 14),
              ),

            ),
            Container(
              alignment: Alignment.center,

              width: 100,
              child: Text(
                'Total Stock',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black, fontSize: 14),
              ),
            ),
            Container(
              alignment: Alignment.center,

              width: 100,
                child: Text(
                  'Available Stock',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
            ),
            Container(
              alignment: Alignment.center,

              width: 100,
                child: Text(
                  'Required Stock',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
            ),
            Container(
              width: 100,
                child: Text(
                  'Stock Alert Limit',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
            ),
            Container(
              alignment: Alignment.center,

              width: 100,
                child: Text(
                  'Out Of stock',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
            ),

            Container(
              alignment: Alignment.center,
              width: 150,
                child: Text(
                  '',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, fontSize: 14),
                  textAlign: TextAlign.center,
                ),

            ),
          ]
      ),
    );
  }

  List<Widget> _createRow() {
    List<Widget>rowWidgetList = [];

    for(int index = 0; index<vendor_inventory_DataList.length; index++){
      rowWidgetList.add(
          Container(
            //height: 35,
              margin: EdgeInsets.only(
                  left: 2, right: 2 ),
              padding: EdgeInsets.only(
                  left: 10, right: 10),
              child:Column(
                children: <Widget>[
                  Container(
                    child: Row(children: [
                      Container(
                        alignment: Alignment.center,

                        width: 200,
                        child:Container(
                          child: Text(
                            vendor_inventory_DataList[index].productName!,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 14,
                                //fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          margin: EdgeInsets.only(left: 5,right: 5),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child:Container(
                            margin: EdgeInsets.only(left: 5,right: 5),
                            child: Text(
                              textAlign: TextAlign.center,

                              vendor_inventory_DataList[index].totalProductStock!,
                              style: TextStyle(
                                  fontSize: 14,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            alignment: Alignment.center,
                          ),
                        width: 100,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child:Container(
                            margin: EdgeInsets.only(left: 5,right: 5),
                            child: Text(
                              textAlign: TextAlign.center,

                              vendor_inventory_DataList[index].availableProductStock!,
                              style: TextStyle(
                                  fontSize: 14,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            alignment: Alignment.center,
                          ),
                        width: 100,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 100,
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 5,right: 5),
                          child: Text(
                            textAlign: TextAlign.center,

                            vendor_inventory_DataList[index].requiredStock!,
                            style: TextStyle(
                                fontSize: 14,
                                // fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child:Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 5,right: 5),
                            child: Text(
                              textAlign: TextAlign.center,

                              vendor_inventory_DataList[index].productStockAlertLimit!,
                              style: TextStyle(
                                  fontSize: 14,
                                  //  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        width: 100,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child:Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 5,right: 5),
                            child: Text(
                              textAlign: TextAlign.center,

                              vendor_inventory_DataList[index].status!,
                              style: TextStyle(
                                  fontSize: 14,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        width: 100,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child:
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) =>
                                      EditInventory(
                                          vendor_inventory_DataList[index].productAutoId!,
                                          admin_id,
                                          app_type_id))).then(onGoBack);
                            },
                            child: Container(
                              // margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 10,
                                  ),
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              alignment: Alignment.center,
                              height: 50,
                              child: Text('Edit',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                                  fontSize: 15),),
                            ),
                          ),
                        width: 150,
                      ),
                    ]
                    ),
                  ),
                  Divider(height: 2,)
                ],
              ))
      );
    }

    rowWidgetList.add(SizedBox(height: 50,));

    return rowWidgetList;
  }

  Widget buildDataTable() {
    final columns = [
      'Product Name',
      'Stock',
      'Available Stock',
      'Required Stock',
      'Stock Alert Limit',
      'Out Of Stock'
    ];

    return DataTable(
      columns: getColumns(columns),
      rows: getRows(vendor_inventory_DataList!),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
          ))
      .toList();

  List<DataRow> getRows(List<Vendor_Inventory_data> inventoryModel) =>
      inventoryModel.map((Vendor_Inventory_data inventoryModel) {
        final cells = [
          inventoryModel.productName,
          inventoryModel.totalProductStock,
          inventoryModel.availableProductStock,
          inventoryModel.requiredStock,
          inventoryModel.productStockAlertLimit,
          inventoryModel.status
        ];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void show_DropDown() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(5.0),
            title: new Text(
              "Inventory Menu",
              style: TextStyle(
                  fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                height: 50,
                width: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     /* GestureDetector(
                        child: Text(
                          "Add Product Inventory",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                          ),
                        ),
                        onTap: () {
                          if(getProduct_List!.isEmpty)
                          {
                            Fluttertoast.showToast(
                              msg: "First add product",
                              backgroundColor: Colors.grey,
                            );
                          }
                          else{
                            Navigator.pop(context);

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => Product_Inventory(getProduct_List: getProduct_List, vendor_id: user_id,
                                    admin_id: admin_id)),).then(onGoBack);
                          }

                        },
                      ),
                      Divider(color: Colors.grey.shade300),
                     */
                      GestureDetector(
                        child: Text(
                          "See Trending Products",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    Venders_Tranding_ProductList())).then(onGoBack);
                        },
                      ),
                      Divider(color: Colors.grey.shade300),
                      // GestureDetector(
                      //   child: Text(
                      //     "See BestSelling Products",
                      //     style: TextStyle(
                      //       fontSize: 15,
                      //       color: Colors.blue,
                      //     ),
                      //   ),
                      //   onTap: () {
                      //     Navigator.of(context).pop();
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //           builder: (context) =>
                      //               Venders_BestSelling_ProductList(vendor_id: admin_id,)),).then(onGoBack);
                      //   },
                      // ),
                      // Divider(color: Colors.grey.shade300),
                   /*   GestureDetector(
                        child: Text(
                          "Add Market List",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => Venders_MarketList()),
                          );
                        },
                      ),*/
                    ],
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Dismiss",
                  style: TextStyle(fontSize: 15, color: Colors.orange),
                ),
              ),
            ],
          );
        });
  }

  FutureOr onGoBack(dynamic value) {
    get_Vendor_InventoryList();
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? apptypeid= prefs.getString('app_type_id');
    String? adminId =prefs.getString('admin_auto_id');

    if (baseUrl!=null && apptypeid!=null && adminId!=null) {
      setState(() {
        this.admin_id=adminId;
        this.baseUrl=baseUrl;
        this.app_type_id=apptypeid;
        DateTime firstDayCurrentMonth =
            DateTime.utc(DateTime.now().year, DateTime.now().month, 1);
        DateTime lastDayCurrentMonth = DateTime.utc(
          DateTime.now().year,
          DateTime.now().month + 1,
        ).subtract(const Duration(days: 1));

        start_date =
            DateFormat('yyyy-MM-dd').format(firstDayCurrentMonth).toString();
        end_date =
            DateFormat('yyyy-MM-dd').format(lastDayCurrentMonth).toString();
        get_Vendor_InventoryList();
        //getProducts();
      });
    }
    return null;
  }

  void get_Vendor_InventoryList() async {
    if(this.mounted){
      setState(() {
        isloading = true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.getVendor_Inventory_list(admin_id, start_date, end_date,baseUrl, admin_id)
        .then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            Vendor_Invetory_Model vendor_invetory_model= value;

            if (vendor_invetory_model != null) {
              if (mounted) {
                setState(() {
                  vendor_inventory_DataList = vendor_invetory_model.data!;
                });
              }
            } else {}
          });
        }

        if(this.mounted){
          setState(() {
            isloading = false;
          });
        }
      }
      else {
        if(this.mounted){
          setState(() {
            isloading = false;
          });
        }
      }
    });
  }

/*
  void getProducts() async {
    final body={
      "customer_auto_id": user_id,
      "admin_auto_id":admin_id,
      "app_type_id":app_type_id,
    };

    var url=baseUrl+'api/'+get_admin_products;
    var uri = Uri.parse(url);
    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        AllProductsModel allProductsModel=AllProductsModel.fromJson(json.decode(response.body));
        getProduct_List=allProductsModel.getProductsLists;
      }

      if(mounted){
        setState(() {
        });
      }
    }
    else if (response.statusCode == 500) {
      if(this.mounted){
        setState(() {
        });
      }
    }
  }
*/

  void show_PrintMenu() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(6.0),
            title: new Text(
              "Export to",
              style: TextStyle(
                  fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            content:Wrap(
              children: <Widget>[
                GestureDetector(
                  child:Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey,
                            width: 1
                        ),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    margin: EdgeInsets.only(left: 20,right: 20),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Text(
                          ".csv",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.arrow_circle_down,color: Colors.blue,size: 25,),
                            )
                        )
                      ],
                    ),
                  ),
                  onTap: () =>{
                    generateCsv(),
                    Navigator.pop(context)
                  },
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Dismiss",
                  style: TextStyle(fontSize: 15, color: Colors.orange),
                ),
              ),
            ],
          );
        });
  }

  generateCsv() async {
    List<List<String>> dataList=[];

    List<String> data=[];

    // data.add('Id');
    // data.add('User Id');
    // data.add('Product Id');
    data.add('Product Name');
    //data.add('Unit');
    data.add('Total Stock');
    data.add('Available Stock');
    data.add('Required Stock');
    data.add('Stock Alert Limit');
    data.add('Status');
    dataList.add(data);


    for(int index=0; index<vendor_inventory_DataList!.length ;index++){
      Vendor_Inventory_data dataModel=vendor_inventory_DataList![index];
      List<String> data=[];

      // data.add(dataModel.inventaryAutoId!);
      // data.add(dataModel.userAutoId!);
      // data.add(dataModel.productAutoId!);
      data.add(dataModel.productName!);
     // data.add(dataModel.productUnit!);
      data.add(dataModel.totalProductStock!);
      data.add(dataModel.availableProductStock!);
      data.add(dataModel.requiredStock!);
      data.add(dataModel.productStockAlertLimit!);
      data.add(dataModel.status!);

      dataList.add(data);
    }

    String csvData = ListToCsvConverter().convert(dataList);

    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/inventory${DateTime.now()}.csv').create();
    await file.writeAsString(csvData);

    if(file!=null){
      ShareExtend.share(file.path, "file");

      //shareFile(file);
    }
  }

}
