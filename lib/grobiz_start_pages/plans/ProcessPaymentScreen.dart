// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Utils/AppConfig.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:poultry_a2z/grobiz_start_pages/order_history/grobiz_plans_history.dart';
import 'package:poultry_a2z/grobiz_start_pages/plans/purchase_plan_response.dart';
import 'package:poultry_a2z/grobiz_start_pages/plans/subscription_plan_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProcessPaymentScreen extends StatefulWidget{
  GetPlanLists subscriptionPlan;
  late String transaction_id;

  ProcessPaymentScreen(this.subscriptionPlan,this.transaction_id);

  @override
  _ProcessPaymentScreenState createState() => _ProcessPaymentScreenState(subscriptionPlan,transaction_id);

}

class _ProcessPaymentScreenState extends State<ProcessPaymentScreen>{
  bool isApiCallProcess=false;
  GetPlanLists subscriptionPlan;
  late String transaction_id;

  bool? isSuccessfull,isFailure;

  String user_auto_id='';

  String message='';

  _ProcessPaymentScreenState(this.subscriptionPlan,this.transaction_id);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(30),
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:isApiCallProcess?
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,children: <Widget> [
                Text('Please wait\n we are processing your payment',
                  textAlign:TextAlign.center,
                  style: TextStyle(color:Colors.orangeAccent,fontWeight: FontWeight.bold,fontSize: 17),),
                SizedBox(height: 30,),
                CircularProgressIndicator()
              ],
            ):
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Text(message,
                  style: TextStyle(color:
                      isSuccessfull==true?Colors.orangeAccent:
                      isFailure==true? Colors.red:
                      Colors.black,
                      fontWeight: FontWeight.bold,fontSize: 18),
                textAlign: TextAlign.center,),
                SizedBox(height: 50,),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GrobizPlanHistory()));
                  },
                  child: Text("Ok",style: TextStyle(color: Colors.white,fontSize: 15),),
                  style:
                  ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    onPrimary: Colors.orange,
                    minimumSize: Size(100,40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  Future getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> userMap;

    String user_id = prefs.getString('user_id')!;

    if (user_id != null) {
      setState(() {
        user_auto_id = user_id;
        purchasePlan();
      });
    }
  }

  //purchase plan
  Future purchasePlan() async {
    setState(() {
      isApiCallProcess=true;
    });

    final body = {
      "plan_auto_id": subscriptionPlan.planAutoId,
      "payment_mode": 'Online',
      "transaction_status": 'Completed',
      "transaction_id": transaction_id,
      "user_auto_id": user_auto_id,
    };

    var url=AppConfig.grobizBaseUrl+purchase_plan;
    var uri = Uri.parse(url);

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      print(response.body.toString());

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      String msg=resp['msg'];
      if(status==1){
        if(this.mounted){
          setState(() {
            isApiCallProcess=false;
            isSuccessfull=true;
            isFailure=false;
          });
        }

        message='Your plan has been purchased successfully';
       // Fluttertoast.showToast(msg:msg, toastLength: Toast.LENGTH_SHORT);
      }
      else{
        if(this.mounted){
          setState(() {
            isApiCallProcess=false;
            isSuccessfull=false;
            isFailure=true;

            message=msg;

          });
        }

       // Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_SHORT);
      }
    }
    else if (response.statusCode == 500) {
      print(response.body.toString());
      isApiCallProcess=false;
      isSuccessfull=false;
      isFailure=true;
      Fluttertoast.showToast(msg:'Server Error', toastLength: Toast.LENGTH_SHORT);
    }
  }

}

