class AppUiModel {
  AppUiModel({
    required this.status,
    required this.msg,
    required this.allAppUiStyle,
  });
  late final int status;
  late final String msg;
  late final List<AllAppUiStyle>? allAppUiStyle;

  AppUiModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    allAppUiStyle = List.from(json['all_app_ui_style']).map((e)=>AllAppUiStyle.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['all_app_ui_style'] = allAppUiStyle!.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class AllAppUiStyle {
  AllAppUiStyle({
    required this.id,
    required this.appbarColor,
    required this.appbarIconColor,
    required this.bottomBarColor,
    required this.bottomBarIconColor,
    required this.addToCartButtonColor,
    required this.loginRegisterButtonColor,
    required this.buyNowBottonColor,
    required this.appFont,
    required this.showLocationOnHomescreen,
    required this.updatedAt,
    required this.createdAt,
    required this.productLayoutType,
  });
  late final String id;
  late final String appbarColor;
  late final String appbarIconColor;
  late final String bottomBarColor;
  late final String bottomBarIconColor;
  late final String addToCartButtonColor;
  late final String loginRegisterButtonColor;
  late final String buyNowBottonColor;
  late final String appFont;
  late final String showLocationOnHomescreen;
  late final String updatedAt;
  late final String createdAt;
  late final String productLayoutType;

  AllAppUiStyle.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    appbarColor = json['appbar_color'];
    appbarIconColor = json['appbar_icon_color'];
    bottomBarColor = json['bottom_bar_color'];
    bottomBarIconColor = json['bottom_bar_icon_color'];
    addToCartButtonColor = json['add_to_cart_button_color'];
    loginRegisterButtonColor = json['login_register_button_color'];
    buyNowBottonColor = json['buy_now_botton_color'];
    appFont = json['app_font'];
    showLocationOnHomescreen = json['show_location_on_homescreen'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    productLayoutType = json['product_layout_type'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['appbar_color'] = appbarColor;
    _data['appbar_icon_color'] = appbarIconColor;
    _data['bottom_bar_color'] = bottomBarColor;
    _data['bottom_bar_icon_color'] = bottomBarIconColor;
    _data['add_to_cart_button_color'] = addToCartButtonColor;
    _data['login_register_button_color'] = loginRegisterButtonColor;
    _data['buy_now_botton_color'] = buyNowBottonColor;
    _data['app_font'] = appFont;
    _data['show_location_on_homescreen'] = showLocationOnHomescreen;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['product_layout_type'] = productLayoutType;
    return _data;
  }
}