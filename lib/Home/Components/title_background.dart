
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/show_color_picker.dart';
import 'package:poultry_a2z/Home/Components/UserLocation/select_pincode_bottomsheet.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/settings/Add_Pincode/Components/Get_Pincode_List_Model.dart';
import 'package:poultry_a2z/settings/Add_Pincode/Components/Rest_Apis.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

typedef OnSaveCallback = void Function(Color color);

class TitleBackground extends StatefulWidget {
  Color backgroundColor=Colors.white70;
  OnSaveCallback onSaveCallback;

  TitleBackground(this.backgroundColor, this.onSaveCallback);

  @override
  _TitleBackground createState() => _TitleBackground();
}

class _TitleBackground extends State<TitleBackground> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Background color',
            style: TextStyle(color: Colors.black,fontSize: 15, fontWeight: FontWeight.bold),
          ),

          GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1,color: Colors.black)
              ),
              alignment: Alignment.center,
              margin: EdgeInsets.all(10),
              child: Text('Select Background Color',style: TextStyle(color: Colors.black),),
            ),
            onTap: () {
              showBackgroundColorChooser();
            },
          )

        ],
      ),
    );
  }

  showBackgroundColorChooser() {
    showDialog(
        context: context,
        builder: (context){
          return ShowColorPicker(onSaveCallback: updateBackgroundColor, pickerColor: widget.backgroundColor,);
        }
    );
  }

  void updateBackgroundColor(Color color){
    widget.onSaveCallback(color);
    Navigator.pop(context);
  }

}
