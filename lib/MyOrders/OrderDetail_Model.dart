class OrderDetailsModel {
  OrderDetailsModel({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final int status;
  late final String msg;
  late final List<OrderDetailsData> data;

  OrderDetailsModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>OrderDetailsData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class OrderDetailsData {
  OrderDetailsData({
    required this.orderAutoId,
    required this.customerAutoId,
    required this.orderId,
    required this.address,
    required this.country,
    required this.state,
    required this.city,
    required this.mobileNo,
    required this.paymentMode,
    required this.transactionId,
    required this.paymentStatus,
    required this.appliedPromocode,
    required this.promocodeValueOff,
    required this.promocodeType,
    required this.promocodeValueOffOnOrder,
    required this.usedPincode,
    required this.pincodeDeliveryCharge,
    required this.totalPrice,
    required this.totalPaidPrice,
    required this.status,
    required this.orderDate,
    required this.orderTime,
    required this.productDetails,
    required this.getRatingLists,
  });
  late final String orderAutoId;
  late final String customerAutoId;
  late final String orderId;
  late final String address;
  late final String country;
  late final String state;
  late final String city;
  late final String mobileNo;
  late final String paymentMode;
  late final String transactionId;
  late final String paymentStatus;
  late final String appliedPromocode;
  late final String promocodeValueOff;
  late final String promocodeType;
  late final String promocodeValueOffOnOrder;
  late final String usedPincode;
  late final String pincodeDeliveryCharge;
  late final String totalPrice;
  late final String totalPaidPrice;
  late final String status;
  late final String orderDate;
  late final String orderTime;
  late final List<ProductDetails> productDetails;
  late final List<GetRatingLists> getRatingLists;

  OrderDetailsData.fromJson(Map<String, dynamic> json){
    orderAutoId = json['order_auto_id'];
    customerAutoId = json['customer_auto_id'];
    orderId = json['order_id'];
    address = json['address'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    mobileNo = json['mobile_no'];
    paymentMode = json['payment_mode'];
    transactionId = json['transaction_id'];
    paymentStatus = json['payment_status'];
    appliedPromocode = json['applied_promocode'];
    promocodeValueOff = json['promocode_value_off'];
    promocodeType = json['promocode_type'];
    promocodeValueOffOnOrder = json['promocode_value_off_on_order'];
    usedPincode = json['used_pincode'];
    pincodeDeliveryCharge = json['pincode_delivery_charge'];
    totalPrice = json['total_price'];
    totalPaidPrice = json['total_paid_price'];
    status = json['status'];
    orderDate = json['order_date'];
    orderTime = json['order_time'];
    productDetails = List.from(json['product_details']).map((e)=>ProductDetails.fromJson(e)).toList();
    getRatingLists = List.from(json['get_rating_lists']).map((e)=>GetRatingLists.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['order_auto_id'] = orderAutoId;
    _data['customer_auto_id'] = customerAutoId;
    _data['order_id'] = orderId;
    _data['address'] = address;
    _data['country'] = country;
    _data['state'] = state;
    _data['city'] = city;
    _data['mobile_no'] = mobileNo;
    _data['payment_mode'] = paymentMode;
    _data['transaction_id'] = transactionId;
    _data['payment_status'] = paymentStatus;
    _data['applied_promocode'] = appliedPromocode;
    _data['promocode_value_off'] = promocodeValueOff;
    _data['promocode_type'] = promocodeType;
    _data['promocode_value_off_on_order'] = promocodeValueOffOnOrder;
    _data['used_pincode'] = usedPincode;
    _data['pincode_delivery_charge'] = pincodeDeliveryCharge;
    _data['total_price'] = totalPrice;
    _data['total_paid_price'] = totalPaidPrice;
    _data['status'] = status;
    _data['order_date'] = orderDate;
    _data['order_time'] = orderTime;
    _data['product_details'] = productDetails.map((e)=>e.toJson()).toList();
    _data['get_rating_lists'] = getRatingLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ProductDetails {
  ProductDetails({
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
    required this.productFinalPrice,
  });
  late final String productOrderAutoId;
  late final String orderId;
  late final String addedById;
  late final String addedBy;
  late final String productAutoId;
  late final String productName;
  late final String productImage;
  late final String size;
  late final String quantity;
  late final String colorName;
  late final String colorImage;
  late final String orderDate;
  late final String orderStatus;
  late final String productPrice;
  late final String productOfferPercentage;
  late final String productFinalPrice;

  ProductDetails.fromJson(Map<String, dynamic> json){
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
    _data['product_final_price'] = productFinalPrice;
    return _data;
  }
}

class GetRatingLists {
  GetRatingLists({
    required this.ratingAutoId,
    required this.productAutoId,
    required this.productName,
    required this.customerAutoId,
    required this.customerName,
    required this.emailId,
    required this.mobileNumber,
    required this.rating,
    required this.review,
    required this.reviewImage,
    required this.date,
  });
  late final String ratingAutoId;
  late final String productAutoId;
  late final String productName;
  late final String customerAutoId;
  late final String customerName;
  late final String emailId;
  late final String mobileNumber;
  late final String rating;
  late final String review;
  late final String reviewImage;
  late final String date;

  GetRatingLists.fromJson(Map<String, dynamic> json){
    ratingAutoId = json['rating_auto_id'];
    productAutoId = json['product_auto_id'];
    productName = json['product_name'];
    customerAutoId = json['customer_auto_id'];
    customerName = json['customer_name'];
    emailId = json['email_id'];
    mobileNumber = json['mobile_number'];
    rating = json['rating'];
    review = json['review'];
    reviewImage = json['review_image'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['rating_auto_id'] = ratingAutoId;
    _data['product_auto_id'] = productAutoId;
    _data['product_name'] = productName;
    _data['customer_auto_id'] = customerAutoId;
    _data['customer_name'] = customerName;
    _data['email_id'] = emailId;
    _data['mobile_number'] = mobileNumber;
    _data['rating'] = rating;
    _data['review'] = review;
    _data['review_image'] = reviewImage;
    _data['date'] = date;
    return _data;
  }
}