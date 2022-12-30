class TypeAppBaseModel {
  TypeAppBaseModel({
    required this.status,
    required this.msg,
    required this.appBaseData,
  });
  late final int status;
  late final String msg;
  late final List<AppBaseData> appBaseData;

  TypeAppBaseModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    appBaseData = List.from(json['app_base_data']).map((e)=>AppBaseData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['app_base_data'] = appBaseData.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class AppBaseData {
  AppBaseData({
    required this.id,
    required this.appName,
    required this.keywords,
    required this.appImage,
    required this.updatedAt,
    required this.createdAt,
    required this.category_id,
  });
  late final String id;
  late final String appName;
  late final String keywords;
  late final String appImage;
  late final String updatedAt;
  late final String createdAt;
  late final String category_id;

  AppBaseData.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    appName = json['app_name'];
    keywords = json['keywords'];
    appImage = json['app_image'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    category_id = json['category_id'];

  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['app_name'] = appName;
    _data['keywords'] = keywords;
    _data['app_image'] = appImage;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['category_id'] = category_id;

    return _data;
  }
}