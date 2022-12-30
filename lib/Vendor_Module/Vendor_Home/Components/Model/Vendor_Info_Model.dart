class Vendor_info_Model {
  int? status;
  Vendor_Profile? profile;

  Vendor_info_Model({this.status, this.profile});

  Vendor_info_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    profile =
    json['profile'] != null ? new Vendor_Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class Vendor_Profile {
  String? sId;
  String? name;
  String? emailId;
  String? mobileNumber;
  String? password;
  String? status;
  String? token;
  String? haveRetailShop;
  String? updateOnWhatsapp;
  String? userType;
  String? gstDocs;
  String? shopActDocs;
  String? companyRegCetificate;
  String? city;
  String? address;
  String? minOrderValue;
  String? priceRange;
  String? loginOtp;
  String? registerDate;
  String? updatedAt;
  String? createdAt;

  Vendor_Profile(
      {this.sId,
        this.name,
        this.emailId,
        this.mobileNumber,
        this.password,
        this.status,
        this.token,
        this.haveRetailShop,
        this.updateOnWhatsapp,
        this.userType,
        this.gstDocs,
        this.shopActDocs,
        this.companyRegCetificate,
        this.city,
        this.address,
        this.minOrderValue,
        this.priceRange,
        this.loginOtp,
        this.registerDate,
        this.updatedAt,
        this.createdAt});

  Vendor_Profile.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    emailId = json['email_id'];
    mobileNumber = json['mobile_number'];
    password = json['password'];
    status = json['status'];
    token = json['token'];
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email_id'] = this.emailId;
    data['mobile_number'] = this.mobileNumber;
    data['password'] = this.password;
    data['status'] = this.status;
    data['token'] = this.token;
    data['have_retail_shop'] = this.haveRetailShop;
    data['update_on_whatsapp'] = this.updateOnWhatsapp;
    data['user_type'] = this.userType;
    data['gst_docs'] = this.gstDocs;
    data['shop_act_docs'] = this.shopActDocs;
    data['company_reg_cetificate'] = this.companyRegCetificate;
    data['city'] = this.city;
    data['address'] = this.address;
    data['min_order_value'] = this.minOrderValue;
    data['price_range'] = this.priceRange;
    data['login_otp'] = this.loginOtp;
    data['register_date'] = this.registerDate;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}