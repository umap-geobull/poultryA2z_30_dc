
import '../../../Home/Components/AddNewComponent/models/sub_category_model.dart';
import '../Utils/App_Apis.dart';
import 'Model/Brand_List_Model.dart';
import 'Model/Get_Brand_LIst_Model.dart';
import 'Model/Get_Category_List_Model.dart';
import 'Model/Get_Vendor_Product_Model.dart';
import 'Model/MainCat_List_Model.dart';
import 'Model/SubCat_Model_List.dart';
import 'Model/SubCat_Product_List_Model.dart';
import 'Model/Vender_Brand_Product_Model.dart';
import 'Model/Vender_MainCat_Product_Model.dart';
import 'Model/Vendor_Info_Model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


class Rest_Apis{


  Future<Vendor_info_Model?> getProfile(String userId, String baseUrl) async {

    final body = {
      "user_auto_id": userId,
    };

    var url =baseUrl+'api/'+get_vendor_info;

    Vendor_info_Model? vendorInfoModel;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      vendorInfoModel =
          Vendor_info_Model.fromJson(json.decode(response.body));
    } else {
      vendorInfoModel = null;
    }

    return vendorInfoModel;
  }
  Future<int?> Delete_Product(String productId, String baseUrl) async {
    print("product_auto_id=>"+productId);
    final body = {
      "product_auto_id": productId,
    };

    var url = baseUrl+'api/' + delete_product;
    Uri uri=Uri.parse(url);
    String message;
    int? status;
    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      message = resp['msg'];
      status = resp['status'];
    } else {
      // Fluttertoast.showToast(msg: "Error while creating schedule. Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }
  Future<String?> add_BrandList(String userId, String brands, String baseUrl) async {
    final body = {
      "user_auto_id": userId,
      "brands_auto_id": brands,


    };

    var url =baseUrl+'api/'+select_vendor_brands;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    String message;
    String? status;
    print("response=>" + response.body.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      message = resp['msg'];
      status = resp['status'];
    } else {
      Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }

  // Future<String?> add_ProductList(String userId, String productList) async {
  //   final body = {
  //     "user_auto_id": userId,
  //     "product_auto_id": productList,
  //   };
  //
  //   var url =baseUrl+'api/'+select_vendor_product;
  //
  //   Uri uri=Uri.parse(url);
  //
  //   final response = await http.post(uri, body: body);
  //
  //   String message;
  //   String? status;
  //   print("response=>" + response.body.toString());
  //   if (response.statusCode == 200) {
  //     final resp = jsonDecode(response.body);
  //     message = resp['msg'];
  //     status = resp['status'];
  //   } else {
  //     Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
  //   }
  //
  //   return status;
  // }

  Future<Brand_List_Model?> getBrandList(String baseUrl) async {

    Brand_List_Model? brandListModel;
    var url = baseUrl+'api/'+ get_brand_list;
    var uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {


      final resp = jsonDecode(response.body);
      int status = resp['status'];
      if (status == 1) {
        brandListModel  = Brand_List_Model.fromJson(json.decode(response.body));


      }
    } else {
       Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
    }

    return brandListModel;
  }
  Future<MainCat_List_Model?> getCategoryList(String baseUrl) async {

    MainCat_List_Model? mainCategoryModel;

    var url = baseUrl+'api/'+ get_main_categories;
    var uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {


      final resp = jsonDecode(response.body);
      int status = resp['status'];
      if (status == 1) {
        mainCategoryModel   = MainCat_List_Model.fromJson(json.decode(response.body));



      }
      else {
        Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
      }
    }

    return mainCategoryModel;
  }

  Future<String?> add_CategoryList(String userId, String category, String baseUrl) async {
    final body = {
      "user_auto_id": userId,
      "category_auto_id": category,


    };

    var url =baseUrl+'api/'+select_vendor_categories;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    String message;
    String? status;
    print("response=>" + response.body.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      message = resp['msg'];
      status = resp['status'];
    } else {
      Fluttertoast.showToast(msg: "Error... Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }

  Future<int?> update_vendor_info(String userId, String shopName, String shopAddress, String city, String orderPrice, String orderPriceRange, String baseUrl) async {
    final body = {
      "user_auto_id": userId,
      "shop_name": shopName,
      "city": city,
      "address": shopAddress,
      "min_order_value": orderPrice,
      "price_range": orderPriceRange,

    };

    var url =baseUrl+'api/'+Update_vendor_info;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    String message;
    int? status;
    print("response=>" + response.body.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      message = resp['msg'];
      status = resp['status'];
    } else {
      // Fluttertoast.showToast(msg: "Error while creating schedule. Please try later", backgroundColor: Colors.grey,);
    }

    return status;
  }


  Future<int?> add_product(String userId, String mainCatId, File image, String productName, String price, String subCatId, String? brandName, String brandAutoId,
      String newArrival, String? productUnit, String productQuantity, String grossWeight, String netWeight, String offerPrice/*, String original_price*/, String minimumOrderQuantity,
      String productColors, String selectedSize, String productDescription, String netWeight2, String productDimensions, String productSpecification, String baseUrl)async {

    var url = baseUrl+'api/'+ add_new_product;
    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);
    var imageStream = http.ByteStream(DelegatingStream.typed(image.openRead()));
    var imageLength = await image.length();
    print("img_signature_stream=>" + imageStream.toString());

    var signatureFile = http.MultipartFile('product_img', imageStream, imageLength, filename: productName+".jpg");
    request.files.add(signatureFile);
    {
      print("img_signature_stream=>" + image.toString());
    }



    request.fields["user_auto_id"] = userId;
    request.fields["main_category_auto_id"] = mainCatId;
    request.fields["product_name"] = productName;
    request.fields["price"] = price;
    request.fields["sub_category_auto_id"] = subCatId;
    request.fields["brand_name"] = brandName!;
    request.fields["brand_auto_id"] = brandAutoId;
    request.fields["product_unit"] = productUnit!;
    request.fields["new_arrival"] = newArrival;
    request.fields["product_quantity"] = productQuantity;
    request.fields["gross_weight"] = grossWeight;
    request.fields["net_weight"] = netWeight;
    request.fields["offer_price"] = offerPrice;
 //   request.fields["final_price"] = original_price;
    request.fields["minimum_order_quantity"] = minimumOrderQuantity;
    request.fields["product_colors"] = productColors;
    request.fields["product_size"] = selectedSize;
    request.fields["product_description"] = productDescription;
    request.fields["product_weight"] = netWeight2;
    request.fields["product_dimensions"] = productDimensions;
    request.fields["product_specification"] = productSpecification;
    request.fields["added_by"] = "Vendor";
    request.fields["new_arrival"] = newArrival;


    http.Response response = await http.Response.fromStream(await request.send());

    String message;
    int? status;
    print(response);
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      message = resp['msg'];
      status = resp['status'];
    } else {
      status = null;
    }
    return status;
  }

  Future<Brand_Model?> getBrand_List(String vendorId, String baseUrl) async {
    print("vendor_id=>"+vendorId);
    final body = {
      "user_auto_id": vendorId,
    };

    var url = baseUrl+'api/'+ get_vendor_brand_list;

    Brand_Model? getVendorBrandLists;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];

    if (response.statusCode == 200) {

      getVendorBrandLists = Brand_Model.fromJson(json.decode(response.body));
    } else {
      getVendorBrandLists = null;
    }

    return getVendorBrandLists;
  }


  Future<Category_List_Model?> getCategory_List(String vendorId, String baseUrl) async {

    final body = {
      "user_auto_id": vendorId,
    };

    var url = baseUrl+'api/'+ get_vendor_category_list;

    Category_List_Model? getCategoryList;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];
    if (status== 1) {
      getCategoryList = Category_List_Model.fromJson(json.decode(response.body));
    } else {
      getCategoryList = null;
    }

    return getCategoryList;
  }


  Future<Get_Vendor_Product_Model?> getVendor_ProductList(String vendorId, String baseUrl) async {

    final body = {
      "user_auto_id": vendorId,
    };
    var url = baseUrl+'api/'+ get_vendor_product_list;
//print('base=>'+baseUrl);
    Get_Vendor_Product_Model? getVendorProductModel;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];
    if (status == 1) {
      getVendorProductModel = Get_Vendor_Product_Model.fromJson(json.decode(response.body));
    } else {
      getVendorProductModel = null;
    }

    return getVendorProductModel;
  }


  Future<SubCategoryModel?> getSubcategory(String baseUrl,String mainCatId,String admin_auto_id, String app_type_id) async {

    final body = {
      "main_category_auto_id": mainCatId,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    var url=baseUrl+'api/'+get_sub_category_list;

    SubCategoryModel? subcategoryModelList;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      subcategoryModelList = SubCategoryModel.fromJson(json.decode(response.body));
    } else {
      subcategoryModelList = null;
    }

    return subcategoryModelList;
  }

  Future<SubCat_Product_List_Model?> getSubCat_Product(String subCatId, String baseUrl) async {
    print("sub_cat_id=>"+subCatId);
    final body = {
      "sub_cat_id": subCatId,
    };

    var url = baseUrl+'api/'+ get_Admin_Subcategory_Product;

    SubCat_Product_List_Model? subCatProductListModel;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];

    if (status == 1) {

      subCatProductListModel = SubCat_Product_List_Model.fromJson(json.decode(response.body));
    } else {
      subCatProductListModel = null;
    }

    return subCatProductListModel;
  }

  Future<Vender_Cat_Product_Model?> getVender_MainCat_Product(String mainCatId, String userId, String baseUrl) async {
    print("main_cat_id=>"+mainCatId);
    final body = {
      "cat_auto_id": mainCatId,
      "user_auto_id":userId
    };

    var url = baseUrl+'api/'+ get_Vendor_MainCat_Product;

    Vender_Cat_Product_Model? venderCatProductModel;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];


    if (status == 1) {

      venderCatProductModel = Vender_Cat_Product_Model.fromJson(json.decode(response.body));
    } else {
      venderCatProductModel = null;
    }

    return venderCatProductModel;
  }

  Future<Vender_Brand_Product_Model?> getVendor_Brand_Product(String brandId, String userId, String baseUrl) async {
    print("main_cat_id=>"+brandId);
    final body = {
      "brand_auto_id": brandId,
      "user_auto_id":userId
    };

    var url = baseUrl+'api/'+ get_Vendor_Brand_Product;

    Vender_Brand_Product_Model? venderBrandProductModel;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int  status = resp['status'];
      if (status == 1) {

      venderBrandProductModel = Vender_Brand_Product_Model.fromJson(json.decode(response.body));
    } else {
      venderBrandProductModel = null;
    }

    return venderBrandProductModel;
  }

}