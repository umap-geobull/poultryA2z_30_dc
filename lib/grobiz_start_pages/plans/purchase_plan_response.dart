class PurchasePlanResponse {
  PurchasePlanResponse({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final int status;
  late final String msg;
  late final Data data;

  PurchasePlanResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
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
    required this.description,
    required this.features,
    required this.rdate,
    required this.rtime,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });
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
  late final String description;
  late final String features;
  late final String rdate;
  late final String rtime;
  late final String status;
  late final String updatedAt;
  late final String createdAt;
  late final String id;

  Data.fromJson(Map<String, dynamic> json){
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
    description = json['description'];
    features = json['features'];
    rdate = json['rdate'];
    rtime = json['rtime'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
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
    _data['description'] = description;
    _data['features'] = features;
    _data['rdate'] = rdate;
    _data['rtime'] = rtime;
    _data['status'] = status;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['_id'] = id;
    return _data;
  }
}