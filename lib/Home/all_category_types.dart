class AllAppCategoryType {
  AllAppCategoryType({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final int status;
  late final String msg;
  late final List<App_Category> data;

  AllAppCategoryType.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>App_Category.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class App_Category {
  App_Category({
    required this.id,
    required this.name,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String name;
  late final String updatedAt;
  late final String createdAt;

  App_Category.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    name = json['name'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['name'] = name;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}