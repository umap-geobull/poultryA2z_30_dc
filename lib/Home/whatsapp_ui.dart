import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageOnWhatsApp extends StatefulWidget {

  @override
  _Whatsapp createState() => _Whatsapp();

}

class _Whatsapp extends State<MessageOnWhatsApp>{

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>{
        print('in tap'),
        openwhatsapp()
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(left: 10,right: 10, top: 30),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment:  MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.whatsapp_rounded, color: Colors.white, size: 18,),
            SizedBox(width: 5,),
            Text('Chat', style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
            ))
          ],
        ),
      ),
    );

  }

  openwhatsapp() async{
    var whatsapp ="7875642402";

    var whatappURL_ios ="https://wa.me/$whatsapp?text=";

    var whatsappURl_android = "whatsapp://send?phone="+whatsapp+"&text=";

    if(Platform.isIOS){
      // for iOS phone only
      if( await canLaunchUrl(Uri.parse(whatappURL_ios))){
        await launchUrl(Uri.parse(whatappURL_ios));
      }
      else{
        Fluttertoast.showToast(
          msg: 'Whatsapp is not installed',
          backgroundColor: Colors.grey,
        );
      }
    }
    else{
      // android , web
      if( await canLaunchUrl(Uri.parse(whatsappURl_android))){
        await launchUrl(Uri.parse(whatsappURl_android));
      }
      else{
        Fluttertoast.showToast(
          msg: 'Whatsapp is not installed',
          backgroundColor: Colors.grey,
        );

      }


    }

  }


}
