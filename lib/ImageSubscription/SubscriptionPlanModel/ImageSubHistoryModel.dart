class ImageSubHistoryModel {
  ImageSubHistoryModel({
    required this.status,
    required this.msg,
    required this.getOrderHistoryList,
  });
  late final int status;
  late final String msg;
  late final List<GetImageSubHistoryList> getOrderHistoryList;

  ImageSubHistoryModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getOrderHistoryList = List.from(json['getOrderHistoryList']).map((e)=>GetImageSubHistoryList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['getOrderHistoryList'] = getOrderHistoryList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetImageSubHistoryList {
  GetImageSubHistoryList({
    required this.id,
    required this.planAutoId,
    required this.userAutoId,
    required this.subscriptionId,
    required this.paymentMode,
    required this.transactionId,
    required this.transactionStatus,
    required this.planName,
    required this.price,
    required this.imageCount,
    required this.offerPercentage,
    required this.finalPrice,
    required this.validity,
    required this.description,
    required this.noOfEdits,
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
  late final String subscriptionId;
  late final String paymentMode;
  late final String transactionId;
  late final String transactionStatus;
  late final String planName;
  late final String price;
  late final String imageCount;
  late final String offerPercentage;
  late final String finalPrice;
  late final String validity;
  late final String description;
  late final String noOfEdits;
  late final String rdate;
  late final String rtime;
  late final String status;
  late final String planExpireDate;
  late final String updatedAt;
  late final String createdAt;

  GetImageSubHistoryList.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    planAutoId = json['plan_auto_id'];
    userAutoId = json['user_auto_id'];
    subscriptionId = json['subscription_id'];
    paymentMode = json['payment_mode'];
    transactionId = json['transaction_id'];
    transactionStatus = json['transaction_status'];
    planName = json['plan_name'];
    price = json['price'];
    imageCount = json['image_count'];
    offerPercentage = json['offer_percentage'];
    finalPrice = json['final_price'];
    validity = json['validity'];
    description = json['description'];
    noOfEdits = json['no_of_edits'];
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
    _data['subscription_id'] = subscriptionId;
    _data['payment_mode'] = paymentMode;
    _data['transaction_id'] = transactionId;
    _data['transaction_status'] = transactionStatus;
    _data['plan_name'] = planName;
    _data['price'] = price;
    _data['image_count'] = imageCount;
    _data['offer_percentage'] = offerPercentage;
    _data['final_price'] = finalPrice;
    _data['validity'] = validity;
    _data['description'] = description;
    _data['no_of_edits'] = noOfEdits;
    _data['rdate'] = rdate;
    _data['rtime'] = rtime;
    _data['status'] = status;
    _data['plan_expire_date'] = planExpireDate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}