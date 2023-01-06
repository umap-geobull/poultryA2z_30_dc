class VendorCatagories {
  VendorCatagories({
    required this.status,
    required this.data,
  });
  late final int status;
  late final List<VendorData> data;

  VendorCatagories.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = List.from(json['data']).map((e)=>VendorData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class VendorData {
  VendorData({
    required this.id,
    required this.categoryName,
    required this.adminAutoId,
    required this.categoryImageApp,
    required this.categoryImageWeb,
    required this.registerDate,
    required this.appTypeId,
    required this.fields,
  });
  late final String id;
  late final String categoryName;
  late final String adminAutoId;
  late final String categoryImageApp;
  late final String categoryImageWeb;
  late final String registerDate;
  late final String appTypeId;
  late final List<Fields> fields;

  VendorData.fromJson(Map<String, dynamic> json){
    id = json['_id']!= null ?json['_id']:'';
    categoryName = json['category_name'];
    adminAutoId = json['admin_auto_id'] != null ?json['admin_auto_id']:'';
    categoryImageApp = json['category_image_app'];
    categoryImageWeb = json['category_image_web'];
    registerDate = json['register_date'];
    appTypeId = json['app_type_id']!= null ?json['app_type_id']:'';
    fields = List.from(json['fields']).map((e)=>Fields.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['category_name'] = categoryName;
    _data['admin_auto_id'] = adminAutoId;
    _data['category_image_app'] = categoryImageApp;
    _data['category_image_web'] = categoryImageWeb;
    _data['register_date'] = registerDate;
    _data['app_type_id'] = appTypeId;
    _data['fields'] = fields.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Fields {
  Fields({
    required this.fieldName,
    required this.inputType,
    required this.required,
    required this.labels,
  });
  late final String fieldName;
  late final String inputType;
  late final String required;
  late final String labels;

  Fields.fromJson(Map<String, dynamic> json){
    fieldName = json['field_name'];
    inputType = json['input_type'];
    required = json['required'];
    labels = json['labels'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['field_name'] = fieldName;
    _data['input_type'] = inputType;
    _data['required'] = required;
    _data['labels'] = labels;
    return _data;
  }
}