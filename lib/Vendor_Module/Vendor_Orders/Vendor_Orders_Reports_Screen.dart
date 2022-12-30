import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Vendor_Home/Utils/constants.dart';

import 'Components/Model/Vendor_Order_Report_Model.dart';
import 'Components/Rest_Apis.dart';
import 'Components/scrollable_widget.dart';
import 'Select_Date_Range.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Vendor_Orders_Reports extends StatefulWidget {
   Vendor_Orders_Reports({Key? key,
     required this.s_date,
     required this.e_date,
     required this.s_date1,
     required this.e_date1,
     required this.vendor_id,
   })
       : super(key: key);
   String s_date, e_date, s_date1, e_date1,vendor_id;

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
  String user_id="",baseUrl="";

  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
    getCurrent_Date();
    orderreports = List.of(Order_Report_dataList!);
  }

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if(baseUrl!=null){
      setState(() {
        this.baseUrl=baseUrl;
        print(baseUrl);
        this.user_id=widget.vendor_id;
        get_Vendor_Report_Data();
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text("Reports",
            style: TextStyle(color: Colors.white, fontSize: 18)),
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Select_Date_Range(type: "reports",)),)

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
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Select_Date_Range(type: "reports",)),)

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

  void show_PrintMenu() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(6.0),
            title: const Text(
              "Choose Option",
              style: TextStyle(
                  fontSize: 18, color: black, fontWeight: FontWeight.bold),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(50))),
                height: 80,
                width: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: const Text(
                          "Print",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                          ),
                        ), onTap: (){

                      },),
                      Divider(color: Colors.grey.shade300),
                      GestureDetector(
                        child: const Text(
                          "Export",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                          ),
                        ),
                        onTap: (){

                        },
                      ),
                      Divider(color: Colors.grey.shade300),

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
                child: const Text(
                  "Dismiss",
                  style: TextStyle(fontSize: 15, color: Colors.orange),
                ),
              ),
            ],
          );
        });
  }


  void get_Vendor_Report_Data() async {
    Rest_Apis restApis = Rest_Apis();

    restApis.getVendor_orders_Reports( user_id, start_date1, end_date1,baseUrl).then((value) {
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
}


