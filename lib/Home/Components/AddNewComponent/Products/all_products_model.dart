import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';

import '../../../../Admin_add_Product/Components/Model/offer_data.dart';
import '../../../../Admin_add_Product/Components/Model/size_model.dart';

class AllProductsModel {
  AllProductsModel({
    required this.status,
    required this.msg,
    required this.getProductsLists,
  });
  late final int status;
  late final String msg;
  late final List<ProductModel> getProductsLists;

  AllProductsModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getProductsLists = List.from(json['get_products_lists']).map((e)=>ProductModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['get_products_lists'] = getProductsLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}
