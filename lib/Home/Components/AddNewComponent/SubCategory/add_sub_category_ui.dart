import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';


typedef OnSaveCallback = void Function();

class AddSubCategory extends StatefulWidget {

  OnSaveCallback onSaveCallback;
  String main_category_auto_id;

  AddSubCategory(this.onSaveCallback,this.main_category_auto_id);

  @override
  _AddSubCategory createState() => _AddSubCategory();

}

class _AddSubCategory extends State<AddSubCategory> {
  final TextEditingController _textEditingController=TextEditingController();

  late File icon_img;
  late XFile pickedImageFile;

  bool isIconSelected=false;
  final ImagePicker _picker = ImagePicker();

  bool isApiCallProcessing=false;

  int img_width=0,img_height=0;

  String baseUrl='',admin_auto_id='',app_type_id='';

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');
    if(baseUrl!=null && adminId!=null && apptypeid!=null){
      this.admin_auto_id=adminId;
      this.baseUrl=baseUrl;
      this.app_type_id=apptypeid;
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: ()=>{Navigator.pop(context)},
                          icon: const Icon(Icons.close),
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: Text(
                          'Add Sub Category',style: TextStyle(color: Colors.black87,fontSize: 14),
                        ),
                      )

                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child:
                    TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                         // contentPadding: new EdgeInsets.only(top: 5.0, bottom: 5.0),
                          hintText: 'Please enter sub category name',
                          hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
                      ),
                    )
                  ),
                  uploadLogoUi(),
                  isApiCallProcessing?
                  const GFLoader(
                      type:GFLoaderType.circle
                  ):
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orangeAccent,
                    ),
                    child: const Text('ADD'),
                    onPressed: () {
                      if(checkValid()==true){
                        addSubCategoryApi();
                      }
                    },
                  ),
                ],
              )
            ),)
      );
    }
    );
  }

  bool checkValid(){
    if(_textEditingController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please add subcategory name", backgroundColor: Colors.grey,);
      return false;
    }
    else if(icon_img==null){
      Fluttertoast.showToast(msg: "Please select subcategory image", backgroundColor: Colors.grey,);
      return false;
    }
  /*  else if(img_height!=img_width){
      Fluttertoast.showToast(msg: "Image size must be 1:1 (For ex. 200 x 200)", backgroundColor: Colors.grey,);
      return false;
    }*/
    return true;
  }

  Widget uploadLogoUi() {
    return GestureDetector(
      onTap: ()=>{showImageDialog()},
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
              width: 100,
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              child:Container(
                  child: isIconSelected ?
                  ClipRRect(
                    child: Image.file(File(icon_img.path), height: 100,
                      width: 100,),
                  ):
                  const Icon(Icons.image,size: 80,)
              )
          )
          //isIconSelected==true && img_width!=img_height?
         // Text('Icon size must be 1:1 (For ex. 200 x 200)',style: TextStyle(color: Colors.redAccent,fontSize: 10),):
          //Container()
        ],
      ),
    );
  }

  Future addSubCategoryApi() async {
    setState(() {
      isApiCallProcessing=true;
    });

    var url=baseUrl+'api/'+add_sub_category;

    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);

    try{
      request.files.add(
        http.MultipartFile(
          'subcategory_image_app',
          icon_img.readAsBytes().asStream(),
          await icon_img.length(),
          filename: icon_img.path.split('/').last,),);
    }
    catch(exception){
      print('profile pic not selected');
      request.fields["category_image_app"] = '';
    }

    request.fields["sub_category_name"] = _textEditingController.text;
    request.fields["subcategory_image_web"] = '';
    request.fields["main_category_auto_id"]=widget.main_category_auto_id;
    request.fields["admin_auto_id"] =admin_auto_id;
    request.fields["app_type_id"] =app_type_id;

    print('admin id: '+admin_auto_id);

    http.Response response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      setState(() {
        isApiCallProcessing=false;
      });
      final resp=jsonDecode(response.body);
      //String message=resp['msg'];
      String status=resp['status'];
      if(status=='1'){
        Fluttertoast.showToast(msg: "Subcategory added successfully", backgroundColor: Colors.grey,);
        widget.onSaveCallback();
        Navigator.pop(context);
      }
      else{
        Fluttertoast.showToast(msg: "Something went wrong.Please try later", backgroundColor: Colors.grey,);
      }
    }
    else if(response.statusCode==500){
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
      Fluttertoast.showToast(msg: "Server Error", backgroundColor: Colors.grey,);
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
    Navigator.of(context).pop(false);
    var pickedFile  = await _picker.pickImage(source: ImageSource.gallery);

    if(pickedFile!=null){
      pickedImageFile=pickedFile;

      File selectedImg = File(pickedImageFile.path);

      icon_img = selectedImg;
      isIconSelected=true;

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
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ]
    )) ;

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

}