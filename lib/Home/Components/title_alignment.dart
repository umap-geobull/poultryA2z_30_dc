
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Home/Components/UserLocation/select_pincode_bottomsheet.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/settings/Add_Pincode/Components/Get_Pincode_List_Model.dart';
import 'package:poultry_a2z/settings/Add_Pincode/Components/Rest_Apis.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

typedef OnSaveCallback = void Function(String alignment);

class TitleAlignment extends StatefulWidget {
  String text_align;
  OnSaveCallback onSaveCallback;

  TitleAlignment(this.text_align, this.onSaveCallback);

  @override
  _TitleAlignment createState() => _TitleAlignment();
}

class _TitleAlignment extends State<TitleAlignment> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Expanded(
              flex:2,
              child:
              Text('Alignment:',
                style: TextStyle(color: Colors.black,fontSize: 15, fontWeight: FontWeight.bold),
              ),
          ),
          Expanded(
              flex:3,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 20,
                    width: 20,
                    child: Radio(
                      value: 'start',
                      groupValue: widget.text_align,
                      onChanged: (value) {
                        widget.onSaveCallback(value.toString());
                      },
                    ),
                  ),
                  Text('Start',style: TextStyle(color: Colors.black54,fontSize: 15),),
                ],
              )),
          Expanded(
              flex:3,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 20,
                    width: 20,
                    child: Radio(
                      value: 'center',
                      groupValue: widget.text_align,
                      onChanged: (value) {
                        widget.onSaveCallback(value.toString());
                      },
                    ),
                  ),
                  Text('Center',style: TextStyle(color: Colors.black54,fontSize: 15),),
                ],
              ))
        ],
      ),
    );
  }

}
