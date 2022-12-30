import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Home/Components/MainCategories/main_category_model.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Home/Components/AddNewComponent/models/sub_category_model.dart';
import '../../Utils/App_Apis.dart';

class AddSizeChart extends StatefulWidget {
  @override
  State<AddSizeChart> createState() => AddSizeChartState();
}

class AddSizeChartState extends State<AddSizeChart> {
  double slider_height = 200;
  Color pickerColor = const Color(0xff443a49), selectedColor = Colors.white;
  late bool isVisible;

  late File icon_img;

  late XFile pickedImageFile;

  bool isIconSelected = false;

  final ImagePicker _picker = ImagePicker();

  bool isaddApiCallProcessing = false,
      isApiCallProcessing = false,
      isSubcategoryapiprocessing = false;

  int img_width = 0, img_height = 0;

  String baseUrl='', admin_auto_id='',app_type_id='';
  String user_id='';

  List<GetmainCategorylist> mainCategoryList=[];

  List<String> selectedMainCategory=[];
  List<String> selectedSubcategories=[];

  bool showOnHome = false;

  @override
  void initState() {
    super.initState();
    getBaseUrl();
  }

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');
    String? userId = prefs.getString('user_id');
    String? apptypeid= prefs.getString('app_type_id');
    if (baseUrl!=null && adminId!=null && userId!=null && apptypeid!=null) {
      setState(() {
        this.user_id = userId;
        this.baseUrl=baseUrl;
        this.admin_auto_id=adminId;
        this.app_type_id=apptypeid;
        getMainCategories();
      });
    }
    return null;
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
      else{
        mainCategoryList=[];
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

 /* void getSubcategories(String maincategoryautoid) async {
    isSubcategoryapiprocessing = true;
    var url = baseUrl + 'api/' + 'get_sub_category_list';
    var uri = Uri.parse(url);
    final body = {
      "main_category_auto_id": maincategoryautoid,
      "admin_auto_id":admin_auto_id,
    };
    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isSubcategoryapiprocessing = false;

      final resp = jsonDecode(response.body);
      int status = resp['status'];
      if (status == 1) {
        SubCategoryModel subCategoryModel =
            SubCategoryModel.fromJson(json.decode(response.body));
        subCategoryList = subCategoryModel.getmainSubcategorylist;
        SubList.add(subCategoryList);

        if (mounted) {
          setState(() {
            SubList;
          });
        }
      } else {
        subCategoryList = [];
      }
    }
  }*/

  bool isAdded(String id) {
    for (int i = 0; i < selectedMainCategory.length; i++) {
      if (selectedMainCategory[i] == id) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Add Size Chart",
            style: TextStyle(color: appBarIconColor, fontSize: 16)),
        leading: IconButton(
          onPressed: ()=>{Navigator.of(context).pop()},
          icon: const Icon(Icons.arrow_back, color: appBarIconColor),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  Container(
                      margin: const EdgeInsets.all(0),
                      child: const Text(
                        'Upload Size Chart Image',
                        style: TextStyle(
                            color: Colors.black87, fontSize: 14),
                      )),
                  uploadLogoUi(),
                ],
              ),
              Container(
                  margin:
                  const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Select Categories/Subcategories',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )
                  )
              ),

             // Text('Select Categories/Subcategories',style: TextStyle(fontSize: 14,color: Colors.black),),
              SizedBox(height: 10,),
              Expanded(
                  child: ListView.builder(
                      //physics: const NeverScrollableScrollPhysics(),
                      cacheExtent: 5000,
                      itemCount: mainCategoryList.length,
                      itemBuilder: (context, index) =>
                          _MainCategory(onChangeSelection,mainCategoryList[index],
                              selectedSubcategories,selectedMainCategory,baseUrl,admin_auto_id,app_type_id)
                  )
              ),

              /* isApiCallProcessing ?
              const GFLoader(type: GFLoaderType.circle) :
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    isApiCallProcessing == false
                        ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: showMainCategoriesUi(),
                    )
                        : const Center(
                      child: Text('No categories'),
                    )
                  ]),*/
            /*  SubList.isNotEmpty ?
              Container(
                  height: MediaQuery.of(context).size.height /3,
                  margin: const EdgeInsets.only(top: 10),
                  // color: Colors.white,
                  child:
                  isSubcategoryapiprocessing
                      ? const GFLoader(type: GFLoaderType.circle)
                      :ListView.builder(
                      itemCount: SubList.length,
                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder:
                          (BuildContext context, int index) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height/2,
                          child: getSubcategoriesUi(SubList[index],selectedMainCategoryName[index]),
                        );
                      })
              ) :
              Container(),*/
              Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orangeAccent,
                    ),
                    child: const Text('Submit'),
                    onPressed: () {
                      if (checkValid() == true) {
                        addSizeApi();
                      }
                    },
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

  bool checkValid() {
    if (isIconSelected== false) {
      Fluttertoast.showToast(
        msg: "Please select image",
        backgroundColor: Colors.grey,
      );
      return false;
    }
    if (selectedSubcategories.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please select subcategory",
        backgroundColor: Colors.grey,
      );
      return false;
    }
    return true;
  }

 /* showMainCategoriesUi() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: GridView.builder(
              itemCount: mainCategoryList.length,
              // physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1 / 0.4,
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            child: Checkbox(
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() {
                                    if (isAdded(mainCategoryList[index].id) == true) {
                                      selectedMainCategory
                                          .remove(mainCategoryList[index].id);
                                      selectedMainCategory;
                                      SubList.clear();
                                      selectedMainCategoryName.clear();
                                      selectedSubCategory.clear();
                                      if (selectedMainCategory.isNotEmpty) {
                                        for (int i = 0; i < selectedMainCategory.length; i++)
                                        {
                                          for(int j=0;j<mainCategoryList.length;j++)
                                            {
                                              if(selectedMainCategory[i]==mainCategoryList[j].id)
                                              {
                                                selectedMainCategoryName.add(mainCategoryList[j].categoryName);
                                                break;
                                              }
                                            }
                                          getSubcategories(selectedMainCategory[i]);
                                        }
                                      }
                                    } else {
                                      selectedMainCategory
                                          .add(mainCategoryList[index].id);
                                      selectedMainCategoryName.add(mainCategoryList[index].categoryName);
                                      getSubcategories(
                                          mainCategoryList[index].id);
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
                              mainCategoryList[index].categoryName,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ]),
                  )),
        )
      ],
    );
  }

  getSubcategoriesUi(List<GetmainSubcategorylist> subCategoryList, String selectedMainCategoryName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            margin: const EdgeInsets.all(8),
            child:Text(selectedMainCategoryName,style: const TextStyle(
                color: Colors.black45,
                fontSize: 14,
                fontWeight: FontWeight.bold))),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 350,
          child: GridView.builder(
              itemCount: subCategoryList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1 / 0.4,
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            child: Checkbox(
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() {
                                    if (isAddedsub(subCategoryList[index].id) ==
                                        true) {
                                      selectedSubCategory
                                          .remove(subCategoryList[index].id);
                                    } else {
                                      selectedSubCategory
                                          .add(subCategoryList[index].id);
                                      sub_category_auto_id =
                                          subCategoryList[index].id;
                                    }
                                  });
                                }
                              },
                              value: isAddedsub(subCategoryList[index].id),
                            ),
                            margin: const EdgeInsets.all(5),
                          ),
                          Flexible(
                            child: Text(
                              subCategoryList[index].subCategoryName,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ]),
                  )),
        )
      ],
    );
  }
*/

  Widget uploadLogoUi() {
    return GestureDetector(
      onTap: () => {showImageDialog()},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          isIconSelected == true
              ? GestureDetector(
                  onTap: () => {cropImage(icon_img)},
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const <Widget>[
                        Text(
                          'Edit Image',
                          style: TextStyle(color: Colors.blue),
                        ),
                        Icon(
                          Icons.crop_free,
                          color: Colors.blue,
                        )
                      ],
                    ),
                  ),
                )
              : Container(),
          Container(
              height: 200,
              width: 200,
              alignment: Alignment.center,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey
                ),
              ),
              child: Container(
                  child: isIconSelected
                      ? ClipRRect(
                          child: Image.file(
                            File(icon_img.path),
                            height: 200,
                            width: 200,
                          ),
                        )
                      : const Icon(
                    Icons.image,
                    size: 80,
                  )))
        ],
      ),
    );
  }

  Future addSizeApi() async {
    String mainCategories='',subCategories='';

  /*  for(int i=0;i<selectedMainCategory.length;i++){
      if(i==0){
        mainCategories+=selectedMainCategory[i];
      }
      else{
        mainCategories+='|'+selectedMainCategory[i];
      }
    }*/

    for(int i=0;i<selectedSubcategories.length;i++){
      if(i==0){
        subCategories+=selectedSubcategories[i];
      }
      else{
        subCategories+='|'+selectedSubcategories[i];
      }
    }

    setState(() {
      isaddApiCallProcessing = true;
    });

    var url = baseUrl + 'api/' + add_size_chart;

    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);

    try {
      if (icon_img != null) {
        request.files.add(
          http.MultipartFile(
            'chart_image',
            icon_img.readAsBytes().asStream(),
            await icon_img.length(),
            filename: icon_img.path.split('/').last,
          ),
        );
      } else {
        request.fields["chart_image"] = '';
      }
    } catch (exception) {
      print('profile pic not selected');
      request.fields["chart_image"] = '';
    }
    request.fields["subcategory_auto_id"] = subCategories;
    request.fields["added_by"] = 'Admin';
    request.fields["user_auto_id"] = user_id;
    request.fields["admin_auto_id"] = admin_auto_id;
    request.fields["app_type_id"] =app_type_id;

    http.Response response =
        await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      setState(() {
        isaddApiCallProcessing = false;
      });
      final resp = jsonDecode(response.body);
      //String message=resp['msg'];
      int status = resp['status'];
      if (status == 1) {
        Fluttertoast.showToast(
          msg: "Sizechart added successfully",
          backgroundColor: Colors.grey,
        );
        // widget.onSaveCallback();
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: "Something went wrong.Please try later",
          backgroundColor: Colors.grey,
        );
      }
    }
  }

  showImageDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: const Text(
            'Upload image from',
            style: TextStyle(color: Colors.black87),
          ),
          content: SizedBox(
            height: 110,
            child: Column(
              children: <Widget>[
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      getCameraImage();
                    },
                    child: const Text("Camera",
                        style: TextStyle(color: Colors.black54, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.blue,
                      minimumSize: const Size(150, 30),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      getGalleryImage();
                    },
                    child: const Text("Gallery",
                        style: TextStyle(color: Colors.black54, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.blue,
                      minimumSize: const Size(150, 30),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future getCameraImage() async {
    Navigator.of(context).pop(false);
    var pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      pickedImageFile = pickedFile;

      File selectedImg = File(pickedImageFile.path);

      icon_img = selectedImg;
      isIconSelected = true;

      getFileSize();

      /*if(selectedImg!=null){
        cropImage(selectedImg);
      }*/
    }
  }

  Future getGalleryImage() async {
    Navigator.of(context).pop(false);
    var pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      pickedImageFile = pickedFile;

      File selectedImg = File(pickedImageFile.path);

      icon_img = selectedImg;
      isIconSelected = true;
      print(icon_img);

      getFileSize();
      /* if(selectedImg!=null){
        cropImage(selectedImg);
      }*/
    }
  }

  cropImage(File icon) async {
    File? croppedFile = (await ImageCropper().cropImage(
        sourcePath: icon.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
       /* androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        )*/
    )) as File?;

    if (croppedFile != null) {
      icon_img = croppedFile;
      isIconSelected = true;

      getFileSize();
    }
  }

  getFileSize() async {
    var decodedImage = await decodeImageFromList(icon_img.readAsBytesSync());
    img_height = decodedImage.height;
    img_width = decodedImage.width;

    if (mounted) {
      setState(() {});
    }
  }


  //categories
  selectCategoriesUi(){
    if(mainCategoryList.isNotEmpty){
      return Expanded(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Select Categories/Subcategories',style: TextStyle(fontSize: 14,color: Colors.black),),
              SizedBox(height: 10,),
              SizedBox(
                  height: 4000,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      cacheExtent: 5000,
                      itemCount: mainCategoryList.length,
                      itemBuilder: (context, index) =>
                          _MainCategory(onChangeSelection,mainCategoryList[index],
                              selectedSubcategories,selectedMainCategory,baseUrl,admin_auto_id,app_type_id)
                  )
              )
            ],
          ));
    }
    else{
      return Container();
    }
  }

  onChangeSelection(List<String> selectedSubcategories, List<String> selectedMaincategories){
    this.selectedSubcategories=selectedSubcategories;
    selectedMainCategory=selectedMaincategories;
    if(mounted){
      setState(() {});
    }
  }

}

typedef OnchangeSelection =Function(List<String> selectedSubcategories, List<String> selectedMainCategory);

class _MainCategory extends StatefulWidget {
  OnchangeSelection onchangeSelection;
  final GetmainCategorylist mainCategoryList;
  List<String> selectedSubcategories;
  List<String> selectedMainCategory;
  String baseUrl;
  String admin_auto_id;
  String app_type_id;

  _MainCategory(this.onchangeSelection,this.mainCategoryList,this.selectedSubcategories,this.selectedMainCategory,
      this.baseUrl,this.admin_auto_id,this.app_type_id);

  @override
  _MainCategoryState createState() => _MainCategoryState(mainCategoryList,selectedSubcategories,selectedMainCategory,
      baseUrl,admin_auto_id,app_type_id);
}

class _MainCategoryState extends State<_MainCategory> {
  bool isApiCallProcessing=false;
  List<String> selectedSubcategories;
  List<String> selectedMainCategory;
  String baseUrl;
  String admin_auto_id;
  String app_type_id;


  _MainCategoryState(this.mainCategory,this.selectedSubcategories,this.selectedMainCategory,this.baseUrl,this.admin_auto_id,this.app_type_id);

  List<GetmainSubcategorylist> subCategoryList=[];

  final GetmainCategorylist mainCategory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    getSubCategories();
  }

  subCategoryItems(){
    List<Widget> items=[];

    for(int index=0;index<subCategoryList.length;index++){
      items.add(
          GestureDetector(
              onTap: ()=>{
                if(isAdded(subCategoryList[index].id) ==true){
                  selectedSubcategories.remove(subCategoryList[index].id)
                }
                else{
                  selectedSubcategories.add(subCategoryList[index].id)
                },

                widget.onchangeSelection(selectedSubcategories,selectedMainCategory)
                //showEditCategory(subCategoryList[index])
              },
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                //  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: isAdded(subCategoryList[index].id)==true ? Colors.blue  : Colors.grey,
                              width: 1
                          )
                      ),
                      margin: const EdgeInsets.only(bottom: 5),
                      child:Stack(
                        children: <Widget>[
                          Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width*1.5,
                              height: 40,
                              child:
                              Text(
                                subCategoryList[index].subCategoryName,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11),
                              )
                          ),

                          Container(
                            alignment: Alignment.topRight,
                            child:
                            isAdded(subCategoryList[index].id)==true?
                            Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.orange[300]
                                ),
                                child:const Icon(Icons.check,color: Colors.white,size: 13,)
                            ):
                            Container(),
                          )
                        ],
                      )),
                ],
              )
          )
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10,left: 5,right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                mainCategory.categoryName,style: const TextStyle(color: Colors.black87,fontSize: 16),
              ),

              const SizedBox(width: 10,),
              Container(
                  child: GestureDetector(
                    onTap: ()=>{
                      if(isAddedMainCategory(mainCategory.id) ==true){
                        selectedMainCategory.remove(mainCategory.id)
                      }
                      else{
                        selectedMainCategory.add(mainCategory.id)
                      },

                      widget.onchangeSelection(selectedSubcategories,selectedMainCategory)

                    },
                    child: isAddedMainCategory(mainCategory.id)?
                    const Icon(Icons.check_box,color: Colors.green,size: 18,):
                    const Icon(Icons.check_box_outlined,color: Colors.grey,size: 18,),
                  )
              )
            ],
          ),
          const SizedBox(height: 7,),

          SizedBox(
              height: 100,
              child:
              subCategoryList.isNotEmpty?
              SizedBox(
                // alignment: Alignment.topCenter,
                  height: MediaQuery.of(context).size.height,
                  child:
                  GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      childAspectRatio: 1/2,
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      // crossAxisSpacing: 1,
                      // mainAxisSpacing: 1,
                      children:subCategoryItems() )
              ):
              Container(
                alignment: Alignment.center,
                child: const Text('No data available'),
              )
          )
        ],
      ),
    );
  }

  void getSubCategories() async {
    final body = {
      "main_category_auto_id": mainCategory.id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    var url=baseUrl+'api/'+get_sub_category_list;
    var uri = Uri.parse(url);
    final response = await http.post(uri,body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        SubCategoryModel subCategoryModel=SubCategoryModel.fromJson(json.decode(response.body));
        subCategoryList=subCategoryModel.getmainSubcategorylist;

        print(subCategoryList.toString());
        if(mounted){
          setState(() {});
        }
      }
    }
  }

  bool isAdded(String id){
    if(isAddedMainCategory(mainCategory.id)){
      return true;
    }
    else{
      for(int i=0;i<widget.selectedSubcategories.length;i++){
        if(widget.selectedSubcategories[i]==id){
          return true;
        }
      }
    }
    return false;
  }

  bool isAddedMainCategory(String id){
    for(int i=0;i<widget.selectedMainCategory.length;i++){
      if(widget.selectedMainCategory[i]==id){
        return true;
      }
    }
    return false;
  }

}