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

class GetSizePriceLists {
  GetSizePriceLists({
    required this.sizePrice,
    required this.offerPercentage,
    required this.finalSizePrice,
  });
  late final String sizePrice;
  late final String offerPercentage;
  late final String finalSizePrice;

  GetSizePriceLists.fromJson(Map<String, dynamic> json){
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

class ProductImages {
  ProductImages({
    required this.imageAutoId,
    required this.imageFile,
  });
  late final String imageAutoId;
  late final String imageFile;

  ProductImages.fromJson(Map<String, dynamic> json){
    imageAutoId = json['image_auto_id'];
    imageFile = json['product_image'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['image_auto_id'] = imageAutoId;
    _data['product_image'] = imageFile;
    return _data;
  }
}