class ApproveProductListModel {
  ApproveProductListModel({
    required this.status,
    required this.getVendorProductApprovalLists,
  });
  late final int status;
  late final List<GetVendorProductApprovalLists> getVendorProductApprovalLists;

  ApproveProductListModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    getVendorProductApprovalLists = List.from(json['get_vendor_product_approval_lists']).map((e)=>GetVendorProductApprovalLists.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['get_vendor_product_approval_lists'] = getVendorProductApprovalLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetVendorProductApprovalLists {
  GetVendorProductApprovalLists({
    required this.productAutoId,
    required this.mainCategoryAutoId,
    this.subCategoryAutoId,
    required this.userAutoId,
    required this.addedBy,
    required this.productDimensions,
    required this.productName,
    required this.highlights,
    required this.description,
    required this.productModelAutoId,
    required this.brandAutoId,
    required this.newArrival,
    required this.moq,
    required this.grossWt,
    required this.netWt,
    required this.unit,
    required this.quantity,
    required this.weight,
    required this.productPrice,
    required this.offerPercentage,
    required this.includingTax,
    required this.taxPercentage,
    required this.finalProductPrice,
    required this.colorImage,
    required this.colorName,
    required this.totalNoOfReviews,
    required this.avgRating,
    required this.productImages,
    required this.size,
    required this.getPriceLists,
  });
  late final String productAutoId;
  late final String mainCategoryAutoId;
  late final String? subCategoryAutoId;
  late final String userAutoId;
  late final String addedBy;
  late final String productDimensions;
  late final String productName;
  late final String highlights;
  late final String description;
  late final String productModelAutoId;
  late final String brandAutoId;
  late final String newArrival;
  late final String moq;
  late final String grossWt;
  late final String netWt;
  late final String unit;
  late final String quantity;
  late final String weight;
  late final String productPrice;
  late final String offerPercentage;
  late final String includingTax;
  late final String taxPercentage;
  late final String finalProductPrice;
  late final String colorImage;
  late final String colorName;
  late final int totalNoOfReviews;
  late final int avgRating;
  late final List<ProductImages> productImages;
  late final List<ProSize> size;
  late final List<GetPriceLists> getPriceLists;

  GetVendorProductApprovalLists.fromJson(Map<String, dynamic> json){
    productAutoId = json['product_auto_id'];
    mainCategoryAutoId = json['main_category_auto_id'];
    subCategoryAutoId = null;
    userAutoId = json['user_auto_id'];
    addedBy = json['added_by'];
    productDimensions = json['product_dimensions'];
    productName = json['product_name'];
    highlights = json['highlights'];
    description = json['description'];
    productModelAutoId = json['product_model_auto_id'];
    brandAutoId = json['brand_auto_id'];
    newArrival = json['new_arrival'];
    moq = json['moq'];
    grossWt = json['gross_wt'];
    netWt = json['net_wt'];
    unit = json['unit'];
    quantity = json['quantity'];
    weight = json['weight'];
    productPrice = json['product_price'];
    offerPercentage = json['offer_percentage'];
    includingTax = json['including_tax'];
    taxPercentage = json['tax_percentage'];
    finalProductPrice = json['final_product_price'];
    colorImage = json['color_image'];
    colorName = json['color_name'];
    totalNoOfReviews = json['total_no_of_reviews'];
    avgRating = json['avg_rating'];
    productImages = List.from(json['product_images']).map((e)=>ProductImages.fromJson(e)).toList();
    size = List.from(json['size']).map((e)=>ProSize.fromJson(e)).toList();
    getPriceLists = List.from(json['get_price_lists']).map((e)=>GetPriceLists.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['product_auto_id'] = productAutoId;
    _data['main_category_auto_id'] = mainCategoryAutoId;
    _data['sub_category_auto_id'] = subCategoryAutoId;
    _data['user_auto_id'] = userAutoId;
    _data['added_by'] = addedBy;
    _data['product_dimensions'] = productDimensions;
    _data['product_name'] = productName;
    _data['highlights'] = highlights;
    _data['description'] = description;
    _data['product_model_auto_id'] = productModelAutoId;
    _data['brand_auto_id'] = brandAutoId;
    _data['new_arrival'] = newArrival;
    _data['moq'] = moq;
    _data['gross_wt'] = grossWt;
    _data['net_wt'] = netWt;
    _data['unit'] = unit;
    _data['quantity'] = quantity;
    _data['weight'] = weight;
    _data['product_price'] = productPrice;
    _data['offer_percentage'] = offerPercentage;
    _data['including_tax'] = includingTax;
    _data['tax_percentage'] = taxPercentage;
    _data['final_product_price'] = finalProductPrice;
    _data['color_image'] = colorImage;
    _data['color_name'] = colorName;
    _data['total_no_of_reviews'] = totalNoOfReviews;
    _data['avg_rating'] = avgRating;
    _data['product_images'] = productImages.map((e)=>e.toJson()).toList();
    _data['size'] = size.map((e)=>e.toJson()).toList();
    _data['get_price_lists'] = getPriceLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ProductImages {
  ProductImages({
    required this.imageAutoId,
    required this.productImage,
  });
  late final String imageAutoId;
  late final String productImage;

  ProductImages.fromJson(Map<String, dynamic> json){
    imageAutoId = json['image_auto_id'];
    productImage = json['product_image'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['image_auto_id'] = imageAutoId;
    _data['product_image'] = productImage;
    return _data;
  }
}

class ProSize {
  ProSize({
    required this.sizeAutoId,
    required this.sizeName,
  });
  late final String sizeAutoId;
  late final String sizeName;

  ProSize.fromJson(Map<String, dynamic> json){
    sizeAutoId = json['size_auto_id'];
    sizeName = json['size_name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['size_auto_id'] = sizeAutoId;
    _data['size_name'] = sizeName;
    return _data;
  }
}

class GetPriceLists {
  GetPriceLists({
    required this.sizePrice,
    required this.offerPercentage,
    required this.finalSizePrice,
  });
  late final String sizePrice;
  late final String offerPercentage;
  late final String finalSizePrice;

  GetPriceLists.fromJson(Map<String, dynamic> json){
    sizePrice = json['size_price'];
    offerPercentage = json['offer_percentage'];
    finalSizePrice = json['final_size_price'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['size_price'] = sizePrice;
    _data['offer_percentage'] = offerPercentage;
    _data['final_size_price'] = finalSizePrice;
    return _data;
  }
}