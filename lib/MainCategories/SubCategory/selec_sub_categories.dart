// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/SubCategory/add_sub_category_ui.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/SubCategory/edit_sub_category_ui.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/sub_category_model.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import '../../../../Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getwidget/getwidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


typedef OnSaveCallback =Function();

class SelectSubCategory extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String homecomponent_id;
  String main_category_id;

  SelectSubCategory(this.onSaveCallback,this.homecomponent_id,this.main_category_id);

  @override
  _SelectSubCategory createState() => _SelectSubCategory();
}

class _SelectSubCategory extends State<SelectSubCategory> {
  List<String> selectedSubcategories=[];

  bool isApiCallProcessing=false;
  bool isAddProcessing=false;

  List<GetmainSubcategorylist> subCategoryList=[];

  String baseUrl='';
  String app_type_id="",admin_auto_id='';

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? apptypeid= prefs.getString('app_type_id');
    String? adminId = prefs.getString('admin_auto_id');
    if(baseUrl!=null && apptypeid!=null && adminId!=null){
      this.baseUrl=baseUrl;
      this.app_type_id=apptypeid;
      this.admin_auto_id=adminId;
      setState(() {});

      if(mounted){
        setState(() {
          isApiCallProcessing=true;
        });
      }
      getSubCategories();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.black87,size: 20,),
          onPressed: onBackPressed,
        ),
        title: Text('Subcategories ('+selectedSubcategories.length.toString()+'/16)' ,style: const TextStyle(color: Colors.black87,fontFamily:'Lato',fontSize: 16)),
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

             },
             child: const Text('Save',style: TextStyle(color: Colors.black87,fontFamily:'Lato',fontSize: 16),)
         )
        ],
      ),
        body:Container(
          child: Stack(
            children: <Widget>[
              subCategoryList.isNotEmpty?
              Container(
                  child:
                  SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 4,
                          physics: const ClampingScrollPhysics(),
                          //scrollDirection: Axis.horizontal,
                          children:subCategoryItems()
                      )
                  )
              ):
              isApiCallProcessing==true?
              Container():
              const Center(
                //  alignment: Alignment.center,
                child: Text('No data available'),
              ),

              isApiCallProcessing==true?
              Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: const GFLoader(
                    type:GFLoaderType.circle
                ) ,
              ) :
              Container()
            ],
          ),
        )
    );
  }

  showAddCategory() {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return AddSubCategory(onAddListener,widget.main_category_id);
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
      "main_category_auto_id": widget.main_category_id,
      "app_type_id": app_type_id,
      "admin_auto_id":admin_auto_id,
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
    for(int i=0;i<selectedSubcategories.length;i++){
      if(selectedSubcategories[i]==id){
        return (i+1).toString();
      }
    }
    return "";
  }

  bool isAdded(String id){
    for(int i=0;i<selectedSubcategories.length;i++){
      if(selectedSubcategories[i]==id){
        return true;
      }
    }
    return false;
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
              },
              child: Column(
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

}