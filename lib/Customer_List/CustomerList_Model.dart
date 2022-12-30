class CustomerList_Model {
  CustomerList_Model({
    required this.status,
    required this.msg,
    required this.getCustomerLists,
  });
  late final int status;
  late final String msg;
  late final List<GetCustomerLists> getCustomerLists;

  CustomerList_Model.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getCustomerLists = List.from(json['get_customer_lists']).map((e)=>GetCustomerLists.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['get_customer_lists'] = getCustomerLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetCustomerLists {
  GetCustomerLists({
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

  GetCustomerLists.fromJson(Map<String, dynamic> json){
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
    return _data;
  }
}