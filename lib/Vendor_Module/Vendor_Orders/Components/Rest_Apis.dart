import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Vendor_Home/Utils/App_Apis.dart';
import 'Model/VendorOrder_Model.dart';
import 'Model/Vendor_Order_Report_Model.dart';

class Rest_Apis {
  Future<VendorOrder_Model?> getVendor_New_orders(String userAutoId, String baseUrl) async {

    final body = {
      "user_auto_id": userAutoId,
    };

    var url = baseUrl +'api/'+ get_Vendor_NewOrders;

    VendorOrder_Model? vendorNewOrderModel;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int status = resp['status'];

    if (response.statusCode == 200) {
      vendorNewOrderModel =
          VendorOrder_Model.fromJson(json.decode(response.body));
    } else {
      vendorNewOrderModel = null;
    }

    return vendorNewOrderModel;
  }

  Future<VendorOrder_Model?> getVendor_Preparing_orders(String userAutoId, String baseUrl) async {

    final body = {
      "user_auto_id": userAutoId,
    };

    var url = baseUrl +'api/'+ get_Vendor_PreparingOrders;

    VendorOrder_Model? vendorNewOrderModel;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int status = resp['status'];

    if (response.statusCode == 200) {
      vendorNewOrderModel =
          VendorOrder_Model.fromJson(json.decode(response.body));
    } else {
      vendorNewOrderModel = null;
    }

    return vendorNewOrderModel;
  }

  Future<VendorOrder_Model?> getVendor_Returned_orders(String userAutoId, String baseUrl) async {

    final body = {
      "user_auto_id": userAutoId,
    };

    var url = baseUrl +'api/'+ get_Vendor_Return_Orders;

    VendorOrder_Model? vendorNewOrderModel;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int status = resp['status'];

    if (response.statusCode == 200) {
      vendorNewOrderModel =
          VendorOrder_Model.fromJson(json.decode(response.body));
    } else {
      vendorNewOrderModel = null;
    }

    return vendorNewOrderModel;
  }

  Future<VendorOrder_Model?> getVendor_Canceled_orders(String userAutoId, String baseUrl) async {

    final body = {
      "user_auto_id": userAutoId,
    };

    var url = baseUrl +'api/'+ get_Vendor_Cancel_Orders;

    VendorOrder_Model? vendorNewOrderModel;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int status = resp['status'];

    if (response.statusCode == 200) {
      vendorNewOrderModel =
          VendorOrder_Model.fromJson(json.decode(response.body));
    } else {
      vendorNewOrderModel = null;
    }

    return vendorNewOrderModel;
  }

  Future<VendorOrder_Model?> getVendor_Dispatched_orders(String userAutoId, String baseUrl) async {

    final body = {
      "user_auto_id": userAutoId,
    };

    var url = baseUrl +'api/'+ get_Vender_DiapatchedOrders;

    VendorOrder_Model? vendorNewOrderModel;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int status = resp['status'];

    if (response.statusCode == 200) {
      vendorNewOrderModel = VendorOrder_Model.fromJson(json.decode(response.body));
    } else {
      vendorNewOrderModel = null;
    }

    return vendorNewOrderModel;
  }

  Future<VendorOrder_Model?> getVendor_COmpleted_orders(String userAutoId, String baseUrl) async {

    final body = {
      "user_auto_id": userAutoId,
    };

    print(userAutoId);
    print('baseurl=>'+baseUrl);

    var url = baseUrl +'api/'+ get_Vendor_Completed_Orders;

    VendorOrder_Model? vendorNewOrderModel;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int status = resp['status'];

    if (response.statusCode == 200) {
      vendorNewOrderModel = VendorOrder_Model.fromJson(json.decode(response.body));
    } else {
      vendorNewOrderModel = null;
    }

    return vendorNewOrderModel;
  }

  Future<Vendor_Order_Report_Model?> getVendor_orders_Reports(String userAutoId, String startDate, String endDate, String baseUrl) async {
    final body = {
      "user_auto_id": userAutoId,
      "start_date": startDate,
      "end_date": endDate,
    };

    var url = baseUrl +'api/'+ get_Vendor_Order_Reports;

    Vendor_Order_Report_Model? vendorOrderReportModel;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int status = resp['status'];

    if (response.statusCode == 200) {
      vendorOrderReportModel = Vendor_Order_Report_Model.fromJson(json.decode(response.body));
    } else {
      vendorOrderReportModel = null;
    }

    return vendorOrderReportModel;
  }


  Future<VendorOrder_Model?> getOrder_Details(String userAutoId, String orderAutoId, String baseUrl) async {

    final body = {
      "user_auto_id": userAutoId,
      "order_auto_id": orderAutoId,
    };

    var url = baseUrl +'api/' +get_Vendor_Order_Details;

    VendorOrder_Model? vendorNewOrderModel;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int status = resp['status'];

    if (response.statusCode == 200) {
      vendorNewOrderModel =
          VendorOrder_Model.fromJson(json.decode(response.body));
    } else {
      vendorNewOrderModel = null;
    }

    return vendorNewOrderModel;
  }

  Future<int?> Change_Order_Status(String orderAutoId,String userId, String Status, String baseUrl) async {
    final body = {
      "user_auto_id": userId,
      "order_auto_id":orderAutoId,
      "status": Status

    };

    var url = baseUrl+ 'api/'+ Change_Vendor_Order_Status;

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
