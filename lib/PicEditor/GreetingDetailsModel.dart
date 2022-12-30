class GreetingsDetailsModel {
  GreetingsDetailsModel({
    required this.status,
    required this.genetalGreetingImages,
  });
  late final int status;
  late final List<GeneralGreetingImages> genetalGreetingImages;

  GreetingsDetailsModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    genetalGreetingImages = List.from(json['genetal_greeting_images']).map((e)=>GeneralGreetingImages.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['genetal_greeting_images'] = genetalGreetingImages.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GeneralGreetingImages {
  GeneralGreetingImages({
    required this.id,
    required this.greetingId,
    required this.greetingName,
    required this.greetingImg,
    required this.xCordinate,
    required this.yCordinate,
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

  GeneralGreetingImages.fromJson(Map<String, dynamic> json){
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