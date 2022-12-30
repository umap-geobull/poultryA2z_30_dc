import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Utils/App_Apis.dart';
import 'EditPrivacyPolicy.dart';
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

  String user_id='';
  String user_type='';
  String baseUrl='', admin_auto_id='';

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? userType =prefs.getString('user_type');
    String? baseUrl =prefs.getString('base_url');
    String? adminId =prefs.getString('admin_auto_id');

    if(userId!=null && userType!=null){
      user_id=userId;
      user_type=userType;

      if(mounted){
        setState(() {});
      }
    }

    if (baseUrl!=null && adminId!=null) {
      if(mounted){
        setState(() {
          this.baseUrl=baseUrl;
          this.admin_auto_id = adminId;
          getPrivacyPolicy();
        });
      }
    }
    return null;
  }

  getPrivacyPolicy() async {
    if(mounted){
      setState(() {
        isloading=true;
      });
    }

    var url = baseUrl+'api/' + show_Privacy;

    Uri uri=Uri.parse(url);

    final body={
      "admin_auto_id" : admin_auto_id,
    };

    final response = await http.post(uri,body: body);

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

    getUserId();
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
          actions: [
            user_type=='Admin'?
            IconButton(
              onPressed: () {
                goToEdit();
              },
              icon: Icon(
                Icons.edit,
                color: appBarIconColor,
              ),
            ):
            Container(),
          ],
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
                      child: Text(
                          privacydata,
                          style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45)))
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

  goToEdit(){
    Route routes = MaterialPageRoute(builder: (context) => EditPrivacyPolicy(privacy_id,privacydata));
    Navigator.push(context, routes).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    getPrivacyPolicy();
  }


}