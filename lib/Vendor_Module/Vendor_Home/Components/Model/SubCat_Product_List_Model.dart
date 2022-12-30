class SubCat_Product_List_Model {
  int? status;
  List<GetAdminSubcategoryProductLists>? getAdminSubcategoryProductLists;

  SubCat_Product_List_Model(
      {this.status, this.getAdminSubcategoryProductLists});

  SubCat_Product_List_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['get_admin_subcategory_product_lists'] != null) {
      getAdminSubcategoryProductLists = <GetAdminSubcategoryProductLists>[];
      json['get_admin_subcategory_product_lists'].forEach((v) {
        getAdminSubcategoryProductLists!
            .add(GetAdminSubcategoryProductLists.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (getAdminSubcategoryProductLists != null) {
      data['get_admin_subcategory_product_lists'] =
          getAdminSubcategoryProductLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetAdminSubcategoryProductLists {
  String? productAutoId;
  String? mainCategoryAutoId;
  String? subCategoryAutoId;
  String? userAutoId;
  String? addedBy;
  String? productDimensions;
  String? productName;
  String? highlights;
  String? description;
  String? productModelAutoId;
  String? specification;
  String? brandAutoId;
  String? newArrival;
  String? moq;
  String? grossWt;
  String? netWt;
  String? unit;
  String? quantity;
  String? weight;
  String? productPrice;
  String? offerPercentage;
  String? finalProductPrice;
  String? colorImage;
  String? colorName;
  List<ProductImages>? productImages;
  List<Size>? size;
  List<GetPriceLists>? getPriceLists;
  bool? isSelected;


  GetAdminSubcategoryProductLists(
      {this.productAutoId,
        this.mainCategoryAutoId,
        this.subCategoryAutoId,
        this.userAutoId,
        this.addedBy,
        this.productDimensions,
        this.productName,
        this.highlights,
        this.description,
        this.productModelAutoId,
        this.specification,
        this.brandAutoId,
        this.newArrival,
        this.moq,
        this.grossWt,
        this.netWt,
        this.unit,
        this.quantity,
        this.weight,
        this.productPrice,
        this.offerPercentage,
        this.finalProductPrice,
        this.colorImage,
        this.colorName,
        this.productImages,
        this.size,
        this.getPriceLists,
      this.isSelected});

  GetAdminSubcategoryProductLists.fromJson(Map<String, dynamic> json) {
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
    specification = json['specification'];
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
    finalProductPrice = json['final_product_price'];
    colorImage = json['color_image'];
    colorName = json['color_name'];
    if (json['product_images'] != null) {
      productImages = <ProductImages>[];
      json['product_images'].forEach((v) {
        productImages!.add(ProductImages.fromJson(v));
      });
    }
    if (json['size'] != null) {
      size = <Size>[];
      json['size'].forEach((v) {
        size!.add(Size.fromJson(v));
      });
    }
    if (json['get_price_lists'] != null) {
      getPriceLists = <GetPriceLists>[];
      json['get_price_lists'].forEach((v) {
        getPriceLists!.add(GetPriceLists.fromJson(v));
      });
    }
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_auto_id'] = productAutoId;
    data['main_category_auto_id'] = mainCategoryAutoId;
    data['sub_category_auto_id'] = subCategoryAutoId;
    data['user_auto_id'] = userAutoId;
    data['added_by'] = addedBy;
    data['product_dimensions'] = productDimensions;
    data['product_name'] = productName;
    data['highlights'] = highlights;
    data['description'] = description;
    data['product_model_auto_id'] = productModelAutoId;
    data['specification'] = specification;
    data['brand_auto_id'] = brandAutoId;
    data['new_arrival'] = newArrival;
    data['moq'] = moq;
    data['gross_wt'] = grossWt;
    data['net_wt'] = netWt;
    data['unit'] = unit;
    data['quantity'] = quantity;
    data['weight'] = weight;
    data['product_price'] = productPrice;
    data['offer_percentage'] = offerPercentage;
    data['final_product_price'] = finalProductPrice;
    data['color_image'] = colorImage;
    data['color_name'] = colorName;

    if (productImages != null) {
      data['product_images'] =
          productImages!.map((v) => v.toJson()).toList();
    }
    if (size != null) {
      data['size'] = size!.map((v) => v.toJson()).toList();
    }
    if (getPriceLists != null) {
      data['get_price_lists'] =
          getPriceLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductImages {
  String? imageAutoId;
  String? productImage;

  ProductImages({this.imageAutoId, this.productImage});

  ProductImages.fromJson(Map<String, dynamic> json) {
    imageAutoId = json['image_auto_id'];
    productImage = json['product_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_auto_id'] = imageAutoId;
    data['product_image'] = productImage;
    return data;
  }
}

class Size {
  String? size;

  Size({this.size});

  Size.fromJson(Map<String, dynamic> json) {
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['size'] = size;
    return data;
  }
}

class GetPriceLists {
  String? sizePrice;
  String? offerPercentage;
  String? finalSizePrice;

  GetPriceLists({this.sizePrice, this.offerPercentage, this.finalSizePrice});

  GetPriceLists.fromJson(Map<String, dynamic> json) {
    sizePrice = json['size_price'];
    offerPercentage = json['offer_percentage'];
    finalSizePrice = json['final_size_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['size_price'] = sizePrice;
    data['offer_percentage'] = offerPercentage;
    data['final_size_price'] = finalSizePrice;
    return data;
  }
}


/*
class SubCat_Product_List_Model {
  int? status;
  List<GetAdminSubcategoryProductLists>? getAdminSubcategoryProductLists;

  SubCat_Product_List_Model(
      {this.status, this.getAdminSubcategoryProductLists});

  SubCat_Product_List_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['get_admin_subcategory_product_lists'] != null) {
      getAdminSubcategoryProductLists = <GetAdminSubcategoryProductLists>[];
      json['get_admin_subcategory_product_lists'].forEach((v) {
        getAdminSubcategoryProductLists!
            .add(new GetAdminSubcategoryProductLists.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.getAdminSubcategoryProductLists != null) {
      data['get_admin_subcategory_product_lists'] =
          this.getAdminSubcategoryProductLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetAdminSubcategoryProductLists {
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
  bool? isSelected;

  GetAdminSubcategoryProductLists(
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
      this.isSelected});

  GetAdminSubcategoryProductLists.fromJson(Map<String, dynamic> json) {
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
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_auto_id'] = this.userAutoId;
    data['main_category_auto_id'] = this.mainCategoryAutoId;
    data['product_name'] = this.productName;
    data['price'] = this.price;
    data['sub_category_auto_id'] = this.subCategoryAutoId;
    data['brand_name'] = this.brandName;
    data['brand_auto_id'] = this.brandAutoId;
    data['product_unit'] = this.productUnit;
    data['product_quantity'] = this.productQuantity;
    data['gross_weight'] = this.grossWeight;
    data['net_weight'] = this.netWeight;
    data['offer_price'] = this.offerPrice;
    data['minimum_order_quantity'] = this.minimumOrderQuantity;
    data['product_colors'] = this.productColors;
    data['product_size'] = this.productSize;
    data['product_description'] = this.productDescription;
    data['product_weight'] = this.productWeight;
    data['product_dimensions'] = this.productDimensions;
    data['product_specification'] = this.productSpecification;
    data['final_price'] = this.finalPrice;
    data['product_img'] = this.productImg;
    data['register_date'] = this.registerDate;
    data['added_by'] = this.addedBy;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}*/
