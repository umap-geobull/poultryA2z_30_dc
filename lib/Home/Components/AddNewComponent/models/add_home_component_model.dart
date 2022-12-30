class AddHomeComponetModel {
  AddHomeComponetModel({
    required this.status,
    required this.data,
  });
  late final String status;
  late final Data data;

  AddHomeComponetModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.componentType,
    required this.title,
    required this.backgroundColor,
    required this.height,
    required this.iconType,
    required this.layoutType,
    required this.titleFont,
    required this.titleColor,
    required this.titleSize,
    required this.labelFont,
    required this.labelColor,
    required this.webBackgroundColor,
    required this.webHeight,
    required this.webIconType,
    required this.webLayoutType,
    required this.webTitleColor,
    required this.webTitleFont,
    required this.registerDate,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });
  late final String componentType;
  late final String title;
  late final String backgroundColor;
  late final String height;
  late final String iconType;
  late final String layoutType;
  late final String titleFont;
  late final String titleColor;
  late final String titleSize;
  late final String labelFont;
  late final String labelColor;
  late final String webBackgroundColor;
  late final String webHeight;
  late final String webIconType;
  late final String webLayoutType;
  late final String webTitleColor;
  late final String webTitleFont;
  late final String registerDate;
  late final String updatedAt;
  late final String createdAt;
  late final String id;

  Data.fromJson(Map<String, dynamic> json){
    componentType = json['component_type'];
    title = json['title'];
    backgroundColor = json['background_color'];
    height = json['height'];
    iconType = json['icon_type'];
    layoutType = json['layout_type'];
    titleFont = json['title_font'];
    titleColor = json['title_color'];
    titleSize = json['title_size'];
    labelFont = json['label_font'];
    labelColor = json['label_color'];
    webBackgroundColor = json['web_background_color'];
    webHeight = json['web_height'];
    webIconType = json['web_icon_type'];
    webLayoutType = json['web_layout_type'];
    webTitleColor = json['web_title_color'];
    webTitleFont = json['web_title_font'];
    registerDate = json['register_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['component_type'] = componentType;
    _data['title'] = title;
    _data['background_color'] = backgroundColor;
    _data['height'] = height;
    _data['icon_type'] = iconType;
    _data['layout_type'] = layoutType;
    _data['title_font'] = titleFont;
    _data['title_color'] = titleColor;
    _data['title_size'] = titleSize;
    _data['label_font'] = labelFont;
    _data['label_color'] = labelColor;
    _data['web_background_color'] = webBackgroundColor;
    _data['web_height'] = webHeight;
    _data['web_icon_type'] = webIconType;
    _data['web_layout_type'] = webLayoutType;
    _data['web_title_color'] = webTitleColor;
    _data['web_title_font'] = webTitleFont;
    _data['register_date'] = registerDate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['_id'] = id;
    return _data;
  }
}