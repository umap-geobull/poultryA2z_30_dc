import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/Vendor_Module/Vendor_Home/Utils/scrollable_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Admin_add_Product/constants.dart';
import '../Vendor_Home/Components/Model/Get_Vendor_Product_Model.dart';
import 'Add_Market_List.dart';
import 'Add_Product_Inventory.dart';
import 'Components/Model/Vendor_Inventory_Model.dart';
import 'Components/Rest_Apis.dart';
import 'Vendor_BestSelling_Report.dart';
import 'Vendor_Tranding_Report.dart';

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
  String user_id = "", start_date = "", end_date = "",admin_id='';
  Vendor_Invetory_Model? vendor_invetory_model;
  List<Vendor_Inventory_data>? vendor_inventory_DataList = [];
  late List<Vendor_Inventory_data> inventory_models;
  Get_Vendor_Product_Model? _get_vendor_product_model;
  List<GetVendorProductLists>? getProduct_List = [];
  String baseUrl="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.user_id=widget.vendor_id;
    this.admin_id=widget.admin_id;
    getUserId();
    inventory_models = List.of(vendor_inventory_DataList!);
  }

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
                    child: Text("Inventory OVER LAST 30 DAYS",
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

  List<DataRow> getRows(List<Vendor_Inventory_data> inventoryModel) =>
      inventoryModel.map((Vendor_Inventory_data inventoryModel) {
        final cells = [
          inventoryModel.productName,
          inventoryModel.totalProductStock,
          inventoryModel.availableProductStock,
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
                height: 150,
                width: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => Product_Inventory(getProduct_List: getProduct_List, vendor_id: user_id,
                                    admin_id: admin_id,)),
                            );
                          }

                        },
                      ),
                      Divider(color: Colors.grey.shade300),
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
                                    Venders_Tranding_ProductList()),
                          );
                        },
                      ),
                      Divider(color: Colors.grey.shade300),
                      GestureDetector(
                        child: Text(
                          "See BestSelling Products",
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
                                    Venders_BestSelling_ProductList(vendor_id: user_id,)),
                          );
                        },
                      ),
                      Divider(color: Colors.grey.shade300),
                      GestureDetector(
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
                child: Text(
                  "Dismiss",
                  style: TextStyle(fontSize: 15, color: Colors.orange),
                ),
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
            title: new Text(
              "Export to",
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
                height: 105,
                width: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // GestureDetector(
                      //   child: Text(
                      //     "Print",
                      //     style: TextStyle(
                      //       fontSize: 15,
                      //       color: Colors.blue,
                      //     ),
                      //   ),
                      //   onTap: () {},
                      // ),
                      // Divider(color: Colors.grey.shade300),
                      GestureDetector(
                        child: Text(
                          "PDF",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                          ),
                        ),
                        onTap: () {},
                      ),
                      Divider(color: Colors.grey.shade300),
                      GestureDetector(
                        child: Text(
                          "Excel",
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
                child: Text(
                  "Dismiss",
                  style: TextStyle(fontSize: 15, color: Colors.orange),
                ),
              ),
            ],
          );
        });
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if (baseUrl!=null) {
      setState(() {
        this.baseUrl=baseUrl;
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
        getVendor_Product();
      });
    }
    return null;
  }

  void get_Vendor_InventoryList() async {
    Rest_Apis restApis = Rest_Apis();

    restApis
        .getVendor_Inventory_list(user_id, start_date, end_date,baseUrl, admin_id)
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
              print("product=>" + vendor_inventory_DataList![0].productName!);
            });
          }
        } else {}
      } else {}
    });
  }

  void getVendor_Product() async {
    Rest_Apis restApis = Rest_Apis();

    restApis.getVendor_ProductList(user_id,baseUrl,admin_id).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            _get_vendor_product_model = value;
          });
        }


        if (_get_vendor_product_model != null) {
          if (mounted) {
            setState(() =>
            {

              getProduct_List =
                  _get_vendor_product_model?.getVendorProductLists,
            });
          }
        } else {
          Fluttertoast.showToast(
            msg: "No product found",
            backgroundColor: Colors.grey,
          );
        }
      }
    });
  }
}
