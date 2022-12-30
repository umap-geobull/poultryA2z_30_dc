
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../Customer_List/Rest_Apis.dart';
import '../Utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Vendor_Module/Vendor_details.dart';
import 'VendorList_Model.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';


class VendorList_screen extends StatefulWidget {
  @override
  _VendorList_screenState createState() => _VendorList_screenState();
}

class _VendorList_screenState extends State<VendorList_screen> {
  String user_id = "";
  bool isApiCallProcess = false;
  String baseUrl='';

  late List<GetVendorLists> vendor_modellist;
  VendorList_Model? vendor_report_model;
  List<GetVendorLists>? VendorList = [];
  late FinanceDataSource _financeDataSource;

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if(baseUrl!=null){
      this.baseUrl=baseUrl;
      print(baseUrl);
      if(this.mounted){
        setState(() {
          get_Vendor_Sales_Report_Data();
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
    vendor_modellist = List.of(VendorList!);
    _financeDataSource = FinanceDataSource(vendor_modellist);
  }

  void get_Vendor_Sales_Report_Data() async {
    if (mounted) {
      setState(() {
        isApiCallProcess = true;
        print('isapicall=' + isApiCallProcess.toString());
      });
    }
    Rest_Apis restApis = Rest_Apis();
    restApis.getVendorsList(baseUrl).then((value) {
      if (value != null) {
        // if (mounted) {
        //   setState(() {
        vendor_report_model = value;
        //     }
        //   );
        // }

        if (vendor_report_model != null) {
          if (mounted) {
            setState(() {
              isApiCallProcess = false;
              VendorList = vendor_report_model?.getVendorLists;
              vendor_modellist = List.of(VendorList!);
              _financeDataSource = FinanceDataSource(vendor_modellist);
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isApiCallProcess = false;
              print('isapicall=' + isApiCallProcess.toString());
              Fluttertoast.showToast(
                msg: "Something went wrong",
                backgroundColor: Colors.grey,
              );
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            isApiCallProcess = false;
            print('isapicall=' + isApiCallProcess.toString());
            Fluttertoast.showToast(
              msg: "Something went wrong",
              backgroundColor: Colors.grey,
            );
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text("All Vendors",
            style: TextStyle(color: Colors.white, fontSize: 18)),
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
           child:
           isApiCallProcess == true
                ? Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.height,
                    height: MediaQuery.of(context).size.width,
                    child: const GFLoader(type: GFLoaderType.circle),)
                : SizedBox(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child: Padding(
    padding: const EdgeInsets.all(5.0),
    child:
    SfDataGrid(source: _financeDataSource,
        columnWidthMode: ColumnWidthMode.auto,
        columns: [
      GridColumn(
        columnName: 'Id',
        visible: false,
        label: Container(
          width: 10,
          alignment: Alignment.center,
          child: const Text('' ),
        ),
      ),
                    GridColumn(
                      columnName: 'Name',
                      label: Container(
                        width: 200,
                        padding: const EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                        child: const Text('Name' ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Email',
                      label: Container(
                        width: 210,
                        alignment: Alignment.center,
                        child: const Text('Email'),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Mobile No.',
                      label: Container(
                        alignment: Alignment.center,
                        child: const Text('Mobile No.'),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Have Retail Shop',
                      width: 100,
                      label: Container(
                        alignment: Alignment.center,
                        child: const Text('Have Retail Shop'),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Update On Whatsapp',
                      label: Container(
                        padding: const EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                        child: const Text('Update On Whatsapp'),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Register Date',
                      label: Container(
                        width: 150,
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('Register Date'),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Status',
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('Status'),
                      ),
                    ),
                    GridColumn(
                      columnName: 'button',
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('View Details'),
                      ),
                    ),
                  ]),),)

      ),
    );
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

class FinanceDataSource extends DataGridSource {

  FinanceDataSource(List<GetVendorLists> vendorData) {
    buildDataGridRow(vendorData);
  }

  void buildDataGridRow(List<GetVendorLists> vendorData) {
    dataGridRow = vendorData.map<DataGridRow>((vendor) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Id', value: vendor.id),
        DataGridCell<String>(columnName: 'Name', value: vendor.name),
        DataGridCell<String>(
            columnName: 'Mobile No.', value: vendor.emailId),
        DataGridCell<String>(columnName: 'Email', value: vendor.mobileNumber),
        DataGridCell<String>(
            columnName: 'Have Retail Shop', value: vendor.haveRetailShop),
        DataGridCell<String>(
            columnName: 'Update On Whatsapp', value: vendor.updateOnWhatsapp),
        DataGridCell<String>(
            columnName: 'Register Date', value: vendor.registerDate),
        DataGridCell<String>(columnName: 'Status', value: vendor.status),
         const DataGridCell<Widget>(columnName: 'button', value: null),
      ]);
    }).toList();
  }

  List<DataGridRow> dataGridRow = <DataGridRow>[];

  @override
  List<DataGridRow> get rows => dataGridRow.isEmpty ? [] : dataGridRow;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          child: dataGridCell.columnName == 'button'
              ? LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                  return
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Vendor_details(row.getCells()[0].value.toString())),);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange, // background
                        // foreground
                      ),
                      child: const Text('View'));
                })
              : Text(dataGridCell.value.toString()));
    }).toList());
  }
}
