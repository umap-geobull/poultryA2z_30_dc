
import '../../../Product_Details/model/Product_Model.dart';
class SubCategoryProductModel {
  SubCategoryProductModel({
    required this.status,
    required this.getAdminSubcategoryProductLists,
  });
  late final int status;
  late final List<ProductModel> getAdminSubcategoryProductLists;

  SubCategoryProductModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    getAdminSubcategoryProductLists = List.from(json['get_admin_subcategory_product_lists']).map((e)=>ProductModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['get_admin_subcategory_product_lists'] = getAdminSubcategoryProductLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}