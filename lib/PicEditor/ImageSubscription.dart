import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../AdminDashboard/PaymentMerchant/RazorPay/ErrorModel.dart';
import '../ImageSubscription/ProcessImagePaymentScreen.dart';
import '../ImageSubscription/SubscriptionPlanModel/ImageSubscriptionPlanModel.dart';
import '../ImageSubscription/purchase_summary.dart';
import '../Utils/AppConfig.dart';
import '../Utils/App_Apis.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../grobiz_start_pages/plans/purchase_summary.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ImageSubscription extends StatefulWidget {
  @override
  _ImageSubscriptionState createState() => _ImageSubscriptionState();
}

class _ImageSubscriptionState extends State<ImageSubscription> {
  String user_id = "";
  String baseUrl = "";
  bool isApiCallProcessing = false;
  bool isChecked = false;
  List<GetImagePlans> getplalist = [];
  List<String> selectedplans = [];
  List<GetImagePlans> purchaseplan=[];
  final String RAZORPAT_KEY_TEST='';
  final String RAZORPAT_KEY='rzp_live_UDyMe2A4Fju0oN';
  final String MERCHANT_NAME='Grobiz';
  final String DESCRIPTION='Order Total';
  late Razorpay _razorpay;
  String currency='INR';
  Color appBarColor = Colors.white,
      appBarIconColor = Colors.black,
      primaryButtonColor = Colors.orange,
      secondaryButtonColor = Colors.orangeAccent;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getappUi();
    getBaseUrl();
  }

  void getappUi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? appBarColor = prefs.getString('appbarColor');
    String? appbarIcon = prefs.getString('appbarIconColor');
    String? primaryButtonColor = prefs.getString('primaryButtonColor');
    String? secondaryButtonColor = prefs.getString('secondaryButtonColor');

    if (appBarColor != null) {
      this.appBarColor = Color(int.parse(appBarColor));
    }

    if (appbarIcon != null) {
      this.appBarIconColor = Color(int.parse(appbarIcon));
    }

    if (primaryButtonColor != null) {
      this.primaryButtonColor = Color(int.parse(primaryButtonColor));
      print(this.primaryButtonColor.value.toString());
    }

    if (secondaryButtonColor != null) {
      this.secondaryButtonColor = Color(int.parse(secondaryButtonColor));
      print(this.secondaryButtonColor.value.toString());
    }

    if (this.mounted) {
      setState(() {});
    }
  }

  void getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? baseUrl =prefs.getString('base_url');
    // String? userType =prefs.getString('user_type');
    String? userId = prefs.getString('user_id');

    if (userId != null && baseUrl != null) {
      setState(() {
        user_id = userId;
        this.baseUrl = AppConfig.grobizBaseUrl;
        getimageplan();
        print(getplalist.length);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: StatefulBuilder(builder: (context, setState) {
          return Material(
              child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new AssetImage('assets/subscription.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 150,
                            margin: EdgeInsets.only(top: 5,left: 25),
                            child:  const Text(
                              'Ready to go pro?',
                              style: TextStyle(color: Colors.white, fontSize: 22),
                            ),
                          ),

                      const Divider(
                        color: Colors.black54,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height/2.5,
                          padding: const EdgeInsets.only(
                              bottom: 0, left: 5, right: 5),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: getplalist.length,
                              itemBuilder: (context, index) =>
                                  PlanCard(getplalist[index]))),
                      // const SizedBox(height: 20,),
                      Container(
                        height: 20,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        alignment: Alignment.center,
                        child: const Text("For more details , contact us",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Container(
                            alignment: Alignment.center,
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: Text(
                                "   Continue   ",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                        onTap: () {
                          // addPlan();
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder:
                          //     (context)=>ProcessImagePaymentScreen(purchaseplan[0],'12345')));
                          Navigator.pop(context);
                          // goToPuchasePlan();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )),
          ));
        }),
        onWillPop: () => onBackPressed());
  }

  PlanCard(GetImagePlans plans) {
    return Container(
      child: Stack(
        children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.orangeAccent,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10,top: 10),
        child: ListTile(
            title: Text(
              plans.name!+"  (₹ "+plans.price+")",
              style: const TextStyle(
                  fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              plans.description!,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            leading: isAdded(plans.id as String) == true
                ? Icon(
              Icons.check_circle,
              color: Colors.green[700],
            )
                : const Icon(
              Icons.check_circle_outline,
              color: Colors.grey,
            ),
            onTap: () {
              setState(() {
                selectedplans.clear();
                purchaseplan.clear();
                setSelected(plans.id);
              });
            }),
      ),
        Container(
          alignment: Alignment.center,
          width: 50,
          height: 25,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white
          ),
          margin: const EdgeInsets.only(left: 260, right: 15,top: 0),
          child: Text(plans.offerPercentage+"% off"),
        ),
    ],),);
  }

  onBackPressed() {
    Navigator.of(context).pop();
  }

  // goToPuchasePlan(GetImagePlans planModel){
  //   if(purchaseplan.isNotEmpty ){
  //   //   Fluttertoast.showToast(msg:'You have already purchased this plan', toastLength: Toast.LENGTH_SHORT);
  //   // }
  //   // else{
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
  //         ImagePlanSummary(planModel)));
  //   }
  // }

  setSelected(String id) {
    if (isAdded(id) == true) {
      selectedplans.clear();
      purchaseplan.clear();
    } else {
      if (selectedplans.length < 1) {
        selectedplans.clear();
        purchaseplan.clear();
        selectedplans.add(id);
        for(int i=0;i<getplalist.length;i++)
          {
            if(getplalist[i].id==selectedplans[0])
              {
                purchaseplan.add(getplalist[i]);
                print('purchased id='+purchaseplan[0].id);
              }
          }

      } else {}
    }
    if (mounted) {
      setState(() {});
    }
  }

  bool isAdded(String id) {
    for (int i = 0; i < selectedplans.length; i++) {
      if (selectedplans[0] == id) {
        return true;
      }
    }
    return false;
  }

  Future getimageplan() async {
    if (this.mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }

    var url = baseUrl + get_image_plans;

    var uri = Uri.parse(url);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      isApiCallProcessing = false;

      final resp = jsonDecode(response.body);
      // String message=resp['msg'];
      int status = resp['status'];
      if (status == 1) {
        ImageSubscriptionModel imageSubscriptionmodel =
            ImageSubscriptionModel.fromJson(json.decode(response.body));
        getplalist = imageSubscriptionmodel.data;
      }

      if (this.mounted) {
        setState(() {});
      }
    }
  }

  //razorpay
  void openCheckout() async {
    var options;

    // int amount= selectedPlan.finalPrice*100;

    String paidPrice=purchaseplan[0].finalPrice;
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
        'currency':'INR',
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

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProcessImagePaymentScreen(purchaseplan[0],response.paymentId!)));

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

  Future<void> addPlan() async {

    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "plan_auto_id":purchaseplan[0].id,
      "user_auto_id": user_id,
      "payment_mode":"Online",
      "transaction_id":"",
      "transaction_status":"",
    };

    var url = baseUrl + image_subscriptions;

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
          msg: "Plan updated successfully",
          backgroundColor: Colors.grey,
        );
        Navigator.pop(context);
      }
      else {
        print('empty');
      }

      if(mounted){
        setState(() {});
      }
    }
  }
}
