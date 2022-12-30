import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';

class WishlistModel {
  WishlistModel({
    required this.status,
    required this.getAdminWishlistProductLists,
  });
  late final int status;
  late final List<ProductModel> getAdminWishlistProductLists;

  WishlistModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    getAdminWishlistProductLists = List.from(json['get_admin_wishlist_product_lists']).map((e)=>ProductModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['get_admin_wishlist_product_lists'] = getAdminWishlistProductLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetAdminWishlistProductLists {
  GetAdminWishlistProductLists({
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
    required this.specification,
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
    required this.productImages,
    required this.size,
    required this.getPriceLists,
  });
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
  late final String specification;
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
  late final List<ProductImages> productImages;
  late final List<Size> size;
  late final List<dynamic> getPriceLists;

  GetAdminWishlistProductLists.fromJson(Map<String, dynamic> json){
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
    includingTax = json['including_tax'];
    taxPercentage = json['tax_percentage'];
    finalProductPrice = json['final_product_price'];
    colorImage = json['color_image'];
    colorName = json['color_name'];
    productImages = List.from(json['product_images']).map((e)=>ProductImages.fromJson(e)).toList();
    size = List.from(json['size']).map((e)=>Size.fromJson(e)).toList();
    getPriceLists = List.castFrom<dynamic, dynamic>(json['get_price_lists']);
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
    _data['specification'] = specification;
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
    _data['product_images'] = productImages.map((e)=>e.toJson()).toList();
    _data['size'] = size.map((e)=>e.toJson()).toList();
    _data['get_price_lists'] = getPriceLists;
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