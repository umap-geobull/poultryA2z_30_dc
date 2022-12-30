import 'package:poultry_a2z/Admin_add_Product/Components/Model/size_model.dart';
import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';


typedef OnAddToCartCallback = void Function(String productAutoId, String moq, List<ProdSize> size);
typedef OnAddToWishlistCallback = void Function(String product_auto_id);
typedef OnRemoveWishlistCallback = void Function(String product_auto_id);
typedef ShowDetailsCallback = void Function(String product_auto_id);


class ProductCard3 extends StatelessWidget {
  ProductCard3(
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
      margin: const EdgeInsets.all(1),
      color: Colors.white,
      child:Column(
        children: [
          Expanded(
            flex: 10,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(children: [
                GestureDetector(
                  onTap: () => {
                    showDetailsCallback(product.productAutoId)
                  },
                  child:
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.grey[100],
                      child: product.productImages.isNotEmpty
                          ? CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: baseUrl +
                            product_base_url +
                            product.productImages[0].productImage,
                        placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                            )),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                      )
                          : Container(
                          child: const Icon(Icons.error),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                          ))),),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.topRight,
                  child: product.newArrival!='Yes'?Container(
                    height: 25,
                    width: 45,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text(
                      'New',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ):Container(),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.bottomRight,
                  child:
                  product.offerData.isNotEmpty && product.offerData[0].offer.isNotEmpty && product.offerData[0].offer!='0'?
                  Container(
                    height: 25,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.orangeAccent,
                    ),
                    child: Text(
                      product.offerData[0].offer + "% off",
                      style: const TextStyle(
                          color: Colors.white, fontSize: 11),
                    ),
                  ):
                  product.offerPercentage.isNotEmpty && product.offerPercentage!='0'?
                  Container(
                    height: 25,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.orangeAccent,
                    ),
                    child: Text(
                      product.offerPercentage + "% off",
                      style: const TextStyle(
                          color: Colors.white, fontSize: 11),
                    ),
                  ):
                  Container(),

                )
              ]),
            ),),
          Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      product.productName,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 15, color: Colors.black87),
                    ),
                    margin: const EdgeInsets.only(right: 2),
                  ),

                  product.productPrice.isNotEmpty?
                  Row(
                    children: [
                      Text(
                        product.currency + product.productPrice,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        product.currency + product.finalProductPrice.toString(),
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      product.avgRating != 0
                          ? Container(
                        width: 40,
                        height: 30,
                        alignment: Alignment.bottomRight,
                        child: totalRatingUi(
                            product.avgRating, product.totalNoOfReviews),
                      ) : Container(height: 30,),
                    ],
                  ):
                  Container(
                      height: 35
                  ),
                  Row(children: [
                    Expanded(
                      flex: 1,
                      child:  product.includingTax=='No'&& product.taxPercentage!='0'?
                      Text(
                        "(with "+product.taxPercentage+"% Taxes)",
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.normal
                        ),
                      ): Container(),),
                  ],),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            width: 50,
                            child: GestureDetector(
                              child:
                              product.isAddedToWishlist==true
                                  ? const Icon(
                                Icons.favorite_rounded,
                                size: 30,
                                color: Colors.red,
                              )
                                  : const Icon(
                                Icons.favorite_outline_rounded,
                                color: Colors.black,
                              ),
                              onTap: () => {
                                if (product.isAddedToWishlist==true){
                                  onRemoveWishlistCallback(product.productAutoId)
                                }
                                else {
                                  onAddToWishlistCallback(product.productAutoId)
                                }
                              },
                            ),
                          )),

                      Expanded(
                          flex:2,
                          child: product.productPrice.isNotEmpty?
                          Container(
                              child:
                              product.isAdedToCart==true?
                              Container(
                                  height: 30,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(2)),
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  child:Text("Added In Cart",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12))
                              ):
                              Container(
                                  height: 30,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: primaryButtonColor,
                                      borderRadius: BorderRadius.circular(2)),
                                  padding: const EdgeInsets.all(5),
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
                              )
                          ):
                          Container()
                      )

                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  totalRatingUi(int avgRating, int totalNoOfReviews) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: 40,
      height: 25,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.star,
            color: Colors.orangeAccent,
            size: 15,
          ),
          Text(
            avgRating.toString(),
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),

          // Text(
          //   '| ' + totalNoOfReviews.toString(),
          //   style: const TextStyle(
          //     color: Colors.black54,
          //     fontSize: 10,
          //   ),
          // ),
        ],
      ),
    );
  }
}
