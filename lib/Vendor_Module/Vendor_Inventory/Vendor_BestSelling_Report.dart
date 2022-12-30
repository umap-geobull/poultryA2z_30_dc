import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Admin_add_Product/constants.dart';
import '../Vendor_Orders/Components/scrollable_widget.dart';
import 'Components/Rest_Apis.dart';
import '../Vendor_Home/Components/Model/Get_Vendor_Product_Model.dart';
import 'Components/Model/Vendor_Inventory_Model.dart';

class Venders_BestSelling_ProductList extends StatefulWidget {
  Venders_BestSelling_ProductList(
      {Key? key,
        required this.vendor_id,
      })
      : super(key: key);
  String vendor_id;

  @override
  _Venders_BestSelling_ProductListState createState() =>
      _Venders_BestSelling_ProductListState();
}

class _Venders_BestSelling_ProductListState extends State<Venders_BestSelling_ProductList> {
  String user_id = "", start_date = "", end_date = "",   product_stock_alert_limit = "10";
  Vendor_Invetory_Model? vendor_invetory_model;
  List<Vendor_Inventory_data>? vendor_inventory_DataList = [];
  late List<Vendor_Inventory_data> inventory_models;
  List<GetVendorProductLists>? getProduct_List = [];
  String baseUrl="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
    this.inventory_models = List.of(vendor_inventory_DataList!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text("Best Selling Products List",
            style: TextStyle(color: Colors.white, fontSize: 16)),
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
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
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("See Best Selling Product List",
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
                              child: Icon(Icons.more_horiz,
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
                  child: Text(
                    "No Trending Product found",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                )
                    : ScrollableWidget(child: buildDataTable())),
          ],
        ),
      ),
    );
  }

  Widget buildDataTable() {
    final columns = [
      'Product Name',
      'Stock',
      'Available Stock',
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

  /*List<DataRow> getRows(List<Inventory_Model> inventory_model) =>
      inventory_model.map((Inventory_Model inventory_model) {
        final cells = [
          inventory_model.Product_name,
          inventory_model.Stock,
          inventory_model.Available_Stock,
          inventory_model.Stock_alert_limit,
          inventory_model.out_of_stock
        ];

        return DataRow(cells: getCells(cells));
      }).toList();*/

  List<DataRow> getRows(List<Vendor_Inventory_data> inventory_model) =>
      inventory_model.map((Vendor_Inventory_data inventory_model) {
        final cells = [
          inventory_model.productName,
          inventory_model.totalProductStock,
          inventory_model.availableProductStock,
          inventory_model.productStockAlertLimit,
          inventory_model.status
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
            title: new Text(
              "Set Best Selling Products Limit",
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
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                height: 130,
                width: 200,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 45,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: TextFormField(
                            // controller: _product_name_controller_,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 15, 0, 0),
                                hintText: "Enter product best selling limit",
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            // style: AppTheme.form_field_text,
                            onChanged: (value) => {setState(() {
                              product_stock_alert_limit = value as String;
                            })},
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: ElevatedButton(
                          child: Center(
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                         /* textColor: Colors.white,
                          color: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                     */     onPressed: () {
                            setState(() {
                              Navigator.of(context).pop();
                              get_Vendor_Trending_InventoryList();
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? userId = prefs.getString('user_id');

    String? baseUrl =prefs.getString('base_url');

    if (baseUrl!=null) {
      setState(() {
        this.baseUrl=baseUrl;

        DateTime firstDayCurrentMonth =
        DateTime.utc(DateTime.now().year, DateTime.now().month, 1);
        DateTime lastDayCurrentMonth = DateTime.utc(
          DateTime.now().year,
          DateTime.now().month + 1,
        ).subtract(Duration(days: 1));

        start_date =
            DateFormat('yyyy-MM-dd').format(firstDayCurrentMonth).toString();
        end_date =
            DateFormat('yyyy-MM-dd').format(lastDayCurrentMonth).toString();
        get_Vendor_Trending_InventoryList();

      });
    }
    return null;
  }

  void get_Vendor_Trending_InventoryList() async {
    Rest_Apis restApis = new Rest_Apis();

    restApis.getVendor_Inventory_Trending_List(user_id, start_date, end_date,  product_stock_alert_limit,baseUrl)
        .then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            vendor_invetory_model = value;
          });
        }

        if (vendor_invetory_model != null) {
          if (mounted) {
            setState(() {
              vendor_inventory_DataList = vendor_invetory_model?.data!;
            });
          }
        } else {}
      } else {}
    });
  }
}
