import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../Vendor_Module/Vendor_Home/Components/Rest_Apis.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Admin_add_Product/Components/Product_List.dart';
import '../../../../Vendor_Module/Vendor_Home/Components/Vendor_Product_List.dart';
import '../models/sub_category_model.dart';

class Choose_Subcategories extends StatefulWidget {

   Choose_Subcategories({Key? key,required this.main_cat_id,})
       : super(key: key);
   String main_cat_id;

  @override
  _Choose_SubcategoriesState createState() => _Choose_SubcategoriesState();
}

class _Choose_SubcategoriesState extends State<Choose_Subcategories> {
  int selected = -1;
  String sub_cat_id = '';
  String baseUrl='',user_id = '', main_cat_id = '',admin_auto_id="",app_type_id="";
  int iconStyle=100,layoutStyle=2;
  Color labelColor=Colors.grey,headerColor=Colors.black87;
  String labelFont='Lato',headerFont='Lato';
  double labelSize=12,headerSize=16;
  TextStyle labelStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:12,
      fontWeight: FontWeight.normal,
      color: Colors.grey);

  List<GetmainSubcategorylist> sub_cat_List = [];

  bool isApiCallProcessing = false;

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
          this.user_id = userId;
          this.admin_auto_id=adminId;
          this.app_type_id=apptypeid;

          get_Subcategories(widget.main_cat_id);
        });
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text(
              "Choose Sub-Category",
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
              child: SafeArea(
                child: Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 3.0, right: 3),
                          child: SingleChildScrollView(
                            child: Container(
                              height: MediaQuery.of(context).size.height/1.25,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [BoxShadow(color: Color(0xffECF0F1), spreadRadius: 1)],
                                color: Colors.white,
                              ),
                              child: GridView.builder(
                                itemCount: sub_cat_List.length,
                                // The length Of the array
                                physics: ScrollPhysics(),
                                padding: EdgeInsets.all(0),
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 2,
                                  crossAxisCount: 4,
                                ),
                                itemBuilder: (context, index) =>  CategoryItem(
                                  sub_cat_List[index].subCategoryName,
                                  sub_cat_List[index].subcategoryImageApp,
                                  index,
                                ),
                              ),
                            ),)
                      ),
                    ],
                  ),
                ),
              )),

          isApiCallProcessing == false &&
              sub_cat_List.isEmpty? Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: const Text('No subcategories available'))
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => Product_List(main_cat_id: widget.main_cat_id,
                        sub_cat_id: sub_cat_id, brand_id: '', type: 'add_product', home_componet_id: '', offer_id: '',)),
                );

/*
                if(sub_cat_id == '')
                {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => Product_List(main_cat_id: widget.main_cat_id, sub_cat_id: '',
                          brand_id: '', type: 'add_product', home_componet_id: '', offer_id: '',)),
                  );
                }
                else{

                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => Product_List(main_cat_id: widget.main_cat_id,
                          sub_cat_id: sub_cat_id, brand_id: '', type: 'add_product', home_componet_id: '', offer_id: '',)),
                  );
                }
*/

              },
            ),
          )),
    );
  }

  Widget CategoryItem(String name, String img, int index) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: img != ''
                        ? CachedNetworkImage(
                      height: 45,
                      width: 45,
                      imageUrl: baseUrl+sub_categories_base_url+img,
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
                Padding(
                  padding:  EdgeInsets.all(3.0),
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
      onTap: () =>
      {
        if(mounted)
          {
            setState(() =>
            {
              selected = index,

              sub_cat_id = sub_cat_List[index].id

            })
          }

      },
    );
  }

  void get_Subcategories(String main_cat_id) async {

    if(this.mounted){
      setState(() {
        isApiCallProcessing = true;
      });
    }
    Rest_Apis restApis = new Rest_Apis();

    restApis.getSubcategory(baseUrl,main_cat_id,admin_auto_id,app_type_id).then((value) {
      if (value != null) {
        SubCategoryModel subcategory_model_list = value;

        if (subcategory_model_list != null) {
          if (this.mounted) {
            setState(() {
              sub_cat_List = subcategory_model_list.getmainSubcategorylist;
              isApiCallProcessing = false;
            });
          }
        }
      }
      else {
        sub_cat_List = [];

        if(this.mounted){
          setState(() {
            isApiCallProcessing =false;
          });
        }
      }
    });
  }

}
