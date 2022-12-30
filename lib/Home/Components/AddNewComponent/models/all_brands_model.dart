class AllBrandsModel {
  AllBrandsModel({
    required this.status,
    required this.msg,
    required this.getBrandslist,
  });
  late final int status;
  late final String msg;
  late final List<GetBrandslist> getBrandslist;

  AllBrandsModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getBrandslist = List.from(json['get_brandslist']).map((e)=>GetBrandslist.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['get_brandslist'] = getBrandslist.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetBrandslist {
  GetBrandslist({
    required this.id,
    required this.brandName,
    required this.brandImageApp,
    required this.brandImageWeb,
    //required this.registerDate,
    required this.updatedAt,
    required this.createdAt,
    required this.main_category_auto_id
  });
  late final String id;
  late final String brandName;
  late final String brandImageApp;
  late final String brandImageWeb;
 // late final String registerDate;
  late final String updatedAt;
  late final String createdAt;
  late final String main_category_auto_id;

  GetBrandslist.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    brandName = json['brand_name'];
    brandImageApp = json['brand_image_app'];
    brandImageWeb = json['brand_image_web'];
   // registerDate = json['register_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    main_category_auto_id= json['main_category_auto_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['brand_name'] = brandName;
    _data['brand_image_app'] = brandImageApp;
    _data['brand_image_web'] = brandImageWeb;
   // _data['register_date'] = registerDate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['main_category_auto_id'] =main_category_auto_id;
    return _data;
  }
}