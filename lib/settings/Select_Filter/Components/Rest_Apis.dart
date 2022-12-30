import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../Utils/App_Apis.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Rest_Apis{
  Future<int?> Add_Filter(String id,String filter_menu, String baseUrl, String admin_auto_id) async {
    final body = {
      "id":id,
      "filter_menu":filter_menu,
      "admin_auto_id":admin_auto_id,
    };

    var url =baseUrl+'api/'+add_filter_menu;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    int? status;
    print(response.toString());

    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      print(resp.toString());
      status = resp['status'];
    }
    else if(response.statusCode==500){
      status=0;
      Fluttertoast.showToast(msg: "Server Error", backgroundColor: Colors.grey,);
    }

    return status;
  }
}