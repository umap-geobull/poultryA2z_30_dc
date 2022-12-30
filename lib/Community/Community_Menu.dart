import 'package:poultry_a2z/AdminDashboard/Admin_Coupon_code/Vendor_Coupen_code_Screen.dart';
import 'package:poultry_a2z/AdminDashboard/Admin_Finance_Report/Finance_Screen.dart';
import 'package:poultry_a2z/AdminDashboard/Admin_Inventory/Vendor_Inventory_Screen.dart';
import 'package:poultry_a2z/AdminDashboard/Admin_Invoice/Vendor_Invoice_Screen.dart';
import 'package:poultry_a2z/AdminDashboard/Admin_Products/Admin_Product_List.dart';
import 'package:poultry_a2z/AdminDashboard/Admin_Sales_Report/Vendor_Sales_Screen.dart';
import 'package:poultry_a2z/AdminDashboard/Delivery_Partner/Select_Delivery_Merchant.dart';
import 'package:poultry_a2z/AdminDashboard/PaymentMerchant/Select_Payment_Merchant.dart';
import 'package:poultry_a2z/Admin_Product_Opreation/Approval_Screen.dart';
import 'package:poultry_a2z/Customer_List/Customer_List.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Vendor_List/Vendors_List.dart';
import 'package:poultry_a2z/settings/Setting_Screen.dart';
import '../Admin_add_Product/constants.dart';

class Community_Menu extends StatelessWidget {

  // String user_id;
  // String admin_id;

  Community_Menu();

  List<Map<String, dynamic>> vendor_menu_List = [
    {"text": "About Disease"},
   // {"text": "Approvals"},
    {"text": "About Management"},
   // {"text": "Vendor List"},
    {"text": "About Feed"},
    {"text": "About Farm"},
    // {"text": "Inventory"},
    // {"text": "Sales"},
    // //{"text": "Finance"},
    // {"text":"Invoice"},
    // {"text":"Coupons"},
    // {"text" : "Payment Gateway"},
    // {"text" : "Delivery Partner"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 40,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: vendor_menu_List.length,
              itemBuilder: (context, index) => CategoryCard(
                text: vendor_menu_List[index]["text"],
                press: () {
                  if(vendor_menu_List[index]["text"] == "About Disease") {
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Vendor_Order_Screen()),);
                  }
                  else if(vendor_menu_List[index]["text"] == "About Management") {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => Approval_Screen()));
                  }
                  else if(vendor_menu_List[index]["text"] == "About Feed") {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
                  }
                  else if(vendor_menu_List[index]["text"] == "About Farm") {
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Vendors_List()),);
                  }
                  else if(vendor_menu_List[index]["text"] == "Customer List") {
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Customer_List()));
                  }
                  else if(vendor_menu_List[index]["text"] == "Products") {
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Admin_Product_List()),);
                  }
                  else if(vendor_menu_List[index]["text"] == "Sales") {
                    /*Navigator.of(context).push(MaterialPageRoute(builder: (context) => Venders_Sales(s_date: '',e_date: '',
                        s_date1: '',e_date1: '',vendor_id:user_id)),);*/
                  }
                  else if(vendor_menu_List[index]["text"] == "Finance") {
                    /*Navigator.of(context).push(MaterialPageRoute(builder: (context) => Admin_Finance(s_date: '',e_date: '',
                        s_date1: '',e_date1: '',vendor_id:user_id)),);*/
                  }
                  else if(vendor_menu_List[index]["text"] == "Inventory") {
                   /* Navigator.of(context).push(MaterialPageRoute(builder: (context) => Venders_Invetory(vendor_id:user_id,
                      admin_id: admin_id,)),);*/
                  }
                  else if(vendor_menu_List[index]["text"] == "Invoice") {
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Vendor_Invoice_Screen()));
                  }
                  else if(vendor_menu_List[index]["text"] == "Coupons") {
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Vendor_Coupen_code(Vendor_id: user_id,)));
                  }
                  else if(vendor_menu_List[index]["text"] == "Payment Gateway") {
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Select_Payment_Merchant()));
                  }
                  else if(vendor_menu_List[index]["text"] == "Delivery Partner") {
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Select_Delivery_Merchant()));
                  }
                },
              )),
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String? text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: EdgeInsets.all(5),
          height: 38,
          child: Padding(
            padding: EdgeInsets.only(
                top: 5, bottom: 5, left: 15, right: 15),
            child: Text(
              text!,
              textAlign: TextAlign.center,
              softWrap: false,
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),

            gradient: vMenuGradientColor,
          )),
    );
  }
}
