

import 'package:flutter/cupertino.dart';

class GetAlignement{

  static Alignment getTitleAlignment(String alignemet){

    if(alignemet == 'center'){
      return Alignment.center;
    }
    else if(alignemet == 'end'){
      return Alignment.centerRight;
    }
    else {
      return Alignment.centerLeft;
    }
  }


}