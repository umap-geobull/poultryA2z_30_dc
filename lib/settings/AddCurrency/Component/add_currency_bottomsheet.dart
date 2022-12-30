import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/settings/AddCurrency/Component/Rest_Apis.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:country_picker/country_picker.dart';
import 'package:currency_picker/currency_picker.dart';
import '../../../Utils/constants.dart';

typedef OnSaveCallback = void Function();

class AddCurrency extends StatefulWidget {

  OnSaveCallback onSaveCallback;

  AddCurrency(this.onSaveCallback);

  @override
  _AddCurrency createState() => _AddCurrency();

}

class _AddCurrency extends State<AddCurrency> {
  bool isApiCallProcessing=false;
  TextEditingController chargesController=TextEditingController();

  String country_name='', country_code='',country_currency='', flag_image='';

  String baseUrl='', admin_auto_id='';
  String expresscharges='0';
  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');

    if (baseUrl!=null && adminId!=null) {
      setState(() {
        this.baseUrl=baseUrl;
        this.admin_auto_id=adminId;
      });
    }
    return null;
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
                          child: Text('Add Currency',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))),
                      Divider(color: Colors.grey.shade300),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text("Select Country",
                          style: TextStyle(
                              color: Colors.black, fontSize: 16)),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 40,
                        child: SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height,
                          child:GestureDetector(
                            onTap: ()=>{
                              showCountryPicker(
                                context: context,
                                showPhoneCode: true,
                                // optional. Shows phone code before the country name.
                                onSelect: (Country country) {
                                  print('Select country: ${country.displayName}');
                                  setState(() {
                                    country_code =country.countryCode+'-'+country.phoneCode;
                                    flag_image=country.flagEmoji.toString();
                                    country_name=country.name.toString();

                                    print('flag: '+country.flagEmoji.toString());
                                  });
                                },
                              )
                            },
                            child: Container(
                              child:
                              country_name.isEmpty?
                              Text('Select Country',
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
                              ):
                              Text(
                                country_name+' '+country_code,
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
                              ),
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black54,
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Text("Select Currency",
                          style: TextStyle(
                              color: Colors.black, fontSize: 16)),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 40,
                        child: SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height,
                          child:GestureDetector(
                            onTap: ()=>{
                              showCurrencyPicker(
                                context: context,
                                showFlag: true,
                                showCurrencyName: true,
                                showCurrencyCode: true,
                                onSelect: (Currency currency) {
                                  print('Select currency: ${currency.name}');
                                  setState(() {
                                    country_currency=currency.symbol.toString();
                                  });
                                  },
                              )
                            },
                            child: Container(
                              child:
                              country_currency.isEmpty?
                              Text('Select Currency',
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
                              ):
                              Text(
                                country_currency,
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
                              ),
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black54,
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Text("Express Delivery Charges",
                          style: TextStyle(
                              color: Colors.black, fontSize: 16)),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 40,
                        child: SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height,
                          child: TextFormField(
                            controller: chargesController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.fromLTRB(
                                  10, 15, 0, 0),
                              hintText: "Enter express delivery charges",
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
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),


                      SizedBox(
                        height: 30,
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
                                  if (country_name.isEmpty) {
                                    Fluttertoast.showToast(msg: "Please select country",
                                      backgroundColor: Colors.grey,);
                                  }
                                  else if (country_currency.isEmpty) {
                                    Fluttertoast.showToast(
                                      msg: "Enter currency",
                                      backgroundColor: Colors.grey,);
                                  }
                                 /* else if (chargesController.text.isEmpty) {
                                    Fluttertoast.showToast(
                                      msg: "Enter express delivery charges",
                                      backgroundColor: Colors.grey,);
                                  }*/
                                  else {
                                    Add_Currency();
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

  void Add_Currency() {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    Rest_Apis restApis=Rest_Apis();
    if(chargesController.text=="" || chargesController.text=='0')
    {
      expresscharges='0';
    }else
    {
      expresscharges=chargesController.text;
    }
    restApis.Add_Currency_Api(country_name, country_code,country_currency,flag_image, expresscharges, admin_auto_id, baseUrl).then((value) {
      if (value != null) {
        country_name='';
        country_code='';
        country_currency='';
        flag_image='';

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