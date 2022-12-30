class MainCategoryBrands {
  MainCategoryBrands({
    required this.status,
    required this.msg,
    required this.getMainCategoryBrands,
  });
  late final String status;
  late final String msg;
  late final List<GetMainCategoryBrands> getMainCategoryBrands;
  
  MainCategoryBrands.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getMainCategoryBrands = List.from(json['get_main_category_components']).map((e)=>GetMainCategoryBrands.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['get_main_category_components'] = getMainCategoryBrands.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetMainCategoryBrands {
  GetMainCategoryBrands({
    required this.id,
    required this.brandName,
    required this.brandImageApp,
    required this.brandImageWeb,
    required this.mainCategoryAutoId,
    required this.registerDate,
    required this.updatedAt,
    required this.createdAt,
  });


  late final String id;
  late final String brandName;
  late final String brandImageApp;
  late final String brandImageWeb;
  late final String mainCategoryAutoId;
  late final String registerDate;
  late final String updatedAt;
  late final String createdAt;
  
  GetMainCategoryBrands.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    brandName = json['brand_name'];
    brandImageApp = json['brand_image_app'];
    brandImageWeb = json['brand_image_web'];
    mainCategoryAutoId = json['main_category_auto_id'];
    registerDate = json['register_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['brand_name'] = brandName;
    _data['brand_image_app'] = brandImageApp;
    _data['brand_image_web'] = brandImageWeb;
    _data['main_category_auto_id'] = mainCategoryAutoId;
    _data['register_date'] = registerDate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}