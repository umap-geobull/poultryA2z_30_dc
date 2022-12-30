import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';
import '../Utils/AppConfig.dart';
import '../Utils/App_Apis.dart';
import 'SubscriptionPlanModel/ImageSubHistoryModel.dart';

class ImageSubscriptionPlan extends StatefulWidget
{
  @override
  _ImageSubscriptionPlanState createState() => _ImageSubscriptionPlanState();
}

class _ImageSubscriptionPlanState extends State<ImageSubscriptionPlan>{
  String user_id = "";
  String baseUrl = "";
  bool isApiCallProcessing = false;
  List<GetImageSubHistoryList> imagesubhistory = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
  }

  void getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId != null && baseUrl != null) {
      setState(() {
        user_id = userId;
        this.baseUrl = AppConfig.grobizBaseUrl;
        getplanhistory();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Image Plan Purchase History",
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
                  itemCount: imagesubhistory.length,
                  itemBuilder: (context, index) => planCard(imagesubhistory[index],
                  )
              ),
            ),

            isApiCallProcessing==false && imagesubhistory.isEmpty?
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

  void getplanhistory() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "user_auto_id":user_id,
    };
    var url = baseUrl + image_subscriptions_history;
    var uri = Uri.parse(url);
    final response = await http.post(uri,body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing = false;

      final resp = jsonDecode(response.body);
      int status = resp['status'];
      if (status == 1) {
        ImageSubHistoryModel imagesModel =
        ImageSubHistoryModel.fromJson(json.decode(response.body));
        imagesubhistory = imagesModel.getOrderHistoryList;
        if (mounted) {
          setState(() {});
        }
      } else if (status == 0){
        imagesubhistory=[];
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  planCard(GetImageSubHistoryList planModel){
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

          // Container(
          //   padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
          //   width: MediaQuery.of(context).size.width,
          //   alignment: Alignment.center,
          //   //margin: EdgeInsets.only(bottom: 10),
          //   child:Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: <Widget>[
          //       Text('Plan Validity: ',style: TextStyle(color: Colors.black54,fontSize: 14,
          //           fontWeight: FontWeight.bold),),
          //       Text(planModel.validity+ ' Days',style: TextStyle(color: Colors.black,fontSize: 15,),),
          //     ],
          //   ),
          // ),

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
                  child: Text(planModel.description,style: TextStyle(color: Colors.black,fontSize: 15,),),
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
}