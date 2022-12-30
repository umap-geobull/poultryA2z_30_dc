import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/grobiz_start_pages/order_history/order_history_model.dart';
import 'package:poultry_a2z/grobiz_start_pages/plans/ProcessPaymentScreen.dart';
import 'package:poultry_a2z/grobiz_start_pages/plans/plan_details_screen.dart';
import 'package:poultry_a2z/grobiz_start_pages/plans/purchase_summary.dart';
import 'package:poultry_a2z/grobiz_start_pages/plans/subscription_plan_model.dart';
import '../../Utils/AppConfig.dart';
import '../../Utils/App_Apis.dart';
import '../../Utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';


class GrobizPlans extends StatefulWidget {
  @override
  _GrobizPlans createState() => _GrobizPlans();

  GrobizPlans();
}

class _GrobizPlans extends State<GrobizPlans> {

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
          getAllPlansApi();
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
            title: Text("Select Plan",
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
            Container(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: planList.length,
                  itemBuilder: (context, index) => planCard(planList[index], index)
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

  planCard(GetPlanLists planModel, int i){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      margin: EdgeInsets.all(20),
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
            // margin: EdgeInsets.only(bottom: 10),
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
                Text(planModel.validity+' '+ planModel.validityUnit,style: TextStyle(color: Colors.orangeAccent,fontSize: 17,
                    fontWeight: FontWeight.bold),),

                Divider(color: Colors.grey,height: 10,)
              ],
            ),
          ),

          Container(
              padding: EdgeInsets.only(left: 10,right: 10),
              child:
              ListView.builder(
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

          planModel.showDetails==false?
          InkWell(
              onTap: ()=>{
                changeVisibility(i),
              },
              child: Padding(
                padding: EdgeInsets.only(top: 10,bottom: 25),
                child: Text('View Details',style: TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),),
              )
          ):
          Container(),

          Visibility(
            visible: planModel.showDetails,
            child: Container(
                padding: EdgeInsets.only(top:10,left: 10,right: 10),
                child:Column(
                 children: <Widget>[
                   Text(
                     'Plan Description',
                     style: TextStyle(color: Colors.orangeAccent,fontSize: 16, fontWeight: FontWeight.bold),
                   ),

                   SizedBox(height: 10,),

                   ListView.builder(
                       shrinkWrap: true,
                       physics: ClampingScrollPhysics(),
                       itemCount: planModel.description.length,
                       itemBuilder: (context, index) =>
                          Container(
                            alignment: Alignment.center,
                            child:  Text(
                              planModel.description[index],
                              style: TextStyle(color: Colors.black,fontSize: 15,),
                            ),
                          )
                   ),
                   Divider(color: Colors.grey,height: 10,)
                 ],
                )

            ),
          ),

          planModel.showDetails==true?
          InkWell(
              onTap: ()=>{
                changeVisibility(i),
              },
              child: Padding(
                padding: EdgeInsets.only(top: 20,bottom: 10),
                child: Text('Hide Details',style: TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),),
              )
          ):
          Container(),

          Container(
            // margin: EdgeInsets.only(bottom: 30),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(150,35),
                primary: kPrimaryColor,
              ),
              child: Text('SELECT'),
              onPressed: () {
                goToPuchasePlan(planModel);
              },
            ),
          ),
        ],
      ),
    );
  }

  changeVisibility(int index){
    setState(() {
      planList[index].showDetails = !planList[index].showDetails;
    });
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

  getAllPlansApi() async {
    if(this.mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body={
      "user_auto_id":user_id,
    };

    var url=AppConfig.grobizBaseUrl+get_plans;
    var uri = Uri.parse(url);
    final response = await http.post(uri,body:body );
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        SubscriptionPlanModel subscriptionPlanModel=SubscriptionPlanModel.fromJson(json.decode(response.body));
        planList=subscriptionPlanModel.getPlanLists;

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
