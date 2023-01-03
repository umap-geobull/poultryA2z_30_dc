import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/Rest_Apis.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/add_price_screen.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/add_specification_bottomsheet.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/all_offers.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/select_size_bottomsheet.dart';
import 'package:poultry_a2z/settings/Add_Units/Components/product_unit_model.dart';
import 'package:image_picker/image_picker.dart';
import '../../Home/Components/AddNewComponent/models/all_brands_model.dart';
import '../../Utils/App_Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../settings/AddCurrency/Add_Currency.dart';
import '../../settings/AddCurrency/Component/currency_list_model.dart';
import '../../settings/Add_Color/Components/Color_List_Model.dart';
import '../../settings/Add_Firmness/Components/Firmness_List_Model.dart';
import '../../settings/Add_Manufacturer/Components/Manufacturer_List_Model.dart';
import '../../settings/Add_Material/Components/Material_List_Model.dart';
import '../../settings/Add_Size/Components/Get_SizeList_Model.dart';
import 'Model/Product_FormUiModel.dart';
import 'Model/Product_Info_Model.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'Model/all_offers_model.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


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
  List<Getdatalist> getFormuilist=[];

  List<File> imageFileList;

  //TextEditingController priceController=TextEditingController();

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

  List<String> Arrival_List = [
    'Select New Arrival',
    'Yes',
    'No',
  ];

  List<String> includingTaxList = [
    'Yes',
    'No',
  ];

  List<String> Unit_list = [
    'Select Unit',
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

  List<String> colorList=[
    'Select Color Name'
  ];

  List<GetSizeList> size_List = [];
  String size_title='';
  late Route routes;

  List<Product_Info_Model> product_info_model_List=[];
  List<GetCurrencyList> getCurrencyList=[];
  bool isApiCallProcessing=false;
  String baseUrl='', admin_auto_id='',app_type_id='',user_id = '';
  bool isedit=false;
  List<String> timeUnititems = [
    'Min',
    'Hrs',
    'Days',
    'Week',
    'Month',
  ];

  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;

  void getappUi() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? appBarColor =prefs.getString('appbarColor');
    String? appbarIcon =prefs.getString('appbarIconColor');
    String? primaryButtonColor =prefs.getString('primaryButtonColor');
    String? secondaryButtonColor =prefs.getString('secondaryButtonColor');

    if(appBarColor!=null){
      this.appBarColor=Color(int.parse(appBarColor));
    }

    if(appbarIcon!=null){
      this.appBarIconColor=Color(int.parse(appbarIcon));
    }

    if(primaryButtonColor!=null){
      this.primaryButtonColor=Color(int.parse(primaryButtonColor));
      print(this.primaryButtonColor.value.toString());
    }

    if(secondaryButtonColor!=null){
      this.secondaryButtonColor=Color(int.parse(secondaryButtonColor));
      print(this.secondaryButtonColor.value.toString());
    }


    if(this.mounted){
      setState(() {});
    }
  }

  getSizeList() async {
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

    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        GetSizeListModel getSizeListModel=GetSizeListModel.fromJson(json.decode(response.body));
        size_List=getSizeListModel.getSizeList!;
        size_title=getSizeListModel.title!;
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
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');
    if(baseUrl!=null && userId!=null && adminId!=null && apptypeid!=null){
      if(this.mounted){
        this.admin_auto_id=adminId;
        this.baseUrl=baseUrl;
        this.user_id=userId;
        this.app_type_id=apptypeid;
        getFormUi();
        getMainBrand();
        getSizeList();
        getColorListApi();
        getUnitListApi();
        getCurrency();
        getManufacturerListApi();
        getFirmnessList();
        getMaterialList();
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

  showAlert() async {
    showDialog(
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
                                backgroundColor: Colors.green[200],
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
                                backgroundColor: Colors.blue[200],
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

    getappUi();
    getBaseUrl();
    getImage_List();
  }

  @override
  Widget build(BuildContext context) {
    tabController = TabController(vsync: this, length: product_info_model_List.length,initialIndex: selectedIndex);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text("Upload Product",
            style: TextStyle(
                color: appBarIconColor,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: ()=>{showAlert()},
          icon: Icon(Icons.arrow_back, color: appBarIconColor),
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
                if(this.mounted)
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
            if(this.mounted)
          setState(() {})
          },
        icon: Icon(Icons.settings,color: appBarIconColor,)),],

        bottom: TabBar(
          indicatorWeight: 3,
          controller: tabController,
          isScrollable: true,
          indicatorColor: const Color.fromRGBO(0, 202, 157, 1),
          labelColor: Colors.black,
          labelStyle: const TextStyle(fontSize: 12),
          unselectedLabelColor: Colors.black,
          tabs: List<Widget>.generate(product_info_model_List.length,
                  (int index) {
                      return Tab(icon: IconButton(
                        onPressed: ()=>{removeTabView(index)}, icon: Icon(Icons.close,size: 15,color: Colors.black,),),
                        text: "Product:" + (index + 1).toString(),iconMargin: const EdgeInsets.all(0),);
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

  removeTabView(int index){
    product_info_model_List.removeAt(index);

    if(this.mounted)
      setState(() {});

   if(product_info_model_List.isEmpty && product_info_model_List.length=='0')
     {
       Navigator.pop(context);
     }
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
                    print('Page changed: $value');
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
    return isedit==false && product_info_model_List[i].isnew_arrival=='no'?Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("New Arrival",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                product_info_model_List[i].isnew_arrival=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isnew_arrival='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isnew_arrival='no',
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
    return isedit==false && product_info_model_List[i].isbrand=='no'?Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Brand Name",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                product_info_model_List[i].isbrand=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isbrand='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isbrand='no',
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
    return isedit==false && product_info_model_List[i].iscolor=='no'?Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Color",
              style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
              product_info_model_List[i].iscolor=='no'?
              IconButton(
                padding: EdgeInsets.all(0),
                onPressed: ()=>{
                  product_info_model_List[i].iscolor='yes',
                setState(() {})
                },
                icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                alignment: Alignment.topRight,
              ):IconButton(
                padding: EdgeInsets.all(0),
                onPressed: ()=>{
                  product_info_model_List[i].iscolor='no',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Product Unit",
                style: TextStyle(color: Colors.black, fontSize: 16)),
            ],),
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
    return isedit==false && product_info_model_List[i].isgross_wt=='no'?Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Product Gross Weight",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                product_info_model_List[i].isgross_wt=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isgross_wt='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isgross_wt='no',
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
                keyboardType: TextInputType.text,
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
    return isedit==false && product_info_model_List[i].isnet_wt=='no'?Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Product Net Weight",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                product_info_model_List[i].isnet_wt=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isnet_wt='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isnet_wt='no',
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
                  keyboardType: TextInputType.text,
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
    return isedit==false && product_info_model_List[i].isquantity=='no'?Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                  "Pack of (Ex. Pack of 2, Pack of 5, etc)",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?
              Row(children: [
                product_info_model_List[i].isquantity=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isquantity='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isquantity='no',
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
                  initialValue: product_info_model_List[i].productQuantity,
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
          Text("Product Price",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          SizedBox(
            height: 8,
          ),
          product_info_model_List[i].productPriceList.isNotEmpty?
          Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: priceListWidget(i),
              )
          ) :
          Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            alignment: Alignment.center,
            child:GestureDetector(
              onTap: ()=>{showAddPrice(i)},
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

  List<Widget> priceListWidget(int i){
    List<Widget> pricelistUi=[];


    print(product_info_model_List[i].productPriceList.length);
    print(getCurrencyList.length);

    if(product_info_model_List[i].productPriceList.length < getCurrencyList.length){
      pricelistUi.add(
          GestureDetector(
            onTap: ()=>{showAddPrice(i)},
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
              )// child: Text('+',style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
            ),
          )
      );
    }


    for(int index=0;index<product_info_model_List[i].productPriceList.length;index++){
      pricelistUi.add(
          Stack(
            children: <Widget>[
              Container(
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
                        child:
                        Container(
                            alignment: Alignment.center,
                            child:Icon(Icons.flag,size: 20,),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.grey[400],
                            )),
                      ),
                    ),
                    Text(product_info_model_List[i].productPriceList[index].currencyList.countryName,
                      style: const TextStyle(color: Colors.black54,fontSize: 14),textAlign: TextAlign.center,maxLines: 2,),
                    Text(product_info_model_List[i].productPriceList[index].currencyList.currency+
                        product_info_model_List[i].productPriceList[index].productPrice,
                        style: const TextStyle(color: Colors.black54,fontSize: 14),textAlign: TextAlign.center),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                width: 100,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    removePrice(i, index)
                  },
                  icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                  alignment: Alignment.topRight,
                ),
              ),
            ],
          )
      );
    }

    return pricelistUi;
  }

  removePrice(int i, int index) {
    product_info_model_List[i].productPriceList.removeAt(index);

    if(this.mounted){
      setState(() {});
    }
  }

  returPolicy(int i){
    return isedit==false && product_info_model_List[i].isreturn_exchange=='no'?Container():Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Return/Exchange",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                product_info_model_List[i].isreturn_exchange=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isreturn_exchange='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isreturn_exchange='no',
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
                                      product_info_model_List[i].isReturn='Yes';
                                    }
                                    else{
                                      product_info_model_List[i].isReturn='No';
                                    }
                                  });
                                }
                              },
                              value: product_info_model_List[i].isReturn=='Yes'?true:false,
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
                                      product_info_model_List[i].isExchange='Yes';
                                    }
                                    else{
                                      product_info_model_List[i].isExchange='No';
                                    }
                                  });
                                }
                              },
                              value: product_info_model_List[i].isExchange=='Yes'?true:false,
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
                  initialValue: product_info_model_List[i].days,
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
                  onChanged: (value)=>{
                    product_info_model_List[i].days=value,
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

  removeOffer(int i){
    product_info_model_List[i].selectedOffer.clear();
    
    if(mounted){
      setState(() {});
    }
  }
  
  showSelectOffer(int i){
    Route routes = MaterialPageRoute(builder: (context) => SelectOffers(onSaveOfferCallback,i));
    Navigator.push(context, routes);
  }

  onSaveOfferCallback(int i,Offers selectedOffer){
    Navigator.of(context).pop();

    product_info_model_List[i].selectedOffer.add(selectedOffer);

    selectedIndex=i;

    if(mounted){
      setState(() {});
    }
  }

  moqUi(int i){
    return isedit==false && product_info_model_List[i].ismoq=='no'?Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Minimun Order Quantity(MOQ)",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                product_info_model_List[i].ismoq=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].ismoq='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].ismoq='no',
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

  manufacturerUi(int i){
    return isedit==false && product_info_model_List[i].ismanufacturers=='no'?Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Product Manufacturer",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                product_info_model_List[i].ismanufacturers=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].ismanufacturers='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].ismanufacturers='no',
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
                value: product_info_model_List[i].manufacturer,
                onChanged: (value) {
                  setState(() {
                    product_info_model_List[i].manufacturer = value as String;
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

  firmnessUi(int i){
    return isedit==false && product_info_model_List[i].isfirmness=='no'?Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Product Firmness",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                product_info_model_List[i].isfirmness=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isfirmness='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isfirmness='no',
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
                value: product_info_model_List[i].firmness,
                onChanged: (value) {
                  setState(() {
                     product_info_model_List[i].firmness = value as String;
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

  materialUi(int i){
    return isedit==false && product_info_model_List[i].ismaterial=='no'?Container():Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Product Material",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                product_info_model_List[i].ismaterial=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].ismaterial='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].ismaterial='no',
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
                value: product_info_model_List[i].material,
                onChanged: (value) {
                  setState(() {
                    product_info_model_List[i].material = value as String;
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

  productBarcodeUi(int i){
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
                        product_info_model_List[i].productSku,
                      )
                    ),
                    Expanded(
                      flex:1,
                      child: IconButton(
                        icon: Icon(Icons.document_scanner),
                        onPressed: ()=>{
                          openScanner(i)
                        },
                      ),
                    )
                  ],
                )),
            ),
            Divider(color: Colors.grey.shade300),

          ],
        ),
      );
  }

  openScanner(int i) async{
    print('abc');
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE);

    if(barcodeScanRes!=null){
      if(this.mounted){
        setState(() {
          product_info_model_List[i].productSku = barcodeScanRes;
        });
      }
    }

    print('barcode: '+barcodeScanRes);
  }

  productSizeUi(int i){

    if(size_List.isNotEmpty && size_title.isNotEmpty ){
      return isedit==false && product_info_model_List[i].issize=='no'?Container():
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Text(size_title,
            //     style: TextStyle(
            //         fontSize: 16, color: Colors.black)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(size_title,
                  style: TextStyle(color: Colors.black, fontSize: 16)),

                isedit==true?Row(children: [
                  product_info_model_List[i].issize=='no'?
                  IconButton(
                    padding: EdgeInsets.all(0),
                    onPressed: ()=>{
                      product_info_model_List[i].issize='yes',
                      setState(() {})
                    },
                    icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                    alignment: Alignment.topRight,
                  ):IconButton(
                    padding: EdgeInsets.all(0),
                    onPressed: ()=>{
                      product_info_model_List[i].issize='no',
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
    else{
      return Container();
    }
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
                   // Text("₹"+product_info_model_List[i].selectedSizePrice[index].toString(),style: const TextStyle(color: Colors.black54,fontSize: 12),),
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
    return isedit==false && product_info_model_List[i].ishighlights=='no'?Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Product Highlight",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                product_info_model_List[i].ishighlights=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].ishighlights='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].ishighlights='no',
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

  dimensionUi(int i){
    return isedit==false && product_info_model_List[i].isdimension=='no'?Container():Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Dimension",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                product_info_model_List[i].isdimension=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isdimension='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isdimension='no',
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
            Expanded(child: TextFormField(
              initialValue: product_info_model_List[i].height,
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
                product_info_model_List[i].height=value,
                selectedIndex=tabController.index,
                setState(() {})
              },
            )),
            const SizedBox(
              width: 5,
            ),
            Expanded(child:TextFormField(
              initialValue: product_info_model_List[i].width,
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
                product_info_model_List[i].width=value,
                 selectedIndex=tabController.index,
                 setState(() {})
              },
            )),
            const SizedBox(
              width: 5,
            ),
            Expanded(child:TextFormField(
              initialValue: product_info_model_List[i].depth,
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
                product_info_model_List[i].depth=value,
                selectedIndex=tabController.index,
                setState(() {})
              },
            )),],),

          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  ThicknessUi(int i){
    return isedit==false && product_info_model_List[i].isthickness=='no'?Container():Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Product Thickness",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                product_info_model_List[i].isthickness=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isthickness='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isthickness='no',
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
            initialValue: product_info_model_List[i].thickness,
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
              product_info_model_List[i].thickness=value,
              selectedIndex=tabController.index,
              setState(() {})
            },
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  inventoryUi(int i)
  {
    return
      Container(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Inventory",
                style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold)),

              // isedit==true?Row(children: [
              //   product_info_model_List[i].isinventory=='no'?
              //   IconButton(
              //     padding: EdgeInsets.all(0),
              //     onPressed: ()=>{
              //       product_info_model_List[i].isinventory='yes',
              //       setState(() {})
              //     },
              //     icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
              //     alignment: Alignment.topRight,
              //   ):IconButton(
              //     padding: EdgeInsets.all(0),
              //     onPressed: ()=>{
              //       product_info_model_List[i].isinventory='no',
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
          unitUi(i),
          StockUi(i),
          // AvailableStockUi(i),
          StockAlertLimitUi(i),
          productBarcodeUi(i),
        ]
    )
    );
  }

  StockUi(int i){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Add Product Stock",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            initialValue: product_info_model_List[i].stock,
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
              product_info_model_List[i].stock=value,
              product_info_model_List[i].available_stock=value,
              selectedIndex=tabController.index,
              setState(() {})
            },
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  // AvailableStockUi(int i){
  //   return isedit==false && product_info_model_List[i].isinventory=='no'?Container():
  //   Container(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         const Text("Product Available Stock",
  //             style: TextStyle(color: Colors.black, fontSize: 16)),
  //         const SizedBox(
  //           height: 8,
  //         ),
  //         TextFormField(
  //           initialValue: product_info_model_List[i].available_stock,
  //           decoration: InputDecoration(
  //               filled: true,
  //               hintText: "Enter available stock",
  //               fillColor: Colors.white,
  //               contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
  //               focusedBorder: OutlineInputBorder(
  //                 borderSide:
  //                 const BorderSide(color: Colors.blue, width: 1),
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               enabledBorder: OutlineInputBorder(
  //                 borderSide:
  //                 const BorderSide(color: Colors.grey, width: 1),
  //                 borderRadius: BorderRadius.circular(10),
  //               )),
  //           textInputAction: TextInputAction.newline,
  //           keyboardType: TextInputType.number,
  //           maxLines: null,
  //           onChanged: (value)=>{
  //             // product_info_model_List[i].available_stock=value,
  //             // selectedIndex=tabController.index,
  //             // setState(() {})
  //           },
  //         ),
  //         Divider(color: Colors.grey.shade300),
  //       ],
  //     ),
  //   );
  // }

  StockAlertLimitUi(int i){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Product Stock Alert Limit",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            initialValue: product_info_model_List[i].stock_alert_limit,
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
              product_info_model_List[i].stock_alert_limit=value,
              selectedIndex=tabController.index,
              setState(() {})
            },
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  TrailPeriodUi(int i){
    return isedit==false && product_info_model_List[i].istrial_period=='no'?Container():Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Product Trial Period",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                product_info_model_List[i].istrial_period=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].istrial_period='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].istrial_period='no',
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
            initialValue: product_info_model_List[i].trial_period,
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
              product_info_model_List[i].trial_period=value,
              selectedIndex=tabController.index,
              setState(() {})
            },
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  expiryUi(int i){
    return isedit==false && product_info_model_List[i].isuse_by=='no'?Container():Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Expiry Date",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                product_info_model_List[i].isuse_by=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isuse_by='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isuse_by='no',
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
            initialValue: product_info_model_List[i].useBy,
            decoration: InputDecoration(
                filled: true,
                hintText: "Enter expiry date",
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
              product_info_model_List[i].useBy=value,
              selectedIndex=tabController.index,
              setState(() {})
            },
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  deliveryByUi(int i){
    return isedit==false && product_info_model_List[i].isexpected_delivery=='no'?Container():
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Expected Delivery",
                style: TextStyle(color: Colors.black, fontSize: 16)),

              isedit==true?Row(children: [
                product_info_model_List[i].isexpected_delivery=='no'?
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isexpected_delivery='yes',
                    setState(() {})
                  },
                  icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                  alignment: Alignment.topRight,
                ):IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    product_info_model_List[i].isexpected_delivery='no',
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
                          Text("Time (Ex. 10/20 etc.)",
                              style: TextStyle(color: Colors.black, fontSize: 15)),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            initialValue: product_info_model_List[i].deliveryByTime,
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
                            keyboardType: TextInputType.number,
                            onChanged: (value) => product_info_model_List[i].deliveryByTime = value,
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
                              style: TextStyle(color: Colors.black, fontSize: 15)),
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
                                value: product_info_model_List[i].deliveryByUnit,
                                onChanged: (value) {
                                  setState(() {
                                    product_info_model_List[i].deliveryByUnit = value as String;
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

  specificationUi(int i){
    return isedit==false && product_info_model_List[i].isspecification=='no'?Container():
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
                    onPressed: ()=>{showAddSpecification(i)},
                  ),
                )),
              isedit==true?
                  Container(
                    width: 50,
                    margin: EdgeInsets.only(left: 80,right: 0),
                    alignment: Alignment.centerRight,
                    child: Row(children: [
                    product_info_model_List[i].isspecification=='no'?
                    IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: ()=>{
                        product_info_model_List[i].isspecification='yes',
                        setState(() {})
                      },
                      icon: Icon(Icons.add_circle_outline,size: 25,color: Colors.green,),
                      alignment: Alignment.topRight,
                    ):IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: ()=>{
                        product_info_model_List[i].isspecification='no',
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
              children:showSpecificationData(i),
            ),
          ),

          Divider(color: Colors.orange),
        ],
      ),
    );
  }

  showSpecificationData(int i){
    List<TableRow> specificationList=[];

    for(int index=0;index<product_info_model_List[i].specificationList.length;index++){
      specificationList.add(
        TableRow(children: [
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(product_info_model_List[i].specificationList[index].title,
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
                child: Text(product_info_model_List[i].specificationList[index].value,
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
                    removeSpecification(i,index)
                  },
                  child: Icon(Icons.close_rounded,color: Colors.redAccent,),
                ),
              ),
            )
          ])
        ]),
      );
    }
    return specificationList;
  }

  removeSpecification(int i, int index) {
    product_info_model_List[i].specificationList.removeAt(index);

    if(this.mounted){
      setState(() {});
    }
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
                  grossWeightUi(i),
                  netWeightUi(i),
                  quantityUi(i),
                  highlightUi(i),
                  manufacturerUi(i),
                  materialUi(i),
                  firmnessUi(i),

                  dimensionUi(i),
                  ThicknessUi(i),
                  TrailPeriodUi(i),
                  // StockUi(i),
                  // AvailableStockUi(i),
                  // StockAlertLimitUi(i),
                  specificationUi(i),
                  expiryUi(i),
                  // includingTaxUi(i),
                  //taxPerUi(i),
                  //offerPriceUi(i),

                  returPolicy(i),
                  deliveryByUi(i),

                  priceUi(i),

                  inventoryUi(i),

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
                            backgroundColor: primaryButtonColor,
                              textStyle: TextStyle(fontSize: 20)),
                          onPressed: () {
                            if(validations(i)==true){
                              add_product(i);
                            }
                          },
                          child: Center(
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
    else if (product_info_model_List[i].colorName.isEmpty) {
      Fluttertoast.showToast(msg: "Please add color name", backgroundColor: Colors.grey,);
      return false;
    }
    else if (product_info_model_List[i].productPriceList.isEmpty) {
      Fluttertoast.showToast(msg: "Please add product price", backgroundColor: Colors.grey,);
      return false;
    }
    return true;
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
        for(int i=0;i<product_info_model_List.length;i++)
          {
            product_info_model_List[i].issize=getFormuilist[0].size;
            product_info_model_List[i].iscolor=getFormuilist[0].color;
            product_info_model_List[i].ishighlights=getFormuilist[0].highlights;
            product_info_model_List[i].isspecification=getFormuilist[0].specification;
            product_info_model_List[i].isbrand=getFormuilist[0].brand;
            product_info_model_List[i].isnew_arrival=getFormuilist[0].newArrival;
            product_info_model_List[i].ismoq=getFormuilist[0].moq;
            product_info_model_List[i].isgross_wt=getFormuilist[0].grossWt;
            product_info_model_List[i].isnet_wt=getFormuilist[0].netWt;
            product_info_model_List[i].isunit=getFormuilist[0].unit;
            product_info_model_List[i].isquantity=getFormuilist[0].quantity;
            product_info_model_List[i].isuse_by=getFormuilist[0].useBy;
            product_info_model_List[i].isexpected_delivery=getFormuilist[0].expectedDelivery;
            product_info_model_List[i].isreturn_exchange=getFormuilist[0].returnExchange;
            product_info_model_List[i].isdimension=getFormuilist[0].dimension;
            product_info_model_List[i].ismanufacturers=getFormuilist[0].manufacturers;
            product_info_model_List[i].ismaterial=getFormuilist[0].material;
            product_info_model_List[i].isfirmness=getFormuilist[0].firmness;
            product_info_model_List[i].isthickness=getFormuilist[0].thickness;
            product_info_model_List[i].istrial_period=getFormuilist[0].trialPeriod;
            product_info_model_List[i].isinventory=getFormuilist[0].inventory;
          }
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  AddFormUi() async {
    var url=baseUrl+'api/'+add_product_formui;

    var uri = Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
      "size":product_info_model_List[0].issize,
      "color":product_info_model_List[0].iscolor,
      "highlights":product_info_model_List[0].ishighlights,
      "specification":product_info_model_List[0].isspecification,
      "brand":product_info_model_List[0].isbrand,
      "new_arrival":product_info_model_List[0].isnew_arrival,
      "moq":product_info_model_List[0].ismoq,
      "gross_wt":product_info_model_List[0].isgross_wt,
      "net_wt":product_info_model_List[0].isnet_wt,
      "unit":product_info_model_List[0].isunit,
      "quantity":product_info_model_List[0].isquantity,
      "use_by":product_info_model_List[0].isuse_by,
      "expected_delivery":product_info_model_List[0].isexpected_delivery,
      "return_exchange":product_info_model_List[0].isreturn_exchange,
      "dimension":product_info_model_List[0].isdimension,
      "manufacturers":product_info_model_List[0].ismanufacturers,
      "material":product_info_model_List[0].ismaterial,
      "firmness":product_info_model_List[0].isfirmness,
      "thickness":product_info_model_List[0].isthickness,
      "trial_period":product_info_model_List[0].istrial_period,
      "inventory":product_info_model_List[0].isinventory
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
      "size":product_info_model_List[0].issize,
      "color":product_info_model_List[0].iscolor,
      "highlights":product_info_model_List[0].ishighlights,
      "specification":product_info_model_List[0].isspecification,
      "brand":product_info_model_List[0].isbrand,
      "new_arrival":product_info_model_List[0].isnew_arrival,
      "moq":product_info_model_List[0].ismoq,
      "gross_wt":product_info_model_List[0].isgross_wt,
      "net_wt":product_info_model_List[0].isnet_wt,
      "unit":product_info_model_List[0].isunit,
      "quantity":product_info_model_List[0].isquantity,
      "use_by":product_info_model_List[0].isuse_by,
      "expected_delivery":product_info_model_List[0].isexpected_delivery,
      "return_exchange":product_info_model_List[0].isreturn_exchange,
      "dimension":product_info_model_List[0].isdimension,
      "manufacturers":product_info_model_List[0].ismanufacturers,
      "material":product_info_model_List[0].ismaterial,
      "firmness":product_info_model_List[0].isfirmness,
      "thickness":product_info_model_List[0].isthickness,
      "trial_period":product_info_model_List[0].istrial_period,
      "inventory":product_info_model_List[0].isinventory
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

  getColorListApi() async {
    var url = baseUrl+'api/' + get_color_list;

    Uri uri=Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
    };
    final response = await http.post(uri, body: body);

    print(response.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        ColorListModel colorListModel=ColorListModel.fromJson(json.decode(response.body));
        List<GetColorList> getcolor=colorListModel.getColorList;

        for (var element in getcolor) {
          colorList.add(element.colorName);
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
     // print("material status=>"+status.toString());
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

  getUnitListApi() async {
    var url = baseUrl+'api/' + get_product_unit;

    Uri uri=Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
    };
    final response = await http.post(uri, body: body);

    print(response.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        ProductUnitModel productUnitModel=ProductUnitModel.fromJson(json.decode(response.body));
        List<GetUnitList> getunit=productUnitModel.getUnitList;

        for (var element in getunit) {
          Unit_list.add(element.unit);
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

  void getImage_List() {
    for (var file in widget.imageFileList) {
      List<File> selectedImg = [File(file.path)];
      product_info_model_List.add(Product_Info_Model(selectedImg));
    }
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
        //  return SelectSize(onSelectSizelistener,i,size_List,product_info_model_List[i].selectedSize);
          return SelectSize(onSelectSizelistener,i,size_List,product_info_model_List[i].selectedSize);
        });
  }

  void onSelectSizelistener(List<GetSizeList> size, int i){
    Navigator.pop(context);

    product_info_model_List[i].selectedSize=size;
  //  product_info_model_List[i].selectedSize.add(size);

   // product_info_model_List[i].selectedSizePrice.add(price);

   /* if(price.isNotEmpty){
      product_info_model_List[i].price=price;
    }*/

    selectedIndex=i;

    setState(() {});
  }

  showAddSpecification(int i) async {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return AddSpecification(onAddSpecificationListener,i);
        });
  }

  onAddSpecificationListener(String title,String value,int i){
    Specification specification=Specification(title, value);
    product_info_model_List[i].specificationList.add(specification);

    if(this.mounted){
      setState(() {});
    }
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
                    const Text('You can add more for this product from edit product screen',style: TextStyle(color: Colors.black54),),
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
                        SizedBox(width: 10,),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  removeSize(int i, int index) {
    if(mounted){
      setState(() {
        product_info_model_List[i].selectedSize.removeAt(index);
      //  product_info_model_List[i].selectedSizePrice.removeAt(index);
      });
    }

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

        print(getCurrencyList.toString());

        if(this.mounted){
          setState(() {});
        }
      }
    }
  }

  showAddPrice(int i){

    if(getCurrencyList.isEmpty)
      {
        showAlertCurrency();
      }
    else {
      List<String> selectedCurrecnyId=[];
      product_info_model_List[i].productPriceList.forEach((element) {
        selectedCurrecnyId.add(element.currencyList.id);
      });

      Route routes = MaterialPageRoute(builder: (context) => AddPrice(
        product_model_auto_id: '',
        i:i,
        onSaveCallback: AddPriceListener,
        selectedSize: product_info_model_List[i].selectedSize,
        selectedCurrencyId: selectedCurrecnyId,
        getCurrencyList: getCurrencyList,
      )
      );

      Navigator.push(context, routes);
    }

  }

  void AddPriceListener(int i,List<ProductPrice> productPriceList) {
    print('in add');


    productPriceList.forEach((element) {
      product_info_model_List[i].productPriceList.add(element);
    });

   /* if(product_info_model_List[i].productPriceList.isEmpty){
      product_info_model_List[i].productPriceList=productPriceList;
    }
    else{
      for(int j=0;j<product_info_model_List[i].productPriceList.length;j++){
        for(int k=0;k<productPriceList.length;k++){
          if(product_info_model_List[i].productPriceList[j].currencyList.id== productPriceList[k].currencyList.id){
            product_info_model_List[i].productPriceList[j]=productPriceList[k];
          }
          else{
            product_info_model_List[i].productPriceList.add(productPriceList[k]);
          }
        }
      }
    }
*/

    if(this.mounted){
      setState(() {
      });
    }
  }

  void AddSizeListener(int i) {
    Navigator.of(context).pop;
  }

  void add_product(int i)async {

    showprogressDialog();

    Product_Info_Model productInfoModel = product_info_model_List[i];

    for(int i=0;i<getBrandslist.length;i++){
      if(productInfoModel.brandName==getBrandslist[i].brandName){
        productInfoModel.brand_auto_id=getBrandslist[i].id;
      }
    }

    String selectedSize = "";
    for (int index = 0; index < productInfoModel.selectedSize.length; index++) {
      if(index==0){
        selectedSize += productInfoModel.selectedSize[index].id;
      }
      else {
        selectedSize += '|' + productInfoModel.selectedSize[index].id;
      }
    }

    String specification_title = "",specification_value="";
    for (int index = 0; index < productInfoModel.specificationList.length; index++) {
      if(index==0){
        specification_title += productInfoModel.specificationList[index].title;
        specification_value += productInfoModel.specificationList[index].value;
      }
      else {
        specification_title += '|' + productInfoModel.specificationList[index].title;
        specification_value += '|' + productInfoModel.specificationList[index].value;
      }
    }

    //print(selectedSize);

    setState(() {
      isApiCallProcessing=true;
    });

    var url = baseUrl +'api/'+add_new_product_admin;

    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);

    request.fields["color_image"] = '';

    request.fields["user_auto_id"] = user_id;
    request.fields["main_category_auto_id"] = widget.main_cat_id;
    request.fields["sub_category_auto_id"] = widget.sub_cat_id;
    request.fields["product_name"] = productInfoModel.productName;
    request.fields["product_dimensions"] = productInfoModel.productDimensions;
    request.fields["added_by"]='Admin';
    request.fields["brand_auto_id"] = productInfoModel.brand_auto_id;
    request.fields["color_name"] = productInfoModel.colorName;
    request.fields["new_arrival"] = productInfoModel.new_arrival;
    request.fields["unit"] = productInfoModel.productUnit;
    request.fields["gross_wt"] = productInfoModel.grossWeight;
    request.fields["net_wt"] = productInfoModel.netWeight;
    request.fields["moq"] = productInfoModel.minimumOrderQuantity;
    request.fields["quantity"] = productInfoModel.productQuantity;
    request.fields["weight"] = productInfoModel.productWeight;
    request.fields["specification_title"] = specification_title;
    request.fields["specification_description"] = specification_value;
    request.fields["description"] = productInfoModel.productDescription;
    request.fields["size"] = selectedSize;
    request.fields["isReturn"] = productInfoModel.isReturn;
    request.fields["isExchange"] = productInfoModel.isExchange;
    request.fields["days"] = productInfoModel.days;
    request.fields["time"] = productInfoModel.deliveryByTime;
    request.fields["time_unit"] =productInfoModel.deliveryByUnit;
    request.fields["use_by"] = productInfoModel.useBy;
    request.fields["closure_type"] = "";
    request.fields["fabric"] = "";
    request.fields["sole"] = "";
    request.fields["admin_auto_id"] = admin_auto_id;
    request.fields["app_type_id"] =app_type_id;
    request.fields["height"]=productInfoModel.height;
    request.fields["Width"]=productInfoModel.width;
    request.fields["depth"]=productInfoModel.depth;
    request.fields["Manufacturers"]=productInfoModel.manufacturer;
    request.fields["Material"]=productInfoModel.material;
    request.fields["Firmness"]=productInfoModel.firmness;
    request.fields["Thickness"]=productInfoModel.thickness;
    request.fields["Trial_Period"]=productInfoModel.trial_period;
    request.fields["stock"]=productInfoModel.stock;
    request.fields["available_stock"]=productInfoModel.stock;
    request.fields["Stock_alert_limit"]=productInfoModel.stock_alert_limit;
    request.fields["product_sku"]=productInfoModel.productSku;

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
        addProductPrice(productInfoModel.productPriceList, productAutoId, i);

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
      request.fields["admin_auto_id"] = admin_auto_id;
      request.fields["app_type_id"] =app_type_id;

      http.Response response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        final resp=jsonDecode(response.body);
        String status=resp['status'];
        if(status=='1'){

          if(index==images.length-1){
            isApiCallProcessing=false;
            product_info_model_List.removeAt(i);
            Navigator.pop(context);
            productAddedAlert();
          }
        }
        else{
          Fluttertoast.showToast(msg: "Something went wrong.Please try later", backgroundColor: Colors.grey,);
        }

        if(mounted){
          setState(() {
          });
        }
      }
      else{
        Fluttertoast.showToast(msg: 'Server erorr:'+ response.statusCode.toString());
        Navigator.pop(context);
      }
    }

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
                                routes = MaterialPageRoute(builder: (context) => const Add_Currency());
                                Navigator.push(context, routes).then(onGoBack);

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
  FutureOr onGoBack(dynamic value) {
    getCurrency();
  }
  Future addProductPrice(List<ProductPrice> productPriceList,String productAutoId,int i) async{
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    for(int index=0;index<productPriceList.length;index++){
      Rest_Apis restApis = Rest_Apis();

      restApis.addProductPrice(productPriceList[index], productAutoId, user_id, admin_auto_id, baseUrl,app_type_id).then((value) {
        if (value != null) {
          var status = value;
        }
      });
    }

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
                      Text('Please wait. Your product is being uploaded. This might take some time',style: TextStyle(color: Colors.black),),
                      SizedBox(height: 10,),
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                      Container(
                          child: ElevatedButton(
                            onPressed: (){
                              // if(product_info_model_List.isEmpty){
                              //   Navigator.pop(context);
                              //   Navigator.pop(context);
                              // }
                              // else{
                              Navigator.pop(context);
                              // }
                            },
                            child: const Text("Cancel",style: TextStyle(color: Colors.black54,fontSize: 13)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[200],
                              minimumSize: const Size(70,30),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(2.0)),
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                )

              ]
          )      ),
    ) ;
  }
}

class ProductSize {
  String size;
  String size_id;
  String price;

  ProductSize(this.size, this.size_id, this.price);
}
