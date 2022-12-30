import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/App_Apis.dart';
import '../../Utils/constants.dart';
import 'Component/SizeChartModel.dart';

class EditSizeChart extends StatefulWidget {
  late GetSizeChartdata _getSizeChartdata;
  EditSizeChart(GetSizeChartdata sizechart)
  {
    _getSizeChartdata=sizechart;
}

@override
State<EditSizeChart> createState() => EditSizeChartState(_getSizeChartdata);}

class EditSizeChartState extends State<EditSizeChart> {
  late File icon_img;

  late XFile pickedImageFile;

  bool isIconSelected = false;

  final ImagePicker _picker = ImagePicker();

  bool isApiCallProcessing = false,isupdateSizechartApiProcessing=false;

  int img_width = 0,
      img_height = 0;

  String baseUrl = '';

  late GetSizeChartdata getSizeChartdata;

  var selectedIndexes = [],
      selectedSubcategories = [];

  late String main_category_auto_id,
  sizechart_auto_id,
      added_by = 'Admin',
      sub_category_auto_id,
      user_id = '',app_type_id='',admin_auto_id='';

  EditSizeChartState(GetSizeChartdata getSizeChartdata)
  {
    this.getSizeChartdata=getSizeChartdata;
    sizechart_auto_id=getSizeChartdata.id;
    sub_category_auto_id=getSizeChartdata.subcategoryAutoId;
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
  }
  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? apptypeid= prefs.getString('app_type_id');
    String? adminId = prefs.getString('admin_auto_id');
    if (userId != null && baseUrl!=null && apptypeid!=null && adminId!=null) {
      setState(() {
        user_id = userId;
        this.baseUrl=baseUrl;
        this.admin_auto_id=adminId;
        this.app_type_id=apptypeid;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            title: const Text("Update Size Chart",
                style: TextStyle(color: appBarIconColor, fontSize: 16)),
            leading: IconButton(
              onPressed: ()=>{Navigator.of(context).pop()},
              icon: const Icon(Icons.arrow_back, color: appBarIconColor),
            ),
          ),
          body: SingleChildScrollView(
            // controller: ModalScrollController.of(context),

              child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: AnimatedPadding(
                    padding: MediaQuery
                        .of(context)
                        .viewInsets,
                    duration: const Duration(milliseconds: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 50,
                          color: appBarColor,
                          padding: const EdgeInsets.only(left: 10, right: 5),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const <Widget>[
                              // Expanded(
                              //   flex: 3,
                              //   child: Text(
                              //     'Add Size Chart',
                              //     style:
                              //     TextStyle(
                              //         color: Colors.black87, fontSize: 20),
                              //   ),
                              // ),
                            ],
                          ),),
                        Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.all(10),
                                        child: const Text(
                                          'Size Chart Image',
                                          style:
                                          TextStyle(color: Colors.black87,
                                              fontSize: 16),
                                        )
                                    ),
                                    SizedBox(width:350, height:350,
                                    child: GestureDetector(
                                        onTap: ()=>{
                                          showImageDialog(),
                                          uploadLogoUi()
                                        },
                                        child: getSizeChartdata.chartImage.isNotEmpty && isIconSelected==false
                                            ? CachedNetworkImage(
                                          fit: BoxFit.contain,
                                          imageUrl: baseUrl+ sizechart_image_base_url + getSizeChartdata.chartImage,
                                          placeholder: (context, url) => Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[400],
                                              )),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        )
                                            : Container(
                                            child: uploadLogoUi(),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                            ))),),
                                  ],
                                ), flex: 1,),
                            ]),
                    isupdateSizechartApiProcessing==false?Container(
                          alignment: Alignment.bottomCenter,
                          margin: const EdgeInsets.only(top: 10),
                          child: SizedBox(
                            width: 150,
                            child:
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                              ),
                              child: const Text('Update'),
                              onPressed: () {
                                if (checkValid() == true) {
                                  updateSizeApi();
                                }
                              },
                            ),
                          ),
                        ): Container(child: GFLoader(type:GFLoaderType.circle),),
                      ],),)
              )
          ));

  }

  bool checkValid() {
    if (icon_img == null) {
      Fluttertoast.showToast(
        msg: "Please select image",
        backgroundColor: Colors.grey,
      );
      return false;
    }
    if (sub_category_auto_id == null) {
      Fluttertoast.showToast(
        msg: "Please select subcategory",
        backgroundColor: Colors.grey,
      );
      return false;
    }
    return true;
  }

  Widget uploadLogoUi() {
    return GestureDetector(
      onTap: () => {showImageDialog()},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          isIconSelected == true ?
          GestureDetector(
            onTap: () =>
            {
              cropImage(icon_img)
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const <Widget>[
                  Text('Edit Image', style: TextStyle(color: Colors.blue),),
                  Icon(Icons.crop_free, color: Colors.blue,)
                ],
              ),
            ),
          ) :
          Container(),
          Container(
              height: 300,
              width: 350,
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              child: Container(
                  child: isIconSelected ?
                  ClipRRect(
                    child: Image.file(File(icon_img.path),
                      height: 300,
                      width: 350,),
                  ) :
                  const Icon(Icons.image, size: 350,)
              )
          )
        ],
      ),
    );
  }

  Future updateSizeApi() async {
    if(this.mounted) {
      setState(() {
        isupdateSizechartApiProcessing = true;
      });
    }

    var url = baseUrl + 'api/' + edit_size_chart;

    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);

    try {
      request.files.add(
        http.MultipartFile(
          'chart_image',
          icon_img.readAsBytes().asStream(),
          await icon_img.length(),
          filename: icon_img.path
              .split('/')
              .last,),);
    }
    catch (exception) {
      print('profile pic not selected');
      request.fields["chart_image"] = '';
    }

    request.fields["chart_auto_id"] = sizechart_auto_id;
    request.fields["subcategory_auto_id"] = sub_category_auto_id;
    request.fields["added_by"] = added_by;
    request.fields["user_auto_id"] = user_id;
    request.fields["app_type_id"] =app_type_id;
    request.fields["admin_auto_id"] = admin_auto_id;

    http.Response response = await http.Response.fromStream(
        await request.send());

    if (response.statusCode == 200) {
      if(this.mounted) {
        setState(() {
          isupdateSizechartApiProcessing = false;
        });
      }
      final resp = jsonDecode(response.body);
      //String message=resp['msg'];
      String status = resp['status'];
      if (status == '1') {
        Fluttertoast.showToast(
          msg: "Sizechart updated successfully", backgroundColor: Colors.grey,);
        // widget.onSaveCallback();
        Navigator.pop(context);
      }
      else {
        Fluttertoast.showToast(msg: "Something went wrong.Please try later",
          backgroundColor: Colors.grey,);
      }
    }
  }

  showImageDialog() async {
    return showDialog(
      context: context,
      builder: (context) =>
      AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: const Text(
            'Upload image from', style: TextStyle(color: Colors.black87),),
          content: SizedBox(
            height: 110,
            child: Column(
              children: <Widget>[
                Container(
                  child:
                  ElevatedButton(
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
                const SizedBox(height: 10,),
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
          )
      ),
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
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    Key? key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(child: Text(label)),
            Checkbox(
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue!);
              },
            ),
          ],
        ),
      ),
    );
  }
}