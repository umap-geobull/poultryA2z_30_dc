import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../../../Admin_add_Product/constants.dart';
import '../../../Vendor_Home/Utils/App_Apis.dart';
import 'product_color_model.dart';
import 'product_details_model1.dart';
import 'select_size_bottomsheet.dart';
import 'size_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import 'Get_SizeList_Model.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'Rest_Apis.dart';
import 'add_color_screen .dart';
import 'all_brands_model.dart';



class Update_Product extends StatefulWidget {
  Update_Product({Key? key, required this.product_id,required this.vendor_id}) : super(key: key);
  String product_id;
  String vendor_id;

  @override
  _Update_Product createState() => _Update_Product(product_id,vendor_id);
}

class _Update_Product extends State<Update_Product> {
  String product_id;
  String user_id ;

  _Update_Product(this.product_id,this.user_id);

  List<GetProductsDetails> productsDetails=[];

  List<GetBrandslist> getBrandslist=[];
  List<String> brand_list = [
    'Select Brand',
  ];

  List<String> Unit_list = [
    'Select Unit',
    'Kilogram (KG)',
    'Liter (Ltr)',
    'Bunch(BN)',
    'Dozen(12 Unit)',
  ];
  List<String> Arrival_List = [
    'Select New Arrival',
    'Yes',
    'No',
  ];

  List<String> includingTaxList = [
    'Yes',
    'No',
  ];

  List<String> colorList=[
    'Select Color Name','Black','White','Red','Yellow','Blue','Pink','Orange','Green'
  ];

  List<GetSizeList> size_List = [];

  File? product_img;
  final ImagePicker _picker = ImagePicker();

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
  var specificationController = TextEditingController();
  var selectedColorController = TextEditingController();
  var taxController = TextEditingController();

  late File product_image;

  bool isImageSelected=false;

  String product_name = "",brandName='Select Brand';
  String newArrival='Select New Arrival';
  String unit='Select Unit';
  String includingTax='Yes';

  String baseUrl='';

  List<File> colorImage=[];
  String colorName='';

  int selectedSize=-1;

  bool isApiCallProcessing=false;

  List<GetProductsLists> productColorList=[];

  getSizeListApi() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    var url = baseUrl+'api/' + get_size_list;

    Uri uri=Uri.parse(url);

    final response = await http.get(uri);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        GetSizeListModel getSizeListModel=GetSizeListModel.fromJson(json.decode(response.body));
        size_List=getSizeListModel.getSizeList;
      }
      else {
        print('empty');
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if(baseUrl!=null){
      this.baseUrl=baseUrl;
      setState(() {});

      getProductDetails(product_id);
      getMainBrand();

      getSizeListApi();
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
          backgroundColor: kPrimaryColor,
          title: const Text("Edit Product",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed:  Navigator.of(context).pop,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
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

                      unitUi(),

                      const Text("Product Gross Weight",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(
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
                      Divider(color: Colors.grey.shade300),

                      const Text("Product Net Weight",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(
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

                      const Text("Product Quantity",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
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
                                hintText: "Enter the Product Quantity",
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

                      const Text("Product Price",
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

                      const Text("Product Offer(%)",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(
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
                      Divider(color: Colors.grey.shade300),

                   /*   Text("Product Final Price",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 45,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: TextFormField(
                            controller: finalproceController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                                hintText: "Enter the Product final Price)",
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
                            keyboardType: TextInputType.number,

                          ),
                        ),
                      ),
                      Divider(color: Colors.grey.shade300),
*/
                      const Text("Minimum Order Quantity(MOQ)",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
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

                      const Text("Product Highlight",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(
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

                      const Text("Product Specification",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: specificationController,
                        decoration: InputDecoration(
                            filled: true,
                            hintText: "Enter the specification",
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
                        maxLines: null,                        // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
                      ),
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
                                  primary: kPrimaryColor,
                                  textStyle: const TextStyle(fontSize: 20)),
                              onPressed: () {
                                edit_product();
                              },
                                child: Text(
                                  'Update Product Info',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
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

  @override
  void dispose() {

    productname_Controller.dispose();
    super.dispose();
  }

  brandNameUi(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Brand Name",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("New Arrival",
              style: TextStyle(color: Colors.black, fontSize: 16)),
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Product Unit",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
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
                  productsDetails[0].productImages[index].imageFile!=''?
                  CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: baseUrl+product_base_url+productsDetails[0].productImages[index].imageFile,

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

  getProductDetails(String productAutoId) async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "product_auto_id": productAutoId,
      "user_auto_id": user_id
    };

    print("prod_id=>"+productAutoId);
    print('user_id: '+user_id);

    var url = baseUrl+'api/edit_vendor_product' ;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        ProductDetailsModel productDetailsModel=ProductDetailsModel.fromJson(json.decode(response.body));
        productsDetails=productDetailsModel.getProductsDetails;

        getProductColorList();

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
          specificationController.text = productDetailsList.specification;
          heightlightController.text = productDetailsList.description;
          selectedColorController.text = productDetailsList.colorName;
          taxController.text = productDetailsList.taxPercentage;

          unit=productDetailsList.unit;
          newArrival=productDetailsList.newArrival;
          includingTax=productDetailsList.includingTax;
          if(getBrandslist.isNotEmpty){
            for(int i=0;i<getBrandslist.length;i++){
              if(productDetailsList.brandAutoId==getBrandslist[i].id){
                brandName=getBrandslist[i].brandName;
              }
            }
          }
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

  Future getMainBrand() async {
    brand_list.clear();
    brand_list.add('Select Brand');

    var url=baseUrl+'api/'+get_brand_list;

    var uri = Uri.parse(url);

    final response = await http.get(uri);

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

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId != null) {
      setState(() {
        user_id = userId;
        getProductDetails(product_id);
      });
    }
    return null;
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Product Sizes",
              style: TextStyle(
                  fontSize: 16, color: Colors.black)),
          const SizedBox(
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

  includingTaxUi(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Including tax",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
          Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                items: includingTaxList.map((item) => DropdownMenuItem<String>(
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
                value: includingTax,
                onChanged: (value) {
                  setState(() {
                    includingTax = value as String;
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

  taxPerUi(){
    if(includingTax=='Yes'){
      return Container();
    }
    else{
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Tax(%)",
                style: TextStyle(color: Colors.black, fontSize: 16)),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 45,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: TextFormField(
                  controller: taxController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                        hintText: "Enter the tax percentage",
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
  }

  addColors(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Product Colors",
              style: TextStyle(
                  fontSize: 16, color: Colors.black)),
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
                              imageUrl: baseUrl+product_base_url+productColorList[index].productImageLists[0].imageFile,
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
    getProductDetails(product_id);
    //priceController.text=productColorList[color_index].getPriceLists[0].sizePrice;
   // offerController.text=productColorList[color_index].getPriceLists[0].offerPercentage;
    //finalproceController.text=productColorList[color_index].getPriceLists[0].finalSizePrice;

    if(mounted){
      setState(() {

      });
    }
  }

  showSelectSize() async {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SelectSize(onSelectSizelistener,0,size_List);
        });
  }

  void onSelectSizelistener(GetSizeList size,String price, int i){
    Navigator.pop(context);

    productsDetails[0].size.add(Size(sizeAutoId: size.id,sizeName: size.size));

    productsDetails[0].getPriceLists.add(GetSizePriceLists(sizePrice:price,offerPercentage: '',finalSizePrice: ''));

    setState(() {});
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
            margin: const EdgeInsets.only(bottom: 20,left: 2,right: 2,top: 2),
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
       List<Size> sizelist=productsDetails[0].size;
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
                           pricelist.isNotEmpty && !(pricelist.length<sizelist.length)?
                           Text(pricelist[index].sizePrice):
                           Container()
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

/*      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => Add_Product_Screen(
                imageFileList: imageFileList,
                main_cat_id: widget.main_cat_id,
                sub_cat_id: widget.sub_cat_id)),
      );*/
    }

/*
    if (selectedImages!.isNotEmpty) {
      imageFileList.addAll(selectedImages);
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => Add_Product_Screen(
                imageFileList: imageFileList,
                main_cat_id: widget.main_cat_id,
                sub_cat_id: widget.sub_cat_id)),
      );
    }
*/
    // print("Image List Length:" + imageFileList.length.toString());

    setState(() {});
  }

  FutureOr onGoBack(dynamic value) {
    getProductColorList();
  }

  void getProductColorList() {
    Rest_Apis restApis=Rest_Apis();

    restApis.getProductColors(baseUrl,productsDetails[0].productModelAutoId).then((value){
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

  void edit_product()async {

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
        selectedSizePrice += productsDetails[0].getPriceLists[index].sizePrice.toString();
      }
      else {
        selectedSize += '|' + productsDetails[0].size[index].sizeAutoId;
        selectedSizePrice += '|' + productsDetails[0].getPriceLists[index].sizePrice.toString();
      }
    }

    String offer='0';
    if(offerController.text.isNotEmpty){
      offer=offerController.text;
    }

    setState(() {
      isApiCallProcessing=true;
    });

    var url = baseUrl +'api/'+update_vendor_product;

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
      print('profile pic not selected');
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
    request.fields["specification"] = specificationController.text;
    request.fields["description"] = heightlightController.text;
    request.fields["size"] = selectedSize;
    request.fields["size_price"] = selectedSizePrice;
    request.fields["including_tax"] = includingTax;
    request.fields["tax_percentage"] = taxController.text;

    // final response = await request.send();

    http.Response response = await http.Response.fromStream(await request.send());

    String status;
    String msg='';

    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      status = resp['status'];
      if(status=="1"){
        Fluttertoast.showToast(msg: "Product updated successfully", backgroundColor: Colors.grey,);
      }
      else{
        msg = resp['msg'];
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
      }

      if(mounted){
        setState(() {

        });
      }
    }
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
        print('profile pic not selected');
        request.fields["image_file"] = '';
      }

      request.fields["product_auto_id"] = productAutoId;

      http.Response response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        final resp=jsonDecode(response.body);
        String status=resp['status'];
        if(status=='1'){
          isApiCallProcessing=false;
          Fluttertoast.showToast(msg: "Product imamge added", backgroundColor: Colors.grey,);
          getProductDetails(product_id);
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
}

class Size_Model {
  String name;
  bool isSelected;

  Size_Model(this.name, this.isSelected);
}
