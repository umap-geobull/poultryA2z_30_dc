class AboutusModel {
  AboutusModel({
    required this.status,
    required this.allabouts,
  });
  late final int status;
  late final List<Allabouts> allabouts;

  AboutusModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    allabouts = List.from(json['allabouts']).map((e)=>Allabouts.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['allabouts'] = allabouts.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Allabouts {
  Allabouts({
    required this.id,
    required this.about,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String about;
  late final String updatedAt;
  late final String createdAt;

  Allabouts.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    about = json['about'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['about'] = about;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}