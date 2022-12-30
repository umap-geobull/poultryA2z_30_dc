import 'dart:convert';
import 'package:poultry_a2z/Vendor_Module/Vendor_Home/Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
import 'Model/Vendor_Inventory_Model.dart';



class Rest_Apis {

  Future<Vendor_Invetory_Model?> getVendor_Inventory_list(String userAutoId, String startDate, String endDate, String baseUrl, String admin_auto_id) async {

    final body = {
      "user_auto_id": userAutoId,
      "admin_auto_id" : admin_auto_id,
    };

    var url = baseUrl+'api/' + getVendor_Inventory_List;

    Vendor_Invetory_Model? vendorInventoryModel;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);

    print(resp.toString());

    int status = resp['status'];

    if (response.statusCode == 200) {
      if(status==1) {
        vendorInventoryModel =
            Vendor_Invetory_Model.fromJson(json.decode(response.body));
      }
      else{
        vendorInventoryModel = null;
      }
    } else {
      vendorInventoryModel = null;
    }

    return vendorInventoryModel;
  }

  Future<Vendor_Invetory_Model?> getVendor_Inventory_Trending_List(String userAutoId, String startDate, String endDate,
      String productStockAlertLimit, String baseUrl, String admin_auto_id) async {

    final body = {
      "user_auto_id": userAutoId,
      "start_date": startDate,
      "end_date": endDate,
      "product_stock_alert_limit":productStockAlertLimit,
      "admin_auto_id":admin_auto_id
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
