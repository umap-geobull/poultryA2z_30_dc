class ProductPriceModel {
  ProductPriceModel({
    required this.status,
    required this.msg,
    required this.getCountryProductPriceList,
  });
  late final int status;
  late final String msg;
  late final List<GetCountryProductPriceList> getCountryProductPriceList;

  ProductPriceModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getCountryProductPriceList = List.from(json['get_country_product_price_list']).map((e)=>GetCountryProductPriceList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['get_country_product_price_list'] = getCountryProductPriceList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetCountryProductPriceList {
  GetCountryProductPriceList({
    required this.countryPriceAutoId,
    required this.userAutoId,
    required this.productAutoId,
    required this.currencyAutoId,
    required this.productPrice,
    required this.offerPercentage,
    required this.sizePrice,
    required this.includingTax,
    required this.taxPercentage,
    required this.offerData,
    required this.finalPrice,
    required this.countryName,
    required this.countryCode,
    required this.currency,
    required this.flagImage,
  });
  late final String countryPriceAutoId;
  late final String userAutoId;
  late final String productAutoId;
  late final String currencyAutoId;
  late final String productPrice;
  late final String offerPercentage;
  late final String sizePrice;
  late final String includingTax;
  late final String taxPercentage;
  late final List<OfferData> offerData;
  late final String finalPrice;
  late final String countryName;
  late final String countryCode;
  late final String currency;
  late final String flagImage;

  GetCountryProductPriceList.fromJson(Map<String, dynamic> json){
    countryPriceAutoId = json['country_price_auto_id'];
    userAutoId = json['user_auto_id'];
    productAutoId = json['product_auto_id'];
    currencyAutoId = json['currency_auto_id'];
    productPrice = json['product_price'];
    offerPercentage = json['offer_percentage'];
    sizePrice = json['size_price'];
    includingTax = json['including_tax'];
    taxPercentage = json['tax_percentage'];
    offerData = List.from(json['offer_data']).map((e)=>OfferData.fromJson(e)).toList();
    finalPrice = json['final_price'];
    countryName = json['country_name'];
    countryCode = json['country_code'];
    currency = json['currency'];
    flagImage = json['flag_image'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['country_price_auto_id'] = countryPriceAutoId;
    _data['user_auto_id'] = userAutoId;
    _data['product_auto_id'] = productAutoId;
    _data['currency_auto_id'] = currencyAutoId;
    _data['product_price'] = productPrice;
    _data['offer_percentage'] = offerPercentage;
    _data['size_price'] = sizePrice;
    _data['including_tax'] = includingTax;
    _data['tax_percentage'] = taxPercentage;
    _data['offer_data'] = offerData.map((e)=>e.toJson()).toList();
    _data['final_price'] = finalPrice;
    _data['country_name'] = countryName;
    _data['country_code'] = countryCode;
    _data['currency'] = currency;
    _data['flag_image'] = flagImage;
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