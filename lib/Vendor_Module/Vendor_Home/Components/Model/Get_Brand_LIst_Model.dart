class Brand_Model {
  int? status;
  List<GetVendorBrandLists>? getVendorBrandLists;

  Brand_Model({this.status, this.getVendorBrandLists});

  Brand_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['get_vendor_brand_lists'] != null) {
      getVendorBrandLists = <GetVendorBrandLists>[];
      json['get_vendor_brand_lists'].forEach((v) {
        getVendorBrandLists!.add(GetVendorBrandLists.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (getVendorBrandLists != null) {
      data['get_vendor_brand_lists'] =
          getVendorBrandLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetVendorBrandLists {
  String? brandAutoId;
  String? brandName;
  String? brandImageApp;
  String? brandImageWeb;

  GetVendorBrandLists(
      {this.brandAutoId,
        this.brandName,
        this.brandImageApp,
        this.brandImageWeb});

  GetVendorBrandLists.fromJson(Map<String, dynamic> json) {
    brandAutoId = json['brand_auto_id'];
    brandName = json['brand_name'];
    brandImageApp = json['brand_image_app'];
    brandImageWeb = json['brand_image_web'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brand_auto_id'] = brandAutoId;
    data['brand_name'] = brandName;
    data['brand_image_app'] = brandImageApp;
    data['brand_image_web'] = brandImageWeb;
    return data;
  }
}