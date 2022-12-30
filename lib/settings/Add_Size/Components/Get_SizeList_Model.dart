class GetSizeListModel {
  GetSizeListModel({
    required this.status,
    required this.msg,
    required this.title,
    required this.getSizeList,
  });
  late final int status;
  late final String msg;
  late final String? title;
  late final List<GetSizeList> getSizeList;

  GetSizeListModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    title=json['title'];
    getSizeList = List.from(json['get_size_list']).map((e)=>GetSizeList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['title']=title;
    _data['get_size_list'] = getSizeList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetSizeList {
  GetSizeList({
    required this.id,
    required this.size,
  });
  late final String id;
  late final String size;

  GetSizeList.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['size'] = size;
    return _data;
  }
}