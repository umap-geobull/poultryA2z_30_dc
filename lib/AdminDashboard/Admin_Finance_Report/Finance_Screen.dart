import 'dart:async';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:poultry_a2z/AdminDashboard/Admin_Finance_Report/Compnents/Rest_Apis.dart';
import 'package:poultry_a2z/Vendor_Module/Vendor_Home/Utils/scrollable_widget.dart';
import 'package:poultry_a2z/AdminDashboard/Admin_Orders/Select_Date_Range.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'Compnents/Model/AdminFinanceModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Admin_Finance extends StatefulWidget {
  Admin_Finance({Key? key,
    required this.s_date,
    required this.e_date,
    required this.s_date1,
    required this.e_date1,
    required this.vendor_id})
      : super(key: key);
  String s_date, e_date, s_date1, e_date1,vendor_id;

  @override
  _Admin_FinanceState createState() => _Admin_FinanceState();
}

class _Admin_FinanceState extends State<Admin_Finance> {
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
  late List<FinanceModel> sale_models;
 // int order_count = 0;
  List<FinanceModel> financeList = [];
  String baseUrl="", admin_auto_id='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user_id=widget.vendor_id;
    getBaseUrl();
    sale_models = List.of(financeList);
  }

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? adminId =prefs.getString('admin_auto_id');

    if(baseUrl!=null && adminId!=null){
      setState(() {
        this.baseUrl=baseUrl;
        this.admin_auto_id = adminId;

        getCurrent_Date();
      });
    }
    return null;
  }

  void get_Vendor_Finance_Report_Data() async {
    Rest_Apis restApis = Rest_Apis();

    print(baseUrl);
    print(admin_auto_id);

    print(start_date1);
    print(end_date1);

    restApis.getVendorFinanceReport( user_id, start_date1, end_date1,baseUrl, admin_auto_id).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            financeList =value;
            sale_models = List.of(financeList);
          }
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Finance",
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
                          child: Text("FINANCE OVER LAST 30 DAYS",
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
                  const Text("Finance Over Time",
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
                                  Select_Date_Range(type: "Finance",onSaveCallback: onSelectRangeListener,)),)

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
                child: financeList.isEmpty ?
                Container(
                  alignment: Alignment.center,
                  height: 400,
                  width: MediaQuery.of(context).size.height,
                  child: const Text("No finance report found over this time", style: TextStyle(fontSize: 14, color: Colors.black),),
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

    get_Vendor_Finance_Report_Data();
  }

  Widget buildDataTable() {

    final columns = ['Date', 'Sales Count', 'Sales Amount', 'Delivery Charge', 'Returns','Tax', 'Total Sales'];

    return DataTable(
      columns: getColumns(columns),
      rows: getRows(sale_models),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
    label: Text(column),

  )).toList();

  List<DataRow> getRows(List<FinanceModel> saleModel) => saleModel.map((FinanceModel saleModel) {
    final cells = [saleModel.date, saleModel.salesPerDayCount, saleModel.totalSalesPerDay, saleModel.totalDeliveryCharge,
      saleModel.returnsOrdersPerDay,saleModel.tax, saleModel.totalSales,];

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

        get_Vendor_Finance_Report_Data();
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


    data.add('Date');
    data.add('Sales Count');
    data.add('Sales Amount');
    data.add('Delivery Charges');
    data.add('Returns');
    data.add('Tax');
    data.add('Total Sales');
    dataList.add(data);


    for(int index=0; index<financeList.length ;index++){
      FinanceModel dataModel=financeList[index];
      List<String> data=[];

      print('3');

      data.add(dataModel.date);
      data.add(dataModel.salesPerDayCount.toString());
      data.add(dataModel.totalSalesPerDay.toString());
      data.add(dataModel.totalDeliveryCharge.toString());
      data.add(dataModel.returnsOrdersPerDay.toString());
      data.add(dataModel.tax.toString());
      data.add(dataModel.totalSales.toString());
      dataList.add(data);

      print(dataList.toString());
    }

    String csvData = ListToCsvConverter().convert(dataList);

    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/finance${DateTime.now()}.csv').create();
    await file.writeAsString(csvData);

    if(file!=null){
      ShareExtend.share(file.path, "file");
    }
  }
}
