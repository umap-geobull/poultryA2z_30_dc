import 'dart:convert';
import 'package:async/async.dart';
import '../../../Vendor_Home/Utils/App_Apis.dart';
import 'product_color_model.dart';
import 'package:http/http.dart' as http;
import 'Product_Details_Model.dart';
import 'Product_Info_Model.dart';

class Rest_Apis {
  Future<Product_Details_Model?> getProduct_Info(
      String productId, String baseUrl) async {
    print("product_auto_id=>" + productId);
    final body = {
      "product_auto_id": productId,
    };

    var url = baseUrl + 'api/' + edit_product;

    Product_Details_Model? productDetailsModel;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int status = resp['status'];

    if (response.statusCode == 200) {
      productDetailsModel =
          Product_Details_Model.fromJson(json.decode(response.body));
    } else {
      productDetailsModel = null;
    }

    return productDetailsModel;
  }

  Future<ProductColorModel?> getProductColors(
      String baseUrl, String productModelAutoId) async {
    print("product_model_auto_id=>" + productModelAutoId);

    final body = {
      "product_model_auto_id": productModelAutoId,
    };

    var url = baseUrl + 'api/' + get_vendor_product_colors;

    ProductColorModel? productColorModel;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    final resp = jsonDecode(response.body);
    int status = resp['status'];

    if (response.statusCode == 200) {
      productColorModel =
          ProductColorModel.fromJson(json.decode(response.body));
    } else {
      productColorModel = null;
    }

    return productColorModel;
  }

  Future<String?> add_product(
      String baseUrl,
      String userId,
      String mainCatId,
      String subCatId,
      Product_Info_Model productInfoModel,
      String selectedSize,
      String selectedSizePrice) async {
    // var url = baseUrl +'api/'+ add_new_product_admin;
    var url = baseUrl + 'api/add_new_product';

    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);

    //product image
    if (productInfoModel.productImages.isNotEmpty) {
      var imageStream = http.ByteStream(DelegatingStream.typed(
          productInfoModel.productImages[0].openRead()));
      var imageLength = await productInfoModel.productImages[0].length();
      print("img_signature_stream=>" + imageStream.toString());

      var signatureFile = http.MultipartFile(
          'product_images', imageStream, imageLength,
          filename: productInfoModel.productName + ".jpg");
      request.files.add(signatureFile);
    } else {
      print("img_signature_stream=>" +
          productInfoModel.productImages[0].toString());
    }

    //color image
    if (productInfoModel.colorImage.isNotEmpty) {
      var imageStream = http.ByteStream(
          DelegatingStream.typed(productInfoModel.colorImage[0].openRead()));
      var imageLength = await productInfoModel.colorImage[0].length();
      print("color image string=>" + imageStream.toString());

      var colorFile = http.MultipartFile(
          'color_image', imageStream, imageLength,
          filename: productInfoModel.productName +
              productInfoModel.colorName +
              ".jpg");
      request.files.add(colorFile);
    } else {
      print("color image null=>" + productInfoModel.colorImage[0].toString());
    }

    request.fields["user_auto_id"] = userId;
    request.fields["main_category_auto_id"] = mainCatId;
    request.fields["sub_category_auto_id"] = subCatId;
    request.fields["product_name"] = productInfoModel.productName;
    request.fields["product_dimensions"] = productInfoModel.productDimensions;
    request.fields["added_by"] = 'Admin';
    request.fields["brand_auto_id"] = productInfoModel.brand_auto_id;
    request.fields["color_name"] = productInfoModel.colorName;
    request.fields["new_arrival"] = productInfoModel.new_arrival;
    request.fields["unit"] = productInfoModel.productUnit;
    request.fields["gross_wt"] = productInfoModel.grossWeight;
    request.fields["net_wt"] = productInfoModel.netWeight;
    request.fields["moq"] = productInfoModel.minimumOrderQuantity;
    request.fields["quantity"] = productInfoModel.productQuantity;
    request.fields["offer_percentage"] = productInfoModel.offerPrice;
    request.fields["weight"] = productInfoModel.productWeight;
    request.fields["product_price"] = productInfoModel.price;
    request.fields["specification"] = productInfoModel.productSpecification;
    request.fields["description"] = productInfoModel.productDescription;
    request.fields["size"] = selectedSize;
    request.fields["size_price"] = selectedSizePrice;

    // final response = await request.send();

    http.Response response =
        await http.Response.fromStream(await request.send());

    String? status;
    String msg = '';
    String productAutoId = '';

    String value = '';

    print(response.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      status = resp['status'];
      if (status == "0") {
        msg = resp['msg'];
      } else if (status == "1") {
        productAutoId = resp['product_auto_id'];
        status = productAutoId;
      }
    } else {
      status = null;
    }
    return status;
  }

  Future<int?> Delete_Product(String productId, String baseUrl) async {
    print("product_auto_id=>" + productId);
    final body = {
      "product_auto_id": productId,
    };

    var url = baseUrl + 'api/' + delete_product;
    Uri uri = Uri.parse(url);
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
}
