class AllCouponModel {
  AllCouponModel({
    required this.status,
    required this.msg,
    required this.allCuponcodeList,
  });
  late final int status;
  late final String msg;
  late final List<CuponcodeList> allCuponcodeList;

  AllCouponModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    allCuponcodeList = List.from(json['all_cuponcode_list']).map((e)=>CuponcodeList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['all_cuponcode_list'] = allCuponcodeList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class CuponcodeList {
  CuponcodeList({
    required this.id,
    required this.userAutoId,
    required this.adminAutoId,
    required this.type,
    required this.coupenCode,
    required this.coupenCodeValue,
    required this.coupenCodeDesc,
    required this.startDate,
    required this.endDate,
    required this.registerDate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String userAutoId;
  late final String adminAutoId;
  late final String type;
  late final String coupenCode;
  late final String coupenCodeValue;
  late final String coupenCodeDesc;
  late final String startDate;
  late final String endDate;
  late final String registerDate;
  late final String updatedAt;
  late final String createdAt;

  CuponcodeList.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    userAutoId = json['user_auto_id'];
    adminAutoId = json['admin_auto_id'];
    type = json['type'];
    coupenCode = json['coupen_code'];
    coupenCodeValue = json['coupen_code_value'];
    coupenCodeDesc = json['coupen_code_desc'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    registerDate = json['register_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['user_auto_id'] = userAutoId;
    _data['admin_auto_id'] = adminAutoId;
    _data['type'] = type;
    _data['coupen_code'] = coupenCode;
    _data['coupen_code_value'] = coupenCodeValue;
    _data['coupen_code_desc'] = coupenCodeDesc;
    _data['start_date'] = startDate;
    _data['end_date'] = endDate;
    _data['register_date'] = registerDate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}