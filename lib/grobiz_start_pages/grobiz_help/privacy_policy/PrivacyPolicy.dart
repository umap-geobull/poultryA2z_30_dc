import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:poultry_a2z/Utils/AppConfig.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Utils/App_Apis.dart';
import 'PrivacyPolicyModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';


class PrivacyPolicy extends StatefulWidget {
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;

  PrivacyPolicy(this.appBarColor, this.appBarIconColor, this.primaryButtonColor,
      this.secondaryButtonColor);

  @override
  State<PrivacyPolicy> createState() => PrivacyPolicyState(appBarColor,appBarIconColor,primaryButtonColor,secondaryButtonColor);

}

class PrivacyPolicyState extends State<PrivacyPolicy>{
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;


  PrivacyPolicyState(this.appBarColor, this.appBarIconColor, this.primaryButtonColor,
      this.secondaryButtonColor);


  late String privacydata='', privacy_id='',updatedon='',updateday='';
  late PrivacyPolicyModel privacyPolicyModel;
  bool isloading=false;


  getPrivacyPolicy() async {
    if(mounted){
      setState(() {
        isloading=true;
      });
    }

    var url = AppConfig.grobizBaseUrl + showPrivacy;

    Uri uri=Uri.parse(url);

    final response = await http.get(uri);
    print(response.toString());
    if (response.statusCode == 200) {
      isloading=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        privacyPolicyModel = PrivacyPolicyModel.fromJson(json.decode(response.body));
        var mainList = privacyPolicyModel.allprivacy;
        if(mounted){
          setState(() {
            privacy_id=mainList[0].id;
            privacydata = mainList[0].privacy;
            isloading=false;
            updateday=mainList[0].updatedAt;
          });
        }
      }
      else {
        if(mounted){
          setState(() {
            privacy_id='';
            privacydata = 'No Data Avaialble';
            isloading=false;
          });
        }
      }

      if(mounted){
        setState(() {});
      }
    }
    else if(response.statusCode==500){
      if(mounted){
        setState(() {
          isloading=false;
          Fluttertoast.showToast(
            msg: 'Server error',
            backgroundColor: Colors.grey,
          );
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    getPrivacyPolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text("Privacy Policy", style: TextStyle(color: appBarIconColor, fontSize: 18, fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: Icon(Icons.arrow_back, color: appBarIconColor),
          ),
        ),

        body:Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin:
                      const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 5),
                      child: Html(
                          data:privacydata
                      )
                  )
                ],
              ),
            ),

            isloading==true?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: const GFLoader(
                  type:GFLoaderType.circle
              ),
            ):
            Container()
          ],
        )
    );
  }


}