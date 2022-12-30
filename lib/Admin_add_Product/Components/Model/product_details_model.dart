import 'offer_data.dart';
import 'size_model.dart';

class ProductDetailsModel {
  ProductDetailsModel({
    required this.status,
    required this.msg,
    required this.getProductsDetails,
  });
  late final int status;
  late final String msg;
  late final List<GetProductsDetails> getProductsDetails;

  ProductDetailsModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getProductsDetails = List.from(json['get_products_details']).map((e)=>GetProductsDetails.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['get_products_details'] = getProductsDetails.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetProductsDetails {
  GetProductsDetails({
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
    required this.sizeChart,
    required this.totalNoOfReviews,
    required this.specificationDetails,
    required this.avgRating,
    required this.Manufacturers,
    required this.Material,
    required this.Width,
    required this.height,
    required this.depth,
    required this.Thickness,
    required this.Firmness,
    required this.Discount,
    required this.TrialPeriod,
    required this.productSku,
    required this.productImages,
    required this.size,
    required this.offerData,
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
  late final String brandAutoId;
  late final String newArrival;
  late final String moq;
  late final String grossWt;
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
  late final String sizeChart;
  late final int totalNoOfReviews;
  late final List<SpecificationDetails> specificationDetails;
  late final int avgRating;
  late final String productSku;
  late final String Manufacturers;
  late final String Material;
  late final String Width;
  late final String height;
  late final String depth;
  late final String Thickness;
  late final String Firmness;
  late final String Discount;
  late final String TrialPeriod;
  late final String stock;
  late final String availableStock;
  late final String stockAlertLimit;


  late final List<ProductImages> productImages;
  late final List<ProdSize> size;
  late final List<OfferData> offerData;
  late final List<GetSizePriceLists> getPriceLists;

  String issize='',iscolor='',ishighlights='',isspecification='',
      isbrand='',isnew_arrival='',ismoq='',isgross_wt='',isnet_wt='',isunit='',
      isquantity='',isuse_by='', isexpected_delivery='',isreturn_exchange='',
      isdimension='',ismanufacturers='',ismaterial='',isfirmness='',isthickness='',istrial_period='',isinventory='', isSku='';

  GetProductsDetails.fromJson(Map<String, dynamic> json){
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
    sizeChart = json['size_chart'];
    totalNoOfReviews = json['total_no_of_reviews'];
    specificationDetails = List.from(json['specification_details']).map((e)=>SpecificationDetails.fromJson(e)).toList();
    avgRating = json['avg_rating'];
    Manufacturers = json['Manufacturers'];
    Material = json['Material'];
    Width = json['Width'];
    height = json['height'];
    depth = json['depth'];
    Thickness = json['Thickness'];
    Firmness = json['Firmness'];
    Discount = json['Discount'];
    TrialPeriod = json['Trial_Period'];
    productSku = json['product_sku'];
    stock = json['stock'];
    availableStock = json['available_stock'];
    stockAlertLimit = json['Stock_alert_limit'];
    productImages = List.from(json['product_images']).map((e)=>ProductImages.fromJson(e)).toList();
    size = List.from(json['size']).map((e)=>ProdSize.fromJson(e)).toList();
    offerData = List.from(json['offer_data']).map((e)=>OfferData.fromJson(e)).toList();
    getPriceLists = List.from(json['get_price_lists']).map((e)=>GetSizePriceLists.fromJson(e)).toList();

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
    _data['size_chart'] = sizeChart;
    _data['total_no_of_reviews'] = totalNoOfReviews;
    _data['specification_details'] = specificationDetails.map((e)=>e.toJson()).toList();
    _data['avg_rating'] = avgRating;
    _data['Manufacturers'] = Manufacturers;
    _data['Material'] = Material;
    _data['Width'] = Width;
    _data['height'] = height;
    _data['depth'] = depth;
    _data['Thickness'] = Thickness;
    _data['Firmness'] = Firmness;
    _data['Discount'] = Discount;
    _data['Trial_Period'] = TrialPeriod;
    _data['product_sku'] = productSku;

    _data['stock'] = stock;
    _data['available_stock'] = availableStock;
    _data['Stock_alert_limit'] = stockAlertLimit;

    _data['product_images'] = productImages.map((e)=>e.toJson()).toList();
    _data['size'] = size.map((e)=>e.toJson()).toList();
    _data['offer_data'] = offerData.map((e)=>e.toJson()).toList();
    _data['get_price_lists'] = getPriceLists.map((e)=>e.toJson()).toList();


    return _data;
  }
}

class SpecificationDetails {
  SpecificationDetails({
    required this.title,
    required this.description,
  });
  late final String title;
  late final String description;

  SpecificationDetails.fromJson(Map<String, dynamic> json){
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['description'] = description;
    return _data;
  }
}



