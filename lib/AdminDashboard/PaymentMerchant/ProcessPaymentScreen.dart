import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/AdminDashboard/PaymentMerchant/RazorPay/ErrorModel.dart';
import 'package:poultry_a2z/Admin_add_Product/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

typedef OnSaveCallback = void Function(String transactionId);

class ProcessPaymentScreen extends StatefulWidget{
  String final_paid_price;
  OnSaveCallback onSaveCallback;

  ProcessPaymentScreen(this.final_paid_price,this.onSaveCallback);

  @override
  _ProcessPaymentScreenState createState() => _ProcessPaymentScreenState();
}

class _ProcessPaymentScreenState extends State<ProcessPaymentScreen>{
  String payment_gateway_name= '', clientd = '', secretkey = '', marchant_name = '', razorpay_key = '';

  String returnUrl="https://samplesite.com/return";
  String cancelUrl="https://samplesite.com/cancel";


  bool isPaymentFail=false;
  String errorMessage='';

  late Razorpay _razorpay;
  String currency='USD';
  String description='Order Total';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    getPaymentDetails();
  }

  Future<String?> getPaymentDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clientd = prefs.getString('clientd');
    String? secretkey =prefs.getString('secretkey');
    String? marchant_name = prefs.getString('marchant_name');
    String? razorpay_key = prefs.getString('razorpay_key');
    String? paymentgatewayname = prefs.getString('payment_gateway_name');

    print(paymentgatewayname);
    print(razorpay_key);
    print(marchant_name);

    if (clientd!=null && secretkey != null && marchant_name!=null &&
        razorpay_key!=null && paymentgatewayname!=null) {
      if(mounted){
        setState(() {
          this.clientd = clientd;
          this.secretkey=secretkey;
          this.marchant_name=marchant_name;
          this.razorpay_key=razorpay_key;
          this.payment_gateway_name=paymentgatewayname;
          goToPaymentGateway();
        });
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child:isPaymentFail?
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  Container(
                    height: 50,
                    width: 50,
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red
                    ),
                    child: Icon(Icons.close,color: Colors.white,),
                  ),
                  Text('Transaction Failed',
                    style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                  SizedBox(height: 20,),
                  Text(errorMessage,
                    style: TextStyle(color:Colors.black,fontSize: 17),),
                  SizedBox(height: 50,),
                  ElevatedButton(
                    onPressed: (){
                      widget.onSaveCallback('');
                      Navigator.pop(context);
                    },
                    child: Text("Ok",),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryLightColor,
                      minimumSize: Size(100,40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  )
                ],
              ):
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  CircularProgressIndicator(),
                  Text('Please Wait',
                    style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),

                  SizedBox(height: 20,),

                  Text('We are processing your payment',
                    style: TextStyle(color:Colors.black,fontSize: 17),),

                  SizedBox(height: 15,),

                  Text('Please dont exit the screen or press back button',
                    style: TextStyle(color:Colors.black,fontSize: 15),),
                  SizedBox(height: 30,),
                ],
              )
          ),
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void goToPaymentGateway() {
    print(this.payment_gateway_name);
    print(razorpay_key);
    print(marchant_name);

    if(payment_gateway_name=='RazorPay'){
      print('razorpay');
      openRazorpayCheckout();
    }
    else if(payment_gateway_name == 'PayPal'){
      print('paypal');
      openPaypalCheckout();
    }
    else{

    }
  }


  //razorpay
  void openRazorpayCheckout() async {
    var options;

    print("in "+payment_gateway_name);

    String paidPrice=widget.final_paid_price;
    int finalPaidPrice=int.parse(paidPrice);
    int amount= finalPaidPrice*100;

    try{
      options = {
        'key': razorpay_key,
        'amount': amount,
        'name': marchant_name,
        'description': "Order Total",
        'retry': {'enabled': true, 'max_count': 1},
        'send_sms_hash': true,
        'currency':currency,
      };
    }
    catch (e) {
      debugPrint('Error: e');
    }

    try {
      _razorpay.open(options);
    }
    catch (e) {
      Fluttertoast.showToast(
          msg: 'Payment Error',
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _razorpay.clear();

    String transactionId=response.paymentId!;

    widget.onSaveCallback(transactionId);
    Navigator.pop(context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    //print(response.code.toString()+"-"+response.message.toString());

    isPaymentFail=true;

    try{
      ErrorModel errorModel=ErrorModel.fromJson(json.decode(response.message!));

      errorMessage=errorModel.error.description.toString();

      print('error message: '+errorMessage);
    }
    catch(e){
      print(e.toString());
    }

    if(this.mounted){
      setState(() {
      });
    }

    /*Fluttertoast.showToast(
        msg: errorModel.error.description, toastLength: Toast.LENGTH_SHORT);*/
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!, toastLength: Toast.LENGTH_SHORT);
  }


  //paypal

  void openPaypalCheckout() async {

    print("in "+payment_gateway_name);

    print(clientd);
    print(secretkey);

    String paidPrice=widget.final_paid_price;
    //int finalPaidPrice=int.parse(paidPrice);
    //double amount= finalPaidPrice*100;

    //print(finalPaidPrice.toString());

  /*  Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
            sandboxMode: true,
            clientId: clientd,
            secretKey: secretkey,
            returnURL: "https://samplesite.com/return",
            cancelURL: "https://samplesite.com/cancel",
            transactions: [
              {
                "amount": {
                  "total": '10.12',
                  "currency": 'USD',
                },
                "description": description,
              }
            ],
            onSuccess: (Map params) async {
              _handlepaymentSuccess(params);
              print("onSuccess: $params");
            },
            onError: (error) {
              _handlepaymentError(error);
              print("onError: $error");
            },
            onCancel: (params) {
              _handleCancel(params);
              print('cancelled: $params');
            }),
      ),
    );
*/

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
            sandboxMode: true,
            clientId: clientd,
            secretKey: secretkey,
            returnURL: returnUrl,
            cancelURL: cancelUrl,
            transactions: [
              {
                "amount": {
                  "total": paidPrice,
                  "currency": currency,
                },
                "description": description,
                // "payment_options": {
                //   "allowed_payment_method":
                //       "INSTANT_FUNDING_SOURCE"
                // },
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              print("onSuccess: $params");
            },
            onError: (error) {
              print("onError: $error");
            },
            onCancel: (params) {
              print('cancelled: $params');
            }),
      ),
    );
  }

  void _handlepaymentSuccess(Map params) {
   // String transactionId=response.paymentId!;

    //widget.onSaveCallback(transactionId);
   // Navigator.pop(context);
  }

  void _handlepaymentError(error) {
    //print(response.code.toString()+"-"+response.message.toString());

    isPaymentFail=true;

    errorMessage=error.toString();

    if(this.mounted){
      setState(() {
      });
    }
  }

  void _handleCancel(params) {

    errorMessage="Payment cancelled";

    if(this.mounted){
      setState(() {
      });
    }
  }

}

