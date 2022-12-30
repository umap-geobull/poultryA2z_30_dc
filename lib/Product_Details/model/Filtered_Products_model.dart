import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';

class FilteredProducts_Model {
  FilteredProducts_Model({
    required this.status,
    this.getAdminOfferProductLists,
  });
  late final int status;
  late final List<ProductModel>? getAdminOfferProductLists;

  FilteredProducts_Model.fromJson(Map<String, dynamic> json){
    status = json['status'];
    getAdminOfferProductLists = List.from(json['get_admin_filter_product_lists']).map((e)=>ProductModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['get_admin_filter_product_lists'] = getAdminOfferProductLists!.map((e)=>e.toJson()).toList();
    return _data;
  }
}