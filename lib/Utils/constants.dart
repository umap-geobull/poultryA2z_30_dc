import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';


const appBarColor = Color(0xFFFFFFFF);
const appBarIconColor = Color(0xFF282727);
const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);
const Color black = Color(0xFF000000);
const Color white = Color(0xFFffffff);
final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(20),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kNameError = "Please Enter your name";
const String kMobileError = "Please Enter your mobile";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kAddressNullError = "Please Enter your address";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
//const String app_under_maintenance_message = "The app is undergoing maintenance kindly get back to us at 7pm IST.We regret for the inconvenience.Let us know are you continue with is app?";

const String app_under_maintenance_message = "The app is undergoing maintenance.You may face few glitches.Kindly be patient, We regret for the inconvenience caused.";
const String home_component_show_in_msg = "Please selected atleast one place to show this component(Show in home/ any main category";

final otpInputDecoration =
InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: 10),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(color: kTextColor),
  );
}