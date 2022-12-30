import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/AdminDashboard/Admin_Invoice/widget/button_widget.dart';
import 'package:poultry_a2z/AdminDashboard/Admin_Orders/Components/scrollable_widget.dart';
import 'package:poultry_a2z/Utils/AppConfig.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/grobiz_start_pages/profile/admin_profile_model.dart';
import 'package:intl/intl.dart';
import 'api/pdf_api.dart';
import 'api/pdf_invoice_api.dart';
import 'model/customer.dart';
import 'model/invoice.dart';
import 'model/supplier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Vendor_Invoice_Screen extends StatefulWidget {
  const Vendor_Invoice_Screen({Key? key}) : super(key: key);

  @override
  _Vendor_Invoice_ScreenState createState() => _Vendor_Invoice_ScreenState();
}

class _Vendor_Invoice_ScreenState extends State<Vendor_Invoice_Screen> {
  String purchase_date = "",invoice_date = "", due_date = "";
  bool isVisible = false;
  var productNameController = TextEditingController();
  var purchaseDateController = TextEditingController();
  var productQuantityController = TextEditingController();
  var productTaxController = TextEditingController();
  var productPriceController = TextEditingController();

  var customerNameController = TextEditingController();
  var customerEmailAddressController = TextEditingController();
  var customerMobileController = TextEditingController();

  String admin_business_name='', admin_mb='', admin_email='';

  String admin_auto_id='';

  late List<InvoiceItem> inventorymodel = <InvoiceItem>[];

   int? randomNumber ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      Random random = new Random();
       randomNumber = random.nextInt(10000);
    });

    getBaseUrl();
    getCurrent_Date();
  }

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? adminId =prefs.getString('admin_auto_id');

    if(adminId!=null){
      setState(() {
        this.admin_auto_id = adminId;

        getAdminProfile();
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text("Invoice",
            style: TextStyle(color: appBarIconColor, fontSize: 18)),
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      bottomSheet: Checkout_Section(context),
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
                    Text(admin_business_name,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Mobile no.: "+admin_mb,
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                    Text("Email: "+admin_email,
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                  ],
                ),
              ),
            ),
            Divider(color: Colors.grey.shade300),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Tax Invoice",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Bill to",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 20,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: TextFormField(
                          controller: customerNameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: TextStyle(
                              color: Colors.grey, // <-- Change this
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            ),
                            hintText: 'Enter Customer name',
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),

                          // style: AppTheme.form_field_text,
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 20,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: TextFormField(
                          controller: customerEmailAddressController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: TextStyle(
                              color: Colors.grey, // <-- Change this
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            ),
                            hintText: 'Enter Customer Email',
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),

                          // style: AppTheme.form_field_text,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 20,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: TextFormField(
                          controller: customerMobileController,
                          maxLength: 10,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: TextStyle(
                              color: Colors.grey, // <-- Change this
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            ),
                            hintText: 'Enter mobile number',
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            counterText: "",
                          ),
                          // style: AppTheme.form_field_text,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Divider(color: Colors.grey.shade300),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Invoice Details",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline, // <--
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Flexible(
                            flex: 4,
                            child: Container(
                              height: 20,
                              child: Text("Invoice Number:- ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15)),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Container(
                              height: 20,
                              child: Text('${DateTime.now().year}-'+randomNumber.toString(), style:  TextStyle(fontSize: 15, color: Colors.black),),

                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline, // <--
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Flexible(
                            flex: 4,
                            child: Container(
                              height: 20,
                              child: Text("Invoice Date:- ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: GestureDetector(
                              onTap: (){
                                show_DatePicker("invoice_date");
                              },
                              child: Container(
                                height: 20,
                                child: Text(invoice_date, style:  TextStyle(fontSize: 15, color: Colors.black),),

                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline, // <--
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Flexible(
                            flex: 4,
                            child: Container(
                              height: 20,
                              child: Text("Invoice Due Date:- ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: GestureDetector(
                              onTap: (){
                                show_DatePicker("due_date");
                              },
                              child: Container(
                                height: 20,
                                child: Text(due_date, style:  TextStyle(fontSize: 15, color: Colors.black),),

                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(color: Colors.grey.shade300),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 10),
                        child: Text("Add Product",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue))),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.black45, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(Icons.add, size: 20),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Update_Vendor();
                      },
                    ),
                  )
                ],
              ),
            ),

            Visibility(
              visible: isVisible,
                child: ScrollableWidget(child: buildDataTable())),

          ],
        ),
      ),
    );
  }

  Widget buildDataTable() {
    final columns = ['Product Name', 'Date', 'Quantity', 'Tax', 'Unit Price'];

    return DataTable(
      columns: getColumns(columns),
      rows: getRows(inventorymodel),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
          ))
      .toList();

  List<DataRow> getRows(List<InvoiceItem> inventory_model) =>
      inventory_model.map((InvoiceItem inventory_model) {
        final cells = [
          inventory_model.description,
          inventory_model.date,
          inventory_model.quantity,
          inventory_model.vat,
          inventory_model.unitPrice
        ];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  Widget Checkout_Section(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.all(8.0),
     child: Container(
       height: 35,
       child: ButtonWidget(
          text: 'Share Invoice',
          onClicked: () async {
            if (customerNameController.text == "" ||
                customerNameController.text.isEmpty) {
              Fluttertoast.showToast(
                msg: "Enter customer name",
                backgroundColor: Colors.grey,
              );
            } else if (customerMobileController.text == "" ||
                customerMobileController.text.isEmpty) {
              Fluttertoast.showToast(
                msg: "Enter customer mobile number",
                backgroundColor: Colors.grey,
              );
            } else if (customerEmailAddressController.text == "" ||
                customerEmailAddressController.text.isEmpty) {
              Fluttertoast.showToast(
                msg: "Enter customer email address",
                backgroundColor: Colors.grey,
              );
            } else {
              final date = invoice_date;
              final dueDate = due_date;

              final invoice = Invoice(
                supplier: Supplier(
                  name: admin_business_name,
                  phone: admin_mb,
                  email: admin_email,
                ),
                customer: Customer(
                  name: customerNameController.text,
                  phone: customerMobileController.text,
                  email: customerEmailAddressController.text
                ),
                info: InvoiceInfo(
                  date: date,
                  dueDate: dueDate,
                  description: 'My description...',
                  number: '${DateTime.now().year}-'+randomNumber.toString(),
                ),
                items: inventorymodel,
              );

              final pdfFile = await PdfInvoiceApi.generate(invoice);

              PdfApi.shareFile(pdfFile);
            }
          },
        ),
     ),
   );
  }

  Update_Vendor() {
    return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, state) {
            return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text("Product Name",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 45,
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              child: TextFormField(
                                controller: productNameController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 15, 0, 0),
                                    hintText: 'Please enter your product name',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    )),

                                // style: AppTheme.form_field_text,
                                keyboardType: TextInputType.name,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text("Purchase Date",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          SizedBox(
                            height: 5,
                          ),

                          GestureDetector(
                            onTap: () => {
                              showDatePicker_(state)
                              //show_DatePicker(state);
                            },
                            child: Container(

                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              child: Container(

                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black,),
                               borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                height: MediaQuery.of(context).size.height,
                                child:Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                                  child: Text('$purchase_date', style: TextStyle(color: Colors.black),),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text("Product Quantity",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 45,
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              child: TextFormField(
                                controller: productQuantityController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 15, 0, 0),
                                    hintText: 'Please enter product quantity',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    )),

                                // style: AppTheme.form_field_text,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),

                          Text("Product Price",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 45,
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              child: TextFormField(
                                controller: productPriceController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 15, 0, 0),
                                    hintText: 'Please enter your product price',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    )),

                                // style: AppTheme.form_field_text,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text("Product Tax",
                              style:
                              TextStyle(fontSize: 16, color: Colors.black)),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 45,
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              child: TextFormField(
                                controller: productTaxController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding:
                                    EdgeInsets.fromLTRB(10, 15, 0, 0),
                                    hintText: 'Please enter product tax(in %)',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    )),

                                // style: AppTheme.form_field_text,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          GestureDetector(
                            onTap: () {
                              if (productNameController.text == "" ||
                                  productNameController.text.isEmpty) {
                                Fluttertoast.showToast(
                                  msg: "Enter product name",
                                  backgroundColor: Colors.grey,
                                );
                              }

                              else if (productQuantityController.text == "" ||
                                  productQuantityController.text.isEmpty) {
                                Fluttertoast.showToast(
                                  msg: "Enter product quantity",
                                  backgroundColor: Colors.grey,
                                );
                              } else if (productPriceController.text == "" ||
                                  productPriceController.text.isEmpty) {
                                Fluttertoast.showToast(
                                  msg: "Enter product price ",
                                  backgroundColor: Colors.grey,
                                );
                              }
                              else if (productTaxController.text == "" ||
                                  productTaxController.text.isEmpty) {
                                Fluttertoast.showToast(
                                  msg: "Enter product tax ",
                                  backgroundColor: Colors.grey,
                                );
                              }else {
                                Navigator.of(context).pop();
                                setState(() {
                                  int tax = int.parse(productTaxController.text) ;
                                  double tax_final = tax/100;

                                  isVisible = true;
                                  inventorymodel.add(InvoiceItem(
                                    description: productNameController.text,
                                    date:purchase_date,
                                    quantity: int.parse(productQuantityController.text),
                                    vat: tax_final,
                                    unitPrice: double.parse(productPriceController.text),


                                  ));
                                  productNameController.text = "";

                                  productQuantityController.text = "";
                                  productPriceController.text = "";
                                  productTaxController.text = "";

                                });
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              height: 45,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      (new Color(0xffF5591F)),
                                      new Color(0xffF2861E)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[200],
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 10),
                                      blurRadius: 50,
                                      color: Color(0xffEEEEEE)),
                                ],
                              ),
                              child: Text(
                                "Add Product",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ));
          });

        });
  }

  double roundDouble(double value, int places){
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  void getCurrent_Date() {
    if (mounted) {
      setState(() {
        final DateTime today = DateTime.now();
        purchase_date = DateFormat('dd, MMMM yyyy').format(today).toString();
        invoice_date = DateFormat('dd, MMMM yyyy').format(today).toString();
        due_date = DateFormat('dd, MMMM yyyy').format(today.add(Duration(days: 7))).toString();
      });
    }
  }

  Future<void> showDatePicker_(StateSetter updateState) async {
    updateState(() {
      showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2010, 1),
          lastDate: DateTime(2030, 12),
          builder: (context, picker) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Colors.black45,
                  onPrimary: Colors.white,
                  surface: Colors.black45,
                  onSurface: Colors.black,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: picker!,
            );
          }).then((selectedDate) {
        if (mounted) {
          setState(() {
            if (selectedDate != null) {
              print(selectedDate.toString());

              purchase_date =
                  DateFormat('dd, MMMM yyyy').format(selectedDate).toString();
            }
          });
        }
      });

    });
  }

  show_DatePicker(String date) {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2010, 1),
        lastDate: DateTime(2030,12),
        builder: (context,picker){
          return Theme(

            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.black45,
                onPrimary: Colors.white,
                surface: CupertinoColors.systemGrey2,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor:Colors.white,
            ),
            child: picker!,);
        })
        .then((selectedDate) {
      if(mounted)
      {
        setState(() {
          if(selectedDate!=null){
            print(selectedDate.toString());
            if(date== "invoice_date")
            {
              invoice_date = DateFormat('dd, MMMM yyyy').format(selectedDate).toString();
            }
            else if(date== "due_date"){
              due_date = DateFormat('dd, MMMM yyyy').format(selectedDate).toString();
            }
          }
        });
      }

    });
  }

  Future getAdminProfile() async {
    final body = {
      "user_auto_id":admin_auto_id,
    };

    var url=AppConfig.grobizBaseUrl+get_admin_profile;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        AdminProfileModel adminProfileModel=AdminProfileModel.fromJson(json.decode(response.body));

        admin_business_name=adminProfileModel.data[0].name;
        admin_email=adminProfileModel.data[0].email;
        admin_mb=adminProfileModel.data[0].countryCode+ ' '+adminProfileModel.data[0].contact!;
        if(this.mounted){
          setState(() {});
        }
      }
      else {
        String msg=resp['msg'];
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
      }
    }
    else if (response.statusCode == 500) {
      Fluttertoast.showToast(msg: 'Server error', backgroundColor: Colors.grey,);
      setState(() {});
    }
  }

}
