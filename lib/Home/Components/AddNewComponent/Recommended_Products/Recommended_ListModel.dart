import 'package:poultry_a2z/Admin_add_Product/Components/Model/size_model.dart';

import '../../../../Admin_add_Product/Components/Model/offer_data.dart';
import '../../../../Product_Details/model/Product_Model.dart';
class Recommended_ListModel {
  Recommended_ListModel({
    required this.status,
    required this.getRecommendedProductsLists,
  });
  late final int status;
  late final List<ProductModel> getRecommendedProductsLists;

  Recommended_ListModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    getRecommendedProductsLists = List.from(json['get_recommended_products_lists']).map((e)=>ProductModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['get_recommended_products_lists'] = getRecommendedProductsLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}
