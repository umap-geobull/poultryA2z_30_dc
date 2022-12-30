class Vendor_Sales_Model {
  Vendor_Sales_Model({
    required this.status,
    required this.msg,
    required this.totalOrderCount,
    required this.data,
  });
  late final int status;
  late final String msg;
  late final int totalOrderCount;
  late final List<GetVendorSalesReport> data;

  Vendor_Sales_Model.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    totalOrderCount = json['total_order_count'];
    data = List.from(json['data']).map((e)=>GetVendorSalesReport.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['total_order_count'] = totalOrderCount;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetVendorSalesReport {
  GetVendorSalesReport({
    required this.date,
    required this.ordersCount,
    required this.grossSales,
    required this.discounts,
    required this.returns,
    required this.netSale,
    required this.shipping,
    required this.tax,
    required this.totalSales,
  });
  late final String date;
  late final int ordersCount;
  late final int grossSales;
  late final int discounts;
  late final int returns;
  late final int netSale;
  late final String shipping;
  late final int tax;
  late final int totalSales;

  GetVendorSalesReport.fromJson(Map<String, dynamic> json){
    date = json['date'];
    ordersCount = json['orders_count'];
    grossSales = json['gross_sales'];
    discounts = json['discounts'];
    returns = json['returns'];
    netSale = json['net_sale'];
    shipping = json['shipping'];
    tax = json['tax'];
    totalSales = json['total_sales'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['date'] = date;
    _data['orders_count'] = ordersCount;
    _data['gross_sales'] = grossSales;
    _data['discounts'] = discounts;
    _data['returns'] = returns;
    _data['net_sale'] = netSale;
    _data['shipping'] = shipping;
    _data['tax'] = tax;
    _data['total_sales'] = totalSales;
    return _data;
  }
}