import 'package:poultry_a2z/Utils/App_Apis.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'SpecializationModel.dart';


class Rest_Apis{

  Future<List<SpecializationList>?> Get_Specialization_List(String admin_auto_id, String baseUrl) async {

    var url = baseUrl+'api/' + get_specialization;

    List<SpecializationList>? getspecList;

    Uri uri=Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
    };
    final response = await http.post(uri, body: body);

   if(response.statusCode==200){
     final resp = jsonDecode(response.body);
     int  status = resp['status'];

     if (status == 1) {
       getspecList = SpecializationModel.fromJson(json.decode(response.body)).data;
     }
     else if(status == 0){
       Fluttertoast.showToast(msg: "No specialization found", backgroundColor: Colors.grey,);
       getspecList = [];
     }
     else{
       Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
       getspecList = [];
     }
   }
   else if(response.statusCode==500){
     Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
     getspecList=[];
   }
    return getspecList;
  }


  Future<int?> Delete_Specialization(String specialization_autoid, String admin_auto_id, String baseUrl) async {
    final body = {
      "specialization_id": specialization_autoid,
      "admin_auto_id":admin_auto_id,
    };

    var url =baseUrl+'api/'+delete_specialization;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    int? status;

    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);

      status = resp['status'];
    } else {
      // Fluttertoast.showToast(msg: "Error while creating schedule. Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }

  Future<int?> Add_Specialization_Api(String manufacturer_name, String admin_auto_id, String baseUrl) async {
    final body = {
      "specialization": manufacturer_name,
      "admin_auto_id":admin_auto_id,
    };

    var url =baseUrl+'api/'+add_specialization;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    int? status;

    print("response=>" + response.body.toString());

    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);

      status = resp['status'];
    } else {
      // Fluttertoast.showToast(msg: "Something went wrong ,Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }
}