import 'dart:io';

import 'Brand_List_Model.dart';

class Product_Info_Model{

  String sId = "";
  String userAutoId = "";
  String mainCategoryAutoId= "";
  String productName = "";
  String price = "";
  String subCategoryAutoId = "";
  String? brandName ;
  Get_Brandslist? get_Brand_List;
  String brandAutoId = "";
  String? productUnit ;
  String? new_arrival;
  String productQuantity = "";
  String grossWeight = "";
  String netWeight = "";
  String offerPrice = "";
  String originalPrice = "";
  String minimumOrderQuantity = "";
  String minimumOrderPrice = "";
  // String productColors = "";
  List<String> selectedColor = [];
  List<String> selectedSize = [];
  //String productSize = "";
  String productDescription = "";
  String productWeight = "";
  String productDimensions = "";
  String productSpecification = "";

  File image;

  Product_Info_Model(this.image);
}