import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/grobiz_start_pages/order_history/order_history_model.dart';
import '../../Utils/AppConfig.dart';
import '../../Utils/App_Apis.dart';
import '../../Utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GrobizPlanHistory extends StatefulWidget {
  @override
  _GrobizPlansHistory createState() => _GrobizPlansHistory();
}

class _GrobizPlansHistory extends State<GrobizPlanHistory> {

  String user_id='';

  bool isApiCallProcessing=false;

  List<GetOrderHistoryList> planList=[];

  void getUserId() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? appName =prefs.getString('app_name');
    String? user_id =prefs.getString('user_id');

    if(user_id!=null){
      if(this.mounted){
        setState(() {
          this.user_id=user_id;
          print (user_id);
          getAllPlansApi();
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("Purchase History",
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
                  itemBuilder: (context, index) => planCard(planList[index],
                  )
              ),
            ),

            isApiCallProcessing==false && planList.isEmpty?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Text('No plans purchased yet'),
            ) :
            Container(),


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

  List<Widget> sliderItems(){
    List<Widget> items=[];

    for(int i=0;i<planList.length;i++){
      items.add(
        planCard(planList[i])
      );
    }

    return items;
  }

  showPlans(){
    return
      ListView.builder(
        itemCount: planList.length,
        itemBuilder: (context, index) => planCard(planList[index],
        )
    );
  }

  planCard(GetOrderHistoryList planModel){
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
           // alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(bottom: 10),
            child: Text(planModel.planName,
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
          ),

          Container(
            padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            //margin: EdgeInsets.only(bottom: 10),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Taransaction ID: ',style: TextStyle(color: Colors.black54,fontSize: 14,
                    fontWeight: FontWeight.bold),),
                Text(planModel.transactionId,style: TextStyle(color: Colors.black,fontSize: 14,),),
              ],
            ),
          ),

          Divider(),

          Container(
            padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            //margin: EdgeInsets.only(bottom: 10),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Purchased On: ',style: TextStyle(color: Colors.black54,fontSize: 14,
                    fontWeight: FontWeight.bold),),
                Text(planModel.rdate,style: TextStyle(color: Colors.black,fontSize: 14,),),
              ],
            ),
          ),

          Divider(),

          Container(
            padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            //margin: EdgeInsets.only(bottom: 10),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Plan Validity: ',style: TextStyle(color: Colors.black54,fontSize: 14,
                    fontWeight: FontWeight.bold),),
                Text(planModel.validity+ ' '+planModel.validityUnit,style: TextStyle(color: Colors.black,fontSize: 15,),),
              ],
            ),
          ),

          Divider(),

          Container(
            padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            //margin: EdgeInsets.only(bottom: 10),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Plan Features: ',style: TextStyle(color: Colors.black54,fontSize: 14,
                    fontWeight: FontWeight.bold),),
                Flexible(
                  child: Text(planModel.features,style: TextStyle(color: Colors.black,fontSize: 15,),),
                )
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            // margin: EdgeInsets.only(bottom: 10),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Purchase Details',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex:1,
                      child:Text('Plan Price: ',style: TextStyle(color: Colors.black54,fontSize: 14,),),
                    ),
                    Expanded(
                      flex:1,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child:Text(planModel.price,style: TextStyle(color: Colors.black,fontSize: 15,),),
                        )
                    )
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex:1,
                      child:Text('Offer: ',style: TextStyle(color: Colors.black54,fontSize: 14,),),
                    ),
                    Expanded(
                        flex:1,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child:Text(planModel.offerPercentage+'%',style: TextStyle(color: Colors.black,fontSize: 15,),),
                        )
                    )
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex:1,
                      child:Text('Total Paid Price: ',style: TextStyle(color: Colors.black,fontSize: 16,),),
                    ),
                    Expanded(
                        flex:1,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child:Text(planModel.finalPrice,style: TextStyle(color: Colors.orange,fontSize: 18,),),
                        )
                    )
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
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

    var url=AppConfig.grobizBaseUrl+orderHistory;
    var uri = Uri.parse(url);
    final response = await http.post(uri,body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        OrderHistoryModel subscriptionPlanModel=OrderHistoryModel.fromJson(json.decode(response.body));
        planList=subscriptionPlanModel.getOrderHistoryList;

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
