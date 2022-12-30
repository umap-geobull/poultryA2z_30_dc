import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/product_color_model.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/product_price_model.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/add_price_screen.dart';
import 'package:poultry_a2z/AppUi/app_ui_model.dart';
import 'package:poultry_a2z/grobiz_start_pages/UserBusiness/BusinessDetailsModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:async/async.dart';
import '../../../../Utils/App_Apis.dart';
import '../../../Admin_Product_Opreation/Model/Product_Details_Model.dart';
import 'Product_Info_Model.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Rest_Apis{

  Future<String?> addToWishlist(String productAutoId,String userAutoId, String admin_auto_id, String baseUrl) async {
    final body = {
      "product_auto_id": productAutoId,
      "user_auto_id": userAutoId,
      "admin_auto_id":admin_auto_id,
    };


    print("prod_id=>"+productAutoId);
    print("user_id=>"+userAutoId);

    var url = baseUrl+'api/' + add_to_wishlist;

    Uri uri=Uri.parse(url);

    String status='';

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      status = resp['status'];
      print("status=>"+status.toString());
      if (status == '1') {

      }
      else {
        String  msg = resp['msg'];
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
      }
    }

    return status;
  }

  Future<int?> removeFromWishlist(String productAutoId,String userAutoId, String admin_auto_id, String baseUrl) async {
    final body = {
      "product_auto_id": productAutoId,
      "user_auto_id": userAutoId,
      "admin_auto_id":admin_auto_id,
    };

    print("prod_id=>"+productAutoId);
    print("user_id=>"+userAutoId);

    var url = baseUrl+'api/' + delete_wishlist_item;

    Uri uri=Uri.parse(url);

    int? status;

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      print(resp.toString());

      status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {

      }
      else {
        String  msg = resp['msg'];
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
      }
    }

    return status;
  }

  Future<Product_Details_Model?> getProduct_Info(String productId, String baseUrl) async {
    print("product_auto_id=>"+productId);
    final body = {
      "product_auto_id": productId,
    };

    var url = baseUrl +'api/'+ edit_product;

    Product_Details_Model? productDetailsModel;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];
    print("status=>"+status.toString());
    print("responce=>"+response.toString());
    if (response.statusCode == 200) {

      productDetailsModel = Product_Details_Model.fromJson(json.decode(response.body));
    } else {
      productDetailsModel = null;
    }

    return productDetailsModel;
  }

  Future<BusinessDetailsModel?> getBusinessDetails(String baseUrl) async {
    var url = baseUrl +'api/'+ show_business_details;

    BusinessDetailsModel? businessDetailsModel;

    Uri uri=Uri.parse(url);

    final response = await http.get(uri,);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];
    print("status=>"+status.toString());
    print("responce=>"+response.toString());
    if (response.statusCode == 200) {
      if(status==1){
        businessDetailsModel=BusinessDetailsModel.fromJson(json.decode(response.body));
      }
      else{
        businessDetailsModel=null;
      }
    }
    else {
      businessDetailsModel = null;
    }

    return businessDetailsModel;
  }

  Future<ProductColorModel?> getProductColors(String baseUrl,String productModelAutoId, String admin_auto_id ,String app_type_id) async {
    print("product_model_auto_id=>"+productModelAutoId);

    final body = {
      "product_model_auto_id": productModelAutoId,
      "admin_auto_id":admin_auto_id,
      "app_type_id":app_type_id,
    };

    var url = baseUrl +'api/'+ get_admin_product_colors;

    ProductColorModel? productColorModel;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];
    print("status=>"+status.toString());
    print("responce=>"+response.toString());
    if (response.statusCode == 200) {
      if(status==1)
      {
        productColorModel = ProductColorModel.fromJson(json.decode(response.body));

      }else
      {
        productColorModel=null;
      }
    }
    else {
      productColorModel = null;
    }

    return productColorModel;
  }

  Future<int?> Delete_Product(String productId, String admin_auto_id, String baseUrl,String app_type_id) async {
    print("product_auto_id=>"+productId);
    final body = {
      "product_auto_id": productId,
      "admin_auto_id":admin_auto_id,
      "app_type_id":app_type_id,
    };

    var url = baseUrl +'api/'+ delete_product;
    Uri uri=Uri.parse(url);
    String message;
    int? status;
    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      message = resp['msg'];
      status = resp['status'];
    } else {
      // Fluttertoast.showToast(msg: "Error while creating schedule. Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }

  Future<String?> addProductPrice(ProductPrice productPrice,String productAutoId,String userAutoId,
      String admin_auto_id, String baseUrl,String app_type_id) async {

    String selectedSizePrice = "";
    String offer_id = "";

    if(productPrice.offer!=null){
      offer_id=productPrice.offer!.id;
    }

    for (int index = 0; index < productPrice.selectedSize.length; index++) {
      if(index==0){
        selectedSizePrice += productPrice.selectedSizePrice[index].toString();
      }
      else {
        selectedSizePrice += '|' + productPrice.selectedSizePrice[index].toString();
      }
    }

    String offerPer='0',taxPer='0';

    if(productPrice.offerPer.isNotEmpty){
      offerPer=productPrice.offerPer;
    }

    if(productPrice.tax.isNotEmpty){
      taxPer=productPrice.tax;
    }

    final body = {
      "product_auto_id": productAutoId,
      "user_auto_id": userAutoId,
      "currency_auto_id": productPrice.currencyList.id,
      "product_price": productPrice.productPrice,
      "offer_percentage": offerPer,
      "size_price": selectedSizePrice,
      "including_tax": productPrice.includingTax,
      "tax_percentage": taxPer,
      "offer_auto_id":offer_id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    print("prod_id=>"+productAutoId);
    print("user_id=>"+userAutoId);

    var url = baseUrl+'api/' + add_country_product_price;

    Uri uri=Uri.parse(url);

    String status='';

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      status = resp['status'];
      print(" add status=>"+status.toString());
      if (status == '1') {

      }
      else {
        String  msg = resp['msg'];
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
      }
    }
    else if(response.statusCode==500){
      Fluttertoast.showToast(msg: 'Server Error', backgroundColor: Colors.grey,);
    }
    return status;
  }

  Future<ProductPriceModel?> getProductPrice(String baseUrl,String productAutoId ,String user_auto_id, String admin_auto_id,String app_type_id) async {
    print("product_model_auto_id=>"+productAutoId);
    print("user_auto_id=>"+user_auto_id);
    print("app_type_id=>"+app_type_id);

    final body = {
      "user_auto_id": user_auto_id,
      "product_auto_id": productAutoId,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };
    var url = baseUrl +'api/'+ get_country_product_price;

    ProductPriceModel? productPriceModel;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];
    print("status=>"+status.toString());
    print("responce=>"+response.toString());
    print("res=>"+resp.toString());
    if (response.statusCode == 200) {
      if(status==1)
      {
        productPriceModel = ProductPriceModel.fromJson(json.decode(response.body));

      }else
      {
        productPriceModel=null;
      }
    }
    else {
      productPriceModel = null;
    }

    return productPriceModel;
  }

  Future<int?> delete_product_price(String country_price_auto_id,String user_auto_id,String currency_auto_id,
      String product_auto_id, String admin_auto_id, String baseUrl,String app_type_id) async {
    print("product_auto_id=>"+product_auto_id);
    final body = {
      "product_auto_id": product_auto_id,
      "country_price_auto_id":country_price_auto_id,
      "user_auto_id":user_auto_id,
      "currency_auto_id":currency_auto_id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    var url = baseUrl +'api/'+ delete_country_product_price;
    Uri uri=Uri.parse(url);
    String message;
    int? status;
    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      message = resp['msg'];
      status = resp['status'];
    } else {
      // Fluttertoast.showToast(msg: "Error while creating schedule. Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }

  Future<String?> edit_product_price(String country_price_auto_id,String user_auto_id,String currency_auto_id,
      String product_auto_id, String product_price,String offer_percentage,String size_price,String including_tax,
      String tax_percentage,String offer_auto_id, String admin_auto_id, String baseUrl,String app_type_id) async {

    print("product_auto_id=>"+product_auto_id);

    final body = {
      "product_auto_id": product_auto_id,
      "country_price_auto_id":country_price_auto_id,
      "user_auto_id":user_auto_id,
      "currency_auto_id":currency_auto_id,
      "product_price":product_price,
      "offer_percentage":offer_percentage,
      "size_price":size_price,
      "including_tax":including_tax,
      "tax_percentage":tax_percentage,
      "offer_auto_id":offer_auto_id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    var url = baseUrl +'api/'+ edit_country_product_price;
    Uri uri=Uri.parse(url);
    String message;
    String? status;
    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      print(resp.toString());
      message = resp['msg'];
      status = resp['status'];
      if(status=='0'){
        Fluttertoast.showToast(msg:message, backgroundColor: Colors.grey,);
      }
    }
    else if (response.statusCode == 500)  {
      status = '0';
      Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
    }

    return status;
  }

  Future<AppUiModel?> getAppUi(String admin_auto_id, String baseUrl, ) async {

    var url = baseUrl +'api/'+ get_app_ui_style;

    AppUiModel? appUiModel;

    Uri uri=Uri.parse(url);

    final body={
      "admin_auto_id":"636bafd640e19ce8b70a92e2"
      // "admin_auto_id":admin_auto_id
    };
    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];
    print("responce=>"+response.toString());
    print("ui model status code ${response.statusCode}");
    if (response.statusCode == 200) {
      appUiModel = AppUiModel.fromJson(json.decode(response.body));
      print("UI Model body ${response.body}");
    }
    else if(response.statusCode==500){
      appUiModel = null;
      Fluttertoast.showToast(msg: 'Server error', backgroundColor: Colors.grey,);
    }

    return appUiModel;
  }

  Future<int?> addAppUi(String id, String appbar_color, String appbar_icon_color,String bottom_bar_color,
      String bottom_bar_icon_color,String add_to_cart_button_color,
      String login_register_button_color, String buy_now_botton_color, String app_font,
      String show_location_on_homescreen, String product_layout_type, String admin_auto_id, String baseUrl,) async {

    final body={
      "id":id,
      "appbar_color":appbar_color,
      "appbar_icon_color":appbar_icon_color,
      "bottom_bar_color":bottom_bar_color,
      "bottom_bar_icon_color":bottom_bar_icon_color,
      "add_to_cart_button_color":add_to_cart_button_color,
      "login_register_button_color":login_register_button_color,
      "buy_now_botton_color":buy_now_botton_color,
      "app_font":app_font,
      "show_location_on_homescreen":show_location_on_homescreen,
      "product_layout_type":product_layout_type,
      "admin_auto_id":admin_auto_id,
    };

    var url = baseUrl +'api/'+ add_app_ui_style;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri,body: body);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];
    print("status=>"+status.toString());
    print("responce=>"+response.toString());
    if (response.statusCode == 200) {
      if(status==1){
        Fluttertoast.showToast(msg: 'Ui updated successfully', backgroundColor: Colors.grey,);
      }
      else{
        String  msg = resp['msg'];
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
      }
    }
    else if(response.statusCode==500){
      Fluttertoast.showToast(msg: 'Server error', backgroundColor: Colors.grey,);
    }

    return status;
  }

}