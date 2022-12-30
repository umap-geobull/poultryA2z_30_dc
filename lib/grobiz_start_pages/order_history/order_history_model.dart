class OrderHistoryModel {
  OrderHistoryModel({
    required this.status,
    required this.msg,
    required this.getOrderHistoryList,
  });
  late final int status;
  late final String msg;
  late final List<GetOrderHistoryList> getOrderHistoryList;

  OrderHistoryModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getOrderHistoryList = List.from(json['getOrderHistoryList']).map((e)=>GetOrderHistoryList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['getOrderHistoryList'] = getOrderHistoryList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetOrderHistoryList {
  GetOrderHistoryList({
    required this.id,
    required this.planAutoId,
    required this.userAutoId,
    required this.orderId,
    required this.paymentMode,
    required this.transactionId,
    required this.transactionStatus,
    required this.planName,
    required this.price,
    required this.offerPercentage,
    required this.finalPrice,
    required this.validity,
    required this.validityUnit,
    required this.description,
    required this.features,
    required this.countryId,
    required this.countryName,
    required this.countryCode,
    required this.currency,
    required this.code,
    required this.rdate,
    required this.rtime,
    required this.status,
    required this.planExpireDate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String planAutoId;
  late final String userAutoId;
  late final String orderId;
  late final String paymentMode;
  late final String transactionId;
  late final String transactionStatus;
  late final String planName;
  late final String price;
  late final String offerPercentage;
  late final String finalPrice;
  late final String validity;
  late final String validityUnit;
  late final String description;
  late final String features;
  late final String countryId;
  late final String countryName;
  late final String countryCode;
  late final String currency;
  late final String code;
  late final String rdate;
  late final String rtime;
  late final String status;
  late final String planExpireDate;
  late final String updatedAt;
  late final String createdAt;

  GetOrderHistoryList.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    planAutoId = json['plan_auto_id'];
    userAutoId = json['user_auto_id'];
    orderId = json['order_id'];
    paymentMode = json['payment_mode'];
    transactionId = json['transaction_id'];
    transactionStatus = json['transaction_status'];
    planName = json['plan_name'];
    price = json['price'];
    offerPercentage = json['offer_percentage'];
    finalPrice = json['final_price'];
    validity = json['validity'];
    validityUnit = json['validity_unit'];
    description = json['description'];
    features = json['features'];
    countryId = json['country_id'];
    countryName = json['country_name'];
    countryCode = json['country_code'];
    currency = json['currency'];
    code = json['code'];
    rdate = json['rdate'];
    rtime = json['rtime'];
    status = json['status'];
    planExpireDate = json['plan_expire_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['plan_auto_id'] = planAutoId;
    _data['user_auto_id'] = userAutoId;
    _data['order_id'] = orderId;
    _data['payment_mode'] = paymentMode;
    _data['transaction_id'] = transactionId;
    _data['transaction_status'] = transactionStatus;
    _data['plan_name'] = planName;
    _data['price'] = price;
    _data['offer_percentage'] = offerPercentage;
    _data['final_price'] = finalPrice;
    _data['validity'] = validity;
    _data['validity_unit'] = validityUnit;
    _data['description'] = description;
    _data['features'] = features;
    _data['country_id'] = countryId;
    _data['country_name'] = countryName;
    _data['country_code'] = countryCode;
    _data['currency'] = currency;
    _data['code'] = code;
    _data['rdate'] = rdate;
    _data['rtime'] = rtime;
    _data['status'] = status;
    _data['plan_expire_date'] = planExpireDate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}