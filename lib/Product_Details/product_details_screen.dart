import 'dart:async';
import 'dart:convert';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/size_model.dart';
import 'package:poultry_a2z/BuyNow/buy_now_screen.dart';
import 'package:poultry_a2z/Cart/Cart_Screen.dart';
import 'package:poultry_a2z/Cart/model/cart_count_model.dart';
import 'package:poultry_a2z/Product_Details/ZoomSizeChart.dart';
import 'package:poultry_a2z/Product_Details/calculate_delivery_time.dart';
import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';
import 'package:poultry_a2z/Product_Details/select_share_bottomsheet.dart';
import 'package:poultry_a2z/RatingReview/product_rating_model.dart';
import 'package:poultry_a2z/Shop_Details/SoldbyVendor_Details.dart';
import 'package:poultry_a2z/grobiz_start_pages/create_dynamic_link.dart';
import 'package:poultry_a2z/settings/Add_Pincode/Add_Pincode_Screen.dart';
import 'package:poultry_a2z/settings/Add_Pincode/Components/Get_Pincode_List_Model.dart';
import 'package:poultry_a2z/settings/Add_Size/Components/Get_SizeList_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../RatingReview/RatingAndReview.dart';
import '../RatingReview/RatingAndReview_Model.dart';
import '../Wishlist/model/wishlist_count_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Utils/App_Apis.dart';
import '../Admin_add_Product/Components/Model/Rest_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import '../Admin_add_Product/Components/Model/product_color_model.dart';
import '../Admin_add_Product/Components/Model/product_details_model.dart';
// import 'package:badges/badges.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:poultry_a2z/Home/Components/UserLocation/select_pincode_bottomsheet.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';
import 'ZoomPhotoViewGallery.dart';
import 'model/SimilarProductModel.dart';

class ProductDetailScreen extends StatefulWidget {
  String product_id;
  ProductDetailScreen(this.product_id);

  @override
  _ProductDetailScreen createState() => _ProductDetailScreen(product_id);
}

class _ProductDetailScreen extends State<ProductDetailScreen> {
  String product_id;

  bool isAddedTocart=false;
  bool isBuynow=false;
  bool isAddedTowishlist=false;
  //late File product_image;
  int total_reviews = 0, avg_rating = 0,finishingRating=0,quality_rating=0,price_rating=0,size_fit_rating=0;

  _ProductDetailScreen(this.product_id);

  List<GetRatingLists> RatingAndReviewList = [];
  List<GetRatingLists> yourReview=[];

  String user_id='', userType='',app_type_id='';
  String baseUrl='',admin_auto_id='';

  String size_title='';

  List<GetProductsDetails> productsDetails=[];
  String price='',offer_per='',final_price='';

  String cartCount='0';
 // String wishlistCount='0';
  List<GetAdminWishlistProductLists> wishlistProduct=[];

  bool isApiCallProcessing=false,isServerError=false;
  bool showAppbar=true;

  List<GetProductsLists> productColorList=[];

  int selectedSize=-1,Wishlist_count=0,return_count=0,repeat_count=0;
  String user_pincode='', user_city='';
  double latitude=0.0,longitude=0.0;

  String app_name='';

  late Route routes;

  bool isout_of_stock=false;

  late File share_prod_image;
  String product_image='';

  List<ProductModel> similarProductList = [];

  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;

  bool isPincodeDeliveryAvailable=false;
  List<GetPincodeList> getpincode_List = [];

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
    String? appName =prefs.getString('app_name');
    String? adminId = prefs.getString('admin_auto_id');
    String? userId = prefs.getString('user_id');
    String? userType = prefs.getString('user_type');
    String? apptypeid= prefs.getString('app_type_id');

    if(appName!=null){
      this.app_name=appName;
      }

    if(userType!=null){
      this.userType=userType;
    }

    if(baseUrl!=null && adminId!=null && userId!=null && apptypeid!=null){
      this.user_id = userId;
      this.admin_auto_id=adminId;
      this.baseUrl=baseUrl;
      this.app_type_id=apptypeid;
      setState(() {});
      getSizeListApi();
      getPin_CodeList();
      getProductDetails(product_id);
      getCartProdList(product_id);
      getWishlistProdList(product_id);
      getRatingandReviewData(product_id);
    }
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
  //         icon: const Icon(Icons.shopping_cart, color: Colors.black),
  //         onPressed: () {
  //           gotoCartScreen();
  //         }
  //     ),
  //   );
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
    getappUi();
  }

  getPincodeData() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? pincode =prefs.getString('user_pincode');
    double? latitude =prefs.getDouble('user_latitude');
    double? longitude =prefs.getDouble('user_longitude');
    String? user_city =prefs.getString('user_city');

    if(pincode!=null){
      this.user_pincode=pincode;
      bool isAvailable=false;
      for(int i=0; i<getpincode_List.length ; i++){
        if(getpincode_List[i].pincode == user_pincode){
          isAvailable=true;
        }
      }

      if(isAvailable==true){
        isPincodeDeliveryAvailable=true;
      }
      else{
        isPincodeDeliveryAvailable=false;
      }

      if(this.mounted){
        setState(() {});
      }
    }

    if(longitude!=null){
      this.longitude=longitude;
    }

    if(latitude!=null){
      this.latitude=latitude;
    }

    if(user_city!=null){
      this.user_city=user_city;
    }

    if(this.mounted){
      setState(() {});
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: isout_of_stock==false?Buy_Now_Section(context):
        Container(
          height: 40,
          alignment: Alignment.center,
          child: Text('Out Of Stock',style: TextStyle(color: Colors.red,fontSize: 18),),),
        extendBodyBehindAppBar: true,
        appBar: showAppbar==true?
        AppBar(
          backgroundColor: Colors.white.withOpacity(0.5),
          leading: IconButton(
            onPressed:  Navigator.of(context).pop,
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
            actions: [
              IconButton(
                visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
                padding: EdgeInsets.zero,
                onPressed: () {
                  shareProduct();
                },
                icon: const Icon(Icons.share, color: Colors.black87),
              ),

              /*product_image!=''?
              IconButton(
                visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
                padding: EdgeInsets.zero,
                onPressed: () {
                  shareOnSocialMedia();
                },
                icon: const Icon(Icons.admin_panel_settings, color: Colors.black87),
              ):
              Container(),*/

              // IconButton(
              //   visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
              //   padding: EdgeInsets.zero,
              //   onPressed: () {},
              //   icon: Icon(Icons.favorite_border_rounded, color: Colors.black87),
              // ),

              //_shoppingCartBadge(),
            ]
        ):
        null,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.only(top: 32,bottom: 60),
          child:Stack(
            children: <Widget>[
              Container(
                child: SingleChildScrollView(
                  child:GestureDetector(
                    onDoubleTap: ()=>{
                      showHideAppbar()
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        productImageUi(),
                        productNameUi(),
                        //soldByUi(),
                        productPriceUi(),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: moqUi()),
                              Expanded(
                                  flex: 1,
                                  child: total_reviews!=0?totalRatingUi():const Text(''))
                            ],
                          ),
                        ),
                        // Container(
                        //     alignment: Alignment.topLeft,
                        //     margin: EdgeInsets.only(left: 10),
                        //     child: Text("Shipping charges from factory: Rs.0",
                        //         style: TextStyle(fontSize: 12, color: Colors.black))),
                        Divider(
                          height: 20,
                          thickness: 7,
                          color: Colors.grey[200],
                        ),
                        addColors(),
                        addSize(),
                        productColorList.isNotEmpty?
                        Divider(
                          height: 20,
                          thickness: 7,
                          color: Colors.grey[200],
                        ):
                        Container(),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: const BorderRadius.all(Radius.circular(20))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        const Icon(Icons.repeat),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(repeat_count.toString()+' Repeat Order',
                                            style: const TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: const [
                                        Icon(Icons.emoji_events),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Best Selling Product',
                                            style: TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: const BorderRadius.all(Radius.circular(20))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        const Icon(Icons.favorite),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(Wishlist_count.toString()+' Likes', style: const TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: const BorderRadius.all(Radius.circular(20))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        const Icon(Icons.repeat),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(return_count.toString()+'% Return', style: const TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: Divider(color: Colors.grey.shade200),
                        ),
                        Container(child:
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 6,
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child:
                                          user_pincode.isEmpty?
                                          Text(
                                            "Select Delivery Pincode",
                                            style:
                                            (TextStyle(fontSize: 14, color: Colors.black)),
                                          ):
                                          isPincodeDeliveryAvailable==true?
                                          Text(
                                            "Deliver To: "+user_pincode,
                                            style: (TextStyle(fontSize: 14, color: Colors.green)),
                                          ):
                                           Container(
                                             child: Text('Sorry, currently we are unable to deliver at pincode '+user_pincode,
                                             style: TextStyle(color: Colors.red,fontSize: 15),),)

                                      )),
                                  Expanded(
                                    flex: 3,
                                    child: GestureDetector(
                                      child: SizedBox(
                                        height: 35,
                                        width: 100,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryButtonColor,
                                              textStyle: const TextStyle(fontSize: 20)),
                                          onPressed: ()=> {
                                            if(getpincode_List.length==0 && userType=='Admin')
                                              {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => Add_Pincode_Screen()))
                                              }else
                                              {
                                                showAddPincode()
                                              }
                                          },
                                          child: const Center(
                                            child: Text(
                                              'Change',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            productsDetails.isNotEmpty && productsDetails[0].time.isNotEmpty
                                && productsDetails[0].timeUnit.isNotEmpty?
                            Row(
                              children: [
                                Padding(
                                  padding:EdgeInsets.only(left: 10.0, top: 5),
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.card_giftcard),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('Expected Delivery: '+CalculateDeliveryTime.getDeliveryDate(productsDetails[0].time,
                                          productsDetails[0].timeUnit),
                                          style: TextStyle(fontSize: 14)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      // Icon(Icons.info),
                                    ],
                                  ),
                                ),
                              ],
                            ):
                            Container(),
                          ],
                        ),
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),

                        productDescriptionUi(),
                        productPackofUi(),
                        productMaterialUi(),
                        productThicknessUi(),
                        productFirmnessUi(),
                        productTrialPeriodUi(),
                        productDimensionUi(),
                        specificationUi(),
                        Divider(
                          height: 20,
                          thickness: 7,
                          color: Colors.grey[200],
                        ),
                       returnPolicyUi(),
                       // Return_Policy_Screen(),
                        Divider(
                          height: 20,
                          thickness: 7,
                          color: Colors.grey[200],
                        ),
                        total_reviews!=0 ?ratingReviewUi():Container(),

                        similarProductList.isNotEmpty?
                        similar_product_ui():
                        Container(),
                        const SizedBox(height: 10,),

                        //  Recommended_Product_List()
                      ],
                    ),
                  ),
                ),
              ),

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
          )));
  }

  showAddPincode() {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SelectPincode(onAddPincodelistener);
        });
  }

  onAddPincodelistener(){
    Navigator.of(context).pop();
    getPincodeData();
  }

  similar_product_ui(){
    return Container(
      width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Text(
              'Similar Products',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Container(
              width: 1000,
                height: 280,
                margin: const EdgeInsets.only(top:10,),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: similarProductList.length,
                    itemBuilder: (context, index) =>
                        simillarProductItem(similarProductList[index])
                )

            )

          ],
        )
    );
  }

  returnPolicyUi(){
    if(productsDetails.isNotEmpty && productsDetails[0].isExchange!='' && productsDetails[0].isReturn!=''){
      return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Return/Exchange',
              style: TextStyle(
                  fontSize: 16,
                  //fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 10,),

            productsDetails[0].isReturn=='Yes' && productsDetails[0].isExchange=='Yes'?
            Text('Easy return and exchange available within '+productsDetails[0].days+' days',
              style: TextStyle(fontSize: 15, color: Colors.black),):
            productsDetails[0].isReturn=='Yes'?
            Text('Easy return available within '+productsDetails[0].days+' days',
              style: TextStyle(fontSize: 15, color: Colors.black),):
            productsDetails[0].isExchange=='Yes'?
            Text('Easy exchange available within '+productsDetails[0].days+' days',
              style: TextStyle(fontSize: 15, color: Colors.black),):
            Text('Return/Exchange not avaialble for this product',
              style: TextStyle(fontSize: 15, color: Colors.black),)

          ],
        ),
      );
    }
    else{
      return Container();
    }
  }

  ratingReviewUi(){
    return Container(
      padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Customer Reviews',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 20,),
            Container(
                margin: const EdgeInsets.all(5),
                alignment: Alignment.center,
                height: 120,
                // color: Colors.grey[100],
                width: MediaQuery.of(context).size.width,
                child:Row(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: [
                              Text(avg_rating.toString(),
                                  style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.black)
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.pinkAccent,
                                size: 27,
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                          Text(total_reviews.toString()+' Verified Buyers',
                              style: const TextStyle(
                                  fontSize: 12,
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.black54))
                        ],
                      ),
                      width: 90,
                    ),
                    VerticalDivider(),
                    Expanded(
                      flex:1,
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: [
                              Text('Finishing',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black)
                              ),
                              Expanded(
                                  flex:1,
                                  child:Container(
                                    alignment: Alignment.centerRight,
                                    width: MediaQuery.of(context).size.width,
                                    child: SizedBox(
                                      child: RatingBar.builder(
                                        itemSize: 15,
                                        ignoreGestures: true,
                                        initialRating: double.parse(finishingRating.toString()),
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(horizontal: 2.5),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.blueAccent,
                                        ),
                                        onRatingUpdate: (rating) {
                                        },
                                      ),
                                    ),
                                  )
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                          SizedBox(height: 10,),

                          Row(
                            children: [
                              Text('Quality',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black)
                              ),
                              Expanded(
                                  flex:1,
                                  child:Container(
                                    alignment: Alignment.centerRight,
                                    width: MediaQuery.of(context).size.width,
                                    child: SizedBox(
                                      child: RatingBar.builder(
                                        itemSize: 15,
                                        ignoreGestures: true,
                                        initialRating: double.parse(quality_rating.toString()),
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(horizontal: 2.5),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.blueAccent,
                                        ),
                                        onRatingUpdate: (rating) {
                                        },
                                      ),
                                    ),
                                  )
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                          SizedBox(height: 10,),

                          Row(
                            children: [
                              Text('Size & Fit',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black)
                              ),
                              Expanded(
                                  flex:1,
                                  child:Container(
                                    alignment: Alignment.centerRight,
                                    width: MediaQuery.of(context).size.width,
                                    child: SizedBox(
                                      child: RatingBar.builder(
                                        itemSize: 15,
                                        ignoreGestures: true,
                                        initialRating: double.parse(size_fit_rating.toString()),
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(horizontal: 2.5),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.blueAccent,
                                        ),
                                        onRatingUpdate: (rating) {
                                        },
                                      ),
                                    ),
                                  )
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                          SizedBox(height: 10,),

                          Row(
                            children: [
                              Text('Price',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black)
                              ),
                              Expanded(
                                  flex:1,
                                  child:Container(
                                    alignment: Alignment.centerRight,
                                    width: MediaQuery.of(context).size.width,
                                    child: SizedBox(
                                      child: RatingBar.builder(
                                        itemSize: 15,
                                        ignoreGestures: true,
                                        initialRating: double.parse(price_rating.toString()),
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(horizontal: 2.5),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.blueAccent,
                                        ),
                                        onRatingUpdate: (rating) {
                                        },
                                      ),
                                    ),
                                  )
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                        ],
                      ),
                    )
                    )
                  ],
                )
            ),
            Divider(),

/*
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
             // color: Colors.grey[100],
              width: MediaQuery.of(context).size.width,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                        children: [
                          Text(avg_rating.toString(),
                              style: const TextStyle(
                                  fontSize: 40,
                                  color: Colors.black)
                          ),
                          const Icon(
                            Icons.star,
                            color: Colors.orangeAccent,
                            size: 20,
                          ),
                        ],
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                    Text(total_reviews.toString()+' Verified Buyers',
                        style: const TextStyle(
                            fontSize: 12,
                            //fontWeight: FontWeight.bold,
                            color: Colors.black54))
                  ],
                )
            ),
*/

           /* yourReview.isNotEmpty?
            myReview(yourReview[0]):
            Container(),
*/

            Text(
              'Reviews',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            RatingAndReviewList.isNotEmpty && RatingAndReviewList[0]!=null?
            RatingUi(RatingAndReviewList[0]):
            Container(),
            // RatingAndReviewList.isNotEmpty&& RatingAndReviewList[1]!=null?
            // RatingUi(RatingAndReviewList[1]):
            // Container(),
            RatingAndReviewList.isNotEmpty && RatingAndReviewList.length>1?
            GestureDetector(
              onTap: ()=>{
                routes =MaterialPageRoute(builder: (context) => RatingAndReview(product_id,user_id,app_type_id)),
                Navigator.push(context, routes).then(onGoBackFromReview)
              },
              child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(
                          color: Colors.black54,
                          width: 1
                      ),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: const Text('View All Reviews',
                      style: TextStyle(
                          fontSize: 12,
                          //fontWeight: FontWeight.bold,
                          color: Colors.black54))
              ),
            ):
            Container()
          ],
        )
    );
  }

  RatingUi(GetRatingLists ratinglist) {
    return
      Container(
        child: GestureDetector(
            onTap: () => {
            //  showReviewDetails(ratinglist)
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              /*  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26)
                ),*/
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        border:Border.all(
                          color: Colors.orangeAccent
                        ),
                        borderRadius: BorderRadius.circular(2)
                      ),
                      child: Row(
                        children: [
                          Text(ratinglist.rating),
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 15,
                          ),
                        ],
                      ) ,
                    ),
                    Expanded(
                      child:Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ratinglist.review,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.left,
                              textScaleFactor: 1,
                              softWrap: true,
                            ),
                            ratinglist.reviewImage.isNotEmpty ?
                            Container(
                              margin: const EdgeInsets.all(10),
                              height: 90,
                              width: 90,
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: baseUrl+review_image_base_url + ratinglist.reviewImage,
                                placeholder: (context, url) => Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black12,
                                    )),
                                errorWidget: (context, url, error) => const Icon(
                                  Icons.error,
                                  color: Colors.black26,
                                ),
                              )
                            ):
                            Container(),
                            Container(
                              height: 25,
                              //margin: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    ratinglist.customerName,
                                    style: const TextStyle(color: Colors.black87,fontSize: 12),
                                  ),
                                  const VerticalDivider(
                                    color: Colors.black87,
                                    thickness: 1,
                                    width: 10,
                                    indent: 4,
                                    endIndent: 0,
                                  ),
                                  Text(
                                    getupdatedDate(ratinglist.date),
                                    style: const TextStyle(color: Colors.black87,fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                              color: Colors.black54,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ))));
  }

  String getupdatedDate(String rdate) {
    late String updatedon,updateday;
    updatedon=rdate;
    var inputFormat = DateFormat('yyyy-MM-dd');
    var date1 = inputFormat.parse(updatedon);

    var outputFormat = DateFormat('dd-MM-yyyy');
    var date2 = outputFormat.format(date1);
    updateday =date2.toString();
    return updateday;
  }

  FutureOr onGoBackFromReview(dynamic value) {
    getRatingandReviewData(product_id);
  }

  showImages(List<ProductImages> imageList){
     routes = MaterialPageRoute(builder: (context) => GalleryPhotoViewWrapper(galleryItems: imageList,baseUrl: baseUrl,));
     Navigator.push(context, routes).then(onGoBack);

    /* routes = MaterialPageRoute(builder: (context) => PhotoViewGallery(imageList,baseUrl));
     Navigator.push(context, routes).then(onGoBack);*/
  }

  showSizeChart(){

    routes = MaterialPageRoute(builder: (context) => ZoomSizeChart(image: productsDetails[0].sizeChart,baseUrl: baseUrl,));
    Navigator.push(context, routes).then(onGoBack);
  }

  productImageUi(){
    if(productsDetails.isNotEmpty && productsDetails[0].productImages.isNotEmpty){
      return GestureDetector(
        onTap:(){
          showImages(productsDetails[0].productImages);
        },
        child: SizedBox(
        height: 450,
        child: ImageSlideshow(
          /// Width of the [ImageSlideshow].
          width: MediaQuery.of(context).size.width,

          /// Height of the [ImageSlideshow].
          height: 450,

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
      ),);
    }
    else{
      return  Container(
        height: 400,
        color: Colors.grey[300],
      );
    }
  }

  specificationUi(){

    if(productsDetails.isNotEmpty && productsDetails[0].specificationDetails.isNotEmpty && productsDetails[0].specificationDetails[0].title!=''){
      return Container(
        margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Text("Product Specification",
                      style: TextStyle(
                          fontSize: 15, color: Colors.black)) ,
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
                children:showSpecificationData(),
              ),
            ),

          ],
        ),
      );
    }
    else{
      return Container();
    }
  }

  showSpecificationData(){
    List<TableRow> specificationList=[];

    if(productsDetails.isNotEmpty && productsDetails[0]!=null){
      for(int index=0;index<productsDetails[0].specificationDetails.length;index++){
        specificationList.add(
          TableRow(children: [
            Column(children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(productsDetails[0].specificationDetails[index].title,
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
                  child: Text(productsDetails[0].specificationDetails[index].description,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 14.0)),
                ),
              )
            ]),
          ]),
        );
      }
    }
    return specificationList;
  }

  List<Widget> imagesliderItems(){
    List<Widget> items=[];

    for(int index=0;index<productsDetails[0].productImages.length;index++){
      items.add(
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 450,
            child:
            productsDetails[0].productImages.isNotEmpty?
            CachedNetworkImage(
              fit: BoxFit.contain,
              imageUrl: baseUrl+product_base_url+productsDetails[0].productImages[index].productImage,

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
      );
    }

    return items;
  }

  soldByUi(){
    if(productsDetails.isNotEmpty && productsDetails[0].addedBy!='Admin'){
      return
        Container(
        margin: EdgeInsets.all(10),
        child:TextButton(
          onPressed: ()=>{
            Navigator.push(context, MaterialPageRoute(builder: (context) => SoldByVendor_details(productsDetails[0].userAutoId)))
          },
          child: Text('Sold By: Vendor Name',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      );
    }
    else{
      return  Container();
    }
  }

  moqUi(){
    if(productsDetails.isNotEmpty && productsDetails[0].moq.isNotEmpty){
      return Container(
        margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
        child: Text('MOQ: '+productsDetails[0].moq,
          style: const TextStyle(
              color: Colors.black54,
              fontSize: 15,
          ),
        ),
      );
    }
    else{
      return  Container();
    }
  }

  totalRatingUi(){
    if(total_reviews!=0){
      return Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.bottomRight,
        margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
        child:Container(
          width: 70,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(avg_rating.toString(),
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 10,
                ),
              ),
              Icon(Icons.star,color: Colors.orangeAccent,size: 10,),
              Text('| '+total_reviews.toString(),
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      );
    }
    else{
      return  Container();
    }
  }

  grossWtUi(){
    if(productsDetails.isNotEmpty && productsDetails[0].moq.isNotEmpty){
      return Container(
        margin: const EdgeInsets.all(10),
        child: Text('MOQ: '+productsDetails[0].moq,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 15,
          ),
        ),
      );
    }
    else{
      return  Container();
    }
  }

  netWtUi(){
    if(productsDetails.isNotEmpty && productsDetails[0].moq.isNotEmpty){
      return Container(
        margin: const EdgeInsets.all(10),
        child: Text('MOQ: '+productsDetails[0].moq,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 15,
          ),
        ),
      );
    }
    else{
      return  Container();
    }
  }

  prodWtUi(){
    if(productsDetails.isNotEmpty && productsDetails[0].moq.isNotEmpty){
      return Container(
        margin: const EdgeInsets.all(10),
        child: Text('MOQ: '+productsDetails[0].moq,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 15,
          ),
        ),
      );
    }
    else{
      return  Container();
    }
  }

  qtyUi(){
    if(productsDetails.isNotEmpty && productsDetails[0].moq.isNotEmpty){
      return Container(
        margin: const EdgeInsets.all(10),
        child: Text('MOQ: '+productsDetails[0].moq,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 15,
          ),
        ),
      );
    }
    else{
      return  Container();
    }
  }

  productNameUi(){
    if(productsDetails.isNotEmpty){
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 10,right: 10,top: 10),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 8,
              child:Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  productsDetails[0].productName,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                )
                ,
              )),
            Expanded(
              flex: 2,
              child:
              Container(
                alignment: Alignment.topRight,
                width: MediaQuery.of(context).size.width,
                child: IconButton(
                  icon:
                  isAddedTowishlist==true?
                  const Icon(Icons.favorite_rounded,color: Colors.red,):
                  const Icon(Icons.favorite_outline_rounded),

                  onPressed: ()=>{
                    if(isAddedTowishlist==false){
                      addToWishlist()
                    }
                    else{
                      removeFromWishlist()
                    }

                  },
                ),
              ),
            )
          ],
        ),
      );
    }
    else{
      return  Container(
        margin: const EdgeInsets.all(10),
        width: 200,
        height: 20,
        color: Colors.grey[200],
      );
    }
  }

  productPriceUi(){

    if(productsDetails.isNotEmpty){
      if(productsDetails[0].productPrice.isNotEmpty){
        if(productsDetails[0].includingTax=='No' && productsDetails[0].taxPercentage!='0'){
          return Container(
              margin: const EdgeInsets.only(left: 10,right: 10,bottom: 8),
              child:Column(
                children: <Widget>[
                  Row(
                    children: [
                      productsDetails[0].productPrice!=productsDetails[0].finalProductPrice ?
                      Text(
                        productsDetails[0].currency + price,
                        style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                            decoration: TextDecoration.lineThrough),
                      ):Text(''),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        productsDetails[0].currency + final_price,
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "including "+productsDetails[0].taxPercentage+"% Taxes",
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      offer_per!='0'?Text(
                        offer_per.toString()+'% OFF',
                        style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.bold
                        ),
                      ):Text('')
                    ],
                  )

                ],
              ));
        }
        else{
          return Container(
              margin: const EdgeInsets.only(left: 10,right: 10,bottom: 8),
              child:Column(
                children: <Widget>[
                  Row(
                    children: [
                      productsDetails[0].offerPercentage!='0' && productsDetails[0].offerPercentage!='0' && !productsDetails[0].offerData.isEmpty?Text(
                        productsDetails[0].currency + price,
                        style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                            decoration: TextDecoration.lineThrough),
                      ):Text(''),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        productsDetails[0].currency + final_price,
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  offer_per.toString()!='0'?Row(
                    children: [
                      Text(
                        offer_per.toString()+'% OFF',
                        style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ):Container()

                ],
              ));
        }
      }
      else{
        return Container();
      }
    }
    else{
      return  Container(
        margin: const EdgeInsets.only(left: 10,right: 10,bottom: 8),
        width: 300,
        height: 20,
        color: Colors.grey[200],
      );
    }
  }

  productDescriptionUi(){
    return productsDetails.isNotEmpty && productsDetails[0].description!=''?Container(
      margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Description",
              style: TextStyle(
                  fontSize: 15, color: Colors.black)),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(10),
            child: Text(
              productsDetails[0].description,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[200],
          ),

        ],
      ),
    ):Container();
  }

  productMaterialUi(){
    return productsDetails.isNotEmpty && productsDetails[0].Material!='Select Material' && productsDetails[0].Material!=''?Container(
      margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Product Material",
              style: TextStyle(
                  fontSize: 15, color: Colors.black)),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(10),
            child: Text(
              productsDetails[0].Material,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[200],
          ),

        ],
      ),
    ):Container();
  }

  productThicknessUi(){
    return productsDetails.isNotEmpty && productsDetails[0].Thickness!='' && productsDetails[0].Thickness!="Select Thickness"?Container(
      margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Product Thickness",
              style: TextStyle(
                  fontSize: 15, color: Colors.black)),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(10),
            child: Text(
              productsDetails[0].Thickness+'cm',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[200],
          ),

        ],
      ),
    ):Container();
  }

  productFirmnessUi(){
    return productsDetails.isNotEmpty && productsDetails[0].Firmness!='Select Firmness' && productsDetails[0].Firmness!=''?Container(
      margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Product Firmness",
              style: TextStyle(
                  fontSize: 15, color: Colors.black)),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(10),
            child: Text(
              productsDetails[0].Firmness,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[200],
          ),

        ],
      ),
    ):Container();
  }

  productTrialPeriodUi(){
    return productsDetails.isNotEmpty && productsDetails[0].TrialPeriod!=''?Container(
      margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Product Trial Period",
              style: TextStyle(
                  fontSize: 15, color: Colors.black)),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(10),
            child: Text(
              productsDetails[0].TrialPeriod+' Days',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[200],
          ),

        ],
      ),
    ):Container();
  }

  productPackofUi(){
    return productsDetails.isNotEmpty && productsDetails[0].quantity!=''?Container(
      margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Pack Of",
              style: TextStyle(
                  fontSize: 15, color: Colors.black)),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(10),
            child: Text(
              productsDetails[0].quantity,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[200],
          ),

        ],
      ),
    ):Container();
  }

  productDimensionUi(){
    return productsDetails.isNotEmpty && (productsDetails[0].height.isNotEmpty ||
        productsDetails[0].Width.isNotEmpty || productsDetails[0].depth.isNotEmpty)?Container(
      margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Product Dimensions",
              style: TextStyle(
                  fontSize: 15, color: Colors.black)),
          const SizedBox(
            height: 5,
          ),
          productsDetails[0].height!=null && productsDetails[0].height.isNotEmpty?
          Row(
            children: <Widget>[
              Text(
                 'Height: ',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              Text(
                productsDetails[0].height,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              )
            ],
          ):
          Container(),

          productsDetails[0].Width!=null && productsDetails[0].Width.isNotEmpty?
          Row(
            children: <Widget>[
              Text(
                'Width: ',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              Text(
                productsDetails[0].Width,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              )
            ],
          ):
          Container(),

          productsDetails[0].depth!=null && productsDetails[0].depth.isNotEmpty?
          Row(
            children: <Widget>[
              Text(
                'Depth: ',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              Text(
                productsDetails[0].depth,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              )
            ],
          ):
          Container(),

          Divider(
            thickness: 1,
            color: Colors.grey[200],
          ),

        ],
      ),
    ):Container();
  }

  addColors(){
    if(productsDetails.isNotEmpty && productsDetails[0].colorName!='Color'){
      return productColorList.isNotEmpty && productColorList.length>1?
      Container(
        margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Colors",
                style: TextStyle(
                    fontSize: 15, color: Colors.black)),
            const SizedBox(
              height: 5,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: getColorList(),
                )
            ) ,
            Divider(
              thickness: 1,
              color: Colors.grey[200],
            ),
          ],
        ),
      ):
      Container();
    }
    else{
      return Container();
    }
  }

  List<Widget> getColorList(){
    List<Widget> colorList=[];

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
                              imageUrl: baseUrl+product_base_url+productColorList[index].productImageLists[0].productImage,
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

                    productColorList[index].colorName != 'Select Color Name'?
                    Text(productColorList[index].colorName):
                    Container()
                  ],
                ),
              ),
            )
        );
      }
    }
    return colorList;
  }

  void selectColor(int colorIndex, ) {
    product_id=productColorList[colorIndex].productAutoId;
    getProductDetails(product_id);
    getWishlistProdList(product_id);
    getCartProdList(product_id);
    getRatingandReviewData(product_id);
    //priceController.text=productColorList[color_index].getPriceLists[0].sizePrice;
    // offerController.text=productColorList[color_index].getPriceLists[0].offerPercentage;
    //finalproceController.text=productColorList[color_index].getPriceLists[0].finalSizePrice;

    if(mounted){
      setState(() {

      });
    }
  }

  addSize(){

    if(productsDetails.isNotEmpty && productsDetails[0].size.isNotEmpty){
      return Container(
        margin: const EdgeInsets.only(left: 10,right: 10,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Select "+size_title,
                    style: TextStyle(
                        fontSize: 15, color: Colors.black)),

                productsDetails[0].sizeChart.isNotEmpty?
                Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: ()=>{
                          showSizeChart()
                        },
                        child: Text('Size Chart',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: Colors.blue),),
                      ),
                    )
                ):
                Container()
              ],
            ),
            SizedBox(height: 5),
            Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 6,right: 6),
                alignment: Alignment.centerLeft,
                height: 90,
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
    else{
      return Container();
    }
  }

  List<Widget> getSizeList(){
    List<Widget> sizeList=[];

    List<ProdSize> sizelist=productsDetails[0].size;
    List<GetSizePriceLists> pricelist=productsDetails[0].getPriceLists;


    if(sizelist.isNotEmpty){
      for(int index=0;index<sizelist.length;index++){
        sizeList.add(
            GestureDetector(
              onTap: ()=>{
                selectSize(index)
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 2,right: 2,top: 0),
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
                            color: selectedSize==index?
                            Colors.blue:
                            Colors.grey.shade300,
                            width: 1.5),
                      ),
                      child: Text(sizelist[index].sizeName,
                        textAlign:TextAlign.center,style: const TextStyle(color:Colors.black87,fontSize: 17),),
                    ),
                    pricelist.isNotEmpty && !(pricelist.length <sizelist.length) && pricelist[index].sizePrice!='0'?
                    Text(productsDetails[0].currency +pricelist[index].sizePrice):
                    Container()
                  ],
                ),
              ),
            )
        );
      }
    }
    return sizeList;
  }

  void selectSize(int sizeIndex, ) {
    selectedSize=sizeIndex;

    if(productsDetails[0].getPriceLists.isNotEmpty &&
        productsDetails[0].getPriceLists[sizeIndex].sizePrice.isNotEmpty &&
        productsDetails[0].getPriceLists[sizeIndex].sizePrice!='0'){

      price=productsDetails[0].getPriceLists[sizeIndex].sizePrice;
      offer_per=productsDetails[0].getPriceLists[sizeIndex].offerPercentage;
      final_price=productsDetails[0].getPriceLists[sizeIndex].finalSizePrice;
    }
    else{
      price=productsDetails[0].productPrice;
      offer_per=productsDetails[0].offerPercentage;
      final_price=productsDetails[0].finalProductPrice;
    }

    if(mounted){
      setState(() {

      });
    }
  }

  void pincodeUnavaialbleAlert() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.yellow[50],
        content:Wrap(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Text('Sorry, currently we are unable to deliver at pincode '+user_pincode,
                    style: TextStyle(color: Colors.black54),),
                ],
              ),
            )
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: const Text("Ok",
                style: TextStyle(color: Colors.white,fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(70,30),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
              ),
            ),
          )
        ],),
    );
  }

  void pincodeEmptyAlert() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.yellow[50],
        content:Wrap(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Text('Pincode is Not available,Please add pincode...',
                    style: TextStyle(color: Colors.black54),),
                ],
              ),
            )
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Add_Pincode_Screen()));
            },
            child: const Text("Ok",
                style: TextStyle(color: Colors.white,fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(70,30),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
              ),
            ),
          )
        ],),
    );
  }

  Widget Buy_Now_Section(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryButtonColor,
                        textStyle: const TextStyle(fontSize: 20)),
                    onPressed: ()=> {
                      if(isAddedTocart==true){
                        gotoCartScreen()
                      }
                      else{
                        if(validation()==true){
                          addToCart()
                        }
                      }
                    },
                    child: isAddedTocart==true?
                    const Text("GO TO CART", style: TextStyle(fontSize: 14),):
                    const Text("ADD TO CART", style: TextStyle(fontSize: 14),),
                  ),
                ),
              ),
              const SizedBox(width: 20,),
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryButtonColor,
                        textStyle: const TextStyle(fontSize: 20)),
                    onPressed: () {
                      if (validation() == true) {
                        BuyNow();
                      }
                    },
                    child: const Center(
                      child: Text(
                        'BUY NOW',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )

            ],
          )
      )
    );

  }

  gotoCartScreen(){
    routes = MaterialPageRoute(builder: (context) => const Cart_Screen());
    Navigator.push(context, routes).then(onGoBack);
  }

  getSizeListApi() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    var url = baseUrl+'api/' + get_size_list;

    Uri uri=Uri.parse(url);

    final body = {
      "admin_auto_id": admin_auto_id,
    };

    final response = await http.post(uri, body:  body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      if (status == 1) {
        GetSizeListModel getSizeListModel=GetSizeListModel.fromJson(json.decode(response.body));
        size_title=getSizeListModel.title!;
      }
      else {
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  getProductDetails(String productId) async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "product_auto_id": productId,
      "admin_auto_id": admin_auto_id,
      "customer_auto_id": user_id,
      "app_type_id":app_type_id,
    };
//print(body.toString());
    var url = baseUrl+'api/' + get_product_details;
//print(url);
    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      isServerError=false;

      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      if (status == 1) {
        ProductDetailsModel productDetailsModel=ProductDetailsModel.fromJson(json.decode(response.body));
        productsDetails=productDetailsModel.getProductsDetails;

        price=productsDetails[0].productPrice;
        offer_per=productsDetails[0].offerPercentage;
        final_price=productsDetails[0].finalProductPrice;
        int availablestock=int.parse(productsDetails[0].availableStock);
        if(availablestock<1)
          {
            isout_of_stock=true;
          }

        share_prod_image= await urlToFile(baseUrl+product_base_url+productsDetails[0].productImages[0].productImage);

        product_image = baseUrl+product_base_url+productsDetails[0].productImages[0].productImage;

        getProductColorList();

        getSimillarProducts();

        getReturnRepeatLikedetails();

      }
      else {
      }

      if(mounted){
        setState(() {});
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

  FutureOr onGoBack(dynamic value) {
    getCartProdList(product_id);
  }

  void getProductColorList() {
    Rest_Apis restApis=Rest_Apis();

    restApis.getProductColors(baseUrl,productsDetails[0].productModelAutoId,admin_auto_id,app_type_id).then((value){
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

  showHideAppbar() {
    if(mounted){
      setState(() {
        showAppbar=!showAppbar;
      });
    }
  }

  addToCart() async {

    String cartQty='1';

    if(productsDetails[0].moq.isNotEmpty){
      cartQty=productsDetails[0].moq;
    }

    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    String size='';

    if(productsDetails[0].size.isNotEmpty && selectedSize!=-1){
      size=productsDetails[0].size[selectedSize].sizeAutoId;
    }
    final body = {
      "product_auto_id": product_id,
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
        isAddedTocart=true;
        getCartProdList(product_id);
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
  }

  BuyNow() async {

    String cartQty='1';

    if(productsDetails[0].moq.isNotEmpty){
      cartQty=productsDetails[0].moq;
    }

    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    String size='';

    if(productsDetails[0].size.isNotEmpty && selectedSize!=-1){
      size=productsDetails[0].size[selectedSize].sizeAutoId;
    }
    final body = {
      "product_auto_id": product_id,
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
        isBuynow=true;
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
  }

  bool validation(){
    if(productsDetails[0].size.isNotEmpty && selectedSize==-1){
      Fluttertoast.showToast(msg: "Please select size", backgroundColor: Colors.grey,);
      return false;
    }
    if(isPincodeDeliveryAvailable == false){
      if(getpincode_List.length==0 && userType=='Admin')
      {
        pincodeEmptyAlert();
      }else
      {
        //showAddPincode()
        pincodeUnavaialbleAlert();
      }
      //pincodeUnavaialbleAlert();
      return false;
    }

    return true;
  }

  addToWishlist() async {

    if(mounted){
      setState(() {
        // isApiCallProcessing=true;
        isAddedTowishlist=true;
        Wishlist_count=Wishlist_count+1;
      });
    }

    Rest_Apis restApis=Rest_Apis();

    restApis.addToWishlist(productsDetails[0].productAutoId, user_id, admin_auto_id,baseUrl).then((value){
      if(value!=null && value!=''){
        // isApiCallProcessing=false;
        if(value=='1'){
          isAddedTowishlist=true;
          getReturnRepeatLikedetails();
        }else{
          isAddedTowishlist=false;
        }
        if(mounted){
          setState(() {});
        }
      }
    });

  }

  removeFromWishlist() async {

    if(mounted){
      setState(() {
        // isApiCallProcessing=true;

        if(Wishlist_count==0) {}
        else
        {Wishlist_count = Wishlist_count-1;
        isAddedTowishlist=false;
        }
      });
    }

    Rest_Apis restApis=Rest_Apis();

    restApis.removeFromWishlist(productsDetails[0].productAutoId,user_id, admin_auto_id, baseUrl).then((value){
      if(value!=null){
        // isApiCallProcessing=false;
        if(value==1){
          isAddedTowishlist=false;
          getReturnRepeatLikedetails();
        }else{
          isAddedTowishlist=false;
        }
        if(mounted){
          setState(() {});
        }
      }
    });

  }

  getCartProdList(String productId) async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "user_auto_id": user_id,
      "admin_auto_id": admin_auto_id,
    };

    var url = baseUrl+'api/' + get_cart_product_count;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      if (status == 1) {
        CartCountModel cartCountModel=CartCountModel.fromJson(json.decode(response.body));
        bool isAdded=false;

        cartCount=cartCountModel.productCountData.toString();

        for (var element in cartCountModel.getAdminCartProductLists) {
          if(element.productAutoId==productId){
            isAdded=true;
          }
        }

        isAddedTocart=isAdded;
      }
      else {
        isAddedTocart=false;
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  getWishlistProdList(String productId) async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "user_auto_id": user_id,
      "admin_auto_id": admin_auto_id,
    };

    var url = baseUrl+'api/' + get_wishlist_product_count;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      if (status == 1) {
        WishlistCountModel wishlistCountModel=WishlistCountModel.fromJson(json.decode(response.body));
        bool isAdded=false;

        wishlistProduct=wishlistCountModel.getAdminWishlistProductLists;
       // =wishlistCountModel.productCountData.toString();

        for (var element in wishlistCountModel.getAdminWishlistProductLists) {
          if(element.productAutoId==productId){
            isAdded=true;
          }
        }

        isAddedTowishlist=isAdded;
      }
      else {
        wishlistProduct=[];
        isAddedTowishlist=false;
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  getRatingandReviewData(String productId) async {
    var url = baseUrl + 'api/' + Show_Ratings;

    var uri = Uri.parse(url);
    final body = {
      "product_auto_id": productId,
      "admin_auto_id": admin_auto_id,
      "app_type_id": app_type_id,
    };
    var response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      isApiCallProcessing = false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];

      if (status == 1) {
        RatingAndReviewModel ratingAndReviewModel = RatingAndReviewModel.fromJson(json.decode(response.body));
        RatingAndReviewList = ratingAndReviewModel.getalldata;
        yourReview = ratingAndReviewModel.getcstomerdata;

        total_reviews = ratingAndReviewModel.totalNoOfReviews;
        avg_rating = ratingAndReviewModel.avgRating;
        finishingRating = ratingAndReviewModel.avgFinishing;
        size_fit_rating = ratingAndReviewModel.avgSizeFitting;
        quality_rating = ratingAndReviewModel.avgProductQuality;
        price_rating = ratingAndReviewModel.avgPricing;

      }
      else {
        RatingAndReviewList = [];
        yourReview =[];
        total_reviews = 0;
        avg_rating = 0;
      }
      if (mounted) {
        setState(() {});
      }

    }

    else if (response.statusCode == 500) {
      if (mounted) {
        setState(() {
          isApiCallProcessing = false;
          RatingAndReviewList = [];
          yourReview =[];
          total_reviews = 0;
          avg_rating = 0;

/*          Fluttertoast.showToast(
            msg: 'Server error',
            backgroundColor: Colors.grey,
          );*/
        });
      }
    }
  }

  myReview(GetRatingLists ratinglist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10,),
        const Text(
          'Your Review',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87),
        ),
        Container(
            child: GestureDetector(
                onTap: () => {
                  //showReviewDetails(ratinglist)
                },
                child: Container(
                    margin: const EdgeInsets.all(10),
                    /*  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26)
                ),*/
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              border:Border.all(
                                  color: Colors.orangeAccent
                              ),
                              borderRadius: BorderRadius.circular(2)
                          ),
                          child: Row(
                            children: [
                              Text(ratinglist.rating),
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 15,
                              ),
                            ],
                          ) ,
                        ),
                        Expanded(
                          child:Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ratinglist.review,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.left,
                                  textScaleFactor: 1,
                                  softWrap: true,
                                ),
                                ratinglist.reviewImage.isNotEmpty ?
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 90,
                                  width: 90,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    imageUrl: baseUrl+review_image_base_url + ratinglist.reviewImage,
                                    placeholder: (context, url) => Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.black12,
                                        )),
                                    errorWidget: (context, url, error) => const Icon(
                                      Icons.error,
                                      color: Colors.black26,
                                    ),
                                  )
                                ):
                                Container(),

                                Container(
                                  height: 25,
                                  margin: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        ratinglist.customerName,
                                        style: const TextStyle(color: Colors.black87,fontSize: 12),
                                      ),
                                      const VerticalDivider(
                                        color: Colors.black87,
                                        thickness: 1,
                                        width: 10,
                                        indent: 4,
                                        endIndent: 0,
                                      ),
                                      Text(
                                        getupdatedDate(ratinglist.date),
                                        style: const TextStyle(color: Colors.black87,fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.black54,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )))
        )
      ],
    );
  }

  getSimillarProducts() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "product_auto_id": productsDetails[0].productAutoId,
      "sub_category_auto_id": productsDetails[0].subCategoryAutoId,
      "main_category_auto_id": productsDetails[0].mainCategoryAutoId,
      "admin_auto_id": admin_auto_id,
      "customer_auto_id" : user_id,
      "app_type_id": app_type_id,
    };

    var url = baseUrl+'api/'+ get_simillar_products;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      int  status = resp['status'];

      similarProductList.clear();
      if (status == 1) {
        SimilarProductModel similarProductModel=SimilarProductModel.fromJson(json.decode(response.body));
        similarProductList=similarProductModel.getAdminSubcategoryProductLists;
      }
      else {
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  simillarProductItem(ProductModel product){
    return Container(
      width: 180,
      margin: const EdgeInsets.all(1),
      color: Colors.grey[100],
      child:GestureDetector(
        onTap: ()=>{
          showProductDetails(product.productAutoId)
        },
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Stack(children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.grey[100],
                      child: product.productImages.isNotEmpty
                          ? CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl: baseUrl+product_base_url + product.productImages[0].productImage,
                        placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                            )),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ) :
                      Container(
                          child: const Icon(Icons.error),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                          ))
                  ),
                  product.offerPercentage!='0' && product.offerPercentage!=''?Container(
                    height: 15,
                    width: 45,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                    ),
                    child: Text(
                      product.offerPercentage + "% off",
                      style: const TextStyle(
                          color: Colors.white, fontSize: 11),
                    ),
                  ):Container(),
                ]
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              child: Text(
                                product.productName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 17,color: Colors.black87),
                              ),
                              margin: const EdgeInsets.only(right: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            product.finalProductPrice!=product.productPrice?Text(
                              productsDetails[0].currency + product.productPrice,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough),
                            ):const Text(''),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              productsDetails[0].currency + product.finalProductPrice.toString(),
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                )
            ),
          ],
        ),
      ),

    );
  }

  getReturnRepeatLikedetails() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "product_auto_id": product_id,
      "admin_auto_id": admin_auto_id,
      "app_type_id": app_type_id,
    };

    var url = baseUrl+'api/'+ get_return_repeat_like_details;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      int  status = resp['status'];
print(resp.toString());
      if (status == 1) {
        Wishlist_count=resp['wishlist_count'];
        return_count=resp['return_count'];
        repeat_count=resp['repeat_count'];
      }
      else {
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  showProductDetails(String productId){
    routes = MaterialPageRoute(builder: (context) => ProductDetailScreen(productId));
    Navigator.push(context, routes).then(onGoBack);
  }

  shareProduct() async{

    String message='Check out this product from '+app_name+'\n';
    String productName=productsDetails[0].productName+'\n';
    String productPrice=productsDetails[0].productPrice;
    String finalPrice=productsDetails[0].finalProductPrice.toString();
    String offerPrice=productsDetails[0].offerPercentage;

    // String appLink='https://play.google.com/store/';

    var dynamicLink = await ShareAppLink.createDynamicLinkProduct(product_id, admin_auto_id);

    String price='';

      if(offerPrice!=''){
        price='Original Price: '+productsDetails[0].currency+productPrice+', Get it for '+productsDetails[0].currency
            +finalPrice.toString()+'\nYou get '+offerPrice+'% OFF\n';
      }
      else{
        price='Price: '+productsDetails[0].currency+finalPrice.toString()+'\n';
      }

    Share.shareFiles([share_prod_image.path], text:message+productName+price+dynamicLink.toString());
  }

  shareOnSocialMedia() async{
    String productName=productsDetails[0].productName+'\n';
    String productPrice=productsDetails[0].productPrice;
    String finalPrice=productsDetails[0].finalProductPrice.toString();
    String offerPrice=productsDetails[0].offerPercentage;

    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder( // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (BuildContext context) {
          return SelectSocialShare(product_id, share_prod_image, product_image, admin_auto_id,
          productName, productPrice, finalPrice, offerPrice, app_name, productsDetails[0].currency);
        });
  }

  Future<File> urlToFile(String imageUrl) async {
    var rng = Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File(tempPath+ (rng.nextInt(100)).toString() +'.png');
    Uri uri=Uri.parse(imageUrl);
    http.Response response = await http.get(uri);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future getPin_CodeList() async {

    final body = {
      "user_auto_id": "userAutoId",
      "admin_auto_id" : admin_auto_id,
    };

    var url = baseUrl+'api/' + get_pincode_list;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    if(response.statusCode==200){
      final resp = jsonDecode(response.body);
      int  status = resp['status'];

      if (status == 1) {
        getpincode_List = Get_Pincode_List_Model.fromJson(json.decode(response.body)).getPincodeList!;

        getPincodeData();
      }
      else if(status == 0){
        getpincode_List = [];
        getPincodeData();
      }
      else{
        getpincode_List = [];
        getPincodeData();
      }
    }
    else  if(response.statusCode==500){
      getpincode_List = [];
      getPincodeData();
    }

  }
}
