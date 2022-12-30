import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/size_model.dart';
import 'package:poultry_a2z/Product_Details/product_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../Product_Details/model/Product_Model.dart';
import '../../Utils/App_Apis.dart';
import '../../Utils/constants.dart';
import 'Update_ProductNew.dart';

typedef OnDeleteCallback = void Function(String product_auto_id);
typedef EditCallback = void Function(String product_auto_id);
typedef ShowDetailsCallback = void Function(String product_auto_id);

class ProductCardAdmin extends StatelessWidget {
  ProductCardAdmin(
      {Key? key,
        required this.baseUrl,
        required this.user_id,
        required this.product,
        required this.onDeleteCallback,
        required this.editCallback,
        required this.showDetailsCallback
      })
      : super(key: key);

  String baseUrl;
  String user_id;
  ProductModel product;
  OnDeleteCallback onDeleteCallback;
  //OnGoBackCallback onGoBackCallback;
  EditCallback editCallback;
  ShowDetailsCallback showDetailsCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          GestureDetector(
            child: SizedBox(
              width: 120,
              child: Stack(children: [
                SizedBox(
                    width: 120,
                    height: 170,
                    child: Container(
                        color: Colors.grey[100],
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
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
                            const Icon(Icons.error),
                          ) :
                          Container(
                              child: const Icon(Icons.error),
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                              )),
                        )
                    )
                ),
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
                Align(
                    alignment: Alignment.bottomRight,
                    child:product.totalNoOfReviews!=0?Container(
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
          ),
          Expanded(
              flex: 1,
              child: Container(
                  height: 170,
                  padding: const EdgeInsets.all(10),
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
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15,color: Colors.black87),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "Sizes: ${getProdSize(product.size)}",
                                    style:
                                    const TextStyle(color: Colors.black, fontSize: 14),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "MOQ: " + product.moq,
                                    style:
                                    const TextStyle(color: Colors.black, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 5),
                                child:
                                product.productPrice.isNotEmpty?
                                Row(
                                  children: [
                                    const Text(
                                      "Price: ",
                                      style:
                                      TextStyle(color: Colors.black, fontSize: 14),
                                    ),
                                    product.finalProductPrice!=product.productPrice?
                                    Text(product.currency + product.productPrice,
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 13,
                                          decoration: TextDecoration.lineThrough),
                                    ):
                                    Text(''),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      product.currency + product.finalProductPrice.toString(),
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    /* product.includingTax=='No'&& product.taxPercentage!='0'?
                                  Text(
                                    "(with "+product.taxPercentage+"% Taxes)",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal
                                    ),
                                  ):const Text(''),*/
                                  ],
                                ):
                                Container()
                            ),
                            product.includingTax=='No'&& product.taxPercentage!='0'?
                            Text(
                              "(including "+product.taxPercentage+"% Taxes)",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal
                              ),
                            ) :Text(''),
                          ],
                        ),
                      ),
                      Expanded(
                          child:Container(
                            height: MediaQuery.of(context).size.height,
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 35,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: kPrimaryColor,
                                          textStyle: const TextStyle(fontSize: 20)),
                                      onPressed: () {
                                        editCallback(product.productAutoId);
                                      },
                                      child: const Center(
                                        child: Text(
                                          'Edit',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 35,
                                    child:  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: kPrimaryColor,
                                          textStyle: const TextStyle(fontSize: 20)),
                                      onPressed: () {
                                        onDeleteCallback(product.productAutoId);
                                      },
                                      child: const Center(
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ) ,
                                    /* child: RaisedButton(
                                      child: const Center(
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      textColor: Colors.white,
                                      color: kPrimaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5)),
                                      onPressed: () {
                                        showAlert(product.productAutoId);
                                      },
                                    ),*/
                                  ),
                                ),
                              ],
                            )
                            ,
                          ))
                    ],
                  )
              )
          )
        ],
      ),

    );
  }

  String getProdSize(List<ProdSize> sizeLists){
    String size='';

    for(int i=0;i<sizeLists.length;i++){
      if(i==0){
        size+=sizeLists[i].sizeName;
      }
      else {
        size+=','+sizeLists[i].sizeName;
      }
    }
    return size;
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