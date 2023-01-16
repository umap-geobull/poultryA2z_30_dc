class SpecializationModel {
  SpecializationModel({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final int status;
  late final String msg;
  late final List<SpecializationList> data;

  SpecializationModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>SpecializationList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class SpecializationList {
  SpecializationList({
    required this.id,
    required this.adminAutoId,
    required this.specialization,
    required this.rdate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String adminAutoId;
  late final String specialization;
  late final String rdate;
  late final String updatedAt;
  late final String createdAt;
  bool isSelected=false;

  SpecializationList.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    adminAutoId = json['admin_auto_id'];
    specialization = json['specialization'];
    rdate = json['rdate'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['admin_auto_id'] = adminAutoId;
    _data['specialization'] = specialization;
    _data['rdate'] = rdate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}