import 'package:poultry_a2z/Utils/App_Apis.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

// import 'Manufacturer_List_Model.dart';

class Rest_Apis{

  // Future<List<GetManufacturerList>?> Get_Manufacturer_List(String admin_auto_id, String baseUrl) async {
  //
  //   var url = baseUrl+'api/' + get_manufacturer;
  //
  //   List<GetManufacturerList>? getManufacturerList;
  //
  //   Uri uri=Uri.parse(url);
  //
  //   final body={
  //     "admin_auto_id":admin_auto_id,
  //   };
  //   final response = await http.post(uri, body: body);
  //
  //  if(response.statusCode==200){
  //    final resp = jsonDecode(response.body);
  //    int  status = resp['status'];
  //
  //    if (status == 1) {
  //      getManufacturerList = Manufacturer_List_Model.fromJson(json.decode(response.body)).data;
  //    }
  //    else if(status == 0){
  //      Fluttertoast.showToast(msg: "No manufacturer found", backgroundColor: Colors.grey,);
  //      getManufacturerList = [];
  //    }
  //    else{
  //      Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
  //      getManufacturerList = [];
  //    }
  //  }
  //  else if(response.statusCode==500){
  //    Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
  //    getManufacturerList=[];
  //  }
  //   return getManufacturerList;
  // }


  Future<int?> Delete_Manufacturer(String manufacturer_autoid, String admin_auto_id, String baseUrl) async {
    final body = {
      "manufacturer_auto_id": manufacturer_autoid,
      "admin_auto_id":admin_auto_id,
    };

    var url =baseUrl+'api/'+delete_manufacturer;

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

  Future<String?> Add_consultanttype_Api(String manufacturer_name, String admin_auto_id, String baseUrl) async {
    final body = {
      "manufacturer_name": manufacturer_name,
      "admin_auto_id":admin_auto_id,
    };

    var url =baseUrl+'api/'+add_manufacturer;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    String? status;

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