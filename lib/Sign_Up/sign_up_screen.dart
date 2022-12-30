import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:poultry_a2z/Home/Home_Screen.dart';
import 'package:poultry_a2z/Utils/theme.dart';
import 'package:poultry_a2z/grobiz_start_pages/welcome/phone_field.dart';
import '../Utils/App_Apis.dart';
import '../Utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class Signup extends StatefulWidget {
  final String mobile_number;

  @override
  _SignupState createState() => _SignupState(mobile_number);

  Signup(this.mobile_number);
}

class _SignupState extends State<Signup> {
  _SignupState(this.mobile_number);

  String country_code = "", phone_code='',country_name='India';

  final int _value = 1;
  bool isCheck = false, isCheck1 = false;

  String mobile_number;

  final TextEditingController _mobileController=TextEditingController();
  final TextEditingController _nameController=TextEditingController();
  final TextEditingController _emailController=TextEditingController();

 // final formGlobalKey = GlobalKey < FormState > ();
  bool isSignUpApiprocessing=false,isSendOtpApiProcessing=false,isVerifyOtpApiProcessing=false,isOtpSend=false,isOtpVerified=false;

  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;

  String otp='';
  String val_one='',val_two='',val_three='',val_four='';

  String haveRetailshop="Yes";
  String whatsAppUpdate="false";
  String baseUrl='';
  String admin_auto_id='';
  FocusNode _focus = FocusNode();
  bool isLocationAllowed=false,isLocationPermissionChecked=false;


  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? appName =prefs.getString('app_name');

    if(baseUrl!=null){
      if(mounted){
        setState(() {
          this.baseUrl=baseUrl;
          print (baseUrl);
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _focus.addListener(_onFocusChange);

    getBaseUrl();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();

    if(mobile_number.isNotEmpty){
      _mobileController.text=mobile_number;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  initWidget() {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    color: Color(0xffF5591F),
                    gradient: LinearGradient(
                      colors: [(Color(0xffF5591F)), Color(0xffF2861E)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        margin: const EdgeInsets.only(top: 20, left: 10),
                        alignment: Alignment.center,
                        child: const Text(
                          "Sign-Up",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 50),
                        alignment: Alignment.centerRight,
                        width: 270,
                        child: Image.asset(
                          "assets/store.png",
                          height: 150,
                          width: 150,
                        ),
                      ),
                    ],
                  ),
                ),
                formUi()

              ],
            )));
  }

  void _onFocusChange() {
    if(isLocationAllowed==false && isLocationPermissionChecked==false){
      _getCurrentLocation();
    }
    debugPrint("Focus: ${_focus.hasFocus.toString()}");
  }

  _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      if(this.mounted){
        setState(() {
          //_showCity=true;
        });
      }

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        if(this.mounted){
          // _showCity=true;
          //_showCountry=true;
          isLocationAllowed=false;
          isLocationPermissionChecked=true;
          setState(() {});
        }
        return Future.error('Location permissions are denied');
      }

      else if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        if(this.mounted){
          //  _showCity=true;
          // _showCountry=true;
          isLocationAllowed=false;
          isLocationPermissionChecked=true;
          setState(() {});
        }
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      else{
        isLocationAllowed=true;
        isLocationPermissionChecked=true;

        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        if(position!=null){
          double latitude=position.latitude;
          double longitude=position.longitude;

          List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude,localeIdentifier: 'en_US',);
          if(placemarks!=null){
            print(placemarks.toString());
            String countrycode=placemarks[0].isoCountryCode.toString();

            country_code=countrycode;

            if(this.mounted){
              setState(() {
                //  _showCountry=true;
                // _showCity=true;
              });
            }
          }
        }
      }

    }

    else if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      if(this.mounted){
        // _showCity=true;
        //_showCountry=true;
        setState(() {});
      }
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    else{
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      if(position!=null){
        double latitude=position.latitude;
        double longitude=position.longitude;

        List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
        print(placemarks.toString());
        if(placemarks!=null){
          String countrycode=placemarks[0].isoCountryCode.toString();

          country_code=countrycode;


          if(this.mounted){
            setState(() {
              //  _showCity=true;
              //  _showCountry=true;
            });
          }
        }
      }
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
  }

  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void onCountryCodePressed() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        print('Select country: ${country.displayName}');
        setState(() {
          country_code =country.countryCode+'-'+country.phoneCode;
          country_name =country.name;
        });
      },
    );
  }

  bool isNameValid(String name) {
   if(name.isEmpty){
     return false;
   }
   return true;
  }

  Widget formUi() {
    return Container(
      margin: const EdgeInsets.only(right: 20, top: 20, left: 20),
      child: Column(
        children: [
          Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Shop Name", style: TextStyle(fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10,),
                  SizedBox(
                    height: 45,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child:
                      TextFormField(
                        controller: _nameController,
                        validator: (name) {
                          if (isNameValid(name!)) {
                            return null;
                          } else {
                            return 'Please enter shop name';
                          }
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                            hintText: 'Please enter your shop name',

                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            )

                        ),
                        // style: AppTheme.form_field_text,
                        keyboardType: TextInputType.name,
                      ),
                    ),
                  ),
                ],

              )
          ),
          const SizedBox(height: 20.0),

          Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Email Id", style: TextStyle(fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10,),
                  SizedBox(
                    height: 45,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child:
                      TextFormField(
                        controller: _emailController,
                        validator: (email) {
                          if (isNameValid(email!)) {
                            return null;
                          } else {
                            return 'Please enter email id';
                          }
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                            hintText: 'Please enter your email id',

                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            )

                        ),
                        // style: AppTheme.form_field_text,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ),
                ],

              )
          ),
          const SizedBox(height: 20.0),

          Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Mobile Number", style: TextStyle(fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10,),
                  Container(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                       /* SizedBox(
                          height: 45,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  height: MediaQuery.of(context).size.height,
                                  decoration: BoxDecoration(

                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),

                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0),
                                        topLeft: Radius.circular(10.0)),
                                  ),
                                  child: TextButton(

                                    onPressed: () {
                                      onCountryCodePressed();
                                    },
                                    child:
                                    Text(
                                      country_code,
                                      style: form_field_label_text(),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  margin: const EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(

                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0)),
                                  ),
                                  child: TextFormField(
                                    maxLength: 10,
                                    controller: _mobileController,
                                    onChanged: (mobile) {
                                      mobile_number=mobile;
                                      isOtpVerified=false;

                                      setState(() {});
                                    },
                                    keyboardType: TextInputType.phone,
                                    autocorrect: true,
                                    textAlign: TextAlign.left,
                                    cursorColor: const Color(0xffF5591F),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                                      hintText: "Mobile Number",
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),*/

                        Container(
                          margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: IntlPhoneField(
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                                      hintText: 'Please enter your mobile no',

                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      )

                                  ),
                                  focusNode: _focus,
                                  initialCountryCode: country_code,
                                  controller: _mobileController,
                                  onCountryChanged: (country) {
                                    setState(() {
                                      country_code = country.code;
                                      phone_code = country.dialCode;
                                      print(country_code);
                                      print(phone_code);
                                    });
                                  },
                                ),
                              )

                              /* SizedBox(
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: const EdgeInsets.only(right: 5),
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(0, 10),
                                        blurRadius: 50,
                                        color: Color(0xffEEEEEE)),
                                  ],
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(15.0),
                                      topLeft: Radius.circular(15.0)),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    onCountryCodePressed();
                                  },
                                  child: Text(
                                    country_code,
                                    style: form_field_label_text(),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(0, 10),
                                        blurRadius: 50,
                                        color: Color(0xffEEEEEE)),
                                  ],
                                  borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0)),
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: _mobileController,
                                  autocorrect: true,
                                  maxLength: 10,
                                  textAlign: TextAlign.left,
                                  cursorColor: const Color(0xffF5591F),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 20),
                                    hintText: "Mobile Number",
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),*/
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],


              )
          ),
          isOtpVerified==true?
          Container(
            margin: const EdgeInsets.only(right: 20.0,top: 5),
            alignment: Alignment.centerRight,
            child: const Text("Verified",style: TextStyle(color: Colors.green,fontSize: 13,fontWeight: FontWeight.bold),),
          ):
          Container(),
          const SizedBox(height: 30.0),

          isOtpVerified==true || isOtpSend==true?
          Container():
          isSendOtpApiProcessing==true?
          Container(
            height: 60,
            alignment: Alignment.center,
            width: 80,
            child: const GFLoader(
                type:GFLoaderType.circle
            ),
          ):
          GestureDetector(
            onTap: () {
              sendSignUpOtpApi(_mobileController.text);
            },
            child: Container(
              width: 200,
              alignment: Alignment.center,
              height: 40,
              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(10),
                color: Colors.orangeAccent,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: Color(0xffEEEEEE)),
                ],
              ),
              child: const Text(
                "Verify Mobile Number",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          isOtpSend==true?
          verifyOtpUi():
          Container(),

          isOtpVerified==true?
          showDetails():
          Container()
        ],
      ),
    );
  }

  bool isValidMobileNumber(){
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);

    if(!regExp.hasMatch(mobile_number)){
      return false;
    }

    return true;
  }

  Widget showDetails(){
    return Column(
      children: <Widget>[
        Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Do you have Retails Shop ?", style: TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(height: 10,),
                Container(

                  child:Row(
                    children: [
                      Container(
                        height: 45,
                        width: 150,
                        decoration: BoxDecoration(

                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),

                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: <Widget>[
                            Radio(
                              value: "Yes",
                              groupValue: haveRetailshop,
                              onChanged: (value){
                                setState(() {
                                  value = haveRetailshop;
                                });
                              },

                            ),
                            const SizedBox(width: 10,),
                            const Text("Yes", style: TextStyle(fontSize: 16, color: Colors.black),)
                          ],
                        ),
                      ),
                      const SizedBox(width: 30,),
                      Container(
                        height: 45,
                        width: 150,
                        decoration: BoxDecoration(

                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),

                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          children: <Widget>[
                            Radio(
                              value: "No",
                              groupValue: haveRetailshop,
                              onChanged: (value){
                                setState(() {
                                  value = haveRetailshop;
                                });
                              },

                            ),
                            const SizedBox(width: 10,),
                            const Text("No", style: TextStyle(fontSize: 16, color: Colors.black))
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],


            )
        ),
        const SizedBox(height: 15.0),
        Container(

            child: Row(
                mainAxisAlignment:  MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(value: isCheck, onChanged: (bool? checkBoxState){
                    if (checkBoxState != null) {
                      setState(() {
                        isCheck = checkBoxState;
                      });
                    }
                  }),

                  const Text("I Want all order related updates \n on my What's Up",
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, color: Colors.black, ),
                      maxLines: 2),
                ]





            )
        ),
        const SizedBox(height: 15.0),
        Container(

            child: Row(
                mainAxisAlignment:  MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(value: isCheck1, onChanged: (bool? checkBoxState){
                    if (checkBoxState != null) {
                      setState(() {
                        isCheck1 = checkBoxState;
                      });
                    }
                  }),

                  const Text("Agree with ", style: TextStyle(fontSize: 16, color: Colors.black),),
                  GestureDetector(
                    child: const Text(
                      "Terms and Condition",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                    onTap: () {
                      // Write Tap Code Here.
                    },
                  )
                ]
            )
        ),
        const SizedBox(height: 15.0),
        isSignUpApiprocessing==true?
        Container(
          height: 60,
          alignment: Alignment.center,
          width: 80,
          child: const GFLoader(
              type:GFLoaderType.circle
          ),
        ):
        GestureDetector(
          onTap: () {
            signUpApi();
          /*  Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
       */   },
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 10, right: 10),

            height: 45,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [(Color(0xffF5591F)), Color(0xffF2861E)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: Color(0xffEEEEEE)),
              ],
            ),
            child: const Text(
              "Register",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Resend Code in " , style: TextStyle(fontSize: 14),),
        TweenAnimationBuilder(
          tween: Tween(begin: 30.0, end: 0.0),
          duration: const Duration(seconds: 30),
          builder: (_, dynamic value, child) => Text(
            "00:${value.toInt()}",
            style: const TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }

  Widget verifyOtpUi(){
    return Column(
      children: <Widget>[
        const Text('Please enter the otp sent to your mobile number '),
        const SizedBox(height: 15.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 45,
              height: 45,
              child: TextFormField(
                autofocus: true,
               // obscureText: true,
                style: const TextStyle(fontSize: 20),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: otpInputDecoration,
                onChanged: (value) {
                  val_one=value;
                  nextField(value, pin2FocusNode);
                },
              ),
            ),
            SizedBox(
              width: 45,
              height: 45,
              child: TextFormField(
                focusNode: pin2FocusNode,
               // obscureText: true,
                style: const TextStyle(fontSize: 20),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: otpInputDecoration,
                onChanged: (value){
                  val_two=value;
                  nextField(value, pin3FocusNode);
                },
              ),
            ),
            SizedBox(
              width: 45,
              height: 45,
              child: TextFormField(
                focusNode: pin3FocusNode,
               // obscureText: true,
                style: const TextStyle(fontSize: 20),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: otpInputDecoration,
                onChanged: (value){
                  val_three=value;
                  nextField(value, pin4FocusNode);
                },
              ),
            ),
            SizedBox(
              width: 45,
              height: 45,
              child: TextFormField(
                focusNode: pin4FocusNode,
               // obscureText: true,
                style: const TextStyle(fontSize: 20),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: otpInputDecoration,
                onChanged: (value) {
                  val_four=value;
                  if (value.length == 1) {
                    pin4FocusNode!.unfocus();
                    // Then you need to check is the code is correct or not
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 15,),
        TextButton(
          onPressed: ()=>{},
          child: const Text('Resend OTP',style: TextStyle(color: Colors.deepOrange),),
        ),
        const SizedBox(height: 15.0),

        isVerifyOtpApiProcessing==true?
        Container(
          height: 60,
          alignment: Alignment.center,
          width: 80,
          child: const GFLoader(
              type:GFLoaderType.circle
          ),
        ):
        GestureDetector(
          onTap: () {
            if(validationOtp()){
              verifySignUpOtpApi();
            }
          },
          child: Container(
            width: 200,
            alignment: Alignment.center,
            // margin: EdgeInsets.only(left: 10, right: 10),

            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [(Color(0xffF5591F)), Color(0xffF2861E)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[100],
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: Color(0xffEEEEEE)),
              ],
            ),
            child: const Text(
              "Verify",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )

      ],
    );
  }

  Future sendSignUpOtpApi(String mobileNumber) async {
    setState(() {
      isSendOtpApiProcessing=true;
    });

    final body = {
      "mobile_number":mobileNumber,
      "admin_auto_id":admin_auto_id,
    };

    var url=baseUrl+'api/'+send_registration_otp;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      isSendOtpApiProcessing=false;

      final resp=jsonDecode(response.body);
      String status=resp['status'];

      if(status=="1"){
        isOtpSend=true;
        isOtpVerified=false;

      }
      else if(status=="0") {
        isOtpSend=false;
        isOtpVerified=true;
      }

      setState(() {});

    }
  }

  Future verifySignUpOtpApi() async {
    setState(() {
      isVerifyOtpApiProcessing=true;
    });

    final body = {
      "mobile_number":mobile_number,
      "otp":otp,
      "admin_auto_id":admin_auto_id,
    };

    var url=baseUrl+'api/'+verify_registration_otp;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      isVerifyOtpApiProcessing=false;

      final resp=jsonDecode(response.body);
      String status=resp['status'];

      if(status=="1"){
        isOtpSend=false;
        isOtpVerified=true;
        isVerifyOtpApiProcessing=false;
      }
      else {
        String msg=resp['msg'];
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
      }

      setState(() {});
    }
  }

  Future signUpApi() async {
    setState(() {
      isSignUpApiprocessing=true;
    });

    final body = {
      "mobile_number":_mobileController.text,
      "name":_nameController.text,
      "email_id":_emailController.text,
      "update_on_whatsapp":isCheck.toString(),
      "have_retail_shop":haveRetailshop,
      "user_type":'Buyer',
      "country_code":country_code,
      "country_name":country_name,
      "admin_auto_id":admin_auto_id,
    };

    print(country_name+' '+country_code);

    var url=baseUrl+'api/'+user_registration;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      isSignUpApiprocessing=false;

      final resp=jsonDecode(response.body);
      String status=resp['status'];

      if(status=="1"){
        print(status);

        String userAutoId=resp['user_auto_id'];
        String userType=resp['user_type'];
        Fluttertoast.showToast(msg: "You have signed up successfully", backgroundColor: Colors.grey,);
        saveLoginSession(userAutoId,userType);
      }
      else {
        String msg=resp['msg'];
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
      }

      setState(() {});
    }
  }

  bool validationOtp(){
    otp=val_one+val_two+val_three+val_four;

    if(otp.isEmpty){
      Fluttertoast.showToast(msg: "Please enter otp", backgroundColor: Colors.grey,);
      return false;
    }
    else if(otp.length<4){
      Fluttertoast.showToast(msg: "Please enter valid otp", backgroundColor: Colors.grey,);
      return false;
    }
    return true;
  }

  Future<void> saveLoginSession(String userAutoId, String userType) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();

    prefs.setBool('is_login', true);
    prefs.setString('user_id', userAutoId);
    prefs.setString('user_type', userType);

    print("set");

    Fluttertoast.showToast(msg: "Signed in successfully", backgroundColor: Colors.grey,);

    Navigator.of(context)
        .pushNamedAndRemoveUntil(HomeScreen.routeName, (Route<dynamic> route) => false);

   /* Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );*/
  }
}
