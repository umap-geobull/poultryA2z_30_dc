class Brand_List_Model {
  int? status;
  String? msg;

  List<Get_Brandslist>? getBrandslist;

  Brand_List_Model({this.status, this.msg, this.getBrandslist});

  Brand_List_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['get_brandslist'] != null) {
      getBrandslist = <Get_Brandslist>[];
      json['get_brandslist'].forEach((v) {
        getBrandslist!.add(Get_Brandslist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    if (getBrandslist != null) {
      data['get_brandslist'] =
          getBrandslist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Get_Brandslist {
  String? sId;
  String? brandName;
  String? brandImageApp;
  String? brandImageWeb;
  String? mainCategoryAutoId;
  String? registerDate;
  String? updatedAt;
  String? createdAt;
  bool? isSelected;

  Get_Brandslist(
      this.sId,
        this.brandName,
        this.brandImageApp,
        this.brandImageWeb,
        this.mainCategoryAutoId,
        this.registerDate,
        this.updatedAt,
        this.createdAt,
      this.isSelected);


  Get_Brandslist.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    brandName = json['brand_name'];
    brandImageApp = json['brand_image_app'];
    brandImageWeb = json['brand_image_web'];
    mainCategoryAutoId = json['main_category_auto_id'];
    registerDate = json['register_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['brand_name'] = brandName;
    data['brand_image_app'] = brandImageApp;
    data['brand_image_web'] = brandImageWeb;
    data['main_category_auto_id'] = mainCategoryAutoId;
    data['register_date'] = registerDate;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}