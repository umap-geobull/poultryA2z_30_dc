import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/BuyNow/model/buy_now_model.dart';
import 'package:poultry_a2z/Cart/model/user_address_model.dart';
import 'package:poultry_a2z/Home/Home_Screen.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import '../Utils/App_Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getwidget/getwidget.dart';
import 'package:poultry_a2z/AdminDashboard/PaymentMerchant/ProcessPaymentScreen.dart';


class FinalPayScreen extends StatefulWidget {
  String couponCodeString;
  final String _paymentMode;
  final String _deliveryType;


  FinalPayScreen(this.couponCodeString, this._paymentMode, this._deliveryType);

  @override
  _FinalPayScreenState createState() => _FinalPayScreenState();
}

class _FinalPayScreenState extends State<FinalPayScreen> {

  late UserAddressDetails userAddressDetails;
  String pincode='';
  bool isApiCallProcessing=false;
  String user_id='';
  String baseUrl='',admin_auto_id='';
  late BuyNowModel cartModel;
  bool isServerError=false;

  bool isPlaceOrderProcessing=false;
  bool orderPlaced=false;

  String payment_status='Pending';

  //transaction_id='',

  List<GetAdminCartProductLists> cartProductList=[];
  String Totalprice='',currency='';
  String payment_gateway_name= '', clientd = '', secretkey = '', marchant_name = '', razorpay_key = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserId();
    getPaymentDetails();
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? baseUrl =prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');

    if (baseUrl!=null && userId != null && adminId!=null) {
      if(mounted){
        setState(() {
          user_id = userId;
          this.baseUrl=baseUrl;
          this.admin_auto_id=adminId;

          getAddressFromSession();
        });
      }
    }
    return null;
  }

  Future<String?> getPaymentDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clientd = prefs.getString('clientd');
    String? secretkey =prefs.getString('secretkey');
    String? marchant_name = prefs.getString('marchant_name');
    String? razorpay_key = prefs.getString('razorpay_key');
    String? paymentgatewayname = prefs.getString('payment_gateway_name');

    if (clientd!=null && secretkey != null && marchant_name!=null &&
        razorpay_key!=null && paymentgatewayname!=null) {
      if(mounted){
        setState(() {
          this.clientd = clientd;
          this.secretkey=secretkey;
          this.marchant_name=marchant_name;
          this.razorpay_key=razorpay_key;
          this.payment_gateway_name=payment_gateway_name;
        });
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text("CheckOut", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
      ),
      bottomSheet: Checkout_Section(context),
      body:Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 40),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addressUi(),
                  const Divider(color: Colors.grey),
                  deliveryUi(),
                  paymentModeUi(),
                  priceDetails(),
                  Divider(thickness: 5,color: Colors.grey.shade100,),
                  SizedBox(height: 15,),
                  Text('  Your order contains',
                    style: TextStyle(color: Colors.black87,fontSize: 18,fontWeight: FontWeight.bold),),
                  SizedBox(height: 20,),
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
                ],
              ),
            ),
          ),

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

  cartCard(GetAdminCartProductLists cartModel,int index){
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Container(
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
              ),
              const SizedBox(
                width: 15,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartModel.productName,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5,),
                    /*  Row(
                          children: [
                            Text('Size:'),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '5',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),*/
                    cartModel.colorName!='Select Color Name'?Row(
                      children: [
                        const Text('Color:'),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          cartModel.colorName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ):Container(),
                    const SizedBox(height: 5,),
                    Row(
                      children: [
                        const Text('Quantity:'),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          cartModel.cartQuantity,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5,),

                    Row(
                      children: [
                        Text(
                          currency + cartModel.productPrice.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          currency + cartModel.finalProductPrice.toString(),
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
                        Container()
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
        ),
        Divider(thickness: 1,
          color: Colors.grey[300],)
      ],
    );
  }

  priceDetails(){
    if(cartProductList.isNotEmpty){
      return Container(
        margin: const EdgeInsets.only(top: 10),
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
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerRight,
                          child: const Text('-',
                            style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 15),)
                      ))

                ],
              ),
            ),

            SizedBox(height: 8,),
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

  addressUi(){
    if(pincode.isNotEmpty){
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        child:
        Container(
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
            ],
          ),
        ),
      );
    }
    else{
      return Container();
    }
  }

  paymentModeUi(){
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10)
      ),
      child:Text('Payment Mode: '+widget._paymentMode,style: const TextStyle(color: Colors.black87,fontSize: 15),)
    );
  }

  deliveryUi(){
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10)
        ),
        child:Text('Delivery Type: '+widget._deliveryType,style: const TextStyle(color: Colors.black87,fontSize: 15),)
    );
  }

  Widget Checkout_Section(BuildContext context) {

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
                child: cartProductList.isNotEmpty?
                Text( currency +Totalprice,
                  style: const TextStyle(color: Colors.black87,fontSize: 20,fontWeight: FontWeight.bold),):
                    Container()
              ),
            ),
            Expanded(
              flex: 4,
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      textStyle: const TextStyle(fontSize: 20)),
                  onPressed: () {
                    goToPaymentPage();
                  },
                  child: const Center(
                    child: Text(
                      'Place Order',
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

  goToPaymentPage(){
    if(widget._paymentMode=='ONLINE'){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>
          ProcessPaymentScreen(Totalprice.toString(),onPaymentSucesslistner)));
    }
    else{
      placeOrder('');
    }
  }
  getAddressFromSession() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userAddress = prefs.getString('user_address');

    if(userAddress!=null){
      UserAddressDetails userAddressDetails=UserAddressDetails.fromJson(json.decode(userAddress));
      this.userAddressDetails=userAddressDetails;
      pincode=userAddressDetails.pincode;

      if(mounted){
        setState(() {
          if(user_id.isNotEmpty && baseUrl.isNotEmpty && pincode.isNotEmpty){
            getBuyNow();
          }
        });
      }
    }
  }

  getBuyNow() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "user_auto_id": user_id,
      "pincode": pincode,
      "coupon_code": widget.couponCodeString,
      "delivery_type":widget._deliveryType,
      "admin_auto_id":admin_auto_id,
    };

    var url = baseUrl+'api/' + get_buy_now;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        cartModel=BuyNowModel.fromJson(json.decode(response.body));
        cartProductList=cartModel.getAdminCartProductLists;
        Totalprice=cartModel.totalPaidPrice;
        currency=cartProductList[0].currency;
      }

      if(mounted){
        setState(() {});
      }
    }

    else if(response.statusCode==500){
      isApiCallProcessing=false;
      isServerError=true;

      if(mounted){
        setState(() {});
      }
    }
  }

  placeOrder(String transaction_id) async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
        isPlaceOrderProcessing=true;
      });
    }

    String productAutoId='',size='',quantity='',productPrice='',productOfferPercentage='',
        productFinalPrice='',productImage='',addedBy='',addedById='';


    for(int index=0;index<cartProductList.length;index++){

      String _size='';
      if(cartProductList[index].size.isNotEmpty){
        _size=cartProductList[index].size[0].sizeName;
      }

      if(index==0){
        productAutoId=productAutoId+cartProductList[index].productAutoId;
        size=size+_size;
        quantity=quantity+cartProductList[index].cartQuantity;
        productPrice=productPrice+cartProductList[index].productPrice.toString();
        productOfferPercentage=productOfferPercentage+cartProductList[index].productOfferPercentage;
        productFinalPrice=productFinalPrice+cartProductList[index].finalProductPrice.toString();
        productImage=productImage+cartProductList[index].productImages[0].imageFile;
        addedBy=addedBy+cartProductList[index].addedBy;
        addedById=addedById+cartProductList[index].userAutoId;
      }
      else{
          productAutoId=productAutoId+'|'+cartProductList[index].productAutoId;
          size=size+'|'+_size;
          quantity=quantity+'|'+cartProductList[index].cartQuantity;
          productPrice=productPrice+'|'+cartProductList[index].productPrice.toString();
          productOfferPercentage=productOfferPercentage+'|'+cartProductList[index].productOfferPercentage;
          productFinalPrice=productFinalPrice+'|'+cartProductList[index].finalProductPrice.toString();
          productImage=productImage+'|'+cartProductList[index].productImages[0].imageFile;
          addedBy=addedBy+'|'+cartProductList[index].addedBy;
          addedById=addedById+'|'+cartProductList[index].userAutoId;
      }
    }

    //print(productAutoId);

    final body = {
      "customer_auto_id": user_id,
      "product_auto_id": productAutoId,
      "size": size,
      "quantity": quantity,
      "product_price": productPrice,
      "product_offer_percentage": productOfferPercentage,
      "product_final_price": productFinalPrice,
      "product_image": productImage,
      "added_by": addedBy,
      "added_by_id": addedById,
      "address": userAddressDetails.addressDetails,
      "country": 'India',
      "state": 'Maharashtra',
      "city": userAddressDetails.city,
      "mobile_no": userAddressDetails.mobileNo,
      "payment_mode": widget._paymentMode,
      "transaction_id": transaction_id,
      "payment_status": payment_status,
      "applied_promocode": cartModel.appliedPromocode,
      "promocode_value_off": cartModel.promocodeValueOff,
      "promocode_type": cartModel.promocodeType,
      "promocode_value_off_on_order": cartModel.promocodeValueOffOnOrder,
      "used_pincode": cartModel.usedPincode,
      "pincode_delivery_charge": cartModel.pincodeDeliveryCharge,
      "total_price": cartModel.totalPrice.toString(),
      "total_paid_price": Totalprice.toString(),
      "admin_auto_id" : admin_auto_id,
    };

    //print(user_id);

    var url = baseUrl+'api/' + place_order;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    //print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      //print("status=>"+status.toString());
      if (status == 1) {
        orderPlaced=true;
        orderSuccesfullAlert();
      }

      if(mounted){
        setState(() {});
      }
    }

    else if(response.statusCode==500){
      isApiCallProcessing=false;
      isServerError=true;

      if(mounted){
        setState(() {});
      }
    }
  }

  Future<bool> orderSuccesfullAlert() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          content:Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    const Text('Hey...',style: TextStyle(color: Colors.orangeAccent,fontSize: 20),),
                    const SizedBox(height: 10,),
                    const Text('Your order has been placed successfully',
                      style: TextStyle(color: Colors.black54,fontSize: 15),),
                    const SizedBox(height: 5,),
                    const Text('Keep Shopping',
                      style: TextStyle(color: Colors.orange,fontSize: 16),),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            child: ElevatedButton(
                              onPressed: (){
                                _goToHomeScreen();
                              },
                              child: const Text("Ok",style: TextStyle(color: Colors.black54,fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[200],
                                // minimumSize: Size(70,30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )
                        ),
                        const SizedBox(width: 10,),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  Future _goToHomeScreen() async{
    Navigator.popUntil(context, ModalRoute.withName("/"));
    Navigator.push(context,  MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  onPaymentSucesslistner(String transactionId) {

    print('back');

    if(transactionId.isNotEmpty){
      placeOrder(transactionId);
    }
  }
}
