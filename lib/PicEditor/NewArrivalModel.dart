class NewArrivalGreetingModel {
  NewArrivalGreetingModel({
    required this.status,
    required this.allNewArrivalGreetings,
  });
  late final int status;
  late final List<AllNewArrivalGreetings> allNewArrivalGreetings;

  NewArrivalGreetingModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    allNewArrivalGreetings = List.from(json['all_new_arrival_greetings']).map((e)=>AllNewArrivalGreetings.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['all_new_arrival_greetings'] = allNewArrivalGreetings.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class AllNewArrivalGreetings {
  AllNewArrivalGreetings({
    required this.id,
    required this.greetingId,
    required this.greetingName,
    required this.xCordinate,
    required this.yCordinate,
    required this.greetingImg,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String greetingId;
  late final String greetingName;
  late final String xCordinate;
  late final String yCordinate;
  late final String greetingImg;
  late final String status;
  late final String updatedAt;
  late final String createdAt;

  AllNewArrivalGreetings.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    greetingId = json['greeting_id'];
    greetingName = json['greeting_name'];
    xCordinate = json['x_coordinate'];
    yCordinate = json['y_coordinate'];
    greetingImg = json['greeting_img'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['greeting_id'] = greetingId;
    _data['greeting_name'] = greetingName;
    _data['x_coordinate'] = xCordinate;
    _data['y_coordinate'] = yCordinate;
    _data['greeting_img'] = greetingImg;
    _data['status'] = status;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}