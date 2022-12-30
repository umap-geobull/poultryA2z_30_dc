
import 'package:poultry_a2z/Vendor_Module/Vendor_Home/Utils/App_Apis.dart';

import 'Components/Model/Coupen_Code_Info_Model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Rest_Apis {
  Future<Coupen_Code_Info_Model?> getCoupen_CodeList(String userId, String baseUrl, String admin_auto_id) async {

    final body = {
      "admin_auto_id" : admin_auto_id,
      "user_auto_id": userId,
    };

    var url = baseUrl+'api/'+ get_all_coupen_code;

    Coupen_Code_Info_Model? coupenCodeInfoModel;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];

    if (status == 1) {
      coupenCodeInfoModel = Coupen_Code_Info_Model.fromJson(json.decode(response.body));
    }
    else if(status == 0){
      Fluttertoast.showToast(msg: "No Coupon code found", backgroundColor: Colors.grey,);
      coupenCodeInfoModel = null;
    }
    else{
      Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
    }
    return coupenCodeInfoModel;
  }

  Future<String?> add_coupen_code(String userId, String type,String coupenCode, String coupenCodeValue,
      String coupenCodeDesc, String startDate, String endDate, String baseUrl, String admin_auto_id) async {
    final body = {
      "user_auto_id": userId,
      "type": type,
      "coupen_code": coupenCode,
      "coupen_code_value": coupenCodeValue,
      "coupen_code_desc": coupenCodeDesc,
      "start_date": startDate,
      "end_date":endDate,
      "admin_auto_id" : admin_auto_id,
    };

    var url =baseUrl+'api/'+add_new_coupen_code;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    String message;
    String? status;
    print("response=>" + response.body.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      // message = resp['msg'];
      status = resp['status'];
    } else {
      // Fluttertoast.showToast(msg: "Error while creating schedule. Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }

  Future<String?> update_coupen_code(String? coupenId,String userId, String type,String coupenCode,
      String coupenCodeValue, String coupenCodeDesc, String startDate, String endDate, String baseUrl, String admin_auto_id) async {
    final body = {
      "coupon_auto_id":coupenId,
      "user_auto_id": userId,
      "type": type,
      "coupen_code": coupenCode,
      "coupen_code_value": coupenCodeValue,
      "coupen_code_desc": coupenCodeDesc,
      "start_date": startDate,
      "end_date":endDate,
      "admin_auto_id" : admin_auto_id,
    };

    var url =baseUrl+'api/'+edit_coupen_code;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);


    String? status;
    print("response=>" + response.body.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);

      status = resp['status'];
    } else {
      // Fluttertoast.showToast(msg: "Error while creating schedule. Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }

  Future<int?> Delete_coupon_code(String? coupenId,String userId, String baseUrl, String admin_auto_id) async {
    final body = {
      "user_auto_id": userId,
      "coupon_auto_id":coupenId,
      "admin_auto_id" : admin_auto_id,
    };

    var url =baseUrl+'api/'+delete_coupen_code;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    int? status;
    print("response=>" + response.body.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);

      status = resp['status'];
    } else {
      // Fluttertoast.showToast(msg: "Error while creating schedule. Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }
}