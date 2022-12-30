import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/Product_Info_Model.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/all_offers_model.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/product_price_model.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/size_model.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/add_specification_bottomsheet.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/all_offers.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/edit_price_screen.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/select_size_bottomsheet.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/all_brands_model.dart';
import 'package:poultry_a2z/settings/AddCurrency/Add_Currency.dart';
import 'package:poultry_a2z/settings/AddCurrency/Component/currency_list_model.dart';
import 'package:poultry_a2z/settings/Add_Color/Components/Color_List_Model.dart';
import 'package:poultry_a2z/settings/Add_Units/Components/product_unit_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../Utils/App_Apis.dart';
import '../../Utils/constants.dart';
import '../../settings/Add_Firmness/Components/Firmness_List_Model.dart';
import '../../settings/Add_Manufacturer/Components/Manufacturer_List_Model.dart';
import '../../settings/Add_Material/Components/Material_List_Model.dart';
import '../../settings/Add_Size/Components/Get_SizeList_Model.dart';
import 'Model/Product_FormUiModel.dart';
import 'Model/Rest_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'Model/product_color_model.dart';
import 'Model/product_details_model.dart';
import 'add_color_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'add_price_screen.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


class Update_Product extends StatefulWidget {
  Update_Product({Key? key, required this.product_id}) : super(key: key);
  String product_id;

  @override
  _Update_Product createState() => _Update_Product(product_id);
}

class _Update_Product extends State<Update_Product> {
  String product_id;

  _Update_Product(this.product_id);

  List<GetProductsDetails> productsDetails=[];
  List<GetBrandslist> getBrandslist=[];
  List<String> brand_list = [
    'Select Brand',
  ];

  List<GetCurrencyList> getCurrencyList=[];

  List<String> Arrival_List = [
    'Select New Arrival',
    'Yes',
    'No',
  ];

  List<String> timeUnititems = [
    'Min',
    'Hrs',
    'Days',
    'Week',
    'Month',
  ];

  List<String> includingTaxList = [
    'Yes',
    'No',
  ];

  List<String> Unit_list = [
    'Select Unit',
  ];

  List<String> colorList=[
    'Select Color Name'
  ];

  List<String> Manufacturer_list = [
    'Select Manufacturer',
  ];

  List<String> Firmness_list = [
    'Select Firmness',
  ];

  List<String> Material_list = [
    'Select Material',
  ];

  List<GetSizeList> size_List = [];
  String size_title='';

  List<Offers> selectedOffer=[];
  List<Getdatalist> getFormuilist=[];
  File? product_img;
  final ImagePicker _picker = ImagePicker();
  String user_id = "";
  bool isedit=false;

  var productname_Controller = TextEditingController();
  var Grossweight_controller= TextEditingController() ;
  var NetWeight_controller = TextEditingController();
  var Quantity_Controller = TextEditingController();
  var Weight_Controller = TextEditingController();
  var priceController = TextEditingController();
  var offerController = TextEditingController();
  var finalproceController = TextEditingController();
  var moqController = TextEditingController();
  var heightlightController = TextEditingController();
  var selectedColorController = TextEditingController();
  var taxController = TextEditingController();
  var daysController = TextEditingController();
  var useByController = TextEditingController();
  var deliveryTimeController=TextEditingController();
  var heightController=TextEditingController();
  var widthController=TextEditingController();
  var depthController=TextEditingController();
  var thicknessController=TextEditingController();
  var trial_periodController=TextEditingController();
  var stock_Controller=TextEditingController();
  var available_stock_Controller=TextEditingController();
  var stock_alert_limit_Controller=TextEditingController();

  late File product_image;

  bool isImageSelected=false;

  String product_name = "",brandName='Select Brand';
  String newArrival='Select New Arrival';
  String unit='Select Unit';
  String manufacturer='Select Manufacturer';
  String productSku = '';
  String material='Select Material';
  String firmness='Select Firmness';
  String height='',width='',depth='',thickness='',trial_period='';
  String stock='',available_stock='',alert_limit='';
  String includingTax='Yes';
  String isReturn='No',isExchange='No';
  String deliveryByUnit = "Days";

  String baseUrl='',admin_auto_id='',app_type_id='';

  List<File> colorImage=[];
  String colorName='';

  int selectedSize=-1;

  bool isApiCallProcessing=false;
  List<GetCountryProductPriceList> getCountryProductPriceList=[];

  List<GetProductsLists> productColorList=[];


  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? adminId =prefs.getString('admin_auto_id');
    String? userId = prefs.getString('user_id');
    String? apptypeid= prefs.getString('app_type_id');

    if(baseUrl!=null && adminId!=null && userId!=null && apptypeid!=null){
      this.baseUrl=baseUrl;
      this.admin_auto_id=adminId;
      this.user_id = userId;
      this.app_type_id=apptypeid;
      setState(() {});
      getMainBrand();
      getSizeListApi();
      getColorListApi();
      getUnitListApi();
      getCurrency();
      getManufacturerListApi();
      getFirmnessList();
      getMaterialList();
      getProductDetails();
    }
  }

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
          title: const Text("Edit Product",
              style: TextStyle(
                  color: appBarIconColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed:  Navigator.of(context).pop,
            icon: const Icon(Icons.arrow_back, color: appBarIconColor),
          ),
          actions: [
            isedit==true?
            IconButton(
                onPressed: ()=>{
                  isedit=false ,
                  if(getFormuilist.isEmpty)
                    AddFormUi()
                  else
                    UpdateFormUi(),
                  setState(() {})
                },
                icon: Icon(Icons.save,color: appBarIconColor,)):
            IconButton(
                onPressed: ()=>{
                  if(isedit==true)
                    { isedit=false }
                  else{
                    isedit=true
                  },
                  setState(() {})
                },
                icon: Icon(Icons.settings,color: appBarIconColor,)),],
        ),
        body: Add_Product_Layout(context));
  }

  Widget Add_Product_Layout(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      productImageUi(),
                      Divider(color: Colors.grey.shade300),

                      const Text("Product Name",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 45,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: TextFormField(
                            controller: productname_Controller,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                hintText: "Enter the Product name",
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
                            keyboardType: TextInputType.name,

                          ),
                        ),
                      ),

                      Divider(color: Colors.grey.shade300),

                      addColors(),

                      addSize(),

                      newArrivalStatusUi(),

                      brandNameUi(),

                      // unitUi(),
                      isedit==false && productsDetails.isNotEmpty && productsDetails[0].isgross_wt=='no'?Container():
                  Container(child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [const Text("Product Gross Weight",
                            style: TextStyle(color: Colors.black, fontSize: 16)),

                          isedit==true?Row(children: [
                            productsDetails[0].isgross_wt=='no'?
                            IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: ()=>{
                                productsDetails[0].isgross_wt='yes',
                                setState(() {})
                              },
                              icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                              alignment: Alignment.topRight,
                            ):IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: ()=>{
                                productsDetails[0].isgross_wt='no',
                                setState(() {})
                              },
                              icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                              alignment: Alignment.topRight,
                            )
                            ,],):Container()
                        ],),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 45,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: TextFormField(
                            controller: Grossweight_controller,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                hintText: "Enter the product gross weight",
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
                      Divider(color: Colors.grey.shade300),])),

                  isedit==false && productsDetails.isNotEmpty && productsDetails[0].isnet_wt=='no'?Container():
                  Container(child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [const Text("Product Net Weight",
                            style: TextStyle(color: Colors.black, fontSize: 16)),

                          isedit==true?Row(children: [
                            productsDetails[0].isnet_wt=='no'?
                            IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: ()=>{
                                productsDetails[0].isnet_wt='yes',
                                setState(() {})
                              },
                              icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                              alignment: Alignment.topRight,
                            ):IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: ()=>{
                                productsDetails[0].isnet_wt='no',
                                setState(() {})
                              },
                              icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                              alignment: Alignment.topRight,
                            )
                            ,],):Container()
                        ],),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 45,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: TextFormField(
                            controller: NetWeight_controller,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                hintText: "Enter the product net weight",
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
                      ])),

                      isedit==false && productsDetails.isNotEmpty && productsDetails[0].isquantity=='no'?Container():
                  Container(child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                              "Pack of (Ex. Pack of 2, Pack of 5, etc)",
                              style: TextStyle(color: Colors.black, fontSize: 16)),

                          isedit==true?
                          Row(children: [
                            productsDetails[0].isquantity=='no'?
                            IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: ()=>{
                                productsDetails[0].isquantity='yes',
                                setState(() {})
                              },
                              icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                              alignment: Alignment.topRight,
                            ):IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: ()=>{
                                productsDetails[0].isquantity='no',
                                setState(() {})
                              },
                              icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                              alignment: Alignment.topRight,
                            )
                            ,],):
                          Container()
                        ],),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 45,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: TextFormField(
                            controller: Quantity_Controller,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                hintText: "Enter the Pack of Value",
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
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Divider(color: Colors.grey.shade300),]
                  )),

                     /* const Text("Product Price",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 45,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: TextFormField(
                            controller: priceController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                hintText: "Enter the Product price",
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
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Divider(color: Colors.grey.shade300),
                      includingTaxUi(),
                      taxPerUi(),
                      Text("Product Offer(%)",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 45,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: TextFormField(
                            controller: offerController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                hintText: "Enter the Product offer(%)",
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
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: const Text(' OR '),
                      ),
                      selectedOffer.isNotEmpty?
                      Container(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            child: Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: ()=>{
                                    showSelectOffer()
                                  },
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 100,
                                      child: ClipRRect(
                                        // borderRadius: BorderRadius.circular(5),
                                        child:selectedOffer[0].componentImage!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          height: 100,
                                          width: MediaQuery.of(context).size.width,
                                          imageUrl: baseUrl+offer_image_base_url+selectedOffer[0].componentImage,
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                //borderRadius: BorderRadius.circular(5),
                                                color: Colors.grey[400],
                                              )),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ):
                                        Container(
                                            child:const Icon(Icons.error),
                                            decoration: BoxDecoration(
                                              //   borderRadius: BorderRadius.circular(5),
                                              color: Colors.grey[400],
                                            )),
                                      )

                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                      width: 200,
                                      color: Colors.black38,
                                      padding: const EdgeInsets.all(10),
                                      child: selectedOffer[0].offer.isNotEmpty?
                                      Text('Offer% : '+selectedOffer[0].offer+'%',
                                        style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),):
                                      Text('Offer Off Price : Rs.'+selectedOffer[0].price,
                                        style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)
                                  ),
                                ),

                                Align(
                                  alignment: Alignment.topRight,
                                  child:Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child:IconButton(
                                      onPressed: ()=>{removeOffer()},
                                      icon: const Icon(Icons.clear,color: Colors.orange),),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ):
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                width: 1
                            ),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        alignment: Alignment.center,
                        height: 100,
                        child: TextButton(
                          onPressed: ()=>{showSelectOffer()},
                          child: const Text('Select Offer',style: TextStyle(color: Colors.blue,fontSize: 17,fontWeight: FontWeight.bold),),
                        ),
                      ),
                      Divider(color: Colors.grey.shade300),
*/
                     isedit==false &&  productsDetails.isNotEmpty && productsDetails[0].ismoq=='no'?Container():
                     Container(child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [const Text("Minimun Order Quantity(MOQ)",
                                style: TextStyle(color: Colors.black, fontSize: 16)),

                              isedit==true?Row(children: [
                                productsDetails[0].ismoq=='no'?
                                IconButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: ()=>{
                                    productsDetails[0].ismoq='yes',
                                    setState(() {})
                                  },
                                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                                  alignment: Alignment.topRight,
                                ):IconButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: ()=>{
                                    productsDetails[0].ismoq='no',
                                    setState(() {})
                                  },
                                  icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                                  alignment: Alignment.topRight,
                                )
                                ,],):Container()
                            ],),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 45,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: TextFormField(
                              controller: moqController,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                  hintText: "Enter the MOQ",
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
                              keyboardType: TextInputType.name,
                            ),
                          ),
                        ),
                        Divider(color: Colors.grey.shade300),
                      ],)),
                      isedit==false && productsDetails.isNotEmpty && productsDetails[0].ishighlights=='no'?Container():
                      Container(child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [const Text("Product Highlight",
                            style: TextStyle(color: Colors.black, fontSize: 16)),

                          isedit==true?
                          Row(children: [
                            productsDetails.isNotEmpty && productsDetails[0].ishighlights=='no'?
                            IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: ()=>{
                                productsDetails[0].ishighlights='yes',
                                setState(() {})
                              },
                              icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                              alignment: Alignment.topRight,
                            ):IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: ()=>{
                                productsDetails[0].ishighlights='no',
                                setState(() {})
                              },
                              icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                              alignment: Alignment.topRight,
                            )
                            ,],):Container()
                        ],),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: heightlightController,
                        decoration: InputDecoration(
                            filled: true,
                            hintText: "Enter the highlight",
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
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
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
                      ),
                      Divider(color: Colors.grey.shade300),
                      ])),
                      manufacturerUi(),
                      materialUi(),
                      firmnessUi(),
                      dimensionUi(),
                      ThicknessUi(),
                      TrailPeriodUi(),
                      specificationUi(),
                      expiryUi(),
                      returPolicy(),
                      deliveryByUi(),
                      priceUi(),
                      inventoryUi(),

                      Divider(color: Colors.grey.shade300),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child:
                          isApiCallProcessing==true?
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child: const GFLoader(
                                type:GFLoaderType.circle
                            ),
                          ):
                          SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  textStyle: const TextStyle(fontSize: 20)),
                              onPressed: () {
                                if(validations()==true) {
                                  edit_product();
                                }
                              },
                              child: const Center(
                                child: Text(
                                  'Update Product Info',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),

          isApiCallProcessing==true?
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: const GFLoader(
                type:GFLoaderType.circle
            ),
          ):
          Container()
        ],
      ),
    );
  }

  bool validations(){

     if (getCountryProductPriceList.isEmpty) {
      Fluttertoast.showToast(msg: "Please add product price", backgroundColor: Colors.grey,);
      return false;
    }
    return true;
  }

  specificationUi(){
    return isedit==false && productsDetails.isNotEmpty && productsDetails[0].isspecification=='no'?Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                const Text("Product Specification",
                    style: TextStyle(color: Colors.black, fontSize: 16)),

                Expanded(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.add_circle,color: Colors.blue),
                        onPressed: ()=>{showAddSpecification()},
                      ),
                    )),
                isedit==true?
                Container(
                  width: 50,
                  margin: EdgeInsets.only(left: 80,right: 0),
                  alignment: Alignment.centerRight,
                  child: Row(children: [
                    productsDetails[0].isspecification=='no'?
                    IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: ()=>{
                        productsDetails[0].isspecification='yes',
                        setState(() {})
                      },
                      icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                      alignment: Alignment.topRight,
                    ):IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: ()=>{
                        productsDetails[0].isspecification='no',
                        setState(() {})
                      },
                      icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                      alignment: Alignment.topRight,
                    )
                    ,],),)
                    :Container()
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),

          Container(
            margin: const EdgeInsets.all(10),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(4),
              },
              border: TableBorder.all(
                  color: Colors.grey.shade200,
                  style: BorderStyle.solid,
                  width: 1),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children:showSpecificationData(),
            ),
          ),

          Divider(),
        ],
      ),
    );
  }

  onAddSpecificationListener(String title,String value,int i){
    SpecificationDetails specificationDetails=SpecificationDetails(title: title,description: value);
    productsDetails[0].specificationDetails.add(specificationDetails);

    if(this.mounted){
      setState(() {});
    }
  }

  showAddSpecification() async {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return AddSpecification(onAddSpecificationListener,0);
        });
  }

  showSpecificationData(){
    List<TableRow> specificationList=[];

    if(productsDetails.isNotEmpty && productsDetails[0]!=null){
      for(int index=0;index<productsDetails[0].specificationDetails.length;index++){
        specificationList.add(
          TableRow(children: [
            Column(children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(productsDetails[0].specificationDetails[index].title,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14.0)),
                ),
              )
            ]),
            Column(children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(productsDetails[0].specificationDetails[index].description,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 14.0)),
                ),
              )
            ]),
            Column(children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child:GestureDetector(
                    onTap: ()=>{
                      removeSpecification(index)
                    },
                    child: Icon(Icons.close_rounded,color: Colors.redAccent,),
                  ),
                ),
              )
            ]),
          ]),
        );
      }
    }
    return specificationList;
  }

  removeOffer(){
    selectedOffer.clear();

    if(mounted){
      setState(() {});
    }
  }

  showSelectOffer(){
    Route routes = MaterialPageRoute(builder: (context) => SelectOffers(onSaveOfferCallback,0));
    Navigator.push(context, routes);
  }

  onSaveOfferCallback(int i,Offers selectedOffer){
    Navigator.of(context).pop();

    this.selectedOffer.add(selectedOffer);

    if(mounted){
      setState(() {});
    }
  }

  @override
  void dispose() {

    productname_Controller.dispose();
    super.dispose();
  }

  brandNameUi(){
    return isedit==false && productsDetails.isNotEmpty && productsDetails[0].isbrand=='no'?Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Brand Name",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                productsDetails[0].isbrand=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].isbrand='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].isbrand='no',
                    setState(() {})
                  },
                  icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                  alignment: Alignment.topRight,
                )
                ,],):Container()
            ],),
          const SizedBox(
            height: 8,
          ),
          brand_list.isNotEmpty?
          Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                items: brand_list.map((item) => DropdownMenuItem<String>(
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
                value: brandName,
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
                onChanged: (value) {
                  setState(() {
                    brandName=value as String;
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
          ):
          Container(
            alignment: Alignment.centerLeft,
            child: Text('Select Brand'),
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  productImageUi(){

    if(productsDetails.isNotEmpty && productsDetails[0].productImages.isNotEmpty){
      return Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 400,
              child: Stack(
                children: <Widget>[
                  ImageSlideshow(
                    /// Width of the [ImageSlideshow].
                    width: MediaQuery.of(context).size.width,

                    /// Height of the [ImageSlideshow].
                    height: 400,

                    /// The page to show when first creating the [ImageSlideshow].
                    initialPage: 0,

                    /// The color to paint the indicator.
                    indicatorColor: Colors.blue,

                    /// The color to paint behind th indicator.
                    indicatorBackgroundColor: Colors.grey,

                    /// The widgets to display in the [ImageSlideshow].
                    /// Add the sample image file into the images folder
                    children: imagesliderItems(),

                    /// Called whenever the page in the center of the viewport changes.
                    onPageChanged: (value) {
                    },

                    /// Auto scroll interval.
                    /// Do not auto scroll with null or 0.
                    autoPlayInterval: null,

                    /// Loops back to first slide.
                    isLoop: true,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomRight,
                    child:Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54
                      ),
                      child: IconButton(
                        onPressed: ()=>{
                          addImagesProduct()
                        },
                        icon: const Icon(Icons.library_add_rounded,color: Colors.white,),
                      ),
                    ),
                  )
                ],
              ),
            ),

            Divider(color: Colors.grey.shade300),

          ],
        ),
      );
    }
    else{
      return  Container(
        height: 500,
        color: Colors.grey[300],
      );
    }
  }

  newArrivalStatusUi(){
    return isedit==false && productsDetails.isNotEmpty && productsDetails[0].isnew_arrival=='no'?
    Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("New Arrival",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                productsDetails[0].isnew_arrival=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].isnew_arrival='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].isnew_arrival='no',
                    setState(() {})
                  },
                  icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                  alignment: Alignment.topRight,
                )
                ,],):Container()
            ],),
          const SizedBox(
            height: 8,
          ),
          Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                items: Arrival_List.map((item) => DropdownMenuItem<String>(
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
                value: newArrival,
                onChanged: (value) {
                  setState(() {
                    newArrival = value as String;
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

        ],
      ),
    );
  }

  unitUi(){
    if(Unit_list.isNotEmpty && Unit_list.length!=1){
       return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text("Product Unit",
                  style: TextStyle(color: Colors.black, fontSize: 16)),
              ],),
            const SizedBox(
              height: 8,
            ),

            Unit_list.isNotEmpty && Unit_list.length!=1?
            Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  items: Unit_list.map((item) => DropdownMenuItem<String>(
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
                  value: unit,
                  hint: Text('Select Unit'),
                  onChanged: (value) {
                    setState(() {
                      unit = value as String;
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
            ):
            Container(
              alignment: Alignment.centerLeft,
              child: Text('Select Unit'),
            ),
            Divider(color: Colors.grey.shade300),
          ],
        ),
      );
    }
    else{
      return Container();
    }
  }

  manufacturerUi(){
    return isedit==false && productsDetails.isNotEmpty && productsDetails[0].ismanufacturers=='no'?Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Product Manufacturer",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                productsDetails[0].ismanufacturers=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].ismanufacturers='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].ismanufacturers='no',
                    setState(() {})
                  },
                  icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                  alignment: Alignment.topRight,
                )
                ,],):Container()
            ],),
          const SizedBox(
            height: 8,
          ),
          Manufacturer_list.isNotEmpty?
          Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                items: Manufacturer_list.map((item) => DropdownMenuItem<String>(
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
                value: manufacturer,
                onChanged: (value) {
                  setState(() {
                  manufacturer = value as String;
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
          ):
          Container(
            alignment: Alignment.centerLeft,
            child: Text('Select Manufacturer'),
          ),
          Divider(color: Colors.grey.shade300),

        ],
      ),
    );
  }

  firmnessUi(){
    return isedit==false && productsDetails.isNotEmpty && productsDetails[0].isfirmness=='no'?Container():
     Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Product Firmness",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                productsDetails[0].isfirmness=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].isfirmness='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].isfirmness='no',
                    setState(() {})
                  },
                  icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                  alignment: Alignment.topRight,
                )
                ,],):Container()
            ],),
          const SizedBox(
            height: 8,
          ),
          Firmness_list.isNotEmpty?
          Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                items: Firmness_list.map((item) => DropdownMenuItem<String>(
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
                value: firmness,
                onChanged: (value) {
                  setState(() {
                    firmness = value as String;

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
          ):
          Container(
            alignment: Alignment.centerLeft,
            child: Text('Select Firmness'),
          ),

          Divider(color: Colors.grey.shade300),

        ],
      ),
    );
  }

  materialUi(){
    return isedit==false && productsDetails.isNotEmpty && productsDetails[0].ismaterial=='no'?Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Product Material",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                productsDetails[0].ismaterial=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].ismaterial='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].ismaterial='no',
                    setState(() {})
                  },
                  icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                  alignment: Alignment.topRight,
                )
                ,],):Container()
            ],),
          const SizedBox(
            height: 8,
          ),
          Material_list.isNotEmpty?
          Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                items: Material_list.map((item) => DropdownMenuItem<String>(
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
                value: material,
                onChanged: (value) {
                  setState(() {
                    material = value as String;
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
          ):
          Container(
            alignment: Alignment.centerLeft,
            child: Text('Select Material'),
          ),
          Divider(color: Colors.grey.shade300),

        ],
      ),
    );
  }

  dimensionUi(){
    return isedit==false && productsDetails.isNotEmpty && productsDetails[0].isdimension=='no'?Container():Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Dimension",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                productsDetails[0].isdimension=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].isdimension='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].isdimension='no',
                    setState(() {})
                  },
                  icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                  alignment: Alignment.topRight,
                )
                ,],):Container()
            ],),
          const SizedBox(
            height: 8,
          ),
          Row(children: [
            Expanded(
                child: TextFormField(
              controller: heightController,
              decoration: InputDecoration(
                  filled: true,
                  hintText: "Enter height",
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
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
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.number,
              maxLines: null,
              onChanged: (value)=>{
                height=value,

                setState(() {})
              },
            )),
            const SizedBox(
              width: 5,
            ),
            Expanded(child:TextFormField(
              controller: widthController,
              decoration: InputDecoration(
                  filled: true,
                  hintText: "Enter width",
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
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
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.number,
              maxLines: null,
              onChanged: (value)=>{
                width=value,
                setState(() {})
              },
            )),
            const SizedBox(
              width: 5,
            ),
            Expanded(child:TextFormField(
              controller: depthController,
              decoration: InputDecoration(
                  filled: true,
                  hintText: "Enter depth",
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
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
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.number,
              maxLines: null,
              onChanged: (value)=>{
                depth=value,
                setState(() {})
              },
            )),],),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  ThicknessUi(){
    return isedit==false && productsDetails.isNotEmpty && productsDetails[0].isthickness=='no'?Container():Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Product Thickness",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                productsDetails[0].isthickness=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].isthickness='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].isthickness='no',
                    setState(() {})
                  },
                  icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                  alignment: Alignment.topRight,
                )
                ,],):Container()
            ],),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: thicknessController,
            decoration: InputDecoration(
                filled: true,
                hintText: "Enter product thickness",
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
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
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.number,
            maxLines: null,
            onChanged: (value)=>{
              thickness=value,
              setState(() {})
            },
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  inventoryUi() {
    return
      // isedit==false && productsDetails.isNotEmpty && productsDetails[0].isinventory=='no'?Container():
    Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text("Inventory",
                    style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold)),

                  // isedit==true?Row(children: [
                  //   productsDetails[0].isinventory=='no'?
                  //   IconButton(
                  //     padding: EdgeInsets.all(0),
                  //     onPressed: ()=>{
                  //       productsDetails[0].isinventory='yes',
                  //       setState(() {})
                  //     },
                  //     icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  //     alignment: Alignment.topRight,
                  //   ):IconButton(
                  //     padding: EdgeInsets.all(0),
                  //     onPressed: ()=>{
                  //       productsDetails[0].isinventory='no',
                  //       setState(() {})
                  //     },
                  //     icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                  //     alignment: Alignment.topRight,
                  //   )
                  //   ,],):Container()
                ],),
              const SizedBox(
                height: 5,
              ),
              unitUi(),
              StockUi(),
              //AvailableStockUi(),
              StockAlertLimitUi(),
              productBarcodeUi()
            ]
        )
    );
  }

  productBarcodeUi(){
    return
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Product Barcode",
                style: TextStyle(color: Colors.black, fontSize: 16)),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 45,
              child: Container(
                  padding: EdgeInsets.only(left: 10),
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color:Colors.grey,
                        width: 1
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:Row(
                    children: <Widget>[
                      Expanded(
                          flex:7,
                          child: Text(
                            productSku,
                          )
                      ),
                      Expanded(
                        flex:1,
                        child: IconButton(
                          icon: Icon(Icons.document_scanner),
                          onPressed: ()=>{
                            openScanner()
                          },
                        ),
                      )
                    ],
                  )),
            ),
            Divider(color: Colors.grey.shade300),

          ],
        )
      );
  }

  openScanner() async{
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE);

    if(barcodeScanRes!=null){
      if(this.mounted){
        setState(() {
          productSku = barcodeScanRes;
        });
      }
    }
  }

  StockUi(){
    return
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Add Product Stock",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: stock_Controller,
            decoration: InputDecoration(
                filled: true,
                hintText: "Enter product Stock",
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
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
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.number,
            maxLines: null,
            onChanged: (value)=>{
              stock=value,
              setState(() {})
            },
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  AvailableStockUi(){
    return
      // isedit==false && productsDetails.isNotEmpty &&  productsDetails[0].isinventory=='no'?Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Product Available Stock",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: available_stock_Controller,
            decoration: InputDecoration(
                filled: true,
                hintText: "Enter available stock",
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
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
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.number,
            maxLines: null,
            enabled: false,
            onChanged: (value)=>{
              // available_stock=value,
              // setState(() {})
            },
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  StockAlertLimitUi(){
    return
      // isedit==false && productsDetails.isNotEmpty &&  productsDetails[0].isinventory=='no'?Container():
      Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Product Stock Alert Limit",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: stock_alert_limit_Controller,
            decoration: InputDecoration(
                filled: true,
                hintText: "Enter stock alert limit",
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
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
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.number,
            maxLines: null,
            onChanged: (value)=>{
             alert_limit=value,

              setState(() {})
            },
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  TrailPeriodUi(){
    return isedit==false && productsDetails.isNotEmpty && productsDetails[0].istrial_period=='no'?Container():Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Product Trial Period",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                productsDetails[0].istrial_period=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].istrial_period='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].istrial_period='no',
                    setState(() {})
                  },
                  icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                  alignment: Alignment.topRight,
                )
                ,],):Container()
            ],),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: trial_periodController,
            decoration: InputDecoration(
                filled: true,
                hintText: "Enter trial period in days",
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
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
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChanged: (value)=>{
              trial_period=value,
              setState(() {})
            },
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  List<Widget> imagesliderItems(){
    List<Widget> items=[];

    if(productsDetails.isNotEmpty && productsDetails[0].productImages.isNotEmpty){
      for(int index=0;index<productsDetails[0].productImages.length;index++){
        items.add(
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 400,
                child: ClipRRect(
                  child:
                  productsDetails[0].productImages[index].productImage!=''?
                  CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: baseUrl+product_base_url+productsDetails[0].productImages[index].productImage,

                    placeholder: (context, url) =>
                        Container(decoration: BoxDecoration(
                          color: Colors.grey[400],
                        )),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ):
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[200],
                      )),
                )

            )
        );
      }
    }

    return items;
  }

  showImageDialog() {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Upload image from'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              getCameraImage();
            },
            child: const Text('Camera'),
          ),
          SimpleDialogOption(
            onPressed: () {
              getGalleryImage();
            },
            child: const Text('Gallery'),
          ),
        ],
      ),
    );
  }

  Future getCameraImage() async {
    Navigator.of(context).pop(false);

    var image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      product_image = (File(image!.path));
    });
  }

  Future getGalleryImage() async {
    Navigator.of(context).pop(false);
    var image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      // _brand_img = image as File;
      product_image = File(image!.path);
    });
  }

  addSize(){
    return isedit==false && productsDetails.isNotEmpty && productsDetails[0].issize=='no'?Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(size_title,
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                productsDetails[0].issize=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].issize='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].issize='no',
                    setState(() {})
                  },
                  icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                  alignment: Alignment.topRight,
                )
                ,],):Container()
            ],),
          SizedBox(
            height: 8,
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: getSizeList(),
              )
          ) ,
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  deliveryByUi(){
    return isedit==false && productsDetails.isNotEmpty && productsDetails[0].isexpected_delivery=='no'?Container():
     Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Expected Delivery",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                productsDetails[0].isexpected_delivery=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].isexpected_delivery='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].isexpected_delivery='no',
                    setState(() {})
                  },
                  icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                  alignment: Alignment.topRight,
                )
                ,],):Container()
            ],),
          SizedBox(
            height: 8,
          ),
          Container(
              child:Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Time",
                              style: TextStyle(color: Colors.black, fontSize: 16)),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: deliveryTimeController,
                            decoration: InputDecoration(
                                filled: true,
                                hintText: "Enter delivery time",
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
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
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Time Unit",
                              style: TextStyle(color: Colors.black, fontSize: 16)),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 49,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                hint: Row(
                                  children: const [
                                    Expanded(
                                      child: Text(
                                        'Select Unit',
                                        style: TextStyle(
                                          fontSize: 14,

                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                items: timeUnititems
                                    .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,

                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                                    .toList(),
                                value: deliveryByUnit,
                                onChanged: (value) {
                                  setState(() {
                                    deliveryByUnit = value as String;
                                  });
                                },
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                ),

                                iconEnabledColor: Colors.black,
                                iconDisabledColor: Colors.grey,
                                buttonHeight: 50,
                                buttonWidth: MediaQuery.of(context).size.width,
                                buttonPadding:
                                EdgeInsets.only(left: 14, right: 14,top: 10,bottom: 10),
                                buttonDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),

                                ),
                                itemHeight: 30,
                                itemPadding:
                                const EdgeInsets.only(left: 10, right: 10),
                                dropdownMaxHeight: 150,
                                dropdownWidth: 170,
                                dropdownPadding: null,

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
                        ],
                      ),
                    ),
                  )
                ],
              )
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  expiryUi(){
    return isedit==false && productsDetails.isNotEmpty && productsDetails[0].isuse_by=='no'?Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          const Text("Expiry By",
            style: TextStyle(color: Colors.black, fontSize: 16)),

          isedit==true?Row(children: [

            productsDetails[0].isuse_by=='no'?
            IconButton(
              padding: EdgeInsets.all(0),
              onPressed: ()=>{
                productsDetails[0].isuse_by='yes',
                setState(() {})
              },
              icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
              alignment: Alignment.topRight,
            ):IconButton(
              padding: EdgeInsets.all(0),
              onPressed: ()=>{
                productsDetails[0].isuse_by='no',
                setState(() {})
              },
              icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
              alignment: Alignment.topRight,
            )
            ,],):Container()
        ],),
          SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: useByController,
            decoration: InputDecoration(
                filled: true,
                hintText: "Enter use by",
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
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
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  returPolicy(){
    return isedit==false && productsDetails.isNotEmpty && productsDetails[0].isreturn_exchange=='no'?Container():
        Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Return/Exchange",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                productsDetails[0].isreturn_exchange=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].isreturn_exchange='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].isreturn_exchange='no',
                    setState(() {})
                  },
                  icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                  alignment: Alignment.topRight,
                )
                ,],):Container()
            ],),
          SizedBox(
            height: 8,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child:Row(
              children: <Widget>[
                Expanded(
                  flex:1,
                  child: Container(
                    child: Row(
                        mainAxisAlignment:  MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            child: Checkbox(
                              onChanged: (value) {
                                if(mounted){
                                  setState(() {
                                    if(value==true){
                                      isReturn='Yes';
                                    }
                                    else{
                                      isReturn='No';
                                    }
                                  });
                                }
                              },
                              value: isReturn=='Yes'?true:false,
                            ),
                            margin: const EdgeInsets.all(5),
                          ),
                          Flexible(
                            child: Text('Return',
                              style: const TextStyle(fontSize: 16, color: Colors.black, ),
                            ),
                          )
                        ]
                    ),
                  ),
                ),
                Expanded(
                  flex:1,
                  child: Container(
                    child: Row(
                        mainAxisAlignment:  MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            child: Checkbox(
                              
                              onChanged: (value) {
                                if(mounted){
                                  setState(() {
                                    if(value==true){
                                      isExchange='Yes';
                                    }
                                    else{
                                      isExchange='No';
                                    }
                                  });
                                }
                              },
                              value: isExchange=='Yes'?true:false,
                            ),
                            margin: const EdgeInsets.all(5),
                          ),
                          Flexible(
                            child: Text('Exchange',
                              style: const TextStyle(fontSize: 16, color: Colors.black, ),
                            ),
                          )
                        ]
                    ),
                  ),
                )

              ],
            ) ,
          ),
          SizedBox(
            height: 45,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: TextFormField(
                controller: daysController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                      hintText: "Enter return/exchange days",
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
                  keyboardType: TextInputType.number,
              ),
            ),
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  addColors(){
    return isedit==false && productsDetails.isNotEmpty && productsDetails[0].iscolor=='no'?Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Color",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                productsDetails[0].iscolor=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].iscolor='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    productsDetails[0].iscolor='no',
                    setState(() {})
                  },
                  icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                  alignment: Alignment.topRight,
                )
                ,],):Container()
            ],),
          const SizedBox(
            height: 8,
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              height: 130,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: getColorList(),
              )
          ) ,
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  AddFormUi() async {
    var url=baseUrl+'api/'+add_product_formui;

    var uri = Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
      "size":productsDetails[0].issize,
      "color":productsDetails[0].iscolor,
      "highlights":productsDetails[0].ishighlights,
      "specification":productsDetails[0].isspecification,
      "brand":productsDetails[0].isbrand,
      "new_arrival":productsDetails[0].isnew_arrival,
      "moq":productsDetails[0].ismoq,
      "gross_wt":productsDetails[0].isgross_wt,
      "net_wt":productsDetails[0].isnet_wt,
      "unit":productsDetails[0].isunit,
      "quantity":productsDetails[0].isquantity,
      "use_by":productsDetails[0].isuse_by,
      "expected_delivery":productsDetails[0].isexpected_delivery,
      "return_exchange":productsDetails[0].isreturn_exchange,
      "dimension":productsDetails[0].isdimension,
      "manufacturers":productsDetails[0].ismanufacturers,
      "material":productsDetails[0].ismaterial,
      "firmness":productsDetails[0].isfirmness,
      "thickness":productsDetails[0].isthickness,
      "trial_period":productsDetails[0].istrial_period,
      "inventory":productsDetails[0].isinventory
    };
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      String status=resp['status'];
      if(status=='1'){
        getFormUi();
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  UpdateFormUi() async {
    var url=baseUrl+'api/'+update_product_formui;

    var uri = Uri.parse(url);

    final body={
      "form_auto_id":getFormuilist[0].id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
      "size":productsDetails[0].issize,
      "color":productsDetails[0].iscolor,
      "highlights":productsDetails[0].ishighlights,
      "specification":productsDetails[0].isspecification,
      "brand":productsDetails[0].isbrand,
      "new_arrival":productsDetails[0].isnew_arrival,
      "moq":productsDetails[0].ismoq,
      "gross_wt":productsDetails[0].isgross_wt,
      "net_wt":productsDetails[0].isnet_wt,
      "unit":productsDetails[0].isunit,
      "quantity":productsDetails[0].isquantity,
      "use_by":productsDetails[0].isuse_by,
      "expected_delivery":productsDetails[0].isexpected_delivery,
      "return_exchange":productsDetails[0].isreturn_exchange,
      "dimension":productsDetails[0].isdimension,
      "manufacturers":productsDetails[0].ismanufacturers,
      "material":productsDetails[0].ismaterial,
      "firmness":productsDetails[0].isfirmness,
      "thickness":productsDetails[0].isthickness,
      "trial_period":productsDetails[0].istrial_period,
      "inventory":productsDetails[0].isinventory
    };

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      String status=resp['status'];
      if(status=='1'){

        getFormUi();
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  List<Widget> getColorList(){
    List<Widget> colorList=[];

    colorList.add(
        GestureDetector(
          onTap: ()=>{
            fetch_imagesColor()
          },
          child:
          Container(
            width: 80,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 30,left: 10,right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                  color: Colors.grey.shade300, width: 1.5),
            ),
            child: const Text('+',style: TextStyle(color: Colors.black87,fontSize: 20),),
          ),
        )
    );

    if(productColorList.isNotEmpty){
      for(int index=0;index<productColorList.length;index++){
        colorList.add(
            GestureDetector(
              onTap: ()=>{
                selectColor(index,)
              },
              child:
              Container(
                alignment: Alignment.center,
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        height: 80,
                        width: 80,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(
                              color: product_id==productColorList[index].productAutoId?
                              Colors.blue:
                              Colors.grey.shade300,
                              width: 1.5
                          ),
                        ),
                        child: Container(
                          color: Colors.transparent,
                          child:
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child:
                            productColorList[index].productImageLists.isNotEmpty?
                            CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: baseUrl+product_base_url+productColorList[index].productImageLists[0].productImage,
                              placeholder: (context, url) =>
                                  Container(decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                  )),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ):
                            Container(
                                child:const Icon(Icons.error),
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                )),
                          ),
                        )
                    ),
                    productColorList[index].colorName == 'Select Color Name'?
                    Text(''):
                    Text(productColorList[index].colorName)
                  ],
                ),
              ),
            )
        );
      }
    }
    return colorList;
  }

  void selectSize(int sizeIndex, ) {
    selectedSize=sizeIndex;

    if(productsDetails[0].getPriceLists.isNotEmpty &&
        !(productsDetails[0].getPriceLists.length<productsDetails[0].size.length)){

      priceController.text=productsDetails[0].getPriceLists[sizeIndex].sizePrice;
      offerController.text=productsDetails[0].getPriceLists[sizeIndex].offerPercentage;
      finalproceController.text=productsDetails[0].getPriceLists[sizeIndex].finalSizePrice;
    }

    else{
      priceController.text=productsDetails[0].productPrice;
      offerController.text=productsDetails[0].offerPercentage;
      finalproceController.text=productsDetails[0].finalProductPrice;
    }

    if(mounted){
      setState(() {

      });
    }
  }

  void selectColor(int colorIndex, ) {
    product_id=productColorList[colorIndex].productAutoId;
    getProductDetails();
    if(mounted){
      setState(() {

      });
    }
  }

  showSelectSize() async {
    List<GetSizeList> sizeList=[];

    productsDetails[0].size.forEach((element) {
      sizeList.add(GetSizeList(id: element.sizeAutoId, size: element.sizeName));
    });

    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SelectSize(onSelectSizelistener,0,size_List,sizeList);
        });
  }

  void onSelectSizelistener(List<GetSizeList> size, int i){
    Navigator.pop(context);

    productsDetails[0].size.clear();

    size.forEach((element) {
      productsDetails[0].size.add(ProdSize(sizeAutoId: element.id, sizeName: element.size));
    });

   // productsDetails[0].size.add(ProdSize(sizeAutoId: size.id,sizeName: size.size));

   // productsDetails[0].getPriceLists.add(GetSizePriceLists(sizePrice:price,offerPercentage: '',finalSizePrice: ''));

    if(this.mounted){
      setState(() {});
    }
  }

  List<Widget> getSizeList(){
    List<Widget> sizeList=[];

      sizeList.add(
        GestureDetector(
          onTap: ()=>{
            showSelectSize()
          },
          child:
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 27,left: 2,right: 2,top: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: Colors.grey.shade300, width: 1.5),
            ),
            child: const Text('+',
              textAlign:TextAlign.center,style: TextStyle(color: Colors.black87,fontSize: 20),),
          ),
        )
    );

    if(productColorList.isNotEmpty){
       List<ProdSize> sizelist=productsDetails[0].size;
       List<GetSizePriceLists> pricelist=productsDetails[0].getPriceLists;

      if(sizelist.isNotEmpty){
        for(int index=0;index<sizelist.length;index++){
          sizeList.add(
             SizedBox(
               width: 80,
               height: 80,
               child: Stack(
                 children: <Widget>[
                   GestureDetector(
                     onTap: ()=>{
                       selectSize(index)
                     },
                     child: Container(
                       alignment: Alignment.center,
                       margin: const EdgeInsets.all(2),
                       child:  Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: <Widget>[
                           Container(
                             height: 50,
                             width: 50,
                             alignment: Alignment.center,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(10),
                               border: Border.all(
                                   color:
                                   selectedSize==index? Colors.blue: Colors.grey.shade300,
                                   width: 1.5),
                             ),
                             child: Text(sizelist[index].sizeName,
                               textAlign:TextAlign.center,style: const TextStyle(color:Colors.black87,fontSize: 17),),

                           ),
                         ],
                       ),
                     ),
                   ),
                   Container(
                     alignment: Alignment.topRight,
                     width: MediaQuery.of(context).size.width,
                     child: GestureDetector(
                         onTap: ()=>{
                           removeSize(index)
                         },
                         child: const Icon(Icons.close)),
                   )
                 ],
               ),
             )
          );
        }
      }
    }

    return sizeList;
  }

  removeSize(int index) {
    if(mounted){
      setState(() {
        productsDetails[0].size.removeAt(index);
        productsDetails[0].getPriceLists.removeAt(index);
      });
    }

  }

  Future<void> fetch_imagesColor() async {
    ImagePicker imagePicker = ImagePicker();
    List<File>? imageFileList = [];
    var selectedImages = await imagePicker.pickMultiImage();

    if(selectedImages!=null){
      for (var file in selectedImages) {
        File selectedImg = File(file.path);
        imageFileList.add(selectedImg);
      }

      Route routes = MaterialPageRoute(builder: (context) => AddColors(
        imageFileList: imageFileList,
        product_model_auto_id: productsDetails[0].productModelAutoId,
        product_price: productsDetails[0].productPrice,
        offer_price: productsDetails[0].offerPercentage,
      includingTax: productsDetails[0].includingTax,
      taxPercentage: productsDetails[0].taxPercentage,)
      );

      Navigator.push(context, routes).then(onGoBack);
    }

    setState(() {});
  }

  FutureOr onGoBack(dynamic value) {
    getProductColorList();
  }

  Future<void> addImagesProduct() async {
    ImagePicker imagePicker = ImagePicker();
    List<File>? imageFileList = [];
    var selectedImages = await imagePicker.pickMultiImage();

    if(selectedImages!=null){
      for (var file in selectedImages) {
        File selectedImg = File(file.path);
        imageFileList.add(selectedImg);
      }

      addMoreImages(imageFileList, product_id);
    }
  }

  removeSpecification(int index) {
    productsDetails[0].specificationDetails.removeAt(index);

    if(this.mounted){
      setState(() {});
    }
  }

  priceUi(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Product Price",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          SizedBox(
            height: 8,
          ),
          getCountryProductPriceList.isNotEmpty?
          Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: priceListWidget(),
              )
          ) :
          Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            alignment: Alignment.center,
            child:GestureDetector(
              onTap: ()=>{showAddPrice()},
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Text('Add Price'),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.blue,
                        width: 1
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  List<Widget> priceListWidget(){
    List<Widget> pricelistUi=[];

    if(getCountryProductPriceList.length < getCurrencyList.length){
      pricelistUi.add(
          GestureDetector(
            onTap: ()=>{showAddPrice()},
            child: Container(
              margin: const EdgeInsets.only(left:2,right: 2,top: 7),
              width: 100,
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:Border.all(
                      color: Colors.grey,
                      width: 1
                  )
              ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add,color: Colors.blue,),
                    Text('Add Price For More Currencies', textAlign: TextAlign.center, style: TextStyle(
                        color: Colors.grey, fontSize: 12
                    ),)
                  ],
                )
              // child: Text('+',style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
            ),
          )
      );
    }

    for(int index=0;index<getCountryProductPriceList.length;index++){
      pricelistUi.add(
          GestureDetector(
            onTap: ()=>{showEditPrice(getCountryProductPriceList[index])},
            child: Container(
              padding: EdgeInsets.all(5),
              margin: const EdgeInsets.only(left:2,right: 2,top: 7),
              width: 100,
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:Border.all(
                      color: Colors.grey,
                      width: 1
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 25,
                    width: 40,
                    margin: EdgeInsets.only(bottom: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: getCountryProductPriceList[index].flagImage.isNotEmpty?
                      CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: baseUrl+brands_base_url+
                            getCountryProductPriceList[index].flagImage,
                        placeholder: (context, url) =>
                            Container(decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.grey[400],
                            )),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ):
                      Container(
                          alignment: Alignment.center,
                          child:Icon(Icons.error,size: 8,),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.grey[400],
                          )),
                    ),
                  ),
                  Text(getCountryProductPriceList[index].countryName,
                    style: const TextStyle(color: Colors.black54,fontSize: 14),textAlign: TextAlign.center,maxLines: 2,),
                  Text(getCountryProductPriceList[index].currency+
                      getCountryProductPriceList[index].productPrice,
                      style: const TextStyle(color: Colors.black54,fontSize: 14),textAlign: TextAlign.center),
                ],
              ),
            )

          )
      );
    }

    return pricelistUi;
  }

  void getCurrency() async {
    var url=baseUrl+'api/'+get_currecy_list;
    var uri = Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
    };
    final response = await http.post(uri,body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        CurrencyListModel currencyListModel=CurrencyListModel.fromJson(json.decode(response.body));
        getCurrencyList=currencyListModel.getCurrencyList;

        if(this.mounted){
          setState(() {});
        }
      }
    }
  }

  FutureOr onGoBackFromCurrency(dynamic value) {
    getCurrency();
  }

  showAlertCurrency() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          content: Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Please add currency first.',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Route routes = MaterialPageRoute(builder: (context) => const Add_Currency());
                                Navigator.push(context, routes).then(onGoBackFromCurrency);

                              },
                              child: const Text("Add",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[200],
                                minimumSize: const Size(70, 30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            child: ElevatedButton(
                              onPressed: () => {Navigator.pop(context)},
                              child: const Text("Close",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[200],
                                minimumSize: const Size(70, 30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  showAddPrice(){

    if(getCurrencyList.isEmpty) {
      showAlertCurrency();
    }
    else {
      List<GetSizeList> prodSize=[];

      productsDetails[0].size.forEach((element) {
        prodSize.add(GetSizeList(id: element.sizeAutoId, size: element.sizeName, ));
      });

      List<String> selectedCurrecnyId=[];
      getCountryProductPriceList.forEach((element) {
        selectedCurrecnyId.add(element.currencyAutoId);
      });


      Route routes = MaterialPageRoute(builder: (context) => AddPrice(
        product_model_auto_id: '',
        i:0,
        onSaveCallback: AddPriceListener,
        selectedSize: prodSize,
        selectedCurrencyId:selectedCurrecnyId,
        getCurrencyList: getCurrencyList,
      )
      );

      Navigator.push(context, routes);
    }
  }

  void AddPriceListener(int i,List<ProductPrice> productPriceList) {

    addProductPrice(productPriceList, productsDetails[0].productAutoId);
    if(this.mounted){
      setState(() {
      });
    }
  }

  showEditPrice(  GetCountryProductPriceList productPriceList){
    Route routes = MaterialPageRoute(builder: (context) => EditPrice(
      productPriceList: productPriceList,
      size: productsDetails[0].size,
      onSaveCallback: editPriceListener,
    )
    );

    Navigator.push(context, routes);
  }

  editPriceListener() {
    getProductPriceList();

    if(this.mounted){
      setState(() {
      });
    }
  }

  getFormUi() async {
    var url=baseUrl+'api/'+get_product_formui;

    var uri = Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        ProductFormUiModel product_ui=ProductFormUiModel.fromJson(json.decode(response.body));
        getFormuilist=product_ui.getdatalist;
        productsDetails[0].issize=getFormuilist[0].size;
        productsDetails[0].iscolor=getFormuilist[0].color;
        productsDetails[0].ishighlights=getFormuilist[0].highlights;
        productsDetails[0].isspecification=getFormuilist[0].specification;
        productsDetails[0].isbrand=getFormuilist[0].brand;
        productsDetails[0].isnew_arrival=getFormuilist[0].newArrival;
        productsDetails[0].ismoq=getFormuilist[0].moq;
        productsDetails[0].isgross_wt=getFormuilist[0].grossWt;
        productsDetails[0].isnet_wt=getFormuilist[0].netWt;
        productsDetails[0].isunit=getFormuilist[0].unit;
        productsDetails[0].isquantity=getFormuilist[0].quantity;
        productsDetails[0].isuse_by=getFormuilist[0].useBy;
        productsDetails[0].isexpected_delivery=getFormuilist[0].expectedDelivery;
        productsDetails[0].isreturn_exchange=getFormuilist[0].returnExchange;
        productsDetails[0].isdimension=getFormuilist[0].dimension;
        productsDetails[0].ismanufacturers=getFormuilist[0].manufacturers;
        productsDetails[0].ismaterial=getFormuilist[0].material;
        productsDetails[0].isfirmness=getFormuilist[0].firmness;
        productsDetails[0].isthickness=getFormuilist[0].thickness;
        productsDetails[0].istrial_period=getFormuilist[0].trialPeriod;
        productsDetails[0].isinventory=getFormuilist[0].inventory;

      }
      else{

      }

      if(mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
    }
    else{
      if(mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
    }
  }

  getColorListApi() async {
    var url = baseUrl+'api/' + get_color_list;

    Uri uri=Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
    };
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      if (status == 1) {
        ColorListModel colorListModel=ColorListModel.fromJson(json.decode(response.body));
        List<GetColorList> getcolor=colorListModel.getColorList;

        for (var element in getcolor) {
          colorList.add(element.colorName);
        }
      }
      else {
        colorList = [];
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  getUnitListApi() async {
    var url = baseUrl+'api/' + get_product_unit;

    Uri uri=Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
    };
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);

      int  status = resp['status'];
      if (status == 1) {
        ProductUnitModel productUnitModel=ProductUnitModel.fromJson(json.decode(response.body));
        List<GetUnitList> getunit=productUnitModel.getUnitList;

        for (var element in getunit) {
          Unit_list.add(element.unit);
        }
      }
      else {
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  getSizeListApi() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    var url = baseUrl+'api/' + get_size_list;

    Uri uri=Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
    };
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      if (status == 1) {
        GetSizeListModel getSizeListModel=GetSizeListModel.fromJson(json.decode(response.body));
        size_List=getSizeListModel.getSizeList;
        size_title=getSizeListModel.title!;
      }
      else {
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  getManufacturerListApi() async {

    var url = baseUrl+'api/' + get_manufacturer;

    Uri uri=Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
    };

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);

      int  status = resp['status'];

      if (status == 1) {
        Manufacturer_List_Model manufacturerListModel=Manufacturer_List_Model.fromJson(json.decode(response.body));
        List<GetManufacturerList> getmanufacturer=manufacturerListModel.data;

        for (var element in getmanufacturer) {
          Manufacturer_list.add(element.manufacturerName);
        }
      }
      else {
        print('empty');
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  getMaterialList() async {
    var url = baseUrl+'api/' + get_material;

    Uri uri=Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
    };
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      //print(resp.toString());
      int  status = resp['status'];
      //print("material status=>"+status.toString());
      if (status == 1) {
        MaterialListModel materialListModel=MaterialListModel.fromJson(json.decode(response.body));
        List<GetMaterialData> getmaterial=materialListModel.data;

        for (var element in getmaterial) {
          Material_list.add(element.materialName);
        }
      }
      else {
        print('empty');
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  getFirmnessList() async {

    var url = baseUrl+'api/' + get_firmness;

    Uri uri=Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
    };
    final response = await http.post(uri, body: body);


    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      //print(resp.toString());
      int  status = resp['status'];
      //print("firmness status=>"+status.toString());
      if (status == 1) {
        FirmnessListModel firmnessListModel=FirmnessListModel.fromJson(json.decode(response.body));
        List<GetFirmnessData> getfirmness=firmnessListModel.data;

        for (var element in getfirmness) {
          Firmness_list.add(element.firmnessType);
        }
      }
      else {
        print('empty');
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  void getProductColorList() {
    Rest_Apis restApis=Rest_Apis();

    restApis.getProductColors(baseUrl,productsDetails[0].productModelAutoId,admin_auto_id,app_type_id).then((value){
      isApiCallProcessing=false;
      if(value!=null){
        ProductColorModel productColorModel=value;
        if(productColorModel.status==1){
          productColorList=productColorModel.getProductsLists;
        }
        else{
        }

        if(mounted){
          setState(() {});
        }
      }
    });
  }

  void showprogressDialog(){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
          backgroundColor: Colors.white,
          content: Wrap(
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Please wait. Your product is being updated. This might take some time',style: TextStyle(color: Colors.black),),
                      SizedBox(height: 10,),
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    ],
                  ),
                )

              ]
          )      ),
    ) ;
  }

  void edit_product()async {

    showprogressDialog();

    String brandAutoId='';
    for(int i=0;i<getBrandslist.length;i++){
      if(brandName==getBrandslist[i].brandName){
        brandAutoId=getBrandslist[i].id;
      }
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

    String offer='0';
    if(offerController.text.isNotEmpty){
      offer=offerController.text;
    }

    String offerAutoId='';

    if(selectedOffer.isNotEmpty){
      offerAutoId=selectedOffer[0].id;
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

    setState(() {
      isApiCallProcessing=true;
    });

    var url = baseUrl +'api/'+update_admin_product;

    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);

    //color image
    try{
      if(colorImage[0]!=null){
        request.files.add(
          http.MultipartFile(
            'color_image',
            colorImage[0].readAsBytes().asStream(),
            await colorImage[0].length(),
            filename: colorImage[0].path.split('/').last,),);
      }
      else{
        request.fields["color_image"] = productsDetails[0].colorImage;
      }
    }
    catch(exception){
      request.fields["color_image"] = productsDetails[0].colorImage;
    }

    request.fields["product_auto_id"] = product_id;
    request.fields["user_auto_id"] = user_id;
    request.fields["main_category_auto_id"] = productsDetails[0].mainCategoryAutoId;
    request.fields["sub_category_auto_id"] = productsDetails[0].subCategoryAutoId;
    request.fields["product_name"] = productname_Controller.text;
    request.fields["product_dimensions"] = productsDetails[0].productDimensions;
    request.fields["added_by"]='Admin';
    request.fields["brand_auto_id"] = brandAutoId;
    request.fields["color_name"] = selectedColorController.text;
    request.fields["new_arrival"] = newArrival;
    request.fields["unit"] = unit;
    request.fields["gross_wt"] = Grossweight_controller.text;
    request.fields["net_wt"] = NetWeight_controller.text;
    request.fields["moq"] = moqController.text;
    request.fields["quantity"] = Quantity_Controller.text;
    request.fields["offer_percentage"] = offer;
    request.fields["weight"] = Weight_Controller.text;
    request.fields["product_price"] = priceController.text;
    request.fields["description"] = heightlightController.text;
    request.fields["size"] = selectedSize;
    request.fields["size_price"] = selectedSizePrice;
    request.fields["including_tax"] = includingTax;
    request.fields["tax_percentage"] = taxController.text;
    request.fields["offer_auto_id"] = offerAutoId;
    request.fields["specification_title"] = specification_title;
    request.fields["specification_description"] = specification_value;
    request.fields["isReturn"] = isReturn;
    request.fields["isExchange"] = isExchange;
    request.fields["days"] = daysController.text;
    request.fields["time"] = deliveryTimeController.text;
    request.fields["time_unit"] =deliveryByUnit;
    request.fields["use_by"] = useByController.text;
    request.fields["closure_type"] = "";
    request.fields["fabric"] = "";
    request.fields["sole"] = "";
    request.fields["admin_auto_id"] = admin_auto_id;
    request.fields["app_type_id"] =app_type_id;
    request.fields["height"]=height;
    request.fields["Width"]=width;
    request.fields["depth"]=depth;
    request.fields["Manufacturers"]=manufacturer;
    request.fields["Material"]=material;
    request.fields["Firmness"]=firmness;
    request.fields["Thickness"]=thicknessController.text;
    request.fields["Trial_Period"]=trial_periodController.text;
    request.fields["stock"]=stock_Controller.text;
    request.fields["available_stock"]=available_stock_Controller.text;
    request.fields["Stock_alert_limit"]=stock_alert_limit_Controller.text;
    request.fields["product_sku"]= productSku;

    http.Response response = await http.Response.fromStream(await request.send());

    String status;
    String msg='';

    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      status = resp['status'];
      if(status=="1"){
        Fluttertoast.showToast(msg: "Product updated successfully", backgroundColor: Colors.grey,);

        Navigator.pop(context);
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

  void getProductPriceList() {
    Rest_Apis restApis=Rest_Apis();
    getCountryProductPriceList.clear();
    restApis.getProductPrice(baseUrl,productsDetails[0].productAutoId,user_id, admin_auto_id,app_type_id).then((value){
      isApiCallProcessing=false;
      if(value!=null){
        if(mounted){
          setState(() {
            isApiCallProcessing=false;
          });
        }

        ProductPriceModel productPriceModel=value;
        if(productPriceModel.status==1){
          getCountryProductPriceList=productPriceModel.getCountryProductPriceList;
        }
        else{
          getCountryProductPriceList=[];
        }

        if(mounted){
          setState(() {});
        }
      }
    });
  }

  Future addProductPrice(List<ProductPrice> productPriceList,String productAutoId) async{
    for(int index=0;index<productPriceList.length;index++){
      Rest_Apis restApis = Rest_Apis();

      restApis.addProductPrice(productPriceList[index], productAutoId, user_id, admin_auto_id, baseUrl,app_type_id).then((value) {
        if (value != null) {
          if(value=='1'){
            getProductPriceList();
          }
        }
      });
    }

  }

  Future addMoreImages(List<File> images,String productAutoId) async{
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    for(int index=0;index<images.length;index++){
      var url=baseUrl+'api/'+add_product_image;

      var uri = Uri.parse(url);

      var request = http.MultipartRequest("POST", uri);

      try{
        request.files.add(
          http.MultipartFile(
            'image_file',
            images[index].readAsBytes().asStream(),
            await images[index].length(),
            filename: images[index].path.split('/').last,),);
      }
      catch(exception){
        request.fields["image_file"] = '';
      }

      request.fields["product_auto_id"] = productAutoId;
      request.fields['admin_auto_id'] = admin_auto_id;
      request.fields["app_type_id"] =app_type_id;

      http.Response response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        final resp=jsonDecode(response.body);
        String status=resp['status'];
        if(status=='1'){
          isApiCallProcessing=false;
          Fluttertoast.showToast(msg: "Product imamge added", backgroundColor: Colors.grey,);
          getProductDetails();
        }
        else{
          if(mounted){
            setState(() {
              isApiCallProcessing=false;
            });
          }
          Fluttertoast.showToast(msg: "Something went wrong.Please try later", backgroundColor: Colors.grey,);
        }
      }
    }

  }

  getProductDetails() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "product_auto_id": product_id,
      "customer_auto_id": user_id,
      "admin_auto_id": admin_auto_id,
      "app_type_id":app_type_id,
    };

    var url = baseUrl+'api/' + get_product_details;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);

      //print('resp: '+ resp.toString());

      int  status = resp['status'];
      if (status == 1) {
        ProductDetailsModel productDetailsModel=ProductDetailsModel.fromJson(json.decode(response.body));
        productsDetails=productDetailsModel.getProductsDetails;

        getFormUi();

        getProductColorList();
        getProductPriceList();

        if(productsDetails.isNotEmpty){
          GetProductsDetails productDetailsList=productsDetails[0];
          productname_Controller.text = productDetailsList.productName;
          Grossweight_controller.text = productDetailsList.grossWt;
          NetWeight_controller.text = productDetailsList.netWt;
          Quantity_Controller.text = productDetailsList.quantity;
          priceController.text = productDetailsList.productPrice;
          offerController.text = productDetailsList.offerPercentage;
          finalproceController.text = productDetailsList.finalProductPrice;
          moqController.text = productDetailsList.moq;
          heightlightController.text = productDetailsList.description;
          selectedColorController.text = productDetailsList.colorName;
          taxController.text = productDetailsList.taxPercentage;
          daysController.text = productDetailsList.days;
          useByController.text=productDetailsList.useBy;
          deliveryTimeController.text=productDetailsList.time;
          heightController.text=productDetailsList.height;
          widthController.text=productDetailsList.Width;
          depthController.text=productDetailsList.depth;
          thicknessController.text=productDetailsList.Thickness;
          trial_periodController.text=productDetailsList.TrialPeriod;
          //stock_Controller.text=productDetailsList.stock;
          available_stock_Controller.text=productDetailsList.availableStock;
          stock_alert_limit_Controller.text=productDetailsList.stockAlertLimit;

          unit=productDetailsList.unit;
          newArrival=productDetailsList.newArrival;
          includingTax=productDetailsList.includingTax;
          deliveryByUnit=productDetailsList.timeUnit;
          if(Manufacturer_list.length!=0 && Manufacturer_list.length!=1) {
            manufacturer = productDetailsList.Manufacturers;
          }
          if(Material_list.length!=0 && Material_list.length!=1) {
            material=productDetailsList.Material;
          }
          if(Firmness_list.length!=0 && Firmness_list.length!=1) {
            firmness=productDetailsList.Firmness;
          }
          firmness=productDetailsList.Firmness;
          productSku = productDetailsList.productSku;
          if(productsDetails[0].isReturn.isNotEmpty){
            isReturn=productsDetails[0].isReturn;
          }

          if(productsDetails[0].isExchange.isNotEmpty){
            isExchange=productsDetails[0].isExchange;
          }

          if(getBrandslist.isNotEmpty){
            for(int i=0;i<getBrandslist.length;i++){
              if(productDetailsList.brandAutoId==getBrandslist[i].id){
                brandName=getBrandslist[i].brandName;
              }
            }
          }

          if(productDetailsList.offerData.isNotEmpty){
            Offers offer=Offers(homecomponentAutoId: productDetailsList.offerData[0].homecomponentAutoId,
              componentImage: productDetailsList.offerData[0].componentImage,
              brand: productDetailsList.offerData[0].brand,
              subcategory: productDetailsList.offerData[0].subcategory,
              mainCategory: productDetailsList.offerData[0].mainCategory,
              id: productDetailsList.offerData[0].offerAutoId,
              offer: productDetailsList.offerData[0].offer,
              price: productDetailsList.offerData[0].price,
              updatedAt: '',
              createdAt: '',
              rdate: '',
            );

            selectedOffer.add(offer);
          }
        }
      }
      else {
        print('empty');
        if(mounted){
          setState(() {
            isApiCallProcessing=false;
          });
        }
      }
    }
  }

  Future getMainBrand() async {
    var url=baseUrl+'api/'+get_brand_list;

    var uri = Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        AllBrandsModel allBrandsModel=AllBrandsModel.fromJson(json.decode(response.body));
        getBrandslist=allBrandsModel.getBrandslist;

        for (var element in getBrandslist) {
          brand_list.add(element.brandName);
        }
      }

      if(mounted){
        setState(() {});
      }
    }
  }

}

class Size_Model {
  String name;
  bool isSelected;
  Size_Model(this.name, this.isSelected);
}
