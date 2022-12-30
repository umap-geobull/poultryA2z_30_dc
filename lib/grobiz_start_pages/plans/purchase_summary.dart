import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Home/Home_Screen.dart';
import 'package:poultry_a2z/Utils/theme.dart';
import 'package:poultry_a2z/grobiz_start_pages/plans/ErrorModel.dart';
import 'package:poultry_a2z/grobiz_start_pages/plans/ProcessPaymentScreen.dart';
import 'package:poultry_a2z/grobiz_start_pages/plans/subscription_plan_model.dart';
import 'package:poultry_a2z/grobiz_start_pages/welcome/welcome_page.dart';
import '../../Utils/AppConfig.dart';
import '../../Utils/App_Apis.dart';
import '../../Utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


class Summary extends StatefulWidget {
  GetPlanLists subscriptionPlan;


  Summary(this.subscriptionPlan);

  @override
  _Summary createState() => _Summary(subscriptionPlan);
}

class _Summary extends State<Summary> {
  GetPlanLists planModel;

  _Summary(this.planModel);


  String user_id='';
  bool isApiCallProcessing=false;
  List<GetPlanLists> planList=[];

  final String RAZORPAT_KEY_TEST='';
  final String RAZORPAT_KEY='rzp_live_UDyMe2A4Fju0oN';
  final String MERCHANT_NAME='Grobiz';
  final String DESCRIPTION='Order Total';
  late Razorpay _razorpay;
  String currency='INR';

  void getUserId() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? user_id =prefs.getString('user_id');

    if(user_id!=null){
      if(this.mounted){
        setState(() {
          this.user_id=user_id;
          print (user_id);
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("Summary",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            leading: IconButton(
              onPressed: () => {Navigator.of(context).pop()},
              icon: Icon(Icons.arrow_back, color: Colors.black),
            ),
           ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft:Radius.circular(10) ,topRight: Radius.circular(10)),
                            color: Colors.orangeAccent,
                          ),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(planModel.planName,
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                        ),

                        Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child:Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              planModel.offerPercentage!='0'?
                              Container(
                                child:  Text(planModel.currency+planModel.price,style: TextStyle(color: Colors.black,fontSize: 15,
                                    decoration: TextDecoration.lineThrough),),
                                margin: EdgeInsets.only(bottom: 10),
                              ):
                              Container(),

                              Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    planModel.finalPrice!='Free'?
                                    Text(planModel.currency+planModel.finalPrice,style: TextStyle(color: Colors.orangeAccent,fontSize: 25,
                                        fontWeight: FontWeight.bold),):
                                    Text(planModel.finalPrice,style: TextStyle(color: Colors.orangeAccent,fontSize: 25,
                                        fontWeight: FontWeight.bold),),

                                    planModel.offerPercentage!='0'?
                                    Text(' ('+planModel.offerPercentage+'% OFF'+')',style: TextStyle(color: Colors.black,fontSize: 14,
                                        fontWeight: FontWeight.bold),):
                                    Container(),
                                  ],
                                ),
                              ),

                              Divider(color: Colors.grey,height: 10,)
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          //margin: EdgeInsets.only(bottom: 10),
                          child:Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('Validity',style: TextStyle(color: Colors.black54,fontSize: 13,
                                  fontWeight: FontWeight.bold),),
                              SizedBox(height: 5,),
                              Text(planModel.validity + ' ' + planModel.validityUnit,
                                style: TextStyle(color: Colors.orangeAccent,fontSize: 17,
                                    fontWeight: FontWeight.bold),),

                              Divider(color: Colors.grey,height: 10,)
                            ],
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: planModel.features.length,
                                itemBuilder: (context, index) =>
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            planModel.features[index],
                                            style: TextStyle(color: Colors.black,fontSize: 15,),
                                          ),
                                          SizedBox(height: 10,),
                                          Divider(color: Colors.grey,height: 10,)
                                          // Container(color: Colors.grey[200],height: 1,)
                                        ],
                                      ),
                                    )
                            )
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.white,
                height: 80,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex:1,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Total Payable Amount:',style: TextStyle(color: Colors.black,fontSize: 12),),
                              Text(planModel.finalPrice,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        )),
                    Expanded(
                        flex:1,
                        child: Container(
                          // margin: EdgeInsets.only(bottom: 30),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(150,45),
                              primary: kPrimaryColor,
                            ),
                            child: Text('Purchase Plan'),
                            onPressed: () {
                              if(planModel.finalPrice=='0' || planModel.finalPrice==''){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder:
                                    (context)=>ProcessPaymentScreen(planModel,'')));
                              }
                              else{
                                openCheckout();
                              }
                            },
                          ),
                        ),),
                  ],
                ),
              ),
            ),

            isApiCallProcessing==true?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: GFLoader(type: GFLoaderType.circle),
            ) :
            Container(),
          ],
        )
    );
  }

  //razorpay
  void openCheckout() async {
    var options;

    // int amount= selectedPlan.finalPrice*100;

    String paidPrice=planModel.finalPrice;
    int finalPaidPrice=int.parse(paidPrice);
    int amount= finalPaidPrice*100;

    try{
      options = {
        'key': RAZORPAT_KEY,
        'amount': amount,
        'name': MERCHANT_NAME,
        'description': DESCRIPTION,
        'retry': {'enabled': true, 'max_count': 1},
        'send_sms_hash': true,
        'currency':planModel.code,
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
          msg: 'Please select plan',
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _razorpay.clear();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProcessPaymentScreen(planModel,response.paymentId!)));

    //Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId!, toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    //print(response.code.toString()+"-"+response.message.toString());

    ErrorModel errorModel=ErrorModel.fromJson(json.decode(response.message!));

    Fluttertoast.showToast(
        msg: errorModel.error.description, toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!, toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

}
