class ProductVListModel {
  ProductVListModel({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final String status;
  late final String msg;
  late final List<ProductVListData> data;

  ProductVListModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>ProductVListData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ProductVListData {
  ProductVListData({
    required this.id,
    required this.userAutoId,
    required this.productName,
    required this.productImage,
    required this.rdate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String userAutoId;
  late final String productName;
  late final String productImage;
  late final String rdate;
  late final String updatedAt;
  late final String createdAt;

  ProductVListData.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    userAutoId = json['user_auto_id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    rdate = json['rdate'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['user_auto_id'] = userAutoId;
    _data['product_name'] = productName;
    _data['product_image'] = productImage;
    _data['rdate'] = rdate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}