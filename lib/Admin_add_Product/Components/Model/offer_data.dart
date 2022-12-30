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
