import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
import 'EditAboutUs.dart';
import 'AboutUsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';


class Aboutus extends StatefulWidget {
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;

  Aboutus(this.appBarColor, this.appBarIconColor, this.primaryButtonColor,
      this.secondaryButtonColor);


  @override
  State<Aboutus> createState() => AboutusState(appBarColor,appBarIconColor,primaryButtonColor,secondaryButtonColor);
}

class AboutusState extends State<Aboutus> {
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;


  AboutusState(this.appBarColor, this.appBarIconColor, this.primaryButtonColor,
      this.secondaryButtonColor);


  late String aboutus='', about_id='';
  late AboutusModel aboutusModel;
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
          getAboutUs();
        });
      }
    }
    return null;
  }


  @override
  void initState() {
    super.initState();
    getUserId();
  }

  getAboutUs() async {
    if(mounted){
      setState(() {
        isloading=true;
      });
    }

    var url = baseUrl+'api/' + show_About;

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
        aboutusModel = AboutusModel.fromJson(json.decode(response.body));
        var mainList = aboutusModel.allabouts;
        if(mounted){
          setState(() {
            about_id=mainList[0].id;
            aboutus = mainList[0].about;
            isloading=false;
          });
        }
      }
      else {
        if(mounted){
          setState(() {
            about_id='';
            aboutus = 'No Data Avaialble';
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

  goToEdit(){
    Route routes = MaterialPageRoute(builder: (context) => EditAboutus(about_id,aboutus));
    Navigator.push(context, routes).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    getAboutUs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text("About Us", style: TextStyle(color: appBarIconColor, fontSize: 18, fontWeight: FontWeight.bold)),
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
            Container()
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
                          aboutus,
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

}
