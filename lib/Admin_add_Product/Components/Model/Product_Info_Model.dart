import 'dart:io';

import 'package:poultry_a2z/Admin_add_Product/Components/Model/product_color_model.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/add_price_screen.dart';
import 'package:poultry_a2z/settings/Add_Size/Components/Get_SizeList_Model.dart';

import 'all_offers_model.dart';

class Product_Info_Model{

  //String price = "";
  //String including_tax='Yes';
 // String tax_percentage='';
//  String offerPrice = "";
 // String original_price = "";
  //List<String> selectedSizePrice = [];


  String sId = "";
  String product_model_auto_id = "";
  String userAutoId = "";
  String mainCategoryAutoId= "";
  String productName = "";
  String subCategoryAutoId = "";
  String productUnit='Select Unit' ;
  String new_arrival='Select New Arrival';
  String productQuantity = "";
  String grossWeight = "";
  String netWeight = "";
  String minimumOrderQuantity = "";
  String minimumOrderPrice = "";
  List<String> selectedColor = [];
  String productWeight = "";
  String productDimensions = "";
  String productDescription = "";
  String useBy = "";
  String deliveryByTime = "";
  String deliveryByUnit = "Days";
  String brandName ='Select Brand';
  String brand_auto_id = "";
  List<File> productImages=[];
  List<GetSizeList> selectedSize = [];
  List<File> colorImage=[];
  String colorName='Select Color Name';
  String isReturn="No";
  String isExchange="No";
  String days="";
  String material='Select Material';
  String manufacturer='Select Manufacturer';
  String firmness='Select Firmness';
  String height='';
  String width='';
  String depth='';
  String trial_period='';
  String thickness='';
  String stock='';
  String available_stock='';
  String stock_alert_limit='';

  List<Offers> selectedOffer=[];

  List<GetProductsLists> productColorList=[];

  int selectedColorIndex=0;

  String productSku = '';
  List<Specification> specificationList=[];

  List<ProductPrice> productPriceList=[];

  Product_Info_Model(this.productImages);
  String issize='',iscolor='',ishighlights='',isspecification='',
      isbrand='',isnew_arrival='',ismoq='',isgross_wt='',isnet_wt='',isunit='',
      isquantity='',isuse_by='', isexpected_delivery='',isreturn_exchange='',
      isdimension='',ismanufacturers='',ismaterial='',isfirmness='',isthickness='',istrial_period='',isinventory='';
}

class Specification{
  String title;
  String value;
  Specification(this.title, this.value);
}