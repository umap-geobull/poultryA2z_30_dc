import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';

import '../../../../Admin_add_Product/Components/Model/offer_data.dart';
import '../../../../Admin_add_Product/Components/Model/size_model.dart';

class OfferProductModel {
  OfferProductModel({
    required this.status,
    required this.getAdminOfferProductLists,
  });
  late final int status;
  late final List<ProductModel> getAdminOfferProductLists;

  OfferProductModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    getAdminOfferProductLists = List.from(json['get_admin_offer_product_lists']).map((e)=>ProductModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['get_admin_offer_product_lists'] = getAdminOfferProductLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}