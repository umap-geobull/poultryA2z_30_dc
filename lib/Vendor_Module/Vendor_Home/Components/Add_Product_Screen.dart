import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../Vendor_Module/Vendor_Home/Components/Rest_Apis.dart';
import '../Utils/constants.dart';
import 'Model/Brand_List_Model.dart';
import 'Model/Product_Info_Model.dart';

class Add_Product_Screen extends StatefulWidget {
  Add_Product_Screen(
      {Key? key,
      required this.imageFileList,
      required this.main_cat_id,
      required this.sub_cat_id})
      : super(key: key);
  List<XFile>? imageFileList;
  String main_cat_id;
  String sub_cat_id;

  @override
  _Add_Product_ScreenState createState() => _Add_Product_ScreenState();
}

class _Add_Product_ScreenState extends State<Add_Product_Screen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>showAlert(),
      child: MaterialApp(
          title: 'flutterTabs',
          home: tabs(
            imageFileList: widget.imageFileList,
            sub_cat_id: widget.sub_cat_id,
            main_cat_id: widget.main_cat_id,
          )),
    );
  }
  Future<bool> showAlert() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: const Text('Are you sure?',style: TextStyle(color: Colors.black87),),
          content:Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    const Text('Do you want to discard your data',style: TextStyle(color: Colors.black54),),
                    const SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            child: ElevatedButton(
                              onPressed: (){

                                Navigator.pop(context);
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(builder: (context) => Vendor_details()),
                                // );
                              },
                              child: const Text("Yes",style: TextStyle(color: Colors.black54,fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green[200],
                                onPrimary: Colors.green,
                                minimumSize: const Size(70,30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )
                        ),
                        const SizedBox(width: 10,),
                        Container(
                            child: ElevatedButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              child: const Text("No",
                                  style: TextStyle(color: Colors.black54,fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue[200],
                                onPrimary: Colors.blue,
                                minimumSize: const Size(70,30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}

class tabs extends StatefulWidget {
  tabs(
      {Key? key,
      required this.imageFileList,
      required this.main_cat_id,
      required this.sub_cat_id})
      : super(key: key);
  List<XFile>? imageFileList;
  String main_cat_id;
  String sub_cat_id;

  @override
  _tabsState createState() => _tabsState();
}

class _tabsState extends State<tabs> with SingleTickerProviderStateMixin {
  final SwiperController _scrollController = SwiperController();

  TabController? tabController;
  Brand_List_Model? brandList_Model;
  List<Get_Brandslist>? getBrandslist = [];

  //Get_Brandslist? get_Brand_List;
  int currentindex2 = 0; // for swiper index initial
  String size_name = "", product_unit = "";
  int selectedIndex = 0;
  List<String> selectedSize = [];
  List<String> Arrival_List = [
    'Yes',
    'No',

  ];
  // for tab
  final _product_name_controller_ = TextEditingController();
  String? selected_BrandValue, selected_UnitValue;
  List<String> brand_list = [
    'SparX footwear',
    'Nike footwear',
    'Adidas footwear',
    'RED WINGS SHOES',
  ];

  List<String> Unit_list = [
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
  List<Model> selectedColor = [];
  List<Size_Model> Size_List = [
    Size_Model("5", false),
    Size_Model("6", false),
    Size_Model("7", false),
    Size_Model("8", false),
    Size_Model("9", false),
    Size_Model("10", false),
  ];

  String user_id = "";
String baseUrl="";
  List<XFile>? imageColorList = [];
  List<Product_Info_Model> product_info_model_List = [];

  @override
  void initState() {
    super.initState();
    getBaseUrl();
    getImage_List();
    getMainBrand();


    tabController = TabController(
      initialIndex: selectedIndex,
      length: product_info_model_List.length,
      vsync: this,
    );

    tabController?.addListener(() {
      setState(() {
        print(tabController?.index);
        _scrollController.move(tabController!.index);
      });
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text("Upload Product",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          leading: const Icon(Icons.arrow_back, color: Colors.white),
          actions: [
            IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            ),
          ]),
      body: Container(
        child: Column(
          children: [
            Container(
                child: DefaultTabController(
              // length: widget.imageFileList!.length,
              length: product_info_model_List.length,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 35.0),
                child: Material(
                  child: TabBar(
                    onTap: (index) => _scrollController.move(index),
                    controller: tabController,
                    isScrollable: true,
                    indicatorColor: const Color.fromRGBO(0, 202, 157, 1),
                    labelColor: Colors.black,
                    labelStyle: const TextStyle(fontSize: 14),
                    unselectedLabelColor: Colors.black,
                    tabs: List<Widget>.generate(
                        /*widget.imageFileList!.length*/
                        product_info_model_List.length, (int index) {
                      return Tab(text: "Product:" + (index + 1).toString());
                    }),
                  ),
                ),
              ),
            )),
            Expanded(
              child: Swiper(
                onIndexChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                    tabController!.animateTo(index);
                    currentindex2 = index;
                  });
                },
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                    tabController!.animateTo(index);
                    currentindex2 = index;
                  });
                },
                duration: 2,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Swiper(
                    duration: 2,
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return VisibilityDetector(
                        key: Key(index.toString()),
                        child: Add_Product_Layout(
                            context,
                            /*widget.imageFileList![index]*/
                            product_info_model_List[index].image,
                            index),
                        onVisibilityChanged: (VisibilityInfo info) {
                          if (info.visibleFraction == 1) {
                            setState(() {
                              selectedIndex = index;
                              tabController!.animateTo(index);
                              currentindex2 = index;
                            });
                          }
                        },
                      );
                    },
                    //itemCount: widget.imageFileList!.length,
                    itemCount: product_info_model_List.length,
                  );
                },
                //itemCount: widget.imageFileList!.length,
                itemCount: product_info_model_List.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Add_Product_Layout(BuildContext context, File imageFile, int i) {
    // File? _brand_img = File(imageFile.path);

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
                  const Text(
                    "Product Image",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        width: 150,
                        height: 150,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: imageFile != null
                            ? Image.file(
                                imageFile,
                                width: 100.0,
                                height: 100.0,
                                fit: BoxFit.fitHeight,
                              )
                            : SizedBox(
                                width: 100,
                                height: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/upload_image.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
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
                        initialValue: product_info_model_List[i].productName,
                        // controller: _product_name_controller_,
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
                        onChanged: (value) => {
                          product_info_model_List[i].productName = value,
                          setState(() {})
                        },
                        keyboardType: TextInputType.name,
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey.shade300),
                  const Text("New Arrival",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  const SizedBox(
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
                                'Select Arrival',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
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
                        value: product_info_model_List[i].new_arrival,
                        onChanged: (value) {
                          setState(() {
                            product_info_model_List[i].new_arrival = value as String;
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
                  const Text("Brand Name",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<Get_Brandslist>(
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

                        items: getBrandslist
                            ?.map<DropdownMenuItem<Get_Brandslist>>(
                                (Get_Brandslist value) {
                          return DropdownMenuItem<Get_Brandslist>(
                            value: value,
                            child: Text(
                              value.brandName as String,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        value: product_info_model_List[i].get_Brand_List,
                        /*onChanged: (value) {
                          setState(() {
                            selected_BrandValue = value as String;
                          });
                        },*/

                        onChanged: (Get_Brandslist? value) {
                          setState(() {
                            product_info_model_List[i].get_Brand_List = value;
                            product_info_model_List[i].brandName =
                                product_info_model_List[i]
                                    .get_Brand_List
                                    ?.brandName as String;
                            product_info_model_List[i].brandAutoId =
                                product_info_model_List[i].get_Brand_List?.sId
                                    as String;
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          child: const Text("Product Unit",
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
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                "Add Unit",
                                style:
                                TextStyle(fontSize: 14, color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          show_addUnit_Layout();
                        },
                      )
                    ],
                  ),
                  const SizedBox(
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
                        value: product_info_model_List[i].productUnit,
                        onChanged: (value) {
                          setState(() {
                            product_info_model_List[i].productUnit =
                                value as String;
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
                        initialValue: product_info_model_List[i].grossWeight,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                            hintText: "Enter the Product gross weight",
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
                        onChanged: (value) => {
                          product_info_model_List[i].grossWeight = value,
                          setState(() {})
                        },
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
                          initialValue: product_info_model_List[i].netWeight,
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
                          onChanged: (value) => {
                                product_info_model_List[i].netWeight = value,
                                setState(() {})
                              }),
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
                          initialValue:
                              product_info_model_List[i].productQuantity,
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
                          onChanged: (value) => {
                                product_info_model_List[i].productQuantity =
                                    value,
                                setState(() {})
                              }),
                    ),
                  ),
                  Divider(color: Colors.grey.shade300),
                  const Text("Product Actual Price",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 45,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: TextFormField(
                          initialValue: product_info_model_List[i].price,
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
                          onChanged: (value) => {
                                product_info_model_List[i].price = value,
                                setState(() {})
                              }),
                    ),
                  ),
                  Divider(color: Colors.grey.shade300),
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
                          initialValue: product_info_model_List[i].offerPrice,
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
                          onChanged: (value) => {
                                product_info_model_List[i].offerPrice = value,
                                setState(() {})
                              }),
                    ),
                  ),
                /*  Divider(color: Colors.grey.shade300),
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
                          initialValue: product_info_model_List[i].originalPrice,
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
                          onChanged: (value)=>{
                            product_info_model_List[i].originalPrice=value,

                            setState(() {})
                          }
                      ),
                    ),
                  ),*/
                  Divider(color: Colors.grey.shade300),
                  Divider(color: Colors.grey.shade300),
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
                          initialValue:
                              product_info_model_List[i].minimumOrderQuantity,
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
                          onChanged: (value) => {
                                product_info_model_List[i]
                                    .minimumOrderQuantity = value,
                                setState(() {})
                              }),
                    ),
                  ),
                  Divider(color: Colors.grey.shade300),
                  const Text("Minimum Order Prize(MOP)",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 45,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: TextFormField(
                          initialValue:
                              product_info_model_List[i].minimumOrderPrice,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                              hintText: "Enter the MOP",
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
                          onChanged: (value) => {
                                product_info_model_List[i].minimumOrderPrice =
                                    value,
                                setState(() {})
                              }),
                    ),
                  ),
                  Divider(color: Colors.grey.shade300),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          child: const Text("Select Color",
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
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
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
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                      child: GridView.builder(
                          physics: const ScrollPhysics(),
                          padding: const EdgeInsets.all(0),
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
                                i);
                          })),
                  Container(
                      child: InkWell(
                    onTap: () {
                      //select_Color();
                    },
                    child: GridView.builder(
                        physics: const ScrollPhysics(),
                        padding: const EdgeInsets.all(0),
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
                          child: const Text("Select Size",
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
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                "Add Size",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          show_addSize_Layout();
                        },
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                      child: GridView.builder(
                          physics: const ScrollPhysics(),
                          padding: const EdgeInsets.all(0),
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
                            return SizeItem_Card(Size_List[index].name,
                                Size_List[index].isSelected, index, i);
                          })),
                  Divider(color: Colors.grey.shade300),
                  const Text("Product Highlight",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 100,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: TextFormField(
                        initialValue:
                            product_info_model_List[i].productDescription,
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
                        // style: AppTheme.form_field_text,

                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) => {
                          product_info_model_List[i].productDescription = value,
                          setState(() {})
                        },
                        minLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        maxLines: null,
                        // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
                        expands: true,
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey.shade300),
                  const Text("Product Specification",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 100,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: TextFormField(
                        initialValue:
                            product_info_model_List[i].productSpecification,
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
                        // style: AppTheme.form_field_text,

                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) => {
                          product_info_model_List[i].productSpecification =
                              value,
                          setState(() {})
                        },
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
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: kPrimaryColor,
                              textStyle: const TextStyle(fontSize: 20)),
                          onPressed: () {
                            if (widget.main_cat_id == "" ||
                                widget.main_cat_id.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Main category not selected",
                                backgroundColor: Colors.grey,
                              );
                            } else if (product_info_model_List[i].image.path ==
                                "" ||
                                product_info_model_List[i].image.path.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Please add product image",
                                backgroundColor: Colors.grey,
                              );
                            } else if (product_info_model_List[i].productName ==
                                "" ||
                                product_info_model_List[i]
                                    .productName
                                    .isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Enter the product name",
                                backgroundColor: Colors.grey,
                              );
                            } else {

                              Upload_product_Info(i);
                            }
                          },
                          child: const Center(
                            child: Text(
                              'Add Product',
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
        ));
  }

  Widget Color_Card_Item(
      String name, String image, bool isSelected, int index, int i) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: isAdded(Color_List[index].name, i,
                            "color_type") ==
                        true
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
                SizedBox(
                  height: 15,
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 10, color: black),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () => {
        setState(() => {
              setSelected(Color_List[index].name, i, "color_type")
              /* Color_List[index].isSelected = !Color_List[index].isSelected;

          if (Color_List[index].isSelected == true) {
            selectedColor.add(Model(name, image, true));
          } else if (Color_List[index].isSelected == false) {
            selectedColor.removeWhere(
                (element) => element.name == Color_List[index].name);
          }*/
            })
      },
    );
  }

  Widget SizeItem_Card(String name, bool isSelected, int index, int i) {
    return GestureDetector(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Container(
            height: 30,
            width: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: isAdded(Size_List[index].name, i, "size_type") == true
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
                      margin: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),

                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    child: const Icon(
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
          setSelected(Size_List[index].name, i, "size_type"),

        })
      },
    );
  }

  setSelected(String name, int i, String type) {
    if (type == "color_type") {
      if (isAdded(name, i, type) == true) {
        // selectedSize.remove(name);
        product_info_model_List[i].selectedColor.remove(name);
        print("data=>" + product_info_model_List[i].selectedColor.toString());
      } else {
        if (product_info_model_List[i].selectedColor.length < 10) {
          //   selectedSize.add(name);
          product_info_model_List[i].selectedColor.add(name);
          print("data=>" + product_info_model_List[i].selectedColor.toString());
        } else {
          Fluttertoast.showToast(
            msg: "Maximum 10 color can be selected",
            backgroundColor: Colors.grey,
          );
        }
      }
    } else if (type == "size_type") {
      if (isAdded(name, i, type) == true) {
        // selectedSize.remove(name);
        product_info_model_List[i].selectedSize.remove(name);
        print("data=>" + product_info_model_List[i].selectedSize.toString());
      } else {
        if (product_info_model_List[i].selectedSize.length < 10) {
          //   selectedSize.add(name);
          product_info_model_List[i].selectedSize.add(name);
          print("data=>" + product_info_model_List[i].selectedSize.toString());
        } else {
          Fluttertoast.showToast(
            msg: "Maximum 10 size can be selected",
            backgroundColor: Colors.grey,
          );
        }
      }
    }
  }

  bool isAdded(String name, int j, String type) {
    if (type == "size_type") {
      for (int i = 0; i < product_info_model_List[j].selectedSize.length; i++) {
        if (product_info_model_List[j].selectedSize[i] == name) {
          return true;
        }
      }
      return false;
    } else if (type == "color_type") {
      for (int i = 0;
          i < product_info_model_List[j].selectedColor.length;
          i++) {
        if (product_info_model_List[j].selectedColor[i] == name) {
          return true;
        }
      }
      return false;
    }

    return false;
  }

  @override
  void dispose() {
    // other dispose methods
    _product_name_controller_.dispose();

    super.dispose();
  }

  Future<void> select_Color() async {
    ImagePicker imagePicker = ImagePicker();

    List<XFile>? selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages!.isNotEmpty) {
      imageColorList?.addAll(selectedImages);

      print("Image List Length:" + imageColorList!.length.toString());
    }
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
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Center(
                      child: Text('Add Size',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: TextField(
                      decoration: const InputDecoration(hintText: 'Enter size'),
                      autofocus: true,
                      onChanged: (value) => {
                        setState(() {
                          size_name = value;
                        })
                      },
                    ),
                  ),
                  const SizedBox(
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
                              Size_List.add(Size_Model(size_name, false));
                            });
                          },
                          child: const Center(
                            child: Text(
                              'Save',
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
            ));
  }
  void show_addUnit_Layout() {
    showModalBottomSheet<void>(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Center(
                  child: Text('Add Unit',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))),
              Divider(color: Colors.grey.shade300),
              const SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: TextField(
                  decoration: const InputDecoration(hintText: 'Enter Unit'),
                  autofocus: true,
                  onChanged: (value) => {
                    setState(() {
                      product_unit = value;
                    })
                  },
                ),
              ),
              const SizedBox(
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
                          Unit_list.add(product_unit);
                        });
                      },
                      child: const Center(
                        child: Text(
                          'Save',
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
        ));
  }
  void getImage_List() {
    if (widget.imageFileList != null) {
      widget.imageFileList?.forEach((file) {
        File selectedImg = File(file.path);
        product_info_model_List.add(Product_Info_Model(selectedImg));
      });
    }
  }

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if(baseUrl!=null){
      setState(() {
        this.baseUrl=baseUrl;
      });
    }
    return null;
  }

  void getMainBrand() async {
    Rest_Apis restApis = Rest_Apis();

    restApis.getBrandList(baseUrl).then((value) {
      if (value != null) {
        setState(() {
          //isApiCallProcessing = false;
          brandList_Model = value;
        });

        if (brandList_Model != null) {
          getBrandslist = brandList_Model?.getBrandslist;
        } else {
          Fluttertoast.showToast(
            msg: "No brand found",
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

  void Upload_product_Info(int i) {
    Product_Info_Model productInfoModel = product_info_model_List[i];
    print("new_arrival=>"+productInfoModel.new_arrival!+productInfoModel.originalPrice);


    String selectedSize = "";

    for (int i = 0; i < productInfoModel.selectedSize.length; i++) {
      if (i == 0) {
        selectedSize += productInfoModel.selectedSize[i];
      } else {
        selectedSize += '|' + productInfoModel.selectedSize[i];
      }
    }

    String selectedColor = "";

    for (int i = 0; i < productInfoModel.selectedColor.length; i++) {
      if (i == 0) {
        selectedColor += productInfoModel.selectedColor[i];
      } else {
        selectedColor += '|' + productInfoModel.selectedColor[i];
      }
    }
    Rest_Apis restApis = Rest_Apis();

    restApis.add_product(
            user_id,
            widget.main_cat_id,
            productInfoModel.image,
            productInfoModel.productName,
            productInfoModel.price,
            widget.sub_cat_id,
            productInfoModel.brandName,
            productInfoModel.brandAutoId,
            productInfoModel.new_arrival!,
            productInfoModel.productUnit,
            productInfoModel.productQuantity,
            productInfoModel.grossWeight,
            productInfoModel.netWeight,
            productInfoModel.offerPrice,
           // product_info_model.originalPrice,
            productInfoModel.minimumOrderQuantity,
            selectedColor,
            selectedSize,
            productInfoModel.productDescription,
            productInfoModel.netWeight,
            productInfoModel.productDimensions,
            productInfoModel.productSpecification,baseUrl)
        .then((value) {
      if (value != null) {
        setState(() {});

        int status = value;
        print("status=>" + status.toString());
        if (status == 1) {
          Fluttertoast.showToast(
            msg: "product added successfully",
            backgroundColor: Colors.grey,
          );
        } else {
          Fluttertoast.showToast(
            msg: "Error while adding product. Please try later",
            backgroundColor: Colors.grey,
          );
        }
      }
    });
  }
}

class Size_Model {
  String name;
  bool isSelected;

  Size_Model(this.name, this.isSelected);
}
