class MaincategoryStyle {
  MaincategoryStyle({
    required this.status,
    required this.getmain_category_style_list,
  });
  late final String status;
  late final List<MainStyle> getmain_category_style_list;

  MaincategoryStyle.fromJson(Map<String, dynamic> json){
    status = json['status'];
    getmain_category_style_list = List.from(json['getmain_category_style_list']).map((e)=>MainStyle.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['getmain_category_style_list'] = getmain_category_style_list.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class MainStyle {
  MainStyle({
    required this.id,
    required this.appIconStyle,
    required this.appLabelFont,
    required this.appLabelColor,
    required this.webIconStyle,
    required this.webLabelFont,
    required this.webLabelColor,
    required this.registerDate,
    required this.updatedAt,
    required this.createdAt,
  });

  late final String id;
  late final String appIconStyle;
  late final String appLabelFont;
  late final String appLabelColor;
  late final String webIconStyle;
  late final String webLabelFont;
  late final String webLabelColor;
  late final String registerDate;
  late final String updatedAt;
  late final String createdAt;

  MainStyle.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    appIconStyle = json['app_icon_style'];
    appLabelFont = json['app_label_font'];
    appLabelColor = json['app_label_color'];
    webIconStyle = json['web_icon_style'];
    webLabelFont = json['web_label_font'];
    webLabelColor = json['web_label_color'];
    registerDate = json['register_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['app_icon_style'] = appIconStyle;
    _data['app_label_font'] = appLabelFont;
    _data['app_label_color'] = appLabelColor;
    _data['web_icon_style'] = webIconStyle;
    _data['web_label_font'] = webLabelFont;
    _data['web_label_color'] = webLabelColor;
    _data['register_date'] = registerDate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}

/*
class MainCategoryStyle{

  saveIconType(int iconType) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(MAIN_CAT_ICON_STYLE,iconType);
  }

  saveFont(String font) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(MAIN_CAT_FONT,font);
  }

  saveSize(double size) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setDouble(MAIN_CAT_SIZE,size);
  }

  saveColor(String color) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(MAIN_CAT_COLOR,color);
  }

  static Future<int?> getIconType() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? value= preferences.getInt(MAIN_CAT_ICON_STYLE);
    return value;
  }

  static Future<String?> getFontStyle() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? value= preferences.getString(MAIN_CAT_FONT);
    return value;
  }

  static Future<double?> getSize() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    double? value= preferences.getDouble(MAIN_CAT_SIZE);
    return value;
  }

  static Future<String?> getColor() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? value= preferences.getString(MAIN_CAT_COLOR);
    return value;
  }


}
*/
