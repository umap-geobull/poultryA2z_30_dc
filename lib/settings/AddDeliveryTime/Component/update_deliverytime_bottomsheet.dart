import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/settings/AddCurrency/Component/Rest_Apis.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Utils/constants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';


typedef OnSaveCallback = void Function();

class AddDeliveryTime extends StatefulWidget {

  OnSaveCallback onSaveCallback;
  String charges,id,unit;

  AddDeliveryTime(this.onSaveCallback, this.charges, this.id, this.unit);

  @override
  _AddDeliveryTime createState() => _AddDeliveryTime(charges,id,unit);

}

class _AddDeliveryTime extends State<AddDeliveryTime> {

  String charges,id,unit;
  _AddDeliveryTime(this.charges, this.id, this.unit);

  List<String> items = [
    'Min',
    'Hrs',
    'Days',
    'Week',
    'Month'
  ];

  bool isApiCallProcessing=false;

  String baseUrl='';

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if(baseUrl!=null){
      this.baseUrl=baseUrl;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Material(
          child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 100),
                child:Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Center(
                          child: Text('Update Delivery Time ',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))),
                      Divider(color: Colors.grey.shade300),
                      SizedBox(
                        height: 10.0,
                      ),

                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Delivery Time",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16)),
                            SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery
                                      .of(context)
                                      .viewInsets
                                      .bottom),
                              child: SizedBox(
                                height: 40,
                                child: SizedBox(
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height,
                                  child: TextFormField(

                                    initialValue: charges,
                                    // controller: _product_name_controller_,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          10, 15, 0, 0),
                                      //hintText: "Add multiple colors separated by comma",
                                      hintText: "Add time",
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                        const BorderSide(color: Colors.blue, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                        const BorderSide(color: Colors.grey, width: 1),
                                        borderRadius: BorderRadius.circular(10),

                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide:
                                        const BorderSide(color: Colors.grey, width: 1),
                                        borderRadius: BorderRadius.circular(10),

                                      ),
                                    ),

                                    onChanged: (value) => charges = value,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Time Unit",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16)),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              child: Center(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    isExpanded: true,
                                    hint: Row(
                                      children: const [
                                        Expanded(
                                          child: Text(
                                            'Select Unit',
                                            style: TextStyle(
                                              fontSize: 14,

                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    items: items
                                        .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,

                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                        .toList(),
                                    value: unit,
                                    onChanged: (value) {
                                      setState(() {
                                        unit = value as String;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                    ),

                                    iconEnabledColor: Colors.black,
                                    iconDisabledColor: Colors.grey,
                                    buttonHeight: 40,
                                    buttonWidth: MediaQuery.of(context).size.width,
                                    buttonPadding:
                                    EdgeInsets.only(left: 14, right: 14,top: 10,bottom: 10),
                                    buttonDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),

                                    ),
                                    itemHeight: 30,
                                    itemPadding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                    dropdownMaxHeight: 150,
                                    dropdownWidth: 170,
                                    dropdownPadding: null,

                                    dropdownDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),

                                    ),
                                    dropdownElevation: 8,
                                    scrollbarRadius: const Radius.circular(40),
                                    scrollbarThickness: 1,
                                    scrollbarAlwaysShow: true,

                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: kPrimaryColor,
                                  textStyle: const TextStyle(fontSize: 20)),
                              onPressed: () {
                                setState(() {
                                  if (charges == "" || charges.isEmpty) {
                                    Fluttertoast.showToast(msg: "Enter time",
                                      backgroundColor: Colors.grey,);
                                  }
                                  else {
                                    Navigator.pop(context);
                                    Add_DeliveryTime();
                                    if(mounted)
                                    {
                                      setState(() {
                                        charges = "";
                                      });
                                    }
                                  }
                                });
                              },
                              child: const Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                )),)
      );
    }
    );
  }

  void Add_DeliveryTime() {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    Rest_Apis restApis=Rest_Apis();

    restApis.Add_DeliveryTime_Api(charges, unit,id,baseUrl).then((value) {
      if (value != null) {
        String status = value;

        if (status == "1") {
          isApiCallProcessing = false;
          widget.onSaveCallback();
        }
        else{
          isApiCallProcessing = false;
        }
      }
    });
  }
}