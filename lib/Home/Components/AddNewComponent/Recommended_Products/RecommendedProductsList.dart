import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';

import '../../../../Product_Details/model/Product_Model.dart';
import '../../../../Product_Details/product_details_screen.dart';
import '../../../../Utils/App_Apis.dart';
import 'Recommended_ListModel.dart';

class Recommended_Products extends StatefulWidget{
  @override
  Recommended_ProductsState createState() => Recommended_ProductsState();

}

class Recommended_ProductsState extends State<Recommended_Products>{
  bool isApiCallProcessing=false;
  String baseUrl='',admin_auto_id='',app_type_id='';
  String user_id='';
  List<ProductModel> recommended_products=[];
  late Route routes;

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');
    String? userId = prefs.getString('user_id');
    String? apptypeid= prefs.getString('app_type_id');

    if (userId != null && baseUrl!=null && adminId!=null && apptypeid!=null) {
      setState(() {
        this.user_id = userId;
        this.baseUrl=baseUrl;
        this.admin_auto_id=adminId;
        this.app_type_id=apptypeid;
        getRecommended_Product();
      });
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
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    print("customer_auto_id=>"+user_id);

    var url = baseUrl+'api/' + get_recommended_products;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing = false;

      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());

      if (status == 1) {
        Recommended_ListModel recommendedListModel=Recommended_ListModel.fromJson(json.decode(response.body));
        recommended_products=recommendedListModel.getRecommendedProductsLists;
      }
      else {
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
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar:  AppBar(
         backgroundColor: kPrimaryColor,
         title: const Text(
           'Recomended Products'
         ),
         actions: const [
         ]
     ),
     body: Stack(
children: [
  Container(child:GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1/1.6,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1
      ),
      itemCount: recommended_products.length,
      itemBuilder: (context, index) =>
          productCategoryCard(recommended_products[index])
  ),),

  isApiCallProcessing==false && recommended_products.isEmpty ?
  Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: const Text('No products available')
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
     )
   );
  }

  productCategoryCard(ProductModel product){
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
                  Container(
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
                  ),
                  product.avgRating!=0?Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.bottomRight,
                    child: totalRatingUi(product.avgRating,product.totalNoOfReviews),
                  ):Container(),
                ]
                ),
              ),
            ),
            Expanded(
                flex: 4,
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
                            // Container(
                            //   alignment: Alignment.topRight,
                            //   width: MediaQuery.of(context).size.width,
                            //   child: GestureDetector(
                            //     child: checkWishlistProduct(product.productAutoId)==true?
                            //     Icon(Icons.favorite_rounded,color: Colors.red,):
                            //     Icon(Icons.favorite_outline_rounded,color: Colors.black,),
                            //     onTap: ()=>{
                            //       if(checkWishlistProduct(product.productAutoId)==true){
                            //         removeFromWishlist(product.productAutoId)
                            //       }
                            //       else{
                            //         addToWishlist(product.productAutoId)
                            //       }
                            //     },
                            //   ),
                            // )
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
                        // Expanded(
                        //   flex:1,
                        //   child:                         Container(
                        //     height: MediaQuery.of(context).size.height,
                        //     alignment: Alignment.bottomCenter,
                        //     child: Row(
                        //       children: [
                        //         Expanded(
                        //           flex: 1,
                        //           child:Container(
                        //             decoration: BoxDecoration(
                        //                 color: kPrimaryColor,
                        //                 borderRadius: BorderRadius.circular(2)
                        //             ),
                        //             padding: EdgeInsets.all(5),
                        //             margin: EdgeInsets.only(top: 5,),
                        //             alignment: Alignment.center,
                        //             child: GestureDetector(
                        //               onTap: (){
                        //               },
                        //               child: Text("Add To Cart",
                        //                   textAlign: TextAlign.center,
                        //                   style: TextStyle(color: Colors.white,
                        //                       fontWeight: FontWeight.bold,fontSize: 12)),
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(width: 5,),
                        //         Expanded(
                        //           flex: 1,
                        //           child:Container(
                        //             decoration: BoxDecoration(
                        //                 color: Colors.orangeAccent,
                        //                 borderRadius: BorderRadius.circular(2)
                        //             ),
                        //             padding: EdgeInsets.all(5),
                        //             margin: EdgeInsets.only(top: 5,),
                        //             alignment: Alignment.center,
                        //             child: GestureDetector(
                        //               onTap: (){
                        //               },
                        //               child: Text("Buy Now",
                        //                   textAlign: TextAlign.center,
                        //                   style: TextStyle(color: Colors.white,
                        //                       fontWeight: FontWeight.bold,fontSize: 12)),
                        //             ),
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    )
                )
            ),
          ],
        ),
      ),

    );
  }

  showProductDetails(String productId){
    routes = MaterialPageRoute(builder: (context) => ProductDetailScreen(productId));
    Navigator.push(context, routes).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    getBaseUrl();
    getRecommended_Product();
  }

  totalRatingUi(int avgRating, int totalNoOfReviews){
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
          Text(avgRating.toString(),
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 10,
            ),
          ),
          const Icon(Icons.star,color: Colors.orangeAccent,size: 10,),
          Text('| '+totalNoOfReviews.toString(),
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}