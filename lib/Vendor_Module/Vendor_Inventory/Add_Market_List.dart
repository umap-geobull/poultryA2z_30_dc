import 'package:poultry_a2z/Vendor_Module/Vendor_Home/Utils/scrollable_widget.dart';
import 'package:flutter/material.dart';

import '../../Admin_add_Product/constants.dart';
import 'Components/Model/Market_List_Model.dart';

class Venders_MarketList extends StatefulWidget {
  const Venders_MarketList({Key? key}) : super(key: key);

  @override
  _Venders_MarketListState createState() => _Venders_MarketListState();
}

class _Venders_MarketListState extends State<Venders_MarketList> {
  late List<MarketList_Model> marketList_models;

  List<MarketList_Model> marketlistmodel = <MarketList_Model>[
    MarketList_Model(
      Product_name: "Sparx Shoes",
      Available_Stock: "20 Pairs",
      Required_stock: "10 Pairs",
    ),
    MarketList_Model(
      Product_name: "Bata Shoes",
      Available_Stock: "20 Pairs",
      Required_stock: "100 Pairs",
    ),
    MarketList_Model(
      Product_name: "Sparx Lofer",
      Available_Stock: "20 Pairs",
      Required_stock: "10 Pairs",
    ),
    MarketList_Model(
      Product_name: "Nike Shoes",
      Available_Stock: "30 Pairs",
      Required_stock: "100 Pairs",
    ),
    MarketList_Model(
      Product_name: "Paragon Office Shoes",
      Available_Stock: "20 Pairs",
      Required_stock: "10 Pairs",
    ),
    MarketList_Model(
      Product_name: "Laxmi Chappals",
      Available_Stock: "20 Pairs",
      Required_stock: "100 Pairs",
    ),
    MarketList_Model(
      Product_name: "Sparx Party Shoes",
      Available_Stock: "40 Pairs",
      Required_stock: "10 Pairs",
    ),
    MarketList_Model(
      Product_name: "Bata Black Wear",
      Available_Stock: "30 Pairs",
      Required_stock: "100 Pairs",
    ),
    MarketList_Model(
      Product_name: "Sparx Sandals",
      Available_Stock: "20 Pairs",
      Required_stock: "10 Pairs",
    ),
    MarketList_Model(
      Product_name: "Bata Ladies Wear",
      Available_Stock: "60 Pairs",
      Required_stock: "100 Pairs",
    ),
    MarketList_Model(
      Product_name: "Sparx White Shoes",
      Available_Stock: "50 Pairs",
      Required_stock: "10 Pairs",
    ),
    MarketList_Model(
      Product_name: "Laxmi Kids Wear",
      Available_Stock: "50 Pairs",
      Required_stock: "100 Pairs",
    )
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    marketList_models = List.of(marketlistmodel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text("Vendor Market List",
            style: TextStyle(color: Colors.white, fontSize: 16)),
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
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
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
                                  child: Text("See Market List",
                                      style: TextStyle(
                                          fontSize: 18,
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
            ScrollableWidget(child: buildDataTable()),
          ],
        ),
      ),
    );
  }

  Widget buildDataTable() {
    final columns = ['Product Name', 'Available Stock', 'Required Stock'];

    return DataTable(
      columns: getColumns(columns),
      rows: getRows(marketlistmodel),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
          ))
      .toList();

  List<DataRow> getRows(List<MarketList_Model> inventoryModel) =>
      inventoryModel.map((MarketList_Model inventoryModel) {
        final cells = [
          inventoryModel.Product_name,
          inventoryModel.Available_Stock,
          inventoryModel.Required_stock,
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
                height: 100,
                width: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: const Text(
                          "Print",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                          ),
                        ),
                        onTap: () {},
                      ),
                      Divider(color: Colors.grey.shade300),
                      GestureDetector(
                        child: const Text(
                          "Export",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                          ),
                        ),
                        onTap: () {},
                      ),
                      Divider(color: Colors.grey.shade300),
                      GestureDetector(
                        child: const Text(
                          "Import",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                          ),
                        ),
                        onTap: () {},
                      ),
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
