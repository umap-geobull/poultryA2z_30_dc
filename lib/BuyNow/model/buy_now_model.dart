class BuyNowModel {
  BuyNowModel({
    required this.status,
    required this.appliedPromocode,
    required this.promocodeValueOff,
    required this.promocodeType,
    required this.promocodeValueOffOnOrder,
    required this.usedPincode,
    required this.pincodeDeliveryCharge,
    required this.expressDeliveryCharge,
    required this.totalPrice,
    required this.totalPaidPrice,
    required this.getAdminCartProductLists,
  });
  late final int status;
  late final String appliedPromocode;
  late final String promocodeValueOff;
  late final String promocodeType;
  late final String promocodeValueOffOnOrder;
  late final String usedPincode;
  late final String pincodeDeliveryCharge;
  late final String expressDeliveryCharge;
  late final String totalPrice;
  late final String totalPaidPrice;
  late final List<GetAdminCartProductLists> getAdminCartProductLists;

  BuyNowModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    appliedPromocode = json['applied_promocode'];
    promocodeValueOff = json['promocode_value_off'];
    promocodeType = json['promocode_type'];
    promocodeValueOffOnOrder = json['promocode_value_off_on_order'];
    usedPincode = json['used_pincode'];
    pincodeDeliveryCharge = json['pincode_delivery_charge'];
    expressDeliveryCharge = json['express_delivery_charge'];
    totalPrice = json['total_price'];
    totalPaidPrice = json['total_paid_price'];
    getAdminCartProductLists = List.from(json['get_admin_cart_product_lists']).map((e)=>GetAdminCartProductLists.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['applied_promocode'] = appliedPromocode;
    _data['promocode_value_off'] = promocodeValueOff;
    _data['promocode_type'] = promocodeType;
    _data['promocode_value_off_on_order'] = promocodeValueOffOnOrder;
    _data['used_pincode'] = usedPincode;
    _data['pincode_delivery_charge'] = pincodeDeliveryCharge;
    _data['express_delivery_charge'] = expressDeliveryCharge;
    _data['total_price'] = totalPrice;
    _data['total_paid_price'] = totalPaidPrice;
    _data['get_admin_cart_product_lists'] = getAdminCartProductLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetAdminCartProductLists {
  GetAdminCartProductLists({
    required this.cartProductAutoId,
    required this.productAutoId,
    required this.mainCategoryAutoId,
    required this.subCategoryAutoId,
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
    required this.isReturn,
    required this.isExchange,
    required this.days,
    required this.time,
    required this.timeUnit,
    required this.useBy,
    required this.closureType,
    required this.fabric,
    required this.sole,
    required this.currency,
    required this.cartQuantity,
    required this.weight,
    required this.originalProductPrice,
    required this.productPrice,
    required this.productOfferPercentage,
    required this.includingTax,
    required this.offerCompPriceOff,
    required this.offerCompPercentage,
    required this.taxPercentage,
    required this.finalProductPrice,
    required this.product_final_price,
    required this.colorImage,
    required this.colorName,
    required this.productImages,
    required this.size,
    required this.offerData,
    required this.getPriceLists,
  });
  late final String cartProductAutoId;
  late final String productAutoId;
  late final String mainCategoryAutoId;
  late final String subCategoryAutoId;
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
  late final String isReturn;
  late final String isExchange;
  late final String days;
  late final String time;
  late final String timeUnit;
  late final String useBy;
  late final String closureType;
  late final String fabric;
  late final String sole;
  late final String currency;
  late String cartQuantity;
  late final String weight;
  late final String originalProductPrice;
  late final String productPrice;
  late final String productOfferPercentage;
  late final String includingTax;
  late final String offerCompPriceOff;
  late final String offerCompPercentage;
  late final String taxPercentage;
  late final String finalProductPrice;
  late final String product_final_price;
  late final String colorImage;
  late final String colorName;
  late final List<ProductImages> productImages;
  late final List<Size> size;
  late final List<dynamic> offerData;
  late final List<GetPriceLists> getPriceLists;

  GetAdminCartProductLists.fromJson(Map<String, dynamic> json){
    cartProductAutoId = json['cart_product_auto_id'];
    productAutoId = json['product_auto_id'];
    mainCategoryAutoId = json['main_category_auto_id'];
    subCategoryAutoId = json['sub_category_auto_id'];
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
    isReturn = json['isReturn'];
    isExchange = json['isExchange'];
    days = json['days'];
    time = json['time'];
    timeUnit = json['time_unit'];
    useBy = json['use_by'];
    closureType = json['closure_type'];
    fabric = json['fabric'];
    sole = json['sole'];
    currency = json['currency'];
    cartQuantity = json['cart_quantity'];
    weight = json['weight'];
    originalProductPrice = json['original_product_price'];
    productPrice = json['product_price'];
    productOfferPercentage = json['product_offer_percentage'];
    includingTax = json['including_tax'];
    offerCompPriceOff = json['offer_comp_price_off'];
    offerCompPercentage = json['offer_comp_percentage'];
    taxPercentage = json['tax_percentage'];
    finalProductPrice = json['final_product_price'];
    product_final_price = json['product_final_price'];
    colorImage = json['color_image'];
    colorName = json['color_name'];
    productImages = List.from(json['product_images']).map((e)=>ProductImages.fromJson(e)).toList();
    size = List.from(json['size']).map((e)=>Size.fromJson(e)).toList();
    offerData = List.castFrom<dynamic, dynamic>(json['offer_data']);
    getPriceLists = List.from(json['get_price_lists']).map((e)=>GetPriceLists.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['cart_product_auto_id'] = cartProductAutoId;
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
    _data['isReturn'] = isReturn;
    _data['isExchange'] = isExchange;
    _data['days'] = days;
    _data['time'] = time;
    _data['time_unit'] = timeUnit;
    _data['use_by'] = useBy;
    _data['closure_type'] = closureType;
    _data['fabric'] = fabric;
    _data['sole'] = sole;
    _data['currency'] = currency;
    _data['cart_quantity'] = cartQuantity;
    _data['weight'] = weight;
    _data['original_product_price'] = originalProductPrice;
    _data['product_price'] = productPrice;
    _data['product_offer_percentage'] = productOfferPercentage;
    _data['including_tax'] = includingTax;
    _data['offer_comp_price_off'] = offerCompPriceOff;
    _data['offer_comp_percentage'] = offerCompPercentage;
    _data['tax_percentage'] = taxPercentage;
    _data['final_product_price'] = finalProductPrice;
    _data['product_final_price'] = product_final_price;
    _data['color_image'] = colorImage;
    _data['color_name'] = colorName;
    _data['product_images'] = productImages.map((e)=>e.toJson()).toList();
    _data['size'] = size.map((e)=>e.toJson()).toList();
    _data['offer_data'] = offerData;
    _data['get_price_lists'] = getPriceLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ProductImages {
  ProductImages({
    required this.id,
    required this.productAutoId,
    required this.adminAutoId,
    required this.appTypeId,
    required this.imageFile,
    required this.rdate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String productAutoId;
  late final String adminAutoId;
  late final String appTypeId;
  late final String imageFile;
  late final String rdate;
  late final String updatedAt;
  late final String createdAt;

  ProductImages.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    productAutoId = json['product_auto_id'];
    adminAutoId = json['admin_auto_id'];
    appTypeId = json['app_type_id'];
    imageFile = json['image_file'];
    rdate = json['rdate'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['product_auto_id'] = productAutoId;
    _data['admin_auto_id'] = adminAutoId;
    _data['app_type_id'] = appTypeId;
    _data['image_file'] = imageFile;
    _data['rdate'] = rdate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}

class Size {
  Size({
    required this.sizeAutoId,
    required this.sizeName,
  });
  late final String sizeAutoId;
  late final String sizeName;

  Size.fromJson(Map<String, dynamic> json){
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
    required this.offerPriceOff,
    required this.finalSizePrice,
  });
  late final String sizePrice;
  late final String offerPriceOff;
  late final String finalSizePrice;

  GetPriceLists.fromJson(Map<String, dynamic> json){
    sizePrice = json['size_price'];
    offerPriceOff = json['offer_price_off'];
    finalSizePrice = json['final_size_price'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['size_price'] = sizePrice;
    _data['offer_price_off'] = offerPriceOff;
    _data['final_size_price'] = finalSizePrice;
    return _data;
  }
}



/*
class BuyNowModel {
  BuyNowModel({
    required this.status,
    required this.appliedPromocode,
    required this.promocodeValueOff,
    required this.promocodeType,
    required this.promocodeValueOffOnOrder,
    required this.usedPincode,
    required this.pincodeDeliveryCharge,
    required this.expressDeliveryCharge,
    required this.totalPrice,
    required this.totalPaidPrice,
    required this.getAdminCartProductLists,
  });
  late final int status;
  late final String appliedPromocode;
  late final String promocodeValueOff;
  late final String promocodeType;
  late final String promocodeValueOffOnOrder;
  late final String usedPincode;
  late final String pincodeDeliveryCharge;
  late final String expressDeliveryCharge;
  late final String totalPrice;
  late final String totalPaidPrice;
  late final List<GetAdminCartProductLists> getAdminCartProductLists;

  BuyNowModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    appliedPromocode = json['applied_promocode'];
    promocodeValueOff = json['promocode_value_off'];
    promocodeType = json['promocode_type'];
    promocodeValueOffOnOrder = json['promocode_value_off_on_order'];
    usedPincode = json['used_pincode'];
    pincodeDeliveryCharge = json['pincode_delivery_charge'];
    expressDeliveryCharge = json['express_delivery_charge'];
    totalPrice = json['total_price'];
    totalPaidPrice = json['total_paid_price'];
    getAdminCartProductLists = List.from(json['get_admin_cart_product_lists']).map((e)=>GetAdminCartProductLists.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['applied_promocode'] = appliedPromocode;
    _data['promocode_value_off'] = promocodeValueOff;
    _data['promocode_type'] = promocodeType;
    _data['promocode_value_off_on_order'] = promocodeValueOffOnOrder;
    _data['used_pincode'] = usedPincode;
    _data['pincode_delivery_charge'] = pincodeDeliveryCharge;
    _data['express_delivery_charge'] = expressDeliveryCharge;
    _data['total_price'] = totalPrice;
    _data['total_paid_price'] = totalPaidPrice;
    _data['get_admin_cart_product_lists'] = getAdminCartProductLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetAdminCartProductLists {
  GetAdminCartProductLists({
    required this.cartProductAutoId,
    required this.productAutoId,
    required this.mainCategoryAutoId,
    required this.subCategoryAutoId,
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
    required this.isReturn,
    required this.isExchange,
    required this.days,
    required this.time,
    required this.timeUnit,
    required this.useBy,
    required this.closureType,
    required this.fabric,
    required this.sole,
    required this.currency,
    required this.cartQuantity,
    required this.weight,
    required this.originalProductPrice,
    required this.productPrice,
    required this.productOfferPercentage,
    required this.includingTax,
    required this.offerCompPriceOff,
    required this.offerCompPercentage,
    required this.taxPercentage,
    required this.finalProductPrice,
    required this.colorImage,
    required this.colorName,
    required this.productImages,
    required this.size,
    required this.offerData,
    required this.getPriceLists,
  });
  late final String cartProductAutoId;
  late final String productAutoId;
  late final String mainCategoryAutoId;
  late final String subCategoryAutoId;
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
  late final String isReturn;
  late final String isExchange;
  late final String days;
  late final String time;
  late final String timeUnit;
  late final String useBy;
  late final String closureType;
  late final String fabric;
  late final String sole;
  late final String currency;
  late String cartQuantity;
  late final String weight;
  late final String originalProductPrice;
  late final String productPrice;
  late final String productOfferPercentage;
  late final String includingTax;
  late final String offerCompPriceOff;
  late final String offerCompPercentage;
  late final String taxPercentage;
  late final String finalProductPrice;
  late final String colorImage;
  late final String colorName;
  late final List<ProductImages> productImages;
  late final List<Size> size;
  late final List<OfferData> offerData;
  late final List<GetPriceLists> getPriceLists;

  GetAdminCartProductLists.fromJson(Map<String, dynamic> json){
    cartProductAutoId = json['cart_product_auto_id'];
    productAutoId = json['product_auto_id'];
    mainCategoryAutoId = json['main_category_auto_id'];
    subCategoryAutoId = json['sub_category_auto_id'];
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
    isReturn = json['isReturn'];
    isExchange = json['isExchange'];
    days = json['days'];
    time = json['time'];
    timeUnit = json['time_unit'];
    useBy = json['use_by'];
    closureType = json['closure_type'];
    fabric = json['fabric'];
    sole = json['sole'];
    currency = json['currency'];
    cartQuantity = json['cart_quantity'];
    weight = json['weight'];
    originalProductPrice = json['original_product_price'];
    productPrice = json['product_price'];
    productOfferPercentage = json['product_offer_percentage'];
    includingTax = json['including_tax'];
    offerCompPriceOff = json['offer_comp_price_off'];
    offerCompPercentage = json['offer_comp_percentage'];
    taxPercentage = json['tax_percentage'];
    finalProductPrice = json['final_product_price'];
    colorImage = json['color_image'];
    colorName = json['color_name'];
    productImages = List.from(json['product_images']).map((e)=>ProductImages.fromJson(e)).toList();
    size = List.from(json['size']).map((e)=>Size.fromJson(e)).toList();
    offerData = List.from(json['offer_data']).map((e)=>OfferData.fromJson(e)).toList();
    getPriceLists = List.from(json['get_price_lists']).map((e)=>GetPriceLists.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['cart_product_auto_id'] = cartProductAutoId;
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
    _data['isReturn'] = isReturn;
    _data['isExchange'] = isExchange;
    _data['days'] = days;
    _data['time'] = time;
    _data['time_unit'] = timeUnit;
    _data['use_by'] = useBy;
    _data['closure_type'] = closureType;
    _data['fabric'] = fabric;
    _data['sole'] = sole;
    _data['currency'] = currency;
    _data['cart_quantity'] = cartQuantity;
    _data['weight'] = weight;
    _data['original_product_price'] = originalProductPrice;
    _data['product_price'] = productPrice;
    _data['product_offer_percentage'] = productOfferPercentage;
    _data['including_tax'] = includingTax;
    _data['offer_comp_price_off'] = offerCompPriceOff;
    _data['offer_comp_percentage'] = offerCompPercentage;
    _data['tax_percentage'] = taxPercentage;
    _data['final_product_price'] = finalProductPrice;
    _data['color_image'] = colorImage;
    _data['color_name'] = colorName;
    _data['product_images'] = productImages.map((e)=>e.toJson()).toList();
    _data['size'] = size.map((e)=>e.toJson()).toList();
    _data['offer_data'] = offerData.map((e)=>e.toJson()).toList();
    _data['get_price_lists'] = getPriceLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ProductImages {
  ProductImages({
    required this.id,
    required this.productAutoId,
    required this.imageFile,
    required this.rdate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String productAutoId;
  late final String imageFile;
  late final String rdate;
  late final String updatedAt;
  late final String createdAt;

  ProductImages.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    productAutoId = json['product_auto_id'];
    imageFile = json['image_file'];
    rdate = json['rdate'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['product_auto_id'] = productAutoId;
    _data['image_file'] = imageFile;
    _data['rdate'] = rdate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}

class Size {
  Size({
    required this.sizeAutoId,
    required this.sizeName,
  });
  late final String sizeAutoId;
  late final String sizeName;

  Size.fromJson(Map<String, dynamic> json){
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

class OfferData {
  OfferData({
    required this.offerAutoId,
    required this.homecomponentAutoId,
    required this.componentImage,
    required this.mainCategory,
    required this.subcategory,
    required this.brand,
    required this.price,
    required this.offer,
    required this.rdate,
  });
  late final String offerAutoId;
  late final String homecomponentAutoId;
  late final String componentImage;
  late final String mainCategory;
  late final String subcategory;
  late final String brand;
  late final String price;
  late final String offer;
  late final String rdate;

  OfferData.fromJson(Map<String, dynamic> json){
    offerAutoId = json['offer_auto_id'];
    homecomponentAutoId = json['homecomponent_auto_id'];
    componentImage = json['component_image'];
    mainCategory = json['main_category'];
    subcategory = json['subcategory'];
    brand = json['brand'];
    price = json['price'];
    offer = json['offer'];
    rdate = json['rdate'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['offer_auto_id'] = offerAutoId;
    _data['homecomponent_auto_id'] = homecomponentAutoId;
    _data['component_image'] = componentImage;
    _data['main_category'] = mainCategory;
    _data['subcategory'] = subcategory;
    _data['brand'] = brand;
    _data['price'] = price;
    _data['offer'] = offer;
    _data['rdate'] = rdate;
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
   // offerPercentage = json['offer_percentage'];
    offerPercentage = json['product_offer_percentage'];
    finalSizePrice = json['final_size_price'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['size_price'] = sizePrice;
    _data['product_offer_percentage'] = offerPercentage;
    //_data['offer_percentage'] = offerPercentage;
    _data['final_size_price'] = finalSizePrice;
    return _data;
  }
}*/
