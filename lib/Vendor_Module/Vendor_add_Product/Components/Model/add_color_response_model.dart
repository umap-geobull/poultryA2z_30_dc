class AddColorResponse {
  AddColorResponse({
    required this.status,
    required this.data,
  });
  late final String status;
  late final Data data;

  AddColorResponse.fromJson(Map<String, dynamic> json){
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
    required this.userAutoId,
    required this.productModelAutoId,
    required this.mainCategoryAutoId,
    required this.subCategoryAutoId,
    required this.brandAutoId,
    required this.productName,
    required this.addedBy,
    required this.productDimensions,
    required this.highlights,
    required this.description,
    required this.specification,
    required this.newArrival,
    required this.moq,
    required this.grossWt,
    required this.netWt,
    required this.unit,
    required this.quantity,
    required this.weight,
    required this.colorImage,
    required this.colorName,
    required this.productPrice,
    required this.offerPercentage,
    required this.finalPrice,
    required this.size,
    required this.sizePrice,
    required this.registerDate,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });
  late final String userAutoId;
  late final String productModelAutoId;
  late final String mainCategoryAutoId;
  late final String subCategoryAutoId;
  late final String brandAutoId;
  late final String productName;
  late final String addedBy;
  late final String productDimensions;
  late final String highlights;
  late final String description;
  late final String specification;
  late final String newArrival;
  late final String moq;
  late final String grossWt;
  late final String netWt;
  late final String unit;
  late final String quantity;
  late final String weight;
  late final String colorImage;
  late final String colorName;
  late final String productPrice;
  late final String offerPercentage;
  late final String finalPrice;
  late final String size;
  late final String sizePrice;
  late final String registerDate;
  late final String updatedAt;
  late final String createdAt;
  late final String id;

  Data.fromJson(Map<String, dynamic> json){
    userAutoId = json['user_auto_id'];
    productModelAutoId = json['product_model_auto_id'];
    mainCategoryAutoId = json['main_category_auto_id'];
    subCategoryAutoId = json['sub_category_auto_id'];
    brandAutoId = json['brand_auto_id'];
    productName = json['product_name'];
    addedBy = json['added_by'];
    productDimensions = json['product_dimensions'];
    highlights = json['highlights'];
    description = json['description'];
    specification = json['specification'];
    newArrival = json['new_arrival'];
    moq = json['moq'];
    grossWt = json['gross_wt'];
    netWt = json['net_wt'];
    unit = json['unit'];
    quantity = json['quantity'];
    weight = json['weight'];
    colorImage = json['color_image'];
    colorName = json['color_name'];
    productPrice = json['product_price'];
    offerPercentage = json['offer_percentage'];
    finalPrice = json['final_price'];
    size = json['size'];
    sizePrice = json['size_price'];
    registerDate = json['register_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_auto_id'] = userAutoId;
    _data['product_model_auto_id'] = productModelAutoId;
    _data['main_category_auto_id'] = mainCategoryAutoId;
    _data['sub_category_auto_id'] = subCategoryAutoId;
    _data['brand_auto_id'] = brandAutoId;
    _data['product_name'] = productName;
    _data['added_by'] = addedBy;
    _data['product_dimensions'] = productDimensions;
    _data['highlights'] = highlights;
    _data['description'] = description;
    _data['specification'] = specification;
    _data['new_arrival'] = newArrival;
    _data['moq'] = moq;
    _data['gross_wt'] = grossWt;
    _data['net_wt'] = netWt;
    _data['unit'] = unit;
    _data['quantity'] = quantity;
    _data['weight'] = weight;
    _data['color_image'] = colorImage;
    _data['color_name'] = colorName;
    _data['product_price'] = productPrice;
    _data['offer_percentage'] = offerPercentage;
    _data['final_price'] = finalPrice;
    _data['size'] = size;
    _data['size_price'] = sizePrice;
    _data['register_date'] = registerDate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['_id'] = id;
    return _data;
  }
}