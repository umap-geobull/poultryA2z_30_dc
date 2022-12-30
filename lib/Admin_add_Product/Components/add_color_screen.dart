import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/add_color_response_model.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/add_price_screen.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/select_color_bottomsheet.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/select_size_bottomsheet.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/settings/AddCurrency/Component/currency_list_model.dart';
import 'package:image_picker/image_picker.dart';
import '../../Utils/App_Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:http/http.dart' as http;
import 'package:poultry_a2z/Admin_add_Product/Components/Model/Rest_Apis.dart';
import '../../settings/Add_Color/Components/Color_List_Model.dart';
import '../../settings/Add_Size/Components/Get_SizeList_Model.dart';
import 'package:cached_network_image/cached_network_image.dart';


typedef OnSaveCallback = void Function(int i,List<GetSizeList> selectedSize,List<File> productImages,
    String colorname,String productPrice,String offerPer,List<ProductPrice> productPriceList);

class ColorInfoModel{
  File image;
  List<File> productImages=[];
  String colorName='';
  List<String> size=[];
  List<int> size_price=[];

  ColorInfoModel(this.image);
}

class AddColors extends StatefulWidget {
  AddColors(
      {Key? key,
        required this.product_model_auto_id,
        required this.product_price,
        required this.imageFileList,
        required this.offer_price,
        required this.includingTax,
        required this.taxPercentage
       })
      : super(key: key);
  String product_model_auto_id;
  String product_price;
  String offer_price;
  List<File> imageFileList;
  String includingTax;
  String taxPercentage;

  @override
  _AddColorsState createState() => _AddColorsState(product_model_auto_id,imageFileList);
}

class _AddColorsState extends State<AddColors> with TickerProviderStateMixin {
  String product_model_auto_id;
  List<File> imageFileList;

  List<GetSizeList> get_size_List = [];

  _AddColorsState(this.product_model_auto_id, this.imageFileList);

  String baseUrl='';
  late TabController tabController;
  int selectedIndex = 0;

  bool isApiCallProcessing=false;

  String user_id='',admin_auto_id='',app_type_id='';

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? adminId =prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');

    if(baseUrl!=null && adminId!=null && apptypeid!=null){
      this.baseUrl=baseUrl;
      this.admin_auto_id=adminId;
      this.app_type_id=apptypeid;
      setState(() {
      });
    }
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    tabController = TabController(vsync: this, length: imageFileList.length,initialIndex: selectedIndex);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Add Colors",
            style: TextStyle(
                color: appBarIconColor,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: ()=>{showAlert()},
          icon: const Icon(Icons.arrow_back, color: appBarIconColor),
        ),
        bottom: TabBar(
          indicatorWeight: 3,
          controller: tabController,
          isScrollable: true,
          indicatorColor: const Color.fromRGBO(0, 202, 157, 1),
          labelColor: Colors.black,
          labelStyle: const TextStyle(fontSize: 14),
          unselectedLabelColor: Colors.black,
          tabs: List<Widget>.generate(imageFileList.length,
                  (int index) {
                return Tab(text: "Color:" + (index + 1).toString());
              }),
        ),

      ),

      body: TabBarView(
        controller: tabController,
        children: getTabView(),
      ),
    );
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
                                primary: Colors.green[200],
                                onPrimary: Colors.green,
                                //minimumSize: Size(70,30),
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
                               // minimumSize: Size(70,30),
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

  Future<void> fetch_images() async {
    ImagePicker imagePicker = ImagePicker();
    var selectedImages = await imagePicker.pickMultiImage();

    if(selectedImages!=null){
      for (var file in selectedImages) {
        File selectedImg = File(file.path);
        imageFileList.add(selectedImg);
      }
    }
    setState(() {});
  }

  getTabView(){
    List<Widget> tabs=[];

    for(int index=0;index<imageFileList.length;index++){
      tabs.add(Stack(
        children: <Widget>[
          ColorTab(product_model_auto_id: product_model_auto_id,
            imageFile: imageFileList[index],
            onSaveCallback: add_product_color,
            index: index,
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
      ));
    }
    return tabs;
  }

  void add_product_color(int i,List<GetSizeList> selectedSize,List<File> productImages,
      String colorname,String productPrice,String offerPrice,List<ProductPrice> productPriceList)async {

    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    String selectedSize = "";
    for (int index = 0; index < selectedSize.length; index++) {
      if(index==0){
        selectedSize += selectedSize[index];
      }
      else {
        selectedSize += '|' + selectedSize[index];
      }
    }

    //price
    String price=widget.product_price;

    if(productPrice.isNotEmpty){
      price=productPrice;
    }

    String offer=widget.offer_price;

    if(offerPrice.isNotEmpty){
      offer=offerPrice;
    }

    if(offer.isEmpty){
      offer='0';
    }

    var url = baseUrl +'api/add_admin_Product_color';

    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);

    request.fields["color_image"] = '';
    request.fields["product_model_auto_id"] = product_model_auto_id;
    request.fields["color_name"] = colorname;
    request.fields["size"] = selectedSize;
    request.fields["user_auto_id"] = user_id;
    request.fields["admin_auto_id"] = admin_auto_id;

    // final response = await request.send();

    http.Response response = await http.Response.fromStream(await request.send());

    String status;
    String msg='';

    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      status = resp['status'];
      if(status=="1"){
        AddColorResponse addColorResponse=AddColorResponse.fromJson(json.decode(response.body));
        String productAutoId=addColorResponse.data.id;

        addProductImages(productImages, productAutoId, i);
        addProductPrice(productPriceList, productAutoId, i);
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

  Future addProductPrice(List<ProductPrice> productPriceList,String productAutoId,int i) async{
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    for(int index=0;index<productPriceList.length;index++){
      Rest_Apis restApis = Rest_Apis();

      restApis.addProductPrice(productPriceList[index], productAutoId, user_id,admin_auto_id, baseUrl,app_type_id).then((value) {
        if (value != null) {
          var status = value;
        }
      });
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
            Fluttertoast.showToast(msg: "Product color added successfully", backgroundColor: Colors.grey,);

            isApiCallProcessing=false;

            imageFileList.removeAt(i);

            if(imageFileList.isEmpty){
              Navigator.of(context).pop();
            }
          }
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

class ColorTab extends StatefulWidget {
  ColorTab(
      {Key? key,
        required this.product_model_auto_id,
        required this.imageFile,
        required this.onSaveCallback,
        required this.index,

})
      : super(key: key);
  String product_model_auto_id;
  File imageFile;
  OnSaveCallback onSaveCallback;
  int index;

  @override
  _ColorTabState createState() => _ColorTabState(product_model_auto_id,imageFile);
}

class _ColorTabState extends State<ColorTab> {
  String product_model_auto_id;
  File imageFile;
  String baseUrl='', admin_auto_id='';
  List<File> productImages=[];
  String colorName='Select Color Name';
  List<File> colorImage=[];
  List<GetSizeList> sizeList=[];
 // List<String> sizePrice=[];
  List<GetSizeList> get_size_List=[];
  List<ProductPrice> productPriceList=[];

  TextEditingController priceController=TextEditingController();
  TextEditingController offerController=TextEditingController();

  List<GetCurrencyList> getCurrencyList=[];

  List<String> colorList=[
    'Select Color Name'
  ];

  _ColorTabState(this.product_model_auto_id, this.imageFile);

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? adminId =prefs.getString('admin_auto_id');

    if(baseUrl!=null && adminId!=null){
      this.baseUrl=baseUrl;
      this.admin_auto_id=adminId;
      setState(() {
        getSizeListApi();
        getColorListApi();
        getCurrency();
      });
    }
  }

  getSizeListApi() async {
    var url = baseUrl+'api/' + get_size_list;

    Uri uri=Uri.parse(url);

    final body={
      "admin_auto_id": admin_auto_id,
    };
    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      if (status == 1) {
        GetSizeListModel getSizeListModel=GetSizeListModel.fromJson(json.decode(response.body));
        get_size_List=getSizeListModel.getSizeList!;
      }
      else {
        get_size_List = [];
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
      "admin_auto_id": admin_auto_id,
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
        print('empty');
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();

    productImages.add(imageFile);

    priceController.text='';
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                      child: Text("Product Images",
                          style: TextStyle(
                              fontSize: 16, color: Colors.black)),
                      padding: EdgeInsets.all(10)),
                  productImageUi(),
                  Divider(color: Colors.grey.shade300),
                  colorUi(),
                  addSize(),
                  priceUi(),
                  saveButtonUi()
                ],
              )
          )
      );
      },

    );
  }

  List<Widget> sliderItems(){
    List<Widget> items=[];

    for(int index=0;index<productImages.length;index++){
      items.add(
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: ClipRRect(
                child: productImages[index]!=null?
                Image.file(productImages[index],
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

  productImageUi(){
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 400,
      child:Stack(
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
            children: sliderItems(),

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
                  fetch_images()
                },
                icon: const Icon(Icons.library_add_rounded,color: Colors.white,),
              ),
            ),
          )
        ],
      ),
    );
  }

  colorUi(){
    return Container(
        margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Product Color",
                style: TextStyle(color: Colors.black, fontSize: 16)),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: DropdownButtonHideUnderline(
                child: GFDropdown(
                  padding: const EdgeInsets.all(15),
                  borderRadius: BorderRadius.circular(5),
                  border: const BorderSide(
                      color: Colors.black12, width: 1),
                  dropdownButtonColor: Colors.white,
                  value: colorName,
                  onChanged: (newValue) {
                    setState(() {
                      colorName = newValue as String;
                    });
                  },
                  items: colorList.map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
    );
  }

  List<Widget> getSizeList(){
    List<Widget> sizeListWidget=[];

    sizeListWidget.add(
        GestureDetector(
          onTap: ()=>{
            showSelectSize()
          },
          child:
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 28,left: 10,right: 10),
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


    for(int index=0;index<sizeList.length;index++){

      sizeListWidget.add(
          Container(
            alignment: Alignment.center,
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(2),
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
                      child: Text(sizeList[index].size),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.topRight,
                      child:InkWell(
                          onTap: ()=>{removeSize(index)},
                          child:const Icon(Icons.close)),
                    ),
                  ],
                ),
              ],
            ),
          )
      );
    }


    return sizeListWidget;
  }

  addSize(){
    return Container(
      margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
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

  bool validations(){
    if(productImages.isEmpty){
      Fluttertoast.showToast(
        msg: "Please select product image",
      );
      return false;
    }
    else if(colorName.isEmpty || colorName=='Select Color Name'){
      Fluttertoast.showToast(
        msg: "Please select color name",
      );
      return false;
    }

    return true;
  }

  saveButtonUi(){
    return Container(
      margin: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          if(validations()==true){
            widget.onSaveCallback(widget.index,sizeList,productImages,colorName,priceController.text,
            offerController.text,productPriceList);
          }
        },
        child: const Text("SAVE",
            style: TextStyle(
                color: Colors.black54, fontSize: 13)),
        style: ElevatedButton.styleFrom(
          primary: Colors.orange[200],
          onPrimary: Colors.orange,
          //minimumSize: Size(100, 40),
          shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(2.0)),
          ),
        ),
      ),
    );

  }

  showSelectColor() async {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SelectColor(onSelectColorlistener,0,colorName,colorImage);
        });
  }

  void onSelectColorlistener(int i,String colorName, List<File> colorImage){
    Navigator.pop(context);

    this.colorName=colorName;
    colorImage=colorImage;
    setState(() {});
  }

  showSelectSize() async {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SelectSize(onSelectSizelistener,0,get_size_List,sizeList);
        });
  }

  void onSelectSizelistener(List<GetSizeList> size,int i){
    Navigator.pop(context);

    sizeList=size;
   // sizeList.add(size);
    //sizePrice.add(price);

   /* if(sizePrice[0].isNotEmpty){
      priceController.text=sizePrice[0];
    }*/


    setState(() {});
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
                               // minimumSize: Size(70,30),
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
                               // minimumSize: Size(70,30),
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

  Future<void> fetch_images() async {
    ImagePicker imagePicker = ImagePicker();
    var selectedImages = await imagePicker.pickMultiImage();

    if(selectedImages!=null){
      for (var file in selectedImages) {
        File selectedImg = File(file.path);
        productImages.add(selectedImg);
      }
    }
    setState(() {});
  }

  removeSize(int index) {
    sizeList.removeAt(index);
        if(mounted){
          setState(() {

          });
        }
  }

  priceUi(){
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Product Price",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          SizedBox(
            height: 8,
          ),
          productPriceList.isNotEmpty?
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
            child: Icon(Icons.add,color: Colors.blue,),
            // child: Text('+',style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
          ),
        )
    );

    for(int index=0;index<productPriceList.length;index++){
      pricelistUi.add(
          Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.topRight,
                width: 100,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: ()=>{
                    removePrice(index)
                  },
                  icon: Icon(Icons.close_rounded,size: 25,color: Colors.redAccent,),
                  alignment: Alignment.topRight,
                ),
              ),
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
                        child: productPriceList[index].currencyList.flagImage.isNotEmpty?
                        CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: baseUrl+brands_base_url+
                              productPriceList[index].currencyList.flagImage,
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
                    Text(productPriceList[index].currencyList.countryName,
                      style: const TextStyle(color: Colors.black54,fontSize: 14),textAlign: TextAlign.center,maxLines: 2,),
                    Text(productPriceList[index].currencyList.currency+
                        productPriceList[index].productPrice,
                        style: const TextStyle(color: Colors.black54,fontSize: 14),textAlign: TextAlign.center),
                  ],
                ),
              )
            ],
          )
      );
    }

    return pricelistUi;
  }

  removePrice(int index) {
    productPriceList.removeAt(index);

    if(this.mounted){
      setState(() {});
    }
  }

  showAddPrice(){
    List<String> selectedCurrecnyId=[];
    productPriceList.forEach((element) {
      selectedCurrecnyId.add(element.currencyList.id);
    });

    Route routes = MaterialPageRoute(builder: (context) => AddPrice(
      product_model_auto_id: '',
      i:0,
      onSaveCallback: AddPriceListener,
      selectedSize: sizeList,
      selectedCurrencyId: selectedCurrecnyId,
      getCurrencyList: getCurrencyList,
    )
    );

    Navigator.push(context, routes);
  }

  void getCurrency() async {
    var url=baseUrl+'api/'+get_currecy_list;
    var uri = Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
    };
    final response = await http.post(uri,body: body);
    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        CurrencyListModel currencyListModel=CurrencyListModel.fromJson(json.decode(response.body));
        getCurrencyList=currencyListModel.getCurrencyList;

        if(this.mounted){
          setState(() {});
        }
      }
      else{
        getCurrencyList = [];
      }
    }
  }

  FutureOr onGoBackFromCurrency(dynamic value) {
    getCurrency();
  }

  void AddPriceListener(int i,List<ProductPrice> productPriceList) {
    productPriceList.forEach((element) {
      this.productPriceList.add(element);
    });

    if(this.mounted){
      setState(() {
      });
    }
  }

}

