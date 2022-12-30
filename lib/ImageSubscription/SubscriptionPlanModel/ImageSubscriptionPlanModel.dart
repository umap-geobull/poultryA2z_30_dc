class ImageSubscriptionModel {
  ImageSubscriptionModel({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final int status;
  late final String msg;
  late final List<GetImagePlans> data;

  ImageSubscriptionModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>GetImagePlans.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetImagePlans {
  GetImagePlans({
    required this.id,
    required this.name,
    required this.price,
    required this.offerPercentage,
    required this.finalPrice,
    required this.validity,
    required this.description,
    required this.noOfEdits,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    this.countryId,
  });
  late final String id;
  late final String name;
  late final String price;
  late final String offerPercentage;
  late final String finalPrice;
  late final String validity;
  late final String description;
  late final String noOfEdits;
  late final String status;
  late final String updatedAt;
  late final String createdAt;
  late final Null countryId;

  GetImagePlans.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    name = json['name'];
    price = json['price'];
    offerPercentage = json['offer_percentage'];
    finalPrice = json['final_price'];
    validity = json['validity'];
    description = json['description'];
    noOfEdits = json['no_of_edits'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    countryId = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['name'] = name;
    _data['price'] = price;
    _data['offer_percentage'] = offerPercentage;
    _data['final_price'] = finalPrice;
    _data['validity'] = validity;
    _data['description'] = description;
    _data['no_of_edits'] = noOfEdits;
    _data['status'] = status;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['country_id'] = countryId;
    return _data;
  }
}