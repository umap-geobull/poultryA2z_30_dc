import 'package:flutter/material.dart';

import '../../../Admin_add_Product/constants.dart';
import '../../../Utils/constants.dart';
import '../../Vendor_Coupon_code/Vendor_Coupen_code_Screen.dart';
import '../../Vendor_Finanace/Vendor_Finance_home_screen.dart';
import '../../Vendor_Inventory/Vendor_Inventory_Screen.dart';
import '../../Vendor_Invoice/Vendor_Invoice_Screen.dart';
import '../../Vendor_Orders/Vendor_Order_Screen.dart';
import '../../Vendor_Sales_Report/Vendor_Sales_Screen.dart';
import 'Vendor_Products.dart';

class Vendor_Menu extends StatelessWidget {

  List<Map<String, dynamic>> vendor_menu_List = [
    {"text": "Orders"},
    {"text": "Sales"},
    {"text": "Finance"},
    {"text": "Inventory"},
    {"text": "Products"},
    {"text": "Coupons"},
    {"text": "Invoice"},
  ];
  late String Vendor_id;
  late String admin_id;
  Vendor_Menu(String vendorId)
  {
    Vendor_id=vendorId;
    admin_id="636bafd640e19ce8b70a92e2";
    print('Vendorid=>'+Vendor_id);
    print('adminid=>'+admin_id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        SizedBox(
          height: 50,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: vendor_menu_List.length,
              itemBuilder: (context, index) => CategoryCard(
                text: vendor_menu_List[index]["text"],
                press: () {
                  if(vendor_menu_List[index]["text"] == "Orders")
                  {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Vendor_Order_Screen(Vendor_id)),);
                  }
                  else if(vendor_menu_List[index]["text"] == "Sales")
                  {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Venders_Sales(s_date: '',e_date: '',s_date1: '',e_date1: '',vendor_id:Vendor_id)),);
                  }
                  else if(vendor_menu_List[index]["text"] == "Finance")
                  {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Vendor_Finanace_home_screen()));
                  }
                  else if(vendor_menu_List[index]["text"] == "Inventory")
                  {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Venders_Invetory(vendor_id:Vendor_id,admin_id: admin_id,)),);
                  }
                  else if(vendor_menu_List[index]["text"] == "Products")
                  {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Vendor_Products(main_cat_id: '', brand_id: '', type: "show_all", sub_cat_id: '',vendor_id: Vendor_id,)));
                  }

                  else if(vendor_menu_List[index]["text"] == "Coupons")
                  {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Vendor_Coupen_code(Vendor_id: Vendor_id,)));
                  }
                  else if(vendor_menu_List[index]["text"] == "Invoice")
                  {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Vendor_Invoice_Screen()));
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
          margin: const EdgeInsets.all(5),
          height: 40,
          width: 100,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 10, left: 10, right: 10),
            child: Text(
              text!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 15,
                  color: appBarIconColor,
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
