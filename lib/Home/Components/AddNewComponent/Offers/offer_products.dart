import 'dart:async';
import 'dart:convert';
import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';
import 'package:poultry_a2z/Product_Details/product_details_screen.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
// import 'package:badges/badges.dart';

import '../../../../Admin_add_Product/Components/Model/Rest_Apis.dart';
import '../../../../Admin_add_Product/constants.dart';
import '../../../../Cart/Cart_Screen.dart';
import '../../../../Cart/model/cart_count_model.dart';
import '../../../../Utils/App_Apis.dart';
import '../../../../Wishlist/model/wishlist_count_model.dart';
import '../models/offer_product_model.dart';

class Offer_Products extends StatefulWidget {
  Offer_Products(
      {Key? key,
      required this.offer_id})
      : super(key: key);
  String offer_id;

  @override
  _Offer_Products createState() => _Offer_Products();
}

class _Offer_Products extends State<Offer_Products> {
  List<ProductModel> productList = [];

  late Route routes;

  bool isApiCallProcessing=true;
  bool isDeleteProcessing=false;
  String user_id='';

  String cartCount='0';

  String baseUrl='',admin_auto_id='',app_type_id='';

  List<GetAdminWishlistProductLists> wishlistProduct=[];

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');

    if(baseUrl!=null && adminId!=null && userId!=null && apptypeid!=null){
      this.admin_auto_id=adminId;
      this.baseUrl=baseUrl;
      this.user_id=userId;
      this.app_type_id=apptypeid;

      if(mounted){
        setState(() {});
      }
      getProducts();
      getWishlistProdList();
      getCartProdList();
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
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: const Text("",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            leading: IconButton(
              onPressed: ()=>{
                Navigator.of(context).pop()
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),

            actions: [
              //_shoppingCartBadge(),
            ]

        ),
        body:Stack(
          children: <Widget>[
            isApiCallProcessing==false && productList.isEmpty?
            Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: const Text('No products available')
            ):
            Container(),

            Container(

            child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1/1.6,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1
                    ),
                    itemCount: productList.length,
                    itemBuilder: (context, index) =>
                        productCard(productList[index])
                )
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
        )
    );
  }

  getCartProdList() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "user_auto_id": user_id,
    };

    print("user_id=>"+user_id);

    var url = baseUrl+'api/' + get_cart_product_count;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        CartCountModel cartCountModel=CartCountModel.fromJson(json.decode(response.body));
        cartCount=cartCountModel.productCountData.toString();
      }
      else{
        cartCount='0';
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  gotoCartScreen(){
    routes = MaterialPageRoute(builder: (context) => const Cart_Screen());
    Navigator.push(context, routes).then(onGoBackFromCart);
  }

  FutureOr onGoBackFromCart(dynamic value) {

  }

  productCard(ProductModel product){
    return Container(
      margin: const EdgeInsets.all(1),
      color: Colors.white,
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
                    product.offerData.isNotEmpty && product.offerData[0].offer.isNotEmpty?
                    Container(
                      height: 15,
                      width: 45,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                      ),
                      child:
                      Text(product.offerData[0].offer + "% off",
                        style: const TextStyle(
                            color: Colors.white, fontSize: 11),
                      ),
                    ):
                    product.offerPercentage.isNotEmpty?
                    Container(
                      height: 15,
                      width: 45,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                      ),
                      child:
                          Text(product.offerPercentage + "% off",
                        style: const TextStyle(
                            color: Colors.white, fontSize: 11),
                      ),
                    ):
                    Container(),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.bottomRight,
                      child: totalRatingUi(),
                    ),
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
                            Container(
                              alignment: Alignment.topRight,
                              width: MediaQuery.of(context).size.width,
                              child: GestureDetector(
                                child: checkWishlistProduct(product.productAutoId)==true?
                                const Icon(Icons.favorite_rounded,color: Colors.red,):
                                const Icon(Icons.favorite_outline_rounded,color: Colors.black,),
                                onTap: ()=>{
                                  if(checkWishlistProduct(product.productAutoId)==true){
                                    removeFromWishlist(product.productAutoId)
                                  }
                                  else{
                                    addToWishlist(product.productAutoId)
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            Text(
                              "₹" + product.productPrice,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "₹" + product.finalProductPrice.toString(),
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          flex:1,
                          child:                         Container(
                            height: MediaQuery.of(context).size.height,
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child:Container(
                                    decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.circular(2)
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.only(top: 5,),
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: (){
                                      },
                                      child: const Text("Add To Cart",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white,
                                              fontWeight: FontWeight.bold,fontSize: 13)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                Expanded(
                                  flex: 1,
                                  child:Container(
                                    decoration: BoxDecoration(
                                        color: Colors.orangeAccent,
                                        borderRadius: BorderRadius.circular(2)
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.only(top: 5,),
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: (){
                                      },
                                      child: const Text("Buy Now",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white,
                                              fontWeight: FontWeight.bold,fontSize: 13)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                )
              ),
            ],
          ),
        ),

    );
  }

  totalRatingUi(){
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
          children: const <Widget>[
            Text('4.7',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 10,
              ),
            ),
            Icon(Icons.star,color: Colors.orangeAccent,size: 10,),
            Text('| 60',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
  }

  showProductDetails(String productId){
    routes = MaterialPageRoute(builder: (context) => ProductDetailScreen(productId));
    Navigator.push(context, routes);
  }

  FutureOr onGoBack(dynamic value) {
    getProducts();
    getCartProdList();
  }

  getProducts() async {
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

    print("offer_id=>"+widget.offer_id);

    var url = baseUrl+'api/' + get_offer_products;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());

      productList.clear();
      if (status == 1) {
        OfferProductModel offerProductModel=OfferProductModel.fromJson(json.decode(response.body));
        productList=offerProductModel.getAdminOfferProductLists;
        isApiCallProcessing=false;
      }
      else {
        print('empty');
        isApiCallProcessing=false;
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  addToWishlist(String productAutoId) async {
    Rest_Apis restApis=Rest_Apis();

    restApis.addToWishlist(productAutoId, user_id, admin_auto_id, baseUrl).then((value){
      if(value!=null && value!=''){
        isApiCallProcessing=false;
        if(value=='1'){
          getWishlistProdList();
        }
        if(mounted){
          setState(() {});
        }
      }
    });

  }

  removeFromWishlist(String productAutoId) async {
    Rest_Apis restApis=Rest_Apis();

    restApis.removeFromWishlist(productAutoId, user_id, admin_auto_id, baseUrl).then((value){
      if(value!=null){
        isApiCallProcessing=false;
        if(value==1){
          getWishlistProdList();
        }
        if(mounted){
          setState(() {});
        }
      }
    });

  }

  getWishlistProdList() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "user_auto_id": user_id,
      "admin_auto_id":admin_auto_id,
    };

    print("user_id=>"+user_id);

    var url = baseUrl+'api/' + get_wishlist_product_count;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        WishlistCountModel wishlistCountModel=WishlistCountModel.fromJson(json.decode(response.body));
        wishlistProduct=wishlistCountModel.getAdminWishlistProductLists;
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  bool checkWishlistProduct(String productAutoId){
    for(int i=0;i<wishlistProduct.length;i++){
      if(productAutoId==wishlistProduct[i].productAutoId){
        return true;
      }
    }

    return false;
  }

}