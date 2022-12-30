class GenerGreetingsModel {
  GenerGreetingsModel({
    required this.status,
    required this.allGeneralGreetings,
  });
  late final int status;
  late final List<AllGeneralGreetings> allGeneralGreetings;

  GenerGreetingsModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    allGeneralGreetings = List.from(json['all_general_greetings']).map((e)=>AllGeneralGreetings.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['all_general_greetings'] = allGeneralGreetings.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class AllGeneralGreetings {
  AllGeneralGreetings({
    required this.id,
    required this.grtImg,
    required this.name,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String grtImg;
  late final String name;
  late final String updatedAt;
  late final String createdAt;

  AllGeneralGreetings.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    grtImg = json['grt_img'];
    name = json['name'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['grt_img'] = grtImg;
    _data['name'] = name;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}