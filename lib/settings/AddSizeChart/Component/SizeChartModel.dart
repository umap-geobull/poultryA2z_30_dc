class SizeChartModel {
  SizeChartModel({
    required this.status,
    required this.msg,
    required this.getalldata,
  });
  late final String status;
  late final String msg;
  late final List<GetSizeChartdata> getalldata;

  SizeChartModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getalldata = List.from(json['getalldata']).map((e)=>GetSizeChartdata.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['getalldata'] = getalldata.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetSizeChartdata {
  GetSizeChartdata({
    required this.id,
    required this.userAutoId,
    required this.addedBy,
    required this.subcategoryAutoId,
    required this.chartImage,
    required this.rdate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String userAutoId;
  late final String addedBy;
  late final String subcategoryAutoId;
  late final String chartImage;
  late final String rdate;
  late final String updatedAt;
  late final String createdAt;

  GetSizeChartdata.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    userAutoId = json['user_auto_id'];
    addedBy = json['added_by'];
    subcategoryAutoId = json['subcategory_auto_id'];
    chartImage = json['chart_image'];
    rdate = json['rdate'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['user_auto_id'] = userAutoId;
    _data['added_by'] = addedBy;
    _data['subcategory_auto_id'] = subcategoryAutoId;
    _data['chart_image'] = chartImage;
    _data['rdate'] = rdate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}