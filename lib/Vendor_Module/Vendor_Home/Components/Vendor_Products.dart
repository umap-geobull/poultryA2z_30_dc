import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../Vendor_add_Product/Components/Model/Update_ProductNew.dart';
import '../../Vendor_add_Product/constants.dart';
import '../Utils/App_Apis.dart';
import 'Model/Main_Cat_Size_Model.dart';
import 'Choose_Main_Categories.dart';
import 'Model/Get_Vendor_Product_Model.dart';
import 'Model/Vender_Brand_Product_Model.dart';
import 'Model/Vender_MainCat_Product_Model.dart';
import 'Rest_Apis.dart';

class Vendor_Products extends StatefulWidget {
  Vendor_Products(
      {Key? key,
      required this.main_cat_id,
      required this.sub_cat_id,
      required this.brand_id,
      required this.type,
      required this.vendor_id,
      })
      : super(key: key);
  String main_cat_id;
  String sub_cat_id;
  String brand_id;
  String type;
  String vendor_id;

  @override
  _Vendor_ProductsState createState() => _Vendor_ProductsState();
}

class _Vendor_ProductsState extends State<Vendor_Products> {
  Vender_Cat_Product_Model? vender_cat_product_model;
  List<GetVendorCategoryProductLists>? getMain_Cat_Product = [];

  Vender_Brand_Product_Model? vender_brand_product_model;
  List<GetVendorBrandProductLists>? getBrand_Product = [];
  List<Product_Size_List_Model> sizeLists = [];

  Get_Vendor_Product_Model? _get_vendor_product_model;
  List<GetVendorProductLists>? getProduct_List = [];

  bool isDataAvailable = false;
  List<String> selected_List = [];
  bool isApiCallProcessing = false;
  bool isDeleteProcessing = false;
  String user_id = "",baseUrl="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
    print("brandid=>"+widget.brand_id);
    print("categoryid=>"+widget.main_cat_id);
    print("type=>"+widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text("Products list",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: [
            // IconButton(
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //           builder: (context) => Choose_Main_Categories()),
            //     );
            //   },
            //   icon: Icon(Icons.add_circle_outline, color: Colors.white),
            // ),
          ]),
      body: Container(
        child: widget.type == "brand"
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: getBrand_Product!.length,
                physics: ScrollPhysics(),
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                itemBuilder: (context, index) => productBrandCard(
                    getBrand_Product![index].productAutoId as String,
                    getBrand_Product![index].productName as String,
                    getBrand_Product![index].avg_rating as int,
                    getBrand_Product![index].productImages![0].imageFile as String,
                    getBrand_Product![index].productPrice as String,
                    getBrand_Product![index].offerPercentage as String,
                    getBrand_Product![index].moq as String,
                    getBrand_Product![index].finalProductPrice as String,
                    getBrand_Product![index].size! ,
                    index))
            : widget.type == "category"
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: getMain_Cat_Product!.length,
                    physics: ScrollPhysics(),
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => productBrandCard(
                        getMain_Cat_Product![index].productAutoId as String,
                        getMain_Cat_Product![index].productName as String,
                        getMain_Cat_Product![index].avg_rating as int,
                        getMain_Cat_Product![index]
                            .productImages![0]
                            .productImage as String,
                        getMain_Cat_Product![index].productPrice as String,
                        getMain_Cat_Product![index].offerPercentage as String,
                        getMain_Cat_Product![index].moq as String,
                        getMain_Cat_Product![index].finalProductPrice as String,
                        getMain_Cat_Product![index].size! ,
                        index))
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemCount: getProduct_List!.length,
                    itemBuilder: (context, index) => productBrandCard(
                        getProduct_List![index].productAutoId as String,
                        getProduct_List![index].productName as String,
                        getProduct_List![index].avg_rating as int,
                        getProduct_List![index].productImageLists![0].productImage as String,
                        getProduct_List![index].productPrice as String,
                        getProduct_List![index].offerPercentage as String,
                        getProduct_List![index].moq as String,
                        getProduct_List![index].finalProductPrice as String,
                        getProduct_List![index].size! ,
                        index)),
      ),
    );
  }

  productBrandCard(
      String id,
      String name,
      int rating,
      String image,
      String price,
      String offer,
      String moq,
      String final_price,
      List<Product_Size_List_Model> sizeLists, int index) {
    return Container(
      height: 170,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            child: Stack(children: [
              Container(
                  width: 120,
                  height: 170,
                  child: Container(
                      color: Colors.grey[100],
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          topLeft: Radius.circular(8),
                        ),
                        child: image != ''
                            ? CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: baseUrl+product_img_base_url + image,
                                placeholder: (context, url) => Container(
                                    decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                )),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                            : Container(
                                child: Icon(Icons.error),
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                )),
                      ))),
              Container(
                height: 15,
                width: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                  ),
                  color: Colors.green,
                ),
                child: Text(
                  offer + "% off",
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ]),
          ),
          Expanded(
            flex: 1,
            child: Container(
                height: 170,
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87),
                    ),
                    Container(
                      height: 15,
                      child: RatingBar.builder(
                        itemSize: 20,
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

                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Text(
                            "Sizes: " + getProdSize(sizeLists),
                            style: const TextStyle(color: Colors.black, fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Text(
                            "MOQ: " + moq,
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Text(
                            "Price: ",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          Text(
                            "₹" + price,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "₹" + final_price,
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 35,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: kPrimaryColor,
                                    textStyle: const TextStyle(fontSize: 20)),
                                onPressed: () {},
                                child: Text(
                                  'Add to Cart',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            flex: 1,
                            child: isDeleteProcessing == true
                                ? Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    child: GFLoader(type: GFLoaderType.circle),
                                  )
                                : Container(
                                    height: 35,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: kPrimaryColor,
                                    textStyle: const TextStyle(fontSize: 20)),
                                onPressed: () {
                                  // showAlert(id);
                                },
                                child: Text(
                                  'Add to Cart',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                  ],
                )),
          )
        ],
      ),
    );
  }

  Future<bool> showAlert(String product_id) async {
    return await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: Text(
            'Are you sure?',
            style: TextStyle(color: Colors.black87),
          ),
          content: Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Do you want delete this product',
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Delete_Product(product_id);
                          },
                          child: Text("Yes",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green[200],
                            onPrimary: Colors.green,
                            //minimumSize: Size(70, 30),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                            ),
                          ),
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("No",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue[200],
                            onPrimary: Colors.blue,
                            // minimumSize: Size(70, 30),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                            ),
                          ),
                        )),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if(baseUrl!=null){
      setState(() {
        this.baseUrl=baseUrl;
        user_id=widget.vendor_id;
        if (widget.type == "brand") {
          getBrand_Product_List(widget.brand_id, user_id);
        } else if (widget.type == "category") {
          getCat_ProductList(widget.main_cat_id, user_id);
        } else {
          getVendor_Product(user_id);
        }
        print(baseUrl);
      });
    }
    return null;
  }

  void Delete_Product(String product_id) {
    if (this.mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }

    Rest_Apis restApis = new Rest_Apis();

    restApis.Delete_Product(product_id,baseUrl).then((value) {
      if (value != null) {
        isApiCallProcessing = false;
        int status = value;
        if (status == 1) {
          Fluttertoast.showToast(
            msg: "Product Deleted successfully",
            backgroundColor: Colors.grey,
          );
          if (widget.type == "brand") {
            getBrand_Product_List(widget.brand_id, user_id);
          } else if (widget.type == "category") {
            getCat_ProductList(widget.main_cat_id, user_id);
          } else {
            getVendor_Product(user_id);
          }
        } else {
          Fluttertoast.showToast(
            msg: "Something went wrong",
            backgroundColor: Colors.grey,
          );
        }

        if (this.mounted) {
          setState(() {});
        }
      }
    });
  }

  // Future<String?> getUserId() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userId = prefs.getString('user_id');
  //
  //   if (userId != null) {
  //     if (mounted) {
  //       setState(() {
  //
  //         /* widget.type == "brand"
  //             ? getBrand_Product_List(widget.brand_id, userId)
  //             : widget.type == "category"
  //                 ? getCat_ProductList(widget.main_cat_id, userId)
  //                 : getVendor_Product(user_id);*/
  //       });
  //     }
  //   }
  //   return null;
  // }

  void getBrand_Product_List(String brand_id, String userId) async {
    Rest_Apis restApis = new Rest_Apis();

    restApis.getVendor_Brand_Product(brand_id, userId,baseUrl).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            vender_brand_product_model = value;
          });
        }

        if (vender_brand_product_model != null) {
          if (mounted) {
            setState(() {
              isDataAvailable = true;
              getBrand_Product =
                  vender_brand_product_model?.getVendorBrandProductLists;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isDataAvailable = false;
            });
          }

          Fluttertoast.showToast(
            msg: "No product found",
            backgroundColor: Colors.grey,
          );
        }
      } else {
        if (mounted) {
          setState(() {
            isDataAvailable = false;
          });
        }

        Fluttertoast.showToast(
          msg: "No product found",
          backgroundColor: Colors.grey,
        );
      }
    });
  }

  void getCat_ProductList(String main_cat_id, String userId) async {
    Rest_Apis restApis = new Rest_Apis();

    restApis.getVender_MainCat_Product(main_cat_id, userId,baseUrl).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            vender_cat_product_model = value;
          });
        }

        if (vender_cat_product_model != null) {
          if (mounted) {
            setState(() {
              isDataAvailable = true;
              getMain_Cat_Product =
                  vender_cat_product_model?.getVendorCategoryProductLists;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isDataAvailable = false;
            });
          }

          Fluttertoast.showToast(
            msg: "No product found",
            backgroundColor: Colors.grey,
          );
        }
      } else {
        if (mounted) {
          setState(() {
            isDataAvailable = false;
          });
        }

        Fluttertoast.showToast(
          msg: "No product found",
          backgroundColor: Colors.grey,
        );
      }
    });
  }

  void getVendor_Product(String user_id) async {
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
            setState(() => {
                  isDataAvailable = true,
                  getProduct_List =
                      _get_vendor_product_model?.getVendorProductLists,
                });
          }
        } else {
          Fluttertoast.showToast(
            msg: "No Product found",
            backgroundColor: Colors.grey,
          );
        }
      }
    });
  }

  String getProdSize(List<Product_Size_List_Model> sizeLists){
    String size='';

    for(int i=0;i<sizeLists.length;i++){
      if(i==0){
        size+=sizeLists[i].sizeName! ;
      }
      else {
        size+=','+ sizeLists[i].sizeName! ;
      }
    }
    return size;
  }

  showEditPage(String producyId) {
     Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => Update_Product(
                product_id: producyId,
            vendor_id: user_id,
              )),
    );
    /*routes = MaterialPageRoute(builder: (context) => Update_Product(product_id: producyId,));
    Navigator.push(context, routes).then(onGoBack);*/
  }
}
