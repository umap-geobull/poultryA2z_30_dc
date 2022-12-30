class FilterMenuModel {
  FilterMenuModel({
    required this.status,
    required this.msg,
    required this.allfiltermenus,
  });
  late final int status;
  late final String msg;
  late final String? id;
  late final List<Allfiltermenus> allfiltermenus;

  FilterMenuModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    id=json['filter_auto_id'];
    allfiltermenus = List.from(json['allfiltermenus']).map((e)=>Allfiltermenus.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['filter_auto_id']=id;
    _data['allfiltermenus'] = allfiltermenus.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Allfiltermenus {
  Allfiltermenus({
    required this.filterMenuName,
  });
  late final String filterMenuName;

  Allfiltermenus.fromJson(Map<String, dynamic> json){
    filterMenuName = json['filter_menu_name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['filter_menu_name'] = filterMenuName;
    return _data;
  }
}