class Subcategory_Model_List {
  int? status;
  List<AllProductsUnderSubcategories>? allProductsUnderSubcategories;

  Subcategory_Model_List({this.status, this.allProductsUnderSubcategories});

  Subcategory_Model_List.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['all_products_under_subcategories'] != null) {
      allProductsUnderSubcategories = <AllProductsUnderSubcategories>[];
      json['all_products_under_subcategories'].forEach((v) {
        allProductsUnderSubcategories!
            .add(AllProductsUnderSubcategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (allProductsUnderSubcategories != null) {
      data['all_products_under_subcategories'] =
          allProductsUnderSubcategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllProductsUnderSubcategories {
  String? subCategoryAutoId;
  String? subCategoryName;
  String? subcategoryImageApp;
  String? subcategoryImageWeb;
  bool? isSelected;

  AllProductsUnderSubcategories(
      {this.subCategoryAutoId,
        this.subCategoryName,
        this.subcategoryImageApp,
        this.subcategoryImageWeb,
      this.isSelected});

  AllProductsUnderSubcategories.fromJson(Map<String, dynamic> json) {
    subCategoryAutoId = json['sub_category_auto_id'];
    subCategoryName = json['sub_category_name'];
    subcategoryImageApp = json['subcategory_image_app'];
    subcategoryImageWeb = json['subcategory_image_web'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub_category_auto_id'] = subCategoryAutoId;
    data['sub_category_name'] = subCategoryName;
    data['subcategory_image_app'] = subcategoryImageApp;
    data['subcategory_image_web'] = subcategoryImageWeb;
    return data;
  }
}