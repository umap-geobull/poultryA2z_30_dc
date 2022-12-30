class Vendor_Invetory_Model {
  int? status;
  String? msg;
  List<Vendor_Inventory_data>? data;

  Vendor_Invetory_Model({this.status, this.msg, this.data});

  Vendor_Invetory_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Vendor_Inventory_data>[];
      json['data'].forEach((v) {
        data!.add(Vendor_Inventory_data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vendor_Inventory_data {
  String? inventaryAutoId;
  String? userAutoId;
  String? productAutoId;
  String? productName;
  String? productUnit;
  String? totalProductStock;
  String? availableProductStock;
  String? productStockAlertLimit;
  String? status;

  Vendor_Inventory_data(
      {this.inventaryAutoId,
        this.userAutoId,
        this.productAutoId,
        this.productName,
        this.productUnit,
        this.totalProductStock,
        this.availableProductStock,
        this.productStockAlertLimit,
      this.status});

  Vendor_Inventory_data.fromJson(Map<String, dynamic> json) {
    inventaryAutoId = json['inventary_auto_id'];
    userAutoId = json['user_auto_id'];
    productAutoId = json['product_auto_id'];
    productName = json['product_name'];
    productUnit = json['product_unit'];
    totalProductStock = json['total_product_stock'];
    availableProductStock = json['available_product_stock'];
    productStockAlertLimit = json['product_stock_alert_limit'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['inventary_auto_id'] = inventaryAutoId;
    data['user_auto_id'] = userAutoId;
    data['product_auto_id'] = productAutoId;
    data['product_name'] = productName;
    data['product_unit'] = productUnit;
    data['total_product_stock'] = totalProductStock;
    data['available_product_stock'] = availableProductStock;
    data['product_stock_alert_limit'] = productStockAlertLimit;
    data['status'] = status;
    return data;
  }
}