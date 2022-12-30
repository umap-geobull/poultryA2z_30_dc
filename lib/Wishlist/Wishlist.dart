import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/size_model.dart';
import 'package:poultry_a2z/BuyNow/buy_now_screen.dart';
import 'package:poultry_a2z/Cart/model/cart_count_model.dart';
import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';
import 'package:poultry_a2z/Product_Details/select_prod_size_bottomsheet.dart';
import 'package:poultry_a2z/Wishlist/wishlist_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Product_Details/product_details_screen.dart';
import '../Utils/App_Apis.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getwidget/getwidget.dart';
import '../Utils/coustom_bottom_nav_bar.dart';
import '../Utils/enums.dart';

class Wishlist extends StatefulWidget {
  @override
  State<Wishlist> createState() => WishlistState();
}

class WishlistState extends State<Wishlist> {
  String user_id='';
  String baseUrl='', admin_auto_id='';
  bool isApiCallProcessing=false;

  List<ProductModel> wishlist = [];

  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;
  Color bototmBarColor=Colors.white, bottomMenuIconColor=Color(0xFFFF7643);

  void getappUi() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? appBarColor =prefs.getString('appbarColor');
    String? appbarIcon =prefs.getString('appbarIconColor');
    String? bottomBarColor =prefs.getString('bottomBarColor');
    String? bottombarIcon =prefs.getString('bottomBarIconColor');
    String? primaryButtonColor =prefs.getString('primaryButtonColor');
    String? secondaryButtonColor =prefs.getString('secondaryButtonColor');

    if(primaryButtonColor!=null){
      this.primaryButtonColor=Color(int.parse(primaryButtonColor));
    }

    if(secondaryButtonColor!=null){
      this.secondaryButtonColor=Color(int.parse(secondaryButtonColor));
    }

    if(bottomBarColor!=null){
      this.bototmBarColor=Color(int.parse(bottomBarColor));
      setState(() {});
    }

    if(bottombarIcon!=null){
      this.bottomMenuIconColor=Color(int.parse(bottombarIcon));
      setState(() {});
    }

    if(appBarColor!=null){
      this.appBarColor=Color(int.parse(appBarColor));
      setState(() {});
    }

    if(appbarIcon!=null){
      this.appBarIconColor=Color(int.parse(appbarIcon));
      setState(() {});
    }

    if(appbarIcon!=null){
      this.appBarIconColor=Color(int.parse(appbarIcon));
      setState(() {});
    }

    if(appbarIcon!=null){
      this.appBarIconColor=Color(int.parse(appbarIcon));
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getappUi();
    getUserId();
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? baseUrl =prefs.getString('base_url');
    String? adminId =prefs.getString('admin_auto_id');

    if (baseUrl!=null && userId != null && adminId!=null) {
      if(mounted){
        setState(() {
          user_id = userId;
          this.baseUrl=baseUrl;
          this.admin_auto_id = adminId;

          getWishList();
        });
      }
    }
    return null;
  }

  getWishList() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "user_auto_id": user_id,
      "admin_auto_id" : admin_auto_id,
    };

    print('User_id: '+user_id);

    var url = baseUrl+'api/' + get_wishlist;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        WishlistModel wishlistModel=WishlistModel.fromJson(json.decode(response.body));
        wishlist=wishlistModel.getAdminWishlistProductLists;

        getCartProdList();

      }
      else {
        wishlist=[];
      }

      if(mounted){
        setState(() {});
      }
    }
    else if(response.statusCode==500){
      if(mounted){
        setState(() {
          isApiCallProcessing=false;
          Fluttertoast.showToast(
            msg: 'Server error',
            backgroundColor: Colors.grey,
          );
        });
      }
    }
  }

  deleteWishList(String productAutoId) async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "user_auto_id": user_id,
      "product_auto_id": productAutoId,
      "admin_auto_id" : admin_auto_id,
    };

    print('User_id: '+user_id);

    var url = baseUrl+'api/' + delete_wishlist_item;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        Fluttertoast.showToast(
          msg: 'Item removed from wishlist',
          backgroundColor: Colors.grey,
        );
        getWishList();
      }
      else{
        String  msg = resp['msg'];
        Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.grey,
        );
      }

      if(mounted){
        setState(() {});
      }
    }
    else if(response.statusCode==500){
      if(mounted){
        setState(() {
          isApiCallProcessing=false;
          Fluttertoast.showToast(
            msg: 'Server error',
            backgroundColor: Colors.grey,
          );
        });
      }
    }
  }

  void _showDeleteDialog(BuildContext context,String productId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text('Do you want to remove this product from wishlist?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                print('Confirmed');
                deleteWishList(productId);
                const CircularProgressIndicator();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  getCartProdList() async {
    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }
    final body = {
      "user_auto_id": user_id,
      "admin_auto_id": admin_auto_id,
    };

    print("user_id=>" + user_id);

    var url = baseUrl + 'api/' + get_cart_product_count;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing = false;
      final resp = jsonDecode(response.body);
      int status = resp['status'];
      print("status=>" + status.toString());
      if (status == 1) {
        CartCountModel cartCountModel =
        CartCountModel.fromJson(json.decode(response.body));
        // cartCount = cartCountModel.productCountData.toString();

        for(int i=0;i<wishlist.length;i++){
          cartCountModel.getAdminCartProductLists.forEach((element) {
            if(element.productAutoId==wishlist[i].productAutoId){
              wishlist[i].isAdedToCart=true;
            }
          });
        }
      }
      else {
        //cartCount = '0';
      }

      if (mounted) {
        setState(() {});
      }
    }
    else if(response.statusCode==500){
      if(mounted){
        setState(() {
          isApiCallProcessing=false;
          Fluttertoast.showToast(
            msg: 'Server error',
            backgroundColor: Colors.grey,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: appBarColor,
        title: Text("Wishlist" ,style: TextStyle(color:appBarIconColor,fontSize: 18)),
        leading: IconButton(
          onPressed: ()=>{
            Navigator.of(context).pop()
          },
          icon: Icon(Icons.arrow_back, color: appBarIconColor),
        ),
        //automaticallyImplyLeading: false,
      ),
      body:Stack(
        children: <Widget>[
          Container(
              margin: const EdgeInsets.all(5),
              child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: wishlist.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1/1.7,
                      crossAxisCount: 2,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0),
                  itemBuilder: (BuildContext context, int index) {
                    return productCard(wishlist[index]);
                  }
              )
          ),

          isApiCallProcessing==false && wishlist.isEmpty?
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: const Text('No products added in wishlist')
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
      ),

    );
  }

  showProductDetails(String productId){
    Route routes = MaterialPageRoute(builder: (context) => ProductDetailScreen(productId));
    Navigator.push(context, routes).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    getWishList();
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

  productCard(ProductModel product){
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
                      showProductDetails(product.productAutoId)
                    },
                    child:
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.grey[100],
                        child: product.productImages.isNotEmpty
                            ? CachedNetworkImage(
                          fit: BoxFit.contain,
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

                  Container(
                    alignment: Alignment.topRight,
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      child: Container(
                        width: 30,
                        height: 30,
                        child:const Icon(Icons.close_rounded,color: Colors.white,),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.red
                        ),
                      ),
                      onTap: ()=>{
                        _showDeleteDialog(context, product.productAutoId)
                      },
                    ),
                  )

                ]),
              ),),
            Expanded(
                flex: 3,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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

                        /*  product.productPrice.isNotEmpty?
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
                                              if(product.size.isNotEmpty){
                                                showSeleceCartSize(product.productAutoId,product.moq,product.size);
                                              }
                                              else{
                                                widget.onAddToCartCallback(product.productAutoId,product.moq,'');
                                                //addToCart(product.productAutoId,product.moq,'');
                                              }
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
                                            if(product.size.isNotEmpty){
                                              showBuyNowSize(product.productAutoId,product.moq,product.size);
                                            }
                                            else{
                                              widget.onBuyNowCallback(product.productAutoId,product.moq,'');
                                            }
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
*/

                        product.productPrice.isNotEmpty?
                        Expanded(
                          flex: 1,
                          child: Container(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                child: Row(
                                  children: [
                                    product.isAdedToCart==true?
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius: BorderRadius.circular(2)),
                                          padding: const EdgeInsets.all(5),
                                          margin: const EdgeInsets.only(
                                            top: 5,
                                          ),
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
                                      child:InkWell(
                                        onTap: () {
                                          if(product.size.isNotEmpty){
                                            showSeleceCartSize(product.productAutoId,product.moq,product.size);
                                          }
                                          else{
                                            addToCart(product.productAutoId,product.moq,'');
                                          }
                                        },

                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: primaryButtonColor,
                                              borderRadius: BorderRadius.circular(2)),
                                          padding: const EdgeInsets.all(5),
                                          margin: const EdgeInsets.only(
                                            top: 5,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text("Add To Cart",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child:InkWell(
                                        onTap: () {
                                          if(product.size.isNotEmpty){
                                            showBuyNowSize(product.productAutoId,product.moq,product.size);
                                          }
                                          else{
                                            buyNow(product.productAutoId,product.moq,'');
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: secondaryButtonColor,
                                              borderRadius: BorderRadius.circular(2)),
                                          padding: const EdgeInsets.all(5),
                                          margin: const EdgeInsets.only(
                                            top: 5,
                                          ),
                                          alignment: Alignment.center,
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

  addToCart(String productAutoId, String moq,String size) async {
    for(int i=0;i<wishlist.length;i++){
      if(productAutoId==wishlist[i].productAutoId){
        wishlist[i].isAdedToCart=true;
      }
    }

    String cartQty='1';
    String size='';

    if(moq.isNotEmpty){
      cartQty=moq;
    }

    final body = {
      "product_auto_id": productAutoId,
      "user_auto_id": user_id,
      "size": size,
      "cart_quantity": cartQty,
      "admin_auto_id": admin_auto_id,
    };

    print("prod_id=>"+productAutoId);
    print("cart qty=>"+cartQty);
    print("Size=>"+size);

    var url = baseUrl+'api/' + add_to_cart;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      String  status = resp['status'];
      print("status=>"+status.toString());
      if (status == '1') {

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
    else if(response.statusCode==500){
      if(mounted){
        setState(() {
          isApiCallProcessing=false;
          Fluttertoast.showToast(
            msg: 'Server error',
            backgroundColor: Colors.grey,
          );
        });
      }
    }
  }

  buyNow(String productAutoId, String moq,String size) async {
    if(this.mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    String cartQty='1';
    String size='';

    if(moq.isNotEmpty){
      cartQty=moq;
    }

    final body = {
      "product_auto_id": productAutoId,
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
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      String  status = resp['status'];
      print("status=>"+status.toString());
      if (status == '1') {
        isApiCallProcessing=false;

        final resp = jsonDecode(response.body);
        String  status = resp['status'];
        print("status=>"+status.toString());
        if (status == '1') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BuyNowScreen()));

          print('Buy Now Success');
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
    else if(response.statusCode==500){
      if(mounted){
        setState(() {
          isApiCallProcessing=false;
          Fluttertoast.showToast(
            msg: 'Server error',
            backgroundColor: Colors.grey,
          );
        });
      }
    }
  }

  showSeleceCartSize(String productAutoId, String moq,List<ProdSize> size) {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SelectProdSize(onAddToCartListener,productAutoId,moq,size);
        });
  }

  showBuyNowSize(String productAutoId, String moq,List<ProdSize> size) {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SelectProdSize(onBuyNowListener,productAutoId,moq,size);
        });
  }

  void onBuyNowListener(String productAutoId, String moq, String size) {
    buyNow(productAutoId,moq,size);
    Navigator.of(context).pop();
  }

  void onAddToCartListener(String productAutoId, String moq, String size) {
    addToCart(productAutoId,moq,size);
    Navigator.of(context).pop();
  }

}
