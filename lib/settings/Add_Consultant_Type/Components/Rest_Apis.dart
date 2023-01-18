import 'package:poultry_a2z/Utils/App_Apis.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'Consultant_Type_model.dart';


class Rest_Apis{

  Future<List<Consultant_typeList>?> Get_ConsultantType_List(String admin_auto_id, String baseUrl) async {

    var url = baseUrl+'api/' + get_consultant_type;

    List<Consultant_typeList>? getConsultantList;

    Uri uri=Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
    };
    final response = await http.post(uri, body: body);

   if(response.statusCode==200){
     final resp = jsonDecode(response.body);
     int  status = resp['status'];

     if (status == 1) {
       getConsultantList = Consulant_Type_model.fromJson(json.decode(response.body)).data;
     }
     else if(status == 0){
       Fluttertoast.showToast(msg: "No consultant type found", backgroundColor: Colors.grey,);
       getConsultantList = [];
     }
     else{
       Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
       getConsultantList = [];
     }
   }
   else if(response.statusCode==500){
     Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
     getConsultantList=[];
   }
    return getConsultantList;
  }


  Future<int?> Delete_Consulant_Type(String consultant_autoid, String admin_auto_id, String baseUrl) async {
    final body = {
      "consultant_type_id": consultant_autoid,
      "admin_auto_id":admin_auto_id,
    };

    var url =baseUrl+'api/'+delete_consultant_type;

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

  Future<int?> Add_consultanttype_Api(String consultant_type, String admin_auto_id, String baseUrl) async {
    final body = {
      "consultant_type": consultant_type,
      "admin_auto_id":admin_auto_id,
    };

    var url =baseUrl+'api/'+add_consultant_type;

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