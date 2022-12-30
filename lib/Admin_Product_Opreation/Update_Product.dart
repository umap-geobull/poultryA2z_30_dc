import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Admin_Product_Opreation/Model/Product_Details_Model.dart';
import 'package:image_picker/image_picker.dart';
import '../../Utils/constants.dart';
import '../Admin_add_Product/Components/Model/Model.dart';
import '../Admin_add_Product/Components/Model/Add_Product_Model.dart';
import '../Home/Components/AddNewComponent/models/all_brands_model.dart';
import '../Utils/App_Apis.dart';
import 'Model/Rest_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';

class Update_Product extends StatefulWidget {
  Update_Product({Key? key, required this.product_id}) : super(key: key);
  String product_id;

  @override
  _tabsState createState() => _tabsState();
}

class _tabsState extends State<Update_Product> {
  List<Add_Product_Details> add_product_ = [];
  String Size_name = "";
  Product_Details_Model? product_details_model;
  ProductDetails? product_detailsList;

  List<GetBrandslist> getBrandslist=[];
  List<String> brand_list=[
    'Select Brand'
  ] ;

  File? product_img;
  final ImagePicker _picker = ImagePicker();
  String? selected_BrandValue, selected_UnitValue,selectedArrivalValue;
  String user_id = "";
  List<String> Unit_list = [
    'Select Unit',
    'Kilogram (KG)',
    'Liter (Ltr)',
    'Bunch(BN)',
    'Dozen(12 Unit)',
  ];

  List<Model> Color_List = [
    Model("orange", "assets/colors/orange.jpg", false),
    Model("green", "assets/colors/green.png", false),
    Model("blue", "assets/colors/blue.png", false),
    Model("red", "assets/colors/red.jpg", false),
    Model("yellow", "assets/colors/yellow.jpg", false),
    /*  Model("black", "assets/colors/black.png", false),
    Model("white", "assets/colors/white.png", false),*/
  ];
  List<String> selectedColor = [];
  List<Size_Model> Size_List = [
    Size_Model("5", false),
    Size_Model("6", false),
    Size_Model("7", false),
    Size_Model("8", false),
    Size_Model("9", false),
    Size_Model("10", false),
  ];

  List<String> selectedSize = [];

  List<File>? imageColorList = [];

  var productname_Controller = TextEditingController();
  var Grossweight_controller= TextEditingController() ;
  var NetWeight_controller = TextEditingController();
  var Quantity_Controller = TextEditingController();
  var priceController = TextEditingController();
  var offerController = TextEditingController();
  var finalproceController = TextEditingController();
  var moqController = TextEditingController();
  var mopController = TextEditingController();
  var heightlightController = TextEditingController();
  var specificationController = TextEditingController();
  var selectedColorController = TextEditingController();
  var selectedSizeController = TextEditingController();
  var product_imageController = TextEditingController();

  late File product_image;

  bool isImageSelected=false;

  String product_name = "";

  String baseUrl='';

  List<String> Arrival_List = [
    'Select New Arrival',
    'Yes',
    'No',
  ];

  bool isApiCallProcess=false;

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if(baseUrl!=null){
      this.baseUrl=baseUrl;
      setState(() {});

      getUserId();
      getMainBrand();
      print("product_id=>" + widget.product_id);
      getProduct_Info(widget.product_id);
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
          title: Text("Edit Product",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed:  Navigator.of(context).pop,
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Add_Product_Layout(context));
  }

  Widget Add_Product_Layout(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Product Image",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),

                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                      onTap: () {
                        showImageDialog();
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                              width: 150,
                              height: 150,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child:product_image != null ?
                              Image.file(product_image, width: 100.0, height: 100.0, fit: BoxFit.fitHeight,) :

                              product_imageController.text!=null &&
                                  product_imageController.text.isNotEmpty?
                              Container(
                                width: 100, height: 100,
                                child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) =>
                                        Container(decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                        )),
                                    imageUrl:baseUrl+product_base_url +
                                        product_imageController.text
                                ),
                              ):
                              Container()))),
                  Divider(color: Colors.grey.shade300),
                  Text("Product Name",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 45,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: TextFormField(
                        controller: productname_Controller,

                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                            hintText: "Enter the Product name",
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
                        keyboardType: TextInputType.name,

                      ),
                    ),
                  ),
                  Divider(color: Colors.grey.shade300),

                  Text("New Arrival",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(
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
                        value: selectedArrivalValue,
                        hint: Row(
                          children: const [
                            Expanded(
                              child: Text(
                                'Select New Arrival',
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
                            selectedArrivalValue = value as String;
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
                  ),
                  Divider(color: Colors.grey.shade300),


                  Text("Product Unit",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(
                    height: 8,
                  ),
                  Center(
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
                        value: selected_UnitValue,
                        onChanged: (value) {
                          setState(() {
                            selected_UnitValue = value as String;
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
                  ),
                  Divider(color: Colors.grey.shade300),
                  Text("Product Gross Weight",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 45,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: TextFormField(
                        controller: Grossweight_controller,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                            hintText: "Enter the product gross weight",
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
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey.shade300),
                  Text("Product Net Weight",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 45,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: TextFormField(
                        controller: NetWeight_controller,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                            hintText: "Enter the product net weight",
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
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey.shade300),
                  Text("Product Quantity",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 45,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: TextFormField(
                        controller: Quantity_Controller,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                            hintText: "Enter the Product Quantity",
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
                  Text("Product Price",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 45,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: TextFormField(
                        controller: priceController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                            hintText: "Enter the Product price",
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
                  Text("Product Offer(%)",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 45,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: TextFormField(
                        controller: offerController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                            hintText: "Enter the Product offer(%)",
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
                  Text("Product Final Price",
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
                  Text("Minimum Order Quantity(MOQ)",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 45,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: TextFormField(
                        controller: moqController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                            hintText: "Enter the MOQ",
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
                        keyboardType: TextInputType.name,
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey.shade300),
                  Text("Minimum Order Prize(MOP)",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 45,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: TextFormField(
                        controller: mopController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                            hintText: "Enter the MOP",
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
                        keyboardType: TextInputType.name,
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey.shade300),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text("Select Color",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black))),
                      GestureDetector(
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: kPrimaryColor, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "Add Color",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          select_Color();
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                      child: GridView.builder(
                          physics: ScrollPhysics(),
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                            crossAxisCount: 5,
                          ),
                          itemCount: Color_List.length,
                          itemBuilder: (BuildContext context, int index) {
                            // return item
                            return Color_Card_Item(
                              Color_List[index].name,
                              Color_List[index].img,
                              Color_List[index].isSelected,
                              index,
                            );
                          })),
                  Container(
                      child: InkWell(
                    onTap: () {
                      //select_Color();
                    },
                    child: GridView.builder(
                        physics: ScrollPhysics(),
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          crossAxisCount: 5,
                        ),
                        itemCount: imageColorList!.isEmpty
                            ? 1
                            : imageColorList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          // return item
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1.5),
                              ),
                              child: imageColorList!.isEmpty
                                  ? Icon(
                                      CupertinoIcons.camera,
                                      color: Colors.grey.withOpacity(0.5),
                                    )
                                  : Image.file(
                                      File(imageColorList![index].path)),
                            ),
                          );
                        }),
                  )),
                  Divider(color: Colors.grey.shade300),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text("Select Size",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black))),
                      GestureDetector(
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: kPrimaryColor, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "Add Size",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          //select_Color();
                          show_addSize_Layout();
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                      child: GridView.builder(
                          physics: ScrollPhysics(),
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                            crossAxisCount: 6,
                          ),
                          itemCount: Size_List.length,
                          itemBuilder: (BuildContext context, int index) {
                            // return item
                            return SizeItem_Card(
                              Size_List[index].name,
                              Size_List[index].isSelected,
                              index,
                            );
                          })),
                  Divider(color: Colors.grey.shade300),
                  Text("Product Highlight",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 100,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: TextFormField(
                        controller: heightlightController,
                        decoration: InputDecoration(
                            filled: true,
                            hintText: "Enter the highlight",
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
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

                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,

                        minLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        maxLines: null,
                        // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
                        expands: true,
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey.shade300),
                  Text("Product Specification",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 100,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: TextFormField(
                        controller: specificationController,
                        decoration: InputDecoration(
                            filled: true,
                            hintText: "Enter the specification",
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
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

                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,

                        minLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        maxLines: null,
                        // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
                        expands: true,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child:
                      isApiCallProcess==true?
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: GFLoader(
                            type:GFLoaderType.circle
                        ),
                      ):
                      Container(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: kPrimaryColor,
                              textStyle: const TextStyle(fontSize: 20)),
                          onPressed: () {
                            Update_Product_Info();
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
        ));
  }

  @override
  void dispose() {

    productname_Controller.dispose();
    super.dispose();
  }

  Widget Color_Card_Item(
      String name, String image, bool isSelected, int index) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: isAdded(Color_List[index].name as String, "color_type") == true
                    ? kPrimaryColor
                    : Colors.grey,
                width: 1.5),
          ),
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        height: 30,
                        width: 30,

                        /*Image.asset(image)*/
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            image,
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
                ),
                Container(
                  height: 15,
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 10, color: black),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () => {
        setState(() =>{
          setSelected(Color_List[index].name as String, "color_type")

        })
      },
    );
  }

  Widget SizeItem_Card(String name, bool isSelected, int index) {
    return GestureDetector(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Container(
            height: 30,
            width: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: isAdded(Size_List[index].name as String, "size_type") == true
                      ? kPrimaryColor
                      : Colors.grey,
                  width: 1.5),
            ),
            alignment: Alignment.center,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),

                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 20,
                    ),
                    onTap: ()=>{

                      setState(() =>{
                        Size_List.removeWhere((item) => item.name == name)

                      })
                    },
                  ),
                ),
              ],
            ),
          )
      ),
      onTap: () => {
        setState(() => {
          setSelected(Size_List[index].name as String, "size_type"),

        })
      },
    );
  }

  setSelected(String name, String type) {
      if(type == "size_type")
        {
          if (isAdded(name, type) == true) {
            // selectedSize.remove(name);
            selectedSize.remove(name);
            print("data=>"+selectedSize.toString());
          } else {
            if (selectedSize.length < 10) {
              //   selectedSize.add(name);
              selectedSize.add(name);
              print("data=>"+selectedSize.toString());

            } else {
              Fluttertoast.showToast(
                msg: "Maximum 10 size can be selected",
                backgroundColor: Colors.grey,
              );
            }
        }


      }
      else if(type == "color_type"){
        if (isAdded(name, type) == true) {
          // selectedSize.remove(name);
          selectedColor.remove(name);
          print("data=>"+selectedColor.toString());
        } else {
          if (selectedColor.length < 10) {
            //   selectedSize.add(name);
            selectedColor.add(name);
            print("data=>"+selectedColor.toString());

          } else {
            Fluttertoast.showToast(
              msg: "Maximum 10 size can be selected",
              backgroundColor: Colors.grey,
            );
          }
        }
      }

  }

  bool isAdded(String name, String type) {
      if(type == "size_type")
        {
          for (int i = 0; i < selectedSize.length; i++) {
            if (selectedSize[i] == name) {
              return true;
            }
          }
          return false;
        }
     else if(type == "color_type")
      {
        for (int i = 0; i < selectedColor.length; i++) {
          if (selectedColor[i] == name) {
            return true;
          }
        }
        return false;
      }

     return false;



  }

  Future<void> select_Color() async {
    ImagePicker imagePicker = ImagePicker();

    var selectedImages = await imagePicker.pickMultiImage();

    if(selectedImages!=null) {
      selectedImages.forEach((file) {
        File selectedImg = File(file.path);
        imageColorList?.add(selectedImg);
      });
      print("Image List Length:" + imageColorList!.length.toString());
    }

/*
    if (selectedImages!.isNotEmpty) {
      imageColorList?.addAll(selectedImages);

      print("Image List Length:" + imageColorList!.length.toString());
    }
*/
    // print("Image List Length:" + imageFileList.length.toString());
    setState(() {});
  }

  void show_addSize_Layout() {
    showModalBottomSheet<void>(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                      child: Text('Add Size',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  Divider(color: Colors.grey.shade300),
                  SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: TextField(
                      decoration: InputDecoration(hintText: 'Enter size'),
                      autofocus: true,
                      onChanged: (value) => {
                        setState(() {
                          Size_name = value;
                        })
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: kPrimaryColor,
                              textStyle: const TextStyle(fontSize: 20)),
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              Size_List.add(Size_Model(Size_name, false));
                            });
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ));
  }

  void getProduct_Info(String product_id) async {
    Rest_Apis restApis = new Rest_Apis();

    restApis.getProduct_Info(product_id,baseUrl).then((value) {
      if (value != null) {
        if(this.mounted){
          setState(() {
            product_details_model = value;
          });
        }

        if (product_details_model != null) {

          product_detailsList = product_details_model?.productDetails;

          product_imageController.text = product_detailsList!.productImg!;

          setState(() {
            product_name = product_detailsList!.productName!;
          });
          productname_Controller.text = product_detailsList!.productName!;
          Grossweight_controller.text = product_detailsList!.grossWeight!;
          NetWeight_controller.text = product_detailsList!.netWeight!;
          Quantity_Controller.text = product_detailsList!.productQuantity!;
          priceController.text = product_detailsList!.price!;
          offerController.text = product_detailsList!.offerPrice!;
          finalproceController.text = product_detailsList!.finalPrice!;
          moqController.text = product_detailsList!.minimumOrderQuantity!;
          selected_UnitValue = product_detailsList!.productUnit;
          selectedArrivalValue = product_detailsList!.new_arrival;
          specificationController.text = product_detailsList!.productSpecification!;
          heightlightController.text = product_detailsList!.productDescription!;
          selectedColorController.text = product_detailsList!.productColors!;

          if(!selectedColorController.text.isEmpty){
            selectedColor= selectedColorController.text.split("|");
          }
          selectedSizeController.text = product_detailsList!.productSize!;

          if(!selectedSizeController.text.isEmpty){
            selectedSize = selectedSizeController.text.split("|");

          }

        } else {
          Fluttertoast.showToast(
            msg: "No product found",
            backgroundColor: Colors.grey,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Something went wrong",
          backgroundColor: Colors.grey,
        );
      }
    });
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

        getBrandslist.forEach((element) {
          brand_list.add(element.brandName);
        });
      }

      if(this.mounted){
        setState(() {});
      }
    }
  }

  showImageDialog() {
    return showDialog(
      context: context,
      builder: (context) => new SimpleDialog(
        title: new Text('Upload image from'),
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

  void Update_Product_Info() {

    setState(() {
      isApiCallProcess=true;
    });

    String selected_size = "";

    for (int i = 0; i < selectedSize.length; i++) {
      if (i == 0) {
        selected_size += selectedSize[i];
      } else {
        selected_size += '|' + selectedSize[i];
      }
    }

    String selected_color = "";

    for (int i = 0; i < selectedColor.length; i++) {
      if (i == 0) {
        selected_color += selectedColor[i];
      } else {
        selected_color += '|' + selectedColor[i];
      }
    }

    Rest_Apis restApis=new Rest_Apis();

    restApis.Update_Product(baseUrl,widget.product_id, user_id, product_detailsList!.mainCategoryAutoId!,
        product_image, productname_Controller.text,priceController.text,product_detailsList!.subCategoryAutoId!,
        product_detailsList!.brandName!, product_detailsList!.brandAutoId!, selected_UnitValue!, Quantity_Controller.text, Grossweight_controller.text,
        NetWeight_controller.text, offerController.text,finalproceController.text, moqController.text,
        selected_color, selected_size,heightlightController.text,
        NetWeight_controller.text,"", specificationController.text).
    then((value){
      if(value!=null){
        String status=value;
        print("status=>"+status.toString());
        if(status=="1"){
          Fluttertoast.showToast(msg: "Product updated successfully", backgroundColor: Colors.grey,);
          //product_info_model_List.removeWhere((item) => item.productName == product_info_model_List[i].productName);
        }
        else{
          Fluttertoast.showToast(msg: "Error while adding product. Please try later", backgroundColor: Colors.grey,);
        }
      }
      setState(() {});
    });
  }
}

class Size_Model {
  String name;
  bool isSelected;

  Size_Model(this.name, this.isSelected);
}
