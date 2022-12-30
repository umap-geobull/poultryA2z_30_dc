import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../Utils/App_Apis.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:getwidget/getwidget.dart';
import 'main_category_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';


typedef OnSaveCallback = void Function();

class EditMainCategory extends StatefulWidget {

  OnSaveCallback onSaveCallback;
  GetmainCategorylist getmainCategorylist;

  EditMainCategory(this.onSaveCallback,this.getmainCategorylist);

  @override
  _EditMainCategory createState() => _EditMainCategory(getmainCategorylist);

}

class _EditMainCategory extends State<EditMainCategory> {
  _EditMainCategory(this.getmainCategorylist);

  final TextEditingController _textEditingController=TextEditingController();
  GetmainCategorylist getmainCategorylist;

  String app_icon_image='';

  late File icon_img;
  late XFile pickedImageFile;

  bool isIconSelected=false;
  final ImagePicker _picker = ImagePicker();

  bool isApiCallProcessing=false,isDeleteProcessing=false;

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

    _textEditingController.text=getmainCategorylist.categoryName;
    app_icon_image=getmainCategorylist.categoryImageApp;
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
                        const Text(
                          'Edit Main Category',style: TextStyle(color: Colors.black87,fontSize: 14),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin: const EdgeInsets.only(right: 5),
                              alignment: Alignment.centerRight,
                              child:
                              isDeleteProcessing==true?
                              const SizedBox(
                                width: 80,
                                child: GFLoader(
                                    type:GFLoaderType.circle
                                ),
                              ):
                              isApiCallProcessing==true?
                              Container():
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.redAccent,
                                    minimumSize: const Size(80, 25)
                                ),
                                child: const Text('Delete'),
                                onPressed: () {
                                  deleteMainCategoryApi();
                                },
                              )
                          ),
                        ),
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          controller: _textEditingController,
                          decoration: const InputDecoration(
                            // contentPadding: new EdgeInsets.only(top: 5.0, bottom: 5.0),
                            hintText: 'Please enter category name',
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
                          ),
                        )
                    ),
                    uploadLogoUi(),

                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(20),
                      child:
                      isApiCallProcessing?
                      const GFLoader(
                          type:GFLoaderType.circle
                      ):
                      isDeleteProcessing?
                      Container():
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orangeAccent,
                            minimumSize: const Size(200, 35)
                        ),
                        child: const Text('SAVE'),
                        onPressed: () {
                          if(checkValid()==true){
                            editMainCategoryApi();
                          }
                        },
                      ),
                    )
                  ],
                )
            ),)
      );
    }
    );
  }

  Widget uploadLogoUi() {
    return GestureDetector(
      onTap: ()=>{showImageDialog()},
      child: Container(
          height: 100,
          width: 100,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
          child:Container(
              child:
                  isIconSelected ?
                  ClipRRect(
                    child: Image.file(File(icon_img.path), height: 60,
                      width: 60,),
                  ):
                  app_icon_image!=''?
                  CachedNetworkImage(
                    height: 100,
                    width: 100,
                    imageUrl: baseUrl+main_categories_base_url+app_icon_image,
                    placeholder: (context, url) =>
                        Container(decoration: BoxDecoration(
                          color: Colors.grey[400],
                        )),
                    // progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ):
                  const Icon(Icons.image,size: 80,)
          )
      ),
    );
  }

  Future editMainCategoryApi() async {
    setState(() {
      isApiCallProcessing=true;
    });

    var url=baseUrl+'api/'+edit_main_categories;

    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);

    try{
      if(icon_img!=null){
        request.files.add(
          http.MultipartFile(
            'category_image_app',
            icon_img.readAsBytes().asStream(),
            await icon_img.length(),
            filename: icon_img.path.split('/').last,),);
      }
      else{
        request.fields["category_image_app"] = app_icon_image;
      }
    }
    catch(exception){
      print('profile pic not selected');
      request.fields["category_image_app"] = app_icon_image;
    }

    request.fields["main_category_auto_id"] = widget.getmainCategorylist.id;
    request.fields["category_name"] = _textEditingController.text;
    request.fields["category_image_web"] = '';
    request.fields["admin_auto_id"] =admin_auto_id;
    request.fields["app_type_id"] =app_type_id;

    http.Response response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      setState(() {
        isApiCallProcessing=false;
      });
      final resp=jsonDecode(response.body);
      //String message=resp['msg'];
      String status=resp['status'];
      if(status=='1'){
        Fluttertoast.showToast(msg: "Category updated successfully", backgroundColor: Colors.grey,);
        widget.onSaveCallback();
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

  Future deleteMainCategoryApi() async {
    setState(() {
      isDeleteProcessing=true;
    });

    final body = {
      "main_category_auto_id": widget.getmainCategorylist.id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    var url=baseUrl+'api/'+delete_main_categories;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      setState(() {
        isDeleteProcessing=false;
      });
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        Fluttertoast.showToast(msg: "Category deleted successfully", backgroundColor: Colors.grey,);
        widget.onSaveCallback();
      }
      else{
        Fluttertoast.showToast(msg: "Something went wrong.Please try later", backgroundColor: Colors.grey,);
      }
    }
  }

  bool checkValid(){
    if(_textEditingController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please add subcategory name", backgroundColor: Colors.grey,);
      return false;
    }
    return true;
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

      cropImage(selectedImg);
    }


    /* pickedImageFile= (await _picker.pickImage(source: ImageSource.camera).whenComplete(() =>
    {
      if(pickedImageFile!=null){
        selectedImg = File(pickedImageFile.path),
        if(selectedImg!=null){
          cropImage(selectedImg)
        }
      }
    }
    )
    )!;*/

  }

  Future getGalleryImage() async {
    Navigator.of(context).pop(false);
    File selectedImg;

   /* pickedImageFile = (await _picker.pickImage(source: ImageSource.gallery).whenComplete(() => {
      if(pickedImageFile!=null){
        selectedImg = File(pickedImageFile.path),
        if(selectedImg!=null){
          cropImage(selectedImg)
        }
      }
    }
    ))!;
*/
    var pickedFile  = await _picker.pickImage(source: ImageSource.gallery);

    if(pickedFile!=null){
      pickedImageFile=pickedFile;

      File selectedImg = File(pickedImageFile.path);

      cropImage(selectedImg);
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
    ));

    if(croppedFile!=null){
      setState(() {
        icon_img = File(croppedFile.path);
        isIconSelected=true;
      });
    }
  }
}