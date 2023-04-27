import 'dart:async';
import 'dart:convert';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/size_model.dart';
import 'package:poultry_a2z/AppUi/app_ui_model.dart';
import 'package:poultry_a2z/BuyNow/buy_now_screen.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/offer_product_model.dart';
import 'package:poultry_a2z/Product_Details/Filters/filter_bottomsheet.dart';
import 'package:poultry_a2z/Product_Details/Product_UI/Product_Card1.dart';
import 'package:poultry_a2z/Product_Details/Product_UI/Product_Card2.dart';
import 'package:poultry_a2z/Product_Details/Product_UI/Product_Card3.dart';
import 'package:poultry_a2z/Product_Details/Product_UI/Product_Card4.dart';
import 'package:poultry_a2z/Product_Details/Product_UI/Product_Card5.dart';
import 'package:poultry_a2z/Product_Details/model/Filtered_Products_model.dart';
import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';
import 'package:poultry_a2z/Product_Details/product_details_screen.dart';
import 'package:poultry_a2z/Product_Details/select_prod_size_bottomsheet.dart';
import 'package:poultry_a2z/settings/Select_Filter/Components/filter_menu_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/Brand_Product_List_Model.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/SubCat_Product_List_Model.dart';
import '../Admin_add_Product/Components/Model/MainCategoryProductList_Model.dart';
import '../Cart/Cart_Screen.dart';
import '../Cart/model/cart_count_model.dart';
import '../Home/Components/AddNewComponent/Recommended_Products/Recommended_ListModel.dart';
import '../Home/Components/AddNewComponent/models/home_product_model.dart';
import '../Home/Components/component_constants.dart';
import '../Utils/App_Apis.dart';
import '../Admin_add_Product/Components/Model/Rest_Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';

// import 'package:badges/badges.dart';

import '../Wishlist/model/wishlist_count_model.dart';

class Product_List_User extends StatefulWidget {
  Product_List_User(
      {Key? key,
      required this.type,
      required this.main_cat_id,
      required this.sub_cat_id,
      required this.brand_id,
      required this.home_componet_id,
      required this.offer_id})
      : super(key: key);
  String type;
  String main_cat_id;
  String sub_cat_id;
  String brand_id;
  String home_componet_id;
  String offer_id;

  @override
  _Product_List_User createState() => _Product_List_User();
}

class _Product_List_User extends State<Product_List_User> {
  List<ProductModel> productList = [];

  String price='',offer_per='',final_price='';
  bool isServerError=false;
  late Route routes;

  bool isApiCallProcessing = false;
  bool isDeleteProcessing = false;

  String cartCount = '0';

  String baseUrl='',admin_auto_id='';
  String user_id = '',app_type_id='';

  List<String> categories = [];

  List<GetAdminWishlistProductLists> wishlistProduct = [];

  String icon_type='1';

  //filter
  String colors='', size='', moq='',  brand='',  min_price='', max_price='', sort_by='',stock='',min_trial_priod='',max_trial_period='';

  String manufacturer='',
      material='',min_thickness='',max_thickness='',firmness='',max_height='', min_height='',min_width='',max_width='',min_depth='',max_depth='',min_discount='',max_discount='';

  Color appBarColor=Colors.white,appBarIconColor=Colors.black,
      primaryButtonColor=Colors.orange, secondaryButtonColor=Colors.orangeAccent;

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

  getAppUiDetails() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.getAppUi(admin_auto_id, baseUrl).then((value) {
      if (value != null) {
        if(mounted){
          setState(() {
            isApiCallProcessing=false;
          });
        }

        AppUiModel appUiModel=value;

        if(appUiModel!=null && appUiModel.status==1 ){
          icon_type=appUiModel.allAppUiStyle![0].productLayoutType;
          if(icon_type=='')
          {
            icon_type='1';
            setState(() {

            });
          }
          if(this.mounted){
            setState(() {
            });
          }
        }
      }else{
        icon_type='1';
        if(mounted){
          setState(() {
            isApiCallProcessing=false;
          });
        }
      }
    });
  }

  getFilterList() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body={
      "admin_auto_id":admin_auto_id,
    };
    var url = baseUrl+'api/' + get_filter_menu;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri,body: body);
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

  getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');
    if(baseUrl!=null && adminId!=null && userId != null && apptypeid!=null){
      if(this.mounted){
        setState(() {
          this.admin_auto_id=adminId;
          this.baseUrl = baseUrl;
          this.user_id = userId;
          this.app_type_id=apptypeid;
          getAppUiDetails();
          getData();
          getFilterList();

        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text("",
              style: TextStyle(
                  color: appBarIconColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: () => {Navigator.of(context).pop()},
            icon: Icon(Icons.arrow_back, color: appBarIconColor),
          ),
          actions: [
            IconButton(
                onPressed: ()=>{
                  showFilter()
                },
                icon: Icon(Icons.filter_alt_outlined,color: appBarIconColor,)),

            //_shoppingCartBadge(),
          ]),
      body: Stack(
        children: <Widget>[

          isApiCallProcessing == false &&
              productList.isEmpty? Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: const Text('No products available'))
              : Container(),

          icon_type=='1'?
          Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(bottom: 50),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1 / 1.6),
                  itemCount: productList.length,
                  itemBuilder: (context, index) =>
                      ProductCard1(
                        baseUrl: baseUrl,
                        user_id: user_id,
                        product: productList[index],
                        onAddToCartCallback: showSeleceCartSize,
                        onAddToWishlistCallback: addToWishlist,
                        onRemoveWishlistCallback:removeFromWishlist,
                        onBuyNowCallback: showBuyNowSize,
                        showDetailsCallback: showProductDetails,
                        primaryButtonColor: primaryButtonColor,
                        secondaryButtonColor: secondaryButtonColor,
                      )
              )
          ):
          icon_type=='2'?
          Container(
              width:MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(bottom: 50,left: 5,right: 5),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: productList.length,
                  itemBuilder: (context, index) =>
                      Product_Card2(
                        baseUrl: baseUrl,
                        user_id: user_id,
                        product: productList[index],
                        onAddToCartCallback: showSeleceCartSize,
                        onAddToWishlistCallback: addToWishlist,
                        onRemoveWishlistCallback:removeFromWishlist,
                        showDetailsCallback: showProductDetails,
                        primaryButtonColor: primaryButtonColor,
                        secondaryButtonColor: secondaryButtonColor,
                      )
              )
          ):
          icon_type=='3'?
          Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(bottom: 50),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1 /2),
                  itemCount: productList.length,
                  itemBuilder: (context, index) =>
                      ProductCard3(
                        baseUrl: baseUrl,
                        user_id: user_id,
                        product: productList[index],
                        onAddToCartCallback: showSeleceCartSize,
                        onAddToWishlistCallback: addToWishlist,
                        onRemoveWishlistCallback:removeFromWishlist,
                        showDetailsCallback: showProductDetails,
                        primaryButtonColor: primaryButtonColor,
                        secondaryButtonColor: secondaryButtonColor,
                      )
              )
          ):
          icon_type=='4'?
          Container(
            width:MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(bottom: 50,left: 5,right: 5),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: productList.length,
                  itemBuilder: (context, index) =>
                      ProductCard4(
                        baseUrl: baseUrl,
                        user_id: user_id,
                        product: productList[index],
                        onAddToCartCallback: showSeleceCartSize,
                        onAddToWishlistCallback: addToWishlist,
                        onRemoveWishlistCallback:removeFromWishlist,
                        showDetailsCallback: showProductDetails,
                        primaryButtonColor: primaryButtonColor,
                        secondaryButtonColor: secondaryButtonColor,
                      )
              )
          ):
          icon_type=='5'?
          Container(
              width:MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(bottom: 50,left: 5,right: 5),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: productList.length,
                  itemBuilder: (context, index) =>
                      ProductCard5(
                        baseUrl: baseUrl,
                        user_id: user_id,
                        product: productList[index],
                        onAddToCartCallback: showSeleceCartSize,
                        onAddToWishlistCallback: addToWishlist,
                        onRemoveWishlistCallback:removeFromWishlist,
                        showDetailsCallback: showProductDetails,
                        primaryButtonColor: primaryButtonColor,
                        secondaryButtonColor: secondaryButtonColor,
                      )
              )
          ):
          Container(),

          isServerError==true?
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/server_error.png'),
                ),
                const Text('Server Error.. Please try later')
              ],
            ),
          ):
          Container(),

          isApiCallProcessing == true
              ? Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: const GFLoader(type: GFLoaderType.circle),
          )
              : Container()
        ],
      ),
     // bottomSheet: filter_Section(context),

    );
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
    if(this.mounted){
      setState(() {
      });
    }

    getData();
  }

  // Widget _shoppingCartBadge() {
  //   return Badge(
  //     badgeColor: Colors.orangeAccent,
  //     position: BadgePosition.topEnd(top: 0, end: 3),
  //     animationDuration: const Duration(milliseconds: 300),
  //     animationType: BadgeAnimationType.slide,
  //     badgeContent: Text(
  //       cartCount.toString(),
  //       style: const TextStyle(color: Colors.white),
  //     ),
  //     child: IconButton(
  //         icon: Icon(Icons.shopping_cart, color: appBarIconColor),
  //         onPressed: () {
  //           gotoCartScreen();
  //         }),
  //   );
  // }

  gotoCartScreen() {
    routes = MaterialPageRoute(builder: (context) => const Cart_Screen());
    Navigator.push(context, routes).then(onGoBackFromCart);
  }

  FutureOr onGoBackFromCart(dynamic value) {
    getCartProdList();
  }

  totalRatingUi(int avgRating, int totalNoOfReviews) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: 60,
      height: 15,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            avgRating.toString(),
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 10,
            ),
          ),
          const Icon(
            Icons.star,
            color: Colors.orangeAccent,
            size: 10,
          ),
          Text(
            '| ' + totalNoOfReviews.toString(),
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
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

  FutureOr onGoBack(dynamic value) {
    getData;
    getCartProdList();
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

        if(user_id.isNotEmpty){
          getWishlistProdList();
          getCartProdList();
        }
      }
      if(mounted){
        setState(() {
          isApiCallProcessing=false;
          isServerError=false;
        });
      }

    }
    else if (response.statusCode == 500) {
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
          isServerError=true;
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
    };

    var url = baseUrl+'api/' + get_recommended_products;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      if (status == 1) {
        Recommended_ListModel recommendedListModel=Recommended_ListModel.fromJson(json.decode(response.body));
        productList=recommendedListModel.getRecommendedProductsLists;

        if(user_id.isNotEmpty){
          getWishlistProdList();
          getCartProdList();
        }
      }
      else {
      }

      if(this.mounted){
        setState(() {
          isApiCallProcessing = false;
          isServerError=false;
        });
      }
    }
    else if (response.statusCode == 500) {
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
          isServerError=true;
        });
      }
    }
  }

  getSubCat_Product() async {
    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }
    final body = {
      "sub_cat_id": widget.sub_cat_id,
      "customer_auto_id": user_id,
      "admin_auto_id":admin_auto_id,
      "app_type_id":app_type_id,
    };
    var url = baseUrl + 'api/' + get_Admin_Subcategory_Product;
    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      int status = resp['status'];
      productList.clear();
      if (status == 1) {
        SubCategoryProductModel subCategoryProductModel =
            SubCategoryProductModel.fromJson(json.decode(response.body));
        productList = subCategoryProductModel.getAdminSubcategoryProductLists;
        if(user_id.isNotEmpty){
          getWishlistProdList();
          getCartProdList();
        }
      } else {
        productList=[];
      }
      if (mounted) {
        setState(() {
          isApiCallProcessing = false;
          //isServerError=false;
        });
      }
    }
    else if (response.statusCode == 500) {
      if(this.mounted){
        setState(() {
          print('server error');
          isApiCallProcessing=false;
          isServerError=true;
        });
      }
    }
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

        if(user_id.isNotEmpty){
          getWishlistProdList();
          getCartProdList();
        }

      } else {
        productList = [];
      }

      if (mounted) {
        setState(() {
          isApiCallProcessing = false;
          isServerError=false;

        });
      }
    }
    else if (response.statusCode == 500) {
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
          isServerError=true;
        });
      }
    }
  }

  getBrand_Product() async {
    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }
    final body = {
      "admin_auto_id":admin_auto_id,
      "brand_id": widget.brand_id,
      "app_type_id":app_type_id,
      "customer_auto_id": user_id,
    };

    var url = baseUrl + 'api/' + get_Admin_Brand_Product;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      int status = resp['status'];
      productList.clear();
      if (status == 1) {
        BrandProductModel brandProductModel =
            BrandProductModel.fromJson(json.decode(response.body));
        productList = brandProductModel.getAdminBrandProductLists;

        if(user_id.isNotEmpty){
          getWishlistProdList();
          getCartProdList();
        }

      } else {
        productList = [];
      }

      if (mounted) {
        setState(() {
          isApiCallProcessing = false;
          isServerError=false;
        });
      }
    }
    else if (response.statusCode == 500) {
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
          isServerError=true;
        });
      }
    }
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
      "app_type_id": app_type_id,
      "admin_auto_id":admin_auto_id,
      "customer_auto_id": user_id,
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
      "min_trial_period":min_trial_priod,
      "max_trial_period":max_trial_period,
      "out_of_stock":stock,
    };

    var url = baseUrl + 'api/' + get_filter_products;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      int status = resp['status'];
      productList.clear();
      if (status == 1) {
        FilteredProducts_Model filteredProductsModel = FilteredProducts_Model.fromJson(json.decode(response.body));
        productList = filteredProductsModel.getAdminOfferProductLists!;
        print(productList[0].productName);

        if(user_id.isNotEmpty){
          getWishlistProdList();
          getCartProdList();
        }

      }
      else {
        productList=[];
      }

      if (mounted) {
        setState(() {
          isApiCallProcessing = false;
          isServerError=false;
        });
      }
    }
    else if (response.statusCode == 500) {
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
          isServerError=true;
        });
      }
    }
  }

  addToWishlist(String productAutoId) async {
    for(int i=0;i<productList.length;i++){
      if(productAutoId==productList[i].productAutoId){
        productList[i].isAddedToWishlist=true;
      }
    }
    if(this.mounted){
      setState(() {});
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.addToWishlist(productAutoId, user_id, admin_auto_id, baseUrl).then((value) {
      if (value != null && value != '') {
        isApiCallProcessing = false;
        if (value == '1') {
          getWishlistProdList();
        }
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  removeFromWishlist(String productAutoId) async {
    for(int i=0;i<productList.length;i++){
      if(productAutoId==productList[i].productAutoId){
        productList[i].isAddedToWishlist=false;
      }
    }

    if(this.mounted){
      setState(() {});
    }

    Rest_Apis restApis = Rest_Apis();

    restApis
        .removeFromWishlist(productAutoId, user_id, admin_auto_id, baseUrl)
        .then((value) {
      if (value != null) {
        isApiCallProcessing = false;
        if (value == 1) {
          getWishlistProdList();
        }
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  getWishlistProdList() async {

    final body = {
      "user_auto_id": user_id,
      "admin_auto_id": admin_auto_id,
    };

    var url = baseUrl + 'api/' + get_wishlist_product_count;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing = false;
      final resp = jsonDecode(response.body);
      int status = resp['status'];
      if (status == 1) {
        WishlistCountModel wishlistCountModel =
            WishlistCountModel.fromJson(json.decode(response.body));
        wishlistProduct = wishlistCountModel.getAdminWishlistProductLists;

        for(int i=0;i<productList.length;i++){
          wishlistProduct.forEach((element) {
            if(element.productAutoId==productList[i].productAutoId){
              productList[i].isAddedToWishlist=true;
            }
          });
        }
      }
      else{

      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  getCartProdList() async {
    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }
    final body = {
      "user_auto_id": user_id,
    };

    var url = baseUrl + 'api/' + get_cart_product_count;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing = false;
      final resp = jsonDecode(response.body);
      int status = resp['status'];
      if (status == 1) {
        CartCountModel cartCountModel =
        CartCountModel.fromJson(json.decode(response.body));
        cartCount = cartCountModel.productCountData.toString();

        for(int i=0;i<productList.length;i++){
          cartCountModel.getAdminCartProductLists.forEach((element) {
            if(element.productAutoId==productList[i].productAutoId){
              productList[i].isAdedToCart=true;
            }
          });
        }
      }
      else {
        cartCount = '0';
      }

      if (mounted) {
        setState(() {});
      }
    }
    else if(response.statusCode==500){
      if(mounted){
        setState(() {
          isApiCallProcessing=false;
          Fluttertoast.showToast(
            msg: 'Server error',
            backgroundColor: Colors.grey,
          );
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

        if(user_id.isNotEmpty){
          getWishlistProdList();
          getCartProdList();
        }

      } else {}

      if (mounted) {
        setState(() {
          isApiCallProcessing = false;
          isServerError=false;
        });
      }
    }
    else if (response.statusCode == 500) {
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
          isServerError=true;
        });
      }
    }

  }

  showProductDetails(String productAutoId) {
    routes = MaterialPageRoute(
        builder: (context) => ProductDetailScreen(productAutoId));
    Navigator.push(context, routes).then(onGoBack);
  }

  showSeleceCartSize(String productAutoId, String moq,List<ProdSize> size) {

    if(size.isNotEmpty){
      return showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return SelectProdSize(addTocartListener,productAutoId,moq,size);
          });
    }
    else{
      addToCart(productAutoId, moq, '');
    }
  }

  showBuyNowSize(String productAutoId, String moq,List<ProdSize> size) {

    if(size.isNotEmpty){
      return showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return SelectProdSize(buyNowListenerListener,productAutoId,moq,size);
          });
    }
    else{
      buyNow(productAutoId, moq, '');
    }
  }

  addTocartListener(String productAutoId, String moq,String size){
    Navigator.pop(context);
    addToCart(productAutoId, moq, size);
  }

  buyNowListenerListener(String productAutoId, String moq,String size){
    Navigator.pop(context);
    buyNow(productAutoId, moq, size);
  }

  addToCart(String productAutoId, String moq,String size) async {
    for(int i=0;i<productList.length;i++){
      if(productAutoId==productList[i].productAutoId){
        productList[i].isAdedToCart=true;
      }
    }

    int cart_count=int.parse(cartCount);
    cart_count=cart_count+1;
    cartCount=cart_count.toString();
    if(this.mounted){
      setState(() {});
    }

    String cartQty='1';
    String size='';

    if(moq.isNotEmpty){
      cartQty=moq;
    }

    final body = {
      "product_auto_id": productAutoId,
      "user_auto_id": user_id,
      "size": size,
      "cart_quantity": cartQty,
      "admin_auto_id": admin_auto_id,
    };

    var url = baseUrl+'api/' + add_to_cart;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      String  status = resp['status'];
      if (status == '1') {

      }
      else {
        String msg=resp['msg'];
        Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.grey,
        );
      }

      if(mounted){
        setState(() {});
      }
    }
    else if(response.statusCode==500){
      if(mounted){
        setState(() {
          isApiCallProcessing=false;
          Fluttertoast.showToast(
            msg: 'Server error',
            backgroundColor: Colors.grey,
          );
        });
      }
    }
  }

  buyNow(String productAutoId, String moq,String size) async {
    if(this.mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    for(int i=0;i<productList.length;i++){
      if(productAutoId==productList[i].productAutoId){
        productList[i].isAdedToCart=true;
      }
    }

    int cart_count=int.parse(cartCount);
    cart_count=cart_count+1;
    cartCount=cart_count.toString();
    if(this.mounted){
      setState(() {});
    }

    String cartQty='1';
    String size='';

    if(moq.isNotEmpty){
      cartQty=moq;
    }

    final body = {
      "product_auto_id": productAutoId,
      "user_auto_id": user_id,
      "size": size,
      "cart_quantity": cartQty,
      "pincode": '',
      "coupon_code":'',
      "delivery_type":'Normal',
      "admin_auto_id": admin_auto_id,
    };

    var url = baseUrl+'api/' + buy_now;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      String  status = resp['status'];
      if (status == '1') {
        isApiCallProcessing=false;

        final resp = jsonDecode(response.body);
        String  status = resp['status'];
        if (status == '1') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BuyNowScreen()));
        }
        else {
          String msg=resp['msg'];
          Fluttertoast.showToast(
            msg: msg,
            backgroundColor: Colors.grey,
          );
        }

        if(mounted){
          setState(() {});
        }
      }
      else {
        String msg=resp['msg'];
        Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.grey,
        );
      }

      if(mounted){
        setState(() {});
      }
    }
    else if(response.statusCode==500){
      if(mounted){
        setState(() {
          isApiCallProcessing=false;
          Fluttertoast.showToast(
            msg: 'Server error',
            backgroundColor: Colors.grey,
          );
        });
      }
    }
  }

}

class Filter_layout extends StatelessWidget {
  const Filter_layout({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);
  final String? text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, //                   <--- border color
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Text(text!),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}