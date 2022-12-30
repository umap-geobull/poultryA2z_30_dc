class BuyNowModel {
  BuyNowModel({
    required this.status,
    required this.data,
  });
  late final String status;
  late final Data data;

  BuyNowModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.productAutoId,
    required this.userAutoId,
    required this.cartQuantity,
    required this.size,
    required this.rdate,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });
  late final String productAutoId;
  late final String userAutoId;
  late final String cartQuantity;
  late final String size;
  late final String rdate;
  late final String updatedAt;
  late final String createdAt;
  late final String id;

  Data.fromJson(Map<String, dynamic> json){
    productAutoId = json['product_auto_id'];
    userAutoId = json['user_auto_id'];
    cartQuantity = json['cart_quantity'];
    size = json['size'];
    rdate = json['rdate'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['product_auto_id'] = productAutoId;
    _data['user_auto_id'] = userAutoId;
    _data['cart_quantity'] = cartQuantity;
    _data['size'] = size;
    _data['rdate'] = rdate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['_id'] = id;
    return _data;
  }
}