import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';
class SimilarProductModel {
  SimilarProductModel({
    required this.status,
    required this.getAdminSubcategoryProductLists,
  });
  late final int status;
  late final List<ProductModel> getAdminSubcategoryProductLists;

  SimilarProductModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    getAdminSubcategoryProductLists = List.from(json['get_similar_product_lists']).map((e)=>ProductModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['get_similar_product_lists'] = getAdminSubcategoryProductLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}