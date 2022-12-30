// ignore: file_names
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Product_List.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/get_title_alignment.dart';
import 'package:poultry_a2z/MainCategories/Brand/BrandsFromMaincategory.dart';
import 'package:poultry_a2z/Product_Details/Product_List_User.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../Utils/App_Apis.dart';
import '../../Home/Components/AddNewComponent/Brand/edit_brand_bottomsheet.dart';
import '../../Home/Components/AddNewComponent/Brand/selec_brands.dart';
import '../../Home/Components/AddNewComponent/models/home_brands_detail.dart';
import '../../Home/Components/component_constants.dart';
import 'main_category_brands.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnEditCallBack =Function(String id);
typedef OnDeleteCallBack =Function(String id);
typedef OnGoToListCallBack =Function(String type, String main_cat_id, String sub_cat_id, String brand_id);

class BrandsNew extends StatefulWidget {
  bool iseditSwitched;
  String component_id;
  OnDeleteCallBack onDeleteCallBack;
  String main_category_auto_id;
  String user_type;
  OnGoToListCallBack onGoToListCallBack;
  String iconType;
  String layoutType;

  BrandsNew(this.iseditSwitched, this.component_id,
      this.onDeleteCallBack,this.main_category_auto_id,this.user_type,this.onGoToListCallBack,this.iconType,this.layoutType);

  @override
  _BrandsNew createState() => _BrandsNew(iseditSwitched,component_id,main_category_auto_id,iconType,layoutType);

}

class _BrandsNew extends State<BrandsNew> {
  bool iseditSwitched;
  String component_id;
  String iconType;
  String layoutType;
  String main_category_auto_id;

  _BrandsNew(this.iseditSwitched, this.component_id,this.main_category_auto_id,this.iconType,this.layoutType);

  bool isApiCallProcessing=false;

  bool isUiAvailable=false;

  TextStyle labelStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:12,
      fontWeight: FontWeight.normal,
      color: Colors.grey);

  TextStyle headerStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:15,
      fontWeight: FontWeight.normal,
      color: Colors.black87);

  String appLabelFont = 'Lato',appHeaderFont='Lato',headerTitle='';
  Color appLabelColor=const Color(0xff443a49),appHeaderColor=Colors.black87,
      title_backgroundColor=Colors.transparent, backgroundColor=Colors.transparent;

  Alignment titleAlignment = Alignment.centerLeft;

  double appFontSize=15;
  Color scrollbarColor=Colors.pinkAccent;
  final ScrollController _controllerOne = ScrollController();
  double scrollbarthickness=2;

  late Route routes;

  String title='';

  List<GetMainCategoryBrands> brandsList=[];

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
      getBrandsUi();
      getBrands();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
  }

  int getItemsCount(){
    if(layoutType=="0" && (brandsList.length>=4|| brandsList.isEmpty)){
      return 4;
    }
    else if(layoutType=="1" && (brandsList.length>=6 || brandsList.isEmpty)){
      return 6;
    }
    else if(layoutType=="2" && (brandsList.length>=8 || brandsList.isEmpty)){
      return 8;
    }
    else if(layoutType=="3" && (brandsList.length>=9 || brandsList.isEmpty)){
      return 9;
    }
    else if(layoutType=="4" && (brandsList.length>=16 || brandsList.isEmpty)){
      return 16;
    }
    else if(layoutType=="5" && (brandsList.length>=6 || brandsList.isEmpty)){
      return 6;
    }
    else if(layoutType=="6" && (brandsList.length>=12 || brandsList.isEmpty)){
      return 12;
    }

    return brandsList.length;
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

    return 1;
  }

  showAddBrand(String homecomponentId) {
    routes = MaterialPageRoute(builder: (context) => SelectBrands(onSavelistener,homecomponentId));
    Navigator.push(context, routes).then(onGoBack);

  }

  void onEditUilistener(){
    Navigator.pop(context);
    getBrandsUi();
  }

  void onSavelistener(){
    Navigator.pop(context);
    getBrands();
  }

  FutureOr onGoBack(dynamic value) {
    getBrands();
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
                        showBrandEdit()
                      },
                      child: Container(
                          padding: const EdgeInsets.all(7),
                          child: const Icon(Icons.edit,color: Colors.orange,)
                      ),):
                    Container(),

                    iseditSwitched==true?
                    GestureDetector(
                      onTap: ()=>{
                        showAddBrand(component_id)
                      },
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        child: const Icon(Icons.add_box_rounded,color: Colors.blue,),
                      ),):
                    Container(),

                    GestureDetector(
                      onTap: ()=>{
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            BrandsFromMainCategory(component_id, main_category_auto_id)))
                      },
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        child: const Icon(Icons.arrow_forward),
                      ),)
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3.0, right: 3),
            child: Container(
                child: getUi()
            ),
          ),
        ],
      )
    );
  }

  Future getBrands() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "main_category_auto_id":main_category_auto_id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    var url=baseUrl+'api/'+get_main_category_brands;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      String status=resp['status'];
      if(status=="1"){
        MainCategoryBrands mainCategoryBrands=MainCategoryBrands.fromJson(json.decode(response.body));
        brandsList=mainCategoryBrands.getMainCategoryBrands;
        
        if(mounted){
          setState(() {});
        }
      }
    }
  }

  Future getBrandsUi() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "component_auto_id":component_id,
      "component_type":SHOP_BY_BRANDS,
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
        HomeBrandDetails homeBrandDetails=HomeBrandDetails.fromJson(json.decode(response.body));
        GetHomeComponentList homeComponent=homeBrandDetails.getHomeComponentList[0];
        isUiAvailable=true;

        title=homeBrandDetails.getHomeComponentList[0].title;

        if(homeComponent.iconType.isNotEmpty){
          iconType=homeComponent.iconType;
        }
        if(homeComponent.layoutType.isNotEmpty){
          layoutType=homeComponent.layoutType;
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

        if(homeComponent.backgroundColor.isNotEmpty){
          backgroundColor=Color(int.parse(homeComponent.backgroundColor));
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

  showBrandEdit() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditBrandsStyle(onEditUilistener,component_id)));
  }

  goToNextScreen(int index){

    widget.onGoToListCallBack("brand", "","", brandsList[index].id);


  /*  if(widget.user_type=='Admin'){
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) =>
                Product_List(type: "brand",
                  main_cat_id: '',
                  sub_cat_id: '',
                  brand_id: brandsList[index].id,)),);
    }
    else{
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) =>
                Product_List_User(type: "brand",
                  main_cat_id: '',
                  sub_cat_id: '',
                  brand_id: brandsList[index].id,)),);
    }*/
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
        if(brandsList.isEmpty){
          return
            Container(
              height: 150,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _controllerOne,

                  itemCount: 3,
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
                  itemCount: brandsList.length,
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
                              brandsList[index].brandImageApp!=''?
                              CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: baseUrl+brands_base_url+brandsList[index].brandImageApp,
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
              ),
            ),
          );
        }
      }
      else if(layoutType=='8'){
        if(brandsList.isEmpty){
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
                          child: brandsList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child: Container(
                              margin: EdgeInsets.all(1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child:
                                brandsList[0].brandImageApp!=''?
                                CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+brands_base_url+brandsList[0].brandImageApp,
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
                                brandsList.length>1 && brandsList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: brandsList[1].brandImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+brands_base_url+brandsList[1].brandImageApp,
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
                                brandsList.length>2 && brandsList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child:
                                      brandsList[2].brandImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+brands_base_url+brandsList[2].brandImageApp,
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
        if(brandsList.isEmpty){
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
                                brandsList.length>1 && brandsList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: brandsList[1].brandImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+brands_base_url+brandsList[1].brandImageApp,
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
                                brandsList.length>2 && brandsList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child:
                                      brandsList[2].brandImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+brands_base_url+brandsList[2].brandImageApp,
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
                          brandsList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child: Container(
                              margin: EdgeInsets.all(1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child:
                                brandsList[0].brandImageApp!=''?
                                CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+brands_base_url+brandsList[0].brandImageApp,
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
        if (brandsList.isEmpty) {
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
                                        brandsList.length>1 && brandsList[0]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(1),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child:
                                              brandsList[0].brandImageApp!=''?
                                              CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+brands_base_url+brandsList[0].brandImageApp,
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
                                        brandsList.length>1 && brandsList[1]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(1),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child:
                                              brandsList[1].brandImageApp!=''?
                                              CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+brands_base_url+brandsList[1].brandImageApp,
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
                                  brandsList.length>2 && brandsList[2]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child:
                                        brandsList[2].brandImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+brands_base_url+brandsList[2].brandImageApp,
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
                                  brandsList.length>3 && brandsList[3]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child:
                                        brandsList[3].brandImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+brands_base_url+brandsList[3].brandImageApp,
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
                                  brandsList.length>4 && brandsList[4]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child:
                                        brandsList[4].brandImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+brands_base_url+brandsList[4].brandImageApp,
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
                                  brandsList.length==6 && brandsList[5]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child:
                                        brandsList[5].brandImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+brands_base_url+brandsList[5].brandImageApp,
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
      else{
        if(brandsList.isEmpty){
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
                          brandsList[index].brandImageApp!=''?
                          CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: baseUrl+brands_base_url+brandsList[index].brandImageApp,
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
        if(brandsList.isEmpty){
          return Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 10),
            child:
            ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _controllerOne,

                itemCount: brandsList.length,
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
                  itemCount: brandsList.length,
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
                                          brandsList[index].brandImageApp!=''?
                                          CachedNetworkImage(
                                            width: MediaQuery.of(context).size.width,
                                            fit: BoxFit.fill,
                                            imageUrl: baseUrl+brands_base_url+brandsList[index].brandImageApp,
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
                                        child: Text(brandsList[index].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if(brandsList.isEmpty){
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
                          brandsList[0]!=null?
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
                                        brandsList[0].brandImageApp!=''?
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+brands_base_url+brandsList[0].brandImageApp,
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
                                      child: Text(brandsList[0].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                brandsList.length>1 && brandsList[1]!=null?
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
                                              brandsList[1].brandImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+brands_base_url+brandsList[1].brandImageApp,
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
                                            child: Text(brandsList[1].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                brandsList.length>2 && brandsList[2]!=null?
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
                                              brandsList[2].brandImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+brands_base_url+brandsList[2].brandImageApp,
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
                                            child: Text(brandsList[2].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if(brandsList.isEmpty){
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
                                brandsList.length>1 && brandsList[1]!=null?
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
                                              brandsList[1].brandImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+brands_base_url+brandsList[1].brandImageApp,
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
                                            child: Text(brandsList[1].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                brandsList.length>2 && brandsList[2]!=null?
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
                                              brandsList[2].brandImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+brands_base_url+brandsList[2].brandImageApp,
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
                                            child: Text(brandsList[2].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                          brandsList[0]!=null?
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
                                        brandsList[0].brandImageApp!=''?
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+brands_base_url+brandsList[0].brandImageApp,
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
                                      child: Text(brandsList[0].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if (brandsList.isEmpty) {
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
                                        brandsList.length>1 && brandsList[0]!=null?
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
                                                      brandsList[0].brandImageApp!=''?
                                                      CachedNetworkImage(
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.fill,
                                                        imageUrl: baseUrl+brands_base_url+brandsList[0].brandImageApp,
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
                                                    child: Text(brandsList[0].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                        brandsList.length>1 && brandsList[1]!=null?
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
                                                      brandsList[1].brandImageApp!=''?
                                                      CachedNetworkImage(
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.fill,
                                                        imageUrl: baseUrl+brands_base_url+brandsList[1].brandImageApp,
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
                                                    child: Text(brandsList[1].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                              brandsList.length>2 && brandsList[2]!=null?
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
                                            brandsList[2].brandImageApp!=''?
                                            CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.fill,
                                              imageUrl: baseUrl+brands_base_url+brandsList[2].brandImageApp,
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
                                          child: Text(brandsList[2].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                              brandsList.length>3 && brandsList[3]!=null?
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
                                            brandsList[3].brandImageApp!=''?
                                            CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.fill,
                                              imageUrl: baseUrl+brands_base_url+brandsList[3].brandImageApp,
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
                                          child: Text(brandsList[3].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                  brandsList.length>4 && brandsList[4]!=null?
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
                                                brandsList[4].brandImageApp!=''?
                                                CachedNetworkImage(
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.fill,
                                                  imageUrl: baseUrl+brands_base_url+brandsList[4].brandImageApp,
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
                                              child: Text(brandsList[4].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                  brandsList.length==6 && brandsList[5]!=null?
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
                                                brandsList[5].brandImageApp!=''?
                                                CachedNetworkImage(
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.fill,
                                                  imageUrl: baseUrl+brands_base_url+brandsList[5].brandImageApp,
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
                                              child: Text(brandsList[5].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if(brandsList.isEmpty){
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
                                    brandsList[index].brandImageApp!=''?
                                    CachedNetworkImage(
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fill,
                                      imageUrl: baseUrl+brands_base_url+brandsList[index].brandImageApp,
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
                                  child: Text(brandsList[index].brandName,style: labelStyle,maxLines: 1,
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
        if(brandsList.isEmpty){
          return Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _controllerOne,

              itemCount: brandsList.length,
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

                  itemCount: brandsList.length,
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
                              brandsList[index].brandImageApp!=''?
                              CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: baseUrl+brands_base_url+ brandsList[index].brandImageApp,
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
        if(brandsList.isEmpty){
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
                          brandsList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child: Container(
                              margin: EdgeInsets.all(1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child:
                                brandsList[0].brandImageApp!=''?
                                CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+brands_base_url+brandsList[0].brandImageApp,
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
                                brandsList.length>1 && brandsList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      brandsList[1].brandImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+brands_base_url+brandsList[1].brandImageApp,
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
                                brandsList.length>2 && brandsList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      brandsList[2].brandImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+brands_base_url+brandsList[2].brandImageApp,
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
        if(brandsList.isEmpty){
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
                                brandsList.length>1 && brandsList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      brandsList[1].brandImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+brands_base_url+brandsList[1].brandImageApp,
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
                                brandsList.length>2 && brandsList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      brandsList[2].brandImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+brands_base_url+brandsList[2].brandImageApp,
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
                          brandsList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child: Container(
                              margin: EdgeInsets.all(1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child:
                                brandsList[0].brandImageApp!=''?
                                CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+brands_base_url+brandsList[0].brandImageApp,
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
        if (brandsList.isEmpty) {
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
                                        brandsList.length>0 && brandsList[0]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(1),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              brandsList[0].brandImageApp!=''?
                                              CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+brands_base_url+brandsList[0].brandImageApp,
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
                                        brandsList.length>1 && brandsList[1]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(1),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              brandsList[1].brandImageApp!=''?
                                              CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+brands_base_url+brandsList[1].brandImageApp,
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
                                  brandsList.length>2 && brandsList[2]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        brandsList[2].brandImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+brands_base_url+brandsList[2].brandImageApp,
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
                                  brandsList.length>3 && brandsList[3]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        brandsList[3].brandImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+brands_base_url+brandsList[3].brandImageApp,
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
                                  brandsList.length>4 && brandsList[4]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        brandsList[4].brandImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+brands_base_url+brandsList[4].brandImageApp,
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
                                  brandsList.length>5 && brandsList[5]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        brandsList[5].brandImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+brands_base_url+brandsList[5].brandImageApp,
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
      else{
        if(brandsList.isEmpty){
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
                        brandsList[index].brandImageApp!=''?
                        CachedNetworkImage(
                          //height: MediaQuery.of(context).size.height,
                          //width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                          imageUrl: baseUrl+brands_base_url+ brandsList[index].brandImageApp,
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
        if(brandsList.isEmpty){
          return Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _controllerOne,

                itemCount: brandsList.length,
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

                  itemCount: brandsList.length,
                  itemBuilder: (context, index) =>
                      GestureDetector(
                        onTap: ()=>{
                          goToNextScreen(index)
                        },
                        child:
                        Container(
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
                                    brandsList[index].brandImageApp!=''?
                                    CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl: baseUrl+brands_base_url+brandsList[index].brandImageApp,
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
                                  child: Text(brandsList[index].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if(brandsList.isEmpty){
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
                          brandsList[0]!=null?
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
                                        brandsList[0].brandImageApp!=''?
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+brands_base_url+brandsList[0].brandImageApp,
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
                                      child: Text(brandsList[0].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                brandsList.length>1 && brandsList[1]!=null?
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
                                              brandsList[1].brandImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+brands_base_url+brandsList[1].brandImageApp,
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
                                            child: Text(brandsList[1].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                brandsList.length>2 && brandsList[2]!=null?
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
                                              brandsList[2].brandImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+brands_base_url+brandsList[2].brandImageApp,
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
                                            child: Text(brandsList[2].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if(brandsList.isEmpty){
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
                                brandsList.length>1 && brandsList[1]!=null?
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
                                              brandsList[1].brandImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+brands_base_url+brandsList[1].brandImageApp,
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
                                            child: Text(brandsList[1].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                brandsList.length>2 && brandsList[2]!=null?
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
                                              brandsList[2].brandImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+brands_base_url+brandsList[2].brandImageApp,
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
                                            child: Text(brandsList[2].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                          brandsList[0]!=null?
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
                                        brandsList[0].brandImageApp!=''?
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+brands_base_url+brandsList[0].brandImageApp,
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
                                      child: Text(brandsList[0].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if (brandsList.isEmpty) {
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
                                        brandsList.length>0 && brandsList[0]!=null?
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
                                                      brandsList[0].brandImageApp!=''?
                                                      CachedNetworkImage(
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.fill,
                                                        imageUrl: baseUrl+brands_base_url+brandsList[0].brandImageApp,
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
                                                    child: Text(brandsList[0].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                        brandsList.length>1 && brandsList[1]!=null?
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
                                                      brandsList[1].brandImageApp!=''?
                                                      CachedNetworkImage(
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.fill,
                                                        imageUrl: baseUrl+brands_base_url+brandsList[1].brandImageApp,
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
                                                    child: Text(brandsList[1].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                              brandsList.length>2 && brandsList[2]!=null?
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
                                            brandsList[2].brandImageApp!=''?
                                            CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.fill,
                                              imageUrl: baseUrl+brands_base_url+brandsList[2].brandImageApp,
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
                                          child: Text(brandsList[2].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                              brandsList.length>3 && brandsList[3]!=null?
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
                                            brandsList[3].brandImageApp!=''?
                                            CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.fill,
                                              imageUrl: baseUrl+brands_base_url+brandsList[3].brandImageApp,
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
                                          child: Text(brandsList[3].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                  brandsList.length>4 && brandsList[4]!=null?
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
                                                brandsList[4].brandImageApp!=''?
                                                CachedNetworkImage(
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.fill,
                                                  imageUrl: baseUrl+brands_base_url+brandsList[4].brandImageApp,
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
                                              child: Text(brandsList[4].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                  brandsList.length>5 && brandsList[5]!=null?
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
                                                brandsList[5].brandImageApp!=''?
                                                CachedNetworkImage(
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.fill,
                                                  imageUrl: baseUrl+brands_base_url+brandsList[5].brandImageApp,
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
                                              child: Text(brandsList[5].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if(brandsList.isEmpty){
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
                                brandsList[index].brandImageApp!=''?
                                CachedNetworkImage(
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+brands_base_url+brandsList[index].brandImageApp,
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
                            child: Text(brandsList[index].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,),
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
        if(brandsList.isEmpty){
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

                itemCount: brandsList.length,
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
                            brandsList[index].brandImageApp!=''?
                            CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: baseUrl+brands_base_url+ brandsList[index].brandImageApp,
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
        if(brandsList.isEmpty){
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
                      flex:1,
                      child:
                      SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:
                          brandsList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child: Container(
                              margin: EdgeInsets.all(1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child:
                                brandsList[0].brandImageApp!=''?
                                CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+brands_base_url+brandsList[0].brandImageApp,
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
                                brandsList.length>1 && brandsList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      brandsList[1].brandImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+brands_base_url+brandsList[1].brandImageApp,
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
                                brandsList.length>2 && brandsList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      brandsList[2].brandImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+brands_base_url+brandsList[2].brandImageApp,
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
        if(brandsList.isEmpty){
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
                                brandsList.length>1 && brandsList[1]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(1);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      brandsList[1].brandImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+brands_base_url+brandsList[1].brandImageApp,
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
                                brandsList.length>2 && brandsList[2]!=null?
                                GestureDetector(
                                  onTap: () {
                                    goToNextScreen(2);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child:
                                      brandsList[2].brandImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+brands_base_url+brandsList[2].brandImageApp,
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
                          brandsList[0]!=null?
                          GestureDetector(
                            onTap: () {
                              goToNextScreen(0);
                            },
                            child: Container(
                              margin: EdgeInsets.all(1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child:
                                brandsList[0].brandImageApp!=''?
                                CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+brands_base_url+brandsList[0].brandImageApp,
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
        if (brandsList.isEmpty) {
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
                                        brandsList.length>0 && brandsList[0]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(1),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              brandsList[0].brandImageApp!=''?
                                              CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+brands_base_url+brandsList[0].brandImageApp,
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
                                        brandsList.length>1 && brandsList[1]!=null?
                                        GestureDetector(
                                          onTap: () {
                                            goToNextScreen(1);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(1),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child:
                                              brandsList[1].brandImageApp!=''?
                                              CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+brands_base_url+brandsList[1].brandImageApp,
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
                                  brandsList.length>2 && brandsList[2]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        brandsList[2].brandImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+brands_base_url+brandsList[2].brandImageApp,
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
                                  brandsList.length>3 && brandsList[3]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        brandsList[3].brandImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+brands_base_url+brandsList[3].brandImageApp,
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
                                  brandsList.length>4 && brandsList[4]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        brandsList[4].brandImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+brands_base_url+brandsList[4].brandImageApp,
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
                                  brandsList.length>5 && brandsList[5]!=null?
                                  GestureDetector(
                                    onTap: () {
                                      goToNextScreen(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child:
                                        brandsList[5].brandImageApp!=''?
                                        CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+brands_base_url+brandsList[5].brandImageApp,
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
      else{
        if(brandsList.isEmpty){
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
                        brandsList[index].brandImageApp!=''?
                        CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: baseUrl+brands_base_url+ brandsList[index].brandImageApp,
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
        if(brandsList.isEmpty){
          return Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _controllerOne,

                itemCount: brandsList.length,
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

                    itemCount: brandsList.length,
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
                                      brandsList[index].brandImageApp!=''?
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: baseUrl+brands_base_url+brandsList[index].brandImageApp,
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
                                    child: Text(brandsList[index].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if(brandsList.isEmpty){
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
                          brandsList[0]!=null?
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
                                        brandsList[0].brandImageApp!=''?
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+brands_base_url+brandsList[0].brandImageApp,
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
                                      child: Text(brandsList[0].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                brandsList.length>1 && brandsList[1]!=null?
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
                                              brandsList[1].brandImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+brands_base_url+brandsList[1].brandImageApp,
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
                                            child: Text(brandsList[1].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                brandsList.length>2 && brandsList[2]!=null?
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
                                              brandsList[2].brandImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+brands_base_url+brandsList[2].brandImageApp,
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
                                            child: Text(brandsList[2].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if(brandsList.isEmpty){
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
                                brandsList.length>1 && brandsList[1]!=null?
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
                                              brandsList[1].brandImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+brands_base_url+brandsList[1].brandImageApp,
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
                                            child: Text(brandsList[1].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                brandsList.length>2 && brandsList[2]!=null?
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
                                              brandsList[2].brandImageApp!=''?
                                              CachedNetworkImage(
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                                imageUrl: baseUrl+brands_base_url+brandsList[2].brandImageApp,
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
                                            child: Text(brandsList[2].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                          brandsList[0]!=null?
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
                                        brandsList[0].brandImageApp!=''?
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                          imageUrl: baseUrl+brands_base_url+brandsList[0].brandImageApp,
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
                                      child: Text(brandsList[0].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if (brandsList.isEmpty) {
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
                                        brandsList.length>0 && brandsList[0]!=null?
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
                                                      brandsList[0].brandImageApp!=''?
                                                      CachedNetworkImage(
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.fill,
                                                        imageUrl: baseUrl+brands_base_url+brandsList[0].brandImageApp,
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
                                                    child: Text(brandsList[0].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                        brandsList.length>1 && brandsList[1]!=null?
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
                                                      brandsList[1].brandImageApp!=''?
                                                      CachedNetworkImage(
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.fill,
                                                        imageUrl: baseUrl+brands_base_url+brandsList[1].brandImageApp,
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
                                                    child: Text(brandsList[1].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                              brandsList.length>2 && brandsList[2]!=null?
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
                                            brandsList[2].brandImageApp!=''?
                                            CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.fill,
                                              imageUrl: baseUrl+brands_base_url+brandsList[2].brandImageApp,
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
                                          child: Text(brandsList[2].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                              brandsList.length>3 && brandsList[3]!=null?
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
                                            brandsList[3].brandImageApp!=''?
                                            CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.fill,
                                              imageUrl: baseUrl+brands_base_url+brandsList[3].brandImageApp,
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
                                          child: Text(brandsList[3].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                  brandsList.length>4 && brandsList[4]!=null?
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
                                                brandsList[4].brandImageApp!=''?
                                                CachedNetworkImage(
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.fill,
                                                  imageUrl: baseUrl+brands_base_url+brandsList[4].brandImageApp,
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
                                              child: Text(brandsList[4].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
                                  brandsList.length==5 && brandsList[5]!=null?
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
                                                brandsList[5].brandImageApp!=''?
                                                CachedNetworkImage(
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.fill,
                                                  imageUrl: baseUrl+brands_base_url+brandsList[5].brandImageApp,
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
                                              child: Text(brandsList[5].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
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
        if(brandsList.isEmpty){
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
                                brandsList[index].brandImageApp!=''?
                                CachedNetworkImage(
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                  imageUrl: baseUrl+brands_base_url+brandsList[index].brandImageApp,
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
                            child: Text(brandsList[index].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,),
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

    if(brandsList.isEmpty){
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
      for(int index=0;index<brandsList.length;index++){
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
                      brandsList[index].brandImageApp!=''?
                      CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: baseUrl+brands_base_url+brandsList[index].brandImageApp,
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
                            brandsList[index].brandImageApp!=''?
                            CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: baseUrl+brands_base_url+brandsList[index].brandImageApp,
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
                        child: Text(brandsList[index].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child:
                    brandsList[index].brandImageApp!=''?
                    CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: baseUrl+brands_base_url+ brandsList[index].brandImageApp,
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
          widgetList.add(Container(
            margin: const EdgeInsets.all(3),
            child: GestureDetector(
                onTap:() =>{goToNextScreen(index)},
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
                          brandsList[index].brandImageApp!=''?
                          CachedNetworkImage(
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                            imageUrl: baseUrl+brands_base_url+brandsList[index].brandImageApp,
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
                        child: Text(brandsList[index].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                    )
                  ],
                )
            ),
          ));
        }
        else if(iconType=="4"){
          widgetList.add(Container(
            child: GestureDetector(
              onTap: () {
                goToNextScreen(index);
              },
              child: SizedBox(
                height: 150,
                width: 130,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child:
                  brandsList[index].brandImageApp!=''?
                  CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: baseUrl+brands_base_url+ brandsList[index].brandImageApp,
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
                        flex:8,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child:
                            brandsList[index].brandImageApp!=''?
                            CachedNetworkImage(
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill,
                              imageUrl: baseUrl+brands_base_url+brandsList[index].brandImageApp,
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
                          child: Text(brandsList[index].brandName,style: labelStyle,maxLines: 1,textAlign: TextAlign.center,)
                      )
                    ],
                  ),
                ),
              )
          );
        }
        else {
          widgetList.add(Container(
            child: GestureDetector(
                onTap: () {
                  goToNextScreen(index);
                },
                child:
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child:
                    brandsList[index].brandImageApp!=''?
                    CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: baseUrl+brands_base_url+ brandsList[index].brandImageApp,
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
      }

    }

    return widgetList;
  }
}
