class Get_Pincode_List_Model {
  int? status;
  String? msg;
  List<GetPincodeList>? getPincodeList;

  Get_Pincode_List_Model({this.status, this.msg, this.getPincodeList});

  Get_Pincode_List_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['get_pincode_list'] != null) {
      getPincodeList = <GetPincodeList>[];
      json['get_pincode_list'].forEach((v) {
        getPincodeList!.add(GetPincodeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    if (getPincodeList != null) {
      data['get_pincode_list'] =
          getPincodeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetPincodeList {
  String? sId;
  String? pincode;
  String? userAutoId;
  String? price;
  String? updatedAt;
  String? createdAt;
  bool? isSelected;

  GetPincodeList(
      {this.sId,
        this.pincode,
        this.userAutoId,
        this.price,
        this.updatedAt,
        this.createdAt,
      this.isSelected});

  GetPincodeList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    pincode = json['pincode'];
    userAutoId = json['user_auto_id'];
    price = json['price'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['pincode'] = pincode;
    data['user_auto_id'] = userAutoId;
    data['price'] = price;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}