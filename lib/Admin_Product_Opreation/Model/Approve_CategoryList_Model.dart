class Approve_CategoryModel {
  Approve_CategoryModel({
    required this.status,
    required this.msg,
    required this.getVendorCategoryApprovalLists,
  });
  late final int status;
  late final String msg;
  late final List<GetVendorCategoryApprovalLists> getVendorCategoryApprovalLists;

  Approve_CategoryModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getVendorCategoryApprovalLists = List.from(json['get_vendor_category_approval_lists']).map((e)=>GetVendorCategoryApprovalLists.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['get_vendor_category_approval_lists'] = getVendorCategoryApprovalLists.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetVendorCategoryApprovalLists {
  GetVendorCategoryApprovalLists({
    required this.id,
    required this.userAutoId,
    required this.categoryName,
    required this.categoryImageApp,
    required this.categoryImageWeb,
    required this.adminApproval,
    required this.rdate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String userAutoId;
  late final String categoryName;
  late final String categoryImageApp;
  late final String categoryImageWeb;
  late final String adminApproval;
  late final String rdate;
  late final String updatedAt;
  late final String createdAt;

  GetVendorCategoryApprovalLists.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    userAutoId = json['user_auto_id'];
    categoryName = json['category_name'];
    categoryImageApp = json['category_image_app'];
    categoryImageWeb = json['category_image_web'];
    adminApproval = json['admin_approval'];
    rdate = json['rdate'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['user_auto_id'] = userAutoId;
    _data['category_name'] = categoryName;
    _data['category_image_app'] = categoryImageApp;
    _data['category_image_web'] = categoryImageWeb;
    _data['admin_approval'] = adminApproval;
    _data['rdate'] = rdate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}