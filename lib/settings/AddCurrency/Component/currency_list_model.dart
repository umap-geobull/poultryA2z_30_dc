class CurrencyListModel {
  CurrencyListModel({
    required this.status,
    required this.msg,
    required this.getCurrencyList,
  });
  late final int status;
  late final String msg;
  late final List<GetCurrencyList> getCurrencyList;

  CurrencyListModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getCurrencyList = List.from(json['get_currency_list']).map((e)=>GetCurrencyList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['get_currency_list'] = getCurrencyList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetCurrencyList {
  GetCurrencyList({
    required this.id,
    required this.adminAutoId,
    required this.countryName,
    required this.countryCode,
    required this.expressDeliveryCharges,
    required this.currency,
    required this.flagImage,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String adminAutoId;
  late final String countryName;
  late final String countryCode;
  late final String expressDeliveryCharges;
  late final String currency;
  late final String flagImage;
  late final String updatedAt;
  late final String createdAt;

  bool isSelected=false;

  GetCurrencyList.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    adminAutoId = json['admin_auto_id'];
    countryName = json['country_name'];
    countryCode = json['country_code'];
    expressDeliveryCharges = json['express_delivery_charges'];
    currency = json['currency'];
    flagImage = json['flag_image'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['admin_auto_id'] = adminAutoId;
    _data['country_name'] = countryName;
    _data['country_code'] = countryCode;
    _data['express_delivery_charges'] = expressDeliveryCharges;
    _data['currency'] = currency;
    _data['flag_image'] = flagImage;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}