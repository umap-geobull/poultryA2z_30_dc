class MainCat_List_Model {
  int? status;
  String? msg;
  List<Get_mainCategorylist>? getmainCategorylist;

  MainCat_List_Model({this.status, this.msg, this.getmainCategorylist});

  MainCat_List_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['getmain_categorylist'] != null) {
      getmainCategorylist = <Get_mainCategorylist>[];
      json['getmain_categorylist'].forEach((v) {
        getmainCategorylist!.add(Get_mainCategorylist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    if (getmainCategorylist != null) {
      data['getmain_categorylist'] =
          getmainCategorylist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Get_mainCategorylist {
  String? sId;
  String? categoryName;
  String? categoryImageApp;
  String? categoryImageWeb;
  String? registerDate;
  String? updatedAt;
  String? createdAt;
  bool? isSelected;

  Get_mainCategorylist(
      {this.sId,
        this.categoryName,
        this.categoryImageApp,
        this.categoryImageWeb,
        this.registerDate,
        this.updatedAt,
        this.createdAt,
      this.isSelected});

  Get_mainCategorylist.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    categoryName = json['category_name'];
    categoryImageApp = json['category_image_app'];
    categoryImageWeb = json['category_image_web'];
    registerDate = json['register_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['category_name'] = categoryName;
    data['category_image_app'] = categoryImageApp;
    data['category_image_web'] = categoryImageWeb;
    data['register_date'] = registerDate;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}