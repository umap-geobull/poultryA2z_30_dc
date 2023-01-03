class ContactUs_Model {
  ContactUs_Model({
    required this.status,
    required this.allcontactDetails,
  });
  late final int status;
  late final List<AllcontactDetails> allcontactDetails;

  ContactUs_Model.fromJson(Map<String, dynamic> json){
    status = json['status'];
    allcontactDetails = List.from(json['allcontact_details']).map((e)=>AllcontactDetails.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['allcontact_details'] = allcontactDetails.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class AllcontactDetails {
  AllcontactDetails({
    required this.id,
    required this.contact,
    required this.email,
    required this.address,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String contact;
  late final String email;
  late final String address;
  late final String updatedAt;
  late final String createdAt;

  AllcontactDetails.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    contact = json['contact'];
    email = json['email'];
    address = json['address'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['contact'] = contact;
    _data['email'] = email;
    _data['address'] = address;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}