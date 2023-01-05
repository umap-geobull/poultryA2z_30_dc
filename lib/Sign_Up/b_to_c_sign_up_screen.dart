import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:poultry_a2z/Home/Home_Screen.dart';
import 'package:poultry_a2z/Sign_Up/vendor_catagory_model.dart';
import 'package:poultry_a2z/Sign_Up/vendor_signup_catagory.dart';
import 'package:poultry_a2z/Utils/AppConfig.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/grobiz_start_pages/welcome/phone_field.dart';
import '../Add_Vendor_Screen/vendor_detail_form.dart';
import '../Home/Components/MainCategories/main_category_model.dart';
import '../Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../grobiz_start_pages/welcome/countries.dart' as c;

class BtoCSignup extends StatefulWidget {
  final String mobile_number;
  final String country_code;
  final String phone_code;

  @override
  BtoCSignupState createState() =>
      BtoCSignupState(mobile_number, country_code, phone_code);

  const BtoCSignup(this.mobile_number, this.country_code, this.phone_code);
}

class BtoCSignupState extends State<BtoCSignup> {
  BtoCSignupState(this.mobile_number, this.country_code, this.phone_code);

  String country_code = '', phone_code = '', country_name = 'India';
  final int _value = 1;
  bool isCheck = false, isCheck1 = false;

  String mobile_number;

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _mobileControllerVendor = TextEditingController();
  final TextEditingController _nameControllerVendor = TextEditingController();
  final TextEditingController _emailControllerVendor = TextEditingController();

  final formGlobalKey = GlobalKey<FormState>();
  bool isSignUpApiprocessing = false,
      isSendOtpApiProcessing = false,
      isVerifyOtpApiProcessing = false,
      isOtpSend = false,
      isOtpVerified = false;

  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;

  String otp = '';
  String val_one = '', val_two = '', val_three = '', val_four = '';

  String haveRetailshop = "Yes";
  String whatsAppUpdate = "false";
  String baseUrl = '', admin_auto_id = '';

  String userType = 'Customer';

  Color appBarColor = Colors.white,
      appBarIconColor = Colors.black,
      primaryButtonColor = Colors.orange,
      secondaryButtonColor = Colors.orangeAccent;

  FocusNode _focus = FocusNode();
  bool isLocationAllowed = false, isLocationPermissionChecked = false;
  String businessDetailsId = '', businessName = '', businessLogo = '';

  String token = '';

  void getappUi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? appBarColor = prefs.getString('appbarColor');
    String? appbarIcon = prefs.getString('appbarIconColor');
    String? primaryButtonColor = prefs.getString('primaryButtonColor');
    String? secondaryButtonColor = prefs.getString('secondaryButtonColor');

    if (appBarColor != null) {
      this.appBarColor = Color(int.parse(appBarColor));
    }

    if (appbarIcon != null) {
      this.appBarIconColor = Color(int.parse(appbarIcon));
    }

    if (primaryButtonColor != null) {
      this.primaryButtonColor = Color(int.parse(primaryButtonColor));
    }

    if (secondaryButtonColor != null) {
      this.secondaryButtonColor = Color(int.parse(secondaryButtonColor));
    }

    if (this.mounted) {
      setState(() {});
    }
  }

  void getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');
    // String? appName =prefs.getString('app_name');
    String? adminId = prefs.getString('admin_auto_id');

    if (baseUrl != null && adminId != null) {
      if (mounted) {
        setState(() {
          this.baseUrl = baseUrl;
          print(baseUrl);
          this.admin_auto_id = adminId;
        });
      }
    }
    setState(() {});
    getMainCategories();
  }

  bool isApiCallProcessing = true;
  bool isAddProcessing = false;
  List<VendorData> mainCategoryList = [];

  void getMainCategories() async {
    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }
    var url = AppConfig.grobizBaseUrl + get_main_category_lists;
    print(url);
    var uri = Uri.parse(url);
    print("url ${uri}");

    final body = {
      // "admin_auto_id":admin_auto_id,
      // "app_type_id": app_type_id,
    };
    print(body.toString());
    final response = await http.get(uri);
    print("response ${response.body}");
    if (response.statusCode == 200) {
      isApiCallProcessing = false;

      final resp = jsonDecode(response.body);
      int status = resp['status'];
      print("status" + status.toString());
      if (status == 1) {
        VendorCatagories vendorCatagoryModel =
            VendorCatagories.fromJson(json.decode(response.body));
        // mainCategoryList=(vendorCatagoryModel!=null?vendorCatagoryModel.data:[])!;

        if (vendorCatagoryModel != null) {
          if (vendorCatagoryModel.data != null) {
            mainCategoryList = vendorCatagoryModel.data!;
          }
        }

        print(mainCategoryList.toString());
        print("Size of shoes" + mainCategoryList.length.toString());
        if (mounted) {
          setState(() {});
        }
      }
    } else if (response.statusCode == 500) {
      if (this.mounted) {
        setState(() {
          isApiCallProcessing = false;
        });
      }
      Fluttertoast.showToast(
        msg: "Server error in getting main categories",
        backgroundColor: Colors.grey,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAppLogo();

    generateFirebaseToken();

    _focus.addListener(_onFocusChange);

    getBaseUrl();
    getappUi();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();

    if (mobile_number.isNotEmpty) {
      _mobileController.text = mobile_number;

      setState(() {});
    }
  }

  void _onFocusChange() {
    if (isLocationAllowed == false && isLocationPermissionChecked == false) {
      _getCurrentLocation();
    }
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
      if (this.mounted) {
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
        if (this.mounted) {
          // _showCity=true;
          //_showCountry=true;
          isLocationAllowed = false;
          isLocationPermissionChecked = true;
          setState(() {});
        }
        return Future.error('Location permissions are denied');
      } else if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        if (this.mounted) {
          //  _showCity=true;
          // _showCountry=true;
          isLocationAllowed = false;
          isLocationPermissionChecked = true;
          setState(() {});
        }
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      } else {
        isLocationAllowed = true;
        isLocationPermissionChecked = true;

        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        if (position != null) {
          double latitude = position.latitude;
          double longitude = position.longitude;

          List<Placemark> placemarks = await placemarkFromCoordinates(
            latitude,
            longitude,
            localeIdentifier: 'en_US',
          );
          if (placemarks != null) {
            String countrycode = placemarks[0].isoCountryCode.toString();

            country_code = countrycode;

            if (this.mounted) {
              setState(() {
                //  _showCountry=true;
                // _showCity=true;
              });
            }
          }
        }
      }
    } else if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      if (this.mounted) {
        // _showCity=true;
        //_showCountry=true;
        setState(() {});
      }
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      if (position != null) {
        double latitude = position.latitude;
        double longitude = position.longitude;

        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);
        if (placemarks != null) {
          String countrycode = placemarks[0].isoCountryCode.toString();

          country_code = countrycode;

          if (this.mounted) {
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

  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  initWidget() {
    return DefaultTabController(
      length: 2,
      child: Builder(builder: (BuildContext context) {
        final TabController? tabController = DefaultTabController.of(context);
        tabController?.addListener(() {
          if (!tabController.indexIsChanging) {
            print("inside tasb change");

          }
        });
        return Scaffold(
          appBar: AppBar(
              elevation: 0,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  businessLogo.isNotEmpty
                      ? SizedBox(
                          height: 150,
                          width: 150,
                          child: CachedNetworkImage(
                            imageUrl: app_logo_base_url + businessLogo,
                            placeholder: (context, url) => Container(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
              centerTitle: true,
              leadingWidth: 0,
              // toolbarHeight: 1,
              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                  decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                color: primaryButtonColor,
              )),
              bottom: TabBar(
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 4,
                tabs: [
                  Tab(icon: Icon(Icons.person_pin), text: "Customer"),
                  Tab(icon: Icon(Icons.contacts), text: "Vendor")
                ],
              )),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                  child: Column(
                children: [
                  // Container(
                  //   padding: EdgeInsets.only(top: 60,bottom: 40),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.only(
                  //         bottomLeft: Radius.circular(30),
                  //         bottomRight: Radius.circular(30)),
                  //     color: primaryButtonColor,
                  //   ),
                  //   child: Center(
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           businessLogo.isNotEmpty?
                  //           SizedBox(
                  //             height: 150,
                  //             width: 150,
                  //             child: CachedNetworkImage(
                  //               imageUrl: app_logo_base_url+businessLogo,
                  //               placeholder:(context, url) => Container(),
                  //               errorWidget: (context, url, error) => const Icon(Icons.error),
                  //             ),
                  //           ):
                  //           Container(),
                  //
                  //           SizedBox(height: 20,),
                  //
                  //           Text(
                  //             "Sign Up",
                  //             style: TextStyle(fontSize: 30, color: Colors.white),
                  //           ),
                  //         ],
                  //       )),
                  // ),
                  formUi()
                ],
              )),
              SingleChildScrollView(
                  child: Column(
                children: [
                  // Container(
                  //   padding: EdgeInsets.only(top: 60,bottom: 40),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.only(
                  //         bottomLeft: Radius.circular(30),
                  //         bottomRight: Radius.circular(30)),
                  //     color: primaryButtonColor,
                  //   ),
                  //   child: Center(
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           businessLogo.isNotEmpty?
                  //           SizedBox(
                  //             height: 150,
                  //             width: 150,
                  //             child: CachedNetworkImage(
                  //               imageUrl: app_logo_base_url+businessLogo,
                  //               placeholder:(context, url) => Container(),
                  //               errorWidget: (context, url, error) => const Icon(Icons.error),
                  //             ),
                  //           ):
                  //           Container(),
                  //
                  //           SizedBox(height: 20,),
                  //
                  //           Text(
                  //             "Sign Up",
                  //             style: TextStyle(fontSize: 30, color: Colors.white),
                  //           ),
                  //         ],
                  //       )),
                  // ),
                  formUiVendor()
                ],
              )),

              // VendorSignupCatagory()
            ],
          ),
        );
      }),
    );
  }

  // Widget VendorSignupCatagory() {
  //
  // }

  getAppLogo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var appLogo = prefs.getString('app_logo');

    if (appLogo != null) {
      if (this.mounted) {
        setState(() {
          businessLogo = appLogo;
        });
      }
    }
  }

  void onCountryCodePressed() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        setState(() {
          country_code = country.countryCode + '-' + country.phoneCode;
          country_name = country.name;
        });
      },
    );
  }

  bool isNameValid(String name) {
    if (name.isEmpty) {
      return false;
    }
    return true;
  }

  Widget formUi() {
    return Container(
      margin: const EdgeInsets.only(right: 20, top: 20, left: 20),
      child: Form(
        key: formGlobalKey,
        child: Column(
          children: [
            Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Name",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 45,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TextFormField(
                      controller: _nameController,
                      validator: (name) {
                        if (isNameValid(name!)) {
                          return null;
                        } else {
                          return 'Please enter your name';
                        }
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 15, 0, 0),
                          hintText: 'Please enter your name',
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          )),
                      // style: AppTheme.form_field_text,
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ),
              ],
            )),
            const SizedBox(height: 20.0),
            Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Email Id",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 45,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TextFormField(
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
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 15, 0, 0),
                          hintText: 'Please enter your email id',
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          )),
                      // style: AppTheme.form_field_text,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),
              ],
            )),
            const SizedBox(height: 20.0),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Mobile Number",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
/*                          SizedBox(
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
                          )*/

                      Container(
                        child: IntlPhoneField(
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                              hintText: 'Please enter your mobile no',
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              )),
                          focusNode: _focus,
                          initialCountryCode: country_code,
                          controller: _mobileController,
                          onCountryChanged: (country) {
                            setState(() {
                              country_code = country.code;
                              phone_code = country.dialCode;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
            isOtpVerified == true
                ? Container(
                    margin: const EdgeInsets.only(right: 20.0, top: 5),
                    alignment: Alignment.centerRight,
                    child: const Text(
                      "Verified",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : Container(),
            const SizedBox(height: 30.0),
            isOtpVerified == true || isOtpSend == true
                ? Container()
                : isSendOtpApiProcessing == true
                    ? Container(
                        height: 60,
                        alignment: Alignment.center,
                        width: 80,
                        child: const GFLoader(type: GFLoaderType.circle),
                      )
                    : GestureDetector(
                        onTap: () {
                          if (_mobileController.text.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "Please Enter mobile number",
                              backgroundColor: Colors.grey,
                            );
                          } else {
                            sendSignUpOtpApi(_mobileController.text);
                          }
                        },
                        child: Container(
                          width: 200,
                          alignment: Alignment.center,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryButtonColor,
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
            isOtpSend == true ? verifyOtpUi(_mobileController.text) : Container(),
            isOtpVerified == true ? showDetails() : Container()
          ],
        ),
      ),
    );
  }

  Widget formUiVendor() {
    return Container(
      margin: const EdgeInsets.only(right: 20, top: 20, left: 20),
      child: Form(
        key: formGlobalKey,
        child: Column(
          children: [
            Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Name",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 45,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TextFormField(
                      controller: _nameControllerVendor,
                      validator: (name) {
                        if (isNameValid(name!)) {
                          return null;
                        } else {
                          return 'Please enter your name';
                        }
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 15, 0, 0),
                          hintText: 'Please enter your name',
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          )),
                      // style: AppTheme.form_field_text,
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ),
              ],
            )),
            const SizedBox(height: 20.0),
            Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Email Id",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 45,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TextFormField(
                      controller: _emailControllerVendor,
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
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 15, 0, 0),
                          hintText: 'Please enter your email id',
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          )),
                      // style: AppTheme.form_field_text,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),
              ],
            )),
            const SizedBox(height: 20.0),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Mobile Number",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
/*                          SizedBox(
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
                          )*/

                      Container(
                        child: IntlPhoneField(
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                              hintText: 'Please enter your mobile no',
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              )),
                          focusNode: _focus,
                          initialCountryCode: country_code,
                          controller: _mobileControllerVendor,
                          onCountryChanged: (country) {
                            setState(() {
                              country_code = country.code;
                              phone_code = country.dialCode;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
            isOtpVerified == true
                ? Container(
                    margin: const EdgeInsets.only(right: 20.0, top: 5),
                    alignment: Alignment.centerRight,
                    child: const Text(
                      "Verified",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : Container(),
            const SizedBox(height: 30.0),
            isOtpVerified == true || isOtpSend == true
                ? Container()
                : isSendOtpApiProcessing == true
                    ? Container(
                        height: 60,
                        alignment: Alignment.center,
                        width: 80,
                        child: const GFLoader(type: GFLoaderType.circle),
                      )
                    : GestureDetector(
                        onTap: () {
                          if (_mobileControllerVendor.text.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "Please Enter mobile number",
                              backgroundColor: Colors.grey,
                            );
                          } else {
                            sendSignUpOtpApi(_mobileControllerVendor.text);
                          }
                        },
                        child: Container(
                          width: 200,
                          alignment: Alignment.center,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryButtonColor,
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
            isOtpSend == true ? verifyOtpUi(_mobileControllerVendor.text) : Container(),
            isOtpVerified == true ? showDetailsVendor() : Container()
          ],
        ),
      ),
    );
  }

  bool isValidMobileNumber() {
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(mobile_number)) {
      return false;
    }

    return true;
  }

  Widget showDetails() {
    return Column(
      children: <Widget>[
        isSignUpApiprocessing == true
            ? Container(
                height: 60,
                alignment: Alignment.center,
                width: 80,
                child: const GFLoader(type: GFLoaderType.circle),
              )
            : GestureDetector(
                onTap: () {
                  if (_mobileController.text.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please Enter mobile number",
                      backgroundColor: Colors.grey,
                    );
                  } else {
                    signUpApi();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  height: 45,
                  decoration: BoxDecoration(
                    color: primaryButtonColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 50,
                          color: Color(0xffEEEEEE)),
                    ],
                  ),
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
      ],
    );
  }

  Widget showDetailsVendor() {
    return Column(
      children: <Widget>[
        isSignUpApiprocessing == true
            ? Container(
                height: 60,
                alignment: Alignment.center,
                width: 80,
                child: const GFLoader(type: GFLoaderType.circle),
              )
            : GestureDetector(
                onTap: () {
                  signUpApiVendor();
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  height: 45,
                  decoration: BoxDecoration(
                    color: primaryButtonColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 50,
                          color: Color(0xffEEEEEE)),
                    ],
                  ),
                  child: Text(
                    "SIGN UP & NEXT",
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
        const Text(
          "Resend Code in ",
          style: TextStyle(fontSize: 14),
        ),
        TweenAnimationBuilder(
          tween: Tween(begin: 30.0, end: 0.0),
          duration: const Duration(seconds: 30),
          builder: (_, dynamic value, child) => Text(
            "00:${value.toInt()}",
            style: TextStyle(color: primaryButtonColor),
          ),
        ),
      ],
    );
  }

  Widget verifyOtpUi(String mobile) {
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
                  val_one = value;
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
                onChanged: (value) {
                  val_two = value;
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
                onChanged: (value) {
                  val_three = value;
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
                  val_four = value;
                  if (value.length == 1) {
                    pin4FocusNode!.unfocus();
                    // Then you need to check is the code is correct or not
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        TextButton(
          onPressed: () => {},
          child: const Text(
            'Resend OTP',
            style: TextStyle(color: Colors.deepOrange),
          ),
        ),
        const SizedBox(height: 15.0),
        isVerifyOtpApiProcessing == true
            ? Container(
                height: 60,
                alignment: Alignment.center,
                width: 80,
                child: GFLoader(type: GFLoaderType.circle),
              )
            : GestureDetector(
                onTap: () {
                  if (validationOtp()) {
                    verifySignUpOtpApi(mobile);
                  }
                },
                child: Container(
                  width: 200,
                  alignment: Alignment.center,
                  // margin: EdgeInsets.only(left: 10, right: 10),

                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: primaryButtonColor,
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
      isSendOtpApiProcessing = true;
    });

    final body = {
      "mobile_number": mobileNumber,
      "admin_auto_id": admin_auto_id,
    };

    var url = baseUrl + 'api/' + send_registration_otp;

    var uri = Uri.parse(url);

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      isSendOtpApiProcessing = false;

      final resp = jsonDecode(response.body);
      String status = resp['status'];

      if (status == "1") {
        isOtpSend = true;
        isOtpVerified = false;
      } else if (status == "0") {
        isOtpSend = false;
        isOtpVerified = true;
      }
      setState(() {});
    }
  }

  Future verifySignUpOtpApi(String mobile) async {
    setState(() {
      isVerifyOtpApiProcessing = true;
    });

    final body = {
      "mobile_number": mobile,
      "otp": otp,
      "admin_auto_id": admin_auto_id,
    };

    var url = baseUrl + 'api/' + verify_registration_otp;

    print("Url ${url}");
    print("body ${body}");

    var uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    print("res ${response.body}");
    if (response.statusCode == 200) {
      isVerifyOtpApiProcessing = false;

      final resp = jsonDecode(response.body);
      String status = resp['status'];

      if (status == "1") {
        isOtpSend = false;
        isOtpVerified = true;
        isVerifyOtpApiProcessing = false;
      } else {
        String msg = resp['msg'];
        Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.grey,
        );
      }

      setState(() {});
    }
  }

  Future signUpApi() async {
    setState(() {
      isSignUpApiprocessing = true;
    });
    if (_nameController == null) {
      _nameController.text = '';
    }
    final body = {
      "mobile_number": _mobileController.text,
      "name": _nameController.text,
      "email_id": _emailController.text,
      "update_on_whatsapp": 'no',
      "have_retail_shop": 'no',
      "user_type": userType,
      "country_code": c.countries[0].code + '-' + c.countries[0].dialCode,
      "country_name": country_name,
      "admin_auto_id": admin_auto_id,
      "token": token
    };

    print("customer sign up body ${body}");

    var url = baseUrl + 'api/' + user_registration;

    var uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isSignUpApiprocessing = false;

      final resp = jsonDecode(response.body);
      String status = resp['status'];
      if (status == "1") {
        String userAutoId = resp['user_auto_id'];
        String userType = resp['user_type'];
        // String category_id = resp['category_id'];
        Fluttertoast.showToast(
          msg: "You have signed up successfully",
          backgroundColor: Colors.grey,
        );
        saveLoginSession(userAutoId, userType, '');
      } else {
        String msg = resp['msg'];
        Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.grey,
        );
      }

      setState(() {});
    }
  }

  Future signUpApiVendor() async {
    setState(() {
      isSignUpApiprocessing = true;
    });
    if (_nameController == null) {
      _nameController.text = '';
    }
    final body = {
      "mobile_number": _mobileControllerVendor.text,
      "name": _nameControllerVendor.text,
      "email_id": _emailControllerVendor.text,
      "update_on_whatsapp": 'no',
      "have_retail_shop": 'no',
      "user_type": "Vendor",
      "country_code": c.countries[0].code + '-' + c.countries[0].dialCode,
      "country_name": country_name,
      "admin_auto_id": admin_auto_id,
      "token": token
    };

    var url = baseUrl + 'api/' + user_registration;
    print("vendor signup body ${body}");

    var uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isSignUpApiprocessing = false;

      final resp = jsonDecode(response.body);
      String status = resp['status'];
      if (status == "1") {
        String userAutoId = resp['user_auto_id'];
        String userType = resp['user_type'];
        // String category_id = resp['category_id'];
        Fluttertoast.showToast(
          msg: "You have signed up successfully",
          backgroundColor: Colors.grey,
        );
        saveLoginSessionVendor(userAutoId, userType, '');
      } else {
        String msg = resp['msg'];
        Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.grey,
        );
      }

      setState(() {});
    }
  }

  bool validationOtp() {
    otp = val_one + val_two + val_three + val_four;

    if (otp.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter otp",
        backgroundColor: Colors.grey,
      );
      return false;
    } else if (otp.length < 4) {
      Fluttertoast.showToast(
        msg: "Please enter valid otp",
        backgroundColor: Colors.grey,
      );
      return false;
    }
    return true;
  }

  Future<void> saveLoginSession(
      String userAutoId, String userType, String category_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('is_login', true);
    prefs.setString('user_id', userAutoId);
    prefs.setString('user_type', userType);
    prefs.setString('app_type_id', category_id);

    Fluttertoast.showToast(
      msg: "Signed in successfully",
      backgroundColor: Colors.grey,
    );

    Navigator.of(context).pushNamedAndRemoveUntil(
        HomeScreen.routeName, (Route<dynamic> route) => false);
  }

  Future<void> saveLoginSessionVendor(
      String userAutoId, String userType, String category_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('is_login', true);
    prefs.setString('user_id', userAutoId);
    prefs.setString('user_type', userType);
    prefs.setString('app_type_id', category_id);

    Fluttertoast.showToast(
      msg: "Signed in successfully",
      backgroundColor: Colors.grey,
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => VendorSignupCatagory()),
    );
  }

  void generateFirebaseToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken != null) {
      token = fcmToken;
      if (this.mounted) {
        setState(() {});
      }
    }
  }
}
