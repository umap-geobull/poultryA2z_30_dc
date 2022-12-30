import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Model/VendorOrder_Model.dart';
import 'Model/Vendor_Order_Report_Model.dart';

class Rest_Apis {
  Future<VendorOrder_Model?> getVendor_New_orders(String userAutoId,String admin_auto_id,String baseurl) async {

    final body = {
      "user_auto_id": userAutoId,
      "admin_auto_id":admin_auto_id,
    };

    var url = baseurl+'api/' + "get_Vendor_NewOrders";

    VendorOrder_Model? vendorNewOrderModel;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int status = resp['status'];
print(resp.toString());
    if (response.statusCode == 200) {
      if(status==1) {
        vendorNewOrderModel =
            VendorOrder_Model.fromJson(json.decode(response.body));
      }
      else{
        vendorNewOrderModel = null;
      }
    } else {
      vendorNewOrderModel = null;
    }

    return vendorNewOrderModel;
  }

  Future<VendorOrder_Model?> getVendor_Preparing_orders(String userAutoId,String admin_auto_id,String baseurl) async {

    final body = {
      "user_auto_id": userAutoId,
      "admin_auto_id":admin_auto_id,
    };

    var url = baseurl +'api/'+ "get_Vendor_PreparingOrders";

    VendorOrder_Model? vendorNewOrderModel;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int status = resp['status'];

    if (response.statusCode == 200) {
      if(status==1) {
        vendorNewOrderModel =
            VendorOrder_Model.fromJson(json.decode(response.body));
      }
      else{
        vendorNewOrderModel = null;
      }
    } else {
      vendorNewOrderModel = null;
    }

    return vendorNewOrderModel;
  }

  Future<VendorOrder_Model?> getVendor_Returned_orders(String userAutoId, String admin_auto_id, String baseurl) async {

    final body = {
      "user_auto_id": userAutoId,
      "admin_auto_id": admin_auto_id
    };
print(body.toString());
    var url = baseurl +'api/'+ "get_Vendor_Return_Orders";
print(url);
    VendorOrder_Model? vendorNewOrderModel;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int status = resp['status'];

    if (response.statusCode == 200) {
      if(status==1) {
        vendorNewOrderModel =
            VendorOrder_Model.fromJson(json.decode(response.body));
      }
      else
        {
          vendorNewOrderModel = null;
        }
    } else {
      vendorNewOrderModel = null;
    }

    return vendorNewOrderModel;
  }

  Future<VendorOrder_Model?> getVendor_Canceled_orders(String userAutoId, String admin_auto_id, String baseurl) async {

    final body = {
      "user_auto_id": userAutoId,
      "admin_auto_id": admin_auto_id,
    };

    var url = baseurl+'api/' + "get_Vendor_Cancel_Orders";

    VendorOrder_Model? vendorNewOrderModel;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int status = resp['status'];

    if (response.statusCode == 200) {
      if(status==1) {
        vendorNewOrderModel =
            VendorOrder_Model.fromJson(json.decode(response.body));
      }
      else{
        vendorNewOrderModel = null;
      }
    } else {
      vendorNewOrderModel = null;
    }

    return vendorNewOrderModel;
  }

  Future<VendorOrder_Model?> getVendor_Dispatched_orders(String userAutoId,String admin_auto_id,String baseurl) async {

    final body = {
      "user_auto_id": userAutoId,
      "admin_auto_id":admin_auto_id,
    };

    var url = baseurl +'api/'+"get_Vender_DiapatchedOrders";

    VendorOrder_Model? vendorNewOrderModel;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int status = resp['status'];

    if (response.statusCode == 200) {
      if(status==1) {
        vendorNewOrderModel =
            VendorOrder_Model.fromJson(json.decode(response.body));
      }
      else{
        vendorNewOrderModel = null;
      }
    } else {
      vendorNewOrderModel = null;
    }

    return vendorNewOrderModel;
  }

  Future<VendorOrder_Model?> getVendor_COmpleted_orders(String userAutoId,String admin_auto_id,String baseurl) async {

    final body = {
      "user_auto_id": userAutoId,
      "admin_auto_id": admin_auto_id,
    };

    var url = baseurl +'api/'+ "get_Vendor_Completed_Orders";

    VendorOrder_Model? vendorNewOrderModel;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int status = resp['status'];

    if (response.statusCode == 200) {
      if(status==1) {
        vendorNewOrderModel =
            VendorOrder_Model.fromJson(json.decode(response.body));
      }
      else{
        vendorNewOrderModel = null;
      }
    } else {
      vendorNewOrderModel = null;
    }

    return vendorNewOrderModel;
  }

  Future<Vendor_Order_Report_Model?> getVendor_orders_Reports(String userAutoId, String admin_auto_id, String startDate, String endDate,String baseurl) async {
    final body = {
      "user_auto_id": userAutoId,
      "start_date": startDate,
      "end_date": endDate,
      "admin_auto_id": admin_auto_id
    };

    var url = baseurl+'api/' + "get_Vendor_Order_Reports";

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


  Future<VendorOrder_Model?> getOrder_Details(String userAutoId, String admin_auto_id, String orderAutoId,String baseurl) async {

    final body = {
      "user_auto_id": userAutoId,
      "order_auto_id": orderAutoId,
      "admin_auto_id": admin_auto_id,
    };

    var url = baseurl+'api/' + "get_Vendor_Order_Details";

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

  Future<int?> Change_Order_Status(String orderAutoId,String userId, String admin_auto_id, String Status,String baseurl) async {
    final body = {
      "user_auto_id": userId,
      "order_auto_id":orderAutoId,
      "status": Status,
      "admin_auto_id":admin_auto_id,
    };
    print(userId+ " "+ orderAutoId +"" + Status + " "+ admin_auto_id);
    var url = baseurl +'api/'+ "Change_Vendor_Order_Status";

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
