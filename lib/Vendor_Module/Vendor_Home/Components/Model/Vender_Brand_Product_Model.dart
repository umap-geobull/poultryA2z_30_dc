import 'Main_Cat_Size_Model.dart';

class Vender_Brand_Product_Model {
  int? status;
  List<GetVendorBrandProductLists>? getVendorBrandProductLists;

  Vender_Brand_Product_Model({this.status, this.getVendorBrandProductLists});

  Vender_Brand_Product_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['get_vendor_brand_product_lists'] != null) {
      getVendorBrandProductLists = <GetVendorBrandProductLists>[];
      json['get_vendor_brand_product_lists'].forEach((v) {
        getVendorBrandProductLists!
            .add(GetVendorBrandProductLists.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (getVendorBrandProductLists != null) {
      data['get_vendor_brand_product_lists'] =
          getVendorBrandProductLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetVendorBrandProductLists {
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
  String? includingTax;
  String? taxPercentage;
  String? finalProductPrice;
  String? colorImage;
  String? colorName;
  int?  avg_rating;
  List<ProductImages>? productImages;
  List<Product_Size_List_Model>? size;
  List<GetPriceLists>? getPriceLists;

  GetVendorBrandProductLists(
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
        this.includingTax,
        this.taxPercentage,
        this.finalProductPrice,
        this.colorImage,
        this.colorName,
        this.avg_rating,
        this.productImages,
        this.size,
        this.getPriceLists});

  GetVendorBrandProductLists.fromJson(Map<String, dynamic> json) {
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
    avg_rating = json['avg_rating'];
    if (json['product_images'] != null) {
      productImages = <ProductImages>[];
      json['product_images'].forEach((v) {
        productImages!.add(ProductImages.fromJson(v));
      });
    }
    if (json['size'] != null) {
      size = <Product_Size_List_Model>[];
      json['size'].forEach((v) {
        size!.add(Product_Size_List_Model.fromJson(v));
      });
    }
    if (json['get_price_lists'] != null) {
      getPriceLists = <GetPriceLists>[];
      json['get_price_lists'].forEach((v) {
        getPriceLists!.add(GetPriceLists.fromJson(v));
      });
    }
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
    data['including_tax'] = includingTax;
    data['tax_percentage'] = taxPercentage;
    data['final_product_price'] = finalProductPrice;
    data['color_image'] = colorImage;
    data['color_name'] = colorName;
    data['avg_rating'] = avg_rating;
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
  String? sId;
  String? productAutoId;
  String? imageFile;
  String? rdate;
  String? updatedAt;
  String? createdAt;

  ProductImages(
      {this.sId,
        this.productAutoId,
        this.imageFile,
        this.rdate,
        this.updatedAt,
        this.createdAt});

  ProductImages.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    productAutoId = json['product_auto_id'];
    imageFile = json['image_file'];
    rdate = json['rdate'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['product_auto_id'] = productAutoId;
    data['image_file'] = imageFile;
    data['rdate'] = rdate;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
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
