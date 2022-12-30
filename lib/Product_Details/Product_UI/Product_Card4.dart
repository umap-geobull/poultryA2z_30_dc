import 'package:poultry_a2z/Admin_add_Product/Components/Model/size_model.dart';
import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';


typedef OnAddToCartCallback = void Function(String productAutoId, String moq, List<ProdSize> size);
typedef OnAddToWishlistCallback = void Function(String product_auto_id);
typedef OnRemoveWishlistCallback = void Function(String product_auto_id);
typedef ShowDetailsCallback = void Function(String product_auto_id);

class ProductCard4 extends StatelessWidget {
  ProductCard4(
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
    return
      Container(
        //height: 420,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(15)
        ),
        margin: const EdgeInsets.all(10),
        child:Column(
          children: [
            SizedBox(
              height: 280,
              width: MediaQuery.of(context).size.width,
              child: Stack(children: [
                GestureDetector(
                  onTap: () => {
                    showDetailsCallback(product.productAutoId)
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child:
                    ClipRRect(
                        borderRadius: BorderRadius.only(topRight:Radius.circular(15),topLeft:Radius.circular(15),),

                        child:    product.productImages.isNotEmpty
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
                            ))),
                  ),
                ),

                product.totalNoOfReviews != 0
                    ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.bottomRight,
                  child: totalRatingUi(
                      product.avgRating, product.totalNoOfReviews),
                )
                    : Container(),
              ]),
            ),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          child: Text(
                            product.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 17, fontWeight:FontWeight.bold,color: Colors.black87),
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
                    SizedBox(height: 10,),
                    Text(
                      product.description,
                      maxLines: 2,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14),
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        product.colorName!='' && product.colorName!='Select Color Name'?
                        Text(
                          "Color: " + product.colorName,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13),
                        ):Text(''),

                        product.netWt!=''?
                        Text(
                          " | Net Wt. " + product.netWt,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13),
                        ):
                        Container(),

                        product.grossWt!=''?
                        Text(
                          " | Gross Wt. " + product.grossWt,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13),
                        ):
                        Container(),
                      ],
                    ),
                    SizedBox(height: 5,),

                    product.productPrice.isNotEmpty?
                    Row(
                      children: [
                        Text(
                          product.currency + product.finalProductPrice.toString(),
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          product.currency + product.productPrice,
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                              decoration: TextDecoration.lineThrough),
                        ),
                        product.offerData.isNotEmpty && product.offerData[0].offer.isNotEmpty && product.offerData[0].offer!='0'?
                        Container(
                          height: 15,
                          width: 45,
                          alignment: Alignment.center,
                          child: Text(
                            product.offerData[0].offer + "% off",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green, fontSize: 13),
                          ),
                        ):
                        product.offerPercentage.isNotEmpty && product.offerPercentage!='0'?
                        Container(
                          height: 15,
                          width: 45,
                          alignment: Alignment.center,
                          child: Text(
                            product.offerPercentage + "% off",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green, fontSize: 13),
                          ),
                        ):
                        Container(),

                        SizedBox(width: 10,),
                        Expanded(
                          flex: 1,
                          child:Container(
                            alignment: Alignment.centerRight,
                            child: product.isAdedToCart==true?
                            Container(
                                width: 100,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(5),
                                // margin: const EdgeInsets.all(5),
                                alignment: Alignment.center,
                                child:Text("Added In Cart",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12))
                            ):
                            Container(
                                width: 100,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: primaryButtonColor,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(5),
                                // margin: const EdgeInsets.all(5),

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
                    ):
                    Container(),

                    product.includingTax=='No'&& product.taxPercentage!='0'?
                    Text(
                      "(with "+product.taxPercentage+"% Taxes)",
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.normal
                      ),
                    ):
                    Container(),

                  ],
                )
            ),
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
