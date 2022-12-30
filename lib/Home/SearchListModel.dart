class SearchListModel {
  SearchListModel({
    required this.status,
    required this.msg,
    required this.allsearchlist,
  });
  late final int status;
  late final String msg;
  late final List<Allsearchlist> allsearchlist;

  SearchListModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    allsearchlist = List.from(json['allsearchlist']).map((e)=>Allsearchlist.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['allsearchlist'] = allsearchlist.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Allsearchlist {
  Allsearchlist({
    required this.title,
    required this.id,
    required this.type,
  });
  late final String title;
  late final String id;
  late final String type;

  Allsearchlist.fromJson(Map<String, dynamic> json){
    title = json['title'];
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['id'] = id;
    _data['type'] = type;
    return _data;
  }
}