class SignUpResponse {
  SignUpResponse({
    required this.status,
    required this.msg,
    required this.profile,
  });
  late final int status;
  late final String msg;
  late final Profile profile;

  SignUpResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    profile = Profile.fromJson(json['profile']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['profile'] = profile.toJson();
    return _data;
  }
}

class Profile {
  Profile({
    required this.customerId,
    required this.name,
    required this.email,
    required this.password,
    required this.status,
    required this.token,
    required this.registerDate,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });
  late final String customerId;
  late final String name;
  late final String email;
  late final String password;
  late final String status;
  late final String token;
  late final String registerDate;
  late final String updatedAt;
  late final String createdAt;
  late final String id;

  Profile.fromJson(Map<String, dynamic> json){
    customerId = json['customer_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    status = json['status'];
    token = json['token'];
    registerDate = json['register_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['customer_id'] = customerId;
    _data['name'] = name;
    _data['email'] = email;
    _data['password'] = password;
    _data['status'] = status;
    _data['token'] = token;
    _data['register_date'] = registerDate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['_id'] = id;
    return _data;
  }
}