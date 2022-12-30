import 'package:flutter/material.dart';

class AddText{
  String text;
  Offset text_position=Offset(0.0,0.0);
  double x_text=0.0;
  double y_text=0.0;
  bool isSelected=false;
  Color textColor=Colors.red;
  double  textSize=20;
  String fontFamilyText = "Roboto";
  Color backgroundColor=Colors.transparent;

  AddText(this.text);
}