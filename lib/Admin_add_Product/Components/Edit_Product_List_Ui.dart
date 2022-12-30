import 'dart:async';
import 'dart:convert';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/Rest_Apis.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/size_model.dart';
import 'package:poultry_a2z/AppUi/app_ui_model.dart';
import 'package:poultry_a2z/Product_Details/Product_UI/Product_Card1.dart';
import 'package:poultry_a2z/Product_Details/Product_UI/Product_Card2.dart';
import 'package:poultry_a2z/Product_Details/Product_UI/Product_Card3.dart';
import 'package:poultry_a2z/Product_Details/Product_UI/Product_Card4.dart';
import 'package:poultry_a2z/Product_Details/Product_UI/Product_Card5.dart';
import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';
import 'package:poultry_a2z/Product_Details/product_details_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import '../../Home/Components/AddNewComponent/Products/all_products_model.dart';
import '../../Utils/App_Apis.dart';
import '../../Wishlist/model/wishlist_count_model.dart';

class Product_List_Ui extends StatefulWidget {
  Product_List_Ui(
      {Key? key,})
      : super(key: key);

  @override
  _Product_List_Ui createState() => _Product_List_Ui();
}

class _Product_List_Ui extends State<Product_List_Ui> {
  List<ProductModel> productList = [];

  String price='',offer_per='',final_price='';
  bool isServerError=false;
  late Route routes;

  bool isApiCallProcessing = false;
  bool isDeleteProcessing = false;

  String baseUrl = '', admin_auto_id='',app_type_id='';
  String user_id = '';

  List<GetAdminWishlistProductLists> wishlistProduct = [];

  String icon_type='1';
  List<Widget> iconTypeList=[];

  List<AllAppUiStyle> appUiStyle=[];

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
        getAppUiDetails();
        getProducts();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setIcons();
    getappUi();
    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text("Products",
              style: TextStyle(
                  color: appBarIconColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: () => {Navigator.of(context).pop()},
            icon: Icon(Icons.arrow_back, color: appBarIconColor),
          ),
          actions: [
            TextButton(
                onPressed: ()=>{
                  addAppUiDetails()
                },
                child: Text('Save',style: TextStyle(color: appBarIconColor),))
          ]),
      body: Stack(
        children: <Widget>[

          Container(
            child: Column(
              children: <Widget>[
                selectIconType(),
                Expanded(
                  flex:1,
                    child:
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
                )
              ],
            ),
          ),

          isApiCallProcessing == false &&
              productList.isEmpty? Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: const Text('No products available'))
              : Container(),

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

    );
  }

  selectIconType() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 160,
      margin: const EdgeInsets.only(left: 10,right: 10,bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15,),
          Text('Select icon type',style: TextStyle(color: Colors.black87,fontSize: 16, ),),
          SizedBox(height: 15,),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: iconTypeList.length,
              itemBuilder: (context, index) => GestureDetector(
                  onTap: ()=>appIconListener(index),
                  child: Container(
                    height: 90,
                    width: 90,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: getDecoration(index),
                    child: iconTypeList[index],
                  )
              ),
            ),)
        ],
      ),
    );
  }

  BoxDecoration getDecoration(int index){
    if((index+1)==int.parse(icon_type)){
      return BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.orange,
              width: 2));
    }
    else{
      return BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.blueGrey,
              width: 1));
    }

  }

  setIcons(){
    iconTypeList.add(
      Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 40,
              width: 30,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.grey[300]
              ),
            ),
            SizedBox(height: 5,),
            Text('300x500',style: TextStyle(fontSize: 11),)
          ],
        ),
      )
    );

    iconTypeList.add(
        Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Container(
            height: 20,
            width: 50,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.grey[300]
            ),
          ),
              SizedBox(height: 5,),
              Text('600x200',style: TextStyle(fontSize: 11),)
            ],
          ),
        )
    );

    iconTypeList.add(
        Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Container(
            height: 50,
            width: 30,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.grey[300]
            ),
          ),
              SizedBox(height: 5,),
              Text('300x550',style: TextStyle(fontSize: 11),)
            ],
          ),
        )
    );

    iconTypeList.add(
        Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Container(
            height: 40,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle,
                color: Colors.grey[300]
            ),
          ),
              SizedBox(height: 5,),
              Text('600x500',style: TextStyle(fontSize: 11),)
            ],
          ),
        )
    );

    iconTypeList.add(
        Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 55,
                width: 42,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5)
                ),
              ),
              SizedBox(height: 5,),
              Text('700x500',style: TextStyle(fontSize: 11),)
            ],
          ),
        )
    );
  }

  void appIconListener(int index){
    if(this.mounted){
      setState(() {
        icon_type=(index+1).toString();
      });
    }

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

  showProductDetails(String productId) {
    routes = MaterialPageRoute(
        builder: (context) => ProductDetailScreen(productId));
    Navigator.push(context, routes).then(onGoBack);
  }

  getProducts() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body={
      "customer_auto_id": user_id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    var url=baseUrl+'api/'+get_admin_products;
    var uri = Uri.parse(url);
    final response = await http.post(uri,body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        AllProductsModel allProductsModel=AllProductsModel.fromJson(json.decode(response.body));
        productList=allProductsModel.getProductsLists;

        if(this.mounted){
          setState(() {});
        }

      }
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

        if(appUiModel!=null && appUiModel.status==1){
          appUiStyle=appUiModel.allAppUiStyle!;

          print(appUiStyle.toString());

          if(appUiStyle[0].productLayoutType.isNotEmpty){
            icon_type=appUiStyle[0].productLayoutType;
          }

          print('icon type: '+icon_type);
          if(this.mounted){
            setState(() {
            });
          }
        }
      }
    });
  }

  addAppUiDetails() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    AllAppUiStyle uiStyle=appUiStyle[0];

    Rest_Apis restApis = Rest_Apis();

    restApis.addAppUi(uiStyle.id,uiStyle.appbarColor,uiStyle.appbarIconColor,uiStyle.bottomBarColor,uiStyle.bottomBarIconColor,
        uiStyle.addToCartButtonColor,uiStyle.loginRegisterButtonColor,uiStyle.buyNowBottonColor,uiStyle.appFont,
    uiStyle.showLocationOnHomescreen,icon_type, admin_auto_id, baseUrl).then((value) {
      if (value != null) {
        if(mounted){
          setState(() {
            isApiCallProcessing=false;
          });
        }
        if(value==1){
          Navigator.pop(context);
        }
      }
    });
  }

  FutureOr onGoBack(dynamic value) {
    getProducts();
  }

  showSeleceCartSize(String productAutoId, String moq,List<ProdSize> size) {
  }

  showBuyNowSize(String productAutoId, String moq,List<ProdSize> size) {

  }

  addToWishlist(String productAutoId) async {
  }

  removeFromWishlist(String productAutoId) async {
  }

}