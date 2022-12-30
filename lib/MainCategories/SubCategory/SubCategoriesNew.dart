// ignore: file_names
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Product_List.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/get_title_alignment.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/home_subcategory_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Utils/App_Apis.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../Home/Components/AddNewComponent/SubCategory/edit_subcategory_bottomsheet.dart';
import '../../Home/Components/AddNewComponent/models/sub_category_model.dart';
import '../../Home/Components/component_constants.dart';
import '../../Product_Details/Product_List_User.dart';
import 'ShowSubcategoryListFromMain.dart';
import 'selec_sub_categories.dart';

typedef OnDeleteCallBack =Function(String id);
typedef OnGoToListCallBack =Function(String type, String main_cat_id, String sub_cat_id, String brand_id);

class SubCategoriesNew extends StatefulWidget {
  bool iseditSwitched;
  String component_id;
  OnDeleteCallBack onDeleteCallBack;
  String main_category_auto_id;
  String user_type;
  OnGoToListCallBack onGoToListCallBack;
  String iconType;
  String layoutType;

  SubCategoriesNew(this.iseditSwitched, this.component_id,this.onDeleteCallBack,this.main_category_auto_id,this.user_type,
      this.onGoToListCallBack,  this.iconType,this.layoutType);
  
  @override
  _SubCategoriesNew createState() => _SubCategoriesNew(iseditSwitched,component_id,main_category_auto_id,iconType,layoutType);
}

class _SubCategoriesNew extends State<SubCategoriesNew> {
  bool iseditSwitched;
  String component_id;
  String main_category_auto_id;
  String iconType;
  String layoutType;
Color scrollbarColor=Colors.pinkAccent;
  final ScrollController _controllerOne = ScrollController();
  double scrollbarthickness=2;


  _SubCategoriesNew(this.iseditSwitched, this.component_id,this.main_category_auto_id,this.iconType,this.layoutType);

  bool isUiAvailable=false;
  
  bool isApiCallProcessing=false;

  String appLabelFont = 'Lato',appHeaderFont='Lato',headerTitle='';
  Color appLabelColor=const Color(0xff443a49),appHeaderColor=Colors.black87,
      title_backgroundColor=Colors.transparent, backgroundColor=Colors.transparent;

  Alignment titleAlignment = Alignment.centerLeft;

  double appFontSize=15;

  TextStyle labelStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:12,
      fontWeight: FontWeight.normal,
      color: Colors.grey);

  TextStyle headerStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:16,
      fontWeight: FontWeight.normal,
      color: Colors.black87);

  late Route routes;

  String title='';

  List<GetmainSubcategorylist> subcategoryList=[];

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
      getSubCategoriesUi();
      getSubCategories();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    getBaseUrl();
  }

  int getItemsCount(){
    if(layoutType=="0" && (subcategoryList.length>=4|| subcategoryList.isEmpty)){
      return 4;
    }
    else if(layoutType=="1" && (subcategoryList.length>=6 || subcategoryList.isEmpty)){
      return 6;
    }
    else if(layoutType=="2" && (subcategoryList.length>=8 || subcategoryList.isEmpty)){
      return 8;
    }
    else if(layoutType=="3" && (subcategoryList.length>=9 || subcategoryList.isEmpty)){
      return 9;
    }
    else if(layoutType=="4" && (subcategoryList.length>=16 || subcategoryList.isEmpty)){
      return 16;
    }
    else if(layoutType=="5" && (subcategoryList.length>=6 || subcategoryList.isEmpty)){
      return 6;
    }
    else if(layoutType=="6" && (subcategoryList.length>=12 || subcategoryList.isEmpty)){
      return 12;
    }
    else if(layoutType=="7" || layoutType=='11'){
      if(subcategoryList.isEmpty){
        return 6;
      }
      else{
        subcategoryList.length;
      }
    }
    return subcategoryList.length;
  }

  int getCrossAxisCount(){
    if(layoutType.isEmpty){
      return 1;
    }
    else if(layoutType=="0" || layoutType=="5"){
      return 2;
    }
    else if(layoutType=="1" || layoutType=="3"){
      return 3;
    }
    else if(layoutType=="2" || layoutType=="4"){
      return 4;
    }
    else if(layoutType=="6"){
      return 2;
    }
    else if(layoutType=="7"){
      subcategoryList.length;
    }
    else if(layoutType=="11"){
      return 1;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color:backgroundColor,
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
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[

                      iseditSwitched==true?
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
                          showCategoryEdit()
                        },
                        child: Container(
                            padding: const EdgeInsets.all(7),
                            child: const Icon(Icons.edit,color: Colors.orange,)
                        ),):
                      Container(),

                      GestureDetector(
                        onTap: ()=>{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ShowSubcategoryFromMain(
                              component_id,main_category_auto_id)))
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

          Padding(
            padding: const EdgeInsets.only(left: 3.0, right: 3),
            child: Container(
                child:
                isUiAvailable==true?
                getUi():
                Container()
            ),
          ),
        ],
      ),
    );
  }

  void showCategoryEdit() {
    routes = MaterialPageRoute(builder: (context) =>  EditSubCategoryStyle(onSaveUilistener,component_id));
    Navigator.push(context, routes);
  }
  
  showAddCategory(){
    routes = MaterialPageRoute(builder: (context) => SelectSubCategory(onSavelistener,component_id,main_category_auto_id));
    Navigator.push(context, routes);
  }

  void onSaveUilistener(){
    Navigator.pop(context);
    getSubCategoriesUi();
  }

  void onSavelistener(){
    Navigator.pop(context);
    getSubCategories();
  }

  void getSubCategories() async {
    final body = {
      "main_category_auto_id": main_category_auto_id,
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
        subcategoryList=subCategoryModel.getmainSubcategorylist;
        if(this.mounted){
          setState(() {});
        }
      }
    }
  }

  Future getSubCategoriesUi() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "component_auto_id":component_id,
      "component_type":SHOP_BY_CATEGORY,
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
        HomeSubcategoryDetails homeSubcategoryDetails=HomeSubcategoryDetails.fromJson(json.decode(response.body));
        GetHomeComponentList homeComponent=homeSubcategoryDetails.getHomeComponentList[0];
        isUiAvailable=true;
        title=homeSubcategoryDetails.getHomeComponentList[0].title;

        if(homeComponent.titleFont.isNotEmpty){
          appHeaderFont=homeComponent.titleFont;
        }
        if(homeComponent.titleColor.isNotEmpty){
          appHeaderColor=Color(int.parse(homeComponent.titleColor));
        }

        if(homeComponent.iconType.isNotEmpty){
          iconType=homeComponent.iconType;
        }
        if(homeComponent.layoutType.isNotEmpty){
          layoutType=homeComponent.layoutType;
        }

        if(homeComponent.backgroundColor.isNotEmpty){
          backgroundColor=Color(int.parse(homeComponent.backgroundColor));
        }

        if(homeComponent.labelFont.isNotEmpty){
          appLabelFont=homeComponent.labelFont;
        }
        if(homeComponent.labelColor.isNotEmpty){
          appLabelColor=Color(int.parse(homeComponent.labelColor));
        }
        if(homeComponent.titleBackground.isNotEmpty){
          title_backgroundColor=Color(int.parse(homeComponent.titleBackground));
        }

        if(homeComponent.titleAlignment.isNotEmpty){
          titleAlignment=GetAlignement.getTitleAlignment(homeComponent.titleAlignment);
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

  FutureOr onGoBack(dynamic value) {
    getSubCategories();
  }

  goToNextScreen(int index){

    widget.onGoToListCallBack("subcategory",
        subcategoryList[index].mainCategoryAutoId,subcategoryList[index].id, "");
  }

  getUi(){
    if(iconType=="0"){
      if(layoutType=="6"){
        return SizedBox(
          height: 280,
          child:RawScrollbar(
            thickness: scrollbarthickness,
            thumbColor: scrollbarColor,
            trackColor: Colors.grey,
            trackRadius: Radius.circular(10),
            controller: _controllerOne,
            thumbVisibility: true,
            child: GridView.count(
                padding: EdgeInsets.zero,
                controller: _controllerOne,
                shrinkWrap: true,
                crossAxisCount: 2,
                // childAspectRatio: 1/1,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children:getLayout()
            ),
          ),
        );
      }
      else if(layoutType=="7"){
        if(subcategoryList.isEmpty){
          return
            Container(
              height: 150,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _controllerOne,

                  itemCount: subcategoryList.length,
                  itemBuilder: (context, index) =>
                      GestureDetector(
                        onTap: ()=>{goToNextScreen(index)},
                        child: Container(
                          margin: const EdgeInsets.only(right: 5),
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(100)
                          ),
                        )
                        ,
                      )
              ),
            );

        }
        else{
          return SizedBox(
            height: 150,
            child:RawScrollbar(
              thickness: scrollbarthickness,
              thumbColor: scrollbarColor,
              trackColor: Colors.grey,
              trackRadius: Radius.circular(10),
              controller: _controllerOne,
              thumbVisibility: true,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _controllerOne,
                  itemCount: subcategoryList.length,
                  itemBuilder: (context, index) =>
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        width: 150,
                        height: MediaQuery.of(context).size.height,
                        child: GestureDetector(
                          onTap: () {
                            goToNextScreen(index);
                          },
                          child: Container(
                            color: Colors.transparent,
                            child:
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child:
                              subcategoryList[index].subcategoryImageApp!=''?
                              CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: baseUrl+sub_categories_base_url+subcategoryList[index].subcategoryImageApp,
                                placeholder: (context, url) =>
                                    Container(decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.grey[400],
                                    )),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ):
                              Container(
                                  child:const Icon(Icons.error),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.grey[400],
                                  )),
                            )
                            ,
                          ),
                        ),

                      )
              ),
            ),
          );
        }
      }
      else if(layoutType=='8'){
        if(subcategoryList.isEmpty){
          return
            SizedBox(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex:1,
                        child:
                        Container(
                          margin: EdgeInsets.all(2),
                          color: Colors.grey[100],
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                        )
                    ),
                    Expanded(
                      flex:1,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child:Container(
                                margin: EdgeInsets.all(2),
                                color: Colors.grey[100],
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),

                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.all(2),
                                color: Colors.grey[100],
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                  ],
                )
            );
        }
        else{
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex:2,
                      child:
                      SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:
                          subcategoryList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child: Container(
                              margin: EdgeInsets.all(1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child:
                                subcategoryList[0].subcategoryImageApp!=''?
                                CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+sub_categories_base_url+subcategoryList[0].subcategoryImageApp,
                                  placeholder: (context, url) =>
                                      Container(decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: Colors.grey[400],
                                      )),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ):
                                Container(
                                    child:const Icon(Icons.error),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.grey[400],
                                    )),
                              )
                              ,
                            ),
                          ):
                          Container()
                      )
                  ),

                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>1 && subcategoryList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: subcategoryList[1].subcategoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[1].subcategoryImageApp,
                                        placeholder: (context, url) =>
                                            Container(decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ):
                                      Container(
                                          child:const Icon(Icons.error),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.grey[400],
                                          )),
                                    )
                                    ,
                                  ),
                                ):
                                Container()
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>2 && subcategoryList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child:
                                      subcategoryList[2].subcategoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[2].subcategoryImageApp,
                                        placeholder: (context, url) =>
                                            Container(decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ):
                                      Container(
                                          child:const Icon(Icons.error),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.grey[400],
                                          )),
                                    )
                                    ,
                                  ),
                                ):
                                Container()
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                ],
              )
          );
        }
      }
      else if(layoutType=='9'){
        if(subcategoryList.isEmpty){
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child:Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex:1,
                      child:
                      Container(
                        margin: EdgeInsets.all(2),
                        color: Colors.grey[100],
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      )
                  ),
                ],
              )
          );
        }
        else{
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>1 && subcategoryList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: subcategoryList[1].subcategoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[1].subcategoryImageApp,
                                        placeholder: (context, url) =>
                                            Container(decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ):
                                      Container(
                                          child:const Icon(Icons.error),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.grey[400],
                                          )),
                                    )
                                    ,
                                  ),
                                ):
                                Container()
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>2 && subcategoryList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child:
                                      subcategoryList[2].subcategoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[2].subcategoryImageApp,
                                        placeholder: (context, url) =>
                                            Container(decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ):
                                      Container(
                                          child:const Icon(Icons.error),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.grey[400],
                                          )),
                                    )
                                    ,
                                  ),
                                ):
                                Container()
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex:2,
                      child:
                      SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:
                          subcategoryList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child: Container(
                              margin: EdgeInsets.all(1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child:
                                subcategoryList[0].subcategoryImageApp!=''?
                                CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+sub_categories_base_url+subcategoryList[0].subcategoryImageApp,
                                  placeholder: (context, url) =>
                                      Container(decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: Colors.grey[400],
                                      )),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ):
                                Container(
                                    child:const Icon(Icons.error),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.grey[400],
                                    )),
                              )
                              ,
                            ),
                          ):
                          Container()
                      )
                  ),
                ],
              )
          );
        }
      }
      else if(layoutType=='10'){
        if (subcategoryList.isEmpty) {
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    color: Colors.grey[300],
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    color: Colors.grey[300],
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        )
                      ],
                    ),
                  )

                ],
              ));
        }
        else {
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    child: SizedBox(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        child:
                                        subcategoryList.length>1 && subcategoryList[0]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(1),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child:
                                              subcategoryList[0].subcategoryImageApp!=''?
                                              CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+sub_categories_base_url+subcategoryList[0].subcategoryImageApp,
                                                placeholder: (context, url) =>
                                                    Container(decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(100),
                                                      color: Colors.grey[400],
                                                    )),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                              ):
                                              Container(
                                                  child:const Icon(Icons.error),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    color: Colors.grey[400],
                                                  )),
                                            )
                                            ,
                                          ),
                                        ):
                                        Container()
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    child: SizedBox(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        child:
                                        subcategoryList.length>2 && subcategoryList[1]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(1),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child:
                                              subcategoryList[1].subcategoryImageApp!=''?
                                              CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+sub_categories_base_url+subcategoryList[1].subcategoryImageApp,
                                                placeholder: (context, url) =>
                                                    Container(decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(100),
                                                      color: Colors.grey[400],
                                                    )),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                              ):
                                              Container(
                                                  child:const Icon(Icons.error),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    color: Colors.grey[400],
                                                  )),
                                            )
                                            ,
                                          ),
                                        ):
                                        Container()
                                    ),
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  subcategoryList.length>3 && subcategoryList[2]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child:
                                        subcategoryList[2].subcategoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+sub_categories_base_url+subcategoryList[2].subcategoryImageApp,
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: Colors.grey[400],
                                              )),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ):
                                        Container(
                                            child:const Icon(Icons.error),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                      )
                                      ,
                                    ),
                                  ):
                                  Container()
                              ),
                            )
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  subcategoryList.length>4 && subcategoryList[3]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child:
                                        subcategoryList[3].subcategoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+sub_categories_base_url+subcategoryList[3].subcategoryImageApp,
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: Colors.grey[400],
                                              )),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ):
                                        Container(
                                            child:const Icon(Icons.error),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                      )
                                      ,
                                    ),
                                  ):
                                  Container()
                              ),
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  subcategoryList.length>5 && subcategoryList[4]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child:
                                        subcategoryList[4].subcategoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+sub_categories_base_url+subcategoryList[4].subcategoryImageApp,
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: Colors.grey[400],
                                              )),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ):
                                        Container(
                                            child:const Icon(Icons.error),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                      )
                                      ,
                                    ),
                                  ):
                                  Container()
                              ),
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  subcategoryList.length==6 && subcategoryList[5]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child:
                                        subcategoryList[5].subcategoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+sub_categories_base_url+subcategoryList[5].subcategoryImageApp,
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: Colors.grey[400],
                                              )),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ):
                                        Container(
                                            child:const Icon(Icons.error),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                      )
                                      ,
                                    ),
                                  ):
                                  Container()
                              ),
                            )
                        )
                      ],
                    ),
                  )

                ],
              ));
        }
      }
      else {
        if(subcategoryList.isEmpty){
          return
            GridView.builder(
              itemCount: getItemsCount(),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: getCrossAxisCount(),
              ),
              itemBuilder: (context, index) =>
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(100)
                    ),
                  ),
            );
        }
        else{
          return
            GridView.builder(
              itemCount: getItemsCount(),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //crossAxisSpacing: 2,
                //mainAxisSpacing: 2,
                crossAxisCount: getCrossAxisCount(),
              ),
              itemBuilder: (context, index) =>
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      onTap: () {
                        goToNextScreen(index);
                      },
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child:
                          subcategoryList[index].subcategoryImageApp!=''?
                          CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: baseUrl+sub_categories_base_url+subcategoryList[index].subcategoryImageApp,
                            placeholder: (context, url) =>
                                Container(decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.grey[400],
                                )),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ):
                          Container(
                              child:const Icon(Icons.error),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.grey[400],
                              )),
                        )
                        ,
                      ),
                    ),

                  ),
            );
        }
      }

    }
    else if(iconType=="1"){
      if(layoutType=="6"){
        return SizedBox(
            height: 300,
            child:RawScrollbar(
              thickness: scrollbarthickness,
              thumbColor: scrollbarColor,
              trackColor: Colors.grey,
              trackRadius: Radius.circular(10),
              controller: _controllerOne,
              thumbVisibility: true,
              child: GridView.count(
                //padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  controller: _controllerOne,
                  crossAxisCount: 2,
                  childAspectRatio: 1.1/1,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,

                  children:getLayout()
              ),
            ));
      }
      else if(layoutType=="7"){
        if(subcategoryList.isEmpty){
          return Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 10),
            child:
            ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _controllerOne,

                itemCount: subcategoryList.length,
                itemBuilder: (context, index) =>
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      height: 150,
                      width: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 120,
                            height: 120,
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(100)
                            ),
                          ),
                          Container(
                            height: 15,
                            width: 70,
                            color: Colors.grey[100],
                          )
                        ],
                      ),
                    )
            ),
          );
        }
        else{
          return SizedBox(
            height: 150,
            child:RawScrollbar(
              thickness: scrollbarthickness,
              thumbColor: scrollbarColor,
              trackColor: Colors.grey,
              trackRadius: Radius.circular(10),
              controller: _controllerOne,
              thumbVisibility: true,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _controllerOne,
                  itemCount: subcategoryList.length,
                  itemBuilder: (context, index) =>
                      GestureDetector(
                        onTap: ()=>{
                          goToNextScreen(index)
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 5),
                          height: 150,
                          width: 120,
                          child: GestureDetector(
                              onTap: () {
                                goToNextScreen(index);
                              },
                              child: Container(
                                height: 150,
                                width: 120,
                                margin: const EdgeInsets.all(3),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex:8,
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 5),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child:
                                          subcategoryList[index].subcategoryImageApp!=''?
                                          CachedNetworkImage(
                                            width: MediaQuery.of(context).size.width,
                                            fit: BoxFit.fill,
                                            imageUrl: baseUrl+sub_categories_base_url+subcategoryList[index].subcategoryImageApp,
                                            placeholder: (context, url) =>
                                                Container(decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Colors.grey[400],
                                                )),
                                          ):
                                          Container(
                                              child:const Icon(Icons.error),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.grey[400],
                                              )),
                                        )
                                        ,
                                      ),
                                    ),
                                    Expanded(
                                        flex:2,
                                        child: Text(subcategoryList[index].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                    )
                                  ],
                                ),
                              )
                          ),

                        ),
                      )
              ),
            ),
          );
        }
      }
      else if(layoutType=='8'){
        if(subcategoryList.isEmpty){
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex:1,
                      child:
                      Container(
                        margin: EdgeInsets.all(2),
                        color: Colors.grey[100],
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      )
                  ),
                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child:Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                ],
              )
          );
        }
        else{
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex:2,
                      child:
                      SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:
                          subcategoryList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child:
                            Container(
                              margin: EdgeInsets.all(1),
                              child:Column(
                                children: <Widget>[
                                  Expanded(
                                    flex:18,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child:
                                        subcategoryList[0].subcategoryImageApp!=''?
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+sub_categories_base_url+subcategoryList[0].subcategoryImageApp,
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.grey[400],
                                              )),
                                        ):
                                        Container(
                                            child:const Icon(Icons.error),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.grey[400],
                                            )),
                                      )
                                      ,
                                    ),
                                  ),
                                  Expanded(
                                      flex:1,
                                      child: Text(subcategoryList[0].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                  )
                                ],
                              ),
                            ),
                          ):
                          Container()
                      )
                  ),

                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>1 && subcategoryList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child:Container(
                                    margin: EdgeInsets.all(1),
                                    child:Column(
                                      children: <Widget>[
                                        Expanded(
                                          flex:10,
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 5),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child:
                                              subcategoryList[1].subcategoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+sub_categories_base_url+subcategoryList[1].subcategoryImageApp,
                                                placeholder: (context, url) =>
                                                    Container(decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.grey[400],
                                                    )),
                                              ):
                                              Container(
                                                  child:const Icon(Icons.error),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.grey[400],
                                                  )),
                                            )
                                            ,
                                          ),
                                        ),
                                        Expanded(
                                            flex:1,
                                            child: Text(subcategoryList[1].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                        )
                                      ],
                                    ),
                                  ),
                                ):
                                Container()
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>2 && subcategoryList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child:Container(
                                    margin: EdgeInsets.all(1),
                                    child:Column(
                                      children: <Widget>[
                                        Expanded(
                                          flex:10,
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 5),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child:
                                              subcategoryList[2].subcategoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+sub_categories_base_url+subcategoryList[2].subcategoryImageApp,
                                                placeholder: (context, url) =>
                                                    Container(decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.grey[400],
                                                    )),
                                              ):
                                              Container(
                                                  child:const Icon(Icons.error),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.grey[400],
                                                  )),
                                            )
                                            ,
                                          ),
                                        ),
                                        Expanded(
                                            flex:1,
                                            child: Text(subcategoryList[2].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                        )
                                      ],
                                    ),
                                  ),
                                ):
                                Container()
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                ],
              )
          );
        }
      }
      else if(layoutType=='9'){
        if(subcategoryList.isEmpty){
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[

                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child:Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex:1,
                      child:
                      Container(
                        margin: EdgeInsets.all(2),
                        color: Colors.grey[100],
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      )
                  )
                ],
              )
          );
        }
        else{
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>1 && subcategoryList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child:Container(
                                    margin: EdgeInsets.all(1),
                                    child:Column(
                                      children: <Widget>[
                                        Expanded(
                                          flex:10,
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 5),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child:
                                              subcategoryList[1].subcategoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+sub_categories_base_url+subcategoryList[1].subcategoryImageApp,
                                                placeholder: (context, url) =>
                                                    Container(decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.grey[400],
                                                    )),
                                              ):
                                              Container(
                                                  child:const Icon(Icons.error),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.grey[400],
                                                  )),
                                            )
                                            ,
                                          ),
                                        ),
                                        Expanded(
                                            flex:1,
                                            child: Text(subcategoryList[1].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                        )
                                      ],
                                    ),
                                  ),
                                ):
                                Container()
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>2 && subcategoryList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child:Container(
                                    margin: EdgeInsets.all(1),
                                    child:Column(
                                      children: <Widget>[
                                        Expanded(
                                          flex:10,
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 5),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child:
                                              subcategoryList[2].subcategoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+sub_categories_base_url+subcategoryList[2].subcategoryImageApp,
                                                placeholder: (context, url) =>
                                                    Container(decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.grey[400],
                                                    )),
                                              ):
                                              Container(
                                                  child:const Icon(Icons.error),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.grey[400],
                                                  )),
                                            )
                                            ,
                                          ),
                                        ),
                                        Expanded(
                                            flex:1,
                                            child: Text(subcategoryList[2].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                        )
                                      ],
                                    ),
                                  ),
                                ):
                                Container()
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex:2,
                      child:
                      SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:
                          subcategoryList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child:
                            Container(
                              margin: EdgeInsets.all(1),
                              child:Column(
                                children: <Widget>[
                                  Expanded(
                                    flex:18,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child:
                                        subcategoryList[0].subcategoryImageApp!=''?
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+sub_categories_base_url+subcategoryList[0].subcategoryImageApp,
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.grey[400],
                                              )),
                                        ):
                                        Container(
                                            child:const Icon(Icons.error),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.grey[400],
                                            )),
                                      )
                                      ,
                                    ),
                                  ),
                                  Expanded(
                                      flex:1,
                                      child: Text(subcategoryList[0].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                  )
                                ],
                              ),
                            ),
                          ):
                          Container()
                      )
                  ),
                ],
              )
          );
        }
      }
      else if(layoutType=='10'){
        if (subcategoryList.isEmpty) {
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    color: Colors.grey[300],
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    color: Colors.grey[300],
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        )
                      ],
                    ),
                  )

                ],
              ));
        }
        else {
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    child: SizedBox(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        child:
                                        subcategoryList.length>1 && subcategoryList[0]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child:Container(
                                            margin: EdgeInsets.all(1),
                                            child:Column(
                                              children: <Widget>[
                                                Expanded(
                                                  flex:10,
                                                  child: Container(
                                                    margin: const EdgeInsets.only(bottom: 2),
                                                    padding: EdgeInsets.only(left:10,right:10),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(100),
                                                      child:
                                                      subcategoryList[0].subcategoryImageApp!=''?
                                                      CachedNetworkImage(
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.fill,
                                                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[0].subcategoryImageApp,
                                                        placeholder: (context, url) =>
                                                            Container(decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              color: Colors.grey[400],
                                                            )),
                                                      ):
                                                      Container(
                                                          child:const Icon(Icons.error),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            color: Colors.grey[400],
                                                          )),
                                                    )
                                                    ,
                                                  ),
                                                ),
                                                Expanded(
                                                    flex:2,
                                                    child: Text(subcategoryList[0].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                                )
                                              ],
                                            ),
                                          ),
                                        ):
                                        Container()
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    child: SizedBox(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        child:
                                        subcategoryList.length>2 && subcategoryList[1]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child:Container(
                                            margin: EdgeInsets.all(1),
                                            child:Column(
                                              children: <Widget>[
                                                Expanded(
                                                  flex:10,
                                                  child: Container(
                                                    margin: const EdgeInsets.only(bottom: 2),
                                                    padding: EdgeInsets.only(left:10,right:10),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(100),
                                                      child:
                                                      subcategoryList[1].subcategoryImageApp!=''?
                                                      CachedNetworkImage(
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.fill,
                                                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[1].subcategoryImageApp,
                                                        placeholder: (context, url) =>
                                                            Container(decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              color: Colors.grey[400],
                                                            )),
                                                      ):
                                                      Container(
                                                          child:const Icon(Icons.error),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            color: Colors.grey[400],
                                                          )),
                                                    )
                                                    ,
                                                  ),
                                                ),
                                                Expanded(
                                                    flex:2,
                                                    child: Text(subcategoryList[1].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                                )
                                              ],
                                            ),
                                          ),
                                        ):
                                        Container()
                                    ),
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child:
                              subcategoryList.length>3 && subcategoryList[2]!=null?
                              GestureDetector(
                                onTap: () {
                                  goToNextScreen(1);
                                },
                                child:Container(
                                  margin: EdgeInsets.all(1),
                                  child:Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex:10,
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 2),
                                          padding: EdgeInsets.only(left:13,right:13),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(100),
                                            child:
                                            subcategoryList[2].subcategoryImageApp!=''?
                                            CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.fill,
                                              imageUrl: baseUrl+sub_categories_base_url+subcategoryList[2].subcategoryImageApp,
                                              placeholder: (context, url) =>
                                                  Container(decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.grey[400],
                                                  )),
                                            ):
                                            Container(
                                                child:const Icon(Icons.error),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Colors.grey[400],
                                                )),
                                          )
                                          ,
                                        ),
                                      ),
                                      Expanded(
                                          flex:1,
                                          child: Text(subcategoryList[2].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                      )
                                    ],
                                  ),
                                ),
                              ):
                              Container()
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child:
                              subcategoryList.length>4 && subcategoryList[3]!=null?
                              GestureDetector(
                                onTap: () {
                                  goToNextScreen(1);
                                },
                                child:Container(
                                  margin: EdgeInsets.all(1),
                                  child:Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex:10,
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 2),
                                          padding: EdgeInsets.only(left:10,right:10),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(100),
                                            child:
                                            subcategoryList[3].subcategoryImageApp!=''?
                                            CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.fill,
                                              imageUrl: baseUrl+sub_categories_base_url+subcategoryList[3].subcategoryImageApp,
                                              placeholder: (context, url) =>
                                                  Container(decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.grey[400],
                                                  )),
                                            ):
                                            Container(
                                                child:const Icon(Icons.error),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Colors.grey[400],
                                                )),
                                          )
                                          ,
                                        ),
                                      ),
                                      Expanded(
                                          flex:2,
                                          child: Text(subcategoryList[3].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                      )
                                    ],
                                  ),
                                ),
                              ):
                              Container()
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  subcategoryList.length>5 && subcategoryList[4]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child:Container(
                                      margin: EdgeInsets.all(1),
                                      child:Column(
                                        children: <Widget>[
                                          Expanded(
                                            flex:10,
                                            child: Container(
                                              margin: const EdgeInsets.only(bottom: 2),
                                              padding: EdgeInsets.only(left:10,right:10),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(100),
                                                child:
                                                subcategoryList[4].subcategoryImageApp!=''?
                                                CachedNetworkImage(
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.fill,
                                                  imageUrl: baseUrl+sub_categories_base_url+subcategoryList[4].subcategoryImageApp,
                                                  placeholder: (context, url) =>
                                                      Container(decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        color: Colors.grey[400],
                                                      )),
                                                ):
                                                Container(
                                                    child:const Icon(Icons.error),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.grey[400],
                                                    )),
                                              )
                                              ,
                                            ),
                                          ),
                                          Expanded(
                                              flex:2,
                                              child: Text(subcategoryList[4].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                          )
                                        ],
                                      ),
                                    ),
                                  ):
                                  Container()
                              ),
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  subcategoryList.length==6 && subcategoryList[5]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child:Container(
                                      margin: EdgeInsets.all(1),
                                      child:Column(
                                        children: <Widget>[
                                          Expanded(
                                            flex:10,
                                            child: Container(
                                              margin: const EdgeInsets.only(bottom: 2),
                                              padding: EdgeInsets.only(left:10,right:10),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(100),
                                                child:
                                                subcategoryList[5].subcategoryImageApp!=''?
                                                CachedNetworkImage(
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.fill,
                                                  imageUrl: baseUrl+sub_categories_base_url+subcategoryList[5].subcategoryImageApp,
                                                  placeholder: (context, url) =>
                                                      Container(decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        color: Colors.grey[400],
                                                      )),
                                                ):
                                                Container(
                                                    child:const Icon(Icons.error),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.grey[400],
                                                    )),
                                              )
                                              ,
                                            ),
                                          ),
                                          Expanded(
                                              flex:2,
                                              child: Text(subcategoryList[5].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                          )
                                        ],
                                      ),
                                    ),
                                  ):
                                  Container()
                              ),
                            )
                        )
                      ],
                    ),
                  )

                ],
              ));
        }
      }
      else{
        if(subcategoryList.isEmpty){
          return
            GridView.builder(
              itemCount: getItemsCount(),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1/1.3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: getCrossAxisCount(),
              ),
              itemBuilder: (context, index) =>
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(100)
                          ),
                        ),
                        Container(
                          height: 15,
                          width: 60,
                          color: Colors.grey[100],
                        )
                      ],
                    ),
                  ),
            );
        }
        else{
          return
            GridView.builder(
              itemCount: getItemsCount(),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1/1.3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: getCrossAxisCount(),
              ),
              itemBuilder: (context, index) =>
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                        onTap: () {
                          goToNextScreen(index);
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.all(3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 8,
                                child:  Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child:
                                    subcategoryList[index].subcategoryImageApp!=''?
                                    CachedNetworkImage(
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fill,
                                      imageUrl: baseUrl+sub_categories_base_url+subcategoryList[index].subcategoryImageApp,
                                      placeholder: (context, url) =>
                                          Container(decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.grey[400],
                                          )),
                                    ):
                                    Container(
                                        child:const Icon(Icons.error),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.grey[400],
                                        )),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Text(subcategoryList[index].subCategoryName,style: labelStyle,maxLines: 1,
                                    textAlign: TextAlign.center,)
                              ),
                            ],
                          ),
                        )
                    ),

                  ),
            );
        }
      }
    }
    else if(iconType=="2"){
      if(layoutType=="6"){
        return SizedBox(
            height: 280,
            child:RawScrollbar(
              thickness: scrollbarthickness,
              thumbColor: scrollbarColor,
              trackColor: Colors.grey,
              trackRadius: Radius.circular(10),
              controller: _controllerOne,
              thumbVisibility: true,
              child: GridView.count(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  controller: _controllerOne,
                  childAspectRatio: 1/1,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children:getLayout()
              )
              ,
            ));
      }
      else if(layoutType=="7"){
        if(subcategoryList.isEmpty){
          return Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _controllerOne,

              itemCount: subcategoryList.length,
              itemBuilder: (context, index) =>
                  GestureDetector(
                      onTap: ()=>{
                        goToNextScreen(index)
                      },
                      child:  Container(
                        margin: const EdgeInsets.only(right: 5),
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(5)
                        ),
                      )
                  ),
            ),
          );
        }
        else{
          return SizedBox(
            height: 150,
            child:RawScrollbar(
              thickness: scrollbarthickness,
              thumbColor: scrollbarColor,
              trackColor: Colors.grey,
              trackRadius: Radius.circular(10),
              controller: _controllerOne,
              thumbVisibility: true,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _controllerOne,

                  itemCount: subcategoryList.length,
                  itemBuilder: (context, index) =>
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        height: 150,
                        width: 150,
                        child: GestureDetector(
                          onTap: () {
                            goToNextScreen(index);
                          },
                          child:
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child:
                              subcategoryList[index].subcategoryImageApp!=''?
                              CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: baseUrl+sub_categories_base_url+ subcategoryList[index].subcategoryImageApp,
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
                            ,
                          ),
                        ),
                      )
              ),
            ),
          );
        }
      }
      else if(layoutType=='8'){
        if(subcategoryList.isEmpty){
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex:2,
                      child:
                      Container(
                        margin: EdgeInsets.all(2),
                        color: Colors.grey[100],
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      )
                  ),
                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child:Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                ],
              )
          );
        }
        else{
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex:2,
                      child:
                      SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:
                          subcategoryList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child: Container(
                              margin: EdgeInsets.all(1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child:
                                subcategoryList[0].subcategoryImageApp!=''?
                                CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+sub_categories_base_url+subcategoryList[0].subcategoryImageApp,
                                  placeholder: (context, url) =>
                                      Container(decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: Colors.grey[400],
                                      )),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ):
                                Container(
                                    child:const Icon(Icons.error),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.grey[400],
                                    )),
                              )
                              ,
                            ),
                          ):
                          Container()
                      )
                  ),

                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>1 && subcategoryList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      subcategoryList[1].subcategoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[1].subcategoryImageApp,
                                        placeholder: (context, url) =>
                                            Container(decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ):
                                      Container(
                                          child:const Icon(Icons.error),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.grey[400],
                                          )),
                                    )
                                    ,
                                  ),
                                ):
                                Container()
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>2 && subcategoryList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      subcategoryList[2].subcategoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[2].subcategoryImageApp,
                                        placeholder: (context, url) =>
                                            Container(decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ):
                                      Container(
                                          child:const Icon(Icons.error),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.grey[400],
                                          )),
                                    )
                                    ,
                                  ),
                                ):
                                Container()
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                ],
              )
          );
        }
      }
      else if(layoutType=='9'){
        if(subcategoryList.isEmpty){
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child:Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex:2,
                      child:
                      Container(
                        margin: EdgeInsets.all(2),
                        color: Colors.grey[100],
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      )
                  )
                ],
              )
          );
        }
        else{
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>1 && subcategoryList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      subcategoryList[1].subcategoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[1].subcategoryImageApp,
                                        placeholder: (context, url) =>
                                            Container(decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ):
                                      Container(
                                          child:const Icon(Icons.error),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.grey[400],
                                          )),
                                    )
                                    ,
                                  ),
                                ):
                                Container()
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>2 && subcategoryList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      subcategoryList[2].subcategoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[2].subcategoryImageApp,
                                        placeholder: (context, url) =>
                                            Container(decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ):
                                      Container(
                                          child:const Icon(Icons.error),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.grey[400],
                                          )),
                                    )
                                    ,
                                  ),
                                ):
                                Container()
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex:2,
                      child:
                      SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:
                          subcategoryList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child: Container(
                              margin: EdgeInsets.all(1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child:
                                subcategoryList[0].subcategoryImageApp!=''?
                                CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+sub_categories_base_url+subcategoryList[0].subcategoryImageApp,
                                  placeholder: (context, url) =>
                                      Container(decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: Colors.grey[400],
                                      )),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ):
                                Container(
                                    child:const Icon(Icons.error),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.grey[400],
                                    )),
                              )
                              ,
                            ),
                          ):
                          Container()
                      )
                  ),
                ],
              )
          );
        }
      }
      else if(layoutType=='10'){
        if (subcategoryList.isEmpty) {
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    color: Colors.grey[300],
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    color: Colors.grey[300],
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        )
                      ],
                    ),
                  )

                ],
              ));
        }
        else {
          return SizedBox(
              height: MediaQuery.of(context).size.width*1.2,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    child: SizedBox(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        child:
                                        subcategoryList.length>0 && subcategoryList[0]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(1),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              subcategoryList[0].subcategoryImageApp!=''?
                                              CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+sub_categories_base_url+subcategoryList[0].subcategoryImageApp,
                                                placeholder: (context, url) =>
                                                    Container(decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(100),
                                                      color: Colors.grey[400],
                                                    )),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                              ):
                                              Container(
                                                  child:const Icon(Icons.error),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    color: Colors.grey[400],
                                                  )),
                                            )
                                            ,
                                          ),
                                        ):
                                        Container()
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    child: SizedBox(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        child:
                                        subcategoryList.length>1 && subcategoryList[1]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(1),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              subcategoryList[1].subcategoryImageApp!=''?
                                              CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+sub_categories_base_url+subcategoryList[1].subcategoryImageApp,
                                                placeholder: (context, url) =>
                                                    Container(decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(100),
                                                      color: Colors.grey[400],
                                                    )),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                              ):
                                              Container(
                                                  child:const Icon(Icons.error),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    color: Colors.grey[400],
                                                  )),
                                            )
                                            ,
                                          ),
                                        ):
                                        Container()
                                    ),
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  subcategoryList.length>2 && subcategoryList[2]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        subcategoryList[2].subcategoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+sub_categories_base_url+subcategoryList[2].subcategoryImageApp,
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: Colors.grey[400],
                                              )),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ):
                                        Container(
                                            child:const Icon(Icons.error),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                      )
                                      ,
                                    ),
                                  ):
                                  Container()
                              ),
                            )
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  subcategoryList.length>3 && subcategoryList[3]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        subcategoryList[3].subcategoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+sub_categories_base_url+subcategoryList[3].subcategoryImageApp,
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: Colors.grey[400],
                                              )),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ):
                                        Container(
                                            child:const Icon(Icons.error),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                      )
                                      ,
                                    ),
                                  ):
                                  Container()
                              ),
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  subcategoryList.length>4 && subcategoryList[4]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        subcategoryList[4].subcategoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+sub_categories_base_url+subcategoryList[4].subcategoryImageApp,
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: Colors.grey[400],
                                              )),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ):
                                        Container(
                                            child:const Icon(Icons.error),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                      )
                                      ,
                                    ),
                                  ):
                                  Container()
                              ),
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  subcategoryList.length>5 && subcategoryList[5]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        subcategoryList[5].subcategoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+sub_categories_base_url+subcategoryList[5].subcategoryImageApp,
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: Colors.grey[400],
                                              )),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ):
                                        Container(
                                            child:const Icon(Icons.error),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                      )
                                      ,
                                    ),
                                  ):
                                  Container()
                              ),
                            )
                        )
                      ],
                    ),
                  )

                ],
              ));
        }
      }
      else if(layoutType=='11')
      {
        if(subcategoryList.isEmpty){
          return
            GridView.builder(
              itemCount: getItemsCount(),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: getCrossAxisCount(),
              ),
              itemBuilder: (context, index) =>
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(5)
                    ),
                  ),
            );
        }
        else{
          return GridView.builder(
            itemCount: getItemsCount(),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              crossAxisCount: getCrossAxisCount(),
            ),
            itemBuilder: (context, index) =>
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    onTap: () {
                      goToNextScreen(index);
                    },
                    child:
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child:
                        subcategoryList[index].subcategoryImageApp!=''?
                        CachedNetworkImage(
                          //height: MediaQuery.of(context).size.height,
                          //width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                          imageUrl: baseUrl+sub_categories_base_url+ subcategoryList[index].subcategoryImageApp,
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
                      ,
                    ),
                  ),

                ),
          );
        }
      }
      else{
        if(subcategoryList.isEmpty){
          return
            GridView.builder(
              itemCount: getItemsCount(),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: getCrossAxisCount(),
              ),
              itemBuilder: (context, index) =>
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(5)
                    ),
                  ),
            );
        }
        else{
          return GridView.builder(
            itemCount: getItemsCount(),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              crossAxisCount: getCrossAxisCount(),
            ),
            itemBuilder: (context, index) =>
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    onTap: () {
                      goToNextScreen(index);
                    },
                    child:
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child:
                        subcategoryList[index].subcategoryImageApp!=''?
                        CachedNetworkImage(
                          //height: MediaQuery.of(context).size.height,
                          //width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                          imageUrl: baseUrl+sub_categories_base_url+ subcategoryList[index].subcategoryImageApp,
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
                      ,
                    ),
                  ),

                ),
          );
        }
      }
    }
    else if(iconType=="3"){
      if(layoutType=="6"){
        return SizedBox(
            height: 300,
            child:RawScrollbar(
                thickness: scrollbarthickness,
                thumbColor: scrollbarColor,
                trackColor: Colors.grey,
                trackRadius: Radius.circular(10),
                controller: _controllerOne,
                thumbVisibility: true,
                child: GridView.count(
                    padding: EdgeInsets.zero,
                    controller: _controllerOne,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 1.2/1,
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children:getLayout()
                )

            ));
      }
      else if(layoutType=="7"){
        if(subcategoryList.isEmpty){
          return Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _controllerOne,

                itemCount: subcategoryList.length,
                itemBuilder: (context, index) =>
                    Container(
                      height: 150,
                      width: 120,
                      margin: const EdgeInsets.only(right: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              flex:8,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(5)
                                ),
                              )),
                          Expanded(
                              flex:2,
                              child:
                              Container(
                                height: 15,
                                width: 60,
                                color: Colors.grey[100],
                              ))
                        ],
                      ),
                    )
            ),
          );
        }
        else{
          return SizedBox(
            height: 170,
            child:RawScrollbar(
              thickness: scrollbarthickness,
              thumbColor: scrollbarColor,
              trackColor: Colors.grey,
              trackRadius: Radius.circular(10),
              controller: _controllerOne,
              thumbVisibility: true,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _controllerOne,

                  itemCount: subcategoryList.length,
                  itemBuilder: (context, index) =>
                      GestureDetector(
                        onTap: ()=>{
                          goToNextScreen(index)
                        },
                        child:                     Container(
                          height: 150,
                          width: 120,
                          margin: const EdgeInsets.only(right: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex:8,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child:
                                    subcategoryList[index].subcategoryImageApp!=''?
                                    CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl: baseUrl+sub_categories_base_url+subcategoryList[index].subcategoryImageApp,
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
                                  ,
                                ),
                              ),
                              Expanded(
                                  flex:2,
                                  child: Text(subcategoryList[index].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                              )
                            ],
                          ),
                        ),
                      )
              ),
            ),
          );
        }
      }
      else if(layoutType=='8'){
        if(subcategoryList.isEmpty){
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex:1,
                      child:
                      Container(
                        margin: EdgeInsets.all(2),
                        color: Colors.grey[100],
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      )
                  ),
                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child:Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                ],
              )
          );
        }
        else{
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex:2,
                      child:
                      SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:
                          subcategoryList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              child:Column(
                                children: <Widget>[
                                  Expanded(
                                    flex:18,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        subcategoryList[0].subcategoryImageApp!=''?
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+sub_categories_base_url+subcategoryList[0].subcategoryImageApp,
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.grey[400],
                                              )),
                                        ):
                                        Container(
                                            child:const Icon(Icons.error),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.grey[400],
                                            )),
                                      )
                                      ,
                                    ),
                                  ),
                                  Expanded(
                                      flex:1,
                                      child: Text(subcategoryList[0].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                  )
                                ],
                              ),
                            ),
                          ):
                          Container()
                      )
                  ),

                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>1 && subcategoryList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child:Container(
                                    margin: EdgeInsets.all(2),
                                    child:Column(
                                      children: <Widget>[
                                        Expanded(
                                          flex:10,
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 5),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              subcategoryList[1].subcategoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+sub_categories_base_url+subcategoryList[1].subcategoryImageApp,
                                                placeholder: (context, url) =>
                                                    Container(decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.grey[400],
                                                    )),
                                              ):
                                              Container(
                                                  child:const Icon(Icons.error),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.grey[400],
                                                  )),
                                            )
                                            ,
                                          ),
                                        ),
                                        Expanded(
                                            flex:1,
                                            child: Text(subcategoryList[1].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                        )
                                      ],
                                    ),
                                  ),
                                ):
                                Container()
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>2 && subcategoryList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child:Container(
                                    margin: EdgeInsets.all(2),
                                    child:Column(
                                      children: <Widget>[
                                        Expanded(
                                          flex:10,
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 5),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              subcategoryList[2].subcategoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+sub_categories_base_url+subcategoryList[2].subcategoryImageApp,
                                                placeholder: (context, url) =>
                                                    Container(decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.grey[400],
                                                    )),
                                              ):
                                              Container(
                                                  child:const Icon(Icons.error),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.grey[400],
                                                  )),
                                            )
                                            ,
                                          ),
                                        ),
                                        Expanded(
                                            flex:1,
                                            child: Text(subcategoryList[2].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                        )
                                      ],
                                    ),
                                  ),
                                ):
                                Container()
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                ],
              )
          );
        }
      }
      else if(layoutType=='9'){
        if(subcategoryList.isEmpty){
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child:Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex:1,
                      child:
                      Container(
                        margin: EdgeInsets.all(2),
                        color: Colors.grey[100],
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      )
                  ),
                ],
              )
          );
        }
        else{
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>1 && subcategoryList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child:Container(
                                    margin: EdgeInsets.all(2),
                                    child:Column(
                                      children: <Widget>[
                                        Expanded(
                                          flex:10,
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 5),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              subcategoryList[1].subcategoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+sub_categories_base_url+subcategoryList[1].subcategoryImageApp,
                                                placeholder: (context, url) =>
                                                    Container(decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.grey[400],
                                                    )),
                                              ):
                                              Container(
                                                  child:const Icon(Icons.error),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.grey[400],
                                                  )),
                                            )
                                            ,
                                          ),
                                        ),
                                        Expanded(
                                            flex:1,
                                            child: Text(subcategoryList[1].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                        )
                                      ],
                                    ),
                                  ),
                                ):
                                Container()
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>2 && subcategoryList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child:Container(
                                    margin: EdgeInsets.all(2),
                                    child:Column(
                                      children: <Widget>[
                                        Expanded(
                                          flex:10,
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 5),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              subcategoryList[2].subcategoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+sub_categories_base_url+subcategoryList[2].subcategoryImageApp,
                                                placeholder: (context, url) =>
                                                    Container(decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.grey[400],
                                                    )),
                                              ):
                                              Container(
                                                  child:const Icon(Icons.error),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.grey[400],
                                                  )),
                                            )
                                            ,
                                          ),
                                        ),
                                        Expanded(
                                            flex:1,
                                            child: Text(subcategoryList[2].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                        )
                                      ],
                                    ),
                                  ),
                                ):
                                Container()
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex:2,
                      child:
                      SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:
                          subcategoryList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child:
                            Container(
                              margin: EdgeInsets.all(1),
                              child:Column(
                                children: <Widget>[
                                  Expanded(
                                    flex:18,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        subcategoryList[0].subcategoryImageApp!=''?
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+sub_categories_base_url+subcategoryList[0].subcategoryImageApp,
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.grey[400],
                                              )),
                                        ):
                                        Container(
                                            child:const Icon(Icons.error),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.grey[400],
                                            )),
                                      )
                                      ,
                                    ),
                                  ),
                                  Expanded(
                                      flex:1,
                                      child: Text(subcategoryList[0].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                  )
                                ],
                              ),
                            ),
                          ):
                          Container()
                      )
                  )
                ],
              )
          );
        }
      }
      else if(layoutType=='10'){
        if (subcategoryList.isEmpty) {
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    color: Colors.grey[300],
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    color: Colors.grey[300],
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        )
                      ],
                    ),
                  )

                ],
              ));
        }
        else {
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: SizedBox(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        child:
                                        subcategoryList.length>1 && subcategoryList[0]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child:Container(
                                            margin: EdgeInsets.all(1),
                                            child:Column(
                                              children: <Widget>[
                                                Expanded(
                                                  flex:10,
                                                  child: Container(
                                                    margin: const EdgeInsets.only(bottom: 5),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(0),
                                                      child:
                                                      subcategoryList[0].subcategoryImageApp!=''?
                                                      CachedNetworkImage(
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.fill,
                                                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[0].subcategoryImageApp,
                                                        placeholder: (context, url) =>
                                                            Container(decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              color: Colors.grey[400],
                                                            )),
                                                      ):
                                                      Container(
                                                          child:const Icon(Icons.error),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            color: Colors.grey[400],
                                                          )),
                                                    )
                                                    ,
                                                  ),
                                                ),
                                                Expanded(
                                                    flex:2,
                                                    child: Text(subcategoryList[0].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                                )
                                              ],
                                            ),
                                          ),
                                        ):
                                        Container()
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: SizedBox(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        child:
                                        subcategoryList.length>2 && subcategoryList[1]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child:Container(
                                            margin: EdgeInsets.all(1),
                                            child:Column(
                                              children: <Widget>[
                                                Expanded(
                                                  flex:10,
                                                  child: Container(
                                                    margin: const EdgeInsets.only(bottom: 5),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(0),
                                                      child:
                                                      subcategoryList[1].subcategoryImageApp!=''?
                                                      CachedNetworkImage(
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.fill,
                                                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[1].subcategoryImageApp,
                                                        placeholder: (context, url) =>
                                                            Container(decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              color: Colors.grey[400],
                                                            )),
                                                      ):
                                                      Container(
                                                          child:const Icon(Icons.error),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            color: Colors.grey[400],
                                                          )),
                                                    )
                                                    ,
                                                  ),
                                                ),
                                                Expanded(
                                                    flex:2,
                                                    child: Text(subcategoryList[1].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                                )
                                              ],
                                            ),
                                          ),
                                        ):
                                        Container()
                                    ),
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child:
                              subcategoryList.length>3 && subcategoryList[2]!=null?
                              GestureDetector(
                                onTap: () {
                                  goToNextScreen(1);
                                },
                                child:Container(
                                  margin: EdgeInsets.all(1),
                                  child:Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex:10,
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 5),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(0),
                                            child:
                                            subcategoryList[2].subcategoryImageApp!=''?
                                            CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.fill,
                                              imageUrl: baseUrl+sub_categories_base_url+subcategoryList[2].subcategoryImageApp,
                                              placeholder: (context, url) =>
                                                  Container(decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.grey[400],
                                                  )),
                                            ):
                                            Container(
                                                child:const Icon(Icons.error),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Colors.grey[400],
                                                )),
                                          )
                                          ,
                                        ),
                                      ),
                                      Expanded(
                                          flex:1,
                                          child: Text(subcategoryList[2].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                      )
                                    ],
                                  ),
                                ),
                              ):
                              Container()
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child:
                              subcategoryList.length>4 && subcategoryList[3]!=null?
                              GestureDetector(
                                onTap: () {
                                  goToNextScreen(1);
                                },
                                child:Container(
                                  margin: EdgeInsets.all(1),
                                  child:Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex:10,
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 5),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(0),
                                            child:
                                            subcategoryList[3].subcategoryImageApp!=''?
                                            CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.fill,
                                              imageUrl: baseUrl+sub_categories_base_url+subcategoryList[3].subcategoryImageApp,
                                              placeholder: (context, url) =>
                                                  Container(decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.grey[400],
                                                  )),
                                            ):
                                            Container(
                                                child:const Icon(Icons.error),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Colors.grey[400],
                                                )),
                                          )
                                          ,
                                        ),
                                      ),
                                      Expanded(
                                          flex:2,
                                          child: Text(subcategoryList[3].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                      )
                                    ],
                                  ),
                                ),
                              ):
                              Container()
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(1),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  subcategoryList.length>5 && subcategoryList[4]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child:Container(
                                      margin: EdgeInsets.all(1),
                                      child:Column(
                                        children: <Widget>[
                                          Expanded(
                                            flex:10,
                                            child: Container(
                                              margin: const EdgeInsets.only(bottom: 5),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(0),
                                                child:
                                                subcategoryList[4].subcategoryImageApp!=''?
                                                CachedNetworkImage(
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.fill,
                                                  imageUrl: baseUrl+sub_categories_base_url+subcategoryList[4].subcategoryImageApp,
                                                  placeholder: (context, url) =>
                                                      Container(decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        color: Colors.grey[400],
                                                      )),
                                                ):
                                                Container(
                                                    child:const Icon(Icons.error),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.grey[400],
                                                    )),
                                              )
                                              ,
                                            ),
                                          ),
                                          Expanded(
                                              flex:2,
                                              child: Text(subcategoryList[4].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                          )
                                        ],
                                      ),
                                    ),
                                  ):
                                  Container()
                              ),
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(1),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  subcategoryList.length==6 && subcategoryList[5]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child:Container(
                                      margin: EdgeInsets.all(1),
                                      child:Column(
                                        children: <Widget>[
                                          Expanded(
                                            flex:10,
                                            child: Container(
                                              margin: const EdgeInsets.only(bottom: 5),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(0),
                                                child:
                                                subcategoryList[5].subcategoryImageApp!=''?
                                                CachedNetworkImage(
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.fill,
                                                  imageUrl: baseUrl+sub_categories_base_url+subcategoryList[5].subcategoryImageApp,
                                                  placeholder: (context, url) =>
                                                      Container(decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        color: Colors.grey[400],
                                                      )),
                                                ):
                                                Container(
                                                    child:const Icon(Icons.error),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.grey[400],
                                                    )),
                                              )
                                              ,
                                            ),
                                          ),
                                          Expanded(
                                              flex:2,
                                              child: Text(subcategoryList[5].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                          )
                                        ],
                                      ),
                                    ),
                                  ):
                                  Container()
                              ),
                            )
                        )
                      ],
                    ),
                  )

                ],
              ));
        }
      }
      else{
        if(subcategoryList.isEmpty){
          return
            GridView.builder(
              itemCount: getItemsCount(),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: getCrossAxisCount(),
              ),
              itemBuilder: (context, index) =>
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex:7,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(5)
                              ),
                            )),
                        Expanded(
                            flex:1,
                            child:
                            Container(
                              height: 15,
                              width: 60,
                              color: Colors.grey[100],
                            ))
                      ],
                    ),
                  ),
            );
        }
        else{
          return GridView.builder(
              itemCount: getItemsCount(),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1/1.2,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: getCrossAxisCount(),
              ),
              itemBuilder: (context, index) =>
                  GestureDetector(
                    onTap: ()=>{goToNextScreen(index)},
                    child:  Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.all(3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex:8,
                            child:  Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child:
                                subcategoryList[index].subcategoryImageApp!=''?
                                CachedNetworkImage(
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+sub_categories_base_url+subcategoryList[index].subcategoryImageApp,
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
                              ,
                            ),
                          ),
                          Expanded(
                            flex:2,
                            child: Text(subcategoryList[index].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                    ),
                  )
          );
        }
      }
    }
    else if(iconType=="4"){
      if(layoutType=="6"){
        return SizedBox(
            height: 300,
            child:RawScrollbar(
              thickness: scrollbarthickness,
              thumbColor: scrollbarColor,
              trackColor: Colors.grey,
              trackRadius: Radius.circular(10),
              controller: _controllerOne,
              thumbVisibility: true,
              child: GridView.count(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  controller: _controllerOne,
                  crossAxisCount: 2,
                  childAspectRatio: 1.3/1,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children:getLayout()
              ),
            ));
      }
      else if(layoutType=="7"){
        if(subcategoryList.isEmpty){
          return Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _controllerOne,

              itemCount: 4,
              itemBuilder: (context, index) =>
                  Container(
                    margin: const EdgeInsets.only(right: 5),
                    height: 150,
                    width: 130,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(5)
                    ),
                  ),
            ),
          );
        }
        else{return SizedBox(
          height: 150,
          child:RawScrollbar(
            thickness: scrollbarthickness,
            thumbColor: scrollbarColor,
            trackColor: Colors.grey,
            trackRadius: Radius.circular(10),
            controller: _controllerOne,
            thumbVisibility: true,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _controllerOne,

                itemCount: subcategoryList.length,
                itemBuilder: (context, index) =>
                    Container(
                      margin: const EdgeInsets.all(2),
                      height: 150,
                      width: 130,
                      child: GestureDetector(
                        onTap: () {
                          goToNextScreen(index);
                        },
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child:
                            subcategoryList[index].subcategoryImageApp!=''?
                            CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: baseUrl+sub_categories_base_url+ subcategoryList[index].subcategoryImageApp,
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
                          ),
                        ),
                      ),
                    )
            ),
          ),
        );
        }
      }
      else if(layoutType=='8'){
        if(subcategoryList.isEmpty){
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex:2,
                      child:
                      Container(
                        margin: EdgeInsets.all(2),
                        color: Colors.grey[100],
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      )
                  ),
                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child:Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                ],
              )
          );
        }
        else{
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex:2,
                      child:
                      SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:
                          subcategoryList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child: Container(
                              margin: EdgeInsets.all(1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child:
                                subcategoryList[0].subcategoryImageApp!=''?
                                CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+sub_categories_base_url+subcategoryList[0].subcategoryImageApp,
                                  placeholder: (context, url) =>
                                      Container(decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: Colors.grey[400],
                                      )),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ):
                                Container(
                                    child:const Icon(Icons.error),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.grey[400],
                                    )),
                              )
                              ,
                            ),
                          ):
                          Container()
                      )
                  ),

                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>1 && subcategoryList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      subcategoryList[1].subcategoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[1].subcategoryImageApp,
                                        placeholder: (context, url) =>
                                            Container(decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ):
                                      Container(
                                          child:const Icon(Icons.error),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.grey[400],
                                          )),
                                    )
                                    ,
                                  ),
                                ):
                                Container()
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>2 && subcategoryList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      subcategoryList[2].subcategoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[2].subcategoryImageApp,
                                        placeholder: (context, url) =>
                                            Container(decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ):
                                      Container(
                                          child:const Icon(Icons.error),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.grey[400],
                                          )),
                                    )
                                    ,
                                  ),
                                ):
                                Container()
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                ],
              )
          );
        }
      }
      else if(layoutType=='9'){
        if(subcategoryList.isEmpty){
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child:Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex:1,
                      child:
                      Container(
                        margin: EdgeInsets.all(2),
                        color: Colors.grey[100],
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      )
                  )
                ],
              )
          );
        }
        else{
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>1 && subcategoryList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      subcategoryList[1].subcategoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[1].subcategoryImageApp,
                                        placeholder: (context, url) =>
                                            Container(decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ):
                                      Container(
                                          child:const Icon(Icons.error),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.grey[400],
                                          )),
                                    )
                                    ,
                                  ),
                                ):
                                Container()
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>2 && subcategoryList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      subcategoryList[2].subcategoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[2].subcategoryImageApp,
                                        placeholder: (context, url) =>
                                            Container(decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ):
                                      Container(
                                          child:const Icon(Icons.error),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.grey[400],
                                          )),
                                    )
                                    ,
                                  ),
                                ):
                                Container()
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex:2,
                      child:
                      SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:
                          subcategoryList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child: Container(
                              margin: EdgeInsets.all(1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child:
                                subcategoryList[0].subcategoryImageApp!=''?
                                CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+sub_categories_base_url+subcategoryList[0].subcategoryImageApp,
                                  placeholder: (context, url) =>
                                      Container(decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: Colors.grey[400],
                                      )),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ):
                                Container(
                                    child:const Icon(Icons.error),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.grey[400],
                                    )),
                              )
                              ,
                            ),
                          ):
                          Container()
                      )
                  )
                ],
              )
          );
        }
      }
      else if(layoutType=='10'){
        if (subcategoryList.isEmpty) {
          return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.all(2),
                                    color: Colors.grey[300],
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.all(2),
                                    color: Colors.grey[300],
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child:
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        )
                      ],
                    ),
                  )

                ],
              ));
        }
        else {
          return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    child: SizedBox(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        child:
                                        subcategoryList.length>1 && subcategoryList[0]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(1),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              subcategoryList[0].subcategoryImageApp!=''?
                                              CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+sub_categories_base_url+subcategoryList[0].subcategoryImageApp,
                                                placeholder: (context, url) =>
                                                    Container(decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(100),
                                                      color: Colors.grey[400],
                                                    )),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                              ):
                                              Container(
                                                  child:const Icon(Icons.error),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    color: Colors.grey[400],
                                                  )),
                                            )
                                            ,
                                          ),
                                        ):
                                        Container()
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    child: SizedBox(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        child:
                                        subcategoryList.length>2 && subcategoryList[1]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(1),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              subcategoryList[1].subcategoryImageApp!=''?
                                              CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+sub_categories_base_url+subcategoryList[1].subcategoryImageApp,
                                                placeholder: (context, url) =>
                                                    Container(decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(100),
                                                      color: Colors.grey[400],
                                                    )),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                              ):
                                              Container(
                                                  child:const Icon(Icons.error),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    color: Colors.grey[400],
                                                  )),
                                            )
                                            ,
                                          ),
                                        ):
                                        Container()
                                    ),
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  subcategoryList.length>3 && subcategoryList[2]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        subcategoryList[2].subcategoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+sub_categories_base_url+subcategoryList[2].subcategoryImageApp,
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: Colors.grey[400],
                                              )),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ):
                                        Container(
                                            child:const Icon(Icons.error),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                      )
                                      ,
                                    ),
                                  ):
                                  Container()
                              ),
                            )
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  subcategoryList.length>4 && subcategoryList[3]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        subcategoryList[3].subcategoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+sub_categories_base_url+subcategoryList[3].subcategoryImageApp,
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: Colors.grey[400],
                                              )),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ):
                                        Container(
                                            child:const Icon(Icons.error),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                      )
                                      ,
                                    ),
                                  ):
                                  Container()
                              ),
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  subcategoryList.length>5 && subcategoryList[4]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        subcategoryList[4].subcategoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+sub_categories_base_url+subcategoryList[4].subcategoryImageApp,
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: Colors.grey[400],
                                              )),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ):
                                        Container(
                                            child:const Icon(Icons.error),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                      )
                                      ,
                                    ),
                                  ):
                                  Container()
                              ),
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  subcategoryList.length==6 && subcategoryList[5]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        subcategoryList[5].subcategoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+sub_categories_base_url+subcategoryList[5].subcategoryImageApp,
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: Colors.grey[400],
                                              )),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ):
                                        Container(
                                            child:const Icon(Icons.error),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey[400],
                                            )),
                                      )
                                      ,
                                    ),
                                  ):
                                  Container()
                              ),
                            )
                        )
                      ],
                    ),
                  )

                ],
              ));
        }
      }
      else if(layoutType=='11')
      {
        if(subcategoryList.isEmpty){
          return
            GridView.builder(
              itemCount: getItemsCount(),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: getCrossAxisCount(),
              ),
              itemBuilder: (context, index) =>
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(5)
                    ),
                  ),
            );
        }
        else{
          return GridView.builder(
            itemCount: getItemsCount(),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: getCrossAxisCount(),
                childAspectRatio: 0.8
            ),
            itemBuilder: (context, index) =>
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    onTap: () {
                      goToNextScreen(index);
                    },
                    child:
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child:
                        subcategoryList[index].subcategoryImageApp!=''?
                        CachedNetworkImage(
                          //height: MediaQuery.of(context).size.height,
                          //width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                          imageUrl: baseUrl+sub_categories_base_url+ subcategoryList[index].subcategoryImageApp,
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
                      ,
                    ),
                  ),

                ),
          );
        }
      }
      else{
        if(subcategoryList.isEmpty){
          return GridView.builder(
            itemCount: getItemsCount(),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 1/1.3,
              crossAxisCount: getCrossAxisCount(),
            ),
            itemBuilder: (context, index) =>
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5)
                  ),
                ),
          );
        }
        else{
          return GridView.builder(
            itemCount: getItemsCount(),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1/1.3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              crossAxisCount: getCrossAxisCount(),
            ),
            itemBuilder: (context, index) =>
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    onTap: () {
                      goToNextScreen(index);
                    },
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child:
                        subcategoryList[index].subcategoryImageApp!=''?
                        CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: baseUrl+sub_categories_base_url+ subcategoryList[index].subcategoryImageApp,
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
                      ,
                    ),
                  ),

                ),
          );
        }
      }
    }
    else {
      if(layoutType=="6"){
        return Container(
            alignment: Alignment.centerLeft,
            height: 350,
            child:RawScrollbar(
              thickness: scrollbarthickness,
              thumbColor: scrollbarColor,
              trackColor: Colors.grey,
              trackRadius: Radius.circular(10),
              controller: _controllerOne,
              thumbVisibility: true,
              child: GridView.count(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 1.3/1,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: _controllerOne,

                  children:getLayout()
              ),
            ));
      }
      else if(layoutType=="7"){
        if(subcategoryList.isEmpty){
          return Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _controllerOne,

                itemCount: subcategoryList.length,
                itemBuilder: (context, index) =>
                    Container(
                      height: 150,
                      width: 120,
                      margin: const EdgeInsets.only(right: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              flex:8,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(5)
                                ),
                              )),
                          Expanded(
                              flex:2,
                              child:
                              Container(
                                height: 15,
                                width: 60,
                                color: Colors.grey[100],
                              ))
                        ],
                      ),
                    )
            ),
          );
        }
        else{
          return SizedBox(
            height: 170,
            child:RawScrollbar(
                thickness: scrollbarthickness,
                thumbColor: scrollbarColor,
                trackColor: Colors.grey,
                trackRadius: Radius.circular(10),
                controller: _controllerOne,
                thumbVisibility: true,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _controllerOne,

                    itemCount: subcategoryList.length,
                    itemBuilder: (context, index) =>
                        GestureDetector(
                          onTap: ()=>{
                            goToNextScreen(index)
                          },
                          child: Container(
                            height: 180,
                            width: 120,
                            margin: const EdgeInsets.only(right: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex:8,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child:
                                      subcategoryList[index].subcategoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[index].subcategoryImageApp,
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
                                    ,
                                  ),
                                ),
                                Expanded(
                                    flex:2,
                                    child: Text(subcategoryList[index].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                )
                              ],
                            ),
                          ),
                        )
                )
            ),
          );
        }
      }
      else if(layoutType=='8'){
        if(subcategoryList.isEmpty){
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex:1,
                      child:
                      Container(
                        margin: EdgeInsets.all(2),
                        color: Colors.grey[100],
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      )
                  ),
                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child:Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                ],
              )
          );
        }
        else{
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex:1,
                      child:
                      SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:
                          subcategoryList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child:
                            Container(
                              margin: EdgeInsets.all(1),
                              child:Column(
                                children: <Widget>[
                                  Expanded(
                                    flex:18,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        subcategoryList[0].subcategoryImageApp!=''?
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+sub_categories_base_url+subcategoryList[0].subcategoryImageApp,
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.grey[400],
                                              )),
                                        ):
                                        Container(
                                            child:const Icon(Icons.error),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.grey[400],
                                            )),
                                      )
                                      ,
                                    ),
                                  ),
                                  Expanded(
                                      flex:1,
                                      child: Text(subcategoryList[0].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                  )
                                ],
                              ),
                            ),
                          ):
                          Container()
                      )
                  ),

                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>1 && subcategoryList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child:Container(
                                    margin: EdgeInsets.all(1),
                                    child:Column(
                                      children: <Widget>[
                                        Expanded(
                                          flex:10,
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 5),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              subcategoryList[1].subcategoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+sub_categories_base_url+subcategoryList[1].subcategoryImageApp,
                                                placeholder: (context, url) =>
                                                    Container(decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.grey[400],
                                                    )),
                                              ):
                                              Container(
                                                  child:const Icon(Icons.error),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.grey[400],
                                                  )),
                                            )
                                            ,
                                          ),
                                        ),
                                        Expanded(
                                            flex:1,
                                            child: Text(subcategoryList[0].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                        )
                                      ],
                                    ),
                                  ),
                                ):
                                Container()
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>2 && subcategoryList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child:Container(
                                    margin: EdgeInsets.all(1),
                                    child:Column(
                                      children: <Widget>[
                                        Expanded(
                                          flex:10,
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 5),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              subcategoryList[2].subcategoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+sub_categories_base_url+subcategoryList[2].subcategoryImageApp,
                                                placeholder: (context, url) =>
                                                    Container(decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.grey[400],
                                                    )),
                                              ):
                                              Container(
                                                  child:const Icon(Icons.error),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.grey[400],
                                                  )),
                                            )
                                            ,
                                          ),
                                        ),
                                        Expanded(
                                            flex:1,
                                            child: Text(subcategoryList[0].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                        )
                                      ],
                                    ),
                                  ),
                                ):
                                Container()
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                ],
              )
          );
        }
      }
      else if(layoutType=='9'){
        if(subcategoryList.isEmpty){
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child:Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[100],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex:1,
                      child:
                      Container(
                        margin: EdgeInsets.all(2),
                        color: Colors.grey[100],
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      )
                  ),
                ],
              )
          );
        }
        else{
          return SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>1 && subcategoryList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child:Container(
                                    margin: EdgeInsets.all(1),
                                    child:Column(
                                      children: <Widget>[
                                        Expanded(
                                          flex:10,
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 5),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              subcategoryList[1].subcategoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+sub_categories_base_url+subcategoryList[1].subcategoryImageApp,
                                                placeholder: (context, url) =>
                                                    Container(decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.grey[400],
                                                    )),
                                              ):
                                              Container(
                                                  child:const Icon(Icons.error),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.grey[400],
                                                  )),
                                            )
                                            ,
                                          ),
                                        ),
                                        Expanded(
                                            flex:1,
                                            child: Text(subcategoryList[0].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                        )
                                      ],
                                    ),
                                  ),
                                ):
                                Container()
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child:
                                subcategoryList.length>2 && subcategoryList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child:Container(
                                    margin: EdgeInsets.all(1),
                                    child:Column(
                                      children: <Widget>[
                                        Expanded(
                                          flex:10,
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 5),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              subcategoryList[2].subcategoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+sub_categories_base_url+subcategoryList[2].subcategoryImageApp,
                                                placeholder: (context, url) =>
                                                    Container(decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.grey[400],
                                                    )),
                                              ):
                                              Container(
                                                  child:const Icon(Icons.error),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.grey[400],
                                                  )),
                                            )
                                            ,
                                          ),
                                        ),
                                        Expanded(
                                            flex:1,
                                            child: Text(subcategoryList[0].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                        )
                                      ],
                                    ),
                                  ),
                                ):
                                Container()
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex:1,
                      child:
                      SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:
                          subcategoryList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child:
                            Container(
                              margin: EdgeInsets.all(1),
                              child:Column(
                                children: <Widget>[
                                  Expanded(
                                    flex:18,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        subcategoryList[0].subcategoryImageApp!=''?
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+sub_categories_base_url+subcategoryList[0].subcategoryImageApp,
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.grey[400],
                                              )),
                                        ):
                                        Container(
                                            child:const Icon(Icons.error),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.grey[400],
                                            )),
                                      )
                                      ,
                                    ),
                                  ),
                                  Expanded(
                                      flex:1,
                                      child: Text(subcategoryList[0].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                  )
                                ],
                              ),
                            ),
                          ):
                          Container()
                      )
                  )
                ],
              )
          );
        }
      }
      else if(layoutType=='10'){
        if (subcategoryList.isEmpty) {
          return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    color: Colors.grey[300],
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    color: Colors.grey[300],
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(2),
                              color: Colors.grey[300],
                            )
                        )
                      ],
                    ),
                  )

                ],
              ));
        }
        else {
          return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: SizedBox(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        child:
                                        subcategoryList.length>1 && subcategoryList[0]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child:Container(
                                            margin: EdgeInsets.all(1),
                                            child:Column(
                                              children: <Widget>[
                                                Expanded(
                                                  flex:10,
                                                  child: Container(
                                                    margin: const EdgeInsets.only(bottom: 5),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(0),
                                                      child:
                                                      subcategoryList[0].subcategoryImageApp!=''?
                                                      CachedNetworkImage(
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.fill,
                                                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[0].subcategoryImageApp,
                                                        placeholder: (context, url) =>
                                                            Container(decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              color: Colors.grey[400],
                                                            )),
                                                      ):
                                                      Container(
                                                          child:const Icon(Icons.error),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            color: Colors.grey[400],
                                                          )),
                                                    )
                                                    ,
                                                  ),
                                                ),
                                                Expanded(
                                                    flex:2,
                                                    child: Text(subcategoryList[0].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                                )
                                              ],
                                            ),
                                          ),
                                        ):
                                        Container()
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: SizedBox(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        child:
                                        subcategoryList.length>2 && subcategoryList[1]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child:Container(
                                            margin: EdgeInsets.all(1),
                                            child:Column(
                                              children: <Widget>[
                                                Expanded(
                                                  flex:10,
                                                  child: Container(
                                                    margin: const EdgeInsets.only(bottom: 5),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(0),
                                                      child:
                                                      subcategoryList[1].subcategoryImageApp!=''?
                                                      CachedNetworkImage(
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.fill,
                                                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[1].subcategoryImageApp,
                                                        placeholder: (context, url) =>
                                                            Container(decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              color: Colors.grey[400],
                                                            )),
                                                      ):
                                                      Container(
                                                          child:const Icon(Icons.error),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            color: Colors.grey[400],
                                                          )),
                                                    )
                                                    ,
                                                  ),
                                                ),
                                                Expanded(
                                                    flex:2,
                                                    child: Text(subcategoryList[1].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                                )
                                              ],
                                            ),
                                          ),
                                        ):
                                        Container()
                                    ),
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child:
                              subcategoryList.length>3 && subcategoryList[2]!=null?
                              GestureDetector(
                                onTap: () {
                                  goToNextScreen(1);
                                },
                                child:Container(
                                  margin: EdgeInsets.all(1),
                                  child:Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex:10,
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 5),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(0),
                                            child:
                                            subcategoryList[2].subcategoryImageApp!=''?
                                            CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.fill,
                                              imageUrl: baseUrl+sub_categories_base_url+subcategoryList[2].subcategoryImageApp,
                                              placeholder: (context, url) =>
                                                  Container(decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.grey[400],
                                                  )),
                                            ):
                                            Container(
                                                child:const Icon(Icons.error),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Colors.grey[400],
                                                )),
                                          )
                                          ,
                                        ),
                                      ),
                                      Expanded(
                                          flex:1,
                                          child: Text(subcategoryList[2].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                      )
                                    ],
                                  ),
                                ),
                              ):
                              Container()
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child:
                              subcategoryList.length>4 && subcategoryList[3]!=null?
                              GestureDetector(
                                onTap: () {
                                  goToNextScreen(1);
                                },
                                child:Container(
                                  margin: EdgeInsets.all(1),
                                  child:Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex:10,
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 5),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(0),
                                            child:
                                            subcategoryList[3].subcategoryImageApp!=''?
                                            CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.fill,
                                              imageUrl: baseUrl+sub_categories_base_url+subcategoryList[3].subcategoryImageApp,
                                              placeholder: (context, url) =>
                                                  Container(decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.grey[400],
                                                  )),
                                            ):
                                            Container(
                                                child:const Icon(Icons.error),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Colors.grey[400],
                                                )),
                                          )
                                          ,
                                        ),
                                      ),
                                      Expanded(
                                          flex:2,
                                          child: Text(subcategoryList[3].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                      )
                                    ],
                                  ),
                                ),
                              ):
                              Container()
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(1),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  subcategoryList.length>5 && subcategoryList[4]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child:Container(
                                      margin: EdgeInsets.all(1),
                                      child:Column(
                                        children: <Widget>[
                                          Expanded(
                                            flex:10,
                                            child: Container(
                                              margin: const EdgeInsets.only(bottom: 5),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(0),
                                                child:
                                                subcategoryList[4].subcategoryImageApp!=''?
                                                CachedNetworkImage(
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.fill,
                                                  imageUrl: baseUrl+sub_categories_base_url+subcategoryList[4].subcategoryImageApp,
                                                  placeholder: (context, url) =>
                                                      Container(decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        color: Colors.grey[400],
                                                      )),
                                                ):
                                                Container(
                                                    child:const Icon(Icons.error),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.grey[400],
                                                    )),
                                              )
                                              ,
                                            ),
                                          ),
                                          Expanded(
                                              flex:2,
                                              child: Text(subcategoryList[4].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                          )
                                        ],
                                      ),
                                    ),
                                  ):
                                  Container()
                              ),
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child:
                            Container(
                              margin: EdgeInsets.all(1),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  subcategoryList.length==6 && subcategoryList[5]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child:Container(
                                      margin: EdgeInsets.all(1),
                                      child:Column(
                                        children: <Widget>[
                                          Expanded(
                                            flex:10,
                                            child: Container(
                                              margin: const EdgeInsets.only(bottom: 5),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(0),
                                                child:
                                                subcategoryList[5].subcategoryImageApp!=''?
                                                CachedNetworkImage(
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.fill,
                                                  imageUrl: baseUrl+sub_categories_base_url+subcategoryList[5].subcategoryImageApp,
                                                  placeholder: (context, url) =>
                                                      Container(decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        color: Colors.grey[400],
                                                      )),
                                                ):
                                                Container(
                                                    child:const Icon(Icons.error),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.grey[400],
                                                    )),
                                              )
                                              ,
                                            ),
                                          ),
                                          Expanded(
                                              flex:2,
                                              child: Text(subcategoryList[5].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                                          )
                                        ],
                                      ),
                                    ),
                                  ):
                                  Container()
                              ),
                            )
                        )
                      ],
                    ),
                  )

                ],
              ));
        }
      }
      else{
        if(subcategoryList.isEmpty){
          return
            GridView.builder(
              itemCount: getItemsCount(),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 1/1.5,
                crossAxisCount: getCrossAxisCount(),
              ),
              itemBuilder: (context, index) =>
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex:7,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(5)
                              ),
                            )),
                        Expanded(
                            flex:1,
                            child:
                            Container(
                              height: 15,
                              width: 60,
                              color: Colors.grey[100],
                            ))
                      ],
                    ),
                  ),
            );
        }
        else{
          return GridView.builder(
              itemCount: getItemsCount(),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1/1.6,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: getCrossAxisCount(),
              ),
              itemBuilder: (context, index) =>
                  GestureDetector(
                    onTap: ()=>{goToNextScreen(index)},
                    child:  Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.all(3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex:8,
                            child:  Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child:
                                subcategoryList[index].subcategoryImageApp!=''?
                                CachedNetworkImage(
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+sub_categories_base_url+subcategoryList[index].subcategoryImageApp,
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
                              ,
                            ),
                          ),
                          Expanded(
                            flex:1,
                            child: Text(subcategoryList[index].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                    ),
                  )
          );
        }
      }
    }
  }

  getLayout(){
    List<Widget> widgetList=[];

    if(subcategoryList.isEmpty){
      for(int i=0;i<12;i++){
        if(iconType=="0"){
          widgetList.add(
              Container(
                height: 100,
                width: 100,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(100),
                ),
              )
          );
        }
        else if(iconType=="1"){
          widgetList.add(
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    Container(height: 15,width:60,color: Colors.grey[100],)
                  ],
                ),
              ));
        }
        else if(iconType=="2"){
          widgetList.add(
              Container(
                height: 100,
                width: 100,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              )
          );
        }
        else if(iconType=="3"){
          widgetList.add(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Container(height: 15,width:60,color: Colors.grey[100],)
                ],
              )
          );
        }
        else if(iconType=="4"){
          widgetList.add(
              Container(
                height: 150,
                width: 100,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              )
          );
        }
        else{
          widgetList.add(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Container(height: 15,width:60,color: Colors.grey[100],)
                ],
              )
          );
        }
      }
    }

    else{
      for(int index=0;index<subcategoryList.length;index++){
        if(iconType=="0"){
          widgetList.add(
              Container(
                margin: const EdgeInsets.all(2),
                child: GestureDetector(
                  onTap: () {
                    goToNextScreen(index);
                  },
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child:
                      subcategoryList[index].subcategoryImageApp!=''?
                      CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: baseUrl+sub_categories_base_url+subcategoryList[index].subcategoryImageApp,
                        placeholder: (context, url) =>
                            Container(decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey[400],
                            )),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ):
                      Container(
                          child:const Icon(Icons.error),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey[400],
                          )),
                    ),
                  ),
                ),

              )
          );
        }
        else if(iconType=="1"){
          widgetList.add(SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
                onTap: () {
                  goToNextScreen(index);
                },
                child: Container(
                  margin: const EdgeInsets.all(3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex:8,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(bottom: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child:
                            subcategoryList[index].subcategoryImageApp!=''?
                            CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: baseUrl+sub_categories_base_url+subcategoryList[index].subcategoryImageApp,
                              placeholder: (context, url) =>
                                  Container(decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[400],
                                  )),
                            ):
                            Container(
                                child:const Icon(Icons.error),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey[400],
                                )),
                          )
                          ,
                        ),
                      ),
                      Expanded(
                        flex:1,
                        child: Text(subcategoryList[index].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,),
                      ),
                    ],
                  ),
                )
            ),

          ));
        }
        else if(iconType=="2"){
          widgetList.add(Container(
            child: GestureDetector(
                onTap: () {
                  goToNextScreen(index);
                },
                child:
                Container(
                  margin: EdgeInsets.all(3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child:
                    subcategoryList[index].subcategoryImageApp!=''?
                    CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: baseUrl+sub_categories_base_url+ subcategoryList[index].subcategoryImageApp,
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
                  ,
                )
            ),

          ));
        }
        else if(iconType=="3"){
          widgetList.add(
              GestureDetector(
                onTap: () {
                  goToNextScreen(index);
                },
                child: Container(
                  margin: const EdgeInsets.all(3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex:8,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child:
                            subcategoryList[index].subcategoryImageApp!=''?
                            CachedNetworkImage(
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill,
                              imageUrl: baseUrl+sub_categories_base_url+subcategoryList[index].subcategoryImageApp,
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
                          ,
                        ),
                      ),
                      Expanded(
                          flex:2,
                          child: Text(subcategoryList[index].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                      )
                    ],
                  ),
                ),
              )
          );
        }
        else if(iconType=="4"){
          widgetList.add(
              Container(
                child: GestureDetector(
                  onTap: () {
                    goToNextScreen(index);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    height: 150,
                    width: 130,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child:
                      subcategoryList[index].subcategoryImageApp!=''?
                      CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: baseUrl+sub_categories_base_url+ subcategoryList[index].subcategoryImageApp,
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
                    ,
                  ),
                ),
              ));
        }
        else if(iconType=="5"){
          widgetList.add(
              GestureDetector(
                onTap: () {
                  goToNextScreen(index);
                },
                child: Container(
                  margin: const EdgeInsets.all(3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex:9,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child:
                            subcategoryList[index].subcategoryImageApp!=''?
                            CachedNetworkImage(
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill,
                              imageUrl: baseUrl+sub_categories_base_url+subcategoryList[index].subcategoryImageApp,
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
                          ,
                        ),
                      ),
                      Expanded(
                          flex:1,
                          child: Text(subcategoryList[index].subCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                      )
                    ],
                  ),
                ),
              )
          );
        }
      }
    }
    return widgetList;
  }
}
