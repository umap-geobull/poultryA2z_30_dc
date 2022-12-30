// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/SubCategory/add_sub_category_ui.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/SubCategory/edit_sub_category_ui.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/sub_category_model.dart';
import 'package:poultry_a2z/Home/Components/MainCategories/add_main_category_ui.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import '../../../../Utils/App_Apis.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getwidget/getwidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../MainCategories/main_category_model.dart';
import '../../component_constants.dart';
import '../models/home_subcategory_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnSaveCallback =Function();

class SelectSubCategory extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String homecomponent_id;

  SelectSubCategory(this.onSaveCallback,this.homecomponent_id);

  @override
  _SelectSubCategory createState() => _SelectSubCategory();
}

class _SelectSubCategory extends State<SelectSubCategory> {

  List<String> selectedSubcategories=[];

  int iconStyle=100,layoutStyle=2;
  Color labelColor=Colors.grey,headerColor=Colors.black87;
  String labelFont='Lato',headerFont='Lato';
  double labelSize=12,headerSize=16;
  String headerTitle='';
  bool isApiCallProcessing=false;
  bool isAddProcessing=false;
  List<GetmainCategorylist> mainCategoryList=[];


  TextStyle labelStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:12,
      fontWeight: FontWeight.normal,
      color: Colors.grey);

  TextStyle headerStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:16,
      fontWeight: FontWeight.normal,
      color: Colors.black87);

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();

  }

  onBackPressed() async{
    Navigator.pop(context);
  }

  Future getDetails() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "component_auto_id":widget.homecomponent_id,
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
        List<Content> selected=homeSubcategoryDetails.getHomeComponentList[0].content;

        for (var element in selected) {
          selectedSubcategories.add(element.subcategoryAutoId);
        }

        if(mounted){
          setState(() {});
        }
      }
    }
    else if(response.statusCode==500){
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
      Fluttertoast.showToast(msg: "Server Error", backgroundColor: Colors.grey,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: appBarIconColor,size: 20,),
          onPressed: onBackPressed,
        ),
        title: Text('Subcategories ('+selectedSubcategories.length.toString()+'/16)' ,style: const TextStyle(color: appBarIconColor,fontFamily:'Lato',fontSize: 16)),
        actions: [
         isAddProcessing==true?
         const SizedBox(
           width: 80,
           child: GFLoader(
               type:GFLoaderType.circle
           ),
         ):
         TextButton(
             onPressed: ()=>{
               addHomeSubCategories()
               //saveSubCategories()
             },
             child: const Text('Save',style: TextStyle(color: appBarIconColor,fontFamily:'Lato',fontSize: 16),)
         )
        ],
      ),
      body:
      isApiCallProcessing==true?
      const GFLoader(
          type:GFLoaderType.circle
      ):
      mainCategoryList.isNotEmpty?
      ListView.builder(
        cacheExtent: 5000,
        itemCount: mainCategoryList.length,
          itemBuilder: (context, index) =>
              _MainCategory(onChangeSelection,mainCategoryList[index],selectedSubcategories,baseUrl,admin_auto_id,app_type_id)
      ):
      Center(
        child: Container(
          child:  ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary:kPrimaryColor ,
            ),
            child: Text('Add Main Categories',style: TextStyle(color: Colors.white),),
            onPressed: () {
              showAddCategory();
            },
          ),
          margin: const EdgeInsets.all(5),
        ),
      )
    );
  }

  showAddCategory() {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return AddMainCategory(onAddMainCategorylistener);
        });
  }

  onAddMainCategorylistener(){
    Navigator.pop(context);
    getMainCategories();
  }

  void getMainCategories() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
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
    else if(response.statusCode==500){
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
      Fluttertoast.showToast(msg: "Server error in getting main categories", backgroundColor: Colors.grey,);
    }
  }

  onChangeSelection(List<String> selectedSubcategories){
    this.selectedSubcategories=selectedSubcategories;
    if(mounted){
      setState(() {});
    }
  }

  void addHomeSubCategories() async {

    if(mounted){
      setState(() {
        isAddProcessing=true;
      });
    }
    String subcategories='';

    for(int i=0;i<selectedSubcategories.length;i++){
      if(i==0){
        subcategories+=selectedSubcategories[i];
      }
      else{
        subcategories+='|'+selectedSubcategories[i];
      }
    }

    final body = {
    "sub_category_auto_id": subcategories,
    "home_component_auto_id": widget.homecomponent_id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    var url=baseUrl+'api/'+add_home_subcategories;
    var uri = Uri.parse(url);
    final response = await http.post(uri,body: body);
    if (response.statusCode == 200) {
      isAddProcessing=false;

    final resp=jsonDecode(response.body);
    String status=resp['status'];
    if(status=="1"){
      widget.onSaveCallback();
    }
    else{
      isAddProcessing=false;
      Fluttertoast.showToast(msg: "Something went wrong. Please try later", backgroundColor: Colors.grey,);
      if(mounted){
        setState(() {});
      }
    }
  }
    else if(response.statusCode==500){
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
      Fluttertoast.showToast(msg: "Server Error", backgroundColor: Colors.grey,);
    }

}

}

typedef OnchangeSelection =Function(List<String> selectedSubcategories);

class _MainCategory extends StatefulWidget {
  OnchangeSelection onchangeSelection;
  final GetmainCategorylist mainCategoryList;
  List<String> selectedSubcategories;
  String baseUrl;
  String admin_auto_id;
  String app_type_id;

  _MainCategory(this.onchangeSelection,this.mainCategoryList,this.selectedSubcategories,this.baseUrl,this.admin_auto_id,this.app_type_id);

  @override
  _MainCategoryState createState() => _MainCategoryState(mainCategoryList,selectedSubcategories,baseUrl,admin_auto_id,app_type_id);
}

class _MainCategoryState extends State<_MainCategory> {
  bool isApiCallProcessing=false;
  List<String> selectedSubcategories;
  String baseUrl;
  String admin_auto_id;
  String app_type_id;


  _MainCategoryState(this.mainCategory,this.selectedSubcategories,this.baseUrl,this.admin_auto_id,this.app_type_id);

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
            onLongPress: ()=>{
              showEditCategory(subCategoryList[index])
            },
              onTap: ()=>{
                if(isAdded(subCategoryList[index].id) ==true){
                  selectedSubcategories.remove(subCategoryList[index].id)
                }
                else{
                  if(selectedSubcategories.length<16){
                    selectedSubcategories.add(subCategoryList[index].id)
                  }
                  else{
                    Fluttertoast.showToast(msg: "Maximum 16 subcategories can be selected", backgroundColor: Colors.grey,)
                  }
                },

                widget.onchangeSelection(selectedSubcategories)
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
                      height: 60,
                      width: 60,
                      child:Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child:
                            subCategoryList[index].subcategoryImageApp.isNotEmpty?
                            CachedNetworkImage(
                              height: 60,
                              width: 60,
                              fit: BoxFit.fill,
                              imageUrl: baseUrl+sub_categories_base_url+subCategoryList[index].subcategoryImageApp,
                              placeholder: (context, url) =>
                                  Container(decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.grey[400],
                                  )),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ):
                            Container(
                                child:const Icon(Icons.error),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.grey[400],
                                )),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child:isAdded(subCategoryList[index].id)==true?
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.orange[300]
                              ),
                              child: Text(
                                getIndex(subCategoryList[index].id,),
                                style: const TextStyle(color: Colors.white,fontSize: 10),
                              ),
                            ):
                            Container(),
                          )
                        ],
                      )),
                  Text(
                    subCategoryList[index].subCategoryName,textAlign: TextAlign.center,style: const TextStyle(fontSize: 11),
                  )
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
      padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                mainCategory.categoryName,style: const TextStyle(color: Colors.black87,fontSize: 16),
              ),
              GestureDetector(
                  onTap: ()=>{
                    //Fluttertoast.showToast(msg: "These are main categroies", backgroundColor: Colors.grey,)
                  },
                  child: const Icon(Icons.info,color: Colors.grey,size: 15,)),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child:
                  GestureDetector(
                    onTap: ()=>{
                      showAddCategory()
                    },
                    child: const Icon(Icons.add_box_rounded,color: Colors.blue),
              ),),
              )
            ],
          ),
          const SizedBox(height: 7,),

          SizedBox(
              height: 200,
              child:
              isApiCallProcessing==true?
              showShimmer():
              subCategoryList.isNotEmpty?
              SizedBox(
               // alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height,
                child:
                GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 1/1,
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

  showAddCategory() {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return AddSubCategory(onAddListener,mainCategory.id);
        });
  }

  showEditCategory(GetmainSubcategorylist subCategory) {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return EditSubCategory(onAddListener,subCategory);
        });
  }

  onAddListener(){
    getSubCategories();
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

        //print(subCategoryList.toString());
        if(mounted){
          setState(() {});
        }
      }
    }
  }

  showShimmer(){
    GFShimmer(
      child: const Text(
        'GF Shimmer',
        style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700),
      ),
      showGradient: true,
      gradient: LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.centerLeft,
        stops: const <double>[0, 0.3, 0.6, 0.9, 1],
        colors: [
          Colors.teal.withOpacity(0.1),
          Colors.teal.withOpacity(0.3),
          Colors.teal.withOpacity(0.5),
          Colors.teal.withOpacity(0.7),
          Colors.teal.withOpacity(0.9),
        ],
      ),
    );
  }

  String getIndex(String id) {
    for(int i=0;i<widget.selectedSubcategories.length;i++){
      if(widget.selectedSubcategories[i]==id){
        return (i+1).toString();
      }
    }
    return "";
  }

  bool isAdded(String id){
    for(int i=0;i<widget.selectedSubcategories.length;i++){
      if(widget.selectedSubcategories[i]==id){
        return true;
      }
    }
    return false;
  }

}