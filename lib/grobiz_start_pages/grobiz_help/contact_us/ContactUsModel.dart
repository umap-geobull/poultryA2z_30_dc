class ContactUs_Model {
  ContactUs_Model({
    required this.status,
    required this.contactDetails,
  });
  late final int status;
  late final List<ContactDetails> contactDetails;

  ContactUs_Model.fromJson(Map<String, dynamic> json){
    status = json['status'];
    contactDetails = List.from(json['contact_details']).map((e)=>ContactDetails.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['contact_details'] = contactDetails.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ContactDetails {
  ContactDetails({
    required this.id,
    required this.updatedAt,
    required this.createdAt,
    required this.contactIndia,
    required this.contactUs,
    required this.email,
    required this.address,
    required this.message,
  });
  late final String id;
  late final String updatedAt;
  late final String createdAt;
  late final String contactIndia;
  late final String contactUs;
  late final String email;
  late final String address;
  late final String message;

  ContactDetails.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    contactIndia = json['contact_india'];
    contactUs = json['contact_us'];
    email = json['email'];
    address = json['address'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['contact_india'] = contactIndia;
    _data['contact_us'] = contactUs;
    _data['email'] = email;
    _data['address'] = address;
    _data['message'] = message;
    return _data;
  }
}