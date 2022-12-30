import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Products/Choose_Subcategories_List.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Vendor_Module/Vendor_Home/Components/Rest_Apis.dart';
import '../../../../Admin_add_Product/Components/Product_List.dart';
import '../../../../Utils/App_Apis.dart';
import '../../../../Vendor_Module/Vendor_Home/Utils/home_style.dart';
import '../../MainCategories/main_category_model.dart';
import '../models/sub_category_model.dart';

class Choose_Main_Categories extends StatefulWidget {
  Choose_Main_Categories({Key? key}) : super(key: key);

  @override
  _Choose_Main_CategoriesState createState() => _Choose_Main_CategoriesState();
}

class _Choose_Main_CategoriesState extends State<Choose_Main_Categories> {
  int selected = -1;
  bool isApiCallProcessing = false;
  List<GetmainCategorylist> mainCategoryList = [];
  MainCategoryModel? mainCategory_Model;

  SubCategoryModel? subcategory_model_list;
  List<GetmainSubcategorylist>? sub_cat_List=[];

  String baseUrl='',user_id = '', main_cat_id = '',admin_auto_id="",app_type_id="";
  int iconStyle=100,layoutStyle=2;
  Color labelColor=Colors.grey,headerColor=Colors.black87;
  String labelFont='Lato',headerFont='Lato';
  double labelSize=12,headerSize=16;
  TextStyle labelStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:12,
      fontWeight: FontWeight.normal,
      color: Colors.grey);

  TextStyle headerStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:16,
      fontWeight: FontWeight.normal,
      color: Colors.black87);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text("Choose Main Category",
            style: TextStyle(
                color: appBarIconColor,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(Icons.arrow_back, color: appBarIconColor),
        ),
      ),
      bottomSheet: Checkout_Section(context),
      body:Stack(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: GridView.builder(
                itemCount: mainCategoryList.length,
                // The length Of the array
                physics: ScrollPhysics(),
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  crossAxisCount: subCategoryCrossAxisCount,
                ),
                itemBuilder: (context, index) => CategoryItem(
                  mainCategoryList[index].categoryName,
                  mainCategoryList[index].categoryImageApp,
                  index,
                ),
              )
          ),

          isApiCallProcessing == false &&
              mainCategoryList.isEmpty? Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: const Text('No main categories available'))
              : Container(),

          isApiCallProcessing == true ? Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: const GFLoader(type: GFLoaderType.circle),
          )
              : Container()

        ],
      ),
    );
  }

  Widget Checkout_Section(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 40,
            child: ElevatedButton(
              child: Center(
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: const Size(70,30),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                ),
              ),
              onPressed: () {
                if (main_cat_id == '') {
                  Fluttertoast.showToast(
                    msg: "Choose main category",
                    backgroundColor: Colors.grey,
                  );
                }
                else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => Choose_Subcategories(
                          main_cat_id: main_cat_id,
                        )),

                  );
                }
              },
            ),
          )),
    );
  }

  Widget CategoryItem(String name, String img, int index) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: selected == index ? Colors.green : Colors.grey,
                  width: 2)
              // isSelected ? kPrimaryColor : Colors.grey.shade100, width: 1.5),

              ),
          child: Container(
            height: 95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: img != ''
                      ? CachedNetworkImage(
                          height: 60,
                          width: 60,
                          imageUrl: baseUrl+main_categories_base_url + img,
                          placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey[400],
                          )),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )
                      : Container(
                          child: Icon(Icons.error),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey[400],
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Container(
                    height: 11,
                    child: Text(
                      name,
                      style: TextStyle(fontSize: 10, color: black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () => {
        if (mounted)
          {
            setState(() =>
                {selected = index, main_cat_id = mainCategoryList![index].id!})
          }
      },
    );
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');
    if (baseUrl!=null && adminId!=null && userId != null && apptypeid!=null) {
      if (mounted) {
        setState(() {
          this.baseUrl=baseUrl;
          user_id = userId;
          this.admin_auto_id=adminId;
          this.app_type_id=apptypeid;
          getMainCategories();
        });
      }
    }
    return null;
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

  void get_Subcategories(String main_cat_id) async {
    Rest_Apis restApis = new Rest_Apis();

    restApis.getSubcategory(baseUrl,main_cat_id,admin_auto_id,app_type_id).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            subcategory_model_list = value;
          });
        }

        if (subcategory_model_list != null) {
          if (mounted) {
            setState(() {
              sub_cat_List = subcategory_model_list?.getmainSubcategorylist;

              if (sub_cat_List!.length == 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => Product_List(
                            main_cat_id: main_cat_id,
                            sub_cat_id: "",brand_id: '', type: 'category', home_componet_id: '', offer_id: '',
                          )),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => Choose_Subcategories(
                            main_cat_id: main_cat_id,
                          )),

                );
              }
            });
          }
        }
      } else {
      }
    });
  }

 /* void get_Subcategories(String main_cat_id) async {
    final body = {
      "main_category_auto_id": main_cat_id,
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
        if (subcategory_model_list != null) {
          if (mounted) {
            setState(() {
              sub_cat_List =
              subcategory_model_list?.allProductsUnderSubcategories!;

              if (sub_cat_List!.length == 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => Product_List(
                        main_cat_id: main_cat_id,
                        sub_cat_id: "",
                      )),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => Choose_Subcategories(
                        main_cat_id: main_cat_id,
                        sub_cat_List: sub_cat_List,
                      )),
                );
              }
            });
          }
        }
        if(mounted){
          setState(() {});
        }
      }
    }
  }*/
}
