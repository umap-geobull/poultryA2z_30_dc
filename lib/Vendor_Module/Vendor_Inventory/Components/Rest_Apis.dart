import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Vendor_Home/Components/Model/Get_Vendor_Product_Model.dart';
import '../../Vendor_Home/Utils/App_Apis.dart';
import 'Model/Vendor_Inventory_Model.dart';



class Rest_Apis {

  Future<Get_Vendor_Product_Model?> getVendor_ProductList(String vendorId, String baseUrl, String admin_auto_id) async {

    final body = {
      "user_auto_id": vendorId,
      "admin_auto_id" : admin_auto_id,
  };

    var url = baseUrl+'api/' + get_vendor_product_list;

    Get_Vendor_Product_Model? getVendorProductModel;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];
    if (status == 1) {
      getVendorProductModel = Get_Vendor_Product_Model.fromJson(json.decode(response.body));
    } else {
      getVendorProductModel = null;
    }

    return getVendorProductModel;
  }

  Future<Vendor_Invetory_Model?> getVendor_Inventory_list(String userAutoId, String startDate, String endDate, String baseUrl, String admin_auto_id) async {

    final body = {
      "user_auto_id": userAutoId,
      "start_date": startDate,
      "end_date": endDate,
      "admin_auto_id" : admin_auto_id,
    };

    var url = baseUrl+'api/' + getVendor_Inventory_List;

    Vendor_Invetory_Model? vendorInventoryModel;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int status = resp['status'];

    if (response.statusCode == 200) {
      vendorInventoryModel = Vendor_Invetory_Model.fromJson(json.decode(response.body));
    } else {
      vendorInventoryModel = null;
    }

    return vendorInventoryModel;
  }

  Future<Vendor_Invetory_Model?> getVendor_Inventory_Trending_List(String userAutoId, String startDate, String endDate, String productStockAlertLimit, String baseUrl) async {

    final body = {
      "user_auto_id": userAutoId,
      "start_date": startDate,
      "end_date": endDate,
      "product_stock_alert_limit":productStockAlertLimit
    };

    var url = baseUrl+'api/'+ get_Vendor_Trending_products;

    Vendor_Invetory_Model? vendorInventoryModel;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int status = resp['status'];

    if (response.statusCode == 200) {
      vendorInventoryModel = Vendor_Invetory_Model.fromJson(json.decode(response.body));
    } else {
      vendorInventoryModel = null;
    }

    return vendorInventoryModel;
  }

  Future<int?> Add_Vendor_Inventory(String userId,
      String admin_auto_id, String productAutoId, String productName,
      String productUnit, String totalStock, String availableStock, String stockAlertLimit, String baseUrl) async {
    final body = {
      "user_auto_id": userId,
      "product_auto_id":productAutoId,
      "product_name": productName,
      "product_unit": productUnit,
      "total_product_stock":totalStock,
      "available_product_stock": availableStock,
      "product_stock_alert_limit": stockAlertLimit,
      "admin_auto_id": admin_auto_id,

    };

    var url = baseUrl+'api/' + add_Vendor_Inventory;

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

}
