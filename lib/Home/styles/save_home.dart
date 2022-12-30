
import 'package:shared_preferences/shared_preferences.dart';

class HomeStyle{

  static Future<String?> get() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId= preferences.getString("user_id");
    return userId;
  }

}
