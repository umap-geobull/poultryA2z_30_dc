import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:poultry_a2z/Vendor_Module/Vendor_add_Product/Components/Model/select_color_bottomsheet.dart';
import 'package:poultry_a2z/Vendor_Module/Vendor_add_Product/Components/Model/select_size_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:http/http.dart' as http;

import '../../../../Utils/App_Apis.dart';
import 'Get_SizeList_Model.dart';
import 'add_color_response_model.dart';


typedef OnSaveCallback = void Function(int i,List<GetSizeList> selectedSize,
    List<String> selectedSizePrice,List<File> productImages,
    String colorname,String productPrice,String offerPer);

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

  String user_id = "",app_type_id='';

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? apptypeid= prefs.getString('app_type_id');
    if(baseUrl!=null && apptypeid!=null){
      this.baseUrl=baseUrl;
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
        // backgroundColor: kPrimaryColor,
        title: const Text("Add Colors",
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

  void add_product_color(int i,List<GetSizeList> selectedSize,List<String> selectedSizePrice,List<File> productImages,
      String colorname,String productPrice,String offerPrice)async {

    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    String selectedSize = "";
    String selectedSizePrice = "";
    for (int index = 0; index < selectedSize.length; index++) {
      if(index==0){
        selectedSize += selectedSize[index];
        selectedSizePrice += selectedSizePrice[index].toString();
      }
      else {
        selectedSize += '|' + selectedSize[index];
        selectedSizePrice += '|' + selectedSizePrice[index].toString();
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

    var url = baseUrl +'api/add_vendor_Product_color';

    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);

    request.fields["color_image"] = '';
    request.fields["product_model_auto_id"] = product_model_auto_id;
    request.fields["color_name"] = colorname;
    request.fields["size"] = selectedSize;
    request.fields["size_price"] = selectedSizePrice;
    request.fields["user_auto_id"] = user_id;
    request.fields["product_price"] = price;
    request.fields["offer_percentage"] = offer;
    request.fields["including_tax"] = widget.includingTax;
    request.fields["tax_percentage"] = widget.taxPercentage;

    // final response = await request.send();
    print("data=>"+product_model_auto_id+" "+colorname+" "+selectedSize+" "+selectedSizePrice+" "+user_id+" "+price+" "+offer+" "+widget.includingTax+" "+widget.taxPercentage);
    http.Response response = await http.Response.fromStream(await request.send());

    String status;
    String msg='';

    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      status = resp['status'];
      print("status=>"+status.toString());
      if(status=="1"){
        AddColorResponse addColorResponse=AddColorResponse.fromJson(json.decode(response.body));
        String productAutoId=addColorResponse.data.id;

        addProductImages(productImages, productAutoId, i);
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
  String baseUrl='';
  List<File> productImages=[];
  String colorName='Select Color Name';
  List<File> colorImage=[];
  List<GetSizeList> sizeList=[];
  List<String> sizePrice=[];
  List<GetSizeList> get_size_List=[];


  TextEditingController priceController=TextEditingController();
  TextEditingController offerController=TextEditingController();

  List<String> colorList=[
    'Select Color Name','Black','White','Red','Yellow','Blue','Pink','Orange','Green'
  ];

  _ColorTabState(this.product_model_auto_id, this.imageFile);

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if(baseUrl!=null){
      this.baseUrl=baseUrl;
      setState(() {
        getSizeListApi();
      });
    }
  }

  getSizeListApi() async {
    var url = baseUrl+'api/' + "get_size_list";

    Uri uri=Uri.parse(url);

    final response = await http.get(uri);
    print(response.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        GetSizeListModel getSizeListModel=GetSizeListModel.fromJson(json.decode(response.body));
        get_size_List=getSizeListModel.getSizeList;
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
                  //productColorUi(),
                  //productSizeUi(),
                  addSize(),
                  priceUi(),
                  offerUi(),
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
                Text(sizePrice[index])
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

  priceUi(){
    return Container(
      margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
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
        ],
      ),
    );
  }

  offerUi(){
    return Container(
      margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Offer%",
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
                    hintText: "Enter the offer%",
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

  bool validations(){
    if(productImages.isEmpty){
      Fluttertoast.showToast(
        msg: "Please select product image",
      );
      return false;
    }
   /* else if(colorImage.isEmpty){
      Fluttertoast.showToast(
        msg: "Please select color image",
      );
      return false;
    }*/
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
            widget.onSaveCallback(widget.index,sizeList,sizePrice,productImages,colorName,priceController.text,
            offerController.text);
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
          return SelectSize(onSelectSizelistener,0,get_size_List);
        });
  }

  void onSelectSizelistener(GetSizeList size,String price,int i){
    Navigator.pop(context);
    sizeList.add(size);
    sizePrice.add(price);

    if(sizePrice[0].isNotEmpty){
      priceController.text=sizePrice[0];
    }
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
    sizePrice.removeAt(index);

        if(mounted){
          setState(() {

          });
        }
  }
}

