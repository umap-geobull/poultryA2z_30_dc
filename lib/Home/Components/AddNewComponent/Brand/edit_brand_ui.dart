import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/all_brands_model.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:getwidget/getwidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../MainCategories/main_category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


typedef OnSaveCallback = void Function();

class EditBrand extends StatefulWidget {

  OnSaveCallback onSaveCallback;
  GetBrandslist brand;

  EditBrand(this.onSaveCallback,this.brand);

  @override
  _EditBrand createState() => _EditBrand(brand);

}

class _EditBrand extends State<EditBrand> {
  _EditBrand(this.brand);

  final TextEditingController _textEditingController=TextEditingController();
  GetBrandslist brand;

  String app_icon_image='';

  late File icon_img;
  late XFile pickedImageFile;

  bool isIconSelected=false;
  final ImagePicker _picker = ImagePicker();

  bool isApiCallProcessing=false,isDeleteProcessing=false;

  List<GetmainCategorylist> mainCategoryList=[];

  List<String> selectedMainCategory=[];

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

      getMainCategories();
    }
  }

  bool isAdded(String id){
    for(int i=0;i<selectedMainCategory.length;i++){
      if(selectedMainCategory[i]==id){
        return true;
      }
    }
    return false;
  }

  showInUi(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('  Select main categories',style: TextStyle(color: Colors.black87,fontSize: 15,),),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child:  GridView.builder(
              itemCount: mainCategoryList.length,
              //physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1/0.4,
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) =>
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child:  Row(
                        mainAxisAlignment:  MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            child: Checkbox(
                              
                              onChanged: (value) {
                                if(mounted){
                                  setState(() {
                                    if(isAdded(mainCategoryList[index].id)==true){
                                      selectedMainCategory.remove(mainCategoryList[index].id);
                                    }
                                    else{
                                      selectedMainCategory.add(mainCategoryList[index].id);
                                    }
                                  });
                                }
                              },
                              value: isAdded(mainCategoryList[index].id),
                            ),
                            margin: const EdgeInsets.all(5),
                          ),
                          Flexible(
                            child: Text(
                              //'fjdw[g fpfj jqfp[0j [fjo[',
                              mainCategoryList[index].categoryName,
                              style: const TextStyle(fontSize: 14, color: Colors.black, ),
                            ),
                          )
                        ]
                    ),
                  )

          ),
        )

      ],
    );
  }

  void getMainCategories() async {
    var url=baseUrl+'api/'+get_main_categories;
    var uri = Uri.parse(url);
    final body={
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        MainCategoryModel mainCategoryModel=MainCategoryModel.fromJson(json.decode(response.body));
        mainCategoryList=mainCategoryModel.getmainCategorylist;

        print(mainCategoryList.toString());
        if(mounted){
          setState(() {});
        }
      }
    }
    else if(response.statusCode==500){
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
      Fluttertoast.showToast(msg: "Server error in getting main categories", backgroundColor: Colors.grey,);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();

    _textEditingController.text=brand.brandName;
    app_icon_image=brand.brandImageApp;

    String showCategory=brand.main_category_auto_id;

    selectedMainCategory=showCategory.split('|');
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
                                        backgroundColor: Colors.blue,
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
                                        backgroundColor: Colors.redAccent,
                                        minimumSize: const Size(80, 25)
                                    ),
                                    child: const Text('Delete'),
                                    onPressed: () {
                                      showAlert();
                                    },
                                  )

                                ],
                              )

                          )
                        ),
                      ],
                    ),

                   /* Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: ()=>{Navigator.pop(context)},
                            icon: Icon(Icons.close),
                          ),
                        ),
                        Text(
                          'Edit Brand',style: TextStyle(color: Colors.black87,fontSize: 14),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin: EdgeInsets.only(right: 5),
                              alignment: Alignment.centerRight,
                              child:
                              isDeleteProcessing==true?
                              Container(
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
                                    minimumSize: Size(80, 25)
                                ),
                                child: Text('Delete'),
                                onPressed: () {
                                  showAlert();
                                },
                              )
                          ),
                        ),
                      ],
                    ),*/
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
                    showInUi(),

                  /*  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(20),
                      child:
                      isApiCallProcessing?
                      GFLoader(
                          type:GFLoaderType.circle
                      ):
                      isDeleteProcessing?
                      Container():
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orangeAccent,
                            minimumSize: Size(200, 35)
                        ),
                        child: Text('SAVE'),
                        onPressed: () {
                          if(checkValid()==true){
                            editBrandApi();
                          }
                        },
                      ),
                    )*/
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
    String mainCategory='';
    for(int i=0;i<selectedMainCategory.length;i++){
      if(i==0){
        mainCategory+=selectedMainCategory[i];
      }
      else{
        mainCategory += '|'+selectedMainCategory[i];
      }
    }

    setState(() {
      isApiCallProcessing=true;
    });

    var url=baseUrl+'api/'+edit_brand;

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
    request.fields["main_category_auto_id"]= mainCategory;
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
  /*  else if(icon_img==null){
      Fluttertoast.showToast(msg: "Please select brand image", backgroundColor: Colors.grey,);
      return false;
    }*/
    return true;
  }

  Future deleteBrandApi() async {
    setState(() {
      isDeleteProcessing=true;
    });

    final body = {
      "brand_auto_id":brand.id ,
      "admin_auto_id":admin_auto_id,
      "app_type_id":app_type_id,
    };

    var url=baseUrl+'api/'+delete_brand;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      setState(() {
        isDeleteProcessing=false;
      });
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        Fluttertoast.showToast(msg: "Brand has been deleted successfully", backgroundColor: Colors.grey,);
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

  showAlert() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: const Text('Are you sure?',style: TextStyle(color: Colors.black87),),
          content:Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    const Text('Do you want to delete this brand',style: TextStyle(color: Colors.black54),),
                    const SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            child: ElevatedButton(
                              onPressed: (){
                                deleteBrandApi();
                                Navigator.pop(context);
                              },
                              child: const Text("Yes",style: TextStyle(color: Colors.black54,fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green[200],
                                onPrimary: Colors.green,
                                minimumSize: const Size(70,30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )
                        ),
                        const SizedBox(width: 10,),
                        Container(
                            child: ElevatedButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              child: const Text("No",
                                  style: TextStyle(color: Colors.black54,fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue[200],
                                onPrimary: Colors.blue,
                                minimumSize: const Size(70,30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

}