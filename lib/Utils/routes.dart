import 'package:flutter/widgets.dart';
import 'package:poultry_a2z/Home/Home_Screen.dart';
import 'package:poultry_a2z/Spalsh_screen/splash_screen.dart';
import 'package:poultry_a2z/grobiz_start_pages/app_maintenance_screen.dart';
import 'package:poultry_a2z/profile/profile_screen.dart';

import '../poultry_vendor/Vendor_details_with_edit.dart';


// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
 // SplashScreen.routeName: (context) => SplashScreen(),
  //Subcategory_home.routeName: (context) => Subcategory_home(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  VendorDetailsWithEdit.routeName: (context) =>  VendorDetailsWithEdit("0"),


};
