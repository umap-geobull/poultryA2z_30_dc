class CartCountModel {
  CartCountModel({
    required this.status,
    required this.productCountData,
    required this.getAdminCartProductLists,
  });
  late final int status;
  late final int productCountData;
  late final List<GetAdminCartProductLists> getAdminCartProductLists;

  CartCountModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    productCountData = json['product_count_data'];
    getAdminCartProductLists = List.from(json['get_admin_cart_product_lists']).map((e)=>GetAdminCartProductLists.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['product_count_data'] = productCountData;
    _data['get_admin_cart_product_lists'] = getAdminCartProductLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetAdminCartProductLists {
  GetAdminCartProductLists({
    required this.productAutoId,
  });
  late final String productAutoId;

  GetAdminCartProductLists.fromJson(Map<String, dynamic> json){
    productAutoId = json['product_auto_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['product_auto_id'] = productAutoId;
    return _data;
  }
}