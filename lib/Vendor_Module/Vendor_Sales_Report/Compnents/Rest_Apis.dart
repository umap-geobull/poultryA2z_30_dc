
import 'package:flutter/material.dart';

import '../../Vendor_Home/Utils/App_Apis.dart';
import '../../Vendor_Sales_Report/Compnents/Model/Vendor_Sales_Model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class Rest_Apis{

  Future<Vendor_Sales_Model?> getVendorSalesReport(String vendorId,String startDate,String endDate, String baseUrl) async {
    print("vendor_id=>"+vendorId);
    final body = {
      "user_auto_id": vendorId,
      "start_date": startDate,
      "end_date": endDate,
    };

    var url = baseUrl+ 'api/' + get_Vendor_Sale_Reports;

    Vendor_Sales_Model? getVendorSalesReport;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];

    if (response.statusCode == 200) {

      getVendorSalesReport = Vendor_Sales_Model.fromJson(json.decode(response.body));
    }else if(response.statusCode== 500)
      {
        Fluttertoast.showToast(msg: "Server Error...please try after some time", backgroundColor: Colors.grey,);
      }
    else{
      getVendorSalesReport = null;
    }
    return getVendorSalesReport;
  }

}