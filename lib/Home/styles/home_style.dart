import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

const int subCategoryCrossAxisCount = 4; //only 3/2/4
const int topPerformingBrandCrossAxisCount = 4; //only 3/2/4
const int recommendedCrossAxisCount = 4; //only 3/2/4
const int bestBrandCrossAxisCount = 4; //only 3/2/4

//sizes
const double subCatHeaderSize = 17; //max 20
const double topBrandHeaderSize = 17; //max 20
const double recommendedHeaderSize = 17; //max 20
const double bestBrandHeaderSize = 17; //max 20
const double mainCatSize = 12; //max 12
const double subCatSize = 12; //max 16
const double topBrandSize = 12; //max 16
const double recommendedSize = 12; //max 16
const double bestBrandSize = 12; //max 16

const Color primaryAppColor = Color(0xFFFF7643);
const Color primaryLightColor = Color(0xFFFFECDF);
const Color homeMenuIconColor = Color(0xFFFFFFFF);
const Color bottomMenuIconColor = Color(0xFFFF7643);
const Color searchBackgroundColor = Color(0xFFFFFFFF);
const Color searchFrontColor = Color(0xFFBDBDBD);
const Color saveAddressColor = Color(0xFF000000);
const Color subCatHeaderColor = Color(0xFF303030);
const Color topBrandHeaderColor = Color(0xFF303030);
const Color bestBrandHeaderColor = Color(0xFF303030);
const Color recommendedHeaderColor = Color(0xFF303030);
const Color mainCatColor = Color(0xFFBDBDBD);
const Color subCatColor = Color(0xFF616161);
const Color topBrandColor = Color(0xFF616161);
const Color recommendedColor = Color(0xFF616161);
const Color bestBrandColor = Color(0xFF616161);

//test family
const subCatHeaderFamily = 'Lato';
const topBrandHeaderFamily = 'Lato';
const recommendedHeaderFamily = 'Lato';
const bestBrandHeaderFamily = 'Lato';
const searchTextFamily = 'Lato';
const addressTextFamily = 'Lato';
const mainCatTextFamily = 'Lato';
const subCatTextFamily = 'Lato';
const topBrandTextFamily = 'Lato';
const recommendedTextFamily = 'Lato';
const bestBrandTextFamily = 'Lato';


//styles
final TextStyle homeSearchStyle= GoogleFonts.getFont(searchTextFamily).copyWith(
    fontSize:14,
    fontWeight: FontWeight.normal,
    color: searchFrontColor);

final TextStyle homeAddressStyle= GoogleFonts.getFont(addressTextFamily).copyWith(
    fontSize:15,
    fontWeight: FontWeight.normal,
    color: saveAddressColor);

final TextStyle mainCatStyle= GoogleFonts.getFont(mainCatTextFamily).copyWith(
    fontSize:mainCatSize,
    fontWeight: FontWeight.bold,
    color: mainCatColor);

final TextStyle subCatStyle= GoogleFonts.getFont(subCatTextFamily).copyWith(
    fontSize:subCatSize,
    fontWeight: FontWeight.normal,
    color: subCatColor);

final TextStyle topBrandStyle= GoogleFonts.getFont(topBrandTextFamily).copyWith(
    fontSize:topBrandSize,
    fontWeight: FontWeight.normal,
    color: topBrandColor);

final TextStyle recommendedStyle= GoogleFonts.getFont(recommendedTextFamily).copyWith(
    fontSize:recommendedSize,
    fontWeight: FontWeight.normal,
    color: recommendedColor);


final TextStyle bestBrandStyle= GoogleFonts.getFont(bestBrandTextFamily).copyWith(
    fontSize:bestBrandSize,
    fontWeight: FontWeight.normal,
    color: bestBrandColor);

final TextStyle subCatHeaderStyle= GoogleFonts.getFont(subCatHeaderFamily).copyWith(
    fontSize:subCatHeaderSize,
    fontWeight: FontWeight.normal,
    color: subCatHeaderColor);

final TextStyle topBrandHeaderStyle= GoogleFonts.getFont(topBrandHeaderFamily).copyWith(
    fontSize:topBrandHeaderSize,
    fontWeight: FontWeight.normal,
    color: topBrandHeaderColor);

final TextStyle recommendedHeaderStyle= GoogleFonts.getFont(recommendedHeaderFamily).copyWith(
    fontSize:recommendedHeaderSize,
    fontWeight: FontWeight.normal,
    color: recommendedHeaderColor);

final TextStyle bestBrandHeaderStyle= GoogleFonts.getFont(bestBrandHeaderFamily).copyWith(
    fontSize:bestBrandHeaderSize,
    fontWeight: FontWeight.normal,
    color: bestBrandHeaderColor);
