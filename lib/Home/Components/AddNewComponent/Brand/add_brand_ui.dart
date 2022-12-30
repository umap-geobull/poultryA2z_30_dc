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
import '../../MainCategories/main_category_model.dart';


typedef OnSaveCallback = void Function();

class AddBrand extends StatefulWidget {

  OnSaveCallback onSaveCallback;

  AddBrand(this.onSaveCallback);

  @override
  _AddBrand createState() => _AddBrand();

}

class _AddBrand extends State<AddBrand> {
  final TextEditingController _textEditingController=TextEditingController();

  late File icon_img;
  late XFile pickedImageFile;

  bool isIconSelected=false;
  final ImagePicker _picker = ImagePicker();

  bool isApiCallProcessing=false;

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
              physics: const NeverScrollableScrollPhysics(),
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
      Fluttertoast.showToast(msg: "Server error while getting main categories", backgroundColor: Colors.grey,);
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
                      const Text(
                        'Add Brand',style: TextStyle(color: Colors.black87,fontSize: 14),
                      ),
                      Expanded(
                          flex:1,
                          child:Container(
                            alignment: Alignment.centerRight,
                            child:
                            isApiCallProcessing==true?
                            const SizedBox(
                              width: 80,
                              child: GFLoader(
                                  type:GFLoaderType.circle
                              ),
                            ):
                            TextButton(
                              onPressed: ()=>{
                              if(checkValid()==true){
                                addBrandApi()
                              }
                              },
                              child: const Text('SAVE'),
                            ),
                          )
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
                          hintText: 'Please enter brand name',
                          hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
                      ),
                    )
                  ),
                  uploadLogoUi(),
                  const SizedBox(height: 15,),
                  showInUi(),
                ],
              )
            ),)
      );
    }
    );
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
    else if(selectedMainCategory.isEmpty){
      Fluttertoast.showToast(msg: "Please select main categories", backgroundColor: Colors.grey,);
      return false;
    }
    return true;
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
              child: isIconSelected ?
              ClipRRect(
                child: Image.file(File(icon_img.path), height: 100,
                  width: 100,),
              ):
              const Icon(Icons.image,size: 80,)
          )
      ),
    );
  }

  Future addBrandApi() async {
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

    var url=baseUrl+'api/'+add_brand;

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
      print('profile pic not selected');
    }

    request.fields["brand_name"] = _textEditingController.text;
    request.fields["brand_image_web"] = '';
    request.fields["main_category_auto_id"]= mainCategory;
    request.fields["admin_auto_id"] =admin_auto_id;
    request.fields["app_type_id"] =app_type_id;

    http.Response response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      setState(() {
        isApiCallProcessing=false;
      });
      final resp=jsonDecode(response.body);
      String status=resp['status'];
      if(status=='1'){
        Fluttertoast.showToast(msg: "Brand added successfully", backgroundColor: Colors.grey,);
        widget.onSaveCallback();
        //Navigator.pop(context);
      }
      else{
        String message=resp['msg'];
        Fluttertoast.showToast(msg: message, backgroundColor: Colors.grey,);
      }
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