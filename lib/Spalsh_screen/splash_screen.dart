

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/grobiz_start_pages/profile/admin_profile_model.dart';
import 'package:poultry_a2z/main.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:poultry_a2z/AppUi/app_ui_model.dart';
import 'package:poultry_a2z/Login/Login_Screen.dart';
import 'package:poultry_a2z/Spalsh_screen/maintenance_status_model.dart';
import 'package:poultry_a2z/Utils/AppConfig.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:poultry_a2z/grobiz_start_pages/app_maintenance_screen.dart';
import 'package:poultry_a2z/grobiz_start_pages/login/select_action_welcome.dart';
import 'package:poultry_a2z/grobiz_start_pages/welcome/welcome_page.dart';
import 'package:http/http.dart' as http;
import '../../Admin_add_Product/Components/Model/Rest_Apis.dart';
import '../../Home/Home_Screen.dart';
import 'dart:convert';
import 'package:upgrader/upgrader.dart';


class SplashScreen extends StatefulWidget{
  String admin_auto_id='636371e2bd3e6182c00869d2';

  SplashScreen(this.admin_auto_id);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  String admin_auto_id = '636371e2bd3e6182c00869d2';
  
  String businessDetailsId='',businessName='',businessLogo='';
  String app_base_url='https://gruzen.in/GrobizEcommerceAppBuilder/';
  bool iSApiCallProcessing=false;

  String user_type='';

  String deep_link_admin_auto_id_session = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setupFlutterNotifications();
    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });

    saveAppBaseUrl();
    getAppLogo();
    //getDeepLinkAdminId();
    getAppMaintenanceStatus();
  }

  saveAppBaseUrl() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('base_url',app_base_url);
    prefs.setString('admin_auto_id', admin_auto_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UpgradeAlert(
        child: Center(
          child:
          businessLogo == 'No Data' || businessLogo.isEmpty?
          SizedBox(
            width: 80,
            child: GFLoader(
                type:GFLoaderType.circle
            ),
          ):
          Padding(
            padding: EdgeInsets.all(30),
          child: CachedNetworkImage(
            imageUrl: app_logo_base_url+businessLogo,
            placeholder:(context, url) => Container(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),),
        ),
      ),
    );
  }

  // check if app is under maintenace
  getAppMaintenanceStatus() async {
    if(this.mounted){
      setState(() {
        iSApiCallProcessing=true;
      });
    }

    var url=AppConfig.grobizBaseUrl+get_maintenance_status;
    var uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      iSApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        MaintenanceStatusModel maintenanceStatusModel=MaintenanceStatusModel.fromJson(json.decode(response.body));
        String isUnderMaintenace=maintenanceStatusModel.maintanceStatusData[0].maintanceStatus;
        if(isUnderMaintenace=='Enable'){
          String maintenanceMessage=maintenanceStatusModel.maintanceStatusData[0].message;

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MaintenanceScreen(widget.admin_auto_id, maintenanceMessage)),
                  (Route<dynamic> route) => false
          );

        }
        else{
          checkAdminId();
        }
      }
    }

    else if(response.statusCode==500){
      if(this.mounted){
        setState(() {});
      }
    }
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
        businessLogo=adminProfileModel.data[0].appLogo;

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

  Future getAppUiDetails() async {
    Rest_Apis restApis = Rest_Apis();

    restApis.getAppUi(admin_auto_id,app_base_url).then((value) {
      if (value != null) {

        AppUiModel appUiModel=value;

        if(appUiModel!=null && appUiModel.status==1){
          List<AllAppUiStyle> appUiStyle=appUiModel.allAppUiStyle!;

          //saveAdminId();
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

  // saveDeepLinkAdminId() async{
  //   SharedPreferences prefs= await SharedPreferences.getInstance();
  //   prefs.setString('deep_link_admin_id','636371e2bd3e6182c00869d2');
  // }
  //
  // getDeepLinkAdminId() async{
  //   SharedPreferences prefs= await SharedPreferences.getInstance();
  //   var id= prefs.getString('deep_link_admin_id');
  //
  //   if(id!=null){
  //     if(this.mounted){
  //       setState(() {
  //         deep_link_admin_auto_id_session = '636371e2bd3e6182c00869d2';
  //       });
  //     }
  //   }
  // }

  getAppLogo() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    var appLogo= prefs.getString('app_logo');

    if(appLogo!=null){
      if(this.mounted){
        setState(() {
          businessLogo = appLogo;
        });
      }
    }
  }

  checkAdminId(){
    if(widget.admin_auto_id.isNotEmpty){
      //saveDeepLinkAdminId();
      if(this.mounted){
        setState(() {
          user_type = 'customer';
          admin_auto_id = widget.admin_auto_id;
          getAdminProfile(admin_auto_id);
          //getAppUiDetails();
        });
      }
    }
    // else if(deep_link_admin_auto_id_session.isNotEmpty){
    //   if(this.mounted){
    //     setState(() {
    //       user_type = 'customer';
    //       admin_auto_id = deep_link_admin_auto_id_session;
    //       getAdminProfile(admin_auto_id);
    //       //getAppUiDetails();
    //     });
    //   }
    // }
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
    print("login customer"+isLogin.toString());

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
    //print("apptype"+app_type!);

    if(isLogin !=null){
      if(isLogin ==true){
        //f(app_type!=null && app_type.isNotEmpty){
          Navigator.of(context)
              .pushNamedAndRemoveUntil(HomeScreen.routeName, (Route<dynamic> route) => false);
       /* }
        else{
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
        }*/
      }
      else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    }
    else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  saveAdminId() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('admin_auto_id',admin_auto_id);
    prefs.setString('base_url',app_base_url);

  }
}