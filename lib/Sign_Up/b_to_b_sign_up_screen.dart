import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:poultry_a2z/Home/Home_Screen.dart';
import 'package:poultry_a2z/Utils/theme.dart';

import 'Otp_screen.dart';

class BtoBSignup extends StatefulWidget {


  final String mobile_number;

  @override
  _BtoBSignupState createState() => _BtoBSignupState(mobile_number);

  const BtoBSignup(this.mobile_number);
}

class _BtoBSignupState extends State<BtoBSignup> {
  _BtoBSignupState(this.mobile_number);

  String country_code = " IN",
      phone_code = "+91";
  final int _value = 1;
  bool isCheck = false, isCheck1 = false;

  String mobile_number;

  final TextEditingController _mobileCpntroller=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(mobile_number.isNotEmpty){
      _mobileCpntroller.text=mobile_number;

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

  void onCountryCodePressed() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        print('Select country: ${country.displayName}');
        setState(() {
          country_code = ' ' + country.countryCode;
          phone_code = '+' + country.phoneCode;
        });
      },
    );
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
          const SizedBox(height: 15.0),
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
                        SizedBox(
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
                                    child: Text(
                                      phone_code + country_code,
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
                                  child: const TextField(

                                    autocorrect: true,
                                    textAlign: TextAlign.left,
                                    cursorColor: Color(0xffF5591F),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      hintText: "Mobile Number",
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],


              )
          ),
          const SizedBox(height: 15.0),
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
                                   value: 1,
                                   groupValue: _value,
                                   onChanged: (value){
                                     setState(() {
                                       value = _value;
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
                                    value: 2,
                                    groupValue: _value,
                                    onChanged: (value){
                                      setState(() {
                                        value = _value;
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
          const Signup_OtpForm(),
          const SizedBox(height: 15.0),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
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
      ),
    );
  }
}
