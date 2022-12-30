class ErrorModel {
  ErrorModel({
    required this.error,
  });
  late final Error error;

  ErrorModel.fromJson(Map<String, dynamic> json){
    error = Error.fromJson(json['error']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['error'] = error.toJson();
    return _data;
  }
}

class Error {
  Error({
    required this.code,
    required this.description,
    required this.source,
    required this.step,
    required this.reason,
  });
  late final String code;
  late final String description;
  late final String source;
  late final String step;
  late final String reason;

  Error.fromJson(Map<String, dynamic> json){
    code = json['code'];
    description = json['description'];
    source = json['source'];
    step = json['step'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['description'] = description;
    _data['source'] = source;
    _data['step'] = step;
    _data['reason'] = reason;
    return _data;
  }
}