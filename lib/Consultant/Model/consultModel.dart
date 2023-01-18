class ConsultModel {
  ConsultModel({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final String status;
  late final String msg;
  late final List<ConsultData> data;

  ConsultModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>ConsultData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ConsultData {
  ConsultData({
    required this.id,
    required this.adminAutoId,
    required this.userAutoId,
    required this.appTypeId,
    required this.fullName,
    required this.mobileNo,
    required this.location,
    required this.consutantType,
    required this.experience,
    required this.specialization,
    required this.fees,
    required this.availableFrom,
    required this.availableTo,
    required this.description,
    required this.consultantEmailId,
    required this.resume,
    required this.profilePhoto,
    required this.rdate,
    required this.updatedAt,
    required this.createdAt,
  });

  late final String id;
  late final String adminAutoId;
  late final String userAutoId;
  late final String appTypeId;
  late final String fullName;
  late final String mobileNo;
  late final String location;
  late final String consutantType;
  late final String experience;
  late final String specialization;
  late final String fees;
  late final String availableFrom;
  late final String availableTo;
  late final String description;
  late final String consultantEmailId;
  late final String resume;
  late final String profilePhoto;
  late final String rdate;
  late final String updatedAt;
  late final String createdAt;

  ConsultData.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    adminAutoId = json['admin_auto_id'];
    userAutoId = json['user_auto_id'];
    appTypeId = json['app_type_id'];
    fullName = json['full_name'];
    mobileNo = json['mobile_no'];
    location = json['location'];
    consutantType = json['consutant_type'];
    experience = json['experience'];
    specialization = json['specialization'];
    fees = json['fees'];
    availableFrom = json['available_from'];
    availableTo = json['available_to'];
    description = json['description'];
    consultantEmailId = json['consultant_email_id'];
    resume = json['resume'];
    profilePhoto = json['profile_photo'];
    rdate = json['rdate'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['admin_auto_id'] = adminAutoId;
    _data['user_auto_id'] = userAutoId;
    _data['app_type_id'] = appTypeId;
    _data['full_name'] = fullName;
    _data['mobile_no'] = mobileNo;
    _data['location'] = location;
    _data['consutant_type'] = consutantType;
    _data['experience'] = experience;
    _data['specialization'] = specialization;
    _data['fees'] = fees;
    _data['available_from'] = availableFrom;
    _data['available_to'] = availableTo;
    _data['description'] = description;
    _data['consultant_email_id'] = consultantEmailId;
    _data['resume'] = resume;
    _data['profile_photo'] = profilePhoto;
    _data['rdate'] = rdate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }

}