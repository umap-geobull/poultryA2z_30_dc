import 'package:poultry_a2z/Utils/App_Apis.dart';

import 'Get_Pincode_List_Model.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
class Rest_Apis{

  Future<List<GetPincodeList>?> getPin_CodeList(String userAutoId,  String admin_auto_id, String baseUrl) async {

    final body = {
      "user_auto_id": "userAutoId",
      "admin_auto_id" : admin_auto_id,
    };

    print('user id:  '+userAutoId);

    var url = baseUrl+'api/' + get_pincode_list;

    List<GetPincodeList>? getPincodeListModel;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    if(response.statusCode==200){
      final resp = jsonDecode(response.body);
      int  status = resp['status'];

      if (status == 1) {
        getPincodeListModel = Get_Pincode_List_Model.fromJson(json.decode(response.body)).getPincodeList;
      }
      else if(status == 0){
        Fluttertoast.showToast(msg: "No Pin code found", backgroundColor: Colors.grey,);
        getPincodeListModel = [];
      }
      else{
        Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
        getPincodeListModel = [];
      }
    }
    else  if(response.statusCode==500){
      Fluttertoast.showToast(msg: "Server Error", backgroundColor: Colors.grey,);
      getPincodeListModel = [];
    }

    return getPincodeListModel;
  }

  Future<int?> Delete_Pin_code(String pincodeId,String userId, String admin_auto_id, String baseUrl) async {
    final body = {
      "user_auto_id": "userAutoId",
      "pincode_auto_id":pincodeId,
      "admin_auto_id" : admin_auto_id,
    };
    print('user id:  '+userId);


    var url =baseUrl+'api/'+delete_pincode;

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

  Future<String?> Add_Pin_code(String userId,  String admin_auto_id,  String pincode, String pincodePrice,String baseUrl) async {
    final body = {
      "user_auto_id": "userAutoId",
      "pincode":pincode,
      "price":pincodePrice,
      "admin_auto_id" : admin_auto_id,
    };

    print('user id:  '+userId);

    var url =baseUrl+'api/'+add_pincode;

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

  Future<String?> Edit_Pincode_List(String userId,  String admin_auto_id, String pincodesAutoId, String pincodePrice,String baseUrl) async {
    final body = {
      "user_auto_id": "userAutoId",
      "pincode_auto_id": pincodesAutoId,
      "price":pincodePrice,
      "admin_auto_id" : admin_auto_id,
    };

    var url =baseUrl+'api/'+edit_pincode;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    String message;
    String? status;
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      message = resp['msg'];
      status = resp['status'];
    } else {
      Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }

}