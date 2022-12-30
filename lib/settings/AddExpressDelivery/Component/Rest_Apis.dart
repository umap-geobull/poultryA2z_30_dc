import 'package:poultry_a2z/Utils/App_Apis.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/settings/AddExpressDelivery/Component/ExpressDelivery_Model.dart';
import 'package:http/http.dart' as http;
class Rest_Apis{

  Future<List<ExpressDelivery>?> getExpressCharges(String admin_auto_id, String baseUrl) async {

    var url = baseUrl+'api/' + get_express_delivery_details;

    List<ExpressDelivery>? expressCharges;

    Uri uri=Uri.parse(url);

    final body = {
      "admin_auto_id":admin_auto_id,
    };

    final response = await http.post(uri, body: body);
    if(response.statusCode==200){
      final resp = jsonDecode(response.body);
      int  status = resp['status'];

      if (status == 1) {
        expressCharges = ExpressDelivery_Model.fromJson(json.decode(response.body)).data;
      }
      else if(status == 0){
        Fluttertoast.showToast(msg: "No express delivery charge added", backgroundColor: Colors.grey,);
        expressCharges = [];
      }
      else{
        Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
        expressCharges = [];
      }
    }
    else if(response.statusCode==500){
      Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
      expressCharges=[];
    }
    return expressCharges;
  }


  Future<String?> Add_Express_Delivery_Api(String id,String charges, String admin_auto_id, String baseUrl) async {
    final body = {
      "id": id,
      "express_delivery_charges":charges,
      "admin_auto_id":admin_auto_id,
    };

    var url =baseUrl+'api/'+update_express_delivery_details;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    String? status;
    print("response=>" + response.body.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);

      status = resp['status'].toString();
    } else {
      // Fluttertoast.showToast(msg: "Error while creating schedule. Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }
}