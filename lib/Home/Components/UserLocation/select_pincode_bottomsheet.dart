import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:getwidget/getwidget.dart';


typedef OnSaveCallback = void Function();

class SelectPincode extends StatefulWidget {
  OnSaveCallback onSaveCallback;

  SelectPincode(this.onSaveCallback);

  @override
  _SelectPincode createState() => _SelectPincode();
}

class _SelectPincode extends State<SelectPincode> {

  String user_pincode='',user_city='';
  double latitude=0.0,longitude=0.0;

  String baseUrl='';

  bool isApiCallProcessing=false;

  TextEditingController pincodeController=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
  }

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? pincode =prefs.getString('user_pincode');
    double? latitude =prefs.getDouble('user_latitude');
    double? longitude =prefs.getDouble('user_longitude');
    String? user_city =prefs.getString('user_city');

    if(baseUrl!=null){
      this.baseUrl=baseUrl;
    }

    if(pincode!=null){
      this.user_pincode=pincode;
    }

    if(longitude!=null){
      this.longitude=longitude;
    }

    if(latitude!=null){
      this.latitude=latitude;
    }

    if(user_city!=null){
      this.user_city=user_city;
    }

    if(this.mounted){
      setState(() {
        pincodeController.text=user_pincode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: StatefulBuilder(builder: (context, setState) {
      return Material(
          child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: ()=>{
                              onBackPressed()
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ),
                        const Text(
                          'Add Delivery Pincode',style: TextStyle(color: Colors.black87,fontSize: 14),
                        ),
                        Expanded(
                            flex:1,
                            child:Container(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: ()=>{
                                  savePincodeSession()
                                },
                                child: const Text('SAVE'),
                              ),
                            )
                        )

                      ],
                    ),
                    Divider(),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: pincodeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                            hintText: "Enter Pincode",
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
                        ),
                      ),
                    ),
                    
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(10),
                      child: Text('OR', style: TextStyle(fontSize:20,color: Colors.black87,fontWeight: FontWeight.bold),),
                    ),

                    isApiCallProcessing==true?
                    Container(
                      margin: EdgeInsets.all(20),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: const GFLoader(
                          type:GFLoaderType.circle
                      ),
                    ):
                    Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue[300],
                          minimumSize: Size(200, 50)
                        ),
                        child: const Text('Fetch From Current Location',style: TextStyle(color: Colors.black87),),
                        onPressed: () {
                          getUserCurrentLocation();
                        },
                      ),
                      margin: const EdgeInsets.all(20),
                    ),

                  ],
                )
            ),
          )
      );
    }
    ),
        onWillPop: ()=>onBackPressed()
    );
  }

  Future<void> savePincodeSession() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();

    prefs.setString('user_pincode', pincodeController.text);
    prefs.setString('user_city', user_city);
    prefs.setDouble('user_latitude', latitude);
    prefs.setDouble('user_longitude', longitude);

    print('user pincode  saved');

    widget.onSaveCallback();

    //Navigator.of(context).pop();
  }

  getUserCurrentLocation() async{

    if (await Permission.location.request().isGranted) {
      print('granted');

      // Either the permission was already granted before or the user just granted it.

      if(this.mounted){
        setState(() {
          isApiCallProcessing=true;
        });
      }
      Position userPosition= await Geolocator.getCurrentPosition();

      if(userPosition!=null){
        latitude=userPosition.latitude;
        longitude=userPosition.longitude;

        List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

        print(placemarks.toString());
        if(placemarks!=null){
          user_pincode=placemarks[0].postalCode.toString();
          user_city=placemarks[0].locality.toString();

          pincodeController.text=user_pincode;
        }

        if(this.mounted){
          setState(() {
            isApiCallProcessing=false;
          });
        }
      }

    }
    else if (await Permission.speech.isPermanentlyDenied) {
      print('permanenly denied');
      openAppSettings();
    }
  }

  onBackPressed() async{
    Navigator.of(context).pop();
  }
}

