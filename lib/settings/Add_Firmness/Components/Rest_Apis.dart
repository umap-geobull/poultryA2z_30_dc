import 'package:poultry_a2z/Utils/App_Apis.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'Firmness_List_Model.dart';

class Rest_Apis{

  Future<List<GetFirmnessData>?> Get_Firmness_List(String admin_auto_id, String baseUrl) async {

    var url = baseUrl+'api/' + get_firmness;

    List<GetFirmnessData>? getFirmnessList;

    Uri uri=Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
    };
    final response = await http.post(uri, body: body);

   if(response.statusCode==200){
     final resp = jsonDecode(response.body);
     int  status = resp['status'];

     if (status == 1) {
       getFirmnessList = FirmnessListModel.fromJson(json.decode(response.body)).data;
     }
     else if(status == 0){
       Fluttertoast.showToast(msg: "No Firmness found", backgroundColor: Colors.grey,);
       getFirmnessList = [];
     }
     else{
       Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
       getFirmnessList = [];
     }
   }
   else if(response.statusCode==500){
     Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
     getFirmnessList=[];
   }
    return getFirmnessList;
  }


  Future<int?> Delete_Firmness(String firmness_autoid, String admin_auto_id, String baseUrl) async {
    final body = {
      "firmness_auto_id": firmness_autoid,
      "admin_auto_id":admin_auto_id,
    };

    var url =baseUrl+'api/'+delete_firmness;

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

  Future<String?> Add_firmness_Api(String firmness_name, String admin_auto_id, String baseUrl) async {
    final body = {
      "firmness_type": firmness_name,
      "admin_auto_id":admin_auto_id,
    };

    var url =baseUrl+'api/'+add_firmness;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    String? status;

    //print("response=>" + response.body.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);

      status = resp['status'];
    } else {
      // Fluttertoast.showToast(msg: "Something went wrong ,Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }
}