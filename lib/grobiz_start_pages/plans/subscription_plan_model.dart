class SubscriptionPlanModel {
  SubscriptionPlanModel({
    required this.status,
    required this.msg,
    required this.getPlanLists,
  });
  late final int status;
  late final String msg;
  late final List<GetPlanLists> getPlanLists;

  SubscriptionPlanModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getPlanLists = List.from(json['get_plan_lists']).map((e)=>GetPlanLists.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['get_plan_lists'] = getPlanLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetPlanLists {
  GetPlanLists({
    required this.planAutoId,
    required this.planName,
    required this.price,
    required this.offerPercentage,
    required this.finalPrice,
    required this.validity,
    required this.validityUnit,
    required this.userLimit,
    required this.description,
    required this.status,
    required this.features,
    required this.countryName,
    required this.countryCode,
    required this.currency,
    required this.code,
  });
  late final String planAutoId;
  late final String planName;
  late final String price;
  late final String offerPercentage;
  late final String finalPrice;
  late final String validity;
  late final String validityUnit;
  late final String userLimit;
  late final List<String> description;
  late final String status;
  late final List<String> features;
  late final String countryName;
  late final String countryCode;
  late final String currency;
  late final String code;

  bool showDetails=false;

  GetPlanLists.fromJson(Map<String, dynamic> json){
    planAutoId = json['plan_auto_id'];
    planName = json['plan_name'];
    price = json['price'];
    offerPercentage = json['offer_percentage'];
    finalPrice = json['final_price'];
    validity = json['validity'];
    validityUnit = json['validity_unit'];
    userLimit = json['user_limit'];
    description = List.castFrom<dynamic, String>(json['description']);
    status = json['status'];
    features = List.castFrom<dynamic, String>(json['features']);
    countryName = json['country_name'];
    countryCode = json['country_code'];
    currency = json['currency'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['plan_auto_id'] = planAutoId;
    _data['plan_name'] = planName;
    _data['price'] = price;
    _data['offer_percentage'] = offerPercentage;
    _data['final_price'] = finalPrice;
    _data['validity'] = validity;
    _data['validity_unit'] = validityUnit;
    _data['user_limit'] = userLimit;
    _data['description'] = description;
    _data['status'] = status;
    _data['features'] = features;
    _data['country_name'] = countryName;
    _data['country_code'] = countryCode;
    _data['currency'] = currency;
    _data['code'] = code;
    return _data;
  }
}