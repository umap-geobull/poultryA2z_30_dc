import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/show_color_picker.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/home_main_category_details.dart';
import 'package:poultry_a2z/Home/Components/MainCategories/main_category_model.dart';
import 'package:poultry_a2z/Home/Components/component_constants.dart';
import 'package:poultry_a2z/Home/Components/title_alignment.dart';
import 'package:poultry_a2z/Home/Components/title_background.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../Utils/App_Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';


typedef OnSaveCallback = void Function();

class EditMainCategoryStyle extends StatefulWidget {

  OnSaveCallback onSaveCallback;
  String component_id;

  @override
  _EditMainCategoryStyle createState() => _EditMainCategoryStyle();

  EditMainCategoryStyle(this.onSaveCallback,this.component_id);
}

class _EditMainCategoryStyle extends State<EditMainCategoryStyle> {
  double fontSize=14,web_fontSize=15;
  List<Widget> iconTypeList=[];
  List<Widget> webIconTypeList=[];
  bool isEditApiProcessing=false,isApiCallProcessing=false,editHeaderVisible=false;
  late GetHomeComponentList homeComponentData;
  List<GetmainCategorylist> mainCategoryList=[];
  bool showOnHome=false;
  List<String> selectedMainCategory=[];

  int app_icon=0,web_icon=0;
  String appLabelFont = 'Lato',appHeaderFont='Lato',web_LabelFont = 'Lato',webHeaderFont='Lato',headerTitle='';
  double appFontSize=17,webFontSize=20;
  Color appLabelColor=const Color(0xff443a49),appHeaderColor=Colors.black87,webLabelColor=const Color(0xff443a49),
      webHeaderColor=Colors.black87,backgroundColor=Colors.white,
      title_backgroundColor=Colors.transparent;

  String title_alignment = '';

  TextStyle appHeaderStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:17,
      fontWeight: FontWeight.normal,
      color: Colors.black87);

  TextStyle webHeaderStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:17,
      fontWeight: FontWeight.normal,
      color: Colors.black87);

  TextStyle appLabelStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:12,
      fontWeight: FontWeight.normal,
      color: Colors.black87);

  TextStyle webLabelStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:12,
      fontWeight: FontWeight.normal,
      color: Colors.black87);

  final TextEditingController _HeaderTextController=TextEditingController();

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
      getDetails();
      getMainCategories();
    }
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

  bool isAdded(String id){
    for(int i=0;i<selectedMainCategory.length;i++){
      if(selectedMainCategory[i]==id){
        return true;
      }
    }
    return false;
  }

  setIcons(){
    iconTypeList.add(
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 10,
                width: 40,
                color: Colors.grey[300],
              )
            ],
          ),
        )
    );

    iconTypeList.add(
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300]
          ),
        )
    );

    iconTypeList.add(
        Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300]
                  ),
                ),
                Container(
                  height: 10,
                  width: 40,
                  color: Colors.grey[300],
                )
              ],
            )
        )
    );

    iconTypeList.add(
      Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.grey[300]
        ),
      ),
    );

    iconTypeList.add(
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.grey[300]
                ),
              ),
              Container(
                height: 10,
                width: 40,
                color: Colors.grey[300],
              )
            ],
          ),
        )
    );

    iconTypeList.add(
      Container(
        height: 40,
        width: 30,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.grey[300]
        ),
      ),
    );




    webIconTypeList.add(
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 10,
                width: 40,
                color: Colors.grey[300],
              )
            ],
          ),
        )
    );

    webIconTypeList.add(
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300]
          ),
        )
    );

    webIconTypeList.add(
        Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300]
                  ),
                ),
                Container(
                  height: 10,
                  width: 40,
                  color: Colors.grey[300],
                )
              ],
            )
        )
    );

    webIconTypeList.add(
      Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.grey[300]
        ),
      ),
    );

    webIconTypeList.add(
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.grey[300]
                ),
              ),
              Container(
                height: 10,
                width: 40,
                color: Colors.grey[300],
              )
            ],
          ),
        )
    );

    webIconTypeList.add(
      Container(
        height: 40,
        width: 30,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.grey[300]
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
    setIcons();
  }

  onBackPressed() async{
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: appBarIconColor,size: 20,),
          onPressed: onBackPressed,
        ),
        title:const Text('Edit main category component',style: TextStyle(color: appBarIconColor,fontFamily:'Lato',fontSize: 16),),
        actions: [
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
              child: Text('Save',style: TextStyle(color:appBarIconColor,fontFamily:'Lato',fontSize: 16),)
          )
        ],
      ),
      body: SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            child: Column(
              children: <Widget>[
                app_view(),
                Divider(
                  height: 10,
                  thickness: 1,
                  color: Colors.grey,
                ),
                SizedBox(height: 10,),
                web_view(),
                const Divider(
                  height: 10,
                  thickness: 1,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('  Background color',style: TextStyle(color: Colors.black87,fontSize: 18,fontWeight: FontWeight.bold),),

                    GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1,color: Colors.black)
                        ),
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(10),
                        child: Text('Select Background Color',style: TextStyle(color: Colors.black),),
                      ),
                      onTap: () {
                        showBackgroundColorChooser();
                      },
                    )

                  ],
                ),
                showInUi()
              ],
            )
        ),),
    );
  }

  void updateBackgroundColor(Color color){

    setState(() {
      backgroundColor=color;
    });

    Navigator.pop(context);

  }

  showBackgroundColorChooser() {
    showDialog(
        context: context,
        builder: (context){
          return ShowColorPicker(onSaveCallback: updateBackgroundColor, pickerColor: backgroundColor,);
        }
    );
  }

  Future getDetails() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "component_auto_id":widget.component_id,
      "component_type":MAIN_CATEGORY,
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
        HomeMainCategoryDetails homeMainCategoryDetails=HomeMainCategoryDetails.fromJson(json.decode(response.body));
        homeComponentData=homeMainCategoryDetails.getHomeComponentList[0];
        setStyleData(homeComponentData);
      }
    }
  }

  setStyleData(GetHomeComponentList homeComponent) {

    String showCategory=homeComponent.show_in_category!;

    selectedMainCategory=showCategory.split('|');

    if(homeComponent.show_on_home!=null&& homeComponent.show_on_home=='true'){
      showOnHome=true;
    }
    else{
      showOnHome=false;
    }

    if(homeComponent.title.isNotEmpty){
      _HeaderTextController.text=homeComponent.title;
    }
    if(homeComponent.iconType.isNotEmpty){
      app_icon=int.parse(homeComponent.iconType);
    }
    if(homeComponent.titleFont.isNotEmpty){
      appHeaderFont=homeComponent.titleFont;
    }
    if(homeComponent.titleColor.isNotEmpty){
      appHeaderColor=Color(int.parse(homeComponent.titleColor));
    }
    if(homeComponent.labelFont.isNotEmpty){
      appLabelFont=homeComponent.labelFont;
    }
    if(homeComponent.labelColor.isNotEmpty){
      appLabelColor=Color(int.parse(homeComponent.labelColor));
    }
    if(homeComponent.webIconType.isNotEmpty){
      web_icon=int.parse(homeComponent.webIconType);
    }
    if(homeComponent.webTitleFont.isNotEmpty){
      webHeaderFont=homeComponent.webTitleFont;
    }
    if(homeComponent.webTitleColor.isNotEmpty){
      webHeaderColor=Color(int.parse(homeComponent.webTitleColor));
    }
    if(homeComponent.title.isNotEmpty){
      headerTitle=homeComponent.title;
    }
    if(homeComponent.backgroundColor.isNotEmpty){
      backgroundColor=Color(int.parse(homeComponent.backgroundColor));
    }
    if(homeComponent.titleBackground.isNotEmpty){
      title_backgroundColor=Color(int.parse(homeComponent.titleBackground));
    }
    if(homeComponent.titleAlignment.isNotEmpty){
      title_alignment=homeComponent.titleAlignment;
    }

    if(mounted){
      setState(() {});
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
      'homecomponent_auto_id':widget.component_id,
      "component_type":MAIN_CATEGORY,
      "title":_HeaderTextController.text,
      "background_color":backgroundColor.value.toString(),
      "height":'',
      "icon_type":app_icon.toString(),
      "layout_type":'0',
      "title_font":appHeaderFont,
      "title_color":appHeaderColor.value.toString(),
      "title_size":appFontSize.toString(),
      "label_font":appLabelFont,
      "label_color":appLabelColor.value.toString(),
      "web_background_color":'',
      "web_height":'',
      "web_icon_type":web_icon.toString(),
      "web_layout_type":'0',
      "web_title_color":webHeaderColor.value.toString(),
      "web_title_font":webHeaderFont,
      "show_in_category":mainCategory,
      "show_on_home":showOnHome.toString(),
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
      "title_background": title_backgroundColor.value.toString(),
      "title_alignment": title_alignment,
    };

    var url=baseUrl+'api/'+edit_home_component;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      isEditApiProcessing=false;

      final resp=jsonDecode(response.body);
      String status=resp['status'];
      if(status=="1"){
        if(mounted){
          widget.onSaveCallback();
        }
      }
      else{

      }

      if(mounted){
        setState(() {});
      }
    }
  }

  //app ui
  app_view(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(' App View',style: TextStyle(color: Colors.black87,fontSize: 18,fontWeight: FontWeight.bold),),
        const SizedBox(height: 10,),
        selectHeaderFont(),
        const SizedBox(height: 10,),
        selectIconType(),
        app_icon==0 || app_icon==2 || app_icon==4?
        selectLabelFont():
        Container()
      ],
    );
  }

  selectHeaderFont() {
    appHeaderStyle= GoogleFonts.getFont(appHeaderFont).copyWith(
        fontSize:appFontSize,
        fontWeight: FontWeight.normal,
        color: appHeaderColor);

    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: const Text('Header font',style: TextStyle(color: Colors.black87,fontSize: 16),),
              ),

              Row(
                children: <Widget>[
                  Expanded(
                      child: TextFormField(
                        autofocus: false,
                        controller: _HeaderTextController,
                        style: appHeaderStyle,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                          hintText: 'Please enter header text',
                          hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                        ),
                      )
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: ()=>{
                        visibleHeaderEdit()
                      },
                      icon: const Icon(Icons.edit,color: Colors.orange,),
                    ),
                  )
                ],
              ),
            ],
          ),

          Visibility(
            visible: editHeaderVisible,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                            children: <Widget>[
                              GestureDetector(
                                  child:
                                  Container(
                                    child: Row(
                                      children: const <Widget>[
                                        Icon(Icons.font_download,color: Colors.blue,size: 30,)    ,
                                        SizedBox(width: 10,),
                                        Text("Change Font",style: TextStyle(fontSize: 13),),
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                    ),
                                    margin: const EdgeInsets.all(10),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                  ),
                                  onTap: ()=> {
                                    appHeaderFontChooser()
                                  }
                              ),
                              SelectableText(appHeaderFont,style: TextStyle(color: Colors.black,fontSize: 16,),)
                            ]
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                alignment: Alignment.center,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Icon(Icons.color_lens_outlined,color: Colors.blue,size: 30,),
                                    SizedBox(width: 10,),
                                    Text("Change Color",style: TextStyle(fontSize: 13),),
                                  ],
                                ),
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(5),

                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                              ),
                              onTap: ()=>{appHeaderColorChooser()},
                            ),
                            SelectableText(appHeaderColor.toString().replaceRange(6, 10, '#'),style: TextStyle(color: Colors.black,fontSize: 16,),)
                          ],
                        ),
                      )
                    ],
                  ),

                  Divider(),

                  TitleAlignment(title_alignment, onAlignmentChangeCallback),

                  Divider(),

                  TitleBackground(title_backgroundColor, onTitleBgChangeCallback)
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }

  void updateAppHeaderTextStyle(PickerFont font){
    setState(() {
      appHeaderFont=font.fontFamily;
    });
  }

  void updateAppHeaderColor(Color color){

    if(mounted){
      setState(() {
        appHeaderColor=color;
      });
      Navigator.pop(context);
    }
  }

  visibleHeaderEdit(){
    setState(() {
      editHeaderVisible=true;
    });
  }

  appHeaderFontChooser(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
              content: SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: FontPicker(
                    showInDialog: true,
                    onFontChanged: (font) {
                      updateAppHeaderTextStyle(font);
                    },
                    //  googleFonts: _myGoogleFonts
                  ),
                ),
              ));
        }
    );
  }

  appHeaderColorChooser() {
    showDialog(
        context: context,
        builder: (context){
          return ShowColorPicker(onSaveCallback: updateAppHeaderColor, pickerColor: appHeaderColor,);
        }
    );
  }

  void appIconListener(int index){
    setState(() {
      app_icon=index;
    });
  }

  BoxDecoration getDecoration(int index){
    if(index==app_icon){
      return BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.orange,
              width: 2));
    }
    else{
      return BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.blueGrey,
              width: 1));
    }

  }

  selectIconType() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 140,
      margin: const EdgeInsets.only(left: 10,right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Select icon type',style: TextStyle(color: Colors.black87,fontSize: 16, ),),
          const SizedBox(height: 20,),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: iconTypeList.length,
              itemBuilder: (context, index) => GestureDetector(
                  onTap: ()=>appIconListener(index),
                  child: Container(
                    height: 90,
                    width: 90,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: getDecoration(index),
                    child: iconTypeList[index],
                  )
              ),
            ),)
        ],
      ),
    );
  }

  showFontChooser(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
              content: SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: FontPicker(
                    showInDialog: true,
                    onFontChanged: (font) {
                      updateTextStyle(font);
                    },
                    //  googleFonts: _myGoogleFonts
                  ),
                ),
              ));
        }
    );
  }

  selectLabelFont() {

    appLabelStyle= GoogleFonts.getFont(appLabelFont).copyWith(
        fontSize:appFontSize,
        fontWeight: FontWeight.normal,
        color: appLabelColor);

    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: const Text('Label font',style: TextStyle(color: Colors.black87,fontSize: 16),),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
                padding: const EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 10),
                height: 40,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.orange,
                        width: 1
                    )
                ),
                child: Text(
                  'Your label will look like this',style: appLabelStyle,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                    children: <Widget>[
                      GestureDetector(
                          child:
                          Container(
                            child: Row(
                              children: const <Widget>[
                                Icon(Icons.font_download,color: Colors.blue,size: 30,)    ,
                                SizedBox(width: 10,),
                                Text("Change Font",style: TextStyle(fontSize: 13),),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                            margin: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.blue,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          onTap: ()=> {
                            showFontChooser()
                          }
                      ),
                      SelectableText(appLabelFont,style: TextStyle(color: Colors.black,fontSize: 16,),)
                    ]
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(Icons.color_lens_outlined,color: Colors.blue,size: 30,),
                            SizedBox(width: 10,),
                            Text("Change Color",style: TextStyle(fontSize: 13),),
                          ],
                        ),
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(5),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.blue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      onTap: ()=>{showColorChooser()},
                    ),
                    SelectableText(appLabelColor.toString().replaceRange(6, 10, '#'),style: TextStyle(color: Colors.black,fontSize: 16,),)
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void updateTextStyle(PickerFont font){
    setState(() {
      appLabelFont=font.fontFamily;
    });
  }

  showColorChooser() {
    showDialog(
        context: context,
        builder: (context){
          return ShowColorPicker(onSaveCallback: updateTextColor, pickerColor: appLabelColor,);
        }
    );
  }

  void updateTextColor(Color color){

    setState(() {
      appLabelColor=color;
    });

    Navigator.pop(context);

  }


  //web ui
  web_view(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(' Web View',style: TextStyle(color: Colors.black87,fontSize: 18,fontWeight: FontWeight.bold),),
        const SizedBox(height: 10,),
        selectWebIconType(),
        web_icon==0 || web_icon==2 || web_icon==4?
        selectWebLabelFont():
        Container()
      ],
    );
  }

  selectWebIconType() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 140,
      margin: const EdgeInsets.only(left: 10,right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Select icon type',style: TextStyle(color: Colors.black87,fontSize: 16, ),),
          const SizedBox(height: 20,),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: webIconTypeList.length,
              itemBuilder: (context, index) => GestureDetector(
                  onTap: ()=>selectWebIconListener(index),
                  child: Container(
                    height: 90,
                    width: 90,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: getWebDecoration(index),
                    child: webIconTypeList[index],
                  )
              ),
            ),)
        ],
      ),
    );
  }

  void updateWebTextStyle(PickerFont font){
    setState(() {
      web_LabelFont=font.fontFamily;
    });
  }

  selectWebLabelFont() {

    webLabelStyle= GoogleFonts.getFont(web_LabelFont).copyWith(
        fontSize:webFontSize,
        fontWeight: FontWeight.normal,
        color: webLabelColor);

    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: const Text('Label font',style: TextStyle(color: Colors.black87,fontSize: 16),),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 10),
                height: 40,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.orange,
                        width: 1
                    )
                ),
                child: Text(
                  'Your label will look like this',style: webLabelStyle,
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                    children: <Widget>[
                      GestureDetector(
                          child:
                          Container(
                            child: Row(
                              children: const <Widget>[
                                Icon(Icons.font_download,color: Colors.blue,size: 30,)    ,
                                SizedBox(width: 10,),
                                Text("Change Font",style: TextStyle(fontSize: 13),),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                            margin: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.blue,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          onTap: ()=> {
                            showWebFontChooser()
                          }
                      ),
                      SelectableText(web_LabelFont,style: TextStyle(color: Colors.black,fontSize: 16,),)
                    ]
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(Icons.color_lens_outlined,color: Colors.blue,size: 30,),
                            SizedBox(width: 10,),
                            Text("Change Color",style: TextStyle(fontSize: 13),),
                          ],
                        ),
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(5),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.blue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      onTap: ()=>{showWebColorChooser()},
                    ),
                   SelectableText(webLabelColor.toString().replaceRange(6, 10, '#'),style: TextStyle(color: Colors.black,fontSize: 16,),)
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void selectWebIconListener(int index){
    setState(() {
      web_icon=index;
    });
  }

  BoxDecoration getWebDecoration(int index){
    if(index==web_icon){
      return BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.orange,
              width: 2));
    }
    else{
      return BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.blueGrey,
              width: 1));
    }

  }

  showWebFontChooser(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
              content: SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: FontPicker(
                    showInDialog: true,
                    onFontChanged: (font) {
                      updateWebTextStyle(font);
                    },
                    //  googleFonts: _myGoogleFonts
                  ),
                ),
              ));
        }
    );
  }

  showWebColorChooser() {
    showDialog(
        context: context,
        builder: (context){
          return ShowColorPicker(onSaveCallback: updateWebTextColor, pickerColor: webLabelColor,);
        }
    );
  }

  void updateWebTextColor(Color color){

    setState(() {
      webLabelColor=color;
    });

    Navigator.pop(context);

  }

  void onAlignmentChangeCallback(String alignment) {
    if(this.mounted){
      setState(() {
        title_alignment = alignment;
      });
    }
  }

  void onTitleBgChangeCallback(Color color) {
    if(this.mounted){
      setState(() {
        title_backgroundColor = color;
      });
    }
  }
}