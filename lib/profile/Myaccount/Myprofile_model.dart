class MyProfile_model {
  MyProfile_model({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final String status;
  late final String msg;
  late final MyProfile data;

  MyProfile_model.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    data = MyProfile.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['data'] = data.toJson();
    return _data;
  }
}

class MyProfile {
  MyProfile({
    required this.id,
    required this.name,
    required this.emailId,
    required this.mobileNumber,
   // required this.password,
    required this.status,
    // required this.token,
    required this.haveRetailShop,
    required this.updateOnWhatsapp,
    required this.userType,
    required this.gstDocs,
    required this.shopActDocs,
    required this.companyRegCetificate,
    required this.city,
    required this.address,
    required this.minOrderValue,
    required this.priceRange,
    required this.loginOtp,
    required this.registerDate,
    required this.updatedAt,
    required this.createdAt,
    this.admin_auto_id,
  });
  late final String id;
  late final String name;
  late final String emailId;
  late final String mobileNumber;
  //late final String? password;
  late final String status;
  // late final String token;
  late final String haveRetailShop;
  late final String updateOnWhatsapp;
  late final String userType;
  late final String gstDocs;
  late final String shopActDocs;
  late final String companyRegCetificate;
  late final String city;
  late final String address;
  late final String minOrderValue;
  late final String priceRange;
  late final String loginOtp;
  late final String registerDate;
  late final String updatedAt;
  late final String createdAt;
  late final String? admin_auto_id;

  MyProfile.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    name = json['name'];
    emailId = json['email_id'];
    mobileNumber = json['mobile_number'];
    //password = json['password'];
    status = json['status'];
    // token = json['token'];
    haveRetailShop = json['have_retail_shop'];
    updateOnWhatsapp = json['update_on_whatsapp'];
    userType = json['user_type'];
    gstDocs = json['gst_docs'];
    shopActDocs = json['shop_act_docs'];
    companyRegCetificate = json['company_reg_cetificate'];
    city = json['city'];
    address = json['address'];
    minOrderValue = json['min_order_value'];
    priceRange = json['price_range'];
    loginOtp = json['login_otp'];
    registerDate = json['register_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    admin_auto_id=json['admin_auto_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['name'] = name;
    _data['email_id'] = emailId;
    _data['mobile_number'] = mobileNumber;
   // _data['password'] = password;
    _data['status'] = status;
    // _data['token'] = token;
    _data['have_retail_shop'] = haveRetailShop;
    _data['update_on_whatsapp'] = updateOnWhatsapp;
    _data['user_type'] = userType;
    _data['gst_docs'] = gstDocs;
    _data['shop_act_docs'] = shopActDocs;
    _data['company_reg_cetificate'] = companyRegCetificate;
    _data['city'] = city;
    _data['address'] = address;
    _data['min_order_value'] = minOrderValue;
    _data['price_range'] = priceRange;
    _data['login_otp'] = loginOtp;
    _data['register_date'] = registerDate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['admin_auto_id']=admin_auto_id;
    return _data;
  }
}