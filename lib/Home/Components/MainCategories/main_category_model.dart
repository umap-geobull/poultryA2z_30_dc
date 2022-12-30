class MainCategoryModel {
  MainCategoryModel({
    required this.status,
    required this.msg,
    required this.getmainCategorylist,
  });
  late final int status;
  late final String msg;
  late final List<GetmainCategorylist> getmainCategorylist;

  MainCategoryModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getmainCategorylist = List.from(json['getmain_categorylist']).map((e)=>GetmainCategorylist.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['getmain_categorylist'] = getmainCategorylist.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetmainCategorylist {
  GetmainCategorylist({
    required this.id,
    required this.categoryName,
    required this.categoryImageApp,
    required this.categoryImageWeb,
   // required this.registerDate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String categoryName;
  late final String categoryImageApp;
  late final String categoryImageWeb;
 // late final String registerDate;
  late final String updatedAt;
  late final String createdAt;

  GetmainCategorylist.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    categoryName = json['category_name'];
    categoryImageApp = json['category_image_app'];
    categoryImageWeb = json['category_image_web'];
    //registerDate = json['register_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['category_name'] = categoryName;
    _data['category_image_app'] = categoryImageApp;
    _data['category_image_web'] = categoryImageWeb;
    //_data['register_date'] = registerDate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}