class VendorOrder_Model {
  VendorOrder_Model({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final int status;
  late final String msg;
  late final List<Data> data;

  VendorOrder_Model.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.productOrderAutoId,
    required this.orderId,
    required this.addedById,
    required this.addedBy,
    required this.productAutoId,
    required this.productName,
    required this.productImage,
    required this.size,
    required this.quantity,
    required this.colorName,
    required this.colorImage,
    required this.orderDate,
    required this.orderStatus,
    required this.productPrice,
    required this.productOfferPercentage,
    required this.productOfferPrice,
    required this.productFinalPrice,
  });
  late final String? productOrderAutoId;
  late final String? orderId;
  late final String? addedById;
  late final String? addedBy;
  late final String? productAutoId;
  late final String? productName;
  late final String? productImage;
  late final String? size;
  late final String? quantity;
  late final String? colorName;
  late final String? colorImage;
  late final String? orderDate;
  late final String? orderStatus;
  late final String? productPrice;
  late final String? productOfferPercentage;
  late final String? productOfferPrice;
  late final String? productFinalPrice;

  Data.fromJson(Map<String, dynamic> json){
    productOrderAutoId = json['product_order_auto_id'];
    orderId = json['order_id'];
    addedById = json['added_by_id'];
    addedBy = json['added_by'];
    productAutoId = json['product_auto_id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    size = json['size'];
    quantity = json['quantity'];
    colorName = json['color_name'];
    colorImage = json['color_image'];
    orderDate = json['order_date'];
    orderStatus = json['order_status'];
    productPrice = json['product_price'];
    productOfferPercentage = json['product_offer_percentage'];
    productOfferPrice = json['product_offer_price'];
    productFinalPrice = json['product_final_price'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['product_order_auto_id'] = productOrderAutoId;
    _data['order_id'] = orderId;
    _data['added_by_id'] = addedById;
    _data['added_by'] = addedBy;
    _data['product_auto_id'] = productAutoId;
    _data['product_name'] = productName;
    _data['product_image'] = productImage;
    _data['size'] = size;
    _data['quantity'] = quantity;
    _data['color_name'] = colorName;
    _data['color_image'] = colorImage;
    _data['order_date'] = orderDate;
    _data['order_status'] = orderStatus;
    _data['product_price'] = productPrice;
    _data['product_offer_percentage'] = productOfferPercentage;
    _data['product_offer_price'] = productOfferPrice;
    _data['product_final_price'] = productFinalPrice;
    return _data;
  }
}