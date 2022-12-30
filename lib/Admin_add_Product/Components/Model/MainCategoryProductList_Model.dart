import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';

class MainCategoryProductsModel {
  MainCategoryProductsModel({
    required this.status,
    required this.getAdminCategoryProductLists,
  });
  late final int status;
  late final List<ProductModel> getAdminCategoryProductLists;

  MainCategoryProductsModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    getAdminCategoryProductLists = List.from(json['get_admin_category_product_lists']).map((e)=>ProductModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['get_admin_category_product_lists'] = getAdminCategoryProductLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}
