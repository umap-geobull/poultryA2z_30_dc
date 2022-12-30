import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../MainCategories/main_category_model.dart';

typedef OnSaveCallback = void Function();

class EditSlider extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String component_id;

  EditSlider(this.onSaveCallback,this.component_id);

  @override
  _EditSlider createState() => _EditSlider(component_id);
}

class _EditSlider extends State<EditSlider> {
  String component_id;

  _EditSlider(this.component_id);

  double slider_height=200;
  Color pickerColor = const Color(0xff443a49),selectedColor=Colors.white;

  late XFile pickedImageFile;

  bool isIconSelected=false;
  final ImagePicker _picker = ImagePicker();

  bool isApiCallProcessing=false,isEditApiProcessing=false;

  bool isImageSelected=false;
  late File selectedImage;

  int selectedSlider=-1;

  List<String> selectedMainCategory=[];
  List<GetmainCategorylist> mainCategoryList=[];
  bool showOnHome=false;

  List<Content> sliderList=[];

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
      getSliderDetails();
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
        child:
        StatefulBuilder(builder: (context, setState) {
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
                                  child:
                                  isEditApiProcessing==true?
                                  const SizedBox(
                                    width: 80,
                                    child: GFLoader(
                                        type:GFLoaderType.circle
                                    ),
                                  ):
                                  TextButton(
                                    onPressed: ()=>{
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
                                    backgroundColor: Colors.orangeAccent,
                                  ),
                                  child: const Text('+ Add Image'),
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
                                    backgroundColor: Colors.orangeAccent,
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
                                const Text('  Slider Height',style: TextStyle(color: Colors.black87, fontSize: 16),),
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
    //Navigator.pop(context);
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
        ImageSlideshow(

          /// Width of the [ImageSlideshow].
          width: MediaQuery.of(context).size.width,

          /// Height of the [ImageSlideshow].
          height: slider_height,

          /// The page to show when first creating the [ImageSlideshow].
          initialPage: selectedSlider!=-1?
          selectedSlider:
          0,

          /// The color to paint the indicator.
          indicatorColor: Colors.blue,

          /// The color to paint behind th indicator.
          indicatorBackgroundColor: Colors.grey,

          /// The widgets to display in the [ImageSlideshow].
          /// Add the sample image file into the images folder
          children: sliderItems(),

          /// Called whenever the page in the center of the viewport changes.
          onPageChanged: (value) {
          },

          /// Auto scroll interval.
          /// Do not auto scroll with null or 0.
          autoPlayInterval: null,

          /// Loops back to first slide.
          isLoop: true,
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
            child: const Text('+ Add Images',style: TextStyle(fontSize: 16,color: Colors.black54),),
          ),
        ),

    );
  }

  List<Widget> sliderItems(){
    List<Widget> items=[];

    for(int i=0;i<sliderList.length;i++){
      items.add(
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: slider_height,
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: ()=>{
                    selectedSlider=i,
                    getGalleryImage()
                  },
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: slider_height,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: sliderList[i].componentImage!=''?
                        CachedNetworkImage(
                          fit: BoxFit.fill,
                          height: slider_height,
                          width: MediaQuery.of(context).size.width,
                          imageUrl: baseUrl+home_slider_base_url+sliderList[i].componentImage,
                          placeholder: (context, url) =>
                              Container(decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey[400],
                              )),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ):
                        Container(
                            child:const Icon(Icons.error),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey[400],
                            )),
                      )

                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child:Container(
                    height: 25,
                    width: 25,
                    margin: const EdgeInsets.all(2),
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: GestureDetector(
                      child: const Icon(Icons.delete_forever_sharp,color: Colors.black,),
                      onTap: ()=>{
                        showAlert(sliderList[i].id)
                      },
                    ),
                  ),
                )
              ],
            ),
          )
      );
    }

    return items;
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
    ));

    if(croppedFile!=null){
      setState(() {
        selectedImage=File(croppedFile.path);
        //selectedImage=croppedFile;
        isIconSelected=true;

        print(selectedImage.path);
        addSliderImageApi();
      });
    }
  }

  showAlert(String id) async {
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
                    const Text('Do you want to delete this slider image',style: TextStyle(color: Colors.black54),),
                    const SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            child:
                            ElevatedButton(
                              onPressed: (){
                                deleteSliderImageApi(id);
                                Navigator.pop(context);
                              },
                              child: const Text("Yes",style: TextStyle(color: Colors.black54,fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
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
                                backgroundColor: Colors.blue,
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

  Future addSliderImageApi() async {
    setState(() {
      isApiCallProcessing=true;
    });

    var url=baseUrl+'api/'+add_home_slider_image;

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

      print(resp.toString());

      String status=resp['status'];

      if(status=='1'){
        print('image uploaded');
        getSliderDetails();
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

    var url=baseUrl+'api/'+edit_home_slider_image;

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
    request.fields["image_auto_id"] = sliderList[selectedSlider].id ;
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
        getSliderDetails();
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

  Future getSliderDetails() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "component_auto_id":component_id,
      "component_type":SLIDER,
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

  Future deleteSliderImageApi(String id) async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "image_auto_id":id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    var url=baseUrl+'api/'+delete_home_slider_image;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        getSliderDetails();
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

    if(mounted){
      setState(() {
        isEditApiProcessing=true;
      });
    }

    final body = {
      'homecomponent_auto_id':component_id,
      "component_type":SLIDER,
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
      isEditApiProcessing=false;

      final resp=jsonDecode(response.body);
      String status=resp['status'];
      if(status=="1"){
        widget.onSaveCallback();
      }
      else{
        Fluttertoast.showToast(msg: "Something went wrong. Please try later", backgroundColor: Colors.grey,);
      }

      if(mounted){
        setState(() {
        });
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

