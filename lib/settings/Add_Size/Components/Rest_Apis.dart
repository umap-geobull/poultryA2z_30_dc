import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/settings/Add_Size/Components/Get_SizeList_Model.dart';
import 'package:http/http.dart' as http;
import '../../../Utils/App_Apis.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Rest_Apis{
  Future<int?> Delete_Size(String? sizeAutoId, String admin_auto_id, String baseUrl) async {
    final body = {
      "size_auto_id":sizeAutoId,
      "admin_auto_id":admin_auto_id,
    };

    var url =baseUrl+'api/'+delete_size;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);


    int? status;
    print("response=>" + response.body.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      status = resp['status'];
    }
    else if (response.statusCode==500){
       Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
       status=0;
    }

    return status;
  }

  Future<String?> Add_Size(String title,String size, String admin_auto_id, String baseUrl) async {
    final body = {
      "title":title,
      "size":size,
      "admin_auto_id":admin_auto_id,
    };

    var url =baseUrl+'api/'+add_size;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);


    String? status;
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);

      status = resp['status'];
    }
    else if (response.statusCode==500){
      Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
      status='0';
    }

    return status;
  }

  Future<GetSizeListModel?> getSizeList(String admin_auto_id, String baseUrl) async {

    GetSizeListModel? getSizeList;

    final body={
      "admin_auto_id":admin_auto_id,
    };
    var url = baseUrl+'api/' + get_size_list;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    if(response.statusCode==200){
      final resp = jsonDecode(response.body);
      int  status = resp['status'];

      if (status == 1) {
        getSizeList = GetSizeListModel.fromJson(json.decode(response.body));
      }
      else if(status == 0){
        Fluttertoast.showToast(msg: "No size found", backgroundColor: Colors.grey,);
        getSizeList = null;
      }
      else{
        Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
        getSizeList = null;
      }
    }
    else if (response.statusCode==500){
      Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
      getSizeList = null;
    }

    return getSizeList;
  }

}