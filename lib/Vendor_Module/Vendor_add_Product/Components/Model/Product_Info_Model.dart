import 'dart:io';

import 'product_color_model.dart';

import 'Get_SizeList_Model.dart';

class Product_Info_Model{

  String sId = "";
  String product_model_auto_id = "";
  String userAutoId = "";
  String mainCategoryAutoId= "";
  String productName = "";
  String price = "";
  String subCategoryAutoId = "";
 // String brandAutoId = "";
  String productUnit='Select Unit' ;
  String new_arrival='Select New Arrival';
  String including_tax='Yes';
  String tax_percentage='';
  String productQuantity = "";
  String grossWeight = "";
  String netWeight = "";
  String offerPrice = "";
  String original_price = "";
  String minimumOrderQuantity = "";
  String minimumOrderPrice = "";
  List<String> selectedColor = [];

  String productWeight = "";
  String productDimensions = "";
  String productSpecification = "";
  String productDescription = "";
  String brandName ='Select Brand';
  String brand_auto_id = "";
 // File image;

  List<File> productImages=[];

  List<GetSizeList> selectedSize = [];
  List<String> selectedSizePrice = [];
  List<File> colorImage=[];
  String colorName='Select Color Name';

  List<GetProductsLists> productColorList=[];

  int selectedColorIndex=0;

  Product_Info_Model(this.productImages);
}