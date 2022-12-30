import 'package:poultry_a2z/Admin_add_Product/Components/Model/size_model.dart';
import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';

typedef OnAddToCartCallback = void Function(String productAutoId, String moq, List<ProdSize> size);
typedef OnAddToWishlistCallback = void Function(String product_auto_id);
typedef OnRemoveWishlistCallback = void Function(String product_auto_id);
typedef ShowDetailsCallback = void Function(String product_auto_id);

class Product_Card2 extends StatelessWidget {
  Product_Card2(
      {Key? key,
        required this.baseUrl,
        required this.user_id,
        required this.product,
        required this.onAddToWishlistCallback,
        required this.onAddToCartCallback,
        required this.onRemoveWishlistCallback,
        required this.showDetailsCallback,
        required this.primaryButtonColor,
        required this.secondaryButtonColor,
      })
      : super(key: key);

  String baseUrl;
  String user_id;
  ProductModel product;
  OnAddToWishlistCallback onAddToWishlistCallback;
  OnAddToCartCallback onAddToCartCallback;
  OnRemoveWishlistCallback onRemoveWishlistCallback;
  Color primaryButtonColor;
  Color secondaryButtonColor;
  ShowDetailsCallback showDetailsCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            child: Expanded(
              flex: 3,
              child: GestureDetector(
                child: Container(
                  // width: 90,
                  child: Stack(children: [
                    Container(
                        width: 120,
                        height: 120,
                        child: Container(
                            color: Colors.grey[100],
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                topLeft: Radius.circular(8),
                              ),
                              child: product.productImages.isNotEmpty
                                  ? CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: baseUrl+product_base_url + product.productImages[0].productImage,
                                placeholder: (context, url) => Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                    )),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ) :
                              Container(
                                  child: Icon(Icons.error),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                  )),
                            )
                        )
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child:product.totalNoOfReviews!=0?
                        Container(
                          width: 65,
                          height: 30,
                          alignment: Alignment.bottomRight,
                          child: totalRatingUi(product.avgRating,product.totalNoOfReviews),
                        ):Container())
                  ]),
                ),
                onTap: ()=>{
                  showDetailsCallback(product.productAutoId)
                },
              )),),
          Container(child: Expanded(
              flex: 7,
              child: Container(
                  height: 110,
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: ()=>{
                          showDetailsCallback(product.productAutoId)
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              product.productName,
                              maxLines: 2,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15,
                                  color: Colors.black87,
                              overflow: TextOverflow.ellipsis,),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            product.useBy.isNotEmpty?
                            Text(
                              'Best before: '+product.useBy,
                              style: TextStyle(fontSize: 12,color: Colors.black87),
                            ):
                            Container(),

                            SizedBox(
                              height: 5,
                            ),
                            product.includingTax=='No'&& product.taxPercentage!='0'?
                            Text(
                              "(with "+product.taxPercentage+"% Taxes)",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 8,
                                  fontWeight: FontWeight.normal
                              ),
                            ):Container(),
                            product.productPrice.isNotEmpty?
                            Container(
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  product.productPrice!=product.finalProductPrice?Expanded(
                                flex: 1,
                                child:Text(
                                    product.currency + product.productPrice,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        decoration: TextDecoration.lineThrough),
                                  ),):Container(),
                                  SizedBox(width: 2,),
                              Expanded(
                                flex: 2,
                                child:Text(
                                    product.currency + product.finalProductPrice.toString(),
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),),
                                  SizedBox(width: 2,),
                                  /*  product.offerPercentage!='0'?
                                  Container(
                                    height: 20,
                                    width: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                      color: Colors.green,
                                    ),
                                    child: Text(
                                      product.offerPercentage + "% off",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 11),
                                    ),
                                  ):
                                  Container(),*/

                                  product.offerData.isNotEmpty && product.offerData[0].offer.isNotEmpty && product.offerData[0].offer!='0'?
                                  Expanded(
                                  flex: 2,
                                  child:
                                  Container(
                                    height: 15,
                                    width: 45,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                      color: Colors.green,
                                    ),
                                    child: Text(
                                      product.offerData[0].offer + "% off",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 11),
                                    ),
                                  )):
                                  Expanded(
                                    flex: 2,
                                    child:product.offerPercentage.isNotEmpty && product.offerPercentage!='0'?
                                   Container(
                                    height: 15,
                                    width: 45,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                      color: Colors.green,
                                    ),
                                    child: Text(
                                      product.offerPercentage + "% off",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 11),
                                    ),
                                  ):
                                  Container(),),

                                  SizedBox(width: 2,),
                                  Expanded(
                                      flex: 4,
                                      child: Container(
                                          height: 40,
                                          margin: EdgeInsets.only(left: 10),
                                          alignment: Alignment.centerRight,
                                          // padding: EdgeInsets.only(right:5),
                                          child: product.isAdedToCart==true?
                                           Container(
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius: BorderRadius.circular(5)),
                                                padding: const EdgeInsets.all(5),
                                                margin: const EdgeInsets.only(
                                                  top: 0,
                                                ),
                                                alignment: Alignment.center,
                                                child:Text("Added In Cart",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        //fontWeight: FontWeight.bold,
                                                        fontSize: 11))
                                            ) :
                                          Container(
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    color: primaryButtonColor,
                                                    borderRadius: BorderRadius.circular(5)),
                                                padding: const EdgeInsets.all(5),
                                                margin: const EdgeInsets.only(
                                                  top: 0,
                                                ),
                                                alignment: Alignment.center,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    onAddToCartCallback(product.productAutoId,product.moq,product.size);
                                                  },
                                                  child: Text("Add To Cart",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12)),
                                                )
                                            ),
                                        ),
                                  )
                                ],
                              ),
                            ):
                            Container()
                          ],
                        ),
                      ),
                    ],
                  )
              )
          ),)
        ],
      ),

    );
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

}