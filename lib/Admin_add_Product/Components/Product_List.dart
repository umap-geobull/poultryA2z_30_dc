import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:poultry_a2z/Admin_add_Product/Components/Edit_Product_List_Ui.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/MainCategoryProductList_Model.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Product_Card_Admin.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Recommended_Products/Recommended_ListModel.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/home_product_model.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/offer_product_model.dart';
import 'package:poultry_a2z/Home/Components/component_constants.dart';
import 'package:poultry_a2z/Product_Details/Filters/filter_bottomsheet.dart';
import 'package:poultry_a2z/Product_Details/model/Filtered_Products_model.dart';
import 'package:poultry_a2z/Product_Details/product_details_screen.dart';
import 'package:poultry_a2z/settings/Select_Filter/Components/filter_menu_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/Brand_Product_List_Model.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/SubCat_Product_List_Model.dart';
import 'package:image_picker/image_picker.dart';
import '../../Product_Details/model/Product_Model.dart';
import '../../Utils/App_Apis.dart';
import 'Add_Product_Screen.dart';
import 'Model/Rest_Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'Update_ProductNew.dart';

class Product_List extends StatefulWidget {
  Product_List(
      {Key? key,
        required this.type,
        required this.main_cat_id,
        required this.sub_cat_id,
        required this.brand_id,
        required this.home_componet_id,
        required this.offer_id
      })
      : super(key: key);
  String type;
  String main_cat_id;
  String sub_cat_id;
  String brand_id;
  String home_componet_id;
  String offer_id;

  @override
  _Product_ListState createState() => _Product_ListState();
}

class _Product_ListState extends State<Product_List> {
  List<ProductModel> productList = [];
  late Route routes;
  bool isApiCallProcessing=false;
  bool isDeleteProcessing=false;

  String baseUrl='',user_id='', admin_auto_id='',app_type_id='';
  List<String> categories = [];
  bool isfilter=false;
  //filter
  String colors='', size='', moq='',  brand='',  min_price='', max_price='', sort_by='',manufacturer='',
      material='',min_thickness='',max_thickness='',firmness='',max_height='', min_height='',min_width='',max_width='',min_depth='',max_depth='',min_discount='',max_discount='',stock='',min_trial_priod='',max_trial_period='';

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
    }

    if(secondaryButtonColor!=null){
      this.secondaryButtonColor=Color(int.parse(secondaryButtonColor));
    }

    if(this.mounted){
      setState(() {});
    }
  }

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');

    String? userType =prefs.getString('user_type');

    if(baseUrl!=null && userId!=null && adminId!=null && apptypeid!=null){
      if(this.mounted){
        this.admin_auto_id=adminId;
        this.baseUrl=baseUrl;
        this.user_id=userId;
        this.app_type_id=apptypeid;

        getData();
        getFilterList();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getappUi();
    getBaseUrl();
  }

  getFilterList() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    var url = baseUrl+'api/' + get_filter_menu;

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
        FilterMenuModel filterMenuModel=FilterMenuModel.fromJson(json.decode(response.body));
        filterMenuModel.allfiltermenus.forEach((element) {
          categories.add(element.filterMenuName);
        });
      }
      else {
      }
      if(mounted){
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            backgroundColor: appBarColor,
            title: Text("Products List",
                style: TextStyle(
                    color: appBarIconColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            leading: IconButton(
              onPressed: ()=>{
                Navigator.of(context).pop()
              },
              icon: Icon(Icons.arrow_back, color: appBarIconColor),
            ),
            actions: [
              IconButton(
                  onPressed: ()=>{
                    showFilter()
                  },
                  icon: Icon(Icons.filter_alt_outlined,color: appBarIconColor,)),

              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Product_List_Ui()));
                },
                icon: Icon(Icons.edit, color:appBarIconColor),
              ),

              widget.type != "brand" ?
              IconButton(
                onPressed: () {
                  fetch_images();
                },
                icon: Icon(Icons.add_circle_outline, color: appBarIconColor),
              ):
              Container(),
            ]
        ),
        body:Stack(
          children: <Widget>[
            //isfilter==false?
            Container(
                height: MediaQuery.of(context).size.height,
               // padding: const EdgeInsets.only(bottom: 50),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: productList.length,
                    itemBuilder: (context, index) =>
                        ProductCardAdmin(
                            baseUrl:baseUrl,
                            user_id: "",
                            product: productList[index],
                            onDeleteCallback: showAlert,
                            editCallback: showEditPage,
                            showDetailsCallback: showProductDetails)

/*
                        ProductCardAdmin(
                            baseUrl:baseUrl,
                            user_id: "",
                            productModel: productList[index],
                            onDeleteCallback: showAlert,
                            onGoBackCallback: getData)
*/
                )
            ),
            //     : Container(
            //     height: MediaQuery.of(context).size.height,
            //     // padding: const EdgeInsets.only(bottom: 50),
            //     child: ListView.builder(
            //         scrollDirection: Axis.vertical,
            //         itemCount: productListfilter.length,
            //         itemBuilder: (context, index) =>
            //             ProductCardFilterAdmin(baseUrl:baseUrl,user_id: "",productModel: productListfilter[index],
            //               onDeleteCallback: Delete_Product,onGoBackCallback: getData,)
            //     )
            // ),
            isApiCallProcessing==false && productList.isEmpty?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: const Text('No products available')
            ):
            Container(),

            // isApiCallProcessing==false && isfilter==true &&productListfilter.isEmpty?
            // Container(
            //     alignment: Alignment.center,
            //     width: MediaQuery.of(context).size.width,
            //     child: const Text('No products available')
            // ):
            // Container(),

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

  Future<void> fetch_images() async {
    ImagePicker imagePicker = ImagePicker();
    List<File>? imageFileList = [];
    var selectedImages = await imagePicker.pickMultiImage();

    if(selectedImages!=null){
      for (var file in selectedImages) {
        File selectedImg = File(file.path);
        imageFileList.add(selectedImg);
      }

      routes = MaterialPageRoute(builder: (context) => Add_Product_Screen(
          imageFileList: imageFileList,
          main_cat_id: widget.main_cat_id,
          sub_cat_id: widget.sub_cat_id)
      );

      Navigator.push(context, routes).then(onGoBack);
    }
    setState(() {});
  }

  void Delete_Product(String productId) {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.Delete_Product(productId, admin_auto_id,baseUrl,app_type_id).then((value) {
      if (value != null) {
        isApiCallProcessing=false;
        int status = value;
        if (status == 1) {

          Fluttertoast.showToast(
            msg: "Product Deleted successfully",
            backgroundColor: Colors.grey,
          );

          getData();

        }
        else {
          Fluttertoast.showToast(
            msg: "Something went wrong",
            backgroundColor: Colors.grey,
          );
        }

        if(mounted){
          setState(() {
          });
        }
      }
    });
  }

  showFilter() {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return FilterBottomsheet(onApplyFilterListener,onClearFilterListener,categories,
              colors, size, moq,  brand,  min_price, max_price, sort_by,manufacturer,
              material,min_thickness,max_thickness,firmness,min_height,max_height,min_width,max_width,min_depth,max_depth,min_discount,max_discount,stock,min_trial_priod,max_trial_period);
        });
  }

  onApplyFilterListener(String colors,String size,String moq,
      String brand, String min_price,String max_price,String sort_by,String manufacturer,String material,
      String firmness,String min_thickness,String max_thickness,String min_height,String max_height,String min_width,String max_width,String min_depth,
      String max_depth,String min_discount,String max_discount,String stock,String min_trial_priod,String max_trial_period){

    this.colors=colors;
    this.size=size;
    this.moq=moq;
    this.brand=brand;
    this.min_price=min_price;
    this.max_price=max_price;
    this.sort_by=sort_by;
    this.manufacturer=manufacturer;
    this.material=material;
    this.min_thickness=min_thickness;
    this.max_thickness=max_thickness;
    this.firmness=firmness;
    this.min_height=min_height;
    this.max_height=max_height;
    this.min_width=min_width;
    this.max_width=max_width;
    this.min_depth=min_depth;
    this.max_depth=max_depth;
    this.min_discount=min_discount;
    this.max_discount=max_discount;
    this.stock=stock;
    this.min_trial_priod=min_trial_priod;
    this.max_trial_period=max_trial_period;

    if(this.mounted){
      setState(() {
      });
    }

    getFilter_Product();
  }

  getFilter_Product() async {
    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }
    final body = {
      "min_price": min_price,
      "max_price": max_price,
      "brand_id": brand,
      "moq": moq,
      "color_name": colors,
      "size_id": size,
      "main_category_id": widget.main_cat_id,
      "sub_category_id": widget.sub_cat_id,
      "admin_auto_id":admin_auto_id,
      "customer_auto_id": user_id,
      "app_type_id": app_type_id,
      "manufacturer_name":manufacturer,
      "material_name":material,
      "firmness_type":firmness,
      "min_thickness":min_thickness,
      "max_thickness":max_thickness,
      "min_height":min_height,
      "max_height":max_height,
      "min_width":min_width,
      "max_width":max_width,
      "min_depth":min_depth,
      "max_depth":max_depth,
      "min_discount":min_discount,
      "max_discount":max_discount,
      "out_of_stock":stock,
      "min_trial_period":min_trial_priod,
      "max_trial_period":max_trial_period,
    };

    // //print(body.toString());

    var url = baseUrl + 'api/' + get_filter_products;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);

      print(resp.toString());
      int status = resp['status'];

      productList.clear();

      if (status == 1) {
        FilteredProducts_Model filteredProductsModel = FilteredProducts_Model.fromJson(json.decode(response.body));
        productList = filteredProductsModel.getAdminOfferProductLists!;
        isfilter=true;
      }
      else {
        productList=[];
      }
      if (this.mounted) {
        setState(() {
          isApiCallProcessing = false;
        });
      }
    }
    else if (response.statusCode == 500) {
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
    }
  }

  onClearFilterListener(){
    this.colors='';
    this.size='';
    this.moq='';
    this.brand='';
    this.min_price='';
    this.max_price='';
    this.sort_by='';
    this.manufacturer='';
    this.material='';
    this.min_thickness='';
    this.max_thickness='';
    this.firmness='';
    this.min_height='';
    this.max_height='';
    this.min_width='';
    this.max_width='';
    this.min_depth='';
    this.max_depth='';
    this.min_discount='';
    this.max_discount='';
    this.stock='';
    this.min_trial_priod='';
    this.max_trial_period='';
    isfilter=false;
    if(this.mounted){
      setState(() {
      });
    }

    getData();
  }

  getData() {
    widget.type == "brand" || widget.type == "Brand" ?
    getBrand_Product() :
    widget.type == "category" ?
    getMainCat_Product() :
    widget.type == "recommended" ?
    getRecommended_Product() :
    widget.type == "home_products" ?
    gethomeProducts() :
    widget.type == "offer" ?
    getOfferProducts() :
    getSubCat_Product();
  }

  showAddPage(String producyId){
    routes = MaterialPageRoute(builder: (context) => Update_Product(product_id: producyId,));
    Navigator.push(context, routes).then(onGoBack);
  }

  getMainCat_Product() async {
    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }
    final body = {
      "admin_auto_id":admin_auto_id,
      "main_cat_id": widget.main_cat_id,
      "app_type_id":app_type_id,
      "customer_auto_id": user_id,
    };

    var url = baseUrl + 'api/' + get_Admin_MainCategory_Product;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      int status = resp['status'];
      productList.clear();
      if (status == 1) {
        MainCategoryProductsModel mainCategoryProductsModel =
        MainCategoryProductsModel.fromJson(json.decode(response.body));
        productList = mainCategoryProductsModel.getAdminCategoryProductLists;

      }
      else {
        productList=[];
      }

      if (mounted) {
        setState(() {
          isApiCallProcessing = false;
        });
      }
    }
    else if (response.statusCode == 500) {
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
    }
  }

  getSubCat_Product() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "sub_cat_id": widget.sub_cat_id,
      "customer_auto_id": user_id,
      "admin_auto_id":admin_auto_id,
      "app_type_id":app_type_id,
    };
//print(body.toString());
    var url = baseUrl+'api/' + get_Admin_Subcategory_Product;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      productList.clear();
      if (status == 1) {
        SubCategoryProductModel subCategoryProductModel=SubCategoryProductModel.fromJson(json.decode(response.body));
        productList=subCategoryProductModel.getAdminSubcategoryProductLists;
      }
      else {
        productList=[];
      }
      if(mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
    }else
      {
        productList=[];
        if(mounted){
          setState(() {
            isApiCallProcessing=false;
          });
        }
      }
  }

  getBrand_Product() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "brand_id": widget.brand_id,
      "admin_auto_id":admin_auto_id,
      "customer_auto_id": user_id,
      "app_type_id":app_type_id,
    };

    var url = baseUrl+'api/' + get_Admin_Brand_Product;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing = false;

      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      productList.clear();
      if (status == 1) {
        BrandProductModel brandProductModel=BrandProductModel.fromJson(json.decode(response.body));
        productList=brandProductModel.getAdminBrandProductLists;
      }
      else {
        productList=[];
      }

      if(mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
    }

  }

  getRecommended_Product() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "customer_auto_id": user_id,
      "app_type_id": app_type_id,
      "admin_auto_id":admin_auto_id,
    };

    var url = baseUrl+'api/' + get_recommended_products;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      print(resp.toString());
      int  status = resp['status'];
      if (status == 1) {
        Recommended_ListModel recommendedListModel=Recommended_ListModel.fromJson(json.decode(response.body));
        productList=recommendedListModel.getRecommendedProductsLists;
      }
      else {
        productList=[];
      }

      if(this.mounted){
        setState(() {
          isApiCallProcessing = false;
        });
      }
    }
    else if (response.statusCode == 500) {
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
    }
  }

  gethomeProducts() async {

    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "component_auto_id":widget.home_componet_id,
      "component_type":PRODUCTS,
      "customer_auto_id":user_id,
      "app_type_id": app_type_id,
      "admin_auto_id":admin_auto_id,
    };

    var url=baseUrl+'api/'+get_home_component_details;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        HomeComponentProductDetails homeComponentProductDetails=HomeComponentProductDetails.fromJson(json.decode(response.body));
        GetHomeComponentList homeComponent=homeComponentProductDetails.getHomeComponentList[0];
        productList=homeComponent.content;
      }else {
        productList=[];
      }

      if(mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }

    }
    else if (response.statusCode == 500) {
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
    }

  }

  getOfferProducts() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "offer_auto_id": widget.offer_id,
      "user_auto_id": user_id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };
    var url = baseUrl+'api/' + get_offer_products;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      int status = resp['status'];
      productList.clear();
      if (status == 1) {
        OfferProductModel offerProductModel=OfferProductModel.fromJson(json.decode(response.body));
        productList=offerProductModel.getAdminOfferProductLists;

      } else {
        productList=[];
      }

      if (mounted) {
        setState(() {
          isApiCallProcessing = false;
        });
      }
    }
    else if (response.statusCode == 500) {
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
    }

  }

  FutureOr onGoBack(dynamic value) {
    getData();
  }



  showEditPage(String productId){
    routes = MaterialPageRoute(builder: (context) => Update_Product(product_id: productId,));
    Navigator.push(context, routes).then(onGoBack);
  }

  showProductDetails(String productId){
    routes = MaterialPageRoute(builder: (context) => ProductDetailScreen(productId));
    Navigator.push(context, routes).then(onGoBack);
  }

  Future<bool> showAlert(String productId) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: const Text(
            'Are you sure?',
            style: TextStyle(color: Colors.black87),
          ),
          content: Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Do you want delete this product',
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
                                //widget.onDeleteCallback(productId);
                                Delete_Product(productId);
                              },
                              child: const Text("Yes",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green[200],
                                onPrimary: Colors.green,
                                //minimumSize: Size(70, 30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("No",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue[200],
                                onPrimary: Colors.blue,
                                // minimumSize: Size(70, 30),
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

}
