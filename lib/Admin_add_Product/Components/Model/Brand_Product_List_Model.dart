
import '../../../Product_Details/model/Product_Model.dart';

class BrandProductModel {
  BrandProductModel({
    required this.status,
    required this.getAdminBrandProductLists,
  });
  late final int status;
  late final List<ProductModel> getAdminBrandProductLists;

  BrandProductModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    getAdminBrandProductLists = List.from(json['get_admin_brand_product_lists']).map((e)=>ProductModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['get_admin_brand_product_lists'] = getAdminBrandProductLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}
