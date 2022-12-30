// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/home_main_category_details.dart';
import 'package:poultry_a2z/Home/Components/MainCategories/add_main_category_ui.dart';
import 'package:poultry_a2z/Home/Components/MainCategories/edit_main_category_ui.dart';
import 'package:poultry_a2z/Home/Components/MainCategories/main_category_model.dart';
import 'package:poultry_a2z/Home/Components/component_constants.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import '../../../../Utils/App_Apis.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getwidget/getwidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnSaveCallback =Function();

class SelectMainCategory extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String homecomponent_id;

  SelectMainCategory(this.onSaveCallback,this.homecomponent_id);

  @override
  _SelectMainCategory createState() => _SelectMainCategory();
}

class _SelectMainCategory extends State<SelectMainCategory> {

  List<String> selectedCategories=[];

  int iconStyle=100,layoutStyle=2;
  Color labelColor=Colors.grey,headerColor=Colors.black87;
  String labelFont='Lato',headerFont='Lato';
  double labelSize=12,headerSize=16;
  String headerTitle='';
  bool isApiCallProcessing=true;
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
        List<Content> selected=homeMainCategoryDetails.getHomeComponentList[0].content;

        for (var element in selected) {
          selectedCategories.add(element.maincategoryAutoId);
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
          icon: const Icon(Icons.arrow_back,color: appBarIconColor,size: 20,),
          onPressed: onBackPressed,
        ),
        title: Text('Main Categories ('+selectedCategories.length.toString()+')' ,
            style: const TextStyle(color: appBarIconColor,fontFamily:'Lato',fontSize: 16)),
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
               if(selectedCategories.isNotEmpty){
                 addHomeMainCategories()
               }
               else{
                 Fluttertoast.showToast(
                   msg: "Please select main categories",
                   backgroundColor: Colors.grey,)
               }
             },
             child: const Text('Save',style: TextStyle(color: appBarIconColor,fontFamily:'Lato',fontSize: 16),)
         )
        ],
      ),
      body:Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Container(
                  child: Text('Please select main categories',
                  style: TextStyle(color: Colors.black, fontSize: 15),),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                ),
                Expanded(
                    child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 4,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        physics: const ClampingScrollPhysics(),
                        //scrollDirection: Axis.horizontal,
                        children:categoryItems()
                    )
                )
              ],
            ),
          ),

          mainCategoryList.isEmpty && isApiCallProcessing==false?
          Center(
            child: Container(
              child:  ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                ),
                child: Text('Add Main Categories',style: TextStyle(color: Colors.white),),
                onPressed: () {
                  showAddCategory();
                },
              ),
              margin: const EdgeInsets.all(5),
            ),
          ):
          Container(),


          isApiCallProcessing==true?
          GFLoader(
              type:GFLoaderType.circle
          ):
          Container()

        ],
      )
    );
  }

  categoryItems(){
    List<Widget> items=[];

    items.add(
        GestureDetector(
            onTap: ()=>{
              showAddCategory()
            },
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black12
                    ),
                    margin: const EdgeInsets.all(5),
                    height: 60,
                    width: 60,
                    child:const Icon(Icons.add,color: Colors.black87,))
              ],
            )
        )
    );

    for(int index=0;index<mainCategoryList.length;index++){
      items.add(
          GestureDetector(
              onLongPress: ()=>{
                showEditCategory(mainCategoryList[index])
              },
              onTap: ()=>{
                setSelected(mainCategoryList[index].id)
              },
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: isAdded(mainCategoryList[index].id)==true ? Colors.blue  : Colors.grey,
                              width: 1
                          )
                      ),
                      margin: const EdgeInsets.all(5),
                      height: 60,
                      width: 60,
                      child:Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child:
                            mainCategoryList[index].categoryImageApp.isNotEmpty?
                            CachedNetworkImage(
                              fit: BoxFit.fill,
                              height: 60,
                              width: 60,
                              imageUrl: baseUrl+main_categories_base_url+mainCategoryList[index].categoryImageApp,
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
                            child:isAdded(mainCategoryList[index].id)==true?
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.orange[300]
                              ),
                              child: Text(
                                getIndex(mainCategoryList[index].id,),
                                style: const TextStyle(color: Colors.white,fontSize: 10),
                              ),
                            ):
                            Container(),
                          )
                        ],
                      )),
                  Text(
                    mainCategoryList[index].categoryName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.black87,fontSize: 11),
                  )
                ],
              )
          )
      );
    }
    return items;
  }

  bool isAdded(String id){
    for(int i=0;i<selectedCategories.length;i++){
      if(selectedCategories[i]==id){
        return true;
      }
    }
    return false;
  }

  String getIndex(String id) {
    for(int i=0;i<selectedCategories.length;i++){
      if(selectedCategories[i]==id){
        return (i+1).toString();
      }
    }
    return "";
  }

  setSelected(String id){
    if(isAdded(id) ==true){
      selectedCategories.remove(id);
    }
    else{
      selectedCategories.add(id);
    }
    setState(() {});
  }

  showAddCategory() {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return AddMainCategory(onAddMainCategorylistener);
        });
  }

  showEditCategory(GetmainCategorylist getmainCategorylist) {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return EditMainCategory(onAddMainCategorylistener,getmainCategorylist);
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

    final body = {
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

  onChangeSelection(List<String> selectedcategories){
    this.selectedCategories=selectedcategories;
    if(mounted){
      setState(() {});
    }
  }

  void addHomeMainCategories() async {

    if(mounted){
      setState(() {
        isAddProcessing=true;
      });
    }
    String maincategories='';

    for(int i=0;i<selectedCategories.length;i++){
      if(i==0){
        maincategories+=selectedCategories[i];
      }
      else{
        maincategories+='|'+selectedCategories[i];
      }
    }

    final body = {
    "main_category_auto_id": maincategories,
    "home_component_auto_id": widget.homecomponent_id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    print('body: '+body.toString());
    var url=baseUrl+'api/'+add_home_maincategories;
    var uri = Uri.parse(url);
    final response = await http.post(uri,body: body);

    print(response.toString());
    if (response.statusCode == 200) {
      isAddProcessing=false;

    final resp=jsonDecode(response.body);

      print('resp: '+resp.toString());

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