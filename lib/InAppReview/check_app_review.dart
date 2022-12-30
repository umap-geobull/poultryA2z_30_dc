
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:in_app_review/in_app_review.dart';


class CheckAppReview{
 static final InAppReview _inAppReview = InAppReview.instance;

 static void requestReview() {
   print('check review');
   _inAppReview.requestReview();
   saveLastReviewDate();
 }

  static checkReviewOnHome() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    int? home_length = prefs.getInt('home_list_length');

    print('home length:' + home_length.toString());

    if(home_length!=null && home_length>5){
      checkReview();
    }
  }

 static checkReview() async {
   SharedPreferences prefs= await SharedPreferences.getInstance();
   String? lastReviewDateString = prefs.getString('last_review_date');

   if(lastReviewDateString==null){
     requestReview();
   }
 }

 static saveHomeComponentSize(int size) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setInt('home_list_length', size);
  }

  static saveLastReviewDate() async{
    DateTime date = DateTime.now();
    String lastDate = dateToString(date);
    print(date.toString());
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('last_review_date', lastDate);
  }

  static DateTime stringtoDate(String dateString) {
    DateTime date= DateTime.parse(dateString);
    return date;
  }

  static String dateToString(DateTime date) {
    String formattedDate = DateFormat('dd MMMM yyyy').format(date);
    return formattedDate;
  }

 static checkDaysBetweenReview(int? home_length) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? lastReviewDateString = prefs.getString('last_review_date');

    if(lastReviewDateString!=null){

      try{
        DateTime reviewDate = stringtoDate(lastReviewDateString);

        DateTime today = DateTime.now();

        if(reviewDate!=null && today !=null ){

          final Duration durdef = today.difference(reviewDate);

          int days = durdef.inDays;

          if(home_length!=null){
            if(home_length>5 && days== null || days > 30){
              requestReview();
            }
          }

        }

      }
      catch(e){

        print('exception: '+e.toString());
      }
    }

 }

}