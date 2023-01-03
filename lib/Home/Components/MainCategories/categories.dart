import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Add_Vendor_Screen/Add_Vendor.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/get_title_alignment.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/home_main_category_details.dart';
import 'package:poultry_a2z/Home/Components/MainCategories/ShowMaincategoryListFromHome.dart';
import 'package:poultry_a2z/Home/Components/MainCategories/edit_main_bottomsheet.dart';
import 'package:poultry_a2z/Home/Components/MainCategories/selec_main_categories.dart';
import 'package:poultry_a2z/Home/Components/component_constants.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';


typedef OnDeleteCallBack =Function(String id);
typedef OnGoToListCallBack =Function(String type, String main_cat_id, String sub_cat_id, String brand_id);

class Categories extends StatefulWidget {
  String mainCategory_auto_id;
  bool iseditSwitched;
  OnDeleteCallBack onDeleteCallBack;
  OnGoToListCallBack onGoToListCallBack;
  String component_id;
  String user_type;
  String iconType;
  String layoutType;
  
  Categories(
      this.mainCategory_auto_id,
      this.iseditSwitched,
      this.onDeleteCallBack,
      this.onGoToListCallBack,
      this.component_id,
      this.user_type,
      this.iconType,
      this.layoutType);

  @override
  _CategoriesState createState() => _CategoriesState(iseditSwitched,component_id,iconType,layoutType);
}

class _CategoriesState extends State<Categories> {
  bool iseditSwitched;
  String component_id;
  String iconType;
  String layoutType;

  _CategoriesState(this.iseditSwitched,this.component_id,this.iconType,this.layoutType);

  String appLabelFont = 'Lato',appHeaderFont='Lato',headerTitle='';
  Color appLabelColor=const Color(0xff443a49),appHeaderColor=Colors.black87,
      backgroundColor=Colors.white,
      title_backgroundColor=Colors.transparent;
  double appFontSize=15;

  Alignment titleAlignment = Alignment.centerLeft;

  bool isApiCallProcessing=false;

  List<Content> mainCategoryList=[];

  TextStyle labelStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:12,
      fontWeight: FontWeight.normal,
      color: Colors.grey);

  TextStyle headerStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:15,
      fontWeight: FontWeight.normal,
      color: Colors.black87);

  String title='';

  late Route routes;

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
      getMainCategories();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
  }

  goToMainCategoryScreen(Content mainCategoryList){
    // Navigator.push(context, MaterialPageRoute(builder: (context) =>
    //     MainCategoryScreen(mainCategoryList.maincategoryAutoId,mainCategoryList.mainCategoryName)));
    // Navigator.push(context,
        // MaterialPageRoute(builder: (context) => Add_Vendor(main_cat_id:mainCategoryList.maincategoryAutoId, main_cat_name: mainCategoryList.mainCategoryName)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: 30),
                alignment: titleAlignment,
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: title_backgroundColor,
                  child: Text(title,style: headerStyle,),
                ),
              ),
              Container(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      widget.iseditSwitched==true?
                      GestureDetector(
                        onTap: ()=>{
                          widget.onDeleteCallBack(component_id)
                        },
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          child: const Icon(Icons.delete,color: Colors.redAccent,),
                        ),
                      ):
                      Container(),

                      iseditSwitched==true?
                      GestureDetector(
                        onTap: ()=>{
                          showEdit()
                        },
                        child: Container(
                            padding: const EdgeInsets.all(7),
                            child: const Icon(Icons.edit,color: Colors.orange,)
                        ),):
                      Container(),

                      iseditSwitched==true?
                      GestureDetector(
                        onTap: ()=>{
                          showAddCategory()
                        },
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          child: const Icon(Icons.add_box_rounded,color: Colors.blue,),
                        ),):
                      Container(),

                      GestureDetector(
                        onTap: ()=>{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ShowMaincategoryFromHome(component_id)))
                        },
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          child: const Icon(Icons.arrow_forward),
                        ),)
                    ],
                  )
              )
            ],
          ),

          Container(
              child:
              isApiCallProcessing==true?
              SizedBox(
                height: 80,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) =>
                        Container(
                          height: 70,
                          width: 70,
                          color: Colors.grey[100],
                          margin: EdgeInsets.all(5),)
                ),
              ):
              isApiCallProcessing==false && mainCategoryList.isEmpty?
              SizedBox(
                height: 80,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) =>
                        Container(
                          height: 70,
                          width: 70,
                          color: Colors.grey[100],
                          margin: EdgeInsets.all(5),)
                ),
              ):
              Container(
                //padding: const EdgeInsets.only(left: 2.0,top:2.0,bottom: 2.0,right: 2.0),
                  child:
                  iconType=='0'?
                  SizedBox(
                    height: 30,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mainCategoryList.length,
                        itemBuilder: (context, index) =>
                            CategoryCard1(
                              getmainCategorylist: mainCategoryList[index],
                              mainCategory_auto_id: widget.mainCategory_auto_id,
                              text: mainCategoryList[index].mainCategoryName,
                              textStyle: labelStyle,
                              press: () => {
                                goToMainCategoryScreen(mainCategoryList[index])
                              },
                              longpressed: () => {

                              },
                            )
                    ),
                  ):
                  iconType=='1'?
                  SizedBox(
                    height: 88,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mainCategoryList.length,
                        itemBuilder: (context, index) =>
                            CategoryCard2(
                              getmainCategorylist: mainCategoryList[index],
                              mainCategory_auto_id: widget.mainCategory_auto_id,
                              icon: mainCategoryList[index].categoryImageApp,
                              text: mainCategoryList[index].mainCategoryName,
                              baseUrl: baseUrl,
                              press: () => {
                                goToMainCategoryScreen(mainCategoryList[index])
                              },
                              longpressed: () => {

                              },
                            )
                    ),
                  ):
                  iconType=='2'?
                  SizedBox(
                    height: widget.mainCategory_auto_id!=''?100: 98,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mainCategoryList.length,
                        itemBuilder: (context, index) =>
                            CategoryCard3(
                              getmainCategorylist: mainCategoryList[index],
                              mainCategory_auto_id: widget.mainCategory_auto_id,
                              icon: mainCategoryList[index].categoryImageApp,
                              text: mainCategoryList[index].mainCategoryName,
                              baseUrl: baseUrl,
                              textStyle: labelStyle,
                              press: () => {
                                goToMainCategoryScreen(mainCategoryList[index])
                              },
                              longpressed: () => {
                              },
                            )
                    ),
                  ):
                  iconType=='3'?
                  SizedBox(
                    height: widget.mainCategory_auto_id!=''?85: 80,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mainCategoryList.length,
                        itemBuilder: (context, index) =>
                            CategoryCard4(
                              getmainCategorylist: mainCategoryList[index],
                              mainCategory_auto_id: widget.mainCategory_auto_id,
                              icon: mainCategoryList[index].categoryImageApp,
                              baseUrl: baseUrl,
                              text: mainCategoryList[index].mainCategoryName,
                              press: () => {
                                goToMainCategoryScreen(mainCategoryList[index]),
                              },
                              longpressed: () => {

                              },
                            )
                    ),
                  ):
                  iconType=='4'?
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mainCategoryList.length,
                        itemBuilder: (context, index) =>
                            CategoryCard5(
                              getmainCategorylist: mainCategoryList[index],
                              mainCategory_auto_id: widget.mainCategory_auto_id,
                              icon: mainCategoryList[index].categoryImageApp,
                              baseUrl: baseUrl,
                              text: mainCategoryList[index].mainCategoryName,
                              textStyle: labelStyle,
                              press: () => {
                                goToMainCategoryScreen(mainCategoryList[index])
                              },
                              longpressed: () => {

                              },
                            )
                    ),
                  ):
                  SizedBox(
                    height: widget.mainCategory_auto_id!=''?95:90,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mainCategoryList.length,
                        itemBuilder: (context, index) =>
                            CategoryCard6(
                              getmainCategorylist: mainCategoryList[index],
                              mainCategory_auto_id: widget.mainCategory_auto_id,
                              icon: mainCategoryList[index].categoryImageApp,
                              baseUrl: baseUrl,
                              text: mainCategoryList[index].mainCategoryName,
                              press: () => {
                                goToMainCategoryScreen(mainCategoryList[index])
                              },
                              longpressed: () => {

                              },
                            )
                    ),
                  )
              )
            /* SizedBox(
            height: 80,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mainCategoryList.length,
                itemBuilder: (context, index) =>
                    CategoryCard2(
                      getmainCategorylist: mainCategoryList[index],
                      mainCategory_auto_id: widget.mainCategory_auto_id,
                      icon: mainCategoryList[index].categoryImageApp,
                      baseUrl: baseUrl,
                      text: mainCategoryList[index].mainCategoryName,
                      press: () => {
                        goToMainCategoryScreen(mainCategoryList[index])
                      },
                      longpressed: () => {
                      },
                    )
            ),
          ),*/
          )
        ],
      ),
    );
  }


  showAddCategory(){
    routes = MaterialPageRoute(builder: (context) => SelectMainCategory(onSavelistener,component_id));
    Navigator.push(context, routes).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    getMainCategories();
  }

  void showEdit() {
    routes = MaterialPageRoute(builder: (context) =>  EditMainCategoryStyle(onSavelistener,component_id));
    Navigator.push(context, routes).then(onGoBack);
  }

  onSavelistener(){
    Navigator.pop(context);
    getMainCategories();
  }

  Future getMainCategories() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "component_auto_id":component_id,
      "component_type":MAIN_CATEGORY,
      "admin_auto_id": admin_auto_id,
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
        GetHomeComponentList homeComponent=homeMainCategoryDetails.getHomeComponentList[0];

        mainCategoryList=homeMainCategoryDetails.getHomeComponentList[0].content;

        title=homeMainCategoryDetails.getHomeComponentList[0].title;

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
        if(homeComponent.backgroundColor.isNotEmpty){
          backgroundColor=Color(int.parse(homeComponent.backgroundColor));
        }

        if(homeComponent.titleBackground.isNotEmpty){
          title_backgroundColor=Color(int.parse(homeComponent.titleBackground));
        }

        if(homeComponent.titleAlignment.isNotEmpty){
          titleAlignment=GetAlignement.getTitleAlignment(homeComponent.titleAlignment);
        }

        if(homeComponent.iconType.isNotEmpty){
          iconType=homeComponent.iconType;
        }
        if(homeComponent.layoutType.isNotEmpty){
          layoutType=homeComponent.layoutType;
        }

        headerStyle= GoogleFonts.getFont(appHeaderFont).copyWith(
            fontSize:appFontSize,
            fontWeight: FontWeight.normal,
            color: appHeaderColor);

        labelStyle= GoogleFonts.getFont(appLabelFont).copyWith(
            fontSize:14,
            fontWeight: FontWeight.normal,
            color: appLabelColor);

        if(mounted){
          setState(() {});
        }
      }
    }
  }

}

Widget categoryLoader(){
  return Container(
    height: 70,
    width: 70,
    margin: const EdgeInsets.all(5),
    color: Colors.grey[300],
  );
}

class CategoryCard1 extends StatelessWidget {
  const CategoryCard1({
    Key? key,
    required this.text,
    required this.press,
    required this.textStyle,
    required this.longpressed,
    required this.mainCategory_auto_id,
    required this.getmainCategorylist
  }) : super(key: key);

  final Content getmainCategorylist;
  final String?  text,mainCategory_auto_id;
  final GestureTapCallback press;
  final TextStyle textStyle;
  final GestureLongPressCallback longpressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      //onLongPress: longpressed,
      child: Container(
        decoration: BoxDecoration(
            border: mainCategory_auto_id==getmainCategorylist.maincategoryAutoId?
            Border.all(
                color: Colors.green,
                width: 2
            ):null,
            borderRadius: BorderRadius.circular(2)
        ),
        margin: const EdgeInsets.only(left: 8,right: 8),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              getmainCategorylist.mainCategoryName,
              textAlign: TextAlign.center,
              style: textStyle,
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }
}

class CategoryCard2 extends StatelessWidget {
  const CategoryCard2({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
    required this.longpressed,
    required this.baseUrl,
    required this.mainCategory_auto_id,
    required this.getmainCategorylist,
  }) : super(key: key);

  final String? icon, text,mainCategory_auto_id;
  final GestureTapCallback press;
  final GestureLongPressCallback longpressed;
  final String? baseUrl;
  final Content getmainCategorylist;


  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
         // onLongPress: longpressed,
          onTap: press,
          child:Container(
            margin: EdgeInsets.only(left: 1,),
            decoration: BoxDecoration(
                border: mainCategory_auto_id==getmainCategorylist.maincategoryAutoId?
                Border.all(
                    color: Colors.green,
                    width: 2
                ):null,
                borderRadius: BorderRadius.circular(2)
            ),
            child: Column(
              children: [
                Container(
                    height: 80,
                    width: 80,
                    child:
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child:
                      icon!=''?
                      CachedNetworkImage(
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        imageUrl: baseUrl!+main_categories_base_url+getmainCategorylist.categoryImageApp,
                        placeholder: (context, url) =>
                            Container(decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey[400],
                            )),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ):
                      Container(
                          child:const Icon(Icons.error),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey[400],
                          )),
                    )
                ),
              ],
            )
            ,
          ));
  }
}

class CategoryCard3 extends StatelessWidget {
  const CategoryCard3({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
    required this.textStyle,
    required this.longpressed,
    required this.baseUrl,
    required this.mainCategory_auto_id,
    required this.getmainCategorylist,
  }) : super(key: key);

  final String? icon, text,baseUrl,mainCategory_auto_id;
  final GestureTapCallback press;
  final TextStyle textStyle;
  final GestureLongPressCallback longpressed;
  final Content getmainCategorylist;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
     // onLongPress:  longpressed,
      child: Container(
        decoration: BoxDecoration(
            border: mainCategory_auto_id==getmainCategorylist.maincategoryAutoId?
            Border.all(
                color: Colors.green,
                width: 2
            ):null,
            borderRadius: BorderRadius.circular(2)
        ),
        width: 90,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(5),
                //height: 70,
                // width: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child:
                  icon!=''?
                  CachedNetworkImage(
                    height: 68,
                    width: 68,
                    fit: BoxFit.cover,
                    imageUrl: baseUrl!+main_categories_base_url+icon!,
                    placeholder: (context, url) =>
                        Container(decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey[400],
                        )),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ):
                  Container(
                      child:const Icon(Icons.error),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey[400],
                      )),
                )
            ),
            //const SizedBox(height: 2),
            Text(
              text!,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: textStyle,
            )
          ],
        ),
      ),
    );
  }
}

class CategoryCard4 extends StatelessWidget {
  const CategoryCard4({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
    required this.longpressed,
    required this.baseUrl,
    required this.mainCategory_auto_id,
    required this.getmainCategorylist,
  }) : super(key: key);

  final String? icon, text, baseUrl,mainCategory_auto_id;
  final GestureTapCallback press;
  final GestureLongPressCallback longpressed;
  final Content getmainCategorylist;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: press,
        //onLongPress: longpressed,
        child:Container(
          decoration: BoxDecoration(
              border: mainCategory_auto_id==getmainCategorylist.maincategoryAutoId?
              Border.all(
                  color: Colors.green,
                  width: 2
              ):null,
              borderRadius: BorderRadius.circular(2)
          ),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(5),
                  height: 80,
                  width: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child:
                    icon!=''?
                    CachedNetworkImage(
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      imageUrl: baseUrl!+main_categories_base_url+icon!,
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
            ],
          )
          ,
        ));
  }
}

class CategoryCard5 extends StatelessWidget {
  const CategoryCard5({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
    required this.textStyle,
    required this.longpressed,
    required this.baseUrl,
    required this.mainCategory_auto_id,
    required this.getmainCategorylist
  }) : super(key: key);

  final String? icon, text,baseUrl,mainCategory_auto_id;
  final GestureTapCallback press;
  final TextStyle textStyle;
  final GestureLongPressCallback longpressed;
  final Content getmainCategorylist;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
     // onLongPress: longpressed,
      child:Container(
        //width: 90,
        decoration: BoxDecoration(
            border: mainCategory_auto_id==getmainCategorylist.maincategoryAutoId?
            Border.all(
                color: Colors.green,
                width: 2
            ):null,
            borderRadius: BorderRadius.circular(2)
        ),
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(5),
                // height: 70,
                //width: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child:
                  icon!=''?
                  CachedNetworkImage(
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                    imageUrl: baseUrl!+main_categories_base_url+icon!,
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
            //const SizedBox(height: 2),
            Flexible(child: Text(
              text!,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: textStyle,
            )
            )
          ],
        ),
      ),
    );
  }
}

class CategoryCard6 extends StatelessWidget {
  const CategoryCard6({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
    required this.longpressed,
    required this.baseUrl,
    required this.mainCategory_auto_id,
    required this.getmainCategorylist,
  }) : super(key: key);

  final String? icon, text, baseUrl,mainCategory_auto_id;
  final GestureTapCallback press;
  final GestureLongPressCallback longpressed;
  final Content getmainCategorylist;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: press,
       // onLongPress: longpressed,
        child:Container(
          decoration: BoxDecoration(
              border: mainCategory_auto_id==getmainCategorylist.maincategoryAutoId?
              Border.all(
                  color: Colors.green,
                  width: 2
              ):null,
              borderRadius: BorderRadius.circular(2)
          ),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(5),
                  height: 90,
                  width: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child:
                    icon!=''?
                    CachedNetworkImage(
                      // height: 70,
                      // width: 70,
                      fit: BoxFit.cover,
                      imageUrl: baseUrl!+main_categories_base_url+icon!,
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
            ],
          )
          ,
        ));
  }
}

