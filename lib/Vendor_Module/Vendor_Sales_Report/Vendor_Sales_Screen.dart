import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/Vendor_Module/Vendor_Home/Utils/scrollable_widget.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:intl/intl.dart';

import '../Vendor_Home/Utils/constants.dart';
import '../Vendor_Sales_Report/Compnents/Rest_Apis.dart';
import '../Vendor_Orders/Select_Date_Range.dart';
import 'Compnents/Model/Vendor_Sales_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Venders_Sales extends StatefulWidget {
  Venders_Sales({Key? key,
    required this.s_date,
    required this.e_date,
    required this.s_date1,
    required this.e_date1,
    required this.vendor_id})
      : super(key: key);
  String s_date, e_date, s_date1, e_date1,vendor_id;

  @override
  _Venders_SalesState createState() => _Venders_SalesState();
}

class _Venders_SalesState extends State<Venders_Sales> {
  String user_id = "";
  bool isApiCallProcess = false;
  String start_date = "", end_date = "",start_date1 = "", end_date1 = "";
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
  String?  selected_range;
  late List<GetVendorSalesReport> sale_models;
  int order_count = 0;
  Vendor_Sales_Model? vendor_sales_report_model;
  List<GetVendorSalesReport>? VendorSalesList = [];
  String baseUrl="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user_id=widget.vendor_id;
    getBaseUrl();
    getCurrent_Date();
    sale_models = List.of(VendorSalesList!);
  }

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if(baseUrl!=null){
      setState(() {
        this.baseUrl=baseUrl;
      });
    }
    return null;
  }

  void get_Vendor_Sales_Report_Data() async {
    Rest_Apis restApis = Rest_Apis();

    restApis.getVendorSalesReport( user_id, start_date1, end_date1,baseUrl).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            vendor_sales_report_model = value;
          });
        }

        if (vendor_sales_report_model != null) {
          if (mounted) {
            setState(() {
              VendorSalesList = vendor_sales_report_model?.data;
              order_count = vendor_sales_report_model!.totalOrderCount;
              sale_models = List.of(VendorSalesList!);

            });
          }
        } else {}
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Sales",
            style: TextStyle(color: Colors.black, fontSize: 18)),
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(Icons.arrow_back, color: Colors.black),
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
                          child: Text("Sales OVER LAST 30 DAYS",
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
                    const Text("RS 0.00",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),

                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                        "Make business decisions by comparing sales across products, sales across dates, months, week and years.",
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                  ],
                ),
              ),
            ),
            Divider(color: Colors.grey.shade300),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              height: 70,
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
                        const SizedBox(width: 10,),
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
                              show_DropDown()

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
    child: VendorSalesList!.isEmpty ?
    Container(
    alignment: Alignment.center,
    height: 400,
    width: MediaQuery.of(context).size.height,
    child: const Text("No sales report found over this time", style: TextStyle(fontSize: 14, color: Colors.black),),
    ):ScrollableWidget(child: buildDataTable())),
          ],
        ),
      ),
    );
  }
  Widget buildDataTable() {

    final columns = ['Date', 'Orders', 'Gross Sales', 'Discounts', 'Returns', 'Net Sales', 'Shipping', 'Tax', 'Total Sales'];

    return DataTable(
      columns: getColumns(columns),
      rows: getRows(sale_models),
    );
  }
  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
    label: Text(column),

  )).toList();

  List<DataRow> getRows(List<GetVendorSalesReport> saleModel) => saleModel.map((GetVendorSalesReport saleModel) {
    final cells = [saleModel.date, saleModel.ordersCount, saleModel.grossSales, saleModel.discounts, saleModel.returns,saleModel.netSale, saleModel.shipping, saleModel.tax, saleModel.totalSales];

    return DataRow(cells: getCells(cells));
  }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();
  void show_DropDown(){
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Group By", style: TextStyle(fontSize: 15, color: Colors.black),),
        content: SizedBox(
          height: 50,
          width: 200,
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                hint: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'Select Range',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: Range_List.map((item) => DropdownMenuItem<String>(
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
                value: selected_range,
                onChanged: (value) {
                  setState(() {
                    print(selected_range);
                    selected_range = value as String;

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
                dropdownWidth: 200,
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
        ),

        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Ok", style: TextStyle(fontSize: 15, color: Colors.orange),),
          ),
        ],
      );
    });
  }

 void show_PrintMenu() {
   showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           contentPadding: const EdgeInsets.all(6.0),
           title: const Text(
             "Choose Option",
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

        get_Vendor_Sales_Report_Data();
      });
    }
  }

}
