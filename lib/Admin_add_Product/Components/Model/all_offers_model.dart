class AllOffers {
  AllOffers({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final int status;
  late final String msg;
  late final List<Offers> data;

  AllOffers.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>Offers.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Offers {
  Offers({
    required this.id,
    required this.homecomponentAutoId,
    required this.componentImage,
    required this.mainCategory,
    required this.subcategory,
    required this.brand,
    required this.price,
    required this.offer,
    required this.rdate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String homecomponentAutoId;
  late final String componentImage;
  late final String mainCategory;
  late final String subcategory;
  late final String brand;
  late final String price;
  late final String offer;
  late final String rdate;
  late final String updatedAt;
  late final String createdAt;

  Offers.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    homecomponentAutoId = json['homecomponent_auto_id'];
    componentImage = json['component_image'];
    mainCategory = json['main_category'];
    subcategory = json['subcategory'];
    brand = json['brand'];
    price = json['price'];
    offer = json['offer'];
    rdate = json['rdate'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['homecomponent_auto_id'] = homecomponentAutoId;
    _data['component_image'] = componentImage;
    _data['main_category'] = mainCategory;
    _data['subcategory'] = subcategory;
    _data['brand'] = brand;
    _data['price'] = price;
    _data['offer'] = offer;
    _data['rdate'] = rdate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}