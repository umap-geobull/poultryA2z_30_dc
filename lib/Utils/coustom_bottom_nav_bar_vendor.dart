import 'package:flutter/material.dart';
import 'package:poultry_a2z/Home/Home_Screen.dart';
import 'package:poultry_a2z/MyOrders/order_screen.dart';
import 'package:poultry_a2z/PicEditor/GreetingsScreen.dart';
import '../Community/Community_Dashboard.dart';
import '../Consultant/Consultant_Dashboard.dart';
import '../Jobs/Add_Vacancy.dart';
import '../Jobs/ApplyJobs.dart';
import '../Jobs/Jobs_Dashboard.dart';
import '../poultry_vendor/Vendor_details_with_edit.dart';
import '../Wishlist/Wishlist.dart';
import '../profile/profile_screen.dart';
import 'enums.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CustomBottomNavBarVendor extends StatefulWidget {
  /* CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
    required this.bototmBarColor,
    required this.bottomMenuIconColor
  }) : super(key: key);
*/

  MenuStateVendor selectedMenu;
  Color bototmBarColor, bottomMenuIconColor;

  @override
  _CustomBottomNavBar createState() => _CustomBottomNavBar(selectedMenu,bototmBarColor,bottomMenuIconColor);

  CustomBottomNavBarVendor(
      this.selectedMenu, this.bototmBarColor, this.bottomMenuIconColor);
}

class _CustomBottomNavBar extends State<CustomBottomNavBarVendor> {
  final MenuStateVendor selectedMenu;

  _CustomBottomNavBar(this.selectedMenu,this.bototmBarColor,this.bottomMenuIconColor);

  Color bototmBarColor, bottomMenuIconColor;
  Color inActiveIconColor = Color(0xFFB6B6B6);
  String? userType = '';
  void getappUi() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? bottomBarColor =prefs.getString('bottomBarColor');
    String? bottombarIcon =prefs.getString('bottomBarIconColor');
   userType = prefs.getString('user_type');
    print("bottom bar ${userType}");

    if(bottomBarColor!=null){
      this.bototmBarColor=Color(int.parse(bottomBarColor));
      setState(() {});
    }

    if(bottombarIcon!=null){
      this.bottomMenuIconColor=Color(int.parse(bottombarIcon));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    getappUi();
    return Container(
      height: 40,
      // padding: EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        color: bototmBarColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        /* borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),*/
      ),
      child: SafeArea(
          top: false,
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.home_outlined,
                    size: 25,
                    color: MenuStateVendor.home == selectedMenu
                        ? bottomMenuIconColor
                        : inActiveIconColor,
                  ),
                  onPressed: () =>
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) =>  VendorDetailsWithEdit("0")))

                // Navigator.pushNamed(context, HomeScreen.routeName),
              ),
              IconButton(
                  icon: Icon(
                    Icons.person_outline,
                    size: 25,
                    color: MenuStateVendor.profile == selectedMenu
                        ? bottomMenuIconColor
                        : inActiveIconColor,
                  ),
                  onPressed: () =>
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => ProfileScreen()))

                // Navigator.pushNamed(context, ProfileScreen.routeName),
              ),
            ],
          )

      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //  getappUi();
  }
}
