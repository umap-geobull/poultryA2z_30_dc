import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/Utils/size_config.dart';



class GraphicContent extends StatelessWidget {
  const GraphicContent({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        Text(
          "Ecommerce",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(36),
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text!,
          textAlign: TextAlign.center,
        ),
        const Spacer(flex: 2),
        Image.asset(
          image!,
          height: getProportionateScreenHeight(200),
          width: getProportionateScreenWidth(235),
        ),
      ],
    );
  }
}
