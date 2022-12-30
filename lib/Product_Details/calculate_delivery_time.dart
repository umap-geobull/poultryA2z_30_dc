import 'package:intl/intl.dart';

class CalculateDeliveryTime{


  static String getDeliveryDate(String time, String timeUnit){
    String deliveryDate='';

    int? deliveryTime=int.tryParse(time);

    var today = new DateTime.now();

    if(timeUnit=='Min'){
      var newDate = DateTime(today.year, today.month, today.day,today.hour,today.minute+deliveryTime!);
      deliveryDate=DateFormat('dd MMMM yyyy hh:mm').format(newDate).toString();
    }
    else if(timeUnit=='Hrs'){
      var newDate = DateTime(today.year, today.month, today.day,today.hour+deliveryTime!,today.minute);
      deliveryDate=DateFormat('dd MMMM yyyy hh:mm').format(newDate).toString();
    }
    else if(timeUnit=='Days'){
      var newDate = DateTime(today.year, today.month, today.day+deliveryTime!,today.hour,today.minute);
      deliveryDate=DateFormat('dd MMMM yyyy').format(newDate).toString();
    }
    else if(timeUnit=='Week'){
      deliveryTime=(deliveryTime!*7);
      var newDate = DateTime(today.year, today.month, today.day+deliveryTime!,today.hour,today.minute);
      deliveryDate=DateFormat('dd MMMM yyyy').format(newDate).toString();
    }
    else if(timeUnit=='Month'){
      var newDate = DateTime(today.year, today.month+deliveryTime!, today.day,today.hour,today.minute);
      deliveryDate=DateFormat('dd MMMM yyyy').format(newDate).toString();
    }

    print(deliveryDate.toString());
    return deliveryDate;
  }
}