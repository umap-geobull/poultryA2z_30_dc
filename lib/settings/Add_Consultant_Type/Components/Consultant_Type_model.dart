class Consulant_Type_model {
  Consulant_Type_model({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final int status;
  late final String msg;
  late final List<Consultant_typeList> data;

  Consulant_Type_model.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>Consultant_typeList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Consultant_typeList {
  Consultant_typeList({
    required this.id,
    required this.adminAutoId,
    required this.consultant_type,
    required this.rdate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String adminAutoId;
  late final String consultant_type;
  late final String rdate;
  late final String updatedAt;
  late final String createdAt;
  bool isSelected=false;

  Consultant_typeList.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    adminAutoId = json['admin_auto_id'];
    consultant_type = json['consultant_type'];
    rdate = json['rdate'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['admin_auto_id'] = adminAutoId;
    _data['consultant_type'] = consultant_type;
    _data['rdate'] = rdate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}