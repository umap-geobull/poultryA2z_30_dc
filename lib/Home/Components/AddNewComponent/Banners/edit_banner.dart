import 'dart:convert';
// import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/show_color_picker.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/home_slider_details.dart';
import 'package:poultry_a2z/Home/Components/component_constants.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../../../Utils/App_Apis.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../MainCategories/main_category_model.dart';
import 'package:fluttertoast/fluttertoast.dart';


typedef OnSaveCallback = void Function();

class EditBanner extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String component_id;

  EditBanner(this.onSaveCallback,this.component_id);

  @override
  _EditBanner createState() => _EditBanner(component_id);
}

class _EditBanner extends State<EditBanner> {
  String component_id;

  _EditBanner(this.component_id);

  double slider_height=200;
  Color pickerColor = const Color(0xff443a49),selectedColor=Colors.white;

  late XFile pickedImageFile;

  bool isIconSelected=false;
  final ImagePicker _picker = ImagePicker();

  bool isApiCallProcessing=false;

  bool isImageSelected=false;
  late File selectedImage;

  List<Content> sliderList=[];

  List<String> selectedMainCategory=[];
  List<GetmainCategorylist> mainCategoryList=[];
  bool showOnHome=false;

  String baseUrl='',admin_auto_id='',userId='',app_type_id='';

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');
    String? userId = prefs.getString('user_id');
    String? apptypeid= prefs.getString('app_type_id');

    if(baseUrl!=null && adminId!=null && userId!=null && apptypeid!=null){
      this.baseUrl=baseUrl;
      this.admin_auto_id=adminId;
      this.userId=userId;
      this.app_type_id=apptypeid;

      setState(() {});
      getBannerDetails();
      getMainCategories();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
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
        const Text('  Show In',style: TextStyle(color: Colors.black87,fontSize: 18,fontWeight: FontWeight.bold),),
        Container(
          margin: const EdgeInsets.only(top: 10),
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
                          showOnHome=value!;
                        });
                      }
                    },
                    value: showOnHome,
                  ),
                  margin: const EdgeInsets.all(5),
                ),
                const Flexible(
                  child: Text(
                    'Home Screen',
                    style: TextStyle(fontSize: 15, color: Colors.black, ),
                  ),
                )
              ]
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 250,
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
    else if (response.statusCode == 500) {
      isApiCallProcessing=false;
      Fluttertoast.showToast(msg: "Server error in getting main categories", backgroundColor: Colors.grey,);
      if(this.mounted){
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: StatefulBuilder(builder: (context, setState) {
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
                            onPressed: ()=>{
                             onBackPressed()
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ),
                        const Text(
                          '',style: TextStyle(color: Colors.black87,fontSize: 14),
                        ),
                        Expanded(
                            flex:1,
                            child:Container(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: ()=>{
                                  print(selectedMainCategory[0].toString()),
                                  print(showOnHome.toString()+' '+selectedMainCategory.length.toString()),

                                  if(showOnHome==false && selectedMainCategory.length==1){
                                    Fluttertoast.showToast(msg: home_component_show_in_msg,
                                        backgroundColor: Colors.grey,toastLength:Toast.LENGTH_LONG)
                                  }
                                  else{
                                    ediHomeComponentApi()
                                  }
                                },
                                child: const Text('SAVE'),
                              ),
                            )
                        )

                      ],
                    ),
                    sliderUi(),
                    Row(
                      children: <Widget>[
                        sliderList.isNotEmpty?
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orangeAccent,
                              ),
                              child: const Text('Edit Image'),
                              onPressed: () {
                                getGalleryImage();
                              },
                            ),
                          ),
                        ):
                        Container(),

                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orangeAccent,
                              ),
                              child: const Text('Background Color'),
                              onPressed: () {
                                showColorChooser();
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.only(bottom: 30,top: 20),
                        child: Row(
                          children: <Widget>[
                            const Text('  Banner Height',style: TextStyle(color: Colors.black87, fontSize: 16),),
                            Expanded(
                                child: Container(
                                  child: Slider(
                                    value: slider_height,
                                    max: 400,
                                    divisions: 10,
                                    label: slider_height.round().toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        slider_height = value;
                                      });
                                    },
                                  ),
                                ))
                          ],
                        )
                    ),
                    showInUi()
                  ],
                )
            ),
          )
      );
    }
    ),
        onWillPop: ()=>onBackPressed()
    );

  }

  onBackPressed() async{
    widget.onSaveCallback();
  }

  sliderUi(){
    return Container(
      width: double.infinity,
      height: slider_height,
      padding: const EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 15),
      decoration: BoxDecoration(
        color:selectedColor
      ),
      margin: const EdgeInsets.only(bottom: 20),
      child:
        isApiCallProcessing?
        Container(
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5)
          ),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: slider_height,
        ):
        sliderList.isNotEmpty?
        SizedBox(
            width: MediaQuery.of(context).size.width,
            height: slider_height,
            child: ClipRRect(
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                height: slider_height,
                width: MediaQuery.of(context).size.width,
                imageUrl: baseUrl+home_slider_base_url+sliderList[0].componentImage,
                placeholder: (context, url) =>
                    Container(decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey[400],
                    )),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            )

        ):
        GestureDetector(
          onTap: ()=>{
            getGalleryImage()
          },
          child:
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5)
            ),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: slider_height,
            child: const Text('+ Add Image',style: TextStyle(fontSize: 16,color: Colors.black54),),
          ),
        ),
    );
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void updateColor(Color color){

    setState(() {
      selectedColor=color;
    });

    Navigator.pop(context);

  }

  showColorChooser() {
    showDialog(
        context: context,
        builder: (context){
          return ShowColorPicker(onSaveCallback: updateColor, pickerColor: selectedColor,);
        }
    );
  }

  Future getGalleryImage() async {
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
    )) ;

    if(croppedFile!=null){
      setState(() {
        selectedImage=File(croppedFile.path);
        isIconSelected=true;
        if(sliderList.isEmpty){
          addSliderImageApi();
        }
        else{
          editSliderImageApi();
        }
      });
    }
  }

  Future addSliderImageApi() async {
    setState(() {
      isApiCallProcessing=true;
    });

    var url=baseUrl+'api/'+add_banner_image;

    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);

    try{
      request.files.add(
        http.MultipartFile(
          'component_image',
          selectedImage.readAsBytes().asStream(),
          await selectedImage.length(),
          filename: selectedImage.path.split('/').last,),);
    }

    catch(exception){
      print('profile pic not selected');
    }

    request.fields["homecomponent_auto_id"] = component_id ;
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
        getBannerDetails();
      }
      else{

      }
    }
    else if (response.statusCode == 500) {
      isApiCallProcessing=false;
      Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
      if(this.mounted){
        setState(() {});
      }
    }
  }

  Future editSliderImageApi() async {

    setState(() {
      isApiCallProcessing=true;
    });

    var url=baseUrl+'api/'+edit_banner_image;

    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);

    try{
      request.files.add(
        http.MultipartFile(
          'component_image',
          selectedImage.readAsBytes().asStream(),
          await selectedImage.length(),
          filename: selectedImage.path.split('/').last,),);
    }

    catch(exception){
      print('profile pic not selected');
    }

    request.fields["homecomponent_auto_id"] = component_id ;
    request.fields["image_auto_id"] = sliderList[0].id ;
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
        getBannerDetails();
      }
      else{

      }
    }
    else if (response.statusCode == 500) {
      isApiCallProcessing=false;
      Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
      if(this.mounted){
        setState(() {});
      }
    }
  }

  Future getBannerDetails() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "component_auto_id":component_id,
      "component_type":BANNER,
      "admin_auto_id":admin_auto_id,
      "customer_auto_id":userId,
      "app_type_id": app_type_id,
    };

    var url=baseUrl+'api/'+get_home_component_details;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        HomeSliderDetails homeSliderDetails=HomeSliderDetails.fromJson(json.decode(response.body));

        sliderList=homeSliderDetails.getHomeComponentList[0].content;

        if(homeSliderDetails.getHomeComponentList[0].height.isNotEmpty){
          slider_height= double.tryParse(homeSliderDetails.getHomeComponentList[0].height)!;
        }
        if(homeSliderDetails.getHomeComponentList[0].backgroundColor.isNotEmpty){
          String  clr=homeSliderDetails.getHomeComponentList[0].backgroundColor;
          selectedColor= Color(int.parse(clr));
        }

        String showCategory=homeSliderDetails.getHomeComponentList[0].showInCategory;

        selectedMainCategory=showCategory.split('|');

        if(homeSliderDetails.getHomeComponentList[0].showOnHome=='true'){
          showOnHome=true;
        }
        else{
          showOnHome=false;
        }

        print(showOnHome.toString());

        if(mounted){
          setState(() {});
        }
      }
    }
    else if (response.statusCode == 500) {
      isApiCallProcessing=false;
      Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
      if(this.mounted){
        setState(() {});
      }
    }
  }

  Future ediHomeComponentApi() async {
    String mainCategory='';
    for(int i=0;i<selectedMainCategory.length;i++){
      if(i==0){
        mainCategory+=selectedMainCategory[i];
      }
      else{
        mainCategory += '|'+selectedMainCategory[i];
      }
    }

    print(mainCategory);

    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      'homecomponent_auto_id':component_id,
      "component_type":BANNER,
      "title":'',
      "background_color":selectedColor.value.toString(),
      "height":slider_height.toString(),
      "icon_type":'',
      "layout_type":'',
      "title_font":'',
      "title_color":'',
      "title_size":'',
      "label_font":'',
      "label_color":'',
      "web_background_color":'',
      "web_height":'',
      "web_icon_type":'',
      "web_layout_type":'',
      "web_title_color":'',
      "web_title_font":'',
      "show_in_category":mainCategory,
      "show_on_home":showOnHome.toString(),
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    var url=baseUrl+'api/'+edit_home_component;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      String status=resp['status'];
      if(status=="1"){
        widget.onSaveCallback();
      }
      else{
        if(mounted){
          setState(() {
            isApiCallProcessing=false;
          });
        }
      }
    }
    else if (response.statusCode == 500) {
      isApiCallProcessing=false;
      Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
      if(this.mounted){
        setState(() {});
      }
    }
  }

}

