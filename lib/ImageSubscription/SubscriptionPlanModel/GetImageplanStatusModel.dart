class GetImageplanStatusModel {
  GetImageplanStatusModel({
    required this.status,
    required this.msg,
    required this.planStatus,
  });
  late final int status;
  late final String msg;
  late final String planStatus;

  GetImageplanStatusModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    planStatus = json['plan_status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['plan_status'] = planStatus;
    return _data;
  }
}