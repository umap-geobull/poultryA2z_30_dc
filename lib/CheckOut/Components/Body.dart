import 'package:flutter/material.dart';
import 'package:poultry_a2z/CheckOut/Components/Delivery_Address.dart';

import 'Apply_Coupen_Code.dart';
import 'Select_Payment_Option.dart';
import 'Upload_Documents.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          Delivery_Address(),
          Divider(color: Colors.grey),
          Select_Payment_Option(),
          Divider(color: Colors.grey),
          Upload_Documents(),
          Divider(color: Colors.grey),
          Coupen_Code_Screen(),
          Divider(color: Colors.grey),
          SizedBox(height: 15,)


        ],
      ),
    );
  }
}
