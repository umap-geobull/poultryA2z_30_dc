// ignore: file_names
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../../Admin_add_Product/Components/Product_List.dart';
import '../../../../Product_Details/Product_List_User.dart';
import '../../../../Utils/App_Apis.dart';
import '../../component_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/home_subcategory_details.dart';
import 'package:getwidget/getwidget.dart';


class ShowSubcategoryFromHome extends StatefulWidget {
  String component_id;

  ShowSubcategoryFromHome(this.component_id);

  @override
  _ShowSubcategoryFromHome createState() => _ShowSubcategoryFromHome(component_id);
}

class _ShowSubcategoryFromHome extends State<ShowSubcategoryFromHome> {

  String component_id;

  _ShowSubcategoryFromHome(this.component_id);


  late GetHomeComponentList homeComponent;
  String appLabelFont = 'Lato',appHeaderFont='Lato',headerTitle='';
  Color appLabelColor=const Color(0xff443a49),appHeaderColor=Colors.black87;
  double appFontSize=15;

  bool isApiCallProcessing=false;

  TextStyle labelStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:12,
      fontWeight: FontWeight.normal,
      color: Colors.grey);

  TextStyle headerStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:16,
      fontWeight: FontWeight.normal,
      color: Colors.black87);

  Color appBarColor=Colors.white,appBarIconColor=Colors.black;

  String showLocationOnHomeScreen='';

  Color bototmBarColor=Colors.white, bottomMenuIconColor=Color(0xFFFF7643);

  bool isUiAvailable=false;

  String title='';

  late Route routes;

  List<Content> subcategoryList=[];

  String baseUrl='';
  String userId='',admin_auto_id='',app_type_id='';

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');

    if(baseUrl!=null && userId!=null && adminId!=null && apptypeid!=null){
      this.baseUrl=baseUrl;
      this.userId=userId;
      this.admin_auto_id=adminId;
      this.app_type_id=apptypeid;
      setState(() {});
      getSubcategory();
    }
  }

  goToNextScreen(int index){
    if(userId=='Admin'){
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) =>
                Product_List(
                  type: "subcategory",
                  main_cat_id: '',
                  sub_cat_id: subcategoryList[index].subcategoryAutoId,
                  brand_id: '',
                  home_componet_id: '',
                  offer_id: '',)),);
    }
    else{
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) =>
                Product_List_User(
                  type: "subcategory",
                  main_cat_id: '',
                  sub_cat_id: subcategoryList[index].subcategoryAutoId,
                  brand_id: '',
                  home_componet_id: '',
                  offer_id: '',)),);
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getappUi();
    getBaseUrl();
  }

  void onSavelistener(){
    Navigator.pop(context);
    getSubcategory();
  }

  FutureOr onGoBack(dynamic value) {
    getSubcategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(Icons.arrow_back, color:appBarIconColor),
        ),
        backgroundColor: appBarColor,
        title: Text(title ,style: TextStyle(color: appBarIconColor,fontSize: 18)),
        automaticallyImplyLeading: false,),
      body:Stack(
        children: <Widget>[
          Container(
              child:
              isUiAvailable==true?
              Container(
                padding: EdgeInsets.all(10),
                child: getUi(),
              ) : 
              Container()
          ),

          isApiCallProcessing == false &&
              subcategoryList.isEmpty?
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: const Text('No subcategories available'))
              : Container(),

          isApiCallProcessing == true
              ? Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: const GFLoader(type: GFLoaderType.circle),
          )
              : Container()


        ],
      ),
    );
  }

  void getappUi() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? appBarColor =prefs.getString('appbarColor');
    String? appbarIcon =prefs.getString('appbarIconColor');
    String? showLocation =prefs.getString('showLocationOnHomescreen');

    String? bottomBarColor =prefs.getString('bottomBarColor');
    String? bottombarIcon =prefs.getString('bottomBarIconColor');

    if(bottomBarColor!=null){
      this.bototmBarColor=Color(int.parse(bottomBarColor));
      setState(() {});
    }

    if(bottombarIcon!=null){
      this.bottomMenuIconColor=Color(int.parse(bottombarIcon));
      setState(() {});
    }

    if(appBarColor!=null){
      this.appBarColor=Color(int.parse(appBarColor));
      setState(() {});
    }

    if(appbarIcon!=null){
      this.appBarIconColor=Color(int.parse(appbarIcon));
      setState(() {});
    }

    if(showLocation!=null){
      this.showLocationOnHomeScreen=showLocation;
      setState(() {});
    }
  }

  Future getSubcategory() async {
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
        homeComponent=homeSubcategoryDetails.getHomeComponentList[0];

        isUiAvailable=true;

        subcategoryList=homeSubcategoryDetails.getHomeComponentList[0].content;

        title=homeSubcategoryDetails.getHomeComponentList[0].title;

        if(homeComponent.labelFont.isNotEmpty){
          appLabelFont=homeComponent.labelFont;
        }
        if(homeComponent.labelColor.isNotEmpty){
          appLabelColor=Color(int.parse(homeComponent.labelColor));
        }

        labelStyle= GoogleFonts.getFont(appLabelFont).copyWith(
            fontSize:14,
            fontWeight: FontWeight.normal,
            color: appLabelColor);

      }
      else{
        subcategoryList = [];
      }

      if(this.mounted){
        setState(() {});
      }

    }
    else{
      subcategoryList = [];

      Fluttertoast.showToast(msg: "Server error: "+response.statusCode.toString(), backgroundColor: Colors.grey,);

      if(this.mounted){
        setState(() {});
      }

    }
  }

  getUi(){
    String iconType="2";
    String layoutType="3";

    if(homeComponent.layoutType.isNotEmpty){
      layoutType=homeComponent.layoutType;
    }
    if(homeComponent.iconType.isNotEmpty){
      iconType=homeComponent.iconType;
    }

    if(iconType=="0"){
      return GridView.builder(
        itemCount: subcategoryList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3
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
    else if(iconType=="1"){
      return GridView.builder(
          itemCount: subcategoryList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1/1.3,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            crossAxisCount: 3,
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
                      color: Colors.white,
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
    else if(iconType=="2"){
      return GridView.builder(
        itemCount: subcategoryList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
          crossAxisCount: 3,
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
    else if(iconType=="3"){
      return GridView.builder(
          itemCount: subcategoryList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1/1.2,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) =>
              GestureDetector(
                onTap: ()=>{goToNextScreen(index)},
                child:  Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(3),
                  color: Colors.white,
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
    else if(iconType=="4"){
      return GridView.builder(
        itemCount: subcategoryList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1/1.3,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
          crossAxisCount: 3,
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
