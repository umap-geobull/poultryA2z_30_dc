import 'dart:async';
import 'dart:convert';
import 'package:poultry_a2z/Cart/Component/select_address_bottomsheet.dart';
import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';
import 'package:poultry_a2z/profile/components/address/add_new_address.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Cart/model/cart_model.dart';
import 'package:poultry_a2z/Cart/Checkout_Screen.dart';
import 'package:poultry_a2z/CheckOut/Components/select_coupon_screen.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
import '../CheckOut/Components/all_coupon_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Home/Home_Screen.dart';
import '../Product_Details/model/alsoBuyProductModel.dart';
import '../Product_Details/product_details_screen.dart';
import 'model/user_address_model.dart';

class Cart_Screen extends StatefulWidget {
  const Cart_Screen({Key? key}) : super(key: key);

  @override
  _Cart_ScreenState createState() => _Cart_ScreenState();
}

class _Cart_ScreenState extends State<Cart_Screen> {

  String user_id='';
  String baseUrl='',admin_auto_id='',app_type_id='';
  bool isApiCallProcessing=false;
  bool isCheck = false;

  bool isServerError=false;
  late CuponcodeList couponcode;
  bool isApplyCoupon=false;
  String couponCodeString='';

  late UserAddressDetails userAddressDetails;
  String pincode='';

  String currency='';
  
  bool isValidPincode=true;
  bool isValidCouponcode=true;

  List<GetAdminCartProductLists> cartProductList=[];
  late CartModel cartModel;
  // List<GetAdminSubcategoryProductLists> subCategoryProductList = [];
  List<ProductModel> alsoBuyProduct = [];

  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;

  void getappUi() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? appBarColor =prefs.getString('appbarColor');
    String? appbarIcon =prefs.getString('appbarIconColor');
    String? primaryButtonColor =prefs.getString('primaryButtonColor');
    String? secondaryButtonColor =prefs.getString('secondaryButtonColor');

    if(appBarColor!=null){
      this.appBarColor=Color(int.parse(appBarColor));
    }

    if(appbarIcon!=null){
      this.appBarIconColor=Color(int.parse(appbarIcon));
    }

    if(primaryButtonColor!=null){
      this.primaryButtonColor=Color(int.parse(primaryButtonColor));
      print(this.primaryButtonColor.value.toString());
    }

    if(secondaryButtonColor!=null){
      this.secondaryButtonColor=Color(int.parse(secondaryButtonColor));
      print(this.secondaryButtonColor.value.toString());
    }

    if(this.mounted){
      setState(() {});
    }

    print('appbar '+this.appBarColor.value.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getappUi();
    getbaseUrl();
  }

  Future<String?> getbaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? baseUrl =prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');

    if (baseUrl!=null && userId != null && adminId!=null && apptypeid!=null) {
      if(mounted){
        setState(() {
          user_id = userId;
          this.baseUrl=baseUrl;
          this.admin_auto_id=adminId;
          this.app_type_id=apptypeid;
          //getCartList();
          getAddressFromSession();
          getAlsoBuyProducts();

        });
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text("My Cart", style: TextStyle(color:appBarIconColor, fontSize: 18, fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: Icon(Icons.arrow_back, color: appBarIconColor),
          )
      ),
      body:Stack(
        children: <Widget>[
          cartProductList.isNotEmpty && isServerError==false?
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              margin: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  addressUi(),
                 // Address_section(),
                  //SizedBox(height: 10,),
                  Divider(color: Colors.grey[400],thickness: 3,),
                  const SizedBox(height: 20,),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: cartProductList.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {

                        },
                        child: cartCard(
                          cartProductList[index],
                          index
                        ),
                      )),

                  alsoBuyProduct.isNotEmpty?
                  suggested_product_ui():
                  Container(),

                  Container(
                    margin: const EdgeInsets.only(
                        top:20,left: 5,right: 10,bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Coupons",
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        const SizedBox(height: 10,),
                        isApplyCoupon==true?
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(
                                  color: Colors.black54,
                                  width: 1
                              )
                          ),
                          child:Row(
                            children: <Widget>[
                              const Icon(
                                Icons.local_offer_rounded,color: Colors.orangeAccent,
                              ),
                              const SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(couponcode.coupenCode,
                                    style: const TextStyle(color: Colors.black87,fontSize: 17,fontWeight: FontWeight.bold),)  ,
                                  SizedBox(height: 5,),

                                  Text('You are saving '+currency+cartModel.promocodeValueOffOnOrder,
                                    style: TextStyle(color: Colors.green,fontSize: 13),)  ,
                                ],
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      child: const Text('Remove',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.blueAccent,fontSize: 11,
                                            fontWeight: FontWeight.bold),),
                                      onPressed: () {
                                        removeCoupon();
                                      },
                                    )
                                ),
                              )
                            ],
                          ),
                        ):
                        GestureDetector(
                          onTap: ()=>{
                            goToCouponScreen()
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(
                                    color: Colors.black54,
                                    width: 1
                                )
                            ),
                            child: Row(
                              children: [
                                const Text('Apply Coupon',style: TextStyle(color: Colors.black87,fontSize: 14),),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: const Icon(
                                      Icons.arrow_forward_ios_rounded,color: Colors.black87,size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  priceDetails()
                ],
              ),
            ),
          ):
          Container(),

          isServerError==false && cartProductList.isNotEmpty?
          Container(
                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height,
                child: Checkout_Section(),
              ):
          Container(),

          isServerError==true?
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/server_error.png'),
                ),
                const Text('Server Error.. Please try later')
              ],
            ),
          ):
          Container(),

          isApiCallProcessing==false && cartProductList.isEmpty && isServerError==false?
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
              height: 500,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Your cart is empty'),
                  Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen[100],
                      ),
                      child: const Text('Keep Shopping',style: TextStyle(color: Colors.black87,fontSize: 12),),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                      },
                    ),
                    margin: const EdgeInsets.all(5),
                  )
                ],
              )
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

  addressUi(){
    if(pincode.isEmpty){
      return GestureDetector(
        onTap: ()=>{
          showSelectAddress()
        },
        child: Container(
         /* decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.grey,
                  width: 1
              ),
              borderRadius: BorderRadius.circular(5)
          ),*/
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              const Text('Select Delivery Address',
                style: TextStyle(color: Colors.blue,fontSize: 18),),
              Expanded(
                  child:Container(
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width,
                    child:
                    const Icon(Icons.arrow_forward_ios_rounded,color: Colors.orangeAccent,size: 18,),
                  ) )
            ],
          ),
        ),
      );
    }
    else{
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        child: GestureDetector(
          onTap: ()=>{
            showSelectAddress()
          },
          child:Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Delivery Address',
                  style: TextStyle(color: Colors.black87,fontSize: 18,fontWeight: FontWeight.bold),),
                const SizedBox(height: 10,),
                Text(userAddressDetails.name,
                  style: const TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.bold),),
                Text(userAddressDetails.addressDetails+', '+userAddressDetails.area,
                  style: const TextStyle(color: Colors.black54,fontSize: 14),),
                Text(userAddressDetails.city+', '+userAddressDetails.pincode,
                  style: const TextStyle(color: Colors.black54,fontSize: 14),),
                Text(userAddressDetails.mobileNo,style: const TextStyle(color: Colors.black54,fontSize: 14),),
                isValidPincode==false?
                const Text('Currently delivery is not available to this pincode',
                  style: TextStyle(color: Colors.red,fontSize: 14),):
                Container(),
                const SizedBox(height: 5,),
                Container(
                  height: 25,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 100,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Colors.orangeAccent,
                            width: 1
                        )
                    ),
                    child: const Text('CHANGE',
                      textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: Colors.black,),),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  showSelectAddress() async {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SelectAddress(onSelectAddresslistener);
        });
  }

  void onSelectAddresslistener(UserAddressDetails userAddressDetails){
    getAddressFromSession();
    Navigator.pop(context);
  }

  removeCoupon(){
    isApplyCoupon =false;
    couponCodeString='';
    getCartList();
    if(mounted){
      setState(() {});
    }
  }

  cartCard(GetAdminCartProductLists cartModel,int index){
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300, width: 1),
                          ),
                          height: 80,
                          width: 80,
                          child: cartModel.productImages.isNotEmpty?
                          CachedNetworkImage(
                            fit: BoxFit.contain,
                            imageUrl: baseUrl+product_base_url+cartModel.productImages[0].imageFile,
                            placeholder: (context, url) =>
                                Container(decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                )),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ):
                          Container(
                              child:const Icon(Icons.error),
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                              )),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              IconButton(onPressed: ()=>{
                                editQuantity(index,cartModel,1)
                              }, icon: const Icon(Icons.add_circle,color: Colors.orangeAccent,)),
                              Text(
                                cartModel.cartQuantity,
                                style: const TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.bold),
                              ),
                              IconButton(onPressed: ()=>{
                                editQuantity(index,cartModel,0)
                              }, icon: const Icon(Icons.remove_circle,color: Colors.orangeAccent,)),
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width:210,
                          child:
                        Text(
                          cartModel.productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),),
                        const SizedBox(height: 5,),
                        cartModel.colorName!='Select Color Name'?Row(
                          children: [
                            Text('Color:'),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              cartModel.colorName,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ):Container(),
                        const SizedBox(height: 5,),
                        Row(
                        children: [
                          cartModel.originalProductPrice!=cartModel.product_final_price && cartModel.productOfferPercentage!='0'?
                          Text(
                            currency + cartModel.originalProductPrice.toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough),
                          ):Text(''),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            currency + cartModel.product_final_price.toString(),
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),

                          cartModel.productOfferPercentage!='0'?
                          Text(
                            cartModel.productOfferPercentage.toString()+ '% OFF',
                            style: const TextStyle(
                                color: Colors.green,
                                fontSize: 13,
                                fontWeight: FontWeight.bold
                            ),
                          ):
                          Container(),

                        ],
                      ),
                        const SizedBox(height: 5,),
                        cartModel.taxPercentage!='0'?
                        Text(
                          'including '+cartModel.taxPercentage.toString()+ '% tax',
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.bold
                          ),
                        ):
                        Container()
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(left: 20,right: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1,
                                color: Colors.orangeAccent
                            )
                        ),
                        padding: const EdgeInsets.only(top: 5,bottom: 5,left: 2,right: 2),
                        alignment: Alignment.center,
                        child: GestureDetector(
                            onTap: (){
                              _showMyDialog(context,cartModel.productAutoId,cartModel.cartProductAutoId);
                            },
                            child:Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  padding: EdgeInsets.all(2),
                                  child: Icon(
                                    Icons.add_circle,
                                    size: 15, color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text('Wishlist',
                                    style: TextStyle(fontSize: 14, color: Colors.blue)),
                              ],
                            ),

                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(left: 20,right: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1,
                                color: Colors.deepOrange
                            )
                        ),
                        padding: const EdgeInsets.only(top: 5,bottom: 5,left: 2,right: 2),
                        alignment: Alignment.center,
                        child:GestureDetector(
                          onTap: ()=>{
                            deleteCartProduct(cartModel.productAutoId)
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                padding: EdgeInsets.all(2),

                                  child: Icon(
                                    Icons.delete, color: Colors.red,
                                    size: 15,
                                  )
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('Remove',
                                  style:
                                  TextStyle(fontSize: 14, color: Colors.red)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(thickness: 1,
          color: Colors.grey[300],)
      ],
    );
  }

  void _showMyDialog(BuildContext context,String productId,String cartProductAutoId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text('Do you want to move this product to wishlist ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                print('Confirmed');
                movetoWishlist(productId,cartProductAutoId);
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

  editQuantity(int index, GetAdminCartProductLists cartmodel,int action){
    int prodQty=int.parse(cartmodel.cartQuantity);

    try{
      if(action==1){
        prodQty=prodQty+1;

        cartProductList[index].cartQuantity=prodQty.toString();
        editCartProduct(cartmodel);

        if(mounted){
          setState(() {});
        }
      }
      else if(action==0){
        if(prodQty==1) {
          Fluttertoast.showToast(
            msg: 'Minimun order quantity for this product is 1',
            backgroundColor: Colors.grey,
          );
        }else{
          prodQty = prodQty - 1;
          if (prodQty != 0) {
            if (cartmodel.moq.isNotEmpty) {
              if (prodQty < int.parse(cartmodel.moq)) {
                Fluttertoast.showToast(
                  msg: 'Minimun order quantity for this product is ' +
                      cartmodel.moq,
                  backgroundColor: Colors.grey,
                );
              }
              else {
                cartProductList[index].cartQuantity = prodQty.toString();
                editCartProduct(cartmodel);

                if (mounted) {
                  setState(() {});
                }
              }
            } else if (cartmodel.moq.isEmpty) {
              cartProductList[index].cartQuantity = prodQty.toString();
              editCartProduct(cartmodel);

              if (mounted) {
                setState(() {});
              }
            }
          }
        }
      }
    }
    catch(e){
      print(e.toString());
    }
  }

  priceDetails(){
    if(cartProductList.isNotEmpty){
      return Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text('Price Details',style: TextStyle(color: Colors.black87,fontWeight:FontWeight.bold,fontSize: 15),),
            const Divider(color: Colors.grey,),
            const SizedBox(height: 5,),
            Container(
              child: Row(
                children: <Widget>[
                  const Text('Order Total',style: TextStyle(color: Colors.grey,fontSize: 14),),
                  Expanded(
                      flex: 1,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerRight,
                          child: Text( currency +cartModel.totalPrice.toString(),style: const TextStyle(color: Colors.black54,fontSize: 15),)
                      )
                  )

                ],
              ),
            ),
            const SizedBox(height: 8,),

            cartModel.promocodeType=='value_off'?
            Container(
              child: Row(
                children: <Widget>[
                  const Text('Coupon Discount',style: TextStyle(color: Colors.grey,fontSize: 14),),
                  Expanded(
                      flex: 1,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerRight,
                          child: Text( currency +cartModel.promocodeValueOffOnOrder,style: const TextStyle(color: Colors.black54,fontSize: 15),)
                      )
                  )
                ],
              ),
            ):
            cartModel.promocodeType=='percentage_off'?
            Container(
              child: Row(
                children: <Widget>[
                  Text('Coupon Discount('+cartModel.promocodeValueOff+'%)',style: const TextStyle(color: Colors.grey,fontSize: 14),),
                  Expanded(
                      flex: 1,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerRight,
                          child: Text( currency +cartModel.promocodeValueOffOnOrder,style: const TextStyle(color: Colors.black54,fontSize: 15),)
                      )
                  )

                ],
              ),
            ):
            Container(
              child: Row(
                children: <Widget>[
                  Text('Coupon Discount('+cartModel.promocodeValueOff+'%)',style: const TextStyle(color: Colors.grey,fontSize: 14),),
                  Expanded(
                      flex: 1,
                      child:GestureDetector(
                        onTap: ()=>{goToCouponScreen()},
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.centerRight,
                            child: const Text('Apply Coupon',
                              style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 15),)
                        ),
                      ))

                ],
              ),
            ),

            const SizedBox(height: 8,),
            Container(
              child: Row(
                children: <Widget>[
                  const Text('Delivery Charges',style: TextStyle(color: Colors.grey,fontSize: 14),),
                  Expanded(
                      flex: 1,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerRight,
                          child: Text( currency +cartModel.pincodeDeliveryCharge,style: const TextStyle(color: Colors.black54,fontSize: 15),)
                      )
                  )

                ],
              ),
            ),
            const Divider(color: Colors.grey,),
            const SizedBox(height: 8,),
            Container(
              child: Row(
                children: <Widget>[
                  const Text('Total Amount',style: TextStyle(color: Colors.black87,fontWeight:FontWeight.bold,fontSize: 17),),
                  Expanded(
                      flex: 1,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerRight,
                          child: Text( currency +cartModel.totalPaidPrice.toString(),style: const TextStyle(color: Colors.black87,fontSize: 17,fontWeight: FontWeight.bold),)
                      )
                  )

                ],
              ),
            ),

          ],
        ),
      );
    }
    else{
      return Container();
    }
  }

  editCartProduct(GetAdminCartProductLists cartModel) async {
    final body = {
      "cart_product_auto_id": cartModel.cartProductAutoId,
      "cart_quantity": cartModel.cartQuantity.toString(),
      "size": '',
      "admin_auto_id" : admin_auto_id,
    };

    var url = baseUrl+'api/' + edit_cart_product;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    //print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      String  status = resp['status'];
      //print('cart qty updated');
      //print("status=>"+status.toString());
      if (status == "1") {
        getCartList();
      }
      if(mounted){
        setState(() {});
      }
    }

    else if(response.statusCode==500){
      isServerError=true;
      cartProductList=[];

      if(mounted){
        setState(() {});
      }
    }
  }

  deleteCartProduct(String cartProductId) async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "product_auto_id": cartProductId,
      "user_auto_id": user_id,
      "admin_auto_id" : admin_auto_id,
    };
   // print(user_id+'user_id');

    var url = baseUrl+'api/' + delete_from_cart;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    //print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      //print("status=>"+status.toString());
      if (status == 1) {
        Fluttertoast.showToast(
          msg: 'Product removed from cart',
          backgroundColor: Colors.grey,
        );

        getCartList();
      }
      else {
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
      isServerError=true;
      cartProductList=[];

      if(mounted){
        setState(() {});
      }
    }
  }

  movetoWishlist(String productId, String cartProductAutoId) async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "product_auto_id": productId,
      "cart_product_auto_id":cartProductAutoId,
      "customer_auto_id": user_id,
      "admin_auto_id" : admin_auto_id,
    };
    //print(user_id);
    //print(cartProductAutoId);
    var url = baseUrl+'api/'+ move_to_wishlist;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    //print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      String  status = resp['status'].toString();
      print("wishlist status=>"+status);
      if (status == '1') {
        Fluttertoast.showToast(
          msg: 'Product moved to wishlist',
          backgroundColor: Colors.grey,
        );

        getCartList();
      }
      else {
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
      isServerError=true;
      cartProductList=[];

      if(mounted){
        setState(() {});
      }
    }
  }

  getCartList() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "user_auto_id": user_id,
      "pincode": pincode,
      "coupon_code": couponCodeString,
      "delivery_type":'Normal',
      "admin_auto_id" : admin_auto_id,
    };

    // print(body.toString());

    var url = baseUrl+'api/' + get_cart_list;
    print(url);
    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      //print("status=>"+status.toString());
      if (status == 1) {
        cartModel=CartModel.fromJson(json.decode(response.body));
        cartProductList=cartModel.getAdminCartProductLists;

        currency=cartProductList[0].currency;

        if(cartModel.pincodeDeliveryCharge=='00'){
          isValidPincode=false;
        }
        else{
          isValidPincode=true;
        }

        if(cartModel.promocodeValueOffOnOrder=='00'){
          isValidCouponcode=false;
        }
        else{
          isValidCouponcode=true;
        }

        for (var product in cartProductList) {
          product.cartQuantity=product.cartQuantity;
        }
      }
      else {
        cartProductList=[];
      }

      if(mounted){
        setState(() {});
      }
    }
    else if(response.statusCode==500){
      isApiCallProcessing=false;
      isServerError=true;
      cartProductList=[];

      if(mounted){
        setState(() {});
      }
    }
  }

  Checkout_Section() {
    return Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(10.0),

        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text( currency +cartModel.totalPaidPrice.toString(),style: const TextStyle(color: Colors.black87,fontSize: 20,fontWeight: FontWeight.bold),),
              ),
            ),
            Expanded(
              flex: 4,
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryButtonColor,
                      textStyle: const TextStyle(fontSize: 20)),
                  onPressed: () {
                    goToCheckout();
                  },
                  child: const Center(
                    child: Text(
                      'Proceed',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  goToCheckout(){
    if(checkValidations()==true){
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => Checkout_Screen(couponCodeString)),
      );
    }
  }

  bool checkValidations(){
    if(pincode.isEmpty){
      Fluttertoast.showToast(
        msg: 'Please select delivery address',
        backgroundColor: Colors.grey,
      );
      return false;
    }
    else if(isValidPincode==false){
      Fluttertoast.showToast(
        msg: 'Please select valid delivery address',
        backgroundColor: Colors.grey,
      );

      return false;
    }

    return true;
  }

  goToCouponScreen() {
    Route routes = MaterialPageRoute(builder: (context) => SelectCouponScreen(applyCouponCallback));
    Navigator.push(context, routes);
  }

  applyCouponCallback(CuponcodeList couponcode) {
    this.couponcode=couponcode;
    couponCodeString=couponcode.coupenCode;
    isApplyCoupon=true;

    getCartList();
  }

  getAddressFromSession() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userAddress = prefs.getString('user_address');

    if(userAddress!=null){
      UserAddressDetails userAddressDetails=UserAddressDetails.fromJson(json.decode(userAddress));
      this.userAddressDetails=userAddressDetails;
      this.pincode=userAddressDetails.pincode;

      if(mounted){
        setState(() {
          if(user_id.isNotEmpty && baseUrl.isNotEmpty && pincode.isNotEmpty){
            getCartList();
          }
        });
      }
    }else{
      getCartList();
    }
  }

  suggested_product_ui(){
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Text(
              'You can also buy',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10,),
            SizedBox(
                width: 1000,
                height: 200,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: alsoBuyProduct.length,
                    itemBuilder: (context, index) =>
                        suggestedProductItem(alsoBuyProduct[index])
                )

            )

          ],
        )
    );
  }

  getAlsoBuyProducts() async {
    final body = {
      "customer_auto_id": user_id,
      "admin_auto_id" : admin_auto_id,
      "app_type_id": app_type_id,
    };

    //print("customer_auto_id=>"+user_id);

    var url = baseUrl+'api/'+ get_also_buy_products;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    //print(response);
    if (response.statusCode == 200) {
      //isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());

      alsoBuyProduct.clear();
      if (status == 1) {
        AlsoBuyProductModel alsoBuyProductModel=AlsoBuyProductModel.fromJson(json.decode(response.body));
        alsoBuyProduct=alsoBuyProductModel.getAlsoBuyProductLists;
      }
      else {
        print('empty');
      }

      if(this.mounted){
        setState(() {});
      }
    }
  }

  suggestedProductItem(ProductModel product){
    return Container(
      width: 180,
      margin: const EdgeInsets.all(1),
      color: Colors.grey[100],
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
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            product.finalProductPrice!=product.productPrice?Text(
                              currency + product.productPrice,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough),
                            ):Container(),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              currency + product.finalProductPrice.toString(),
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
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
   Route routes = MaterialPageRoute(builder: (context) => ProductDetailScreen(productId));
    Navigator.push(context, routes).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    getCartList();
  }
}
