class VendorOrder_Model {
  int? status;
  String? msg;
  List<Data>? data;

  VendorOrder_Model({this.status, this.msg, this.data});

  VendorOrder_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? productOrderAutoId;
  String? orderId;
  String? addedById;
  String? addedBy;
  String? productAutoId;
  String? productName;
  String? productImage;
  String? size;
  String? quantity;
  String? colorName;
  String? colorImage;
  String? orderDate;
  String? orderStatus;
  String? productPrice;
  String? productOfferPercentage;
  String? productFinalPrice;

  Data(
      {this.productOrderAutoId,
        this.orderId,
        this.addedById,
        this.addedBy,
        this.productAutoId,
        this.productName,
        this.productImage,
        this.size,
        this.quantity,
        this.colorName,
        this.colorImage,
        this.orderDate,
        this.orderStatus,
        this.productPrice,
        this.productOfferPercentage,
        this.productFinalPrice});

  Data.fromJson(Map<String, dynamic> json) {
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
    productFinalPrice = json['product_final_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_order_auto_id'] = productOrderAutoId;
    data['order_id'] = orderId;
    data['added_by_id'] = addedById;
    data['added_by'] = addedBy;
    data['product_auto_id'] = productAutoId;
    data['product_name'] = productName;
    data['product_image'] = productImage;
    data['size'] = size;
    data['quantity'] = quantity;
    data['color_name'] = colorName;
    data['color_image'] = colorImage;
    data['order_date'] = orderDate;
    data['order_status'] = orderStatus;
    data['product_price'] = productPrice;
    data['product_offer_percentage'] = productOfferPercentage;
    data['product_final_price'] = productFinalPrice;
    return data;
  }
}