class ColorListModel {
  ColorListModel({
    required this.status,
    required this.msg,
    required this.getColorList,
  });
  late final int status;
  late final String msg;
  late final List<GetColorList> getColorList;

  ColorListModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getColorList = List.from(json['get_color_list']).map((e)=>GetColorList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['get_color_list'] = getColorList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetColorList {
  GetColorList({
    required this.id,
  //  required this.userAutoId,
    required this.colorName,
    required this.colorImg,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
 // late final String userAutoId;
  late final String colorName;
  late final String colorImg;
  late final String updatedAt;
  late final String createdAt;

  bool isSelected=false;

  GetColorList.fromJson(Map<String, dynamic> json){
    id = json['_id'];
  //  userAutoId = json['user_auto_id'];
    colorName = json['color_name'];
    colorImg = json['color_img'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
   // _data['user_auto_id'] = userAutoId;
    _data['color_name'] = colorName;
    _data['color_img'] = colorImg;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}