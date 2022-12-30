import 'package:poultry_a2z/Utils/App_Apis.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/settings/AddCurrency/Component/currency_list_model.dart';
import 'package:poultry_a2z/settings/AddDeliveryTime/Component/delivery_time_model.dart';
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

  Future<List<GetCurrencyList>?> getCurrencyList(String admin_auto_id, String baseUrl) async {

    var url = baseUrl+'api/' + get_currecy_list;

    List<GetCurrencyList>? getCurrencyList;

    Uri uri=Uri.parse(url);

    final body = {
      "admin_auto_id": admin_auto_id,
    };

    final response = await http.post(uri, body: body);

    if(response.statusCode==200){
      final resp = jsonDecode(response.body);
      int  status = resp['status'];

      if (status == 1) {
        getCurrencyList = CurrencyListModel.fromJson(json.decode(response.body)).getCurrencyList;
      }
      else if(status == 0){
        Fluttertoast.showToast(msg: "No currency found", backgroundColor: Colors.grey,);
        getCurrencyList= [];
      }
      else{
        Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
        getCurrencyList = [];
      }
    }
    else if (response.statusCode==500){
      Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
      getCurrencyList = [];
    }

    return getCurrencyList;

  }

  Future<int?> Delete_Currency(String currency_id, String admin_auto_id, String baseUrl) async {
    final body = {
      "currency_auto_id":currency_id,
      "admin_auto_id": admin_auto_id,
    };
    print('currency_auto_id:  '+currency_id);


    var url =baseUrl+'api/'+delete_currency;

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

  Future<String?> Add_Currency_Api(String country_name,String country_code,String currency,
      String flag_image, String express_delivery_charges, String admin_auto_id, String baseUrl) async {
    final body = {
      "country_name": country_name,
      "country_code":country_code,
      "currency":currency,
      "flag_image":flag_image,
      "admin_auto_id": admin_auto_id,
      "express_delivery_charges": express_delivery_charges,
    };

    var url =baseUrl+'api/'+add_currency;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    String? status;
    String msg='';
    print("response=>" + response.body.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      status = resp['status'].toString();
      msg= resp['msg'].toString();

      if(status!=1){
        Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.grey,
        );
      }
    }
    else if(response.statusCode==500) {
      Fluttertoast.showToast(
        msg: "Server error",
        backgroundColor: Colors.grey,
      );
    }
    return status;
  }

  Future<String?> Add_DeliveryTime_Api(String delivery_time,String unit,String id,String baseUrl) async {
    final body = {
      "time": delivery_time,
      "unit":unit,
      "id":id,
    };


    var url =baseUrl+'api/'+add_delivery_time;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    String? status;
    String msg='';
    print("response=>" + response.body.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      status = resp['status'].toString();
      msg= resp['msg'].toString();

      if(status!=1){
        Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.grey,
        );
      }
    }
    else if(response.statusCode==500) {
      Fluttertoast.showToast(
        msg: "Server error",
        backgroundColor: Colors.grey,
      );
    }
    return status;
  }

  Future<DeliveryTimeModel?> getDeliveryTime(String baseUrl) async {

    var url = baseUrl+'api/' + get_delivery_time;

    DeliveryTimeModel? deliveryTimeModel;

    Uri uri=Uri.parse(url);

    final response = await http.get(uri,);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];

    if (status == 1) {

      deliveryTimeModel = DeliveryTimeModel.fromJson(json.decode(response.body));
    }
    else if(status == 0){
      Fluttertoast.showToast(msg: "No data found", backgroundColor: Colors.grey,);
      deliveryTimeModel = null;
    }
    else{
      Fluttertoast.showToast(msg: "Server Error", backgroundColor: Colors.grey,);
    }
    return deliveryTimeModel;
  }

}