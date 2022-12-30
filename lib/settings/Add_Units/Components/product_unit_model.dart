class ProductUnitModel {
  ProductUnitModel({
    required this.status,
    required this.msg,
    required this.getUnitList,
  });
  late final int status;
  late final String msg;
  late final List<GetUnitList> getUnitList;

  ProductUnitModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getUnitList = List.from(json['get_unit_list']).map((e)=>GetUnitList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['get_unit_list'] = getUnitList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetUnitList {
  GetUnitList({
    required this.id,
    required this.unit,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String unit;
  late final String updatedAt;
  late final String createdAt;

  GetUnitList.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    unit = json['unit'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['unit'] = unit;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}