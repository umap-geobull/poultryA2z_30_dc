class AdminProfileModel {
  AdminProfileModel({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final int status;
  late final String msg;
  late final List<Data> data;

  AdminProfileModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.adminPassword,
    required this.adminUsername,
    required this.appLogo,
    required this.appName,
    required this.appType,
    required this.appTypeId,
    required this.city,
    required this.clientId,
    required this.code,
    required this.country,
    required this.countryCode,
    required this.currency,
    required this.customerId,
    required this.emailVerification,
    required this.eraseDataStatus,
    required this.merchantName,
    required this.name,
    required this.password,
    required this.paymentGatewayName,
    required this.razorpayKey,
    required this.registerDate,
    required this.secretKey,
    required this.shiprocketAuthEmail,
    required this.shiprocketAuthPassword,
    required this.status,
    required this.token,
    required this.updatedAt,
    required this.userType,
    required this.emailId,
    required this.mobileNumber,
    required this.loginOtp,
    required this.adminAutoId,
  });
  late final String id;
  late final String adminPassword;
  late final String adminUsername;
  late final String appLogo;
  late final String appName;
  late final String appType;
  late final String appTypeId;
  late final String city;
  late final String clientId;
  late final String code;
  late final String country;
  late final String countryCode;
  late final String currency;
  late final String customerId;
  late final String emailVerification;
  late final String eraseDataStatus;
  late final String merchantName;
  late final String name;
  late final String password;
  late final String paymentGatewayName;
  late final String razorpayKey;
  late final String registerDate;
  late final String secretKey;
  late final String shiprocketAuthEmail;
  late final String shiprocketAuthPassword;
  late final String status;
  late final String token;
  late final String updatedAt;
  late final String userType;
  late final String emailId;
  late final String mobileNumber;
  late final String loginOtp;
  late final String adminAutoId;

  Data.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    adminPassword = json['admin_password'];
    adminUsername = json['admin_username'];
    appLogo = json['app_logo'];
    appName = json['app_name'];
    appType = json['app_type'];
    appTypeId = json['app_type_id'];
    city = json['city'];
    clientId = json['client_id'];
    code = json['code'];
    country = json['country'];
    countryCode = json['country_code'];
    currency = json['currency'];
    customerId = json['customer_id'];
    emailVerification = json['email_verification'];
    eraseDataStatus = json['erase_data_status'];
    merchantName = json['merchant_name'];
    name = json['name'];
    password = json['password'];
    paymentGatewayName = json['payment_gateway_name'];
    razorpayKey = json['razorpay_key'];
    registerDate = json['register_date'];
    secretKey = json['secret_key'];
    shiprocketAuthEmail = json['shiprocket_auth_email'];
    shiprocketAuthPassword = json['shiprocket_auth_password'];
    status = json['status'];
    token = json['token'];
    updatedAt = json['updated_at'];
    userType = json['user_type'];
    emailId = json['email_id'];
    mobileNumber = json['mobile_number'];
    loginOtp = json['login_otp'];
    adminAutoId = json['admin_auto_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['admin_password'] = adminPassword;
    _data['admin_username'] = adminUsername;
    _data['app_logo'] = appLogo;
    _data['app_name'] = appName;
    _data['app_type'] = appType;
    _data['app_type_id'] = appTypeId;
    _data['city'] = city;
    _data['client_id'] = clientId;
    _data['code'] = code;
    _data['country'] = country;
    _data['country_code'] = countryCode;
    _data['currency'] = currency;
    _data['customer_id'] = customerId;
    _data['email_verification'] = emailVerification;
    _data['erase_data_status'] = eraseDataStatus;
    _data['merchant_name'] = merchantName;
    _data['name'] = name;
    _data['password'] = password;
    _data['payment_gateway_name'] = paymentGatewayName;
    _data['razorpay_key'] = razorpayKey;
    _data['register_date'] = registerDate;
    _data['secret_key'] = secretKey;
    _data['shiprocket_auth_email'] = shiprocketAuthEmail;
    _data['shiprocket_auth_password'] = shiprocketAuthPassword;
    _data['status'] = status;
    _data['token'] = token;
    _data['updated_at'] = updatedAt;
    _data['user_type'] = userType;
    _data['email_id'] = emailId;
    _data['mobile_number'] = mobileNumber;
    _data['login_otp'] = loginOtp;
    _data['admin_auto_id'] = adminAutoId;
    return _data;
  }
}