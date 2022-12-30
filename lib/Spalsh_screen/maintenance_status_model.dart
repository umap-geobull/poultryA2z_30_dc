class MaintenanceStatusModel {
  MaintenanceStatusModel({
    required this.status,
    required this.msg,
    required this.maintanceStatusData,
  });
  late final int status;
  late final String msg;
  late final List<MaintanceStatusData> maintanceStatusData;

  MaintenanceStatusModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    maintanceStatusData = List.from(json['maintance_status_data']).map((e)=>MaintanceStatusData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['maintance_status_data'] = maintanceStatusData.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class MaintanceStatusData {
  MaintanceStatusData({
    required this.id,
    required this.maintanceStatus,
    required this.updatedAt,
    required this.createdAt,
    required this.message,
  });
  late final String id;
  late final String maintanceStatus;
  late final String updatedAt;
  late final String createdAt;
  late final String message;

  MaintanceStatusData.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    maintanceStatus = json['maintance_status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['maintance_status'] = maintanceStatus;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['message'] = message;
    return _data;
  }
}