class BusinessDetailsModel {
  BusinessDetailsModel({
    required this.status,
    required this.busniessDetails,
  });
  late final int status;
  late final List<BusniessDetails> busniessDetails;

  BusinessDetailsModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    busniessDetails = List.from(json['busniess_details']).map((e)=>BusniessDetails.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['busniess_details'] = busniessDetails.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class BusniessDetails {
  BusniessDetails({
    required this.id,
    required this.businessLogo,
    required this.businessName,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String businessLogo;
  late final String businessName;
  late final String updatedAt;
  late final String createdAt;

  BusniessDetails.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    businessLogo = json['business_logo'];
    businessName = json['business_name'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['business_logo'] = businessLogo;
    _data['business_name'] = businessName;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}