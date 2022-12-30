import 'package:poultry_a2z/Vendor_Module/Vendor_Finanace/Compnents/Model/Sales_Model.dart';
import 'package:poultry_a2z/Vendor_Module/Vendor_Home/Utils/scrollable_widget.dart';
import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

import '../Vendor_Home/Utils/constants.dart';
import '../Vendor_Orders/Select_Date_Range.dart';

class Venders_Finance_screen extends StatefulWidget {
  const Venders_Finance_screen({Key? key}) : super(key: key);

  @override
  _Venders_Finance_screenState createState() => _Venders_Finance_screenState();
}

class _Venders_Finance_screenState extends State<Venders_Finance_screen> {

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
  late List<Finance_Model> sale_models;

  List<Finance_Model> salesModel = <Finance_Model>[
    Finance_Model(date:"23 May 2022", Sells_per_days: '0', Commision: '0', Tax: "0", Amount_on_hold: "0", Amount_to_received: "0",),
    Finance_Model(date:"24 May 2022", Sells_per_days: '0', Commision: '0', Tax: "0", Amount_on_hold: "0", Amount_to_received: "0",),
    Finance_Model(date:"25 May 2022", Sells_per_days: '0', Commision: '0', Tax: "0", Amount_on_hold: "0", Amount_to_received: "0",),
    Finance_Model(date:"26 May 2022", Sells_per_days: '0', Commision: '0', Tax: "0", Amount_on_hold: "0", Amount_to_received: "0", ),
    Finance_Model(date:"27 May 2022", Sells_per_days: '0', Commision: '0', Tax: "0", Amount_on_hold: "0", Amount_to_received: "0", ),
    Finance_Model(date:"28 May 2022", Sells_per_days: '0', Commision: '0', Tax: "0", Amount_on_hold: "0", Amount_to_received: "0",),
    Finance_Model(date:"29 May 2022", Sells_per_days: '0', Commision: '0', Tax: "0", Amount_on_hold: "0", Amount_to_received: "0", ),
    Finance_Model(date:"30 May 2022", Sells_per_days: '0', Commision: '0', Tax: "0", Amount_on_hold: "0", Amount_to_received: "0", ),
    Finance_Model(date:"31 May 2022", Sells_per_days: '0', Commision: '0', Tax: "0", Amount_on_hold: "0", Amount_to_received: "0", ),
    Finance_Model(date:"01 June 2022", Sells_per_days: '0', Commision: '0', Tax: "0", Amount_on_hold: "0", Amount_to_received: "0",),
    Finance_Model(date:"02 June 2022", Sells_per_days: '0', Commision: '0', Tax: "0", Amount_on_hold: "0", Amount_to_received: "0",),
    Finance_Model(date:"03 June 2022", Sells_per_days: '0', Commision: '0', Tax: "0", Amount_on_hold: "0", Amount_to_received: "0",),


  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sale_models = List.of(salesModel);
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
                        "Make business decisions by comparing finance across dates, months, week and years.",
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
                                  width: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                    Border.all(color: Colors.grey.shade100),
                                    borderRadius: BorderRadius.circular(0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,

                                        // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Wrap(
                                      children: const [
                                        Icon(Icons.calendar_today, size: 18,),
                                        SizedBox(width: 5,),
                                        Text("23 May - 04 June 2022",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            )),
                                      ],

                                    ),
                                  ),
                                )),
                            onTap: ()=>{
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Select_Date_Range(type: "finance",)),)

                            },
                          ),
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

            ScrollableWidget(child: buildDataTable()),
          ],
        ),
      ),
    );
  }
  Widget buildDataTable() {

    final columns = ['Date', 'Sells Per days', 'Commission', 'Tax', 'Amount on Hold', 'Amount to Receive'];

    return Row(
     children: [
       DataTable(
         columns: getColumns(columns),
         rows: getRows(sale_models),
       ),
       Container(

         child: ElevatedButton(
           style: ElevatedButton.styleFrom(
               primary: kPrimaryColor,
               textStyle: const TextStyle(fontSize: 20)),
           onPressed: () {

           },
           child: const Center(
             child: Text(
               'Get Paid',
               style: TextStyle(
                 fontSize: 16,
                 color: Colors.white,
               ),
             ),
           ),
         ),
       )
     ],
    );
  }
  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
    label: Text(column),

  )).toList();

  List<DataRow> getRows(List<Finance_Model> saleModel) => saleModel.map((Finance_Model saleModel) {
    final cells = [saleModel.date, saleModel.Sells_per_days, saleModel.Commision, saleModel.Tax, saleModel.Amount_on_hold,saleModel.Amount_to_received, ];

    return DataRow(cells: getCells(cells));
  }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();
  void show_DropDown(){
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Group By", style: TextStyle(fontSize: 15, color: black),),
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
}
