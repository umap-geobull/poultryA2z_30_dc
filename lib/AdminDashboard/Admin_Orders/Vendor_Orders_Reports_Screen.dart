import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Components/Model/Vendor_Order_Report_Model.dart';
import 'Components/Rest_Apis.dart';
import 'Components/scrollable_widget.dart';
import 'Select_Date_Range.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';


class Vendor_Orders_Reports extends StatefulWidget {
   Vendor_Orders_Reports({Key? key,
     required this.s_date,
     required this.e_date,
     required this.s_date1,
     required this.e_date1,})
       : super(key: key);
   String s_date, e_date, s_date1, e_date1;

  @override
  _Vendor_Orders_ReportsState createState() => _Vendor_Orders_ReportsState();
}

class _Vendor_Orders_ReportsState extends State<Vendor_Orders_Reports> {
  List<String> Range_List = [
    'Last 90 Days',
    'Last Month',
    'Last Week',
    'Last Year',
    '1st Quarter',
    '2nd Quarter',
    '3rd Quarter',
    '4th Quarter'

  ];
  String start_date = "", end_date = "",start_date1 = "", end_date1 = "";
  int order_count = 0;
  String?  selected_range;
   late List<Vendor_Order_Report_Data> orderreports;
  Vendor_Order_Report_Model? vendor_order_report_model;
  List<Vendor_Order_Report_Data>? Order_Report_dataList = [];

  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();

  String user_id = "",admin_auto_id='';
  String baseUrl='';

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId= prefs.getString('admin_auto_id');

    if (userId != null && baseUrl!=null && adminId!=null) {
      setState(() {
        user_id = userId;
        this.baseUrl=baseUrl;
        this.admin_auto_id=adminId;

        getCurrent_Date();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();

    orderreports = List.of(Order_Report_dataList!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Reports",
            style: TextStyle(color: appBarIconColor, fontSize: 18)),
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: const Icon(Icons.arrow_back, color: appBarIconColor),
        ),

      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          flex:8,
                          child:   Text("ORDERS OVER LAST 30 DAYS",
                              style: TextStyle(color: Colors.black, fontSize: 15)),

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
                            onTap: ()=>{
                              show_PrintMenu()

                            },
                          ),
                        )
                      ],
                    ),
                    Text(order_count.toString(),
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                        "Get a sense of your store's order volumn and flow as well as fullfilment performance, with orders reports",
                        style: TextStyle(color: Colors.black, fontSize: 14)),



                  ],
                ),
              ),
            ),
            Divider(color: Colors.grey.shade300),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Orders Over Time",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5,),
                  Container(
                    child: Row(
                      children: [
                        Flexible(
                          flex: 8,
                          child: GestureDetector(
                            child: Container(
                                alignment: Alignment.topLeft,

                                child: Container(
                                  alignment: Alignment.center,

                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                    Border.all(color: Colors.grey.shade100),
                                    borderRadius: BorderRadius.circular(0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,

                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Wrap(
                                      children: [
                                        const Icon(Icons.calendar_today, size: 18,),
                                        const SizedBox(width: 5,),
                                        Text(start_date+"-"+end_date,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            )),
                                      ],

                                    ),
                                  ),
                                )),
                            onTap: ()=>{
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                Select_Date_Range(type: "reports", onSaveCallback: onSelectRangeListener,)),)

                          },
                          ),
                        ),
                        const SizedBox(width: 20,),
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
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
                            onTap: ()=>{
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                  Select_Date_Range(type: "reports", onSaveCallback: onSelectRangeListener,)),)

                             // show_DropDown()
                            },
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
                child: Order_Report_dataList!.isEmpty ?
            Container(
              alignment: Alignment.center,
              height: 400,
              width: MediaQuery.of(context).size.height,
              child: const Text("No order found over this time", style: TextStyle(fontSize: 14, color: Colors.black),),
            ):ScrollableWidget(child: buildDataTable())),
          ],
        ),
      ),
    );
  }

  onSelectRangeListener(String start, String end, String sdate1, String sdate2){
    this.start_date = start;
    this.end_date = end;
    this.start_date1 =sdate1;
    this.end_date1 = sdate2;

    if(this.mounted){
      setState(() {
      });
    }

    get_Vendor_Report_Data();
  }

  Widget buildDataTable() {

    final columns = ['Date', 'Orders', 'Avg. Unit Ordered', 'Average Order Value', 'Returned Quantity', 'Fullfilled Order', 'Shipped Order', 'Delivered Order'];

    return DataTable(
      columns: getColumns(columns),
      rows: getRows(orderreports),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
    label: Text(column),

  )).toList();

  List<DataRow> getRows(List<Vendor_Order_Report_Data> orderReportsData) => orderReportsData.map((Vendor_Order_Report_Data orderReportData) {
    final cells = [orderReportData.orderDate, orderReportData.orders, orderReportData.avgUnitOrdered, orderReportData.avgOrderValue, orderReportData.returnedQuantity, orderReportData.fullfilledOrder, orderReportData.shippedOrder, orderReportData.deliveredOrder];

    return DataRow(cells: getCells(cells));
  }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void get_Vendor_Report_Data() async {
    Rest_Apis restApis = Rest_Apis();

    //627a54303361b835a319fca2

    restApis.getVendor_orders_Reports( user_id, admin_auto_id, start_date1, end_date1,baseUrl).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            vendor_order_report_model = value;
          });
        }

        if (vendor_order_report_model != null) {
          if (mounted) {
            setState(() {
              Order_Report_dataList = vendor_order_report_model?.data!;
              order_count = vendor_order_report_model!.orderCount!;
              orderreports = List.of(Order_Report_dataList!);

            });
          }
        } else {}
      } else {}
    });
  }

  void getCurrent_Date() {
    if(mounted)
    {
      setState(() {
        final DateTime today = DateTime.now();

    //    start_date1 = DateFormat('yyyy-MM-dd').format(today).toString();
        if(widget.s_date != "" || widget.e_date != "")
          {
            start_date = widget.s_date;
            end_date = widget.e_date;

            start_date1 = widget.s_date1;
            end_date1 = widget.e_date1;
          }
        else{
          start_date = DateFormat('dd, MMMM yyyy').format(today).toString();
          end_date = DateFormat('dd, MMMM yyyy').format(today.add(const Duration(days: 30))).toString();

          start_date1 = DateFormat('yyyy-MM-dd').format(today).toString();
          end_date1 = DateFormat('yyyy-MM-dd').format(today.add(const Duration(days: 30))).toString();
        }

        get_Vendor_Report_Data();
      });
    }
  }

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
    print('1');

    List<List<String>> dataList=[];

    print('2');

    List<String> data=[];


    data.add('Order Date');
    data.add('Orders');
    data.add('Avg Unit Ordered');
    data.add('Avg Order Value');
    data.add('Received Orders');
    data.add('Returned Quantity');
    data.add('Fulfilled Orders');
    data.add('Shipped Orders');
    data.add('Delivered Orders');

    dataList.add(data);


    for(int index=0; index<Order_Report_dataList!.length ;index++){
      Vendor_Order_Report_Data dataModel=Order_Report_dataList![index];
      List<String> data=[];

      print('3');

      data.add(dataModel.orderDate!);
      data.add(dataModel.orders.toString());
      data.add(dataModel.avgUnitOrdered.toString());
      data.add(dataModel.avgOrderValue.toString());
      data.add(dataModel.receivedOrders.toString());
      data.add(dataModel.returnedQuantity.toString());
      data.add(dataModel.fullfilledOrder.toString());
      data.add(dataModel.shippedOrder.toString());
      data.add(dataModel.deliveredOrder.toString());

      dataList.add(data);

      print(dataList.toString());
    }

    String csvData = ListToCsvConverter().convert(dataList);

    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/order_report${DateTime.now()}.csv').create();
    await file.writeAsString(csvData);

    if(file!=null){
      ShareExtend.share(file.path, "file");

      //shareFile(file);
    }
  }

}


