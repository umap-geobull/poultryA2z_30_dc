class Vendor_Order_Report_Model {
  int? status;
  String? msg;
  int? orderCount;
  List<Vendor_Order_Report_Data>? data;

  Vendor_Order_Report_Model(
      {this.status, this.msg, this.orderCount, this.data});

  Vendor_Order_Report_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    orderCount = json['Order_Count'];
    if (json['data'] != null) {
      data = <Vendor_Order_Report_Data>[];
      json['data'].forEach((v) {
        data!.add(Vendor_Order_Report_Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    data['Order_Count'] = orderCount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vendor_Order_Report_Data {
  String? orderDate;
  int? orders;
  int? avgUnitOrdered;
  int? avgOrderValue;
  int? receivedOrders;
  int? returnedQuantity;
  int? fullfilledOrder;
  int? shippedOrder;
  int? deliveredOrder;

  Vendor_Order_Report_Data(
      {this.orderDate,
        this.orders,
        this.avgUnitOrdered,
        this.avgOrderValue,
        this.receivedOrders,
        this.returnedQuantity,
        this.fullfilledOrder,
        this.shippedOrder,
        this.deliveredOrder});

  Vendor_Order_Report_Data.fromJson(Map<String, dynamic> json) {
    orderDate = json['order_date'];
    orders = json['orders'];
    avgUnitOrdered = json['avg_unit_ordered'];
    avgOrderValue = json['avg_order_value'];
    receivedOrders = json['received_orders'];
    returnedQuantity = json['returned_quantity'];
    fullfilledOrder = json['fullfilled_order'];
    shippedOrder = json['shipped_order'];
    deliveredOrder = json['delivered_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_date'] = orderDate;
    data['orders'] = orders;
    data['avg_unit_ordered'] = avgUnitOrdered;
    data['avg_order_value'] = avgOrderValue;
    data['received_orders'] = receivedOrders;
    data['returned_quantity'] = returnedQuantity;
    data['fullfilled_order'] = fullfilledOrder;
    data['shipped_order'] = shippedOrder;
    data['delivered_order'] = deliveredOrder;
    return data;
  }
}