class SubCategoryModel {
  SubCategoryModel({
    required this.status,
    required this.msg,
    required this.getmainSubcategorylist,
  });
  late final int status;
  late final String msg;
  late final List<GetmainSubcategorylist> getmainSubcategorylist;

  SubCategoryModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getmainSubcategorylist = List.from(json['getmain_subcategorylist']).map((e)=>GetmainSubcategorylist.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['getmain_subcategorylist'] = getmainSubcategorylist.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetmainSubcategorylist {
  GetmainSubcategorylist({
    required this.id,
    required this.mainCategoryAutoId,
    required this.subCategoryName,
    required this.subcategoryImageApp,
    required this.subcategoryImageWeb,
    required this.registerDate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String mainCategoryAutoId;
  late final String subCategoryName;
  late final String subcategoryImageApp;
  late final String subcategoryImageWeb;
  late final String registerDate;
  late final String updatedAt;
  late final String createdAt;

  GetmainSubcategorylist.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    mainCategoryAutoId = json['main_category_auto_id'];
    subCategoryName = json['sub_category_name'];
    subcategoryImageApp = json['subcategory_image_app'];
    subcategoryImageWeb = json['subcategory_image_web'];
    registerDate = json['register_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['main_category_auto_id'] = mainCategoryAutoId;
    _data['sub_category_name'] = subCategoryName;
    _data['subcategory_image_app'] = subcategoryImageApp;
    _data['subcategory_image_web'] = subcategoryImageWeb;
    _data['register_date'] = registerDate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}