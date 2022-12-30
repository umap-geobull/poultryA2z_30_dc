import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'Components/Rest_Apis.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Vendor_Module/Vendor_Home/Utils/constants.dart';
import '../Vendor_Home/Components/Model/Get_Vendor_Product_Model.dart';

import 'Vendor_Inventory_Screen.dart';

class Product_Inventory extends StatefulWidget {
   Product_Inventory({Key? key, required this.getProduct_List,required this.vendor_id,required this.admin_id}) : super(key: key);
   List<GetVendorProductLists>? getProduct_List;
   String vendor_id;
   String admin_id;

   @override
  _Product_InventoryState createState() => _Product_InventoryState();
}

class _Product_InventoryState extends State<Product_Inventory> {

  String product_unit = "", product_auto_id= "",product_name = "",
      Stock = "",
      Available_stock = "",
      stock_alert_limit = "";

  String user_id = "",baseUrl="",admin_id='';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.user_id=widget.vendor_id;
    this.admin_id=widget.admin_id;
    getBaseUrl();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text("Inventory",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        bottomSheet: Checkout_Section(context),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Product Name",
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                const SizedBox(
                  height: 8,
                ),
               /* Center(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'Select Product',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items:
                          Product_List.map((item) => DropdownMenuItem<String>(
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
                      value: selected_product,
                      onChanged: (value) {
                        setState(() {
                          selected_product = value as String;
                        });
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                      ),
                      iconEnabledColor: Colors.black,
                      iconDisabledColor: Colors.grey,
                      buttonHeight: 45,
                      buttonWidth: MediaQuery.of(context).size.width,
                      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                      buttonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                      ),
                      itemHeight: 30,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 150,
                      dropdownWidth: MediaQuery.of(context).size.width,
                      dropdownPadding: EdgeInsets.only(left: 10, right: 10),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      dropdownElevation: 8,
                      scrollbarRadius: const Radius.circular(40),
                      scrollbarThickness: 1,
                      scrollbarAlwaysShow: true,
                    ),
                  ),
                ),*/
                Center(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<GetVendorProductLists>(
                      isExpanded: true,
                      hint: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'Select Brand',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      items: widget.getProduct_List
                          ?.map<DropdownMenuItem<GetVendorProductLists>>(
                              (GetVendorProductLists value) {
                            return DropdownMenuItem<GetVendorProductLists>(
                              value: value,
                              child: Text(
                                value.productName as String,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                      value: widget.getProduct_List![0],
                      /*onChanged: (value) {
                          setState(() {
                            selected_BrandValue = value as String;
                          });
                        },*/

                      onChanged: (GetVendorProductLists? value) {
                        setState(() {
                          product_name = value?.productName as String;
                          product_auto_id = value?.productAutoId as String;
                          product_unit = value?.unit as String;
                          print("id=>"+product_auto_id);
                          /*product_info_model_List[i].get_Brand_List = value;
                          product_info_model_List[i].brandName = product_info_model_List[i].get_Brand_List?.brandName as String;
                          product_info_model_List[i].brandAutoId = product_info_model_List[i].get_Brand_List?.sId
                          as String;*/
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
                      dropdownWidth: MediaQuery.of(context).size.width,
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
                Divider(color: Colors.grey.shade300),

                const Text("Total Product Stock",
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 45,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TextFormField(
                      // controller: _product_name_controller_,
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
                      // style: AppTheme.form_field_text,
                      onChanged: (value) => { setState(() {
                        Stock = value;
                      })},
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
                      // controller: _product_name_controller_,
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
                      // style: AppTheme.form_field_text,
                      onChanged: (value) =>
                          { setState(() {
                            Available_stock = value;
                          })},
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
                      // controller: _product_name_controller_,
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
                      // style: AppTheme.form_field_text,
                      onChanged: (value) => {
                        setState(() {
                          stock_alert_limit = value;
                        })
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                Divider(color: Colors.grey.shade300),
              ],
            ),
          ),
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
                  primary: kPrimaryColor,
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () {
                if(product_name == ""|| product_unit == "" || product_auto_id == "")
                {
                  Fluttertoast.showToast(msg: "Please Select Product", backgroundColor: Colors.grey,);

                }
                else if(Stock == "")
                {
                  Fluttertoast.showToast(msg: "Please Enter total stock value", backgroundColor: Colors.grey,);

                }
                else if(Available_stock == "")
                {
                  Fluttertoast.showToast(msg: "Please Enter total available stock value", backgroundColor: Colors.grey,);

                }
                else if(stock_alert_limit == "")
                {
                  Fluttertoast.showToast(msg: "Please Enter total stock alert limit value", backgroundColor: Colors.grey,);

                }
                else{
                  Add_Vendor_Inventory();
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
    }
  }

  void Add_Vendor_Inventory() {


    Rest_Apis restApis=Rest_Apis();

    restApis.Add_Vendor_Inventory(user_id, admin_id, product_auto_id, product_name,
        product_unit, Stock, Available_stock, stock_alert_limit,baseUrl).then((value){

      if(value!=null){


        int status =value;

        if(status == 1){


          Fluttertoast.showToast(msg: "Inventory added successfully", backgroundColor: Colors.grey,);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Venders_Invetory(vendor_id: user_id,admin_id: admin_id,)));

        }
        else if(status==0){

          Fluttertoast.showToast(msg: "Something went wrong", backgroundColor: Colors.grey,);
        }
        else{
          Fluttertoast.showToast(msg: "Something went wrong", backgroundColor: Colors.grey,);

        }
      }
    });

  }

}
