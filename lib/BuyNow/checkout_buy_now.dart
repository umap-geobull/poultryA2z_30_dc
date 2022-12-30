import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/BuyNow/final_payment_buynow.dart';
import 'package:poultry_a2z/BuyNow/model/buy_now_model.dart';
import 'package:poultry_a2z/Cart/model/user_address_model.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import '../Utils/App_Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import '../settings/AddExpressDelivery/Component/Rest_Apis.dart';


class CheckOutBuyNow extends StatefulWidget {
  String couponCodeString;

  CheckOutBuyNow(this.couponCodeString);

  @override
  _CheckOutBuyNow createState() => _CheckOutBuyNow();
}

class _CheckOutBuyNow extends State<CheckOutBuyNow> {

  late UserAddressDetails userAddressDetails;
  String pincode='';
  bool isApiCallProcessing=false;
  String user_id='';
  String baseUrl='',admin_auto_id='';
  late BuyNowModel cartModel;
  bool isServerError=false;

  List<GetAdminCartProductLists> cartProductList=[];
  String _paymentMode = 'COD';
  String _deliveryType = 'Normal';
  String currency='';
  int charges=0,Totalprice=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserId();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text("CheckOut", style: TextStyle(color: appBarIconColor, fontSize: 18, fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(Icons.arrow_back, color: appBarIconColor),
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
                children: [
                  addressUi(),
                  const Divider(color: Colors.grey),
                  selectDeliveryUi(),
                  // Divider(color: Colors.grey),
                  paymentModeUi(),
                  // Divider(color: Colors.grey),
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
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      child:
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Select Payment Option",
                  style: TextStyle(color: Colors.black87,fontSize: 18,fontWeight: FontWeight.bold)              ),
            ),

            ListTile(
              leading: Radio<String>(
                value: 'ONLINE',
                groupValue: _paymentMode,
                onChanged: (value) {
                  setState(() {
                    _paymentMode = value!;
                  });
                },
              ),
              title: const Text('Credit/Debit Card'),
            ),
            ListTile(
                leading: Radio<String>(
                  value: 'COD',
                  groupValue: _paymentMode,
                  onChanged: (value) {
                    setState(() {
                      _paymentMode = value!;
                    });
                  },
                ),
                title: const Text('Cash On Delivery')
            )
          ],
        ),
      ),
    );

  }

  selectDeliveryUi(){
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      child:
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                  "Select Delivery Type",
                  style: TextStyle(color: Colors.black87,fontSize: 18,fontWeight: FontWeight.bold)
              ),
            ),

            ListTile(
              leading: Radio<String>(
                value: 'Express',
                groupValue: _deliveryType,
                onChanged: (value) {
                  setState(() {
                    _deliveryType = value!;
                    getBuyNow();
                  });
                },
              ),
              title: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Express Delivery'),
                    Text('Extra '+currency+charges.toString()+' charges will be applicable',style: const TextStyle(color: Colors.green,fontSize: 13),),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Radio<String>(
                value: 'Normal',
                groupValue: _deliveryType,
                onChanged: (value) {
                  setState(() {
                    _deliveryType = value!;
                    getBuyNow();
                  });
                },
              ),
              title: const Text('Normal Delivery'),
            ),
          ],
        ),
      ),
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
                  Text( currency +Totalprice.toString(),
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
                      primary: kPrimaryColor,
                      textStyle: const TextStyle(fontSize: 20)),
                  onPressed: () {
                    goToFinalPayScreen();
                  },
                  child: const Center(
                    child: Text(
                      'Continue',
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

/*
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
                Text( currency +Totalprice.toString(),
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
                      primary: kPrimaryColor,
                      textStyle: const TextStyle(fontSize: 20)),
                  onPressed: () {
                    goToFinalPayScreen();
                  },
                  child: const Center(
                    child: Text(
                      'Continue',
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
*/

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
      "delivery_type":'Normal',
      "admin_auto_id" : admin_auto_id,
    };

    print(user_id);

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
        Totalprice=int.parse(cartModel.totalPaidPrice);

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

  goToFinalPayScreen(){
    print('Total Price:-'+Totalprice.toString());
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => FinalPayScreen(widget.couponCodeString,_paymentMode,_deliveryType)),
    );
  }

}
