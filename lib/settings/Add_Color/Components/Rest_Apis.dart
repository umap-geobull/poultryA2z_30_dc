import 'package:poultry_a2z/Utils/App_Apis.dart';

import 'Color_List_Model.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
class Rest_Apis{

  Future<List<GetColorList>?> getColorList(String admin_auto_id, String baseUrl) async {

    var url = baseUrl+'api/' + get_color_list;

    List<GetColorList>? getColorList;

    Uri uri=Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,

    };
    final response = await http.post(uri, body: body);

   if(response.statusCode==200){
     final resp = jsonDecode(response.body);
     int  status = resp['status'];

     if (status == 1) {
       getColorList = ColorListModel.fromJson(json.decode(response.body)).getColorList;
     }
     else if(status == 0){
       Fluttertoast.showToast(msg: "No colors found", backgroundColor: Colors.grey,);
       getColorList = [];
     }
     else{
       Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
       getColorList = [];
     }
   }
   else if(response.statusCode==500){
     Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
     getColorList=[];
   }
    return getColorList;
  }


  Future<int?> Delete_Color(String colorId, String admin_auto_id, String baseUrl) async {
    final body = {
      "color_auto_id": colorId,
      "admin_auto_id":admin_auto_id,
    };
    print('color_id :'+colorId);

    var url =baseUrl+'api/'+delete_color;

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

  Future<String?> Add_Color_Api(String color, String admin_auto_id, String baseUrl) async {
    final body = {
      "color_name": color,
      "color_img":'',
      "admin_auto_id":admin_auto_id,
    };

    var url =baseUrl+'api/'+add_color;

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
}