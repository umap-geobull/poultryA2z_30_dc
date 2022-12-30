import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poultry_a2z/Utils/AppConfig.dart';
import 'package:poultry_a2z/grobiz_start_pages/UserBusiness/app_logo_list_model.dart';
import 'package:poultry_a2z/grobiz_start_pages/profile/admin_profile_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;
import '../../Utils/App_Apis.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';


typedef OnSaveCallback = void Function();

class SelectLogo extends StatefulWidget {

  OnSaveCallback onSaveCallback;

  @override
  _SelectLogo createState() => _SelectLogo();

  SelectLogo(this.onSaveCallback,);
}

class _SelectLogo extends State<SelectLogo> {
  bool isApiProcessing=false;

  String baseUrl='';

  //List<String> demoLogo=["assets/demo_icon.png","assets/demo_icon2.png"];

  late File icon_img;
  late XFile pickedImageFile;

  bool isIconSelected=false;
  final ImagePicker _picker = ImagePicker();
  int img_width=0,img_height=0;
  String user_id='';

  String businessDetailsId='',businessName='',businessLogo='';
  late AdminProfileModel adminProfileModel;
  List<LogosList> demoLogo=[];

  bool selectDemo =false;

  void getUserId() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    print(userId);
    if(userId!=null){
      this.user_id=userId;
      print(user_id);
      setState(() {
        getAdminProfile();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserId();
    getSampleLogo();
    getBusinessDetailsSession();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Material(
          child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            scrollDirection: Axis.vertical,
            child: AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 100),
              child:SizedBox(
                height: 450,
                child:Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: ()=>{Navigator.pop(context)},
                              icon: const Icon(Icons.close),
                            ),
                            Text('  Select logo',style: TextStyle(color: Colors.black87),),
                            Expanded(child: Container(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: ()=>{
                                  if(isIconSelected==false && businessLogo.isEmpty){
                                    Fluttertoast.showToast(msg: "Please select business logo", backgroundColor: Colors.grey,)
                                  }
                                  else{
                                    editLogoApi()
                                  }
                                },
                                child: Text('Save', style: TextStyle(fontSize: 17),),
                              ),
                            ))
                          ],
                        ),
                        Divider(
                          height: 10,
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10,),
                        Text('  Select from sample logos:',style: TextStyle(color: Colors.black87),),
                        Container(
                          margin: EdgeInsets.all(10),
                         height: 100,
                         child: ListView.builder(
                           shrinkWrap: true,
                           scrollDirection: Axis.horizontal,
                           itemCount: demoLogo.length,
                           itemBuilder: (context, index) =>
                               GestureDetector(
                                 onTap: ()=>{
                                   if(isApiProcessing==false){
                                     selectDemoImage(demoLogo[index].logo)
                                   }
                                 },
                                 child: Container(
                                   height: 100,
                                   width: 100,
                                   padding: const EdgeInsets.all(10),
                                   margin: EdgeInsets.all(5),
                                   alignment: Alignment.center,
                                   decoration: BoxDecoration(
                                       border: Border.all(
                                           color: Colors.grey,
                                           width: 1
                                       ),
                                       borderRadius: BorderRadius.circular(10)
                                   ),
                                     child:Container(
                                         child: CachedNetworkImage(
                                           height: 100,
                                           width: 100,
                                           imageUrl: demo_logo_base_url+demoLogo[index].logo,
                                           placeholder: (context, url) =>
                                               Container(decoration: BoxDecoration(
                                                 color: Colors.grey[400],
                                               )),
                                           errorWidget: (context, url, error) => const Icon(Icons.error),
                                         )
                                     )

                                   //child: Image.asset(demoLogo[index],height: 50,width: 50,),
                                 ),
                               ))
                       ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: Text('  OR',style: TextStyle(color: Colors.black87,fontSize: 17,fontWeight: FontWeight.bold),),
                        ),
                        uploadLogoUi()
                      ],
                    ),

                    isApiProcessing==true?
                    Center(
                      child: GFLoader(
                          type:GFLoaderType.circle
                      ),
                    ):
                    Container()
                  ],
                )
              )
            ),
          )
      );
    }
    );
  }

  Widget uploadLogoUi() {
    return GestureDetector(
      onTap: ()=>{
        //getGalleryImage()

        // showImageDialog()
      },
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          isIconSelected==true?
          GestureDetector(
            onTap: ()=>{
              cropImage(icon_img)
            },
            child:Container(
              margin: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const <Widget>[
                  Text('Edit Image',style: TextStyle(color: Colors.blue),),
                  Icon(Icons.crop_free,color: Colors.blue,)
                ],
              ),
            ),
          ):
          Container(),

          Container(
              height: 100,
              width: 300,
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              child:Container(
                  child: isIconSelected ?
                  ClipRRect(
                    child: Image.file(File(icon_img.path), height: 100,
                      width: 300,),
                  ):
                  businessLogo.isNotEmpty?
                  CachedNetworkImage(
                    height: 100,
                    width: 100,
                    imageUrl: app_logo_base_url+businessLogo,
                    placeholder: (context, url) =>
                        Container(decoration: BoxDecoration(
                          color: Colors.grey[400],
                        )),
                    // progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ):
                  Icon(Icons.image,size: 80,)
              )
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.orangeAccent,
                minimumSize: const Size(150, 30)
            ),
            child: const Text('Select Logo'),
            onPressed: () {
              getGalleryImage();
            },
          )



/*
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.orangeAccent,
                minimumSize: const Size(200, 35)
            ),
            child: const Text('SAVE'),
            onPressed: () {
              if(isIconSelected==false && businessLogo.isEmpty){
                Fluttertoast.showToast(msg: "Please select business logo", backgroundColor: Colors.grey,);
              }
              else{
                editLogoApi();
              }
            },
          )
*/
        ],
      ),
    );
  }

  Future getCameraImage() async {
    Navigator.of(context).pop(false);
    var pickedFile  = await _picker.pickImage(source: ImageSource.camera);

    if(pickedFile!=null){
      pickedImageFile=pickedFile;

      File selectedImg = File(pickedImageFile.path);

      icon_img = selectedImg;
      isIconSelected=true;

      getFileSize();

      /*if(selectedImg!=null){
        cropImage(selectedImg);
      }*/
    }
  }

  Future getGalleryImage() async {
    var pickedFile  = await _picker.pickImage(source: ImageSource.gallery);

    if(pickedFile!=null){
      pickedImageFile=pickedFile;

      File selectedImg = File(pickedImageFile.path);

      icon_img = selectedImg;
      isIconSelected=true;

      print(icon_img);

      getFileSize();
      /* if(selectedImg!=null){
        cropImage(selectedImg);
      }*/
    }
  }

  cropImage (File icon) async {

    CroppedFile? croppedFile = (await ImageCropper().cropImage(
      sourcePath: icon.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
       uiSettings:[
         AndroidUiSettings(
           backgroundColor: Colors.white,
             toolbarTitle: 'Cropper',
             toolbarColor: Colors.deepOrange,
             toolbarWidgetColor: Colors.white,
             initAspectRatio: CropAspectRatioPreset.original,
             lockAspectRatio: false),
         IOSUiSettings(
           title: 'Cropper',
         ),
       ]
    ));

    if(croppedFile!=null){
      icon_img = File(croppedFile.path);
      isIconSelected=true;

      getFileSize();
    }
  }

  getFileSize() async{
    var decodedImage = await decodeImageFromList(icon_img.readAsBytesSync());
    img_height=decodedImage.height;
    img_width=decodedImage.width;

    if(mounted){
      setState(() {
      });
    }
  }

  showImageDialog() async{
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: const Text('Upload image from',style: TextStyle(color: Colors.black87),),
          content: SizedBox(
            height: 110,
            child: Column(
              children: <Widget>[
                Container(
                  child:
                  ElevatedButton(
                    onPressed: (){
                      getCameraImage();
                    },
                    child: const Text("Camera",
                        style: TextStyle(color: Colors.black54,fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.blue,
                      minimumSize: const Size(150,30),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  child: ElevatedButton(
                    onPressed: (){
                      getGalleryImage();
                    },
                    child: const Text("Gallery",
                        style: TextStyle(color: Colors.black54,fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.blue,
                      minimumSize: const Size(150,30),
                      shape: const RoundedRectangleBorder(
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

  selectDemoImage(String path) async {

    if(this.mounted){
      setState(() {
        isApiProcessing=true;
      });
    }

    icon_img= await urlToFile(demo_logo_base_url+path);
    print(icon_img);

    isIconSelected=true;
    if(this.mounted){
      setState(() {
        isApiProcessing=false;
      });
    }
  }

  Future editLogoApi() async {
    setState(() {
      isApiProcessing=true;
    });

    var url=AppConfig.grobizBaseUrl+update_profile;

    print(url);

    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);

    if(isIconSelected==true){
      try{
        if(icon_img!=null){
          request.files.add(
            http.MultipartFile(
              'app_logo',
              icon_img.readAsBytes().asStream(),
              await icon_img.length(),
              filename: icon_img.path.split('/').last,),);
        }
        else{
          request.fields["app_logo"] = '';
        }
      }
      catch(exception){
        print('iocn pic not selected');
        request.fields["app_logo"] = '';
      }
    }

    request.fields["user_auto_id"] = user_id;
    request.fields["app_name"] = adminProfileModel.data[0].appName;
    request.fields["app_type"] = adminProfileModel.data[0].appType;
    request.fields["country_code"] = adminProfileModel.data[0].countryCode;
    request.fields["contact"] = adminProfileModel.data[0].contact;
    request.fields["country"] = adminProfileModel.data[0].country;
    request.fields["city"] = adminProfileModel.data[0].city;
    request.fields["name"] = adminProfileModel.data[0].name;
    request.fields["email"] = adminProfileModel.data[0].email;
    request.fields["app_type_id"] = adminProfileModel.data[0].appTypeId!;

    http.Response response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){

        Fluttertoast.showToast(msg: "Business details updated successfully", backgroundColor: Colors.grey,);
        widget.onSaveCallback();

      }
      else{
        String message=resp['msg'];
        Fluttertoast.showToast(msg: message, backgroundColor: Colors.grey,);
      }

      if(this.mounted){
        setState(() {
          isApiProcessing=false;
        });
      }
    }
    else if(response.statusCode==500){
      if(this.mounted){
        setState(() {
          isApiProcessing=false;
        });
      }
      Fluttertoast.showToast(msg: "Server Error", backgroundColor: Colors.grey,);
    }
  }

  Future getAdminProfile() async {
    setState(() {
      isApiProcessing=true;
    });

    print('user_id: '+user_id);

    final body = {
      "user_auto_id":user_id,
    };

    var url=AppConfig.grobizBaseUrl+get_admin_profile;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);
    print(response.statusCode.toString());

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      print(status.toString());
      if(status==1){
        adminProfileModel=AdminProfileModel.fromJson(json.decode(response.body));
        businessLogo=adminProfileModel.data[0].appLogo;

        print(resp.toString());
        if(this.mounted){
          setState(() {
            isApiProcessing=false;
          });
        }
      }
      else {
        String msg=resp['msg'];
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
      }
    }
    else if (response.statusCode == 500) {
      Fluttertoast.showToast(msg: 'Server error', backgroundColor: Colors.grey,);
      setState(() {});
    }
  }

  Future getSampleLogo() async {
    setState(() {
      isApiProcessing=true;
    });

    print('user_id: '+user_id);

    var url=AppConfig.grobizBaseUrl+get_logos_list;

    var uri = Uri.parse(url);

    final response = await http.get(uri);

    print(response.statusCode.toString());

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      print(status.toString());
      if(status==1){
        AppLogoListModel appLogoListModel=AppLogoListModel.fromJson(json.decode(response.body));
        demoLogo=appLogoListModel.logosList;
        if(this.mounted){
          setState(() {
            isApiProcessing=false;
          });
        }
      }
      else {
        String msg=resp['msg'];
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
      }
    }
    else if (response.statusCode == 500) {
      Fluttertoast.showToast(msg: 'Server error', backgroundColor: Colors.grey,);
      setState(() {});
    }
  }

  Future getBusinessDetailsSession() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();

    String? businssName =prefs.getString('business_name');
    String? businessLogo =prefs.getString('business_logo');
    String? buisnessId =prefs.getString('business_id');

    if(buisnessId!=null){
      this.businessDetailsId=buisnessId;
      print(this.businessDetailsId);
    }
    if(businssName!=null){
      this.businessName=businssName;
      print(this.businessName);
    }
    if(businessLogo!=null){
      this.businessLogo=businessLogo;
      print(this.businessLogo);
    }

    if(this.mounted){
      setState(() {});
    }

    print('business details get');
  }

  storeBusinessDetails() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();

    prefs.setString('business_name', businessName);
    prefs.setString('business_id', businessDetailsId);
    prefs.setString('business_logo', businessLogo);

    print('user pincode  saved');

    Fluttertoast.showToast(msg: "Business details updated successfully", backgroundColor: Colors.grey,);
    widget.onSaveCallback();
  }

  Future<File> urlToFile(String imageUrl) async {
    var rng = Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File(tempPath+ (rng.nextInt(100)).toString() +'.png');
    Uri uri=Uri.parse(imageUrl);
    http.Response response = await http.get(uri);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

}