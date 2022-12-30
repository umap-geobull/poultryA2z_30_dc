import 'package:flutter/material.dart';
import 'package:poultry_a2z/Customer_List/CustomerList_Model.dart';
import 'package:poultry_a2z/Vendor_List/VendorList_Model.dart';
import '../../Utils/App_Apis.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'dart:convert';

import 'package:http/http.dart' as http;


class Rest_Apis{

  Future< List<GetCustomerLists>?> getCustomersList(String baseUrl, String admin_auto_id) async {

    var url = baseUrl +'api/'+ get_customer_lists;

    List<GetCustomerLists>? getCustomerLists;

    Uri uri=Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
    };

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];

    if (response.statusCode == 200) {
      if(status==1){
        getCustomerLists = CustomerList_Model.fromJson(json.decode(response.body)).getCustomerLists;
      }
      else{
        getCustomerLists = [];
      }

    }
    else if (response.statusCode == 500){
      getCustomerLists = [];
      Fluttertoast.showToast(
        msg: "Server Error",
        backgroundColor: Colors.grey,
      );
    }

    return getCustomerLists;
  }


  Future<VendorList_Model?> getVendorsList(String baseUrl) async {

    var url = baseUrl+'api/' + get_all_vendor_list;

    VendorList_Model? getVendorList;

    Uri uri=Uri.parse(url);

    final response = await http.get(uri);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];

    if (response.statusCode == 200) {

      getVendorList = VendorList_Model.fromJson(json.decode(response.body));

    } else {
      getVendorList = null;
    }

    return getVendorList;
  }

  Future<int> updateStatus(String baseUrl,String user_auto_id,String user_type,String user_status) async {

    final body = {
      "user_auto_id": user_auto_id,
      "user_type": user_type,
      "status": user_status,
    };

    var url = baseUrl +'api/'+ update_user_status;


    Uri uri=Uri.parse(url);

    final response = await http.post(uri,body: body);
    print(response.toString());
    final resp = jsonDecode(response.body);
    int  status = resp['status'];
    String  msg = resp['msg'];

    if (response.statusCode == 200) {
      print(response.statusCode.toString());
      if(status==1){
        Fluttertoast.showToast(
          msg: "User status updated successfully",
          backgroundColor: Colors.grey,
        );
      }
      else {
        Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.grey,
        );
      }
    }
    else if (response.statusCode == 500) {
      Fluttertoast.showToast(
        msg: 'Server Error',
        backgroundColor: Colors.grey,
      );
    }
    return status;
  }

}