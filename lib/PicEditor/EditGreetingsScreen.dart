
// ignore_for_file: file_names

//import 'dart:html';
//import 'package:async/async.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
import 'package:poultry_a2z/PicEditor/utils/colors.dart';
import 'package:poultry_a2z/PicEditor/utils/images.dart';
import 'package:poultry_a2z/PicEditor/utils/styling.dart';
import 'package:poultry_a2z/PicEditor/widgets/add_sticker_bottomsheet.dart';
import 'package:poultry_a2z/PicEditor/widgets/greeting_child.dart';
import 'package:poultry_a2z/PicEditor/widgets/image_child.dart';
import 'package:poultry_a2z/PicEditor/widgets/logo_child.dart';
import 'package:poultry_a2z/PicEditor/widgets/name_child.dart';
import 'package:poultry_a2z/PicEditor/widgets/sticker_child.dart';
import 'package:poultry_a2z/PicEditor/widgets/text_child.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


import 'package:dotted_border/dotted_border.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../Utils/AppConfig.dart';
import '../Utils/App_Apis.dart';
import 'GreetingDetailsModel.dart';
import 'ZoomExp.dart';
import 'api/all_urls.dart';
import 'model/StickerModel.dart';
import 'model/add_image.dart';
import 'model/add_name.dart';
import 'model/add_sticker.dart';
import 'model/add_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class EditGreetingsScreen extends StatefulWidget{
  String selectedImage='';
  double  greeting_x,greeting_y;

  EditGreetingsScreen(this.greeting_x,this.greeting_y,this.selectedImage);

  @override
  _EditGreetingsScreenState createState() => _EditGreetingsScreenState(greeting_x,greeting_y,selectedImage);

}

class _EditGreetingsScreenState extends State<EditGreetingsScreen> with TickerProviderStateMixin{
  String selectedImage='';
  double  x,y;

  _EditGreetingsScreenState(this.x,this.y,this.selectedImage);

  bool isApiCallProcess=false;
  String baseUrl="",user_id="";
 String Image_type="Offer";
  bool isShareShow=false;

  //font
  double width = 0.0, height = 0.0;


  late Offset text_position;
  late Offset name_position;
  late Offset logo_position;
  late Offset email_position;
  late Offset contact_position;
  late Offset website_position;
  late Offset location_position;

  double fontSizeName=30,_textSize=20,other_textSize=8;
  Color _textColor=Colors.red,_textColorOther1=Colors.white,_textColorOther2=Colors.black;
  Color _backgroundColor=Colors.transparent;
  String _fontFamilyOther="Roboto";
  FontWeight _fontWeight=FontWeight.bold, _fontWeightName=FontWeight.bold,_fontWeightOther=FontWeight.normal;
  TextStyle? _selectedFontTextStyle;

  String text='',location='',website='',primary_mobile='',secondary_mobile='',email='',name='',logo='';

  bool isAddText=false,isAddName=true,isAddLogo=true,isAddEmail=true,isAddWebsite=true,isAddContact=true,isAddLocation=true;
  bool isTextSelected=false,isNameSelected=false,isLogoSelected=false,isEmailSelected=false,isWebsiteSelected=false,isContactSelected=false,
      isLocationSelected=false;

  Color _addTextColor=Colors.black, _textColorName=Colors.black,_textColorEmail=Colors.black,_textColorContact=Colors.black,
      _textColorWebsite=Colors.black, _textColorLocation=Colors.black;

  String _fontFamilyText = "Roboto",_fontFamilyName="Roboto",_fontFamilyEmail="Roboto",_fontFamilyMobile="Roboto",
      _fontFamilyWebsite="Roboto",_fontFamilyLocation="Roboto";

  late AnimationController controller;
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  var nameFocus=FocusNode();

  int selectedFrame=1;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  static final TextStyle normal_font= TextStyle(
      color: white,
      fontSize: 10);

  double _x_logo = 0.0;
  double _y_logo = 0.0;
  double _x_text = 0.0;
  double _y_text = 0.0;
  double _x_name = 0.0;
  double _y_name = 0.0;
  var app_bar_height = AppBar().preferredSize.height;

  double _zoom=1.0;
  double _previousZoom=0.1;
  Offset _position=Offset(0.0, 0.0);


  double minScale = 0.03;
  double maxScale = 0.6;
  double defScale = 0.1;
  late PhotoViewScaleStateController scaleStateController;
  late PhotoViewControllerBase photo_controller;
  int calls = 0;

  bool showLogoSelected=false,showSliderSelected=false;
  bool islogoTimerint=false,isslidertimerinit=false;

  final dynamic minScale_greeting=0.01;
  final dynamic maxScale_greeting=1.0;
  // ImageProvider imageProvider= AssetImage('assets/images/cat_1.png');

  bool isGreetingImageUploaded=false;
  late File greetingImage;
  final ImagePicker _picker = ImagePicker();

  List<AddText> addTextList=[];
  List<AddImages> addImagesList=[];
  List<AddStricker> addStickerList=[];
  List<AllStickerImages> stickerCategories=[];

  bool select_logo=false;
  late File icon_img;

  bool isAnyStickerSelected(){
    for(int i=0;i<addStickerList.length;i++){
      if(addStickerList[i].isSelected){
        return true;
      }
    }

    return false;
  }

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    // String? userType =prefs.getString('user_type');
    String? userId = prefs.getString('user_id');

    if (userId != null && baseUrl!=null) {
      setState(() {
        user_id = userId;
        this.baseUrl=AppConfig.grobizBaseUrl;

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: ()=>_onBackPressed(),
      child: new Scaffold(
          resizeToAvoidBottomInset: false,
          body:SafeArea(
            child:Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                      children:<Widget>[
                        showHeader(),
                        showSelectedImage(),
                        Expanded(
                            flex:1,
                            child: Container(
                                child:SingleChildScrollView(
                                    child:Column(
                                      children: <Widget> [
                                        showFrames(),
                                        SizedBox(height: 15,),
                                        // showDetails(),
                                        SizedBox(height: 15,),
                                        showEditOptions(),
                                      ],
                                    )
                                )
                            )
                        )
                      ]
                  ),
                  color: app_background,
                ),
                // showShare()
              ],
            ),
          )
      ),
    );

  }

  Alignment getPostion(){
    Alignment position=Alignment.center;

    if(x>=35 && x<=70 && y>=35 && y<=70){
      position=Alignment.center;
    }
    else if(x<=50 && y<=50){
      if(x>=35){
        position=Alignment.topCenter;
      }
      else if( y>=35){
        position=Alignment.centerLeft;
      }
      else{
        position=Alignment.topLeft;
      }
    }
    else if(x<=50 && y>=50){
      if(y<=70){
        position=Alignment.centerLeft;
      }
      else if(x>=35){
        position=Alignment.bottomCenter;
      }
      else{
        position=Alignment.bottomLeft;
      }
    }
    else if(x>=50 && y<=50){
      if(x<=70){
        position=Alignment.topCenter;
      }
      if(y>=35){
        position=Alignment.centerRight;
      }
      else{
        position=Alignment.topRight;
      }
    }
    else if(x>=50 && y>=50){
      if(x<=70){
        position=Alignment.bottomCenter;
      }
      else if(y<=70){
        position=Alignment.centerRight;
      }
      else{
        position=Alignment.bottomRight;
      }
    }

    return position;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    secureScreen();
    getBaseUrl();

    width=350;
    height=350;

    name_position = Offset(width-100, 20);
    logo_position = Offset(0.0, 0.0);
    text_position = Offset(width-(width/2), height-(height/2));

    //_requestPermission();
  }
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
  void showprogressDialog(String msg){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
          backgroundColor: primaryColor,
          content: new Container(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(msg,style: TextStyle(color: white),),
                SizedBox(height: 10,),
                Center(
                  child: CircularProgressIndicator(),
                )
              ],
            ),
          )
      ),
    ) ;
  }

  Widget showHeader() {
    return  Container(
      height: 70,
      padding: EdgeInsets.all(10),
      child:Container(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 20,
                      width: 20,
                      child: Image.asset('assets/backpress.png'),
                    )
                ),
                onTap: ()=> _onBackPressed(),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(

              ),
            ),
            Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        alignment: Alignment.center,
                        height: 33,
                        width: 90,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),bottomRight: Radius.circular(20.0),topRight: Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
                        ),
                        child: Text("Save",style: AppTheme.small_button_text_style,),
                      )
                  ),
                  onTap: ()=> {
                    onNextPressed()
                  },
                )
            )
          ],
        ),
      ),
    );
  }

  // Widget showShare(){
  //   if(isShareShow){
  //     return
  //       Container(
  //       height: MediaQuery.of(context).size.height,
  //       width: MediaQuery.of(context).size.width,
  //       child:Stack(
  //         children: <Widget>[
  //           Opacity(
  //             opacity: 0.5,
  //             child: ModalBarrier(dismissible: false, color: Colors.grey),
  //           ),
  //           Center(
  //               child: Wrap(
  //                 children: <Widget>[
  //                   Container(
  //                     margin: EdgeInsets.all(30),
  //                     width: MediaQuery.of(context).size.width,
  //                     padding: EdgeInsets.all(20),
  //                     decoration: BoxDecoration(
  //                       color: white,
  //                       shape: BoxShape.rectangle,
  //                       border: Border.all(
  //                         color: primaryColor,
  //                         width: 1,
  //                       ),
  //                       borderRadius: BorderRadius.circular(20),
  //                     ),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: <Widget>[
  //                         Text("SAVE & SHARE",style: AppTheme.dialog_title_text_style,),
  //                         Container(
  //                           margin: EdgeInsets.only(top: 10),
  //                           height: 300,
  //                           decoration: BoxDecoration(
  //                             color: white,
  //                             shape: BoxShape.rectangle,
  //                             border: Border.all(
  //                               color: primaryColor,
  //                               width: 1,
  //                             ),
  //                             borderRadius: BorderRadius.circular(20),
  //                           ),
  //                           child: Image.asset(Images.fest_3,fit: BoxFit.fill,),
  //                         ),
  //                         Container(
  //                             width: MediaQuery.of(context).size.width,
  //                             alignment: Alignment.center,
  //                             margin: EdgeInsets.only(top: 20),
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               children: <Widget>[
  //                                 GestureDetector(
  //                                   child: Container(
  //                                     height: 40,
  //                                     width: 40,
  //                                     child: Image.asset(Images.save,fit: BoxFit.fill,),
  //                                   ),
  //                                   onTap: ()=>{},
  //                                 ),
  //                                 SizedBox(width: 50,),
  //                                 GestureDetector(
  //                                   child: Container(
  //                                     height: 40,
  //                                     width: 40,
  //                                     child: Image.asset(Images.share,fit: BoxFit.fill,),
  //                                   ),
  //                                   onTap: ()=>{},
  //                                 ),
  //                               ],
  //                             )
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //
  //                 ],))
  //         ],
  //       ),
  //     );
  //   }
  //   else{
  //     return Container();
  //   }
  // }

  Future getCameraImage() async {
    Navigator.of(context).pop(false);

    var image = await _picker.pickImage(source: ImageSource.camera);

    if(image!=null){
      cropImage(image);
    }
  }

  Future getGalleryImage() async {
    Navigator.of(context).pop(false);

    var image = await _picker.pickImage(source: ImageSource.gallery);

    if(image!=null){
      cropImage(image);
    }
  }

  cropImage (XFile image) async {

    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings:[
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ]
    );

    if(croppedFile!=null){
      setState(() {
        File img= File(croppedFile.path);
        greetingImage = img;
        isGreetingImageUploaded=true;
      });
    }
  }

  showChangeImageDialog() async{
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
          backgroundColor: primaryColor,
          content: new Container(
            height: 78,
            child: Column(
              children: <Widget>[
                Text('Do you want to change image?',style: TextStyle(color: white),),
                SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.pop(context);
                            showImageDialog();
                          },
                          child: Text("Yes",style: AppTheme.alert_dialog_action,),
                          style: ElevatedButton.styleFrom(
                            primary: secondaryColor,
                            onPrimary: secondaryColor,
                            minimumSize: Size(70,30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        )
                    ),
                    SizedBox(width: 10,),
                    Container(
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.of(context).pop(false);
                          },
                          child: Text("No",style: AppTheme.alert_dialog_action,),
                          style: ElevatedButton.styleFrom(
                            primary: secondaryColor,
                            onPrimary: secondaryColor,
                            minimumSize: Size(70,30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        )
                    ),
                  ],
                )
              ],
            ),
          )
      ),
    ) ;

  }

  showImageDialog() async{
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
          backgroundColor: primaryColor,
          title: new Text('Upload image from',style: TextStyle(color: white),),
          content: new Container(
            height: 110,
            child: Column(
              children: <Widget>[
                Container(
                  child:
                  ElevatedButton(
                    onPressed: (){
                      getCameraImage();
                    },
                    child: Text("Camera",style: AppTheme.alert_dialog_action,),
                    style: ElevatedButton.styleFrom(
                      primary: secondaryColor,
                      onPrimary: secondaryColor,
                      minimumSize: Size(MediaQuery.of(context).size.width,40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  child: ElevatedButton(
                    onPressed: (){
                      getGalleryImage();
                    },
                    child: Text("Gallery",style: AppTheme.alert_dialog_action,),
                    style: ElevatedButton.styleFrom(
                      primary: secondaryColor,
                      onPrimary: secondaryColor,
                      minimumSize: Size(MediaQuery.of(context).size.width,40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          )
      ),
    ) ;
  }

  Widget showSelectedImage() {

    return  Container(
        margin: EdgeInsets.only(bottom: 20),
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        child:Screenshot(
          controller: screenshotController,
          child: Container(
            child: Stack(
              children: <Widget>[
                //image
                Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                  child: isGreetingImageUploaded?

                Container(
                      height: 350,
                      width: 350,
                      alignment: getPostion(),
                      child:GreetingChild(greetingImage)
                    ):
                    Container(
                      alignment: getPostion(),
                      child: GestureDetector(
                        onTap: ()=>showImageDialog(),
                        child: Container(
                            height: 70,
                            width: 100,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: primaryColor,
                                    width: 1
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),

                            child: Column(
                              children: <Widget>[
                                Icon(Icons.camera_alt,color: Colors.grey,),
                                SizedBox(height: 5,),
                                Text('Select Photo',style: TextStyle(color: primaryColor,fontSize: 15),)
                              ],
                            )
                        ),
                      )
                      ,
                    ),
                ),

                IgnorePointer(
                  //ignoring: false,
                  child: Image.network(selectedImage,
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,),
                ),

                /*Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    //color: Colors.white,
                    child: Image.asset(Images.circle, fit: BoxFit.fill,)
                ),*/
/*                Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[300],
                    child: Image.network(selectedImage, fit: BoxFit.fill,)
                )*/

                selectedFrame==1?
                frame_1():
                selectedFrame==2?
                frame_2():
                selectedFrame==3?
                frame_3():
                selectedFrame==4?
                frame_4():
                selectedFrame==5?
                frame_5():
                // selectedFrame==6?
                // frame_6():
                // selectedFrame==7?
                // frame_7():
                // selectedFrame==8?
                // frame_8():
                // selectedFrame==9?
                // frame_9():
                // selectedFrame==10?
                // frame_10():
                // selectedFrame==11?
                // frame_11():
                // selectedFrame==12?
                // frame_12():
                // selectedFrame==13?
                // frame_13():
                // selectedFrame==14?
                // frame_14():
                // selectedFrame==15?
                // frame_15():
                // selectedFrame==16?
                // frame_16():
                // selectedFrame==17?
                // frame_17():
                // selectedFrame==18?
                // frame_18():
                // selectedFrame==19?
                // frame_19():
                // selectedFrame==20?
                // frame_20():
                Container(),

                showName(),

                showLogo(),

                showText(),

                showImages(),

                showStickers()
              ],
            )
            ,
          ),
        ));
  }

  Widget showFrames() {
    return  Container(
      child:Container(
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
                      color: selectedFrame==1 ? Colors.green: Colors.transparent,
                      width: selectedFrame==1 ? 2: 0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  height: 90,
                  width: 90,
                  child: GestureDetector(
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        color: white,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:Align(
                              alignment: Alignment.bottomCenter,
                              child:  Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage('assets/images/frame1.png')
                                      )
                                  ),
                                  height: 15,
                                  width: MediaQuery.of(context).size.width,
                                  child: Container(
                                  )
                              )
                          ),
                        )
                    ),
                    onTap: ()=> setState(() {selectedFrame=1;}),
                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedFrame==2 ? Colors.green: Colors.transparent,
                      width: selectedFrame==2 ? 2: 0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  height: 90,
                  width: 90,
                  child: GestureDetector(
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        color: white,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:Align(
                              alignment: Alignment.bottomCenter,
                              child:  Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage('assets/images/frame2.jpg')
                                      )
                                  ),
                                  height: 15,
                                  width: MediaQuery.of(context).size.width,
                                  child: Container(
                                  )
                              )
                          ),
                        )
                    ),
                    onTap: ()=> setState(() {selectedFrame=2;}),

                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedFrame==3 ? Colors.green: Colors.transparent,
                      width: selectedFrame==3 ? 2: 0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  height: 90,
                  width: 90,
                  child: GestureDetector(
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        color: white,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:Align(
                              alignment: Alignment.bottomCenter,
                              child:  Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage('assets/images/frame3.jpg')
                                      )
                                  ),
                                  height: 15,
                                  width: MediaQuery.of(context).size.width,
                                  child: Container(
                                  )
                              )
                          ),
                        )
                    ),
                    onTap: ()=> setState(() {selectedFrame=3;}),

                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedFrame==4 ? Colors.green: Colors.transparent,
                      width: selectedFrame==4 ? 2: 0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  height: 90,
                  width: 90,
                  child: GestureDetector(
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        color: white,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:Align(
                              alignment: Alignment.bottomCenter,
                              child:  Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage('assets/images/frame4.png')
                                      )
                                  ),
                                  height: 15,
                                  width: MediaQuery.of(context).size.width,
                                  child: Container(
                                  )
                              )
                          ),
                        )
                    ),
                    onTap: ()=> setState(() {selectedFrame=4;}),

                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedFrame==5 ? Colors.green: Colors.transparent,
                      width: selectedFrame==5 ? 2: 0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  height: 90,
                  width: 90,
                  child: GestureDetector(
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        color: white,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:Align(
                              alignment: Alignment.bottomCenter,
                              child:  Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage('assets/images/frame5.png')
                                      )
                                  ),
                                  height: 15,
                                  width: MediaQuery.of(context).size.width,
                                  child: Container(
                                  )
                              )
                          ),
                        )
                    ),
                    onTap: ()=> setState(() {selectedFrame=5;}),

                  ),
                ),
                // SizedBox(width: 10,),
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: selectedFrame==6 ? Colors.green: Colors.transparent,
                //       width: selectedFrame==6 ? 2: 0,
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

  void addSticker(String sticker_image){
    setState(() {
      addStickerList.add(AddStricker(sticker_image));
    });

    Navigator.pop(context);
  }

  void showStickerBottomsheet(){
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (context){
          return AddStickerBottomsheet(this.addSticker);
        }
    );
  }

  Widget showEditOptions() {
    return  Container(
      padding: EdgeInsets.all(10),
      child: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: GestureDetector(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 45,
                            width: 45,
                            child: Image.asset('assets/add_logo.png',fit: BoxFit.fill,),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: white,
                              border: Border.all(
                                color: primaryColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text("Add Logo",style: AppTheme.select_details_label_text_style,),
                        ],
                      ),
                      onTap: ()=> {
                        showAddImageDialog()
                      }
                  ),
                ),
                SizedBox(width: 10,),

                Container(
                  child: GestureDetector(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 45,
                            width: 45,
                            child: Image.asset('assets/add_image.png',fit: BoxFit.fill,),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: white,
                              border: Border.all(
                                color: primaryColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text("Add Image",style: AppTheme.select_details_label_text_style,),
                        ],
                      ),
                      onTap: ()=> {
                        showImageDialog()
                      }
                  ),
                ),
                SizedBox(width: 10,),

                Container(
                  child: GestureDetector(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 45,
                            width: 45,
                            child: Image.asset('assets/sticker.png',fit: BoxFit.fill,),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: white,
                              border: Border.all(
                                color: primaryColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text("Add Sticker",style: AppTheme.select_details_label_text_style,),
                        ],
                      ),
                      onTap: ()=> {
                        showStickerBottomsheet()
                      }
                  ),
                ),
                SizedBox(width: 10,),

                Container(
                  child: GestureDetector(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 45,
                            width: 45,
                            child: Image.asset('assets/add_text.png',fit: BoxFit.fill,),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: white,
                              border: Border.all(
                                color: primaryColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text("Add Text",style: AppTheme.select_details_label_text_style,),
                        ],
                      ),
                      onTap: ()=> {
                        showTextDialog()
                      }

                  ),
                ),
                SizedBox(width: 10,),

              /*  Container(
                  child: GestureDetector(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 45,
                            width: 45,
                            child: Image.asset(Images.font_size,fit: BoxFit.fill,),
                          ),
                          SizedBox(height: 10,),
                          Text("Font Size",style: AppTheme.select_details_label_text_style,),
                        ],
                      ),
                      onTap: ()=> {
                        showTextSizeChooser()
                      }

                  ),
                ),
                SizedBox(width: 10,),*/

                Container(

                  child: GestureDetector(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: white,
                            border: Border.all(
                              color: primaryColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Image.asset('assets/font_style.png',fit: BoxFit.fill,),
                        ),
                        SizedBox(height: 10,),
                        Text("Font Style",style: AppTheme.select_details_label_text_style,),

                      ],
                    ),
                    onTap: ()=> { showFontChooser()},
                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  child: GestureDetector(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: white,
                              border: Border.all(
                                color: primaryColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Image.asset(Images.text_color,fit: BoxFit.fill,),
                          ),
                          SizedBox(height: 10,),
                          Text("Text Color",style: AppTheme.select_details_label_text_style,),

                        ],
                      ),
                      onTap: ()=> {
                        showTextColorChooser()
                      }
                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  child: GestureDetector(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: white,
                              border: Border.all(
                                color: primaryColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Image.asset('assets/background.png',fit: BoxFit.fill,),
                          ),
                          SizedBox(height: 10,),
                          Text("Background",style: AppTheme.select_details_label_text_style,),

                        ],
                      ),
                      onTap: ()=> {
                        showBackgroundColorChooser()
                      }
                  ),
                ),
              ],
            )
        ),
      ),
    );

  }

  onNextPressed(){
    setState(() {
      for(int i=0;i<addTextList.length;i++){
        addTextList[i].isSelected=false;
      }

      for(int i=0;i<addImagesList.length;i++){
        addImagesList[i].isSelected=false;
      }

      for(int i=0;i<addStickerList.length;i++){
        addStickerList[i].isSelected=false;
      }

      isNameSelected=false;
      isEmailSelected=false;
      isWebsiteSelected=false;
      isContactSelected=false;
      isLocationSelected=false;
    });

    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    screenshotController
        .capture(
        delay: Duration(milliseconds: 10),
        pixelRatio: pixelRatio //1.5
    )
        .then((capturedImage) async {
      icon_img= await getFileFromUint8list(capturedImage!);
      saveImageApi();
      // Navigator.push(context,  MaterialPageRoute(builder: (context) => FinalImageScreen(capturedImage!)));
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<File> getFileFromUint8list(Uint8List capturedImage) async{
    final tempDir = await getTemporaryDirectory();
    String fileName =
        DateTime.now().microsecondsSinceEpoch.toString() + ".png";
    final file = await new File('${tempDir.path}/'+fileName).create();
    // final file = await new File('${tempDir.path}/image.jpg').create();
    file.writeAsBytesSync(capturedImage);

    return file;
  }

  Future saveImageApi() async {

    setState(() {
      isApiCallProcess = true;
    });

    var url = baseUrl + add_banner_images;
    // print(baseUrl);
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
        isApiCallProcess = false;
      });
      final resp = jsonDecode(response.body);
      //String message=resp['msg'];
      String status = resp['status'];
      print("status=>"+status);
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

  void showSignupErrorDialog(String error){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
          backgroundColor: primaryColor,
          content: new Container(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(error,style: TextStyle(color: white),),
                SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text("Ok",style: AppTheme.alert_dialog_action,),
                          style: ElevatedButton.styleFrom(
                            primary: secondaryColor,
                            onPrimary: secondaryColor,
                            minimumSize: Size(70,30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        )
                    ),
                  ],
                )
              ],
            ),
          )
      ),
    ) ;
  }

  // _requestPermission() async {
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.storage,
  //   ].request();
  //
  //   final info = statuses[Permission.storage].toString();
  //   print(info);
  //   //_toastInfo(info);
  // }

  _onBackPressed() async{
    if(isShareShow){
      setState(() {
        isShareShow=false;
      });
    }
    else{
      Navigator.pop(context);
    }
  }

  //font
  showFontChooser(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
              content: SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  child: FontPicker(
                    showInDialog: true,
                    onFontChanged: (font) {
                      updateTextStyle(font);
                    },
                    //  googleFonts: _myGoogleFonts
                  ),
                ),
              ));
        }
    );
  }

  Widget showStickers(){
    return Container(
        child: addStickerList!=null && addStickerList.isNotEmpty?
        Stack(
          children: stickerData(),
        ):
        Container()
    );
  }

  showTextSizeChooser(){
    int selectedSize=15;

    List<int> fontSizeList=[];
    for(int i=0;i<100; i++){
      fontSizeList.add(i+1);
    };

    showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                  content: SingleChildScrollView(
                    child: Container(
                        width: double.maxFinite,
                        child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Select font size',
                              style: TextStyle(color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato'),
                            ),
                            SizedBox(height: 5,),
                            Container(
                                child: TextFormField(
                                  style: TextStyle(color: Colors.black,
                                      fontSize: selectedSize.toDouble(),
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Lato'),
                                  initialValue: 'Your text size will look like this',
                                ),
                                width: MediaQuery.of(context).size.width
                            ),
                            SizedBox(height: 15,),
                            Container(
                                height: 70,
                                padding: EdgeInsets.all(20),
                                color: Colors.blueGrey[100],
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(selectedSize.toString(),
                                        style: TextStyle(color: Colors.black,
                                            fontSize: 18,
                                            fontFamily: 'Lato'),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton(
                                          onPressed: () {updateTextSize(selectedSize);},

                                          child: Text("Select", style: AppTheme
                                              .alert_dialog_action,),
                                          style: ElevatedButton.styleFrom(
                                            primary: secondaryColor,
                                            onPrimary: secondaryColor,
                                            minimumSize: Size(80, 40),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width
                            ),
                            SizedBox(height: 15,),
                            Container(
                                height: 300,
                                child: new Expanded(
                                    child: ListView.builder(
                                      itemCount: fontSizeList.length,
                                      itemBuilder: (context, position) {
                                        return Wrap(
                                          children: <Widget>[
                                            Container(
                                                child: TextButton(
                                                  child: Text(
                                                    fontSizeList[position]
                                                        .toString(),),
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedSize =
                                                      fontSizeList[position];
                                                    });
                                                  },
                                                )
                                            )
                                          ],
                                        );
                                      },
                                    )
                                )
                            )
                          ],
                        )
                    ),
                  ));
            }
            );
        }
    );
  }

  showTextDialog(){
    String text='';

    showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                    content: SingleChildScrollView(
                      child: Container(
                          width: double.maxFinite,
                          child:
                          Column(
                            children: <Widget>[
                              Container(
                                  child: TextFormField(
                                    onChanged: (value)=> {
                                      text=value
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Write Here',
                                        hintStyle: TextStyle(color: Colors.grey,
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Lato')),
                                    style: TextStyle(color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Lato'),
                                  ),
                                  width: MediaQuery.of(context).size.width
                              ),
                              SizedBox(height: 15,),
                              ElevatedButton(
                                  onPressed: (){
                                    updateText(text);
                                  },
                                  child: Text("Submit",style: TextStyle(color: black,fontSize: 10),),
                                  style: ElevatedButton.styleFrom(
                                    primary: secondaryColor,
                                    onPrimary: secondaryColor,
                                    minimumSize: Size(80,30),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),bottomRight: Radius.circular(25.0)),
                                    ),
                                  )),

                              TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel",style: TextStyle(color: black,fontSize: 10),))],
                          )
                      ),
                    ));
              }
          );
        }
    );
  }

  showTextColorChooser(){
    showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                    content: SingleChildScrollView(
                      child: ColorPicker(
                          pickerColor: pickerColor,
                          onColorChanged: changeColor,
                          showLabel: true,
                          pickerAreaHeightPercent: 0.8,
                          colorPickerWidth:MediaQuery.of(context).size.width ,
                      )

                    ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Got it'),
                            onPressed: () {
                              updateTextColor(pickerColor);
                              //setState(() => _textColor = pickerColor);
                             // Navigator.of(context).pop();
                            },
                          ),
                  ],
                );
              }
          );
        }
    );
  }

  showBackgroundColorChooser(){
    showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: changeColor,
                        showLabel: true,
                        colorPickerWidth:MediaQuery.of(context).size.width ,
                        pickerAreaHeightPercent: 0.8,
                      )

                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Got it'),
                      onPressed: () {
                        updateBackgroundColor(pickerColor);
                        //setState(() => _textColor = pickerColor);
                        // Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }
          );
        }
    );
  }

  void updateTextSize(int selectedSize){
    if(isNameSelected){
      setState(() {
        fontSizeName = selectedSize.toDouble();
      });
    }

    for(int i=0;i<addTextList.length;i++){
      if(addTextList[i].isSelected){
        setState(() {
          addTextList[i].textSize = selectedSize.toDouble();
        });
      }
    }

    Navigator.pop(context);

  }

  void updateText(String text){
    setState(() {
      addTextList.add(AddText(text));
    });

    Navigator.pop(context);

  }

  void updateTextColor(Color color){

    if(isNameSelected){
      setState(() {
        _textColorName=color;
      });
    }
    if(isEmailSelected){
      setState(() {
        _textColorEmail=color;
      });
    }
    if(isLocationSelected){
      setState(() {
        _textColorLocation=color;
      });
    }
    if(isContactSelected){
      setState(() {
        _textColorContact=color;
      });
    }
    if(isWebsiteSelected){
      setState(() {
        _textColorWebsite=color;
      });
    }
    for(int i=0;i<addTextList.length;i++){
      if(addTextList[i].isSelected){
        setState(() {
          addTextList[i].textColor = color;
        });
      }
    }

    if(!isNameSelected && !isEmailSelected && !isContactSelected && !isWebsiteSelected && !isLocationSelected && !isAnyTextSelected()){
      setState(() {
        _textColorWebsite=color;
        _textColorEmail=color;
        _textColorName=color;
        _textColorLocation=color;
        _textColorContact=color;

        //text color
        for(int i=0;i<addTextList.length;i++){
          setState(() {
            addTextList[i].textColor = color;
          });
        }

      });
    }

    Navigator.pop(context);

  }

  bool isAnyTextSelected(){
    for(int i=0;i<addTextList.length;i++){
      if(addTextList[i].isSelected){
        return true;
      }
    }

    return false;
  }

  bool isAnyImageSelected(){
    for(int i=0;i<addImagesList.length;i++){
      if(addImagesList[i].isSelected){
        return true;
      }
    }

    return false;
  }

  void updateTextStyle(PickerFont font){

    if(isNameSelected){
      setState(() {
        _fontFamilyName=font.fontFamily;
      });
    }
    if(isEmailSelected){
      setState(() {
        _fontFamilyEmail=font.fontFamily;
      });
    }
    if(isLocationSelected){
      setState(() {
        _fontFamilyLocation=font.fontFamily;
      });
    }
    if(isContactSelected){
      setState(() {
        _fontFamilyMobile=font.fontFamily;
      });
    }
    if(isWebsiteSelected){
      setState(() {
        _fontFamilyWebsite=font.fontFamily;
      });
    }

    for(int i=0;i<addTextList.length;i++){
      if(addTextList[i].isSelected){
        setState(() {
          addTextList[i].fontFamilyText = font.fontFamily;
        });
      }
    }

    if(!isNameSelected && !isEmailSelected && !isContactSelected && !isWebsiteSelected && !isLocationSelected && !isAnyTextSelected()){
      setState(() {
        _fontFamilyWebsite=font.fontFamily;
        _fontFamilyEmail=font.fontFamily;
        _fontFamilyMobile=font.fontFamily;
        _fontFamilyLocation=font.fontFamily;
        _fontFamilyName=font.fontFamily;

        //text font
        for(int i=0;i<addTextList.length;i++){
          setState(() {
            addTextList[i].fontFamilyText = font.fontFamily;
          });
        }

      });
    }
  }

  void updateBackgroundColor(Color color){
    for(int i=0;i<addTextList.length;i++){
      if(addTextList[i].isSelected){
        setState(() {
          addTextList[i].backgroundColor = color;
        });
      }
    }

    Navigator.pop(context);

  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Widget frame_1(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.topLeft,
              child:  Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/frame1.png')
                      )
                  ),
                  height: 35,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    // child: Column(
                    //   children: <Widget>[
                    //     Expanded(
                    //       flex: 1,
                    //       child: Container(
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.end,
                    //           children: <Widget>[
                    //             Expanded(
                    //               flex: 3,
                    //                child:showWebsite('black'),
                    //             ),
                    //             Expanded(
                    //               flex: 4,
                    //               child:showLocation('white')
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     Expanded(
                    //         flex: 1,
                    //         child:
                    //         Container(
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.end,
                    //             children: <Widget>[
                    //               Expanded(
                    //                   flex: 2,
                    //                   child: showEmail('white')
                    //               ),
                    //               Expanded(
                    //                   flex: 3,
                    //                   child:showContact('white','row')
                    //               ),
                    //             ],
                    //           ),
                    //         )
                    //
                    //     ),
                    //   ],
                    // ),
                  )
              )
          ),
        ],
      ),
    );
  }

  Widget frame_2(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.bottomCenter,
              child:  Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/frame2.jpg')
                      )
                  ),
                  height: 35,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin:  EdgeInsets.only(left: 10,right:10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                    flex: 3,
                                    child: showEmail('black')
                                  /*isAddEmail && email!=null && email.isNotEmpty?
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(Images.email_black,height: 7,width: 7,),
                                        SizedBox(width: 3,),
                                        Container(
                                            child: Text(email,
                                              style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther2),
                                            )
                                        )
                                      ],
                                    ):
                                    Container()*/
                                ),
                                Expanded(
                                    flex: 1,
                                    child:Container()
                                ),
                                Expanded(
                                    flex: 3,
                                    child: showWebsite('black')
                                  /*  isAddWebsite && website!=null && website.isNotEmpty?
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(Images.www_black,height: 7,width: 7,),
                                        SizedBox(width: 3,),
                                        Container(
                                            child: Text(website,
                                              style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther2),
                                            )
                                        )
                                      ],
                                    ):
                                    Container()*/
                                )
                              ],
                            ),
                          ),

                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                              margin:  EdgeInsets.only(left: 10,right:10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                      flex: 4,
                                      child: showLocation('white')
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: showContact('white','row')
                                  ),

                                ],
                              ),
                            )
                        ),

                      ],
                    ),
                  )
              )
          ),
        ],
      ),
    );
  }

  Widget frame_3(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.bottomCenter,
              child:  Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/frame3.jpeg')
                      )
                  ),
                  height: 35,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                  flex: 2,
                                  child:showEmail('white')
                                 /* isAddEmail && email!=null && email.isNotEmpty?
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(Images.email_white,height: 8,width: 8,),
                                      SizedBox(width: 3,),
                                      Container(
                                          child: Text(email,
                                            style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther1),
                                          )
                                      )
                                    ],
                                  ):
                                  Container()*/
                              ),
                              Expanded(
                                  flex: 1,
                                  child: showWebsite('white')
                                /*  isAddWebsite && website!=null && website.isNotEmpty?
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(Images.www_white,height: 7,width: 7,),
                                      SizedBox(width: 3,),
                                      Container(
                                          child: Text(website,
                                            style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther1),
                                          )
                                      )
                                    ],
                                  ):
                                  Container()*/
                              ),
                            ],
                          ),
                         ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: showContact('black','row')

                                /*  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      isAddContact && primary_mobile!=null && primary_mobile.isNotEmpty?
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(Images.call_black,height: 7,width: 7,),
                                          SizedBox(width: 3,),
                                          Container(
                                              child: Text(primary_mobile,
                                                style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther2),
                                              )
                                          )
                                        ],
                                      ):
                                      Container(),

                                      SizedBox(width: 10,),

                                      isAddContact && secondary_mobile!=null && secondary_mobile.isNotEmpty?
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(Images.call_black,height: 7,width: 7,),
                                          SizedBox(width: 3,),
                                          Container(
                                              child: Text(secondary_mobile,
                                                style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther2),
                                              )
                                          )
                                        ],
                                      ):
                                      Container()
                                    ],
                                  )*/
                              ),
                              Expanded(
                                  flex: 2,
                                  child: showLocation('white')
                                /*  isAddLocation && location!=null && location.isNotEmpty?
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(Images.location_white,height: 9,width: 9,),
                                      SizedBox(width: 3,),
                                      Container(
                                          child: Text(location,
                                            style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther1),
                                          )
                                      )
                                    ],
                                  ):
                                  Container()*/
                              ),
                            ],
                          ),
                         ),
                      ],
                    ),
                  )
              )
          ),
        ],
      ),
    );
  }

  Widget frame_4(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.bottomCenter,
              child:  Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/frame4.jpeg')
                      )
                  ),
                  height: 35,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                  flex: 2,
                                  child:Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex:1,
                                        child: Container(),
                                      ),
                                      Expanded(
                                        flex:2,
                                        child:showContact('white','column')
                                       /* Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            isAddContact && primary_mobile!=null && primary_mobile.isNotEmpty?
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(Images.call_white,height: 7,width: 7,),
                                                SizedBox(width: 3,),
                                                Container(
                                                    child: Text(primary_mobile,
                                                      style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther1),
                                                    )
                                                )
                                              ],
                                            ):
                                            Container(),

                                            SizedBox(width: 10,),

                                            isAddContact && secondary_mobile!=null && secondary_mobile.isNotEmpty?
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(Images.call_white,height: 7,width: 7,),
                                                SizedBox(width: 3,),
                                                Container(
                                                    child: Text(secondary_mobile,
                                                      style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther1),
                                                    )
                                                )
                                              ],
                                            ):
                                            Container()
                                          ],
                                        ),*/
                                      )
                                    ],
                                  )
                              ),
                              Expanded(
                                flex:1,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                      child: showWebsite('black')
                                  )
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: showEmail('black')
                              ),
                              Expanded(
                                  flex: 2,
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                  child: showLocation('white')
                              ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
              )
          ),
        ],
      ),
    );
  }

  Widget frame_5(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.bottomCenter,
              child:  Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/frame5.png')
                      )
                  ),
                  height: 35,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex:2,
                          child: showContact('white','column')
                         /* Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              isAddContact && primary_mobile!=null && primary_mobile.isNotEmpty?
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(Images.call_white,height: 7,width: 7,),
                                  SizedBox(width: 3,),
                                  Container(
                                      child: Text(primary_mobile,
                                        style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther1),
                                      )
                                  )
                                ],
                              ):
                              Container() ,
                              SizedBox(width: 10,),
                              isAddContact && secondary_mobile!=null && secondary_mobile.isNotEmpty?
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(Images.call_white,height: 7,width: 7,),
                                  SizedBox(width: 3,),
                                  Container(
                                      child: Text(secondary_mobile,
                                        style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther1),
                                      )
                                  )
                                ],
                              ):
                              Container()
                            ],
                          ),*/
                        ),
                        Expanded(
                          flex: 4,
                          child:Container(
                            margin: EdgeInsets.only(right: 10,top:3,bottom:3),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: showLocation('white')
                                  /*  isAddLocation && location!=null && location.isNotEmpty?
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Image.asset(Images.location_white,height: 8,width: 8,),
                                        SizedBox(width: 3,),
                                        Container(
                                            child: Text(location,
                                              style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: 9,fontWeight: _fontWeightOther,color: _textColorOther1),
                                            )
                                        )
                                      ],
                                    ):
                                    Container()*/
                                ),
                                Expanded(
                                  flex:1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[

                                      Expanded(
                                        flex:1,
                                        child:showEmail('white'),

                                      ),
                                      Expanded(
                                        flex:1,
                                        child: showWebsite('white'),

                                      ),

                                     /* isAddEmail && email!=null && email.isNotEmpty?
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(Images.email_white,height: 8,width: 8,),
                                          SizedBox(width: 3,),
                                          Container(
                                              child: Text(email,
                                                style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther1),
                                              )
                                          )
                                        ],
                                      ):
                                      Container(),*/

                                     /* isAddWebsite && website!=null && website.isNotEmpty?
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(Images.www_white,height: 8,width: 8,),
                                          SizedBox(width: 3,),
                                          Container(
                                              child: Text(website,
                                                style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther1),
                                              )
                                          )
                                        ],
                                      ):
                                      Container(),*/
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                      ],
                    ),
                  )
              )
          ),
        ],
      ),
    );
  }

//   Widget frame_6(){
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.width,
//       child: Stack(
//         children: <Widget>[
//           Align(
//               alignment: Alignment.bottomCenter,
//               child:  Container(
//                 padding: EdgeInsets.only(left: 5,right: 5),
//                 decoration: BoxDecoration(
//                     image: DecorationImage(
//                         fit: BoxFit.fill,
//                         image: AssetImage('assets/images/frame6.png',)
//                     )
//                 ),
//                 height: 40,
//                 width: MediaQuery.of(context).size.width,
//                 child:Column(
//                   children: <Widget>[
//                     Expanded(
//                         flex: 1,
//                         child: Container()
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Expanded(
//                             flex:2,
//                             child: showEmail('white'),
//                           ),
//
//                           Expanded(
//                             flex:3,
//                             child: showContact('white','row'),
//                           ),
//                           /* Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               isAddContact && primary_mobile!=null && primary_mobile.isNotEmpty?
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   Image.asset(Images.call_white,height: 7,width: 7,),
//                                   SizedBox(width: 3,),
//                                   Container(
//                                       child: Text(primary_mobile,
//                                         style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther1),
//                                       )
//                                   )
//                                 ],
//                               ):
//                               Container() ,
//                               SizedBox(width: 5,),
//                               isAddContact && secondary_mobile!=null && secondary_mobile.isNotEmpty?
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   Image.asset(Images.call_white,height: 7,width: 7,),
//                                   SizedBox(width: 3,),
//                                   Container(
//                                       child: Text(secondary_mobile,
//                                         style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther1),
//                                       )
//                                   )
//                                 ],
//                               ):
//                               Container()
//                             ],
//                           ),*/
//                         ],
//                       )
//                     ),
//                     Expanded(
//                       flex:1,
//                       child:Row(
//                         children: <Widget>[
//                           Expanded(
//                               flex: 3,
//                               child:
//                               showLocation('white')
//                             /*  isAddLocation && location!=null && location.isNotEmpty?
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: <Widget>[
//                                   Image.asset(Images.location_white,height: 8,width: 8,),
//                                   SizedBox(width: 3,),
//                                   Container(
//                                       child: Text(location,
//                                         style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther1),
//                                       )
//                                   )
//                                 ],
//                               ):
//                               Container()*/
//                           ),
//                           Expanded(
//                               flex:2,
//                               child: Container(
//                                   child:
//                                   showWebsite('white')
//                                  /* isAddWebsite && website!=null && website.isNotEmpty?
//                                   Row(
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: <Widget>[
//                                       Image.asset(Images.www_white,height: 7,width: 7,),
//                                       SizedBox(width: 3,),
//                                       Container(
//                                           child: Text(website,
//                                             style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther1),
//                                           )
//                                       )
//                                     ],
//                                   ):
//                                   Container()*/
//                               )
//                           )
//                         ],
//                       )
//                     ),
//                   ],
//                 ),
//               )
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget frame_7(){
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.width,
//       child: Stack(
//         children: <Widget>[
//           Align(
//               alignment: Alignment.bottomCenter,
//               child:  Container(
//                   padding: EdgeInsets.only(left:20,right:20),
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           fit: BoxFit.fill,
//                           image: AssetImage('assets/images/frame7.png')
//                       )
//                   ),
//                   height: 35,
//                   width: MediaQuery.of(context).size.width,
//                   child: Container(
//                     child: Column(
//                       children: <Widget>[
//                         Expanded(
//                           flex:2,
//                             child:Row(
//                               children: <Widget>[
//                                 Expanded(
//                                   flex:5,
//                                   child: showContact('black','row')
//                                 ),
//
//                                 Expanded(
//                                   flex:3,
//                                   child:
//                                     showEmail('black')
//                                  /* isAddEmail && email!=null && email.isNotEmpty?
//                                   Row(
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: <Widget>[
//                                       Image.asset(Images.email_black,height: 9,width: 9,),
//                                       SizedBox(width: 3,),
//                                       Container(
//                                           child: Text(email,
//                                             style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther2),
//                                           )
//                                       )
//                                     ],
//                                   ):
//                                   Container(),*/
//                                 ),
//
//                               ],
//                             )
//                         ),
//                         Expanded(
//                             flex:1,
//                             child:Container(
//                                 child:Row(
//                                   children: <Widget>[
//                                     Expanded(
//                                       flex:1,
//                                       child:
//                                         showLocation('white')
//                                      /* isAddLocation && location!=null && location.isNotEmpty?
//                                       Row(
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         children: <Widget>[
//                                           Image.asset(Images.location_white,height: 7,width: 7,),
//                                           SizedBox(width: 3,),
//                                           Container(
//                                               child: Text(location,
//                                                 style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther1),
//                                               )
//                                           )
//                                         ],
//                                       ):
//                                       Container(),*/
//                                     ),
//
//                                     Expanded(
//                                       flex:1,
//                                       child:
//                                         showWebsite('white')
//                                      /* isAddWebsite && website!=null && website.isNotEmpty?
//                                       Row(
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         mainAxisAlignment: MainAxisAlignment.end,
//                                         children: <Widget>[
//                                           Image.asset(Images.www_white,height: 7,width: 7,),
//                                           SizedBox(width: 3,),
//                                           Container(
//                                               child: Text(website,
//                                                 style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther1),
//                                               )
//                                           )
//                                         ],
//                                       ):
//                                       Container(),*/
//                                     ),
//                                   ],
//                                 )
//                             )
//                         )
//                       ],
//                     ),
//                   )
//               )
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget frame_8(){
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.width,
//       child: Stack(
//         children: <Widget>[
//           Align(
//               alignment: Alignment.bottomCenter,
//               child:  Container(
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           fit: BoxFit.fill,
//                           image: AssetImage('assets/images/frame8.png')
//                       )
//                   ),
//                   height: 35,
//                   width: MediaQuery.of(context).size.width,
//                   child: Container(
//                     child: Column(
//                       children: <Widget>[
//                         Expanded(
//                             flex:2,
//                             child:Container(
//                                 margin: EdgeInsets.only(left:40,right:40),
//                                 child:Row(
//                                   children: <Widget>[
//                                     showEmail('white'),
//                                     SizedBox(width: 15,),
//                                     showContact('white', 'row')
//                                   ],
//                                 )
//                             )
//                         ),
//                         Expanded(
//                             flex:1,
//                             child:Container(
//                                 margin: EdgeInsets.only(left:20,right:20),
//                                 child:Row(
//                                   children: <Widget>[
//                                     Expanded(
//                                       flex:1,
//                                       child:
//                                         showWebsite('black')
//                                     ),
//
//                                     Expanded(
//                                       flex:1,
//                                       child: showLocation('black')
//                                     /*  isAddLocation && location!=null && location.isNotEmpty?
//                                       Row(
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         mainAxisAlignment: MainAxisAlignment.end,
//                                         children: <Widget>[
//                                           Image.asset(Images.location_black,height: 7,width: 7,),
//                                           SizedBox(width: 3,),
//                                           Container(
//                                               child: Text(location,
//                                                 style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther2),
//                                               )
//                                           )
//                                         ],
//                                       ):
//                                       Container(),*/
//                                     ),
//
//                                   ],
//                                 )
//                             )
//                         )
//                       ],
//                     ),
//                   )
//               )
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget frame_9(){
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.width,
//       child: Stack(
//         children: <Widget>[
//           Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           fit: BoxFit.fill,
//                           image: AssetImage('assets/images/frame9.png')
//                       )
//                   ),
//                   height: 35,
//                   width: MediaQuery.of(context).size.width,
//                   child: Container(
//                     child: Column(
//                       children: <Widget>[
//                         Expanded(
//                           flex:1,
//                           child: Stack(
//                             children: <Widget>[
//                               showContactSpace('white'),
//                               showEmail('white'),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                             flex:1,
//                             child:Row(
//                               children: <Widget>[
//                                 Expanded(
//                                   flex:1,
//                                   child: showLocation('black'),
//                                 ),
//                                 Expanded(
//                                   flex:1,
//                                   child: showWebsite('black'),
//                                 ),
//                               ],
//                             )
//                         ),
//                       ],
//                     ),
//                   )
//               )
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget frame_10(){
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.width,
//       child: Stack(
//         children: <Widget>[
//           Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           fit: BoxFit.fill,
//                           image: AssetImage('assets/images/10.png')
//                       )
//                   ),
//                   height: 35,
//                   width: MediaQuery.of(context).size.width,
//                   child: Container(
//                     child: Column(
//                       children: <Widget>[
//                         Expanded(
//                             flex:1,
//                             child:Row(
//                               children: <Widget>[
//                                 Expanded(
//                                   flex:3,
//                                   child: showEmail('black'),
//                                 ),
//                                 Expanded(
//                                     flex:1,
//                                     child: Container()),
//                                 Expanded(
//                                   flex:3,
//                                   child: showWebsite('black'),
//                                 ),
//                               ],
//                             )
//                         ),
//                         Expanded(
//                             flex:1,
//                             child:
//                             Row(
//                               children: <Widget>[
//                                 Expanded(
//                                   flex:1,
//                                   child: showContact('white','row'),
//                                 ),
//                                 Expanded(
//                                   flex:1,
//                                   child: showLocation('white'),
//                                 ),
//                               ],
//                             )
//                         ),
//                       ],
//                     ),
//                   )
//               )
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget frame_11(){
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.width,
//       child: Stack(
//         children: <Widget>[
//           Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           fit: BoxFit.fill,
//                           image: AssetImage('assets/images/11.png')
//                       )
//                   ),
//                   height: 35,
//                   width: MediaQuery.of(context).size.width,
//                   child: Container(
//                     child: Column(
//                       children: <Widget>[
//                         Expanded(
//                             flex:1,
//                             child:Row(
//                               children: <Widget>[
//                                 Expanded(
//                                   flex:3,
//                                   child: showEmail('black'),
//                                 ),
//                                 Expanded(
//                                     flex:1,
//                                     child: Container()),
//                                 Expanded(
//                                   flex:3,
//                                   child: showWebsite('black'),
//                                 ),
//                               ],
//                             )
//                         ),
//                         Expanded(
//                             flex:1,
//                             child:
//                             Row(
//                               children: <Widget>[
//                                 Expanded(
//                                   flex:1,
//                                   child: showContact('white','row'),
//                                 ),
//                                 Expanded(
//                                   flex:1,
//                                   child: showLocation('white'),
//                                 ),
//                               ],
//                             )
//                         ),
//                       ],
//                     ),
//                   )
//               )
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget frame_12(){
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.width,
//       child: Container(
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 fit: BoxFit.fill,
//                 image: AssetImage('assets/images/12.png')
//             )
//         ),
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             height: 35,
//             child: Column(
//               children: <Widget>[
//                 Expanded(
//                     flex:1,
//                     child:Row(
//                       children: <Widget>[
//                         Expanded(
//                           flex:3,
//                           child: showEmail('black'),
//                         ),
//                         Expanded(
//                             flex:1,
//                             child: Container()),
//                         Expanded(
//                           flex:3,
//                           child: showWebsite('black'),
//                         ),
//                       ],
//                     )
//                 ),
//                 Expanded(
//                     flex:1,
//                     child:
//                     Row(
//                       children: <Widget>[
//                         Expanded(
//                           flex:1,
//                           child: showContact('white','row'),
//                         ),
//                         Expanded(
//                           flex:1,
//                           child: showLocation('white'),
//                         ),
//                       ],
//                     )
//                 ),
//               ],
//             ),
//           ),
//         ),),
//     );
//   }
//
//   Widget frame_13(){
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.width,
//       child: Container(
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 fit: BoxFit.fill,
//                 image: AssetImage('assets/images/13.png')
//             )
//         ),
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             height: 25,
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                     flex: 1,
//                     child: Container()),
//                 Expanded(
//                   flex: 3,
//                   child: Container(
//                       alignment: Alignment.center,
//                       child: showContact('white', 'column')),
//                 ),
//                 Expanded(
//                     flex: 7,
//                     child: Container(
//                       child: Column(
//                         children: <Widget>[
//                           Row(
//                             children: <Widget>[
//                               Expanded(
//                                 flex:1,
//                                 child: showWebsite('white'),
//                               ),
//                               Expanded(
//                                 flex:1,
//                                 child: showEmail('white'),
//                               )
//                             ],
//                           ),
//                           SizedBox(height: 2,),
//                           showLocation('white'),
//                         ],
//                       ),
//                     )),
//
//               ],
//             ),
// /*
//             child: Column(
//               children: <Widget>[
//                 Expanded(
//                     flex:1,
//                     child:Row(
//                       children: <Widget>[
//                         Expanded(
//                           flex:3,
//                           child: showEmail('black'),
//                         ),
//                         Expanded(
//                             flex:1,
//                             child: Container()),
//                         Expanded(
//                           flex:3,
//                           child: showWebsite('black'),
//                         ),
//                       ],
//                     )
//                 ),
//                 Expanded(
//                     flex:1,
//                     child:
//                     Row(
//                       children: <Widget>[
//                         Expanded(
//                           flex:1,
//                           child: showContact('white','row'),
//                         ),
//                         Expanded(
//                           flex:1,
//                           child: showLocation('white'),
//                         ),
//                       ],
//                     )
//                 ),
//               ],
//             ),
// */
//           ),
//         ),),
//     );
//   }
//
//   Widget frame_14(){
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.width,
//       child: Stack(
//         children: <Widget>[
//           Align(
//               alignment: Alignment.bottomCenter,
//               child:  Container(
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           fit: BoxFit.fill,
//                           image: AssetImage('assets/images/14.png')
//                       )
//                   ),
//                   height: 49,
//                   width: MediaQuery.of(context).size.width,
//                   child: Container(
//                     child: Column(
//                       children: <Widget>[
//                         Expanded(
//                             flex:2,
//                             child:Container(
//                                 margin: EdgeInsets.only(left:30,right:30),
//                                 child:Row(
//                                   children: <Widget>[
//                                     Expanded(
//                                       flex:3,
//                                       child: Container(
//                                         margin: EdgeInsets.only(top:10),
//                                         child: showContact('white', 'column'),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       flex:5,
//                                       child: Container(
//                                         margin: EdgeInsets.only(top:15),
//                                         child:showEmail('white'),),
//                                     ),
//
//                                     /* showEmail('white'),
//                                     SizedBox(width: 15,),
//                                     showContact('white', 'row')*/
//                                   ],
//                                 )
//                             )
//                         ),
//                         Expanded(
//                             flex:1,
//                             child:Container(
//                                 margin: EdgeInsets.only(left:20,right:20),
//                                 child:Row(
//                                   children: <Widget>[
//                                     Expanded(
//                                         flex:1,
//                                         child:
//                                         showWebsite('black')
//                                     ),
//
//                                     Expanded(
//                                         flex:1,
//                                         child: showLocation('black')
//                                       /*  isAddLocation && location!=null && location.isNotEmpty?
//                                       Row(
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         mainAxisAlignment: MainAxisAlignment.end,
//                                         children: <Widget>[
//                                           Image.asset(Images.location_black,height: 7,width: 7,),
//                                           SizedBox(width: 3,),
//                                           Container(
//                                               child: Text(location,
//                                                 style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther2),
//                                               )
//                                           )
//                                         ],
//                                       ):
//                                       Container(),*/
//                                     ),
//
//                                   ],
//                                 )
//                             )
//                         )
//                       ],
//                     ),
//                   )
//               )
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget frame_15(){
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.width,
//       child: Stack(
//         children: <Widget>[
//           Align(
//               alignment: Alignment.bottomCenter,
//               child:  Container(
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           fit: BoxFit.fill,
//                           image: AssetImage('assets/images/15.png')
//                       )
//                   ),
//                   height: 49,
//                   width: MediaQuery.of(context).size.width,
//                   child: Container(
//                     child: Column(
//                       children: <Widget>[
//                         Expanded(
//                             flex:2,
//                             child:Container(
//                                 margin: EdgeInsets.only(left:30,right:30),
//                                 child:Row(
//                                   children: <Widget>[
//                                     Expanded(
//                                       flex:3,
//                                       child: Container(
//                                         margin: EdgeInsets.only(top:10),
//                                         child: showContact('white', 'column'),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       flex:5,
//                                       child: Container(
//                                         margin: EdgeInsets.only(top:15),
//                                         child:showEmail('white'),),
//                                     ),
//
//                                     /* showEmail('white'),
//                                     SizedBox(width: 15,),
//                                     showContact('white', 'row')*/
//                                   ],
//                                 )
//                             )
//                         ),
//                         Expanded(
//                             flex:1,
//                             child:Container(
//                                 margin: EdgeInsets.only(left:20,right:20),
//                                 child:Row(
//                                   children: <Widget>[
//                                     Expanded(
//                                         flex:1,
//                                         child:
//                                         showWebsite('black')
//                                     ),
//
//                                     Expanded(
//                                         flex:1,
//                                         child: showLocation('black')
//                                       /*  isAddLocation && location!=null && location.isNotEmpty?
//                                       Row(
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         mainAxisAlignment: MainAxisAlignment.end,
//                                         children: <Widget>[
//                                           Image.asset(Images.location_black,height: 7,width: 7,),
//                                           SizedBox(width: 3,),
//                                           Container(
//                                               child: Text(location,
//                                                 style: GoogleFonts.getFont(_fontFamilyOther).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorOther2),
//                                               )
//                                           )
//                                         ],
//                                       ):
//                                       Container(),*/
//                                     ),
//
//                                   ],
//                                 )
//                             )
//                         )
//                       ],
//                     ),
//                   )
//               )
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget frame_16(){
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.width,
//       child: Container(
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 fit: BoxFit.fill,
//                 image: AssetImage('assets/images/16.png')
//             )
//         ),
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             height: 42,
//             child: Column(
//               children: <Widget>[
//                 Expanded(
//                     flex:1,
//                     child:Row(
//                       children: <Widget>[
//                         Expanded(
//                           flex:3,
//                           child: showEmail('black'),
//                         ),
//                         Expanded(
//                             flex:1,
//                             child: Container()),
//                         Expanded(
//                           flex:3,
//                           child: showWebsite('black'),
//                         ),
//                       ],
//                     )
//                 ),
//                 Expanded(
//                     flex:1,
//                     child:
//                     Row(
//                       children: <Widget>[
//                         Expanded(
//                           flex:1,
//                           child: showContact('white','row'),
//                         ),
//                         Expanded(
//                           flex:1,
//                           child: showLocation('white'),
//                         ),
//                       ],
//                     )
//                 ),
//               ],
//             ),
//           ),
//         ),),
//     );
//   }
//
//   Widget frame_17(){
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.width,
//       child: Container(
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 fit: BoxFit.fill,
//                 image: AssetImage('assets/images/17.png')
//             )
//         ),
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             height: 42,
//             child: Column(
//               children: <Widget>[
//                 Expanded(
//                     flex:1,
//                     child:Row(
//                       children: <Widget>[
//                         Expanded(
//                           flex:3,
//                           child: showEmail('black'),
//                         ),
//                         Expanded(
//                             flex:1,
//                             child: Container()),
//                         Expanded(
//                           flex:3,
//                           child: showWebsite('black'),
//                         ),
//                       ],
//                     )
//                 ),
//                 Expanded(
//                     flex:1,
//                     child:
//                     Row(
//                       children: <Widget>[
//                         Expanded(
//                           flex:1,
//                           child: showContact('white','row'),
//                         ),
//                         Expanded(
//                           flex:1,
//                           child: showLocation('white'),
//                         ),
//                       ],
//                     )
//                 ),
//               ],
//             ),
//           ),
//         ),),
//     );
//   }
//
//   Widget frame_18(){
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.width,
//       child: Stack(
//         children: <Widget>[
//           Align(
//               alignment: Alignment.bottomCenter,
//               child:  Container(
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           fit: BoxFit.fill,
//                           image: AssetImage('assets/images/18.png')
//                       )
//                   ),
//                   height: 60,
//                   width: MediaQuery.of(context).size.width,
//                   child: Container(
//                     margin: EdgeInsets.only(top: 20),
//                     child: Column(
//                       children: <Widget>[
//                         Expanded(
//                           flex:1,
//                           child: Stack(
//                             children: <Widget>[
//                               showContactSpace('white'),
//                               showEmail('white'),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                             flex:1,
//                             child:Row(
//                               children: <Widget>[
//                                 Expanded(
//                                   flex:1,
//                                   child: showLocation('black'),
//                                 ),
//                                 Expanded(
//                                   flex:1,
//                                   child: showWebsite('black'),
//                                 ),
//                               ],
//                             )
//                         ),
//                       ],
//                     ),
//                   )
//               )
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget frame_19(){
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.width,
//       child: Container(
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 fit: BoxFit.fill,
//                 image: AssetImage('assets/images/19.png')
//             )
//         ),
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             height:40,
//             child: Column(
//               children: <Widget>[
//                 Expanded(
//                   flex:1,
//                   child: Stack(
//                     children: <Widget>[
//                       showContactSpace('white'),
//                       showEmail('white'),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                     flex:1,
//                     child:
//                     Row(
//                       children: <Widget>[
//                         Expanded(
//                           flex:1,
//                           child: showWebsite('white'),
//                         ),
//                         Expanded(
//                           flex:1,
//                           child: showLocation('white'),
//                         ),
//                       ],
//                     )
//                 ),
//               ],
//             ),
//           ),
//         ),),
//     );
//   }
//
//   Widget frame_20(){
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.width,
//       child: Container(
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 fit: BoxFit.fill,
//                 image: AssetImage('assets/images/20.png')
//             )
//         ),
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             height:40,
//             child: Column(
//               children: <Widget>[
//                 Expanded(
//                   flex:1,
//                   child: Stack(
//                     children: <Widget>[
//                       showContactSpace('white'),
//                       showEmail('white'),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                     flex:1,
//                     child:
//                     Row(
//                       children: <Widget>[
//                         Expanded(
//                           flex:1,
//                           child: showWebsite('white'),
//                         ),
//                         Expanded(
//                           flex:1,
//                           child: showLocation('white'),
//                         ),
//                       ],
//                     )
//                 ),
//               ],
//             ),
//           ),
//         ),),
//     );
//   }

  //content

  Widget showContactSpace(String txt_color){
    return Container(
        child: isAddContact?
        Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    child:  !isContactSelected?
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex:1,
                          child: isAddContact && primary_mobile!=null && primary_mobile.isNotEmpty?
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(txt_color=='black' ? Images.call_black : Images.call_white,height: 8,width: 8,),
                              SizedBox(width: 3,),
                              Container(
                                  child: Text(primary_mobile,
                                    style: GoogleFonts.getFont(_fontFamilyMobile).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorContact),
                                  )
                              )
                            ],
                          ):
                          Container(),
                        ),
                        Expanded(
                          flex:1,
                          child: Container(),),
                        Expanded(
                            flex:1,
                            child:
                            isAddContact && secondary_mobile!=null && secondary_mobile.isNotEmpty?
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(txt_color=='black' ? Images.call_black : Images.call_white,height: 8,width: 8,),
                                SizedBox(width: 3,),
                                Container(
                                    child: Text(secondary_mobile,
                                      style: GoogleFonts.getFont(_fontFamilyMobile).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorContact),
                                    )
                                )
                              ],
                            ):
                            Container()
                        ),

                      ],
                    ):
                    Container(
                      child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(2),
                          color: Colors.grey,
                          strokeWidth: 1,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex:1,
                                child: isAddContact && primary_mobile!=null && primary_mobile.isNotEmpty?
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Image.asset(txt_color=='black' ? Images.call_black : Images.call_white,height: 8,width: 8,),
                                    SizedBox(width: 3,),
                                    Container(
                                        child: Text(primary_mobile,
                                          style: GoogleFonts.getFont(_fontFamilyMobile).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorContact),
                                        )
                                    )
                                  ],
                                ):
                                Container(),
                              ),

                              Expanded(
                                  flex:1,
                                  child:
                                  isAddContact && secondary_mobile!=null && secondary_mobile.isNotEmpty?
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Image.asset(txt_color=='black' ? Images.call_black : Images.call_white,height: 8,width: 8,),
                                      SizedBox(width: 3,),
                                      Container(
                                          child: Text(secondary_mobile,
                                            style: GoogleFonts.getFont(_fontFamilyMobile).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorContact),
                                          )
                                      )
                                    ],
                                  ):
                                  Container()
                              ),

                            ],
                          )
                      ),
                    ),
                  ),
                  onTap: ()=>setState(() {
                    isContactSelected=!isContactSelected;
                  }),
                ),
                Container(
                  child: !isContactSelected?
                  Container():
                  GestureDetector(
                    onTap:()=> setState(() {
                      isAddContact=false;
                    }),
                    child: Container(
                        child:Image.asset(Images.close,height: 15,width:15,)
                    ),
                  ),
                )
              ],
            )
        ):
        Container()
    );
  }

  void onDragEnd(Offset offset) {
    setState(() {
      logo_position += offset;

      _x_logo = logo_position.dx;
      // if applicable, don't forget offsets like app/status bar
      _y_logo = logo_position.dy -
          app_bar_height -
          MediaQuery.of(context).padding.top;
    });
  }

  void removeSticker(AddStricker addStricker){
    setState(() {
      addStickerList.remove(addStricker);
    });
  }

  void removeImage(AddImages addImages){
    setState(() {
      addImagesList.remove(addImages);
    });
  }

  void removeText(AddText addText){
    setState(() {
      addTextList.remove(addText);
    });
  }

  void removeLogo(){
    setState(() {
      isAddLogo=false;
    });
  }

  Widget showLogo(){
    return Container(
      child: isAddLogo && logo!=null && logo.isNotEmpty?
      LogoChild(logo,this.removeLogo):
      Container(),
    );
  }

  List<Widget> stickerData(){
    List<Widget> list=[];

    for(int i=0;i<addStickerList.length;i++){
      list.add(
          StickerChild(addStickerList[i],this.removeSticker)
      );
    }

    return list;
  }

  List<Widget> imageData(){
    List<Widget> list=[];

    for(int i=0;i<addImagesList.length;i++){
      list.add(
          ImageChild(addImagesList[i],this.removeImage)
      );
    }

    return list;
  }

  void removeName(){
    setState(() {
      isAddName=false;
    });
  }

  Widget showName(){
    if(isAddName && name!=null && name.isNotEmpty){
      return NameChild(AddName(name,_textColorName,fontSizeName,_fontFamilyName),this.removeName);

      /* return Positioned(
        left: _x_name,
        top: _y_name,
        child: Draggable(
          child: GestureDetector(
            child: Container(
              child: isNameSelected?
              Container(
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(5),
                  color: Colors.grey,
                  strokeWidth: 1,
                  padding: EdgeInsets.all(5),
                  child: Text(name,
                    style: GoogleFonts.getFont(_fontFamilyName).copyWith(fontSize: fontSizeName,fontWeight: _fontWeightName,color: _textColorName),
                  ),
                ),
              ):
              Text(name,
                style: GoogleFonts.getFont(_fontFamilyName).copyWith(fontSize: fontSizeName,fontWeight: _fontWeightName,color: _textColorName),
              ),
            ),
            onTap: ()=>setState(() {
              if(!isNameSelected){
                isNameSelected=true;
              }
              else{
                isNameSelected=false;
              }
            }),
          ),
          feedback: Container(
            child: isNameSelected?
            Container(
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(5),
                color: Colors.grey,
                strokeWidth: 1,
                padding: EdgeInsets.all(5),
                child: Text(name,
                  style: GoogleFonts.getFont(_fontFamilyName).copyWith(fontSize: fontSizeName,fontWeight: _fontWeightName,color: _textColorName),
                ),
              ),
            ):
            Text(name,
              style: GoogleFonts.getFont(_fontFamilyName).copyWith(fontSize: fontSizeName,fontWeight: _fontWeightName,color: _textColorName),
            ),
          ),
          childWhenDragging: Container(),

          onDragStarted: () {
            print("onDragStarted");
          },

          onDragEnd: (dragDetails) {
            print("on Drag Ended");
            setState(() {
              _x_name = dragDetails.offset.dx;
              // if applicable, don't forget offsets like app/status bar
              _y_name = dragDetails.offset.dy -
                  app_bar_height -
                  MediaQuery.of(context).padding.top;
              ;
            });
          },
          onDragCompleted: () {
            print("onDragCompleted");
          },
          onDraggableCanceled: (Velocity velocity, Offset offset) {
            setState(() {
              name_position = offset;
            });
          },
        ),
      );*/
    }
    else{
      return Container();
    }
  }

  List<Widget> textData(){
    List<Widget> list=[];

    for(int i=0;i<addTextList.length;i++){
      list.add(
        TextChild(addTextList[i],this.removeText),
        /* Positioned(
            left: addTextList[i].x_text,
            top: addTextList[i].y_text,
            child: Draggable(
              child:
              TextChild(addTextList[i],this.removeText),
              childWhenDragging: Container(),

              feedback:
              TextChild(addTextList[i],this.removeText),

              onDragStarted: () {
                print("onDragStarted");
              },
              onDragEnd: (dragDetails) {
                print("on Drag Ended");
                setState(() {
                  addTextList[i].x_text = dragDetails.offset.dx;
                  // if applicable, don't forget offsets like app/status bar
                  addTextList[i].y_text = dragDetails.offset.dy -
                      app_bar_height -
                      MediaQuery.of(context).padding.top;
                  ;
                });
              },
              onDragCompleted: () {
                print("onDragCompleted");
              },
              onDraggableCanceled: (Velocity velocity, Offset offset) {
                setState(() {
                  addTextList[i].text_position = offset;
                });
              },
            ),
          )*/
      );
    }

    return list;
  }

  Widget showImages(){
    return Container(
        child: addImagesList!=null && addImagesList.isNotEmpty?
        Stack(
          children: imageData(),
        ):
        Container()
    );
  }

  Widget showText(){
    return Container(
        child: addTextList!=null && addTextList.isNotEmpty?
        Stack(
          children: textData(),
        ):
        Container()
    );
  }

  Widget showWebsite(String txt_color){
    return Container(
      child: isAddWebsite && website!=null && website.isNotEmpty?
      Container(
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                child:  !isWebsiteSelected?
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset( txt_color=='black'?Images.www_black :Images.www_white,height: 8,width: 8,),
                      SizedBox(width: 3,),
                      Container(
                          child: Text(website,
                            style: GoogleFonts.getFont(_fontFamilyWebsite).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorWebsite),
                          )
                      )
                    ],
                  )
                ):
                Container(
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(2),
                    color: Colors.grey,
                    strokeWidth: 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Image.asset( txt_color=='black'?Images.www_black :Images.www_white,height: 8,width: 8,),
                          SizedBox(width: 3,),
                          Container(
                              child: Text(website,
                                style: GoogleFonts.getFont(_fontFamilyWebsite).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorWebsite),
                              )
                          )
                        ],
                      )
                  ),
                ),
              ),
              onTap: ()=>setState(() {
                isWebsiteSelected=!isWebsiteSelected;
              }),
            ),
            Container(
              child: !isWebsiteSelected?
              Container():
              GestureDetector(
                onTap:()=> setState(() {
                  isAddWebsite=false;
                }),
                child: Container(
                    child:Image.asset(Images.close,height: 15,width:15,)
                ),
              ),
            )
          ],
        ),
      ):
      Container(),
    );
  }

  Widget showEmail(String txt_color){
    /*if(txt_color=='black'){
      _textColorEmail=Colors.black;
    }
    else{
      _textColorEmail=Colors.white;
    }
*/

    return Container(
      child: isAddEmail && email!=null && email.isNotEmpty?
      Container(
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                child:  !isEmailSelected?
                Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(txt_color=='black' ? Images.email_black : Images.email_white,height: 9,width: 9,),
                        SizedBox(width: 3,),
                        Container(
                            child: Text(email,
                              style: GoogleFonts.getFont(_fontFamilyEmail).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorEmail),
                            )
                        )
                      ],
                    )
                ):
                Container(
                  child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(2),
                      color: Colors.grey,
                      strokeWidth: 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(txt_color=='black' ? Images.email_black : Images.email_white,height: 9,width: 9,),
                          SizedBox(width: 3,),
                          Container(
                              child: Text(email,
                                style: GoogleFonts.getFont(_fontFamilyEmail).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorEmail),
                              )
                          )
                        ],
                      )
                  ),
                ),
              ),
              onTap: ()=>setState(() {
                isEmailSelected=!isEmailSelected;
              }),
            ),
            Container(
              child: !isEmailSelected?
              Container():
              GestureDetector(
                onTap:()=> setState(() {
                  isAddEmail=false;
                }),
                child: Container(
                    child:Image.asset(Images.close,height: 15,width:15,)
                ),
              ),
            )
          ],
        ),
      ):
      Container(),
    );
  }

  Widget showLocation(String txt_color){
    return Container(
      child: isAddLocation && location!=null && location.isNotEmpty?
      Container(
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: Container(
                alignment: Alignment.centerRight,
                child:  !isLocationSelected?
                Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(txt_color=='black' ? Images.location_black : Images.location_white,height: 8,width: 8,),
                        SizedBox(width: 3,),
                        Container(
                            child: Text(location,
                              style: GoogleFonts.getFont(_fontFamilyLocation).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorLocation),
                            )
                        )
                      ],
                    )
                ):
                Container(
                  child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(2),
                      color: Colors.grey,
                      strokeWidth: 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(txt_color=='black' ? Images.location_black : Images.location_white,height: 8,width: 8,),
                          SizedBox(width: 3,),
                          Container(
                              child: Text(location,
                                style: GoogleFonts.getFont(_fontFamilyLocation).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorLocation),
                              )
                          )
                        ],
                      )
                  ),
                ),
              ),
              onTap: ()=>setState(() {
                isLocationSelected=!isLocationSelected;
              }),
            ),
            Container(
              child: !isLocationSelected?
              Container():
              GestureDetector(
                onTap:()=> setState(() {
                  isAddLocation=false;
                }),
                child: Container(
                    child:Image.asset(Images.close,height: 15,width:15,)
                ),
              ),
            )
          ],
        ),
      ):
      Container(),
    );
  }

  Widget showContact(String txt_color, String orientation){
    return Container(
      child: isAddContact?
      Container(
          child: Stack(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    child:  !isContactSelected?
                    Container(
                        child:orientation=='row'?
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            isAddContact && primary_mobile!=null && primary_mobile.isNotEmpty?
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(txt_color=='black' ? Images.call_black : Images.call_white,height: 8,width: 8,),
                                SizedBox(width: 3,),
                                Container(
                                    child: Text(primary_mobile,
                                      style: GoogleFonts.getFont(_fontFamilyMobile).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorContact),
                                    )
                                )
                              ],
                            ):
                            Container(),
                            SizedBox(width: 10,),
                            isAddContact && secondary_mobile!=null && secondary_mobile.isNotEmpty?
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(txt_color=='black' ? Images.call_black : Images.call_white,height: 8,width: 8,),
                                SizedBox(width: 3,),
                                Container(
                                    child: Text(secondary_mobile,
                                      style: GoogleFonts.getFont(_fontFamilyMobile).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorContact),
                                    )
                                )
                              ],
                            ):
                            Container()
                          ],
                        ):
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            isAddContact && primary_mobile!=null && primary_mobile.isNotEmpty?
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(txt_color=='black' ? Images.call_black : Images.call_white,height: 8,width: 8,),
                                SizedBox(width: 3,),
                                Container(
                                    child: Text(primary_mobile,
                                      style: GoogleFonts.getFont(_fontFamilyMobile).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorContact),
                                    )
                                )
                              ],
                            ):
                            Container(),
                            SizedBox(width: 10,),
                            isAddContact && secondary_mobile!=null && secondary_mobile.isNotEmpty?
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(txt_color=='black' ? Images.call_black : Images.call_white,height: 8,width: 8,),
                                SizedBox(width: 3,),
                                Container(
                                    child: Text(secondary_mobile,
                                      style: GoogleFonts.getFont(_fontFamilyMobile).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorContact),
                                    )
                                )
                              ],
                            ):
                            Container()
                          ],
                        )
                    ):
                    Container(
                      child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(2),
                          color: Colors.grey,
                          strokeWidth: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              primary_mobile!=null && primary_mobile.isNotEmpty?
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(txt_color=='black' ? Images.call_black : Images.call_white,height: 8,width: 8,),
                                  SizedBox(width: 3,),
                                  Container(
                                      child: Text(primary_mobile,
                                        style: GoogleFonts.getFont(_fontFamilyMobile).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorContact),
                                      )
                                  )
                                ],
                              ):
                              Container(),
                              SizedBox(width: 10,),
                              secondary_mobile!=null && secondary_mobile.isNotEmpty?
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(txt_color=='black' ? Images.call_black : Images.call_white,height: 8,width: 8,),
                                  SizedBox(width: 3,),
                                  Container(
                                      child: Text(secondary_mobile,
                                        style: GoogleFonts.getFont(_fontFamilyMobile).copyWith(fontSize: other_textSize,fontWeight: _fontWeightOther,color: _textColorContact),
                                      )
                                  )
                                ],
                              ):
                              Container()
                            ],
                          )
                      ),
                    ),
                  ),
                  onTap: ()=>setState(() {
                    isContactSelected=!isContactSelected;
                  }),
                ),
                Container(
                  child: !isContactSelected?
                  Container():
                  GestureDetector(
                    onTap:()=> setState(() {
                      isAddContact=false;
                    }),
                    child: Container(
                        child:Image.asset(Images.close,height: 15,width:15,)
                    ),
                  ),
                )
              ],
            )
      ):
      Container()
    );
  }

  //details
  // Widget showDetails() {
  //   return Container(
  //       padding: EdgeInsets.only(left: 10,right: 10),
  //       child: SingleChildScrollView(
  //         scrollDirection: Axis.horizontal,
  //         child: Container(
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               nameIcon(),
  //              logoIcon(),
  //               contactIcon(),
  //               emailIcon(),
  //               websiteIcon(),
  //               locationIcon(),
  //            /* *//*  Container(
  //                 width: 50,
  //                 margin: EdgeInsets.all(5),
  //                 child: GestureDetector(
  //                   child:Column(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: <Widget>[
  //                       Container(
  //                         child: Image.asset(Images.contact,fit: BoxFit.fill,),
  //                       ),
  //                       SizedBox(height: 10,),
  //                       Text("Contact",style: AppTheme.select_details_label_text_style,),
  //
  //                     ],
  //                   ),
  //                   onTap: ()=> {},
  //                 ),
  //               ),*//*
  //               Container(
  //                 width: 50,
  //                 margin: EdgeInsets.all(5),
  //                 child: GestureDetector(
  //                   child:Column(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: <Widget>[
  //                       Container(
  //                         child: Image.asset(Images.email,fit: BoxFit.fill,),
  //                       ),
  //                       SizedBox(height: 10,),
  //                       Text("Email",style: AppTheme.select_details_label_text_style,),
  //
  //                     ],
  //                   ),
  //                   onTap: ()=> {},
  //                 ),
  //               ),
  //               Container(
  //                 width: 50,
  //                 margin: EdgeInsets.all(5),
  //                 child: GestureDetector(
  //                   child:Column(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: <Widget>[
  //                       Container(
  //                         child: Image.asset(Images.website,fit: BoxFit.fill,),
  //                       ),
  //                       SizedBox(height: 10,),
  //                       Text("Website",style: AppTheme.select_details_label_text_style,),
  //
  //                     ],
  //                   ),
  //                   onTap: ()=> {},
  //                 ),
  //               ),
  //               Container(
  //                 width: 50,
  //                 margin: EdgeInsets.all(5),
  //                 child: GestureDetector(
  //                   child:Column(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: <Widget>[
  //                       Container(
  //                         height: 50,
  //                         width: 50,
  //                         child: Image.asset(Images.location,fit: BoxFit.fill,),
  //                       ),
  //                       SizedBox(height: 10,),
  //                       Text("Location",style: AppTheme.select_details_label_text_style,),
  //
  //                     ],
  //                   ),
  //                   onTap: ()=> {},
  //                 ),
  //               ),*/
  //             ],
  //           ),
  //         ),
  //       )
  //   );
  // }

  Widget nameIcon(){
    return Container(
      child: GestureDetector(
        onTap: ()=> setState(() {
          isAddName=!isAddName;
        }),
        child: Container(
          alignment: Alignment.center,
          width: 50,
          height: 50,
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isAddName? primaryColor: Colors.white,
          ),
          child:Text("NAME",style:TextStyle(
            fontWeight: FontWeight.bold,
            color: isAddName? Colors.white:Colors.grey[400],
            fontSize: 10,)),

          /* child:
      GestureDetector(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset(Images.name,fit: BoxFit.fill,),
            ),
            SizedBox(height: 10,),
          ],
        ),
        onTap: ()=> setState(() {
          //isAddName=true;
        }),
      ),*/
        ),
      ),
    );
  }

  Widget logoIcon(){
    return Container(
      child: GestureDetector(
        onTap: ()=> setState(() {
          isAddLogo=!isAddLogo;
        }),
        child: Container(
          alignment: Alignment.center,
          width: 50,
          height: 50,
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isAddLogo? primaryColor: Colors.white,
          ),
          child:Text("LOGO",style:TextStyle(
            fontWeight: FontWeight.bold,
            color: isAddLogo? Colors.white:Colors.grey[400],
            fontSize: 10,)),

          /* child:
      GestureDetector(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset(Images.name,fit: BoxFit.fill,),
            ),
            SizedBox(height: 10,),
          ],
        ),
        onTap: ()=> setState(() {
          //isAddName=true;
        }),
      ),*/
        ),
      ),
    );
  }

  Widget contactIcon(){
    return Container(
      child: GestureDetector(
        onTap: ()=> setState(() {
          isAddContact=!isAddContact;
        }),
        child: Container(
          alignment: Alignment.center,
          width: 50,
          height: 50,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isAddContact? primaryColor: Colors.white,
          ),
          child:isAddContact? Image.asset(Images.mb_white):
          Image.asset(Images.mb_grey)),

          /* child:
      GestureDetector(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset(Images.name,fit: BoxFit.fill,),
            ),
            SizedBox(height: 10,),
          ],
        ),
        onTap: ()=> setState(() {
          //isAddName=true;
        }),
      ),*/
      ),
    );
  }

  Widget emailIcon(){
    return Container(
      child: GestureDetector(
        onTap: ()=> setState(() {
          isAddEmail=!isAddEmail;
        }),
        child: Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isAddEmail? primaryColor: Colors.white,
            ),
            child:isAddEmail? Image.asset(Images.mail_white):
            Image.asset(Images.mail_grey)),

        /* child:
      GestureDetector(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset(Images.name,fit: BoxFit.fill,),
            ),
            SizedBox(height: 10,),
          ],
        ),
        onTap: ()=> setState(() {
          //isAddName=true;
        }),
      ),*/
      ),
    );
  }

  Widget websiteIcon(){
    return Container(
      child: GestureDetector(
        onTap: ()=> setState(() {
          isAddWebsite=!isAddWebsite;
        }),
        child: Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isAddWebsite? primaryColor: Colors.white,
            ),
            child:isAddWebsite? Image.asset(Images.website_white):
            Image.asset(Images.website_grey)),

        /* child:
      GestureDetector(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset(Images.name,fit: BoxFit.fill,),
            ),
            SizedBox(height: 10,),
          ],
        ),
        onTap: ()=> setState(() {
          //isAddName=true;
        }),
      ),*/
      ),
    );
  }

  Widget locationIcon(){
    return Container(
      child: GestureDetector(
        onTap: ()=> setState(() {
          isAddLocation=!isAddLocation;
        }),
        child: Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isAddLocation? primaryColor: Colors.white,
            ),
            child:isAddLocation? Image.asset(Images.address_white):
            Image.asset(Images.address_grey)),

        /* child:
      GestureDetector(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset(Images.name,fit: BoxFit.fill,),
            ),
            SizedBox(height: 10,),
          ],
        ),
        onTap: ()=> setState(() {
          //isAddName=true;
        }),
      ),*/
      ),
    );
  }

  //logo images
  showAddImageDialog() async{
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
          backgroundColor: primaryColor,
          title: new Text('Upload image from',style: TextStyle(color: white),),
          content: new Container(
            height: 110,
            child: Column(
              children: <Widget>[
                Container(
                  child:
                  ElevatedButton(
                    onPressed: (){
                      getAddCameraImage();
                    },
                    child: Text("Camera",style: AppTheme.alert_dialog_action,),
                    style: ElevatedButton.styleFrom(
                      primary: secondaryColor,
                      onPrimary: secondaryColor,
                      minimumSize: Size(MediaQuery.of(context).size.width,40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  child: ElevatedButton(
                    onPressed: (){
                      getAddGalleryImage();
                    },
                    child: Text("Gallery",style: AppTheme.alert_dialog_action,),
                    style: ElevatedButton.styleFrom(
                      primary: secondaryColor,
                      onPrimary: secondaryColor,
                      minimumSize: Size(MediaQuery.of(context).size.width,40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          )
      ),
    ) ;
  }

  Future getAddCameraImage() async {
    Navigator.of(context).pop(false);

    try{
      var image = await _picker.pickImage(source: ImageSource.camera);

      if(image!=null){
        cropAddImage(image);
      }
    }
    catch(e){
     print(e.toString());
    }
  }

  Future getAddGalleryImage() async {
    Navigator.of(context).pop(false);

    var image = await _picker.pickImage(source: ImageSource.gallery);

    if(image!=null){
      cropAddImage(image);
    }
  }

  cropAddImage (XFile image) async {

    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings:[
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ]
    );

    if(croppedFile!=null){
      setState(() {
        File img= File(croppedFile.path);
        addImagesList.add(AddImages(img));
      });
    }
  }
}