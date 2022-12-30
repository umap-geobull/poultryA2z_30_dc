import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HomeStyleModel {

  int subCategoryCrossAxisCount = 3; //only 3/2/4
  int topPerformingBrandCrossAxisCount = 4; //only 3/2/4
  int recommendedCrossAxisCount = 4; //only 3/2/4
  int bestBrandCrossAxisCount = 4;

  double subCatHeaderSize = 17; //max 20
  double topBrandHeaderSize = 17; //max 20
  double recommendedHeaderSize = 17; //max 20
  double bestBrandHeaderSize = 17; //max 20
  double mainCatSize = 12; //max 12
  double subCatSize = 12; //max 16
  double topBrandSize = 12; //max 16
  double recommendedSize = 12; //max 16
  double bestBrandSize = 12; //max 16

  //colors
  String primaryAppColor = '0xFFFF7643';
  String primaryLightColor = '0xFFFFECDF';
  String homeMenuIconColor = '0xFFFFFFF';
  String bottomMenuIconColor = '0xFFFF7643';
  String searchBackgroundColor = '0xFFFFFFFF';
  String searchFrontColor = '0xFFBDBDBD';
  String saveAddressColor ='0xFF000000';
  String subCatHeaderColor = '0xFF303030';
  String topBrandHeaderColor = '0xFF303030';
  String bestBrandHeaderColor = '0xFF303030';
  String recommendedHeaderColor = '0xFF303030';
  String mainCatColor = '0xFFBDBDBD';
  String subCatColor = '0xFF616161';
  String topBrandColor = '0xFF616161';
  String recommendedColor = '0xFF616161';
  String bestBrandColor = '0xFF616161';
}

class SaveHomeStyle{

  static Future<void> saveStyle(HomeStyleModel homeStyleModel) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('home_style', jsonEncode(homeStyleModel.toString()));
  }

  static Future<HomeStyleModel> getStyle() async {
    final prefs = await SharedPreferences.getInstance();
    String? settingVal = prefs.getString('home_style');

    HomeStyleModel homeStyleModel = (json.decode(settingVal!));

    return homeStyleModel;
  }

}
