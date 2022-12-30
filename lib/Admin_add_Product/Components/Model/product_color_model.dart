import 'package:poultry_a2z/Admin_add_Product/Components/Model/size_model.dart';

class ProductColorModel {
  ProductColorModel({
    required this.status,
    required this.msg,
    required this.getProductsLists,
  });
  late final int status;
  late final String msg;
  late final List<GetProductsLists> getProductsLists;

  ProductColorModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getProductsLists = List.from(json['get_products_lists']).map((e)=>GetProductsLists.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['get_products_lists'] = getProductsLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetProductsLists {
  GetProductsLists({
    required this.productAutoId,
    required this.productModelAutoId,
    required this.colorImage,
    required this.colorName,
    required this.getSizeLists,
    required this.getPriceLists,
    required this.productImageLists,
  });
  late final String productAutoId;
  late final String productModelAutoId;
  late final String colorImage;
  late final String colorName;
  late final List<ProdSize> getSizeLists;
  late final List<GetSizePriceLists> getPriceLists;
  late final List<ProductImages> productImageLists;

  GetProductsLists.fromJson(Map<String, dynamic> json){
    productAutoId = json['product_auto_id'];
    productModelAutoId = json['product_model_auto_id'];
    colorImage = json['color_image'];
    colorName = json['color_name'];
    getSizeLists = List.from(json['get_size_lists']).map((e)=>ProdSize.fromJson(e)).toList();
    getPriceLists = List.from(json['get_price_lists']).map((e)=>GetSizePriceLists.fromJson(e)).toList();
    productImageLists = List.from(json['product_image_lists']).map((e)=>ProductImages.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['product_auto_id'] = productAutoId;
    _data['product_model_auto_id'] = productModelAutoId;
    _data['color_image'] = colorImage;
    _data['color_name'] = colorName;
    _data['get_size_lists'] = getSizeLists.map((e)=>e.toJson()).toList();
    _data['get_price_lists'] = getPriceLists.map((e)=>e.toJson()).toList();
    _data['product_image_lists'] = productImageLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}