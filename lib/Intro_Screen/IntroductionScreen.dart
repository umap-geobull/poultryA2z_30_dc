import 'package:flutter/material.dart';
import 'package:poultry_a2z/Intro_Screen/Component/body.dart';
import 'package:poultry_a2z/Utils/size_config.dart';

class IntroScreen extends StatelessWidget {
  static String routeName = "/splash";
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}