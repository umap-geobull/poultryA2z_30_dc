import 'package:poultry_a2z/Utils/App_Apis.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'Material_List_Model.dart';

class Rest_Apis{

  Future<List<GetMaterialData>?> Get_Material_List(String admin_auto_id, String baseUrl) async {

    var url = baseUrl+'api/' + get_material;

    List<GetMaterialData>? getMaterialList;

    Uri uri=Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
    };
    final response = await http.post(uri, body: body);

   if(response.statusCode==200){
     final resp = jsonDecode(response.body);
     int  status = resp['status'];

     if (status == 1) {
       getMaterialList = MaterialListModel.fromJson(json.decode(response.body)).data;
     }
     else if(status == 0){
       Fluttertoast.showToast(msg: "No material found", backgroundColor: Colors.grey,);
       getMaterialList = [];
     }
     else{
       Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
       getMaterialList = [];
     }
   }
   else if(response.statusCode==500){
     Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
     getMaterialList=[];
   }
    return getMaterialList;
  }


  Future<int?> Delete_Material(String material_autoid, String admin_auto_id, String baseUrl) async {
    final body = {
      "material_auto_id": material_autoid,
      "admin_auto_id":admin_auto_id,
    };

    var url =baseUrl+'api/'+delete_material;

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

  Future<String?> Add_material_Api(String material_name, String admin_auto_id, String baseUrl) async {
    final body = {
      "material_name": material_name,
      "admin_auto_id":admin_auto_id,
    };

    var url =baseUrl+'api/'+add_material;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    String? status;

    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);

      status = resp['status'];
    } else {
      // Fluttertoast.showToast(msg: "Something went wrong ,Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }
}