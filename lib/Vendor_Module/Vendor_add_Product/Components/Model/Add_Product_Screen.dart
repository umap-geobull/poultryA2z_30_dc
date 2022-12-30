import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:poultry_a2z/Vendor_Module/Vendor_add_Product/Components/Model/all_brands_model.dart';
import 'package:poultry_a2z/Vendor_Module/Vendor_add_Product/Components/Model/select_size_bottomsheet.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import '../../../../Admin_add_Product/constants.dart';
import '../../../Vendor_Home/Utils/App_Apis.dart';
import 'Get_SizeList_Model.dart';
import 'Product_Info_Model.dart';


class Add_Product_Screen extends StatefulWidget {
  Add_Product_Screen({Key? key, required this.imageFileList,required this.main_cat_id,required this.sub_cat_id}) : super(key: key);
  List<File> imageFileList;
  String main_cat_id;
  String sub_cat_id;

  @override
  _Add_Product_ScreenState createState() => _Add_Product_ScreenState(imageFileList);
}

class _Add_Product_ScreenState extends State<Add_Product_Screen> with TickerProviderStateMixin {
  _Add_Product_ScreenState(this.imageFileList);

  List<GetBrandslist> getBrandslist=[];

  // List<String> brand_list =[];
  List<File> imageFileList;

  TextEditingController priceController=TextEditingController();

  // SwiperController _scrollController = new SwiperController();
  late TabController tabController;

  int currentindex2 = 0; // for swiper index initial
  String size_name="";

  int selectedIndex = 0;

  late File selectedImage;
  bool isImageSlected=false;

  List<String> selectedSize = [];
  // for tab
  String? selected_BrandValue, selected_UnitValue;

  String selected_color='Select Color Name';

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

  String user_id = "";

  //List<File>? imageColorList = [];
  List<Product_Info_Model> product_info_model_List=[];

  bool isApiCallProcessing=false;
  String baseUrl='';

  bool isTabsAvaialble=false;

  getSizeList() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    var url = baseUrl+'api/' + "get_size_list";

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

      getMainBrand();
      getSizeList();
    }
  }

  Future getMainBrand() async {
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
                                Navigator.pop(context);
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

  @override
  void initState() {
    super.initState();

    getBaseUrl();

    getImage_List();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    tabController = TabController(vsync: this, length: product_info_model_List.length,initialIndex: selectedIndex);

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: kPrimaryColor,
        title: const Text("Upload Product",
            style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: ()=>{showAlert()},
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),

        bottom: TabBar(
          indicatorWeight: 3,
          controller: tabController,
          isScrollable: true,
          indicatorColor: const Color.fromRGBO(0, 202, 157, 1),
          labelColor: Colors.black,
          labelStyle: const TextStyle(fontSize: 14),
          unselectedLabelColor: Colors.black,
          tabs: List<Widget>.generate(product_info_model_List.length,
                  (int index) {
                return Tab(text: "Product:" + (index + 1).toString());
              }),
        ),

      ),

      body: TabBarView(
        controller: tabController,
        children: getTabView(),
      ),
    );
  }

  getTabView(){
    List<Widget> tabs=[];

    for(int index=0;index<product_info_model_List.length;index++){
      tabs.add(
          Add_Product_Layout(
              context, index)
      );

    }
    return tabs;
  }

  Future<void> addMoreImagesProduct(int i) async {
    ImagePicker imagePicker = ImagePicker();
    List<File>? imageFileList = [];
    var selectedImages = await imagePicker.pickMultiImage();

    if(selectedImages!=null){
      for (var file in selectedImages) {
        File selectedImg = File(file.path);
        product_info_model_List[i].productImages.add(selectedImg);
      }
      setState(() {});
    }
  }

  List<Widget> sliderItems(int k){
    List<Widget> items=[];

    for(int index=0;index<product_info_model_List[k].productImages.length;index++){
      items.add(
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: ClipRRect(
                child: product_info_model_List[k].productImages[index]!=null?
                Image.file(product_info_model_List[k].productImages[index],
                 // fit: BoxFit.fill,
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

    return items;
  }

  productImageUi(int i){
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
                  children: sliderItems(i),

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
                        addMoreImagesProduct(i)
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

  productNameUi(int i){
    return
      Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                onChanged: (value)=>{
                  product_info_model_List[i].productName=value,
                  selectedIndex=i,
                  setState(() {})
                },
                keyboardType: TextInputType.name,
              ),
            ),
          ),
          Divider(color: Colors.grey.shade300),

        ],
      ),
    );
  }

  newArrivalStatusUi(int i){
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
                value: product_info_model_List[i].new_arrival,
                onChanged: (value) {
                  setState(() {
                    product_info_model_List[i].new_arrival = value as String;
                    selectedIndex=tabController.index;
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

  brandNameUi(int i){
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
                value: product_info_model_List[i].brandName,
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
                    product_info_model_List[i].brandName=value as String;
                    selectedIndex=tabController.index;
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

  colorUi(int i){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Color",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
          Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                items: colorList.map((item) => DropdownMenuItem<String>(
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
                value: product_info_model_List[i].colorName,
                onChanged: (value) {
                  setState(() {
                    product_info_model_List[i].colorName = value as String;
                    selectedIndex=tabController.index;
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

  unitUi(int i){
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
                value: product_info_model_List[i].productUnit,
                onChanged: (value) {
                  setState(() {
                    product_info_model_List[i].productUnit = value as String;
                    selectedIndex=tabController.index;
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

  grossWeightUi(int i){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                onChanged: (value)=>{
                  product_info_model_List[i].grossWeight=value,
                  selectedIndex=tabController.index,
                  setState(() {})
                },
              ),
            ),
          ),
          Divider(color: Colors.grey.shade300),

        ],
      ),
    );
  }

  netWeightUi(int i){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                  onChanged: (value)=>{
                    product_info_model_List[i].netWeight=value,
                    selectedIndex=tabController.index,
                    setState(() {})
                  }
              ),
            ),
          ),
          Divider(color: Colors.grey.shade300),

        ],
      ),
    );
  }

  quantityUi(int i){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                  initialValue: product_info_model_List[i].productQuantity,
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
                  onChanged: (value)=>{
                    product_info_model_List[i].productQuantity=value,
                    selectedIndex=tabController.index,
                    setState(() {})
                  }
              ),
            ),
          ),
          Divider(color: Colors.grey.shade300),

        ],
      ),
    );
  }

  priceUi(int i){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                  onChanged: (value)=>{
                    product_info_model_List[i].price=value,
                    selectedIndex=tabController.index,
                    setState(() {})
                  }
              ),
            ),
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  includingTaxUi(int i){
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
                value: product_info_model_List[i].including_tax,
                onChanged: (value) {
                  setState(() {
                    product_info_model_List[i].including_tax = value as String;
                    selectedIndex=tabController.index;
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

  offerPriceUi(int i){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                  onChanged: (value)=>{
                    product_info_model_List[i].offerPrice=value,
                    selectedIndex=tabController.index,
                    setState(() {})
                  }
              ),
            ),
          ),
          Divider(color: Colors.grey.shade300),

        ],
      ),
    );
  }

  taxPerUi(int i){
    if(product_info_model_List[i].including_tax=='Yes'){
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
                    initialValue: product_info_model_List[i].tax_percentage,
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
                    onChanged: (value)=>{
                      product_info_model_List[i].tax_percentage=value,
                      selectedIndex=tabController.index,
                      setState(() {})
                    }
                ),
              ),
            ),
            Divider(color: Colors.grey.shade300),

          ],
        ),
      );
    }
  }

  moqUi(int i){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                  initialValue: product_info_model_List[i].minimumOrderQuantity,
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
                  keyboardType: TextInputType.number,
                  onChanged: (value)=>{
                    product_info_model_List[i].minimumOrderQuantity=value,
                    selectedIndex=tabController.index,
                    setState(() {})
                  }
              ),
            ),
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  productSizeUi(int i){
    return
      Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Product Size",
              style: TextStyle(
                  fontSize: 16, color: Colors.black)),
          const SizedBox(
            height: 8,
          ),
          product_info_model_List[i].selectedSize.isNotEmpty?
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                children: sizeListWidget(i),
              )
          ) :
          Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            alignment: Alignment.center,
            child:GestureDetector(
              onTap: ()=>{showSelectSize(i)},
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Text('Add Size'),
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

  List<Widget> sizeListWidget(int i){
    List<Widget> sizelistUi=[];

    sizelistUi.add(
      GestureDetector(
        onTap: ()=>{showSelectSize(i)},
        child: Container(
          margin: const EdgeInsets.only(left:2,right: 2,top: 7,bottom: 22),
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:Border.all(
                  color: Colors.grey,
                  width: 1
              )
          ),
          child: const Icon(Icons.add,color: Colors.blue,),
          // child: Text('+',style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
        )
        ,
      )
    );


    for(int index=0;index<product_info_model_List[i].selectedSize.length;index++){
      sizelistUi.add(
          GestureDetector(
            onTap: ()=>{
              removeSize(i,index)
            },
            child: Stack(
              children: <Widget>[
                Container(
                  child:
                  const Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                  width: 55,
                  alignment: Alignment.topRight,
                ),
                Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left:2,right: 2,top: 7),
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:Border.all(
                              color: Colors.grey,
                              width: 1
                          )
                      ),
                      child: Text(product_info_model_List[i].selectedSize[index].size),
                    ),
                    Text("₹"+product_info_model_List[i].selectedSizePrice[index].toString(),style: const TextStyle(color: Colors.black54,fontSize: 12),),
                  ],
                ),

              ],
            ),
          )
      );
    }

    return sizelistUi;
  }

  highlightUi(int i){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Product Highlight",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            initialValue: product_info_model_List[i].productDescription,
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
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChanged: (value)=>{
              product_info_model_List[i].productDescription=value,
              selectedIndex=tabController.index,
              setState(() {})
            },
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  specificationUi(int i){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Product Specification",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            initialValue: product_info_model_List[i].productSpecification,
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
            onChanged: (value)=>{
              product_info_model_List[i].productSpecification=value,
              selectedIndex=tabController.index,
              setState(() {})
            },
            maxLines: null,
          ),
          const Divider(color: Colors.orange),
        ],
      ),
    );
  }

  Widget Add_Product_Layout(BuildContext context, int i) {
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
                  productImageUi(i),

                  colorUi(i),

                  productSizeUi(i),

                  productNameUi(i),

                  newArrivalStatusUi(i),

                  brandNameUi(i),

                  moqUi(i),

                  unitUi(i),

                  grossWeightUi(i),

                  netWeightUi(i),

                  quantityUi(i),

                  highlightUi(i),

                  specificationUi(i),

                  priceUi(i),

                  includingTaxUi(i),

                  taxPerUi(i),

                  offerPriceUi(i),

                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: isApiCallProcessing==true?
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
                            if(validations(i)==true){
                              add_product(i);
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
                      )
                  )
                ],
              ),
            ),
          ),
        ));
  }

  bool validations(int i){
    if (widget.main_cat_id == ""|| widget.main_cat_id.isEmpty) {
      Fluttertoast.showToast(msg: "Main category not selected", backgroundColor: Colors.grey,);
      return false;
    }
    else if (product_info_model_List[i].productImages.isEmpty) {
      Fluttertoast.showToast(msg: "Please add product image", backgroundColor: Colors.grey,);
      return false;
    }
    else if (product_info_model_List[i].productName.isEmpty) {
      Fluttertoast.showToast(msg: "Enter the product name", backgroundColor: Colors.grey,);
      return false;
    }
    else if (product_info_model_List[i].price.isEmpty) {
      Fluttertoast.showToast(msg: "Enter the product price", backgroundColor: Colors.grey,);
      return false;
    }
   /* else if (product_info_model_List[i].colorImage.isEmpty) {
      Fluttertoast.showToast(msg: "Please add color image", backgroundColor: Colors.grey,);
      return false;
    }*/
    else if (product_info_model_List[i].colorName.isEmpty) {
      Fluttertoast.showToast(msg: "Please add color name", backgroundColor: Colors.grey,);
      return false;
    }
   /* else if(!(product_info_model_List[i].colorImage.isEmpty && product_info_model_List[i].colorName=='Select Color Name')){

    }*/

    return true;
  }

  void getImage_List() {
    for (var file in widget.imageFileList) {
      List<File> selectedImg = [File(file.path)];
      product_info_model_List.add(Product_Info_Model(selectedImg));
    }
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId != null) {
      setState(() {
        user_id = userId;
        print("ids=>"+widget.main_cat_id+" "+widget.sub_cat_id+" "+user_id);
      });
    }
    return null;
  }

  onBackPressed() {
    if(product_info_model_List.isNotEmpty){
      showAlert();
    }
  }

  showSelectSize(int i) async {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SelectSize(onSelectSizelistener,i,size_List);
        });
  }

  void onSelectSizelistener(GetSizeList size,String price, int i){
    Navigator.pop(context);

    product_info_model_List[i].selectedSize.add(size);

    product_info_model_List[i].selectedSizePrice.add(price);

    if(price.isNotEmpty){
      product_info_model_List[i].price=price;
    }

    selectedIndex=i;

    setState(() {});
  }

  productAddedAlert() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: const Text('Product added',style: TextStyle(color: Colors.black87),),
          content:Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    const Text('You can add more colors for this product from edit product screen',style: TextStyle(color: Colors.black54),),
                    const SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            child: ElevatedButton(
                              onPressed: (){
                                if(product_info_model_List.isEmpty){
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                                else{
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text("Ok",style: TextStyle(color: Colors.black54,fontSize: 13)),
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
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  void add_product(int i)async {

    Product_Info_Model productInfoModel = product_info_model_List[i];

    for(int i=0;i<getBrandslist.length;i++){
      if(productInfoModel.brandName==getBrandslist[i].brandName){
        productInfoModel.brand_auto_id=getBrandslist[i].id;
      }
    }

    String selectedSize = "";
    String selectedSizePrice = "";
    for (int index = 0; index < productInfoModel.selectedSize.length; index++) {
      if(index==0){
        selectedSize += productInfoModel.selectedSize[index].id;
        selectedSizePrice += productInfoModel.selectedSizePrice[index].toString();
      }
      else {
        selectedSize += '|' + productInfoModel.selectedSize[index].id;
        selectedSizePrice += '|' + productInfoModel.selectedSizePrice[index].toString();
      }
    }

    print(selectedSize);
    print(selectedSizePrice);

    String offer='0';
    if(productInfoModel.offerPrice.isNotEmpty){
      offer=productInfoModel.offerPrice;
    }

    setState(() {
      isApiCallProcessing=true;
    });

    var url = baseUrl +'api/'+add_new_product;

    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);

    request.fields["color_image"] = '';

    request.fields["user_auto_id"] = user_id;
    request.fields["main_category_auto_id"] = widget.main_cat_id;
    request.fields["sub_category_auto_id"] = widget.sub_cat_id;
    request.fields["product_name"] = productInfoModel.productName;
    request.fields["product_dimensions"] = productInfoModel.productDimensions;
    request.fields["added_by"]='Vendor';
    request.fields["brand_auto_id"] = productInfoModel.brand_auto_id;
    request.fields["color_name"] = productInfoModel.colorName;
    request.fields["new_arrival"] = productInfoModel.new_arrival;
    request.fields["unit"] = productInfoModel.productUnit;
    request.fields["gross_wt"] = productInfoModel.grossWeight;
    request.fields["net_wt"] = productInfoModel.netWeight;
    request.fields["moq"] = productInfoModel.minimumOrderQuantity;
    request.fields["quantity"] = productInfoModel.productQuantity;
    request.fields["offer_percentage"] = offer;
    request.fields["weight"] = productInfoModel.productWeight;
    request.fields["product_price"] = productInfoModel.price;
    request.fields["specification"] = productInfoModel.productSpecification;
    request.fields["description"] = productInfoModel.productDescription;
    request.fields["size"] = selectedSize;
    request.fields["size_price"] = selectedSizePrice;
    request.fields["including_tax"] = productInfoModel.including_tax;
    request.fields["tax_percentage"] = productInfoModel.tax_percentage;

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
         String productAutoId = resp['product_auto_id'];
        //String product_model_auto_id = resp['product_model_auto_id'];
       // product_info_model_List[i].sId=product_auto_id;
       // product_info_model_List[i].product_model_auto_id=product_model_auto_id;

        addProductImages(productInfoModel.productImages, productAutoId, i);
        //Fluttertoast.showToast(msg: "Product added successfully", backgroundColor: Colors.grey,);
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

  Future addProductImages(List<File> images,String productAutoId,int i) async{
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

          if(index==images.length-1){
            isApiCallProcessing=false;
            product_info_model_List.removeAt(i);
            productAddedAlert();
          }
        }
        else{
         /* if(this.mounted){
            setState(() {
              isApiCallProcessing=false;
            });
          }*/
          Fluttertoast.showToast(msg: "Something went wrong.Please try later", backgroundColor: Colors.grey,);
        }


        if(mounted){
          setState(() {
          });
        }
      }
    }

  }

  removeSize(int i, int index) {
    if(mounted){
      setState(() {
        product_info_model_List[i].selectedSize.removeAt(index);
        product_info_model_List[i].selectedSizePrice.removeAt(index);
      });
    }

  }

}

class ProductSize {
  String size;
  String size_id;
  String price;

  ProductSize(this.size, this.size_id, this.price);
}