class Product_Details_Model {
  int? status;
  ProductDetails? productDetails;

  Product_Details_Model({this.status, this.productDetails});

  Product_Details_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    productDetails = json['product_details'] != null
        ? ProductDetails.fromJson(json['product_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (productDetails != null) {
      data['product_details'] = productDetails!.toJson();
    }
    return data;
  }
}

class ProductDetails {
  String? sId;
  String? userAutoId;
  String? mainCategoryAutoId;
  String? productName;
  String? price;
  String? subCategoryAutoId;
  String? brandName;
  String? brandAutoId;
  String? productUnit;
  String? productQuantity;
  String? grossWeight;
  String? netWeight;
  String? offerPrice;
  String? minimumOrderQuantity;
  String? productColors;
  String? productSize;
  String? productDescription;
  String? productWeight;
  String? productDimensions;
  String? productSpecification;
  String? finalPrice;
  String? productImg;
  String? registerDate;
  String? addedBy;
  String? updatedAt;
  String? createdAt;
  String? new_arrival;

  ProductDetails(
      {this.sId,
        this.userAutoId,
        this.mainCategoryAutoId,
        this.productName,
        this.price,
        this.subCategoryAutoId,
        this.brandName,
        this.brandAutoId,
        this.productUnit,
        this.productQuantity,
        this.grossWeight,
        this.netWeight,
        this.offerPrice,
        this.minimumOrderQuantity,
        this.productColors,
        this.productSize,
        this.productDescription,
        this.productWeight,
        this.productDimensions,
        this.productSpecification,
        this.finalPrice,
        this.productImg,
        this.registerDate,
        this.addedBy,
        this.updatedAt,
        this.createdAt,
      this.new_arrival});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userAutoId = json['user_auto_id'];
    mainCategoryAutoId = json['main_category_auto_id'];
    productName = json['product_name'];
    price = json['price'];
    subCategoryAutoId = json['sub_category_auto_id'];
    brandName = json['brand_name'];
    brandAutoId = json['brand_auto_id'];
    productUnit = json['product_unit'];
    productQuantity = json['product_quantity'];
    grossWeight = json['gross_weight'];
    netWeight = json['net_weight'];
    offerPrice = json['offer_price'];
    minimumOrderQuantity = json['minimum_order_quantity'];
    productColors = json['product_colors'];
    productSize = json['product_size'];
    productDescription = json['product_description'];
    productWeight = json['product_weight'];
    productDimensions = json['product_dimensions'];
    productSpecification = json['product_specification'];
    finalPrice = json['final_price'];
    productImg = json['product_img'];
    registerDate = json['register_date'];
    addedBy = json['added_by'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    new_arrival=json['new_arrival'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_auto_id'] = userAutoId;
    data['main_category_auto_id'] = mainCategoryAutoId;
    data['product_name'] = productName;
    data['price'] = price;
    data['sub_category_auto_id'] = subCategoryAutoId;
    data['brand_name'] = brandName;
    data['brand_auto_id'] = brandAutoId;
    data['product_unit'] = productUnit;
    data['product_quantity'] = productQuantity;
    data['gross_weight'] = grossWeight;
    data['net_weight'] = netWeight;
    data['offer_price'] = offerPrice;
    data['minimum_order_quantity'] = minimumOrderQuantity;
    data['product_colors'] = productColors;
    data['product_size'] = productSize;
    data['product_description'] = productDescription;
    data['product_weight'] = productWeight;
    data['product_dimensions'] = productDimensions;
    data['product_specification'] = productSpecification;
    data['final_price'] = finalPrice;
    data['product_img'] = productImg;
    data['register_date'] = registerDate;
    data['added_by'] = addedBy;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['new_arrival'] =new_arrival;
    return data;
  }
}