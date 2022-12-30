class ExpressDelivery_Model {
  ExpressDelivery_Model({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final int status;
  late final String msg;
  late final List<ExpressDelivery> data;

  ExpressDelivery_Model.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>ExpressDelivery.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ExpressDelivery {
  ExpressDelivery({
    required this.id,
    required this.expressDeliveryCharges,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String expressDeliveryCharges;
  late final String updatedAt;
  late final String createdAt;

  ExpressDelivery.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    expressDeliveryCharges = json['express_delivery_charges'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['express_delivery_charges'] = expressDeliveryCharges;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}