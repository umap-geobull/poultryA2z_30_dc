import 'dart:convert';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/ImageSubscription/SubscriptionPlanModel/GetImageplanStatusModel.dart';
import 'package:poultry_a2z/ImageSubscription/SubscriptionPlanModel/ImageSubscriptionPlanModel.dart';
import 'package:poultry_a2z/PicEditor/utils/styling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import '../Admin_add_Product/constants.dart';
import '../ImageSubscription/SubscriptionPlanModel/ImageSubHistoryModel.dart';
import '../Utils/AppConfig.dart';
import '../Utils/App_Apis.dart';
import 'GalleryModel.dart';
import 'ImageSubscription.dart';
import 'api/ApiClient.dart';
import 'model/add_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class RemoveBackground extends StatefulWidget {
  @override
  _RemoveBackgroundState createState() => new _RemoveBackgroundState();
}

class _RemoveBackgroundState extends State<RemoveBackground> {
  Uint8List? imageFile;
  String user_id = "";
  String? imagePath = "";
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  ScreenshotController screenshotController = ScreenshotController();
  List<AddText> addTextList = [];
  String Imagepath = "", Image_type = "Product";
  int selectedFrame = 1;
  bool isaddApiCallProcessing = false, isApiCallProcessing = false;
  String baseUrl = "";
  late File icon_img;
  Color appBarColor = Colors.white,
      appBarIconColor = Colors.black,
      primaryButtonColor = Colors.orange,
      secondaryButtonColor = Colors.orangeAccent;
  List<GetGalleryImages> galleryImagesList = [];
  String plan = "", plan_auto_id = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    secureScreen();
    getappUi();
    getBaseUrl();
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

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
      print(this.primaryButtonColor.value.toString());
    }

    if (secondaryButtonColor != null) {
      this.secondaryButtonColor = Color(int.parse(secondaryButtonColor));
      print(this.secondaryButtonColor.value.toString());
    }

    if (this.mounted) {
      setState(() {});
    }
  }

  void getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? baseUrl =prefs.getString('base_url');
    // String? userType =prefs.getString('user_type');
    String? userId = prefs.getString('user_id');

    if (userId != null && baseUrl != null) {
      setState(() {
        user_id = userId;
        this.baseUrl = AppConfig.grobizBaseUrl;
        getimageplanstatus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text('Remove Bg',
              style: TextStyle(
                  color: appBarIconColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
              color: appBarIconColor,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          actions: [
            Container(
              child: GestureDetector(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 35,
                        width: 85,
                        margin: EdgeInsets.only(top: 0, right: 15),
                        decoration: BoxDecoration(
                          color: primaryButtonColor,
                          border: Border.all(
                            color: primaryButtonColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Expanded(
                          flex: 1,
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: 85,
                                decoration: BoxDecoration(
                                  // color: primaryButtonColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      bottomRight: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0)),
                                ),
                                child: Text(
                                  "Remove Bg",
                                  style: AppTheme.small_button_text_style,
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    // if (plan == 'Purchased') {
                      imageFile = await ApiClient().removeBgApi(imagePath!);
                      // updatecount();
                      setState(() {});
                    // } else if (plan == 'no plan purchase' ||
                    //     plan == "" ||
                    //     plan == 'Expired') {
                    //   // showplans();
                    //   imageFile = await ApiClient().removeBgApi(imagePath!);
                    //   setState(() {});
                    // }
                  }),
            ),
            // IconButton(
            //     color: appBarIconColor,
            //     onPressed: () async {
            //       if(plan=='Purchased'){
            //       imageFile = await ApiClient().removeBgApi(imagePath!);
            //       // updatecount();
            //       setState(() {});}
            //       else if(plan=='no plan purchase'||plan==""||plan=='Expired'){
            //         showplans();
            //       }
            //     },
            //     icon: const Icon(Icons.cut)),
            // imagePath!=""?IconButton(
            //     color: appBarIconColor,
            //     onPressed: () async {
            //       // getimagefile();
            //     },
            //     icon: const Icon(Icons.save)):Container()
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                  onTap: showImageDialog,
                  child: Screenshot(
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      decoration: new BoxDecoration(
                        color: pickerColor,
                        image: new DecorationImage(
                          image: new AssetImage(Imagepath),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: (imageFile != null)
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 1.8,
                              child: Image.memory(
                                imageFile!,
                              ))
                          : Stack(children: [
                        Container(
                          width: 300,
                          height: MediaQuery.of(context).size.height / 1.8,
                          color: Colors.grey[300]!,
                          child: Image.asset('assets/gallery.png'),
                        ),
                        Container(
                          width: 300,
                            margin: EdgeInsets.only(top: 280),
                            color: Colors.grey[300]!,
                          alignment: Alignment.center,
                          child:Text('Tap to upload image')
                        )
                      ],)
                    ),
                    controller: screenshotController,
                  )),
              showEditOptions(),
              SizedBox(
                height: 15,
              ),
              showFrames(),
            ],
          ),
        ));
  }

  Widget showFrames() {
    return Container(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedFrame == 1
                          ? Colors.green
                          : Colors.transparent,
                      width: selectedFrame == 1 ? 2 : 0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  height: 90,
                  width: 90,
                  child: GestureDetector(
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        // color: white,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                              'assets/images/frame1.png'))),
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Container())),
                        )),
                    onTap: () => setState(() {
                      selectedFrame = 1;
                      Imagepath = 'assets/images/frame1.png';
                    }),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedFrame == 2
                          ? Colors.green
                          : Colors.transparent,
                      width: selectedFrame == 2 ? 2 : 0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  height: 90,
                  width: 90,
                  child: GestureDetector(
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: white,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                              'assets/images/frame2.jpg'))),
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Container())),
                        )),
                    onTap: () => setState(() {
                      selectedFrame = 2;
                      Imagepath = 'assets/images/frame2.jpg';
                    }),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedFrame == 3
                          ? Colors.green
                          : Colors.transparent,
                      width: selectedFrame == 3 ? 2 : 0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  height: 90,
                  width: 90,
                  child: GestureDetector(
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: white,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                              'assets/images/frame3.jpg'))),
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Container())),
                        )),
                    onTap: () => setState(() {
                      selectedFrame = 3;
                      Imagepath = 'assets/images/frame3.jpg';
                    }),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedFrame == 4
                          ? Colors.green
                          : Colors.transparent,
                      width: selectedFrame == 4 ? 2 : 0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  height: 90,
                  width: 90,
                  child: GestureDetector(
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: white,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                              'assets/images/frame4.png'))),
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Container())),
                        )),
                    onTap: () => setState(() {
                      selectedFrame = 4;
                      Imagepath = 'assets/images/frame4.png';
                    }),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedFrame == 5
                          ? Colors.green
                          : Colors.transparent,
                      width: selectedFrame == 5 ? 2 : 0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  height: 90,
                  width: 90,
                  child: GestureDetector(
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: white,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                              'assets/images/frame5.png'))),
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Container())),
                        )),
                    onTap: () => setState(() {
                      selectedFrame = 5;
                      Imagepath = 'assets/images/frame5.png';
                    }),
                  ),
                ),
                // SizedBox(width: 10,),
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==6 ? Colors.green: Colors.transparent,
                //       // width: selectedFrame==6 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/frame6.png')
                //                       )
                //                   ),
                //                   height: 15,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=6;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==7 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==7 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/frame7.png')
                //                       )
                //                   ),
                //                   height: 15,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=7;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==8 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==8 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/frame8.png')
                //                       )
                //                   ),
                //                   height: 15,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=8;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==9 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==9 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/frame9.png')
                //                       )
                //                   ),
                //                   height: 15,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=9;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==10 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==10 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/10.png')
                //                       )
                //                   ),
                //                   height: 15,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=10;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==11 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==11 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/11.png')
                //                       )
                //                   ),
                //                   height: 15,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=11;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==12 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==12 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/12.png')
                //                       )
                //                   ),
                //                   height: MediaQuery.of(context).size.height,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=12;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==13 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==13 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/13.png')
                //                       )
                //                   ),
                //                   height: MediaQuery.of(context).size.height,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=13;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
                //
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==14 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==14 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/14.png')
                //                       )
                //                   ),
                //                   height: 17,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=14;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
                //
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==15 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==15 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/15.png')
                //                       )
                //                   ),
                //                   height: 17,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=15;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
                //
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==16 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==16 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/16.png')
                //                       )
                //                   ),
                //                   height: MediaQuery.of(context).size.height,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=16;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
                //
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==17 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==17 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/17.png')
                //                       )
                //                   ),
                //                   height: MediaQuery.of(context).size.height,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=17;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
                //
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==18 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==18 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/18.png')
                //                       )
                //                   ),
                //                   height: 17,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=18;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
                //
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==19 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==19 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/19.png')
                //                       )
                //                   ),
                //                   height: MediaQuery.of(context).size.height,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=19;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
                //
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==20 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==20 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/20.png')
                //                       )
                //                   ),
                //                   height: MediaQuery.of(context).size.height,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=20;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
                //
                //
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==21 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==21 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/21.png')
                //                       )
                //                   ),
                //                   height: 17,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=21;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
                //
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==22 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==22 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/22.png')
                //                       )
                //                   ),
                //                   height: 17,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=22;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
                //
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==23 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==23 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/23.png')
                //                       )
                //                   ),
                //                   height:17,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=23;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
                //
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==24 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==24 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/24.png')
                //                       )
                //                   ),
                //                   height: MediaQuery.of(context).size.height,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=24;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
                //
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==25 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==25 ? 2: 0,
                //     ),
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   height: 90,
                //   width: 90,
                //   child: GestureDetector(
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)
                //         ),
                //         color: white,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           child:Align(
                //               alignment: Alignment.bottomCenter,
                //               child:  Container(
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           fit: BoxFit.fill,
                //                           image: AssetImage('assets/images/25.png')
                //                       )
                //                   ),
                //                   height: MediaQuery.of(context).size.height,
                //                   width: MediaQuery.of(context).size.width,
                //                   child: Container(
                //                   )
                //               )
                //           ),
                //         )
                //     ),
                //     onTap: ()=> setState(() {selectedFrame=25;}),
                //
                //   ),
                // ),
                // SizedBox(width: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showImageDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: const Text(
            'Upload image from',
            style: TextStyle(color: Colors.black87),
          ),
          content: SizedBox(
            height: 110,
            child: Column(
              children: <Widget>[
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      getImage(ImageSource.camera);
                    },
                    child: const Text("Camera",
                        style: TextStyle(color: Colors.black54, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.greenAccent,
                      onPrimary: Colors.greenAccent,
                      minimumSize: const Size(150, 30),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      getImage(ImageSource.gallery);
                    },
                    child: const Text("Gallery",
                        style: TextStyle(color: Colors.black54, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                      onPrimary: Colors.grey,
                      minimumSize: const Size(150, 30),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget showEditOptions() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Container(
                //   child: GestureDetector(
                //       child:Column(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: <Widget>[
                //           Container(
                //             height: 45,
                //             width: 90,
                //             decoration: BoxDecoration(
                //               color: primaryButtonColor,
                //               border: Border.all(
                //                 color: primaryButtonColor,
                //                 width: 1,
                //               ),
                //               borderRadius: BorderRadius.circular(6.0),
                //             ),
                //             child:  Expanded(
                //                 flex: 1,
                //                   child: Container(
                //                       alignment: Alignment.centerRight,
                //                       child: Container(
                //                         alignment: Alignment.center,
                //                         height: 33,
                //                         width: 100,
                //                         decoration: BoxDecoration(
                //                           // color: primaryButtonColor,
                //                           shape: BoxShape.rectangle,
                //                           borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),bottomRight: Radius.circular(20.0),topRight: Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
                //                         ),
                //                         child: Text("Remove Bg",style: AppTheme.small_button_text_style,),
                //                       )
                //                   ),
                //
                //             ),
                //           ),
                //           SizedBox(height: 20,),
                //           // Text("Remove Bg",style: AppTheme.select_details_label_text_style,),
                //
                //         ],
                //       ),
                //       onTap: ()=> {
                //
                //       }
                //   ),
                // ),
                // SizedBox(width: 10,),
                Container(
                  child: GestureDetector(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.deepOrangeAccent,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Image.asset(
                              'assets/background.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Background",
                            style: AppTheme.select_details_label_text_style,
                          ),
                        ],
                      ),
                      onTap: () => {showBackgroundColorChooser()}),
                ),
                SizedBox(
                  width: 10,
                ),
                imagePath != ""
                    ? Container(
                        child: GestureDetector(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 45,
                                width: 45,
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: white,
                                  border: Border.all(
                                    color: primaryButtonColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Image.asset(
                                  'assets/save.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Save",
                                style: AppTheme.select_details_label_text_style,
                              ),
                            ],
                          ),
                          onTap: () async {
                            getimagefile();
                          },
                        ),
                      )
                    : Container(),
              ],
            )),
      ),
    );
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void updateBackgroundColor(Color color) {
    for (int i = 0; i < addTextList.length; i++) {
      if (addTextList[i].isSelected) {
        setState(() {
          addTextList[i].backgroundColor = color;
        });
      }
    }
    Navigator.pop(context);
  }

  showBackgroundColorChooser() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                  child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: changeColor,
                showLabel: true,
                colorPickerWidth: MediaQuery.of(context).size.width,
                pickerAreaHeightPercent: 0.8,
              )),
              actions: <Widget>[
                TextButton(
                  child: const Text('Got it'),
                  onPressed: () {
                    updateBackgroundColor(pickerColor);
                    Imagepath = "assets/background.jpg";
                    //setState(() => _textColor = pickerColor);
                    // Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        });
  }

  void getImage(ImageSource source) async {
    Navigator.of(context).pop(false);
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        imagePath = pickedImage.path;
        imageFile = await pickedImage.readAsBytes();
        File selectedImg = File(pickedImage.path);

        icon_img = selectedImg;
        setState(() {});
      }
    } catch (e) {
      imageFile = null;
      setState(() {});
    }
  }

  getimagefile() {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: pixelRatio //1.5
            )
        .then((capturedImage) async {
      icon_img = await getFileFromUint8list(capturedImage!);
      saveImageApi();
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }

  Future<File> getFileFromUint8list(Uint8List capturedImage) async {
    final tempDir = await getTemporaryDirectory();
    String fileName = DateTime.now().microsecondsSinceEpoch.toString() + ".png";
    final file = await new File('${tempDir.path}/' + fileName).create();
    file.writeAsBytesSync(capturedImage);

    return file;
  }

  Future saveImageApi() async {
    setState(() {
      isaddApiCallProcessing = true;
    });

    var url = baseUrl + add_banner_images;

    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);

    try {
      if (icon_img != null) {
        request.files.add(
          http.MultipartFile(
            'image_name',
            icon_img.readAsBytes().asStream(),
            await icon_img.length(),
            filename: icon_img.path.split('/').last,
          ),
        );
      } else {
        request.fields["image_name"] = '';
      }
    } catch (exception) {
      print('Image not selected');
      request.fields["image_name"] = '';
    }
    request.fields["image_type"] = Image_type;
    request.fields["user_auto_id"] = user_id;

    http.Response response =
        await http.Response.fromStream(await request.send());
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        isaddApiCallProcessing = false;
      });
      final resp = jsonDecode(response.body);
      String status = resp['status'];
      print("status=>" + status);
      if (status == '1') {
        Fluttertoast.showToast(
          msg: "Image saved successfully",
          backgroundColor: Colors.grey,
        );
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: "Something went wrong.Please try later",
          backgroundColor: Colors.grey,
        );
      }
    }
  }

  // void getimages() async {
  //   if(mounted){
  //     setState(() {
  //       isApiCallProcessing=true;
  //     });
  //   }
  //   final body = {
  //     "user_auto_id":user_id,
  //   };
  //   var url = baseUrl + get_banner_images;
  //   var uri = Uri.parse(url);
  //   final response = await http.post(uri,body: body);
  //   if (response.statusCode == 200) {
  //     isaddApiCallProcessing = false;
  //
  //     final resp = jsonDecode(response.body);
  //     int status = resp['status'];
  //     if (status == 1) {
  //       GalleryModel imagesModel =
  //       GalleryModel.fromJson(json.decode(response.body));
  //       galleryImagesList = imagesModel.data;
  //       print(galleryImagesList.toString());
  //       if (mounted) {
  //         setState(() {});
  //       }
  //     } else {
  //
  //     }
  //   }
  // }

  void getimageplanstatus() async {
    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }
    final body = {
      "admin_auto_id,": user_id,
    };
    print("user-id=" + user_id);
    var url = baseUrl + get_image_plan_status;
    //print(url);
    var uri = Uri.parse(url);
    final response = await http.post(uri, body: body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      isaddApiCallProcessing = false;

      final resp = jsonDecode(response.body);
      int status = resp['status'];
      String message = resp['msg'];
      String planstatus = resp['plan_status'];
      print("planstatus=" + planstatus);

      if (status == 1) {
        GetImageplanStatusModel imagesStatusModel =
            GetImageplanStatusModel.fromJson(json.decode(response.body));
        plan = imagesStatusModel.planStatus;
        print("plan=" + plan);
        if (mounted) {
          setState(() {});
        }
      } else {}
    } else if (response.statusCode == 500) {
      plan = "";
    }
  }

  Future<void> updatecount() async {
    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }
    final body = {
      "admin_auto_id": user_id,
      "plan_auto_id": "",
      "image_count": "1",
    };

    var url = baseUrl + update_image_plan_count;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing = false;

      final resp = jsonDecode(response.body);
      int status = resp['status'];
      print("status=>" + status.toString());
      if (status == 1) {
        // Fluttertoast.showToast(
        //   msg: "Profile Updated successfully",
        //   backgroundColor: Colors.grey,
        // );
        // Navigator.pop(context);
      } else {
        print('empty');
      }

      if (mounted) {
        setState(() {});
      }
    }
  }

  showplans() {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return ImageSubscription();
        });
  }
}
