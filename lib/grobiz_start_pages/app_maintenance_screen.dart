import 'dart:async';
import 'dart:convert';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:poultry_a2z/AppUi/app_ui_model.dart';
import 'package:poultry_a2z/Login/Login_Screen.dart';
import 'package:poultry_a2z/Utils/AppConfig.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/grobiz_start_pages/login/grobiz_login.dart';
import 'package:poultry_a2z/grobiz_start_pages/login/select_action_welcome.dart';
import 'package:poultry_a2z/grobiz_start_pages/profile/admin_profile_model.dart';
import 'package:poultry_a2z/grobiz_start_pages/welcome/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home/Home_Screen.dart';
import '../../Admin_add_Product/Components/Model/Rest_Apis.dart';
import 'package:http/http.dart' as http;



class MaintenanceScreen extends StatefulWidget {
  String admin_auto_id;
  String maintenance_message;
  MaintenanceScreen(this.admin_auto_id, this.maintenance_message);

  @override
  _MaintenanceScreen createState() => _MaintenanceScreen();
}

class _MaintenanceScreen extends State<MaintenanceScreen> {
  _MaintenanceScreen();

  String admin_auto_id='';
  String user_type='';
  String deep_link_admin_auto_id_session = '';
  String app_base_url='https://grobiz.app/GRBCRM2022/PoultryEcommerce/';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveAppBaseUrl();
    getDeepLinkAdminId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      Container(
        color: Color(0xFFefece7),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child:Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: 300,
                          child: Image.asset('assets/man.gif'),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 50),
                          width: 200,
                          child: Image.asset('assets/dog.gif',alignment: Alignment.bottomLeft,),
                        )
                      )
                    ],
                  ),
                )
            ),
            Expanded(
                flex: 1,
                child:Container(
                  margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/textbackground.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(left: 10,right: 100),
                    alignment: Alignment.centerLeft,
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Html(
                            data:widget.maintenance_message
                        )

/*                        Text(app_under_maintenance_message,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),)*/,
                        Container(
                          height: 30,
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                    textStyle: const TextStyle(fontSize: 14)),
                                onPressed: () {
                                  SystemNavigator.pop();
                                },
                                child: Text(
                                  'No',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    textStyle: const TextStyle(fontSize: 14)),
                                onPressed: () {
                                  checkAdminId();
                                },
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  saveAppBaseUrl() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('base_url',app_base_url);
  }

  saveDeepLinkAdminId() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('deep_link_admin_id',widget.admin_auto_id);
  }

  getDeepLinkAdminId() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String id= prefs.getString('deep_link_admin_id')!;

    if(id!=null){
      if(this.mounted){
        deep_link_admin_auto_id_session = id;
      }
    }
  }

  checkAdminId(){
    if(widget.admin_auto_id.isNotEmpty){
      saveDeepLinkAdminId();
      if(this.mounted){
        setState(() {
          user_type = 'customer';
          admin_auto_id = widget.admin_auto_id;
          //getAppUiDetails();
        });
      }
    }
    else if(deep_link_admin_auto_id_session.isNotEmpty){
      if(this.mounted){
        setState(() {
          user_type = 'customer';
          admin_auto_id = deep_link_admin_auto_id_session;
          //getAppUiDetails();
        });
      }
    }
    else{
      checkAdminIdStoredInSession();
    }
  }

  checkAdminIdStoredInSession() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? adminId =prefs.getString('admin_auto_id');
    String? userType =prefs.getString('user_type');

    if(adminId!=null && adminId.isNotEmpty){
      if(userType!=null && userType!='Admin'){
        if(this.mounted){
          setState(() {
            admin_auto_id=adminId;
            getAdminProfile(admin_auto_id);
            //getAppUiDetails();
          });
        }
      }
      else{
        getAdminLoginInfo();
      }
    }
    else{
      getAdminLoginInfo();
    }
  }

  Future getAppUiDetails() async {
    Rest_Apis restApis = Rest_Apis();

    restApis.getAppUi(admin_auto_id,app_base_url).then((value) {
      if (value != null) {

        AppUiModel appUiModel=value;

        if(appUiModel!=null && appUiModel.status==1){
          List<AllAppUiStyle> appUiStyle=appUiModel.allAppUiStyle!;

          saveAdminId();
          saveAppUiSession(appUiStyle);

          if(user_type == 'customer'){
            getCustomerLoginInfo();
          }
          else{
            getAdminLoginInfo();
          }
        }
      }
    });
  }

  Future<void> saveAppUiSession(List<AllAppUiStyle> appUiStyle) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();

    if(appUiStyle[0].appbarColor.isNotEmpty){
      prefs.setString('appbarColor', appUiStyle[0].appbarColor);
    }

    if(appUiStyle[0].appbarIconColor.isNotEmpty){
      prefs.setString('appbarIconColor', appUiStyle[0].appbarIconColor);
    }

    if(appUiStyle[0].bottomBarColor.isNotEmpty){
      prefs.setString('bottomBarColor', appUiStyle[0].bottomBarColor);
    }

    if(appUiStyle[0].bottomBarIconColor.isNotEmpty){
      prefs.setString('bottomBarIconColor', appUiStyle[0].bottomBarIconColor);
    }

    if(appUiStyle[0].loginRegisterButtonColor.isNotEmpty){
      prefs.setString('primaryButtonColor', appUiStyle[0].loginRegisterButtonColor);
    }

    if(appUiStyle[0].addToCartButtonColor.isNotEmpty){
      prefs.setString('secondaryButtonColor', appUiStyle[0].addToCartButtonColor);
    }

    if(appUiStyle[0].showLocationOnHomescreen.isNotEmpty){
      prefs.setString('showLocationOnHomescreen', appUiStyle[0].showLocationOnHomescreen);
    }

    if(this.mounted){
      setState(() {
      });
    }
  }

  getCustomerLoginInfo() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    bool? isLogin =prefs.getBool('is_login');

    if(isLogin !=null){
      if(isLogin ==true){
        Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (Route<dynamic> route) => false);
      }
      else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    }
    else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  getAdminLoginInfo() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    bool? isLogin =prefs.getBool('is_login');
    String? app_type =prefs.getString('app_type');

    if(isLogin !=null){
      if(isLogin ==true){
        if(app_type!=null && app_type.isNotEmpty){
          Navigator.of(context)
              .pushNamedAndRemoveUntil(HomeScreen.routeName, (Route<dynamic> route) => false);
        }
        else{
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WelcomePage()));
        }
      }
      else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SelectOption()));
      }
    }
    else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SelectOption()));
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GrobizLogin()));
    }
  }

  saveAdminId() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('admin_auto_id',admin_auto_id);
  }

  Future getAdminProfile(String admin_id) async {
    final body = {
      "user_auto_id":admin_id,
    };

    var url=AppConfig.grobizBaseUrl+get_admin_profile;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        AdminProfileModel adminProfileModel=AdminProfileModel.fromJson(json.decode(response.body));
        String businessLogo=adminProfileModel.data[0].appLogo;

        saveBusinessLogo(businessLogo);

        if(this.mounted){
          setState(() {
            getAppUiDetails();
          });
        }
      }
    }
    else{
      if(this.mounted){
        setState(() {
        });
      }
    }
  }

  saveBusinessLogo(String logo) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('app_logo',logo);
  }

/*//check link when app is terminated
  checkInitialData(){
    try{
      if (widget.initialLink != null) {
        final Uri deepLink = widget.initialLink!.link;
        if (deepLink != null) {
          final queryParams = deepLink.queryParameters;
          String admin_id = queryParams["admin_auto_id"]!;

          if(admin_id!=null){
            deep_link_admin_auto_id = admin_id;
            //user_type = 'customer';
          }
        }
        else{
          deep_link_admin_auto_id = '';
        }

        if(this.mounted){
          setState(() {});
        }
      }
      else{
        initDynamicLinks();
      }
    }
    catch (e){
      print('e: '+e.toString());
    }
  }

  //check link when app is in background/foreground
  Future<void> initDynamicLinks() async {

    try{
      FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
        final Uri deepLink = dynamicLinkData.link;
        if (deepLink != null) {
          final queryParams = deepLink.queryParameters;
          String admin_id = queryParams["admin_auto_id"]!;

          if(admin_id!=null){
            deep_link_admin_auto_id = admin_id;
            //user_type = 'Customer';
          }
        }
        else{
          deep_link_admin_auto_id = '';
        }

        if(this.mounted){
          setState(() {});
        }
      }).
      onError((error) {
      });
    }
    catch (e){

    }
  }
*/

}
