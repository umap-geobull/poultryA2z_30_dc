import 'package:poultry_a2z/Utils/App_Apis.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/settings/AddExpressDelivery/Component/ExpressDelivery_Model.dart';
import 'package:http/http.dart' as http;
class Rest_Apis{

  Future<ExpressDelivery_Model?> getExpressCharges(String baseUrl) async {

    var url = baseUrl+'api/' + get_express_delivery_details;

    ExpressDelivery_Model? expressDeliveryModel;

    Uri uri=Uri.parse(url);

    final response = await http.get(uri,);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];

    if (status == 1) {

      expressDeliveryModel = ExpressDelivery_Model.fromJson(json.decode(response.body));
    } else if(status == 0){
      Fluttertoast.showToast(msg: "No data found", backgroundColor: Colors.grey,);
      expressDeliveryModel = null;
    }
    else{
      Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
    }
    return expressDeliveryModel;
  }

  Future<String?> Add_Express_Delivery_Api(String id,String charges,String baseUrl) async {
    final body = {
      "id": id,
      "express_delivery_charges":charges,
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