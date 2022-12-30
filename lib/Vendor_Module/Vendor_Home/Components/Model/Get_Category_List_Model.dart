class Category_List_Model {
  int? status;
  List<GetVendorCategoryLists>? getVendorCategoryLists;

  Category_List_Model({this.status, this.getVendorCategoryLists});

  Category_List_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['get_vendor_category_lists'] != null) {
      getVendorCategoryLists = <GetVendorCategoryLists>[];
      json['get_vendor_category_lists'].forEach((v) {
        getVendorCategoryLists!.add(GetVendorCategoryLists.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (getVendorCategoryLists != null) {
      data['get_vendor_category_lists'] =
          getVendorCategoryLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetVendorCategoryLists {
  String? sId;
  String? categoryName;
  String? categoryImageApp;
  String? categoryImageWeb;
  String? registerDate;
  String? updatedAt;
  String? createdAt;

  GetVendorCategoryLists(
      {this.sId,
        this.categoryName,
        this.categoryImageApp,
        this.categoryImageWeb,
        this.registerDate,
        this.updatedAt,
        this.createdAt});

  GetVendorCategoryLists.fromJson(Map<String, dynamic> json) {
    sId = json['category_auto_id'];
    categoryName = json['category_name'];
    categoryImageApp = json['category_image_app'];
    categoryImageWeb = json['category_image_web'];
    registerDate = json['register_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_auto_id'] = sId;
    data['category_name'] = categoryName;
    data['category_image_app'] = categoryImageApp;
    data['category_image_web'] = categoryImageWeb;
    data['register_date'] = registerDate;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}