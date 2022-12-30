import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Cart/final_payment_screen.dart';
import 'package:poultry_a2z/settings/AddCurrency/Component/Rest_Apis.dart';
import 'package:poultry_a2z/settings/AddCurrency/Component/currency_list_model.dart';
import 'model/cart_model.dart';
import 'model/user_address_model.dart';
import '../Utils/App_Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';

class Checkout_Screen extends StatefulWidget {
  String couponCodeString;

  Checkout_Screen(this.couponCodeString);

  @override
  _Checkout_ScreenState createState() => _Checkout_ScreenState();
}

class _Checkout_ScreenState extends State<Checkout_Screen> {

  late UserAddressDetails userAddressDetails;
  String pincode='';
  bool isApiCallProcessing=false;
  String user_id='';
  String baseUrl='',admin_auto_id='';
  late CartModel cartModel;
  bool isServerError=false;

  List<GetAdminCartProductLists> cartProductList=[];
  String _paymentMode = 'COD';
  String _deliveryType = 'Normal';
  String currency='';
  String charges='',Totalprice='';
  List<GetCurrencyList> currencyList = [];

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
          title: Text("CheckOut", style: TextStyle(color: appBarIconColor, fontSize: 18, fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: Icon(Icons.arrow_back, color: appBarIconColor),
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
                    getCartList();
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
                    getCartList();
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
                      backgroundColor: primaryButtonColor,
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
            getCartList();
          }
        });
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
      "coupon_code": widget.couponCodeString,
      "delivery_type":_deliveryType,
      "admin_auto_id" : admin_auto_id,
    };

    print(user_id);

    var url = baseUrl+'api/' + get_cart_list;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        cartModel=CartModel.fromJson(json.decode(response.body));
        cartProductList=cartModel.getAdminCartProductLists;
        Totalprice=cartModel.totalPaidPrice;

        currency=cartProductList[0].currency;
        getCurrencyList();
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

/*
  void getExpressDelivery_List() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.getExpressCharges(admin_auto_id, baseUrl).then((value) {
      if (value != null) {
        isApiCallProcessing = false;
        List<ExpressDelivery> getExpressCharges_List = value;

        if(getExpressCharges_List.isNotEmpty){
          charges=getExpressCharges_List[0].expressDeliveryCharges;
        }

        print('charge length '+getExpressCharges_List.length.toString());
        if(this.mounted){
          setState(() {

          });
        }
      }
    });
  }
*/

  void getCurrencyList() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.getCurrencyList(admin_auto_id, baseUrl).then((value) {

      if (value != null) {
        isApiCallProcessing = false;
        currencyList = value;

        for(int i=0; i<currencyList.length; i++){
          print(currencyList[i].expressDeliveryCharges);
          print(currencyList[i].currency);
          print(this.currency);

          if(currencyList[i].currency == this.currency){
             this.charges=currencyList[i].expressDeliveryCharges;
          }
        }

        print('currency length '+currencyList.length.toString());
        if(this.mounted){
          setState(() {
          });
        }
      }
    });
  }

}
