import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../Utils/size_config.dart';
import '../Utils/App_Apis.dart';
import '../Utils/constants.dart';
import 'Model/Get_Vendor_Product_Model.dart';
import 'Rest_Apis.dart';
import 'Vendor_Products.dart';

class Best_Selling_Product extends StatefulWidget {
  late String Vendor_id;
  Best_Selling_Product(String id)
  {
    this.Vendor_id=id;
  }
  @override
  _Best_Selling_ProductState createState() => _Best_Selling_ProductState();
}

class _Best_Selling_ProductState extends State<Best_Selling_Product> {
  bool isDataAvaiable = false;
  String user_id = "";
  Get_Vendor_Product_Model? _get_vendor_product_model;
  List<GetVendorProductLists>? getProduct_List = [];
  String baseUrl="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
    user_id=widget.Vendor_id;
    getVendor_Product();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 10),
                  child: Text("Best Selling Product",
                      style: TextStyle(fontSize: 16, color: Colors.black))),
            ),
            Expanded(
              flex: 3,
              child: GestureDetector(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: kPrimaryColor, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Show All",
                        style: TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Vendor_Products(main_cat_id: '',
                        brand_id: '', type: "show_all", sub_cat_id: '',vendor_id: user_id,)));
                },
              ),
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Container(
            height: 177,
            child: isDataAvaiable
                ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: getProduct_List!.length,
                itemBuilder: (context, index) =>
                    CategoryCard(
                      icon: getProduct_List![index].productImageLists![0].productImage,
                      text: getProduct_List![index].productName,
                      rating: getProduct_List![index].avg_rating,
                      price: getProduct_List![index].productPrice,
                      final_price: getProduct_List![index].finalProductPrice,
                      offer: getProduct_List![index].offerPercentage,
                      moq: getProduct_List![index].moq,
                      press: () => {},
                    ))
                : Container()),
      ],
    );
  }

  void getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');

    if (baseUrl != null) {
      this.baseUrl = baseUrl;
    }
  }

  void getVendor_Product() async {
    Rest_Apis restApis = new Rest_Apis();

    restApis.getVendor_ProductList(user_id,baseUrl).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            _get_vendor_product_model = value;
          });
        }

        if (_get_vendor_product_model != null) {
          if (mounted) {
            setState(() =>
            {
              isDataAvaiable = true,
              getProduct_List =
                  _get_vendor_product_model?.getVendorProductLists,
            });
          }
        } else {
          Fluttertoast.showToast(
            msg: "No category found",
            backgroundColor: Colors.grey,
          );
        }
      }
    });
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId != null) {
      if (mounted) {
        setState(() {
          user_id = userId;
        });
      }

      getVendor_Product();
    }
    return null;
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({Key? key,
    required this.icon,
    required this.text,
    required this.rating,
    required this.price,
    required this.final_price,
    required this.press,
    required this.offer,
    required this.moq})
      : super(key: key);

  final String? icon, text, price, final_price, offer, moq;
  final int? rating;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: 170,
        height: 190,
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: Column(

            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 80,
                  child: Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                      height: 80,
                      width: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: icon != ''
                            ? CachedNetworkImage(
                          height: 80,
                          width: 80,
                          imageUrl: product_img_base_url + icon!,
                          placeholder: (context, url) =>
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.grey[400],
                                  )),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )
                            : Container(
                            child: Icon(Icons.error),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey[400],
                            )),
                      )),
                ),
              ),
              Container(
                height: 100,
                color: kPrimaryLightColor,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          child: Text(
                            text!,
                            style:
                            TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ),

                      Container(
                        height: 15,
                        child: RatingBar.builder(
                          itemSize: 15,
                          initialRating: double.parse(rating.toString()),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          onRatingUpdate: (rating) {
                           // print(rating);
                          },
                        ),
                      ),


                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "₹" + final_price!,
                              style:
                              TextStyle(color: Colors.blue, fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  "₹" + price!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              )),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          child: Text(
                            "MOQ - " + moq! + " Quantity",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
