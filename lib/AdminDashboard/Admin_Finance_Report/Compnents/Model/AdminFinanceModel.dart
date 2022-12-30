class FinanceReportsModel {
  FinanceReportsModel({
    required this.status,
    required this.msg,
    required this.totalOrderCount,
    required this.data,
  });
  late final int status;
  late final String msg;
  late final int totalOrderCount;
  late final List<FinanceModel> data;

  FinanceReportsModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    totalOrderCount = json['total_order_count'];
    data = List.from(json['data']).map((e)=>FinanceModel.fromJson(e)).toList();
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

class FinanceModel {
  FinanceModel({
    required this.date,
    required this.salesPerDayCount,
    required this.totalSalesPerDay,
    required this.totalDeliveryCharge,
    required this.returnsOrdersPerDay,
    required this.tax,
    required this.totalSales,
  });
  late final String date;
  late final int salesPerDayCount;
  late final String totalSalesPerDay;
  late final String totalDeliveryCharge;
  late final int returnsOrdersPerDay;
  late final String tax;
  late final int totalSales;

  FinanceModel.fromJson(Map<String, dynamic> json){
    date = json['date'];
    salesPerDayCount = json['sales_per_day_count'];
    totalSalesPerDay = json['total_sales_per_day'];
    totalDeliveryCharge = json['total_delivery_charge'];
    returnsOrdersPerDay = json['returns_orders_per_day'];
    tax = json['tax'];
    totalSales = json['total_sales'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['date'] = date;
    _data['sales_per_day_count'] = salesPerDayCount;
    _data['total_sales_per_day'] = totalSalesPerDay;
    _data['total_delivery_charge'] = totalDeliveryCharge;
    _data['returns_orders_per_day'] = returnsOrdersPerDay;
    _data['tax'] = tax;
    _data['total_sales'] = totalSales;
    return _data;
  }
}