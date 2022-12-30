class VendorList_Model {
  VendorList_Model({
    required this.status,
    required this.msg,
    required this.getVendorLists,
  });
  late final int status;
  late final String msg;
  late final List<GetVendorLists> getVendorLists;

  VendorList_Model.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getVendorLists = List.from(json['get_vendor_lists']).map((e)=>GetVendorLists.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['get_vendor_lists'] = getVendorLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetVendorLists {
  GetVendorLists({
    required this.id,
    required this.name,
    required this.emailId,
    required this.mobileNumber,
    required this.password,
    required this.status,
    this.token,
    required this.haveRetailShop,
    required this.updateOnWhatsapp,
    required this.userType,
    required this.loginOtp,
    required this.registerDate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String name;
  late final String emailId;
  late final String mobileNumber;
  late final String password;
  late String status;
  late final String? token;
  late final String haveRetailShop;
  late final String updateOnWhatsapp;
  late final String userType;
  late final String loginOtp;
  late final String registerDate;
  late final String updatedAt;
  late final String createdAt;

  GetVendorLists.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    name = json['name'];
    emailId = json['email_id'];
    mobileNumber = json['mobile_number'];
    password = json['password'];
    status = json['status'];
    token = null;
    haveRetailShop = json['have_retail_shop'];
    updateOnWhatsapp = json['update_on_whatsapp'];
    userType = json['user_type'];
    loginOtp = json['login_otp'];
    registerDate = json['register_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['name'] = name;
    _data['email_id'] = emailId;
    _data['mobile_number'] = mobileNumber;
    _data['password'] = password;
    _data['status'] = status;
    _data['token'] = token;
    _data['have_retail_shop'] = haveRetailShop;
    _data['update_on_whatsapp'] = updateOnWhatsapp;
    _data['user_type'] = userType;
    _data['login_otp'] = loginOtp;
    _data['register_date'] = registerDate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}