import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
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

  bool isUiAvailable=false;
  Color scrollbarColor=Colors.pinkAccent;
  final ScrollController _controllerOne = ScrollController();
  double scrollbarthickness=2;

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

  int getItemsCount(){
    if(layoutType=="0" && (mainCategoryList.length>=4|| mainCategoryList.isEmpty)){
      return 4;
    }
    else if(layoutType=="1" && (mainCategoryList.length>=6 || mainCategoryList.isEmpty)){
      return 6;
    }
    else if(layoutType=="2" && (mainCategoryList.length>=8 || mainCategoryList.isEmpty)){
      return 8;
    }
    else if(layoutType=="3" && (mainCategoryList.length>=9 || mainCategoryList.isEmpty)){
      return 9;
    }
    else if(layoutType=="4" && (mainCategoryList.length>=16 || mainCategoryList.isEmpty)){
      return 16;
    }
    else if(layoutType=="5" && (mainCategoryList.length>=6 || mainCategoryList.isEmpty)){
      return 6;
    }
    else if(layoutType=="6" && (mainCategoryList.length>=12 || mainCategoryList.isEmpty)){
      return 12;
    }
    else if(layoutType=="7" || layoutType=='11'){
      if(mainCategoryList.isEmpty){
        return 6;
      }
      else{
        mainCategoryList.length;
      }
    }

    return mainCategoryList.length;
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
      mainCategoryList.length;
    }
    else if(layoutType=="11"){
      return 1;
    }
    return 1;
  }

  goToMainCategoryScreen(Content mainCategoryList){
    // Navigator.push(context, MaterialPageRoute(builder: (context) =>
    //     MainCategoryScreen(mainCategoryList.maincategoryAutoId,mainCategoryList.mainCategoryName)));
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context) => Add_Vendor(main_cat_id:mainCategoryList.maincategoryAutoId, main_cat_name: mainCategoryList.mainCategoryName)));

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

          // Container(
          //     child:
          //     isApiCallProcessing==true?
          //     SizedBox(
          //       height: 80,
          //       child: ListView.builder(
          //           scrollDirection: Axis.horizontal,
          //           itemCount: 5,
          //           itemBuilder: (context, index) =>
          //               Container(
          //                 height: 70,
          //                 width: 70,
          //                 color: Colors.grey[100],
          //                 margin: EdgeInsets.all(5),)
          //       ),
          //     ):
          //     isApiCallProcessing==false && mainCategoryList.isEmpty?
          //     SizedBox(
          //       height: 80,
          //       child: ListView.builder(
          //           scrollDirection: Axis.horizontal,
          //           itemCount: 5,
          //           itemBuilder: (context, index) =>
          //               Container(
          //                 height: 70,
          //                 width: 70,
          //                 color: Colors.grey[100],
          //                 margin: EdgeInsets.all(5),)
          //       ),
          //     ):
          //     Container(
          //       //padding: const EdgeInsets.only(left: 2.0,top:2.0,bottom: 2.0,right: 2.0),
          //         child:
          //         iconType=='0'?
          //         SizedBox(
          //           height: 30,
          //           child: ListView.builder(
          //               scrollDirection: Axis.horizontal,
          //               itemCount: mainCategoryList.length,
          //               itemBuilder: (context, index) =>
          //                   CategoryCard1(
          //                     getmainCategorylist: mainCategoryList[index],
          //                     mainCategory_auto_id: widget.mainCategory_auto_id,
          //                     text: mainCategoryList[index].mainCategoryName,
          //                     textStyle: labelStyle,
          //                     press: () => {
          //                       goToMainCategoryScreen(mainCategoryList[index])
          //                     },
          //                     longpressed: () => {
          //
          //                     },
          //                   )
          //           ),
          //         ):
          //         iconType=='1'?
          //         SizedBox(
          //           height: 88,
          //           child: ListView.builder(
          //               scrollDirection: Axis.horizontal,
          //               itemCount: mainCategoryList.length,
          //               itemBuilder: (context, index) =>
          //                   CategoryCard2(
          //                     getmainCategorylist: mainCategoryList[index],
          //                     mainCategory_auto_id: widget.mainCategory_auto_id,
          //                     icon: mainCategoryList[index].categoryImageApp,
          //                     text: mainCategoryList[index].mainCategoryName,
          //                     baseUrl: baseUrl,
          //                     press: () => {
          //                       goToMainCategoryScreen(mainCategoryList[index])
          //                     },
          //                     longpressed: () => {
          //
          //                     },
          //                   )
          //           ),
          //         ):
          //         iconType=='2'?
          //         SizedBox(
          //           height: widget.mainCategory_auto_id!=''?100: 98,
          //           child: ListView.builder(
          //               scrollDirection: Axis.horizontal,
          //               itemCount: mainCategoryList.length,
          //               itemBuilder: (context, index) =>
          //                   CategoryCard3(
          //                     getmainCategorylist: mainCategoryList[index],
          //                     mainCategory_auto_id: widget.mainCategory_auto_id,
          //                     icon: mainCategoryList[index].categoryImageApp,
          //                     text: mainCategoryList[index].mainCategoryName,
          //                     baseUrl: baseUrl,
          //                     textStyle: labelStyle,
          //                     press: () => {
          //                       goToMainCategoryScreen(mainCategoryList[index])
          //                     },
          //                     longpressed: () => {
          //                     },
          //                   )
          //           ),
          //         ):
          //         iconType=='3'?
          //         SizedBox(
          //           height: widget.mainCategory_auto_id!=''?85: 80,
          //           child: ListView.builder(
          //               scrollDirection: Axis.horizontal,
          //               itemCount: mainCategoryList.length,
          //               itemBuilder: (context, index) =>
          //                   CategoryCard4(
          //                     getmainCategorylist: mainCategoryList[index],
          //                     mainCategory_auto_id: widget.mainCategory_auto_id,
          //                     icon: mainCategoryList[index].categoryImageApp,
          //                     baseUrl: baseUrl,
          //                     text: mainCategoryList[index].mainCategoryName,
          //                     press: () => {
          //                       goToMainCategoryScreen(mainCategoryList[index]),
          //                     },
          //                     longpressed: () => {
          //
          //                     },
          //                   )
          //           ),
          //         ):
          //         iconType=='4'?
          //         SizedBox(
          //           height: 100,
          //           child: ListView.builder(
          //               scrollDirection: Axis.horizontal,
          //               itemCount: mainCategoryList.length,
          //               itemBuilder: (context, index) =>
          //                   CategoryCard5(
          //                     getmainCategorylist: mainCategoryList[index],
          //                     mainCategory_auto_id: widget.mainCategory_auto_id,
          //                     icon: mainCategoryList[index].categoryImageApp,
          //                     baseUrl: baseUrl,
          //                     text: mainCategoryList[index].mainCategoryName,
          //                     textStyle: labelStyle,
          //                     press: () => {
          //                       goToMainCategoryScreen(mainCategoryList[index])
          //                     },
          //                     longpressed: () => {
          //
          //                     },
          //                   )
          //           ),
          //         ):
          //         SizedBox(
          //           height: widget.mainCategory_auto_id!=''?95:90,
          //           child: ListView.builder(
          //               scrollDirection: Axis.horizontal,
          //               itemCount: mainCategoryList.length,
          //               itemBuilder: (context, index) =>
          //                   CategoryCard6(
          //                     getmainCategorylist: mainCategoryList[index],
          //                     mainCategory_auto_id: widget.mainCategory_auto_id,
          //                     icon: mainCategoryList[index].categoryImageApp,
          //                     baseUrl: baseUrl,
          //                     text: mainCategoryList[index].mainCategoryName,
          //                     press: () => {
          //                       goToMainCategoryScreen(mainCategoryList[index])
          //                     },
          //                     longpressed: () => {
          //
          //                     },
          //                   )
          //           ),
          //         )
          //     )
          //   /* SizedBox(
          //   height: 80,
          //   child: ListView.builder(
          //       scrollDirection: Axis.horizontal,
          //       itemCount: mainCategoryList.length,
          //       itemBuilder: (context, index) =>
          //           CategoryCard2(
          //             getmainCategorylist: mainCategoryList[index],
          //             mainCategory_auto_id: widget.mainCategory_auto_id,
          //             icon: mainCategoryList[index].categoryImageApp,
          //             baseUrl: baseUrl,
          //             text: mainCategoryList[index].mainCategoryName,
          //             press: () => {
          //               goToMainCategoryScreen(mainCategoryList[index])
          //             },
          //             longpressed: () => {
          //             },
          //           )
          //   ),
          // ),*/
          // )
          Container(
              padding: EdgeInsets.only(top:10,bottom: 10),
              child:
              getUi()
            //:Container()
          ),
        ],
      ),
    );
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
        if(mainCategoryList.isEmpty){
          return
            Container(
              height: 150,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _controllerOne,

                  itemCount: mainCategoryList.length,
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
                  itemCount: mainCategoryList.length,
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
                              mainCategoryList[index].categoryImageApp!=''?
                              CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: baseUrl+main_categories_base_url+mainCategoryList[index].categoryImageApp,
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
        if(mainCategoryList.isEmpty){
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
                          mainCategoryList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child: Container(
                              margin: EdgeInsets.all(1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child:
                                mainCategoryList[0].categoryImageApp!=''?
                                CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+main_categories_base_url+mainCategoryList[0].categoryImageApp,
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
                                mainCategoryList.length>1 && mainCategoryList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: mainCategoryList[1].categoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[1].categoryImageApp,
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
                                mainCategoryList.length>2 && mainCategoryList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child:
                                      mainCategoryList[2].categoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[2].categoryImageApp,
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
        if(mainCategoryList.isEmpty){
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
                                mainCategoryList.length>1 && mainCategoryList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: mainCategoryList[1].categoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[1].categoryImageApp,
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
                                mainCategoryList.length>2 && mainCategoryList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child:
                                      mainCategoryList[2].categoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[2].categoryImageApp,
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
                          mainCategoryList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child: Container(
                              margin: EdgeInsets.all(1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child:
                                mainCategoryList[0].categoryImageApp!=''?
                                CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+main_categories_base_url+mainCategoryList[0].categoryImageApp,
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
        if (mainCategoryList.isEmpty) {
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
                                        mainCategoryList.length>1 && mainCategoryList[0]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(1),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child:
                                              mainCategoryList[0].categoryImageApp!=''?
                                              CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+main_categories_base_url+mainCategoryList[0].categoryImageApp,
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
                                        mainCategoryList.length>2 && mainCategoryList[1]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(1),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child:
                                              mainCategoryList[1].categoryImageApp!=''?
                                              CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+main_categories_base_url+mainCategoryList[1].categoryImageApp,
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
                                  mainCategoryList.length>3 && mainCategoryList[2]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child:
                                        mainCategoryList[2].categoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+main_categories_base_url+mainCategoryList[2].categoryImageApp,
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
                                  mainCategoryList.length>4 && mainCategoryList[3]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child:
                                        mainCategoryList[3].categoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+main_categories_base_url+mainCategoryList[3].categoryImageApp,
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
                                  mainCategoryList.length>5 && mainCategoryList[4]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child:
                                        mainCategoryList[4].categoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+main_categories_base_url+mainCategoryList[4].categoryImageApp,
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
                                  mainCategoryList.length==6 && mainCategoryList[5]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child:
                                        mainCategoryList[5].categoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+main_categories_base_url+mainCategoryList[5].categoryImageApp,
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
        if(mainCategoryList.isEmpty){
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
                          mainCategoryList[index].categoryImageApp!=''?
                          CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: baseUrl+main_categories_base_url+mainCategoryList[index].categoryImageApp,
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
        if(mainCategoryList.isEmpty){
          return Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 10),
            child:
            ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _controllerOne,

                itemCount: mainCategoryList.length,
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
                  itemCount: mainCategoryList.length,
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
                                          mainCategoryList[index].categoryImageApp!=''?
                                          CachedNetworkImage(
                                            width: MediaQuery.of(context).size.width,
                                            fit: BoxFit.fill,
                                            imageUrl: baseUrl+main_categories_base_url+mainCategoryList[index].categoryImageApp,
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
                                        child: Text(mainCategoryList[index].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if(mainCategoryList.isEmpty){
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
                          mainCategoryList[0]!=null?
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
                                        mainCategoryList[0].categoryImageApp!=''?
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+main_categories_base_url+mainCategoryList[0].categoryImageApp,
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
                                      child: Text(mainCategoryList[0].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                mainCategoryList.length>1 && mainCategoryList[1]!=null?
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
                                              mainCategoryList[1].categoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+main_categories_base_url+mainCategoryList[1].categoryImageApp,
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
                                            child: Text(mainCategoryList[1].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                mainCategoryList.length>2 && mainCategoryList[2]!=null?
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
                                              mainCategoryList[2].categoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+main_categories_base_url+mainCategoryList[2].categoryImageApp,
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
                                            child: Text(mainCategoryList[2].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if(mainCategoryList.isEmpty){
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
                                mainCategoryList.length>1 && mainCategoryList[1]!=null?
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
                                              mainCategoryList[1].categoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+main_categories_base_url+mainCategoryList[1].categoryImageApp,
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
                                            child: Text(mainCategoryList[1].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                mainCategoryList.length>2 && mainCategoryList[2]!=null?
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
                                              mainCategoryList[2].categoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+main_categories_base_url+mainCategoryList[2].categoryImageApp,
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
                                            child: Text(mainCategoryList[2].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                          mainCategoryList[0]!=null?
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
                                        mainCategoryList[0].categoryImageApp!=''?
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+main_categories_base_url+mainCategoryList[0].categoryImageApp,
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
                                      child: Text(mainCategoryList[0].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if (mainCategoryList.isEmpty) {
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
                                        mainCategoryList.length>1 && mainCategoryList[0]!=null?
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
                                                      mainCategoryList[0].categoryImageApp!=''?
                                                      CachedNetworkImage(
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.fill,
                                                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[0].categoryImageApp,
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
                                                    child: Text(mainCategoryList[0].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                        mainCategoryList.length>2 && mainCategoryList[1]!=null?
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
                                                      mainCategoryList[1].categoryImageApp!=''?
                                                      CachedNetworkImage(
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.fill,
                                                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[1].categoryImageApp,
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
                                                    child: Text(mainCategoryList[1].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                              mainCategoryList.length>3 && mainCategoryList[2]!=null?
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
                                            mainCategoryList[2].categoryImageApp!=''?
                                            CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.fill,
                                              imageUrl: baseUrl+main_categories_base_url+mainCategoryList[2].categoryImageApp,
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
                                          child: Text(mainCategoryList[2].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                              mainCategoryList.length>4 && mainCategoryList[3]!=null?
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
                                            mainCategoryList[3].categoryImageApp!=''?
                                            CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.fill,
                                              imageUrl: baseUrl+main_categories_base_url+mainCategoryList[3].categoryImageApp,
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
                                          child: Text(mainCategoryList[3].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                  mainCategoryList.length>5 && mainCategoryList[4]!=null?
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
                                                mainCategoryList[4].categoryImageApp!=''?
                                                CachedNetworkImage(
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.fill,
                                                  imageUrl: baseUrl+main_categories_base_url+mainCategoryList[4].categoryImageApp,
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
                                              child: Text(mainCategoryList[4].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                  mainCategoryList.length==6 && mainCategoryList[5]!=null?
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
                                                mainCategoryList[5].categoryImageApp!=''?
                                                CachedNetworkImage(
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.fill,
                                                  imageUrl: baseUrl+main_categories_base_url+mainCategoryList[5].categoryImageApp,
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
                                              child: Text(mainCategoryList[5].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if(mainCategoryList.isEmpty){
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
                                    mainCategoryList[index].categoryImageApp!=''?
                                    CachedNetworkImage(
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fill,
                                      imageUrl: baseUrl+main_categories_base_url+mainCategoryList[index].categoryImageApp,
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
                                  child: Text(mainCategoryList[index].mainCategoryName,style: labelStyle,maxLines: 1,
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
        if(mainCategoryList.isEmpty){
          return Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _controllerOne,

              itemCount: mainCategoryList.length,
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

                  itemCount: mainCategoryList.length,
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
                              mainCategoryList[index].categoryImageApp!=''?
                              CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: baseUrl+main_categories_base_url+ mainCategoryList[index].categoryImageApp,
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
        if(mainCategoryList.isEmpty){
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
                          mainCategoryList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child: Container(
                              margin: EdgeInsets.all(1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child:
                                mainCategoryList[0].categoryImageApp!=''?
                                CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+main_categories_base_url+mainCategoryList[0].categoryImageApp,
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
                                mainCategoryList.length>1 && mainCategoryList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      mainCategoryList[1].categoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[1].categoryImageApp,
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
                                mainCategoryList.length>2 && mainCategoryList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      mainCategoryList[2].categoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[2].categoryImageApp,
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
        if(mainCategoryList.isEmpty){
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
                                mainCategoryList.length>1 && mainCategoryList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      mainCategoryList[1].categoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[1].categoryImageApp,
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
                                mainCategoryList.length>2 && mainCategoryList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      mainCategoryList[2].categoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[2].categoryImageApp,
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
                          mainCategoryList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child: Container(
                              margin: EdgeInsets.all(1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child:
                                mainCategoryList[0].categoryImageApp!=''?
                                CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+main_categories_base_url+mainCategoryList[0].categoryImageApp,
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
        if (mainCategoryList.isEmpty) {
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
                                        mainCategoryList.length>0 && mainCategoryList[0]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(1),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              mainCategoryList[0].categoryImageApp!=''?
                                              CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+main_categories_base_url+mainCategoryList[0].categoryImageApp,
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
                                        mainCategoryList.length>1 && mainCategoryList[1]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(1),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              mainCategoryList[1].categoryImageApp!=''?
                                              CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+main_categories_base_url+mainCategoryList[1].categoryImageApp,
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
                                  mainCategoryList.length>2 && mainCategoryList[2]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        mainCategoryList[2].categoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+main_categories_base_url+mainCategoryList[2].categoryImageApp,
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
                                  mainCategoryList.length>3 && mainCategoryList[3]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        mainCategoryList[3].categoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+main_categories_base_url+mainCategoryList[3].categoryImageApp,
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
                                  mainCategoryList.length>4 && mainCategoryList[4]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        mainCategoryList[4].categoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+main_categories_base_url+mainCategoryList[4].categoryImageApp,
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
                                  mainCategoryList.length>5 && mainCategoryList[5]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        mainCategoryList[5].categoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+main_categories_base_url+mainCategoryList[5].categoryImageApp,
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
        if(mainCategoryList.isEmpty){
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
                        mainCategoryList[index].categoryImageApp!=''?
                        CachedNetworkImage(
                          //height: MediaQuery.of(context).size.height,
                          //width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                          imageUrl: baseUrl+main_categories_base_url+ mainCategoryList[index].categoryImageApp,
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
        if(mainCategoryList.isEmpty){
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
                        mainCategoryList[index].categoryImageApp!=''?
                        CachedNetworkImage(
                          //height: MediaQuery.of(context).size.height,
                          //width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                          imageUrl: baseUrl+main_categories_base_url+ mainCategoryList[index].categoryImageApp,
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
        if(mainCategoryList.isEmpty){
          return Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _controllerOne,

                itemCount: mainCategoryList.length,
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

                  itemCount: mainCategoryList.length,
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
                                    mainCategoryList[index].categoryImageApp!=''?
                                    CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl: baseUrl+main_categories_base_url+mainCategoryList[index].categoryImageApp,
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
                                  child: Text(mainCategoryList[index].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if(mainCategoryList.isEmpty){
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
                          mainCategoryList[0]!=null?
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
                                        mainCategoryList[0].categoryImageApp!=''?
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+main_categories_base_url+mainCategoryList[0].categoryImageApp,
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
                                      child: Text(mainCategoryList[0].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                mainCategoryList.length>1 && mainCategoryList[1]!=null?
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
                                              mainCategoryList[1].categoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+main_categories_base_url+mainCategoryList[1].categoryImageApp,
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
                                            child: Text(mainCategoryList[1].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                mainCategoryList.length>2 && mainCategoryList[2]!=null?
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
                                              mainCategoryList[2].categoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+main_categories_base_url+mainCategoryList[2].categoryImageApp,
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
                                            child: Text(mainCategoryList[2].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if(mainCategoryList.isEmpty){
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
                                mainCategoryList.length>1 && mainCategoryList[1]!=null?
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
                                              mainCategoryList[1].categoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+main_categories_base_url+mainCategoryList[1].categoryImageApp,
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
                                            child: Text(mainCategoryList[1].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                mainCategoryList.length>2 && mainCategoryList[2]!=null?
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
                                              mainCategoryList[2].categoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+main_categories_base_url+mainCategoryList[2].categoryImageApp,
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
                                            child: Text(mainCategoryList[2].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                          mainCategoryList[0]!=null?
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
                                        mainCategoryList[0].categoryImageApp!=''?
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+main_categories_base_url+mainCategoryList[0].categoryImageApp,
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
                                      child: Text(mainCategoryList[0].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if (mainCategoryList.isEmpty) {
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
                                        mainCategoryList.length>1 && mainCategoryList[0]!=null?
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
                                                      mainCategoryList[0].categoryImageApp!=''?
                                                      CachedNetworkImage(
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.fill,
                                                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[0].categoryImageApp,
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
                                                    child: Text(mainCategoryList[0].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                        mainCategoryList.length>2 && mainCategoryList[1]!=null?
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
                                                      mainCategoryList[1].categoryImageApp!=''?
                                                      CachedNetworkImage(
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.fill,
                                                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[1].categoryImageApp,
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
                                                    child: Text(mainCategoryList[1].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                              mainCategoryList.length>3 && mainCategoryList[2]!=null?
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
                                            mainCategoryList[2].categoryImageApp!=''?
                                            CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.fill,
                                              imageUrl: baseUrl+main_categories_base_url+mainCategoryList[2].categoryImageApp,
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
                                          child: Text(mainCategoryList[2].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                              mainCategoryList.length>4 && mainCategoryList[3]!=null?
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
                                            mainCategoryList[3].categoryImageApp!=''?
                                            CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.fill,
                                              imageUrl: baseUrl+main_categories_base_url+mainCategoryList[3].categoryImageApp,
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
                                          child: Text(mainCategoryList[3].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                  mainCategoryList.length>5 && mainCategoryList[4]!=null?
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
                                                mainCategoryList[4].categoryImageApp!=''?
                                                CachedNetworkImage(
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.fill,
                                                  imageUrl: baseUrl+main_categories_base_url+mainCategoryList[4].categoryImageApp,
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
                                              child: Text(mainCategoryList[4].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                  mainCategoryList.length==6 && mainCategoryList[5]!=null?
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
                                                mainCategoryList[5].categoryImageApp!=''?
                                                CachedNetworkImage(
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.fill,
                                                  imageUrl: baseUrl+main_categories_base_url+mainCategoryList[5].categoryImageApp,
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
                                              child: Text(mainCategoryList[5].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if(mainCategoryList.isEmpty){
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
                                mainCategoryList[index].categoryImageApp!=''?
                                CachedNetworkImage(
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+main_categories_base_url+mainCategoryList[index].categoryImageApp,
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
                            child: Text(mainCategoryList[index].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,),
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
        if(mainCategoryList.isEmpty){
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

                itemCount: mainCategoryList.length,
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
                            mainCategoryList[index].categoryImageApp!=''?
                            CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: baseUrl+main_categories_base_url+ mainCategoryList[index].categoryImageApp,
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
        if(mainCategoryList.isEmpty){
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
                          mainCategoryList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child: Container(
                              margin: EdgeInsets.all(1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child:
                                mainCategoryList[0].categoryImageApp!=''?
                                CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+main_categories_base_url+mainCategoryList[0].categoryImageApp,
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
                                mainCategoryList.length>1 && mainCategoryList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      mainCategoryList[1].categoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[1].categoryImageApp,
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
                                mainCategoryList.length>2 && mainCategoryList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      mainCategoryList[2].categoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[2].categoryImageApp,
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
        if(mainCategoryList.isEmpty){
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
                                mainCategoryList.length>1 && mainCategoryList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      mainCategoryList[1].categoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[1].categoryImageApp,
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
                                mainCategoryList.length>2 && mainCategoryList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      mainCategoryList[2].categoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[2].categoryImageApp,
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
                          mainCategoryList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child: Container(
                              margin: EdgeInsets.all(1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child:
                                mainCategoryList[0].categoryImageApp!=''?
                                CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+main_categories_base_url+mainCategoryList[0].categoryImageApp,
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
        if (mainCategoryList.isEmpty) {
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
                                        mainCategoryList.length>1 && mainCategoryList[0]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(1),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              mainCategoryList[0].categoryImageApp!=''?
                                              CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+main_categories_base_url+mainCategoryList[0].categoryImageApp,
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
                                        mainCategoryList.length>2 && mainCategoryList[1]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(1),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              mainCategoryList[1].categoryImageApp!=''?
                                              CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+main_categories_base_url+mainCategoryList[1].categoryImageApp,
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
                                  mainCategoryList.length>3 && mainCategoryList[2]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        mainCategoryList[2].categoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+main_categories_base_url+mainCategoryList[2].categoryImageApp,
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
                                  mainCategoryList.length>4 && mainCategoryList[3]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        mainCategoryList[3].categoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+main_categories_base_url+mainCategoryList[3].categoryImageApp,
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
                                  mainCategoryList.length>5 && mainCategoryList[4]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        mainCategoryList[4].categoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+main_categories_base_url+mainCategoryList[4].categoryImageApp,
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
                                  mainCategoryList.length==6 && mainCategoryList[5]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        mainCategoryList[5].categoryImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+main_categories_base_url+mainCategoryList[5].categoryImageApp,
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
        if(mainCategoryList.isEmpty){
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
                        mainCategoryList[index].categoryImageApp!=''?
                        CachedNetworkImage(
                          //height: MediaQuery.of(context).size.height,
                          //width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                          imageUrl: baseUrl+main_categories_base_url+ mainCategoryList[index].categoryImageApp,
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
        if(mainCategoryList.isEmpty){
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
                        mainCategoryList[index].categoryImageApp!=''?
                        CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: baseUrl+main_categories_base_url+ mainCategoryList[index].categoryImageApp,
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
        if(mainCategoryList.isEmpty){
          return Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _controllerOne,

                itemCount: mainCategoryList.length,
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

                    itemCount: mainCategoryList.length,
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
                                      mainCategoryList[index].categoryImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[index].categoryImageApp,
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
                                    child: Text(mainCategoryList[index].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if(mainCategoryList.isEmpty){
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
                          mainCategoryList[0]!=null?
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
                                        mainCategoryList[0].categoryImageApp!=''?
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+main_categories_base_url+mainCategoryList[0].categoryImageApp,
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
                                      child: Text(mainCategoryList[0].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                mainCategoryList.length>1 && mainCategoryList[1]!=null?
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
                                              mainCategoryList[1].categoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+main_categories_base_url+mainCategoryList[1].categoryImageApp,
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
                                            child: Text(mainCategoryList[0].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                mainCategoryList.length>2 && mainCategoryList[2]!=null?
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
                                              mainCategoryList[2].categoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+main_categories_base_url+mainCategoryList[2].categoryImageApp,
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
                                            child: Text(mainCategoryList[0].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if(mainCategoryList.isEmpty){
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
                                mainCategoryList.length>1 && mainCategoryList[1]!=null?
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
                                              mainCategoryList[1].categoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+main_categories_base_url+mainCategoryList[1].categoryImageApp,
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
                                            child: Text(mainCategoryList[0].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                mainCategoryList.length>2 && mainCategoryList[2]!=null?
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
                                              mainCategoryList[2].categoryImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+main_categories_base_url+mainCategoryList[2].categoryImageApp,
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
                                            child: Text(mainCategoryList[0].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                          mainCategoryList[0]!=null?
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
                                        mainCategoryList[0].categoryImageApp!=''?
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+main_categories_base_url+mainCategoryList[0].categoryImageApp,
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
                                      child: Text(mainCategoryList[0].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if (mainCategoryList.isEmpty) {
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
                                        mainCategoryList.length>1 && mainCategoryList[0]!=null?
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
                                                      mainCategoryList[0].categoryImageApp!=''?
                                                      CachedNetworkImage(
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.fill,
                                                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[0].categoryImageApp,
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
                                                    child: Text(mainCategoryList[0].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                        mainCategoryList.length>2 && mainCategoryList[1]!=null?
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
                                                      mainCategoryList[1].categoryImageApp!=''?
                                                      CachedNetworkImage(
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.fill,
                                                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[1].categoryImageApp,
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
                                                    child: Text(mainCategoryList[1].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                              mainCategoryList.length>3 && mainCategoryList[2]!=null?
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
                                            mainCategoryList[2].categoryImageApp!=''?
                                            CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.fill,
                                              imageUrl: baseUrl+main_categories_base_url+mainCategoryList[2].categoryImageApp,
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
                                          child: Text(mainCategoryList[2].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                              mainCategoryList.length>4 && mainCategoryList[3]!=null?
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
                                            mainCategoryList[3].categoryImageApp!=''?
                                            CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.fill,
                                              imageUrl: baseUrl+main_categories_base_url+mainCategoryList[3].categoryImageApp,
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
                                          child: Text(mainCategoryList[3].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                  mainCategoryList.length>5 && mainCategoryList[4]!=null?
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
                                                mainCategoryList[4].categoryImageApp!=''?
                                                CachedNetworkImage(
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.fill,
                                                  imageUrl: baseUrl+main_categories_base_url+mainCategoryList[4].categoryImageApp,
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
                                              child: Text(mainCategoryList[4].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                  mainCategoryList.length==6 && mainCategoryList[5]!=null?
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
                                                mainCategoryList[5].categoryImageApp!=''?
                                                CachedNetworkImage(
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.fill,
                                                  imageUrl: baseUrl+main_categories_base_url+mainCategoryList[5].categoryImageApp,
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
                                              child: Text(mainCategoryList[5].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if(mainCategoryList.isEmpty){
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
                                mainCategoryList[index].categoryImageApp!=''?
                                CachedNetworkImage(
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+main_categories_base_url+mainCategoryList[index].categoryImageApp,
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
                            child: Text(mainCategoryList[index].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,),
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

    if(mainCategoryList.isEmpty){
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
      for(int index=0;index<mainCategoryList.length;index++){
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
                      mainCategoryList[index].categoryImageApp!=''?
                      CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: baseUrl+main_categories_base_url+mainCategoryList[index].categoryImageApp,
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
                            mainCategoryList[index].categoryImageApp!=''?
                            CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: baseUrl+main_categories_base_url+mainCategoryList[index].categoryImageApp,
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
                        child: Text(mainCategoryList[index].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,),
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
                    mainCategoryList[index].categoryImageApp!=''?
                    CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: baseUrl+main_categories_base_url+ mainCategoryList[index].categoryImageApp,
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
                            mainCategoryList[index].categoryImageApp!=''?
                            CachedNetworkImage(
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill,
                              imageUrl: baseUrl+main_categories_base_url+mainCategoryList[index].categoryImageApp,
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
                          child: Text(mainCategoryList[index].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                      mainCategoryList[index].categoryImageApp!=''?
                      CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: baseUrl+main_categories_base_url+ mainCategoryList[index].categoryImageApp,
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
                            mainCategoryList[index].categoryImageApp!=''?
                            CachedNetworkImage(
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill,
                              imageUrl: baseUrl+main_categories_base_url+mainCategoryList[index].categoryImageApp,
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
                          child: Text(mainCategoryList[index].mainCategoryName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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

  goToNextScreen(int index){

    // widget.onGoToListCallBack("category",
    //     mainCategoryList[index].mainCategoryAutoId);
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

