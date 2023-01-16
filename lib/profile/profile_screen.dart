import 'package:flutter/material.dart';
import 'package:poultry_a2z/Login/Login_Screen.dart';
import 'package:poultry_a2z/Utils/coustom_bottom_nav_bar.dart';
import 'package:poultry_a2z/Utils/enums.dart';
import 'package:poultry_a2z/grobiz_start_pages/change_password/change_password.dart';
import 'package:poultry_a2z/grobiz_start_pages/grobiz_help/GrobizHelp.dart';
import 'package:poultry_a2z/grobiz_start_pages/login/grobiz_login.dart';
import 'package:poultry_a2z/grobiz_start_pages/login/select_action_welcome.dart';
import 'package:poultry_a2z/grobiz_start_pages/order_history/grobiz_plans_history.dart';
import 'package:poultry_a2z/grobiz_start_pages/plans/grobiz_plans.dart';
import 'package:poultry_a2z/grobiz_start_pages/profile/admin_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../grobiz_start_pages/profile/admin_profile.dart';
import 'Myaccount/MyProfile.dart';
import '../Wishlist/Wishlist.dart';
import 'components/address/MyAddresses.dart';
import 'components/help/Help.dart';
import 'components/profile_menu.dart';
import 'profile_pic.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  @override
  _ProfileScreen createState() =>_ProfileScreen();

}

class _ProfileScreen extends State<ProfileScreen> {

  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;
  Color bototmBarColor=Colors.white, bottomMenuIconColor=Color(0xFFFF7643);

  String userType='';

  void getappUi() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? appBarColor =prefs.getString('appbarColor');
    String? appbarIcon =prefs.getString('appbarIconColor');
    String? primaryButtonColor =prefs.getString('primaryButtonColor');
    String? secondaryButtonColor =prefs.getString('secondaryButtonColor');
    String? bottomBarColor =prefs.getString('bottomBarColor');
    String? bottombarIcon =prefs.getString('bottomBarIconColor');
    if(bottomBarColor!=null){
      this.bototmBarColor=Color(int.parse(bottomBarColor));
      setState(() {});
    }

    if(bottombarIcon!=null){
      this.bottomMenuIconColor=Color(int.parse(bottombarIcon));
      setState(() {});
    }

    if(appBarColor!=null){
      this.appBarColor=Color(int.parse(appBarColor));
    }

    if(appbarIcon!=null){
      this.appBarIconColor=Color(int.parse(appbarIcon));
    }

    if(primaryButtonColor!=null){
      this.primaryButtonColor=Color(int.parse(primaryButtonColor));
      print(this.primaryButtonColor.value.toString());
    }

    if(secondaryButtonColor!=null){
      this.secondaryButtonColor=Color(int.parse(secondaryButtonColor));
      print(this.secondaryButtonColor.value.toString());
    }

    if(this.mounted){
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getappUi();
    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: appBarColor,
          title: Text("My Account" ,style: TextStyle(color:appBarIconColor,fontSize: 18)),
          automaticallyImplyLeading: false,
        ),
      body:
      SingleChildScrollView(
        padding: const EdgeInsets.only(top:20,bottom: 50,left: 10,right: 10),
        child: Column(
          children: [
            ProfileMenu(
              primaryButtonColor: primaryButtonColor,
              text: "My Profile",
              icon: Icon(Icons.person_outline,color: primaryButtonColor,size: 25,),
              press: () => {
                if(userType=='Admin'){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AdminProfile()))
                }
                else{
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => MyProfile()))
                }
              },
            ),
            ProfileMenu(
              primaryButtonColor: primaryButtonColor,
              text: "Help Center",
              icon: Icon(Icons.help_outline_outlined,color: primaryButtonColor,size: 25,),
              press: () => {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Help(appBarColor,appBarIconColor,primaryButtonColor,secondaryButtonColor)))
              },
            ),
            // ProfileMenu(
            //   primaryButtonColor: primaryButtonColor,
            //   text: "My Addresses",
            //   icon: Icon(Icons.location_on_outlined,color: primaryButtonColor,size: 25,),
            //   press: () => {
            //     Navigator.push(context, MaterialPageRoute(
            //         builder: (context) => MyAddress()))
            //   },
            // ),
            // userType=='Admin'?
            // ProfileMenu(
            //   primaryButtonColor: primaryButtonColor,
            //   text: "Grobiz Help & Support",
            //   icon: Icon(Icons.support_agent,color: primaryButtonColor,size: 25,),
            //   press: () => {
            //     Navigator.push(context, MaterialPageRoute(
            //         builder: (context) => GrobizHelp()))
            //   },
            // ):
            // Container(),
            // userType=='Admin'?
            // ProfileMenu(
            //   primaryButtonColor: primaryButtonColor,
            //   text: "Plan Purchase History",
            //   icon: Icon(Icons.list_alt,color: primaryButtonColor,size: 25,),
            //   press: () => {
            //     Navigator.push(context, MaterialPageRoute(
            //         builder: (context) => GrobizPlanHistory()))
            //   },
            // ):
            // Container(),
            //
            // userType=='Admin'?
            // ProfileMenu(
            //   primaryButtonColor: primaryButtonColor,
            //   text: "Upgrade Plan",
            //   icon: Icon(Icons.money,color: primaryButtonColor,size: 25,),
            //   press: () => {
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => GrobizPlans()))
            //   },
            // ):
            // Container(),

            userType=='Admin'?
            ProfileMenu(
              primaryButtonColor: primaryButtonColor,
              text: "Change Password",
              icon: Icon(Icons.password_outlined,color: primaryButtonColor,size: 25,),
              press: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()))
              },
            ):
            Container(),

            ProfileMenu(
              primaryButtonColor: primaryButtonColor,
              text: "Log Out",
              icon: Icon(Icons.exit_to_app_rounded,color: primaryButtonColor,size: 25,),
              press: () {
                _onLogoutPressed();
              },
            ),
          ],
        ),
      ),
      // drawer: Maindrawer(),
      bottomSheet: CustomBottomNavBar(MenuState.profile,
        bototmBarColor,bottomMenuIconColor,),
    );
  }

  _onLogoutPressed() async{
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: const Text('Are you sure?',style: TextStyle(color: Colors.black87),),
          content: SizedBox(
            height: 78,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Do you want to logout',style: TextStyle(color: Colors.black54),),
                const SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        child: ElevatedButton(
                          onPressed: (){
                            _LogoutUser();
                            //Navigator.popUntil(context, ModalRoute.withName('/'));
                            // Navigator.of(context).pop(true);
                          },
                          child: const Text("Yes",style: TextStyle(color: Colors.black54,fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: const Size(70,30),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        )
                    ),
                    const SizedBox(width: 10,),
                    Container(
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.of(context).pop(false);
                          },
                          child: const Text("No",
                              style: TextStyle(color: Colors.black54,fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: const Size(70,30),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        )
                    ),
                  ],
                )
              ],
            ),
          )
      ),
    ) ?? false;
  }

  Future _LogoutUser() async{

    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? userType=prefs.getString('user_type');

    prefs.setBool('is_login', false);
    prefs.remove('user_id');
    prefs.remove('user_address');
    prefs.remove('user_pincode');
    prefs.remove('user_latitude');
    prefs.remove('user_longitude');
    prefs.remove('user_city');
    prefs.remove('app_type');
    prefs.remove('showLocationOnHomescreen');
    prefs.remove('payment_gateway_name');
    prefs.remove('clientd');
    prefs.remove('secretkey');
    prefs.remove('marchant_name');
    prefs.remove('razorpay_key');
    prefs.remove('payment_gateway_name');
    prefs.remove('isEditSwitched');

    if(userType!=null){
      print(userType);
      if(userType=='Admin'){
        prefs.remove('admin_auto_id');

        Future.delayed(Duration.zero, () {
          Navigator.popUntil(context, ModalRoute.withName("/"));
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
        });

        // Navigator.push(context,  MaterialPageRoute(builder: (context) => GrobizLogin()));
      }
      else{
        Future.delayed(Duration.zero, () {
          Navigator.popUntil(context, ModalRoute.withName("/"));
          Navigator.push(context,  MaterialPageRoute(builder: (context) => LoginScreen()));
        });

      }
    }
  }

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? userType =prefs.getString('user_type');
    String? userId = prefs.getString('user_id');

    if(userType!=null){
      if(this.mounted){
        this.userType=userType;
      }
    }
  }

}
