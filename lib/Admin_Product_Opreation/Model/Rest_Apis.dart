import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import '../../../../../Utils/AppConfig.dart';
import '../../../../../Utils/App_Apis.dart';
import 'Approve_ProductList_Model.dart';
import 'Product_Details_Model.dart';


class Rest_Apis{

  Future<ApproveProductListModel> getApproveProductList(String baseUrl) async {

    late ApproveProductListModel approve_productList_Model;
    var url = baseUrl+'api/' + get_vendor_product_approval_list;
    var uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {

      final resp = jsonDecode(response.body);
      int status = resp['status'];
      if (status == 1) {
        approve_productList_Model  = ApproveProductListModel.fromJson(json.decode(response.body));
      }
    }else if(response.statusCode == 500){
      final resp = jsonDecode(response.body);
      String message = resp['msg'];
      Fluttertoast.showToast(msg: message, backgroundColor: Colors.grey,);
    } else {
      Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
    }
    return approve_productList_Model;
  }

  Future<int?> approve_product(String user_id, String product_auto_id,String baseUrl) async {

    final body = {
      "user_auto_id": user_id,
      "product_auto_id": product_auto_id,
    };

    var url =baseUrl+'api/'+update_vendor_product_admin;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    String message;
    int? status;
    print("response=>" + response.body.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      message = resp['msg'];
      status = resp['status'];
    } else if(response.statusCode == 500){
      final resp = jsonDecode(response.body);
      message = resp['msg'];
      Fluttertoast.showToast(msg: message, backgroundColor: Colors.grey,);
    } else {
      // Fluttertoast.showToast(msg: "Error while creating schedule. Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }

  Future<int?> disapprove_product(String user_id, String product_auto_id,String baseUrl) async {

    final body = {
      "user_auto_id": user_id,
      "product_auto_id": product_auto_id,
    };

    var url =baseUrl+'api/'+disapprove_vendor_product;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    String message;
    int? status;
    print("response=>" + response.body.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      message = resp['msg'];
      status = resp['status'];
    } else if(response.statusCode == 500){
      final resp = jsonDecode(response.body);
      message = resp['msg'];
      Fluttertoast.showToast(msg: message, backgroundColor: Colors.grey,);
    } else {
      // Fluttertoast.showToast(msg: "Error while creating schedule. Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }

  Future<int?> approve_brand(String user_id, String brand_auto_id,String baseUrl) async {

    final body = {
      "user_auto_id": user_id,
      "brand_auto_id": brand_auto_id,
    };

    var url =baseUrl+'api/'+update_vendor_brands_admin;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    String message;
    int? status;
    print("response=>" + response.body.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      message = resp['msg'];
      status = resp['status'];
    } else if(response.statusCode == 500){
      final resp = jsonDecode(response.body);
      message = resp['msg'];
      Fluttertoast.showToast(msg: message, backgroundColor: Colors.grey,);
    } else {
      // Fluttertoast.showToast(msg: "Error while creating schedule. Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }

  Future<int?> disapprove_brand(String user_id, String brand_auto_id,String baseUrl) async {

    final body = {
      "user_auto_id": user_id,
      "brand_auto_id": brand_auto_id,
    };

    var url =baseUrl+'api/'+disapprove_vendor_brand;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    String message;
    int? status;
    print("response=>" + response.body.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      message = resp['msg'];
      status = resp['status'];

      if (status == 1) {
        Fluttertoast.showToast(
          msg: "Brand disapproved successfully",
          backgroundColor: Colors.grey,
        );
      }
      else {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.grey,
        );      }

    }
    else if(response.statusCode == 500){
      Fluttertoast.showToast(msg: 'Server Error', backgroundColor: Colors.grey,);
    }
    else {
      // Fluttertoast.showToast(msg: "Error while creating schedule. Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }

  Future<int?> approve_category(String user_id, String category_auto_id,String baseUrl) async {

    final body = {
      "user_auto_id": user_id,
      "category_auto_id": category_auto_id,
    };

    var url =baseUrl+'api/'+update_vendor_category_admin;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    String message;
    int? status;
    print("response=>" + response.body.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      message = resp['msg'];
      status = resp['status'];
    } else if(response.statusCode == 500){
      final resp = jsonDecode(response.body);
      message = resp['msg'];
      Fluttertoast.showToast(msg: message, backgroundColor: Colors.grey,);
    } else {
      // Fluttertoast.showToast(msg: "Error while creating schedule. Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }

  Future<int?> disapprove_category(String user_id, String category_auto_id,String baseUrl) async {

    final body = {
      "user_auto_id": user_id,
      "category_auto_id": category_auto_id,
    };

    var url =baseUrl+'api/'+disapprove_vendor_category;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    String message;
    int? status;
    print("response=>" + response.body.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      message = resp['msg'];
      status = resp['status'];

      if (status == 1) {
        Fluttertoast.showToast(
          msg: "Category disapproved successfully",
          backgroundColor: Colors.grey,
        );
      }
      else {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.grey,
        );      }

    }
    else if(response.statusCode == 500){
      Fluttertoast.showToast(msg: 'Server Error', backgroundColor: Colors.grey,);
    }
    else {
      // Fluttertoast.showToast(msg: "Error while creating schedule. Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }

  Future<Product_Details_Model?> getProduct_Info(String product_id, String baseUrl) async {
    print("product_auto_id=>"+product_id);
    final body = {
      "product_auto_id": product_id,
    };

    var url = baseUrl +'api/'+ edit_product;

    Product_Details_Model? product_details_model;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];
    print("status=>"+status.toString());
    print("responce=>"+response.toString());
    if (response.statusCode == 200) {

      product_details_model = Product_Details_Model.fromJson(json.decode(response.body));
    }
    else if(response.statusCode == 500){
      String message = resp['msg'];
      Fluttertoast.showToast(msg: message, backgroundColor: Colors.grey,);
    }
    else {
      product_details_model = null;
    }

    return product_details_model;
  }

  Future<String?> Update_Product(String baseUrl,String product_id, String user_id, String main_cat_id, File image, String productName, String price, String sub_cat_id, String brandName, String brandAutoId,
      String? productUnit, String productQuantity, String grossWeight, String netWeight, String offerPrice, String finalPrice, String minimumOrderQuantity,
      String productColors, String selectedSize, String productDescription, String netWeight2, String productDimensions, String productSpecification)async {

    var url = baseUrl+'api/' + update_product;
    var uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);

    if (image != null) {
      var image_stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
      var image_length = await image.length();
      print("img_signature_stream=>" + image_stream.toString());

      var signatureFile = new http.MultipartFile('product_img', image_stream, image_length, filename: productName+".jpg");
      request.files.add(signatureFile);
    }
    {
      print("img_signature_stream=>" + image.toString());
    }
    request.fields["product_auto_id"] = product_id;
    request.fields["user_auto_id"] = user_id;
    request.fields["main_category_auto_id"] = main_cat_id;
    request.fields["product_name"] = productName;
    request.fields["price"] = price;
    request.fields["sub_category_auto_id"] = sub_cat_id;
    request.fields["brand_name"] = brandName;
    request.fields["brand_auto_id"] = brandAutoId;
    request.fields["product_unit"] = productUnit!;
    request.fields["product_quantity"] = productQuantity;
    request.fields["gross_weight"] = grossWeight;
    request.fields["net_weight"] = netWeight;
    request.fields["offer_price"] = offerPrice;
    request.fields["final_price"] = finalPrice;
    request.fields["minimum_order_quantity"] = minimumOrderQuantity;
    request.fields["product_colors"] = productColors;
    request.fields["product_size"] = selectedSize;
    request.fields["product_description"] = productDescription;
    request.fields["product_weight"] = netWeight2;
    request.fields["product_dimensions"] = productDimensions;
    request.fields["product_specification"] = productSpecification;
    request.fields["added_by"] = "Admin";

    http.Response response = await http.Response.fromStream(await request.send());

    String? status;
    print(response.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);

      status = resp['status'];
    }
    else {
      status = null;
    }

    return status;
  }

}