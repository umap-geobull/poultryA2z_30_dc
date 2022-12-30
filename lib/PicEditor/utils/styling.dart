import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'colors.dart';

class AppTheme{

  AppTheme._();


  static final TextStyle no_data_text_style= TextStyle(
      color: primaryColor,
      fontSize: 15 ,
      fontWeight: FontWeight.normal,
      fontFamily: 'Lato');

  static final TextStyle dialog_title_text_style= TextStyle(
      color: primaryColor,
      fontSize: 15 ,
      fontWeight: FontWeight.bold,
      fontFamily: 'Lato');

  static final TextStyle select_details_label_text_style= TextStyle(
      color: black,
      fontSize: 11 ,
      fontFamily: 'Lato');

  static final TextStyle alert_dialog_action= TextStyle(
      color: white,
      fontSize: 15 ,
      fontWeight: FontWeight.bold,
      fontFamily: 'Lato');

  static final TextStyle profile_details= TextStyle(
      color: white,
      fontSize: 16 ,
      fontWeight: FontWeight.normal,
      fontFamily: 'Lato');

  static final TextStyle category_dropdown_text= TextStyle(
    color: black,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );


  static final TextStyle appbar_title= TextStyle(
      color: black,
      fontSize: 18 ,
      fontWeight: FontWeight.bold,
      fontFamily: 'Lato');

  static final TextStyle appbar_title_home= TextStyle(
      color: white,
      fontSize: 20 ,
      fontWeight: FontWeight.bold,
      fontFamily: 'Lato');

  static final TextStyle upgrade_text_style= TextStyle(
      color: white,
      fontSize: 14 ,
      fontWeight: FontWeight.bold,
      fontFamily: 'Lato');

  static final TextStyle profile_buttons_text_style= TextStyle(
      color: primaryColor,
      fontSize: 18 ,
      fontWeight: FontWeight.bold,
      fontFamily: 'Lato');

  static final TextStyle primary_button_text_style= TextStyle(
      color: white,
      fontSize: 15 ,
      fontWeight: FontWeight.bold,
      fontFamily: 'Lato');

  static final TextStyle text_button_text_style= TextStyle(
      color: primaryColor,
      fontSize: 20 ,
      fontWeight: FontWeight.normal,
      fontFamily: 'Lato');

  static final TextStyle fest_date_text_style= TextStyle(
      color: primaryColor,
      fontSize: 12 ,
      fontWeight: FontWeight.normal,
      fontFamily: 'Lato');

  static final TextStyle small_button_text_style= TextStyle(
      color: white,
      fontSize: 13 ,
      fontWeight: FontWeight.bold,
      fontFamily: 'Lato');

  static final TextStyle home_label_text_style= TextStyle(
      color: primaryColor,
      fontSize: 17 ,
      fontWeight: FontWeight.bold,
      fontFamily: 'Lato');


  static final TextStyle SignIn_title= TextStyle(
      color: white,
      fontSize: 25 ,
      fontWeight: FontWeight.bold,
      fontFamily: 'Lato');

  static final TextStyle form_field_label_text= TextStyle(
      color: white,
      fontSize: 13,
      fontFamily: 'Lato');

  static final TextStyle otp_label_text= TextStyle(
      color: black,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontFamily: 'Lato');

  static final TextStyle form_field_label_text2= TextStyle(
      color: primaryColor,
      fontSize: 13,
      fontFamily: 'Lato');

  static final TextStyle otp_field_text= TextStyle(
      color: white,
      fontSize: 14 ,
      fontFamily: 'Lato');

  static final TextStyle form_field_text= TextStyle(
      color: form_field_text_black,
      fontSize: 14 ,
      fontFamily: 'Lato');
}