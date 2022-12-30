
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:poultry_a2z/PicEditor/utils/colors.dart';
import 'package:poultry_a2z/PicEditor/utils/images.dart';
import 'package:poultry_a2z/PicEditor/utils/styling.dart';
import 'package:http/http.dart' as http;
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:share_extend/share_extend.dart';
import 'package:image/image.dart' as ui;
import 'package:shared_preferences/shared_preferences.dart';

import 'api/all_urls.dart';


class FinalImageScreen extends StatefulWidget{

  String id='';
  String name='';
  String type='';

  Uint8List capturedImage;


  FinalImageScreen(this.capturedImage);


  @override
  _FinalImageScreenState createState() => _FinalImageScreenState(capturedImage);

}

class _FinalImageScreenState extends State<FinalImageScreen>{
  Uint8List capturedImage;
  late Uint8List _finalImage;
  bool isImageReady=false;

  _FinalImageScreenState(this.capturedImage);

  String user_auto_id='';
  bool isApiCallProcess=false;

  int post_count=0;

  Future getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> userMap;

    String user_id = prefs.getString('user_id')!;

    if (user_id != null) {
      setState(() {
        user_auto_id = user_id;
        getPostCount();
      });
    }
  }

  // Future getPlans() async{
  //   setState(() {
  //     isApiCallProcess=true;
  //   });
  //
  //   final body = {
  //     "user_auto_id": user_auto_id,
  //   };
  //
  //   var url=BASE_URL+GET_PLAN_HISTORY;
  //
  //   var uri = Uri.parse(url);
  //
  //   final response = await http.post(uri,body: body);
  //
  //   if (response.statusCode == 200) {
  //     Navigator.pop(context);
  //
  //     setState(() {
  //       isApiCallProcess=false;
  //     });
  //
  //     final resp=jsonDecode(response.body);
  //     // String message=resp['msg'];
  //     int status=resp['status'];
  //     if(status==1){
  //       setState(() {
  //         _finalImage = capturedImage;
  //         isImageReady=true;
  //       });
  //     }
  //     else{
  //       if(post_count>0){
  //         addWatermark();
  //       }
  //       else{
  //         setState(() {
  //           _finalImage = capturedImage;
  //           isImageReady=true;
  //         });
  //       }
  //     }
  //   }
  // }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserId();
  }

  void addWatermark() async{

    try{
      Uint8List watermark_image=await getUint8ListFromAssets();

      ui.Image? originalImage = ui.decodeImage(capturedImage);
      ui.Image? watermarkImage = ui.decodeImage(watermark_image);

     // ui.Image? originalImage = ui.decodeImage(_originalImage.readAsBytesSync());

      // initialize width and height of watermark image
      int watermarkWidth=originalImage!.width;
      int watermarkHeight=originalImage.height;
      //int watermarkWidth=1080;
      //int watermarkHeight=1080;
      ui.Image image = ui.Image(watermarkWidth, watermarkHeight);
      ui.drawImage(image, watermarkImage!);

      // give position to watermark over image
      // originalImage.width - 160 - 25 (width of originalImage - width of watermarkImage - extra margin you want to give)
      // originalImage.height - 50 - 25 (height of originalImage - height of watermarkImage - extra margin you want to give)
      ui.copyInto(originalImage,image, dstX: 0, dstY: 0);

      // for adding text over image
      // Draw some text using 24pt arial font
      // 100 is position from x-axis, 120 is position from y-axis
      //ui.drawString(originalImage!, ui.arial_24, 100, 120, 'Brand Bada Karo');

      // Store the watermarked image to a File
      List<int> wmImage = ui.encodePng(originalImage);
      setState(() {
       // _finalImage = File.fromRawPath(Uint8List.fromList(wmImage));
        _finalImage = Uint8List.fromList(wmImage);
        isImageReady=true;
        print('watermark ready');
      });
    }
    catch(e){
      print(e.toString());
    }

  }

  Future<Uint8List> getUint8ListFromAssets() async {
    final byteData = await rootBundle.load('assets/images/watermark.png');
    final Uint8List list = byteData.buffer.asUint8List();

   // final file = File('${(await getTemporaryDirectory()).path}/app_logo.png');
    //await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>_onBackPressed(),
      child: new Scaffold(
          body:SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color:app_background,
              child: Column(
                children: <Widget> [
                  showHeader(),
                  showFinalImage(),
                  showActions()
                ],
              ),
            ),
          )
      ),
    );
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
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.all(10),
                  child: Image.asset('assets/backpress.png'),
                ),
                onTap: ()=> _onBackPressed(),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text('Save & Share',style: AppTheme.appbar_title,)
              ),
            ),
          ],
        ),
      ),
    );

  }

  _onBackPressed() async{
    Navigator.pop(context);
  }

  Widget showFinalImage(){

    return Container(
      height:MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width,
      child:Stack(
        children: <Widget>[
          Container(
              child: isImageReady==true
                  ? Image.memory(_finalImage)
              //? Image.file(_finalImage)
              //: Container()
                  :Center(
                child: CircularProgressIndicator(),
    )
          ),
        ],
      ),
    );
  }

  Widget showActions() {
    return Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 80,
                    width: 80,
                    child: Icon(Icons.save),
                  ),
                  SizedBox(height: 15,),
                  Text('SAVE',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.grey[600]),)
                ],
              ),
              onTap: () => {
                createPostApi(_finalImage, 'Save')
                //saveImage(capturedImage)
              },
            ),
            SizedBox(width: 50,),
            GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 80,
                    width: 80,
                    child: Icon(Icons.share),
                  ),
                  SizedBox(height: 15,),
                  Text('SHARE',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.grey[600]),)
                ],
              ),
              onTap: () => {
                createPostApi(_finalImage, 'Share')
                //shareScreenshot(capturedImage)
              },
            ),
          ],
        )
    );
  }

  // saveImage(Uint8List capturedImage) async {
  //   String fileName = DateTime.now().microsecondsSinceEpoch.toString();
  //   final result = await ImageGallerySaver.saveImage(
  //       _finalImage,
  //       quality: 100,
  //       name: fileName);
  //
  //   //  final resp=jsonDecode(result.body);
  //
  //   bool status=result['isSuccess'];
  //
  //   if(status){
  //     showMsgDialog("Your image has been downloaded successfully");
  //   }
  //   else{
  //     showMsgDialog("Some error happened when downloading your image");
  //   }
  //   print(status.toString());
  //   print(result.toString());
  // }

  Future<File> getFileFromUint8list(Uint8List capturedImage) async{
    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/image.jpg').create();
    file.writeAsBytesSync(capturedImage);

    return file;
  }

  // shareScreenshot(Uint8List capturedImage) async {
  //
  //   final tempDir = await getTemporaryDirectory();
  //   final file = await new File('${tempDir.path}/image.jpg').create();
  //   file.writeAsBytesSync(_finalImage);
  //
  //   ShareExtend.share(file.path, "file");
  // }

  void showMsgDialog(String error){
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

  Future createPostApi(Uint8List capturedImage,String action) async {

    File post_file= await getFileFromUint8list(capturedImage);

    setState(() {
      isApiCallProcess=true;
    });

    showprogressDialog('Please wait');

    var url=BASE_URL+CREATE_POST;

    var uri = Uri.parse(url);

    var request = new http.MultipartRequest("POST", uri);

    try{
      if(post_file!=null){
        request.files.add(
          http.MultipartFile(
            'image_file',
            post_file.readAsBytes().asStream(),
            await post_file.length(),
            filename: post_file.path.split('/').last,),);

      }
    }
    catch(exception){
      print('file not selected');
    }

    request.fields["user_auto_id"] = user_auto_id;
    request.fields["type"] = 'image';
    request.fields["video_file"] = "";

    http.Response response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      setState(() {
        isApiCallProcess=false;
      });
      Navigator.pop(context);

      final resp=jsonDecode(response.body);
      String message=resp['msg'];
      int status=resp['status'];
      if(status==1){
        //showMsgDialog('Post created successfully');
        // if(action=='Save'){
        //   saveImage(capturedImage);
        // }
        // else if(action=='Share'){
        //   shareScreenshot(capturedImage);
        // }
      }
      else{
        showMsgDialog('Something went wrong. Please try later');
      }
    }
  }

  Future getPostCount() async{
    showprogressDialog('Please wait');

    final body = {
      "user_auto_id": user_auto_id,
    };

    var url=BASE_URL+GET_POST_COUNT;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      // getPlans();
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        setState(() {
          post_count=resp['posts_count'];
        });
      }
      else{
        setState(() {
          post_count=0;
        });
      }
    }
  }

  void showprogressDialog(String msg){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
          backgroundColor: primaryColor,
          content: Wrap(
              children: <Widget>[
                Container(
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

              ]
          )      ),
    ) ;
  }

}