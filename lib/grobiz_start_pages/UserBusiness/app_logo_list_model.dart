class AppLogoListModel {
  AppLogoListModel({
    required this.status,
    required this.msg,
    required this.logosList,
  });
  late final int status;
  late final String msg;
  late final List<LogosList> logosList;

  AppLogoListModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    logosList = List.from(json['logos_list']).map((e)=>LogosList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['logos_list'] = logosList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class LogosList {
  LogosList({
    required this.id,
    required this.logo,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String logo;
  late final String updatedAt;
  late final String createdAt;

  LogosList.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    logo = json['logo'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['logo'] = logo;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}