class ResultModel {
  ResultModel({
    required this.data,
  });
  late final Data data;

  ResultModel.fromJson(Map<String, dynamic> json){
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.resultB64,
    required this.foregroundTop,
    required this.foregroundLeft,
    required this.foregroundWidth,
    required this.foregroundHeight,
  });
  late final String resultB64;
  late final int foregroundTop;
  late final int foregroundLeft;
  late final int foregroundWidth;
  late final int foregroundHeight;

  Data.fromJson(Map<String, dynamic> json){
    resultB64 = json['result_b64'];
    foregroundTop = json['foreground_top'];
    foregroundLeft = json['foreground_left'];
    foregroundWidth = json['foreground_width'];
    foregroundHeight = json['foreground_height'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['result_b64'] = resultB64;
    _data['foreground_top'] = foregroundTop;
    _data['foreground_left'] = foregroundLeft;
    _data['foreground_width'] = foregroundWidth;
    _data['foreground_height'] = foregroundHeight;
    return _data;
  }
}