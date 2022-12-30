import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/settings/Add_Units/Components/product_unit_model.dart';
import 'package:http/http.dart' as http;
import '../../../Utils/App_Apis.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Rest_Apis{
  Future<int?> Delete_Unit(String? unitAutoId, String admin_auto_id, String baseUrl) async {
    final body = {
      "unit_auto_id":unitAutoId,
      "admin_auto_id":admin_auto_id,
    };

    var url =baseUrl+'api/'+delete_unit;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);


    int? status;
    print("response=>" + response.body.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);

      status = resp['status'];
    }
    else if(response.statusCode==500){
      status = 0;
      Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
    }

    return status;
  }

  Future<String?> Add_Unit(String unit, String admin_auto_id, String baseUrl) async {
    final body = {
      "unit":unit,
      "admin_auto_id":admin_auto_id,
    };

    var url =baseUrl+'api/'+add_product_unit;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);


    String? status;

    if(response!=null){
      if (response.statusCode == 200) {
        final resp = jsonDecode(response.body);

        status = resp['status'];
      }
      else if (response.statusCode == 500) {
        status ='0';
        Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
      }
    }

    return status;
  }

  Future<List<GetUnitList>?> getUnitList(String admin_auto_id, String baseUrl) async {

    List<GetUnitList>? _getUnitList;

    final body={
      "admin_auto_id":admin_auto_id,
    };
    var url = baseUrl+'api/' + get_product_unit;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    if(response.statusCode==200){
      final resp = jsonDecode(response.body);
      int  status = resp['status'];

      if (status == 1) {
        _getUnitList = ProductUnitModel.fromJson(json.decode(response.body)).getUnitList;
      }
      else if(status == 0){
        Fluttertoast.showToast(msg: "No unit found", backgroundColor: Colors.grey,);
        _getUnitList = [];
      }
      else{
        Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
        _getUnitList = [];
      }
    }
    else if (response.statusCode==500){
      Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
      _getUnitList = [];
    }

    return _getUnitList;
  }


}