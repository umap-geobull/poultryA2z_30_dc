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

class Write_post extends StatelessWidget {

  // String user_id;
  // String admin_id;

  Write_post();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)),

      child: Column(
        children: <Widget>[
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(10),
            //   child:
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: <Widget>[
                  // Expanded(
                  //     flex: 1,
                  //     child:
                  //     Padding(
                  //         padding: EdgeInsets.only(
                  //             left: 10,
                  //             right: 10,
                  //             top: 0,
                  //             bottom: 0),
                  //         child:
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(100),
                                child: Container(
                                    height: 30,
                                    width: 30,
                                    child: Image.asset(
                                        'assets/consultant1.jpeg'),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                          100),
                                      color: Colors.grey[400],
                                    )),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              SizedBox(
                                height: 50,
                                child: TextField(
                                  //controller: tv_expected_salary,
                                  decoration: const InputDecoration(
                                    contentPadding:
                                    EdgeInsets.all(15),
                                    suffixIcon: Icon(Icons.send),
                                    border: OutlineInputBorder(),
                                    labelText: 'Write a post',
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                              )
                            ],
                          ),
                      // ),
    // ),
                  // Expanded(
                  //     flex: 1,
                  //     child:
                  //     SizedBox(
                  //         width: MediaQuery.of(context).size.width,
                  //         child: Padding(
                  //           padding: EdgeInsets.only(
                  //               left: 10,
                  //               right: 10,
                  //               bottom: 2,
                  //               top: 5),
                  //           child:
                  //
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                // Icon(Icons.location_on, color: kMainColor,size: 20,),
                                // SizedBox(width: 5,),
                                Flexible(
                                    child: Text(' Add Photos')),
                                Divider(
                                  height: 5,
                                ),
                                Flexible(child: Text('Add Videos'))
                              ],
                            ),
                          // ))
                  // ),
                // ],
              // ),
            // ),
        ],
      ),

    );
  }
}

