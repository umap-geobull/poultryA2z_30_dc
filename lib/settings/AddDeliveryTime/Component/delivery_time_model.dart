class DeliveryTimeModel {
  DeliveryTimeModel({
    required this.status,
    required this.deliveryTimeDetails,
  });
  late final int status;
  late final List<DeliveryTimeDetails> deliveryTimeDetails;

  DeliveryTimeModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    deliveryTimeDetails = List.from(json['delivery_time_details']).map((e)=>DeliveryTimeDetails.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['delivery_time_details'] = deliveryTimeDetails.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class DeliveryTimeDetails {
  DeliveryTimeDetails({
    required this.id,
    required this.time,
    required this.unit,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String time;
  late final String unit;
  late final String updatedAt;
  late final String createdAt;

  DeliveryTimeDetails.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    time = json['time'];
    unit = json['unit'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['time'] = time;
    _data['unit'] = unit;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}