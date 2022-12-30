class HomeComponentModel {
  HomeComponentModel({
    required this.status,
    required this.msg,
    required this.getHomeComponentList,
  });
  late final int status;
  late final String msg;
  late final List<GetHomeComponentList> getHomeComponentList;

  HomeComponentModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getHomeComponentList = List.from(json['get_home_component_list']).map((e)=>GetHomeComponentList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['get_home_component_list'] = getHomeComponentList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetHomeComponentList {
  GetHomeComponentList({
    required this.id,
    required this.adminAutoId,
    required this.appTypeId,
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
    required this.webCode,
    required this.showInCategory,
    required this.showOnHome,
    required this.registerDate,
    required this.componentIndex,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String adminAutoId;
  late final String appTypeId;
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
  late final String webCode;
  late final String showInCategory;
  late final String showOnHome;
  late final String registerDate;
  late final String componentIndex;
  late final String updatedAt;
  late final String createdAt;

  GetHomeComponentList.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    adminAutoId = json['admin_auto_id'];
    appTypeId = json['app_type_id'];
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
    webCode = json['web_code'];
    showInCategory = json['show_in_category'];
    showOnHome = json['show_on_home'];
    registerDate = json['register_date'];
    componentIndex = json['component_index'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['admin_auto_id'] = adminAutoId;
    _data['app_type_id'] = appTypeId;
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
    _data['web_code'] = webCode;
    _data['show_in_category'] = showInCategory;
    _data['show_on_home'] = showOnHome;
    _data['register_date'] = registerDate;
    _data['component_index'] = componentIndex;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}