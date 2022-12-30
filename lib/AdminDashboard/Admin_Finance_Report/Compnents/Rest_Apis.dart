
import 'package:flutter/material.dart';
import 'package:poultry_a2z/AdminDashboard/Admin_Finance_Report/Compnents/Model/AdminFinanceModel.dart';
import 'package:poultry_a2z/AdminDashboard/Admin_Sales_Report/Compnents/Model/Vendor_Sales_Model.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class Rest_Apis{

  Future<List<FinanceModel>?> getVendorFinanceReport(String vendorId,String startDate,String endDate,
      String baseUrl, String admin_auto_id) async {
    print("vendor_id=>"+vendorId);
    final body = {
      "user_auto_id": vendorId,
      "start_date": startDate,
      "end_date": endDate,
      "admin_auto_id" : admin_auto_id,
    };

    var url = baseUrl+ 'api/' + get_Finance_Reports;

    List<FinanceModel> financeList=[];

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      print(response.statusCode.toString());
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print(status.toString());
      if(status==1){
        financeList = FinanceReportsModel.fromJson(json.decode(response.body)).data;
      }
      else{
        financeList=[];
      }
    }
    else if(response.statusCode== 500) {
      print(response.statusCode.toString());
      financeList=[];
      Fluttertoast.showToast(msg: "Server Error...please try after some time", backgroundColor: Colors.grey,);
    }

    return financeList;
  }

}