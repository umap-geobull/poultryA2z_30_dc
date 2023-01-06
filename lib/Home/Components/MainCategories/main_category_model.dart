class MainCategoryModel {
  MainCategoryModel({
    required this.status,
    required this.getmainCategorylist,
  });
  late final int status;
  late final List<GetmainCategorylist> getmainCategorylist;

  MainCategoryModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    getmainCategorylist = List.from(json['getmain_categorylist']).map((e)=>GetmainCategorylist.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['getmain_categorylist'] = getmainCategorylist.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetmainCategorylist {
  GetmainCategorylist({
    required this.id,
    required this.categoryName,
    required this.adminAutoId,
    required this.categoryImageApp,
    required this.categoryImageWeb,
    required this.registerDate,
    required this.appTypeId,
    required this.fields,
  });
  late final String id;
  late final String categoryName;
  late final String adminAutoId;
  late final String categoryImageApp;
  late final String categoryImageWeb;
  late final String registerDate;
  late final String appTypeId;
  late final List<String> fields;

  GetmainCategorylist.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    categoryName = json['category_name'];
    adminAutoId = json['admin_auto_id'];
    categoryImageApp = json['category_image_app'];
    categoryImageWeb = json['category_image_web'];
    registerDate = json['register_date'];
    appTypeId = json['app_type_id'];
    fields = List.castFrom<dynamic, String>(json['fields']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['category_name'] = categoryName;
    _data['admin_auto_id'] = adminAutoId;
    _data['category_image_app'] = categoryImageApp;
    _data['category_image_web'] = categoryImageWeb;
    _data['register_date'] = registerDate;
    _data['app_type_id'] = appTypeId;
    _data['fields'] = fields;
    return _data;
  }
}