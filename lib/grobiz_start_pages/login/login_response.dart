class LoginResponse {
  LoginResponse({
    required this.status,
    required this.msg,
    required this.profile,
  });
  late final int status;
  late final String msg;
  late final List<Profile> profile;

  LoginResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    profile = List.from(json['profile']).map((e)=>Profile.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['profile'] = profile.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Profile {
  Profile({
    required this.id,
    required this.customerId,
    required this.name,
    required this.email,
    required this.password,
    required this.status,
    required this.emailVerification,
    required this.token,
    required this.appName,
    required this.appType,
    required this.appTypeId,
    required this.countryCode,
    required this.country,
    required this.contact,
    required this.city,
    required this.appLogo,
    required this.adminUsername,
    required this.adminPassword,
    required this.registerDate,
    required this.updatedAt,
    required this.createdAt,
    required this.categoryId,
  });
  late final String id;
  late final String customerId;
  late final String name;
  late final String email;
  late final String password;
  late final String status;
  late final String emailVerification;
  late final String? token;
  late final String appName;
  late final String appType;
  late final String? appTypeId;
  late final String countryCode;
  late final String country;
  late final String contact;
  late final String city;
  late final String appLogo;
  late final String adminUsername;
  late final String adminPassword;
  late final String registerDate;
  late final String updatedAt;
  late final String createdAt;
  late final String categoryId;

  Profile.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    customerId = json['customer_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    status = json['status'];
    emailVerification = json['email_verification'];
    token = json['token'];
    appName = json['app_name'];
    appType = json['app_type'];
    appTypeId = json['app_type_id'];
    countryCode = json['country_code'];
    country = json['country'];
    contact = json['contact'];
    city = json['city'];
    appLogo = json['app_logo'];
    adminUsername = json['admin_username'];
    adminPassword = json['admin_password'];
    registerDate = json['register_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['customer_id'] = customerId;
    _data['name'] = name;
    _data['email'] = email;
    _data['password'] = password;
    _data['status'] = status;
    _data['email_verification'] = emailVerification;
    _data['token'] = token;
    _data['app_name'] = appName;
    _data['app_type'] = appType;
    _data['app_type_id'] = appTypeId;
    _data['country_code'] = countryCode;
    _data['country'] = country;
    _data['contact'] = contact;
    _data['city'] = city;
    _data['app_logo'] = appLogo;
    _data['admin_username'] = adminUsername;
    _data['admin_password'] = adminPassword;
    _data['register_date'] = registerDate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['category_id'] = categoryId;
    return _data;
  }
}