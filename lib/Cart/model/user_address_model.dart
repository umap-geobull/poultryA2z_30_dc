class UserAddressModel {
  UserAddressModel({
    required this.status,
    required this.userAddressDetails,
  });
  late final int status;
  late final List<UserAddressDetails> userAddressDetails;

  UserAddressModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    userAddressDetails = List.from(json['user_address_details']).map((e)=>UserAddressDetails.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['user_address_details'] = userAddressDetails.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class UserAddressDetails {
  UserAddressDetails({
    required this.id,
    required this.userAutoId,
    required this.name,
    required this.mobileNo,
    required this.latitude,
    required this.longitude,
    required this.area,
    required this.city,
    required this.state,
    required this.country,
    required this.addressDetails,
    required this.addressType,
    required this.pincode,
    required this.rdate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String userAutoId;
  late final String name;
  late final String mobileNo;
  late final String latitude;
  late final String longitude;
  late final String area;
  late final String city;
  late final String state;
  late final String country;
  late final String addressDetails;
  late final String addressType;
  late final String pincode;
  late final String rdate;
  late final String updatedAt;
  late final String createdAt;

  UserAddressDetails.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    userAutoId = json['user_auto_id'];
    name = json['name'];
    mobileNo = json['mobile_no'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    area = json['area'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    addressDetails = json['address_details'];
    addressType = json['address_type'];
    pincode = json['pincode'];
    rdate = json['rdate'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['user_auto_id'] = userAutoId;
    _data['name'] = name;
    _data['mobile_no'] = mobileNo;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['area'] = area;
    _data['city'] = city;
    _data['state'] = state;
    _data['country'] = country;
    _data['address_details'] = addressDetails;
    _data['address_type'] = addressType;
    _data['pincode'] = pincode;
    _data['rdate'] = rdate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}