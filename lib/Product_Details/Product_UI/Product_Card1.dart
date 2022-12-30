import 'dart:async';
import 'dart:convert';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/size_model.dart';
import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';
import 'package:poultry_a2z/Product_Details/product_details_screen.dart';
import 'package:poultry_a2z/Product_Details/select_prod_size_bottomsheet.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnAddToCartCallback = void Function(String productAutoId, String moq, List<ProdSize> size);
typedef OnBuyNowCallback = void Function(String productAutoId, String moq, List<ProdSize> size);
typedef OnAddToWishlistCallback = void Function(String product_auto_id);
typedef OnRemoveWishlistCallback = void Function(String product_auto_id);
typedef ShowDetailsCallback = void Function(String product_auto_id);


class ProductCard1 extends StatelessWidget {
  ProductCard1(
      {Key? key,
        required this.baseUrl,
        required this.user_id,
        required this.product,
        required this.onAddToWishlistCallback,
        required this.onAddToCartCallback,
        required this.onRemoveWishlistCallback,
        required this.onBuyNowCallback,
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
  OnBuyNowCallback onBuyNowCallback;
  Color primaryButtonColor;
  Color secondaryButtonColor;
  ShowDetailsCallback showDetailsCallback;

  @override
  Widget build(BuildContext context) {
    return
      Container(
        margin: const EdgeInsets.all(1),
        color: Colors.white,
        child:Column(
          children: [
            Expanded(
              flex: 7,
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
                          fit: BoxFit.contain,
                          imageUrl: baseUrl + product_base_url + product.productImages[0].productImage,
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

                  product.offerData.isNotEmpty && product.offerData[0].offer.isNotEmpty && product.offerData[0].offer!='0'?
                  Container(
                    height: 15,
                    width: 45,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                      ),
                      color: Colors.green,
                    ),
                    child: Text(
                      product.offerData[0].offer + "% off",
                      style: const TextStyle(
                          color: Colors.white, fontSize: 11),
                    ),
                  ):
                  product.offerPercentage.isNotEmpty && product.offerPercentage!='0'?
                  Container(
                    height: 15,
                    width: 45,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                      ),
                      color: Colors.green,
                    ),
                    child: Text(
                      product.offerPercentage + "% off",
                      style: const TextStyle(
                          color: Colors.white, fontSize: 11),
                    ),
                  ):
                  Container(),

                  product.totalNoOfReviews != 0 ?
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.bottomRight,
                    child: totalRatingUi(
                        product.avgRating, product.totalNoOfReviews),
                  ) : Container(),
                ]),
              ),),
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
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.black87),
                              ),
                              margin: const EdgeInsets.only(right: 20),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              width: MediaQuery.of(context).size.width,
                              child: GestureDetector(
                                child:
                                product.isAddedToWishlist==true
                                    ? const Icon(
                                  Icons.favorite_rounded,
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
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        product.productPrice.isNotEmpty?
                        Row(
                          children: [
                            Text(
                              product.currency + product.productPrice,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              product.currency + product.finalProductPrice.toString(),
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            product.includingTax=='No'&& product.taxPercentage!='0'?
                            Text(
                              "(with "+product.taxPercentage+"% Taxes)",
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal
                              ),
                            ):const Text(''),
                          ],
                        ):
                        Container(),

                        product.productPrice.isNotEmpty?
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin: const EdgeInsets.only(
                                top: 5,
                              ),
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                child: Row(
                                  children: [
                                    product.isAdedToCart==true?
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(2)),
                                          padding: const EdgeInsets.all(2),
                                          alignment: Alignment.center,
                                          child:Text("Added In Cart",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 9))
                                      ),
                                    ):
                                    Expanded(
                                      flex: 1,
                                      child: Container(
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
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: secondaryButtonColor,
                                            borderRadius: BorderRadius.circular(2)),
                                        padding: const EdgeInsets.all(5),
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: () {
                                            onBuyNowCallback(product.productAutoId,product.moq,product.size);
                                          },
                                          child: const Text("Buy Now",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12)),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                height: 35,
                              )
                          ),
                        ):
                        Container()
                      ],
                    ))),
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
