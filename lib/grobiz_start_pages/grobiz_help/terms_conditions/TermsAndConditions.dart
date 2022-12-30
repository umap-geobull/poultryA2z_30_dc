import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:poultry_a2z/Utils/AppConfig.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../Utils/App_Apis.dart';
import 'TermsModel.dart';
import 'package:getwidget/getwidget.dart';

class TermsAndConditions extends StatefulWidget {
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;

  TermsAndConditions(this.appBarColor, this.appBarIconColor, this.primaryButtonColor,
      this.secondaryButtonColor);

  @override
  State<TermsAndConditions> createState() => TermsAndConditionsState(appBarColor,appBarIconColor,primaryButtonColor,secondaryButtonColor);
}

class TermsAndConditionsState extends State<TermsAndConditions>{
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;


  TermsAndConditionsState(this.appBarColor, this.appBarIconColor, this.primaryButtonColor,
      this.secondaryButtonColor);

  late String termsdata='', terms_id='';
  late TermsModel termsAndConditions;
  bool isloading=false;

  @override
  void initState() {
    super.initState();
    getTermsCondition();
  }

  getTermsCondition() async {
    if(mounted){
      setState(() {
        isloading=true;
      });
    }

    var url = AppConfig.grobizBaseUrl + showTermsCondition;

    Uri uri=Uri.parse(url);

    final response = await http.get(uri);
    print(response.toString());
    if (response.statusCode == 200) {
      isloading=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        termsAndConditions = TermsModel.fromJson(json.decode(response.body));
        var mainList = termsAndConditions.allterms;
        var status = termsAndConditions.status;
        if (status == 1) {
          setState(() {
            terms_id=mainList[0].id;
            termsdata = mainList[0].term;
            isloading=false;
          });
        } else {
          termsdata = 'Data Not Available';
        }
      }
      else {
        if(mounted){
          setState(() {
            terms_id='';
            termsdata = '';
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

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text("Terms & Conditions", style: TextStyle(color: appBarIconColor, fontSize: 18, fontWeight: FontWeight.bold)),
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
                          data:termsdata
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