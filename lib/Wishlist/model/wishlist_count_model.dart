class WishlistCountModel {
  WishlistCountModel({
    required this.status,
    required this.productCountData,
    required this.getAdminWishlistProductLists,
  });
  late final int status;
  late final int productCountData;
  late final List<GetAdminWishlistProductLists> getAdminWishlistProductLists;

  WishlistCountModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    productCountData = json['product_count_data'];
    getAdminWishlistProductLists = List.from(json['get_admin_wishlist_product_lists']).map((e)=>GetAdminWishlistProductLists.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['product_count_data'] = productCountData;
    _data['get_admin_wishlist_product_lists'] = getAdminWishlistProductLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetAdminWishlistProductLists {
  GetAdminWishlistProductLists({
    required this.productAutoId,
  });
  late final String productAutoId;

  GetAdminWishlistProductLists.fromJson(Map<String, dynamic> json){
    productAutoId = json['product_auto_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['product_auto_id'] = productAutoId;
    return _data;
  }
}