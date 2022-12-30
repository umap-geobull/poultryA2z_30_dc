import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/product_details_model.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class EditInventory extends StatefulWidget {

  EditInventory(this.product_auto_id, this.admin_auto_id, this.app_type_id);

  String product_auto_id;
  String admin_auto_id;
  String app_type_id;


   @override
  _EditInventoryState createState() => _EditInventoryState();
}

class _EditInventoryState extends State<EditInventory> {

  TextEditingController _totalStockController= TextEditingController();
  TextEditingController _availableStockController = TextEditingController();
  TextEditingController _stockAlertLimitController = TextEditingController();

  String baseUrl="";
  bool isApiCallProcessing=false;
  List<GetProductsDetails> productsDetails=[];

  String productName= '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text("Edit Inventory",
              style: TextStyle(color: appBarIconColor, fontSize: 18)),
          leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: const Icon(Icons.arrow_back, color: appBarIconColor),
          ),
        ),
        bottomSheet: Checkout_Section(context),
        body:Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 50),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Product Name: "+ productName,
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(color: Colors.grey.shade300),

                        Text("Total Product Stock",
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 45,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: TextFormField(
                              controller: _totalStockController,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                  hintText: "Enter the total product stock",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.blue, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        Divider(color: Colors.grey.shade300),
                        const Text("Available Product Stock",
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 45,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: TextFormField(
                              controller: _availableStockController,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                  hintText: "Enter the available product stock",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.blue, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        Divider(color: Colors.grey.shade300),
                        const Text("Set Product Stock Alert Limit",
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 45,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: TextFormField(
                              controller: _stockAlertLimitController,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                  hintText: "Enter the product stock alert limit",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.blue, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        Divider(color: Colors.grey.shade300),
                      ],
                    )
                ),
              ),
            ),

            isApiCallProcessing == true ?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.height,
              height: MediaQuery.of(context).size.width,
              child: const GFLoader(type: GFLoaderType.circle),):
            Container()

          ],
        ));
  }

  Widget Checkout_Section(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.grey.shade50,
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () {
                if(_totalStockController.text == "")
                {
                  Fluttertoast.showToast(msg: "Please Enter total stock value", backgroundColor: Colors.grey,);

                }
                else if(_availableStockController.text == "")
                {
                  Fluttertoast.showToast(msg: "Please Enter total available stock value", backgroundColor: Colors.grey,);

                }
                else if(_stockAlertLimitController.text == "")
                {
                  Fluttertoast.showToast(msg: "Please Enter total stock alert limit value", backgroundColor: Colors.grey,);

                }
                else{
                  edit_product();
                }


              },
              child: const Center(
                child: Text(
                  'Save Inventory',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )),
    );
  }

  void getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');

    if (baseUrl != null) {
      this.baseUrl = baseUrl;
      getProductDetails();
    }
  }

  getProductDetails() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "product_auto_id": widget.product_auto_id,
      "customer_auto_id": widget.admin_auto_id,
      "admin_auto_id": widget.admin_auto_id,
      "app_type_id":widget.app_type_id,
    };

    var url = baseUrl+'api/' + get_product_details;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);

      int  status = resp['status'];
      if (status == 1) {
        ProductDetailsModel productDetailsModel=ProductDetailsModel.fromJson(json.decode(response.body));
        productsDetails=productDetailsModel.getProductsDetails;

        if(productsDetails.isNotEmpty){
          productName = productsDetails[0].productName;
          _totalStockController.text = productsDetails[0].stock;
          _availableStockController.text = productsDetails[0].availableStock;
          _stockAlertLimitController.text = productsDetails[0].stockAlertLimit;
        }
       }
      else {
      }

      if(mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }

    }
    else{
      Fluttertoast.showToast(msg: 'Server error: '+response.statusCode.toString());

      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
    }

  }

  void edit_product()async {

    if(this.mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    String selectedSize = "";
    String selectedSizePrice = "";
    for (int index = 0; index < productsDetails[0].size.length; index++) {
      if (index == 0) {
        selectedSize += productsDetails[0].size[index].sizeAutoId;
        // selected_size_price += productsDetails[0].getPriceLists[index].sizePrice.toString();
      }
      else {
        selectedSize += '|' + productsDetails[0].size[index].sizeAutoId;
        //  selected_size_price += '|' + productsDetails[0].getPriceLists[index].sizePrice.toString();
      }
    }

    for (int index = 0; index < productsDetails[0].getPriceLists.length; index++) {
      if (index == 0) {
        selectedSizePrice += productsDetails[0].getPriceLists[index].sizePrice.toString();
      }
      else {
        selectedSizePrice += '|' + productsDetails[0].getPriceLists[index].sizePrice.toString();
      }
    }

    String specification_title = "",specification_value="";
    for (int index = 0; index < productsDetails[0].specificationDetails.length; index++) {
      if(index==0){
        specification_title += productsDetails[0].specificationDetails[index].title;
        specification_value += productsDetails[0].specificationDetails[index].description;
      }
      else {
        specification_title += '|' + productsDetails[0].specificationDetails[index].title;
        specification_value += '|' + productsDetails[0].specificationDetails[index].description;
      }
    }


    var url = baseUrl +'api/'+update_admin_product;

    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);

    request.fields["color_image"] = productsDetails[0].colorImage;
    request.fields["product_auto_id"] = widget.product_auto_id;
    request.fields["user_auto_id"] = widget.admin_auto_id;
    request.fields["main_category_auto_id"] = productsDetails[0].mainCategoryAutoId;
    request.fields["sub_category_auto_id"] = productsDetails[0].subCategoryAutoId;
    request.fields["product_name"] = productsDetails[0].productName;
    request.fields["product_dimensions"] = productsDetails[0].productDimensions;
    request.fields["added_by"]='Admin';
    request.fields["brand_auto_id"] = productsDetails[0].brandAutoId;
    request.fields["color_name"] = productsDetails[0].colorName;
    request.fields["new_arrival"] = productsDetails[0].newArrival;
    request.fields["unit"] = productsDetails[0].unit;
    request.fields["gross_wt"] = productsDetails[0].grossWt;
    request.fields["net_wt"] = productsDetails[0].netWt;
    request.fields["moq"] = productsDetails[0].moq;
    request.fields["quantity"] = productsDetails[0].quantity;
    request.fields["offer_percentage"] = productsDetails[0].offerPercentage;
    request.fields["weight"] = productsDetails[0].weight;
    request.fields["product_price"] = productsDetails[0].productPrice;
    request.fields["description"] = productsDetails[0].description;
    request.fields["size"] = selectedSize;
    request.fields["size_price"] = selectedSizePrice;
    request.fields["including_tax"] = productsDetails[0].includingTax;
    request.fields["tax_percentage"] = productsDetails[0].taxPercentage;
    request.fields["offer_auto_id"] = '';
    request.fields["specification_title"] = specification_title;
    request.fields["specification_description"] = specification_value;
    request.fields["isReturn"] = productsDetails[0].isReturn;
    request.fields["isExchange"] = productsDetails[0].isExchange;
    request.fields["days"] = productsDetails[0].days;
    request.fields["time"] = productsDetails[0].time;
    request.fields["time_unit"] =productsDetails[0].timeUnit;
    request.fields["use_by"] = productsDetails[0].useBy;
    request.fields["closure_type"] = "";
    request.fields["fabric"] = "";
    request.fields["sole"] = "";
    request.fields["admin_auto_id"] = widget.admin_auto_id;
    request.fields["app_type_id"] =widget.app_type_id;
    request.fields["height"]=productsDetails[0].height;
    request.fields["Width"]=productsDetails[0].Width;
    request.fields["depth"]=productsDetails[0].depth;
    request.fields["Manufacturers"]=productsDetails[0].Manufacturers;
    request.fields["Material"]=productsDetails[0].Material;
    request.fields["Firmness"]=productsDetails[0].Firmness;
    request.fields["Thickness"]=productsDetails[0].Thickness;
    request.fields["Trial_Period"]=productsDetails[0].TrialPeriod;
    request.fields["stock"]=_totalStockController.text;
    request.fields["available_stock"]=_availableStockController.text;
    request.fields["Stock_alert_limit"]=_stockAlertLimitController.text;
    request.fields["product_sku"]= productsDetails[0].productSku;

    http.Response response = await http.Response.fromStream(await request.send());

    String status;
    String msg='';

    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      status = resp['status'];
      if(status=="1"){
        Fluttertoast.showToast(msg: "Product inventory updated successfully", backgroundColor: Colors.grey,);
        Navigator.pop(context);
      }
      else{
        Navigator.pop(context);
        msg = resp['msg'];
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
      }

      if(mounted){
        setState(() {
        });
      }
    }
    else{
      Navigator.pop(context);
      isApiCallProcessing=false;
      if(mounted){
        setState(() {
        });
      }

      Fluttertoast.showToast(msg: 'Server Error: '+response.statusCode.toString());
    }
  }

}
