class Approve_BrandModel {
  Approve_BrandModel({
    required this.status,
    required this.msg,
    required this.getVendorBrandApprovalLists,
  });
  late final int status;
  late final String msg;
  late final List<GetVendorBrandApprovalLists> getVendorBrandApprovalLists;

  Approve_BrandModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getVendorBrandApprovalLists = List.from(json['get_vendor_brand_approval_lists']).map((e)=>GetVendorBrandApprovalLists.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['get_vendor_brand_approval_lists'] = getVendorBrandApprovalLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetVendorBrandApprovalLists {
  GetVendorBrandApprovalLists({
    required this.id,
    required this.userAutoId,
    required this.brandName,
    required this.brandImageWeb,
    required this.brandImageApp,
    required this.rdate,
    required this.adminApproval,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String userAutoId;
  late final String brandName;
  late final String brandImageWeb;
  late final String brandImageApp;
  late final String rdate;
  late final String adminApproval;
  late final String updatedAt;
  late final String createdAt;

  GetVendorBrandApprovalLists.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    userAutoId = json['user_auto_id'];
    brandName = json['brand_name'];
    brandImageWeb = json['brand_image_web'];
    brandImageApp = json['brand_image_app'];
    rdate = json['rdate'];
    adminApproval = json['admin_approval'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['user_auto_id'] = userAutoId;
    _data['brand_name'] = brandName;
    _data['brand_image_web'] = brandImageWeb;
    _data['brand_image_app'] = brandImageApp;
    _data['rdate'] = rdate;
    _data['admin_approval'] = adminApproval;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}