import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/grobiz_start_pages/order_history/order_history_model.dart';
import 'package:poultry_a2z/grobiz_start_pages/plans/ProcessPaymentScreen.dart';
import 'package:poultry_a2z/grobiz_start_pages/plans/purchase_summary.dart';
import 'package:poultry_a2z/grobiz_start_pages/plans/subscription_plan_model.dart';
import '../../Utils/AppConfig.dart';
import '../../Utils/App_Apis.dart';
import '../../Utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';


class GrobizPlanDetails extends StatefulWidget {
  GetPlanLists planModel;

  @override
  _GrobizPlanDetails createState() => _GrobizPlanDetails();

  GrobizPlanDetails(this.planModel);
}

class _GrobizPlanDetails extends State<GrobizPlanDetails> {

  String user_id='';

  bool isApiCallProcessing=false;

  List<GetPlanLists> planList=[];
  List<GetOrderHistoryList> purchasedPlanList=[];

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? user_id =prefs.getString('user_id');

    if(user_id!=null){
      if(this.mounted){
        setState(() {
          this.user_id=user_id;
          print (user_id);
          getPurchasedPlansApi();
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(widget.planModel.planName,
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
            planCard(),

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

  planCard(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child:SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              // margin: EdgeInsets.only(bottom: 10),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Plan Price',
                    style: TextStyle(color: Colors.black,fontSize: 16),),

                  SizedBox(height: 10,),
                  widget.planModel.offerPercentage!='0'?
                  Container(
                    child:  Text(widget.planModel.currency+widget.planModel.price,style: TextStyle(color: Colors.black,fontSize: 15,
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
                        widget.planModel.finalPrice!='Free'?
                        Text(widget.planModel.currency+widget.planModel.finalPrice,style: TextStyle(color: Colors.orangeAccent,fontSize: 25,
                            fontWeight: FontWeight.bold),):
                        Text(widget.planModel.finalPrice,style: TextStyle(color: Colors.orangeAccent,fontSize: 25,
                            fontWeight: FontWeight.bold),),

                        widget.planModel.offerPercentage!='0'?
                        Text(' ('+widget.planModel.offerPercentage+'% OFF'+')',style: TextStyle(color: Colors.black,fontSize: 14,
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
                  Text(widget.planModel.validity+' '+ widget.planModel.validityUnit,style: TextStyle(color: Colors.orangeAccent,fontSize: 17,
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
                    itemCount: widget.planModel.features.length,
                    itemBuilder: (context, index) =>
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: <Widget>[
                              Text(
                                widget.planModel.features[index],
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
            Container(
              // margin: EdgeInsets.only(bottom: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150,35),
                  primary: kPrimaryColor,
                ),
                child: Text('SELECT'),
                onPressed: () {
                  goToPuchasePlan(widget.planModel);
                },
              ),
            ),

            /* TextButton(onPressed: ()=>{},
              child: Text('Get Free Trial',style: TextStyle(decoration: TextDecoration.underline),))*/
          ],
        ),
      ),
    );
  }

  goToPuchasePlan(GetPlanLists planModel){
    //if(purchasedPlanList.isNotEmpty && purchasedPlanList[0].status!='Purchased'){
    if(purchasedPlanList.isNotEmpty && purchasedPlanList[0].planAutoId ==planModel.planAutoId){
      planPurchaseAlert();
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
          Summary(planModel)));
    }
  }

  void planPurchaseAlert() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.yellow[50],
        content:Wrap(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  const Text('You have already purchased this plan',style: TextStyle(color: Colors.black54),),
                ],
              ),
            )
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: const Text("Ok",
                style: TextStyle(color: Colors.white,fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(70,30),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
              ),
            ),
          )
        ],),
    );
  }

  getPurchasedPlansApi() async {
    if(this.mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body={
      "user_auto_id":user_id,
    };

    var url=AppConfig.grobizBaseUrl+orderHistory;
    var uri = Uri.parse(url);
    final response = await http.post(uri,body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        OrderHistoryModel subscriptionPlanModel=OrderHistoryModel.fromJson(json.decode(response.body));
        purchasedPlanList=subscriptionPlanModel.getOrderHistoryList;
        print(planList.toString());

        if(this.mounted){
          setState(() {});
        }
      }
      else{
        planList=[];
        if(this.mounted){
          setState(() {});
        }
      }
    }

    else if(response.statusCode==500){
      isApiCallProcessing=false;

      if(this.mounted){
        setState(() {});
      }
    }
  }
}
