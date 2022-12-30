class Coupen_Code_Info_Model {
  int? status;
  String? msg;
  List<CuponcodeList>? cuponcodeList;

  Coupen_Code_Info_Model({this.status, this.msg, this.cuponcodeList});

  Coupen_Code_Info_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['cuponcode_list'] != null) {
      cuponcodeList = <CuponcodeList>[];
      json['cuponcode_list'].forEach((v) {
        cuponcodeList!.add(CuponcodeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    if (cuponcodeList != null) {
      data['cuponcode_list'] =
          cuponcodeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CuponcodeList {
  String? sId;
  String? userAutoId;
  String? type;
  String? coupenCode;
  String? coupenCodeValue;
  String? coupenCodeDesc;
  String? startDate;
  String? endDate;
  String? registerDate;
  String? updatedAt;
  String? createdAt;

  CuponcodeList(
      {this.sId,
        this.userAutoId,
        this.type,
        this.coupenCode,
        this.coupenCodeValue,
        this.coupenCodeDesc,
        this.startDate,
        this.endDate,
        this.registerDate,
        this.updatedAt,
        this.createdAt});

  CuponcodeList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userAutoId = json['user_auto_id'];
    type = json['type'];
    coupenCode = json['coupen_code'];
    coupenCodeValue = json['coupen_code_value'];
    coupenCodeDesc = json['coupen_code_desc'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    registerDate = json['register_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_auto_id'] = userAutoId;
    data['type'] = type;
    data['coupen_code'] = coupenCode;
    data['coupen_code_value'] = coupenCodeValue;
    data['coupen_code_desc'] = coupenCodeDesc;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['register_date'] = registerDate;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}