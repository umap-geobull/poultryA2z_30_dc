import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_Product_Opreation/Model/Approve_BrandModel.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/all_brands_model.dart';
import 'package:poultry_a2z/Home/Components/MainCategories/main_category_model.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:getwidget/getwidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnSaveCallback = void Function();

class EditBrand extends StatefulWidget {

  OnSaveCallback onSaveCallback;
  GetVendorBrandApprovalLists brand;

  EditBrand(this.onSaveCallback,this.brand);

  @override
  _EditBrand createState() => _EditBrand(brand);

}

class _EditBrand extends State<EditBrand> {
  _EditBrand(this.brand);

  final TextEditingController _textEditingController=TextEditingController();
  GetVendorBrandApprovalLists brand;

  String app_icon_image='';

  late File icon_img;
  late XFile pickedImageFile;

  bool isIconSelected=false;
  final ImagePicker _picker = ImagePicker();

  bool isApiCallProcessing=false,isDeleteProcessing=false;

  String baseUrl='';

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if(baseUrl!=null){
      this.baseUrl=baseUrl;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();

    _textEditingController.text=brand.brandName;
    app_icon_image=brand.brandImageApp;
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
                          'Edit Brand',style: TextStyle(color: Colors.black87,fontSize: 14),
                        ),

                        Expanded(
                          flex: 1,
                          child:
                          Container(
                            width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(right: 5),
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  isApiCallProcessing==true?
                                  const SizedBox(
                                    width: 80,
                                    child: GFLoader(
                                        type:GFLoaderType.circle
                                    ),
                                  ):
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.blue,
                                        minimumSize: const Size(80, 25)
                                    ),
                                    child: const Text('Save'),
                                    onPressed: ()=>{
                                      if(checkValid()==true){
                                        editBrandApi()
                                      }
                                    },
                                  ),

                                  const SizedBox(width: 5,),
                                ],
                              )

                          )
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
                            hintText: 'Please enter brand name',
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
                          ),
                        )
                    ),
                    uploadLogoUi(),
                    const SizedBox(height: 15,),
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
                    imageUrl: baseUrl+brands_base_url+app_icon_image,
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

  Future editBrandApi() async {
    setState(() {
      isApiCallProcessing=true;
    });

    var url=baseUrl+'api/'+edit_brand_vendor;

    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);

    try{
      request.files.add(
        http.MultipartFile(
          'brand_image_app',
          icon_img.readAsBytes().asStream(),
          await icon_img.length(),
          filename: icon_img.path.split('/').last,),);
    }
    catch(exception){
      print('pic not selected');
    }

    request.fields["brand_name"] = _textEditingController.text;
    request.fields["brand_image_web"] = '';
    request.fields["brand_auto_id"]=brand.id;
    request.fields["user_auto_id"]=brand.userAutoId;

    http.Response response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      setState(() {
        isApiCallProcessing=false;
      });
      final resp=jsonDecode(response.body);
      //String message=resp['msg'];
      String status=resp['status'];
      if(status=='1'){
        Fluttertoast.showToast(msg: "Brand has been updated successfully", backgroundColor: Colors.grey,);
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

  bool checkValid(){
    if(_textEditingController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please add brand name", backgroundColor: Colors.grey,);
      return false;
    }
    else if(icon_img==null){
      Fluttertoast.showToast(msg: "Please select brand image", backgroundColor: Colors.grey,);
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

    var pickedFile  = await _picker.pickImage(source: ImageSource.gallery);

    if(pickedFile!=null){
      pickedImageFile=pickedFile;

      File selectedImg = File(pickedImageFile.path);

      cropImage(selectedImg);
    }
  }

  cropImage (File icon) async {

    File? croppedFile = (await ImageCropper().cropImage(
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
    )) as File?;

    if(croppedFile!=null){
      setState(() {
        icon_img = File(croppedFile.path);
        isIconSelected=true;
      });
    }
  }
}