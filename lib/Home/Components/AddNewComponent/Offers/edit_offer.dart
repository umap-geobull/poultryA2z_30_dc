import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/show_color_picker.dart';
import 'package:poultry_a2z/Admin_add_Product/constants.dart';
import 'package:poultry_a2z/Home/Components/component_constants.dart';
import 'package:poultry_a2z/Home/Components/title_alignment.dart';
import 'package:poultry_a2z/Home/Components/title_background.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import '../../../../Utils/App_Apis.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:getwidget/getwidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../MainCategories/main_category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';

import '../models/home_offer_details.dart';

typedef OnSaveCallback = void Function();

class EditOffer extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String component_id;

  EditOffer(this.onSaveCallback,this.component_id);

  @override
  _EditOffer createState() => _EditOffer(component_id);
}

class _EditOffer extends State<EditOffer> {
  String component_id;

  _EditOffer(this.component_id);

  double slider_height=200;
  Color pickerColor = const Color(0xff443a49), backgroundColor=Colors.white,
      title_backgroundColor=Colors.transparent;

  String title_alignment = '';

  late XFile pickedImageFile;

  bool isIconSelected=false;
  final ImagePicker _picker = ImagePicker();

  bool isApiCallProcessing=false,isEditApiProcessing=false;

  bool isImageSelected=false;
  late File selectedImage;

  List<String> selectedMainCategory=[];
  List<GetmainCategorylist> mainCategoryList=[];
  bool showOnHome=false;

  List<Widget> layoutTypeList=[];
  List<Widget> webLayoutTypeList=[];
  TextStyle appHeaderStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:17,
      fontWeight: FontWeight.normal,
      color: Colors.black87);

  String appHeaderFont='Lato',headerTitle='';
  double appFontSize=17;
  Color appHeaderColor=Colors.black87;
  final TextEditingController _HeaderTextController=TextEditingController();
  bool editHeaderVisible=false;
  late GetHomeComponentList offerDetails;
  int app_layout=0,web_layout=0;

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
      getOfferDetails();
      getMainCategories();
    }
  }

  setLayouts(){
    layoutTypeList.add(
        Container(
          height: 90,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                    child: GridView.builder(
                      itemCount: 6,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          crossAxisCount: 6,
                          childAspectRatio: 1/1.4
                      ),
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey[300]
                        ),
                      ),
                    )
                ),
              ),
              Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.arrow_back,size: 12,
                          color: Colors.grey[400]
                      ),
                      Icon(Icons.arrow_forward,size: 12,
                          color: Colors.grey[400]
                      ),
                    ],
                  )
              ),
              const SizedBox(height: 10,),
              const Text('280 x 340 px',style: TextStyle(fontSize: 7),)
            ],
          ),
        )
    );

    layoutTypeList.add(
        Container(
          height: 90,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: GridView.builder(
                itemCount: 8,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                    crossAxisCount: 4,
                    childAspectRatio: 1/1.4
                ),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[300]
                  ),
                ),
              )),
              const SizedBox(height: 10,),
              const Text('280 x 340 px',style: TextStyle(fontSize: 7),)

            ],
          ),
        )
    );

    layoutTypeList.add(
        Container(
          height: 90,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                    child: GridView.builder(
                      itemCount: 3,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey[300]
                        ),
                      ),
                    )
                ),
              ),
              const SizedBox(height: 10,),
              const Text('600 x 600 px',style: TextStyle(fontSize: 7),)
            ],
          ),
        )
    );

    layoutTypeList.add(
        Container(
          height: 90,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                    child: GridView.builder(
                      itemCount: 4,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          crossAxisCount: 2,
                          childAspectRatio: 3/1
                      ),
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey[300]
                        ),
                      ),
                    )
                ),
              ),
              const SizedBox(height: 10,),
              const Text('980 x 300 px',style: TextStyle(fontSize: 7),)
            ],
          ),
        )
    );

    layoutTypeList.add(
        Container(
          height: 90,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                    child: GridView.builder(
                      itemCount: 1,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          crossAxisCount: 1,
                          childAspectRatio: 4/1
                      ),
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey[300]
                        ),
                      ),
                    )
                ),
              ),
              const SizedBox(height: 10,),
              const Text('1920 x 525 px',style: TextStyle(fontSize: 7),)
            ],
          ),
        )
    );

    layoutTypeList.add(
        Container(
          height: 90,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                    child: GridView.builder(
                      itemCount: 1,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          crossAxisCount: 1,
                          childAspectRatio: 4/2
                      ),
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey[300]
                        ),
                      ),
                    )
                ),
              ),
              const SizedBox(height: 10,),
              const Text('1920 x 650 px',style: TextStyle(fontSize: 7),)
            ],
          ),
        )
    );

    layoutTypeList.add(
        Container(
          height: 90,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                    child: GridView.builder(
                      itemCount: 1,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          crossAxisCount: 1,
                          childAspectRatio: 4/2
                      ),
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5)
                        ),
                      ),
                    )
                ),
              ),
              Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.arrow_back,size: 12,
                          color: Colors.grey[400]
                      ),
                      Icon(Icons.arrow_forward,size: 12,
                          color: Colors.grey[400]
                      ),
                    ],
                  )
              ),
              const SizedBox(height: 10,),
              const Text('1920 x 650 px',style: TextStyle(fontSize: 7),)
            ],
          ),
        )
    );


    //web

    //0
    webLayoutTypeList.add(
        Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  height: 30,
                  child: GridView.builder(
                    itemCount: 6,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      crossAxisCount: 6,
                    ),
                    itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.grey[300]
                      ),
                    ),
                  )
              ),
              Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.arrow_back,size: 12,
                          color: Colors.grey[400]
                      ),
                      Icon(Icons.arrow_forward,size: 12,
                          color: Colors.grey[400]
                      ),
                    ],
                  )
              )
            ],
          ),
        )
    );

    //1
    webLayoutTypeList.add(
        Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  height: 30,
                  child: GridView.builder(
                    itemCount: 12,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      crossAxisCount: 6,
                    ),
                    itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.grey[300]
                      ),
                    ),
                  )
              ),
              Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.arrow_back,size: 12,
                          color: Colors.grey[400]
                      ),
                      Icon(Icons.arrow_forward,size: 12,
                          color: Colors.grey[400]
                      ),
                    ],
                  )
              )
            ],
          ),
        )
    );

    //2
    webLayoutTypeList.add(
        Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[300]
                  ),
                ),
              )
              )
            ],
          ),
        )
    );

    //3
    webLayoutTypeList.add(
        Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: GridView.builder(
                itemCount: 16,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  crossAxisCount: 4,
                ),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[300]
                  ),
                ),
              )
              )
            ],
          ),
        )
    );

    //4
    webLayoutTypeList.add(
        Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: GridView.builder(
                itemCount: 36,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  crossAxisCount: 6,
                ),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[300]
                  ),
                ),
              )
              )
            ],
          ),
        )
    );

    //5
    webLayoutTypeList.add(
        Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          child: SizedBox(
              height: 30,
              child: GridView.builder(
                itemCount: 7,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  crossAxisCount: 7,
                ),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[300]
                  ),
                ),
              )
          ),
        )
    );

    //6
    webLayoutTypeList.add(
        Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: GridView.builder(
                itemCount: 8,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  crossAxisCount: 4,
                ),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[300]
                  ),
                ),
              )
              )
            ],
          ),
        )
    );

    webLayoutTypeList.add(
        Container(
          height: 90,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: GridView.builder(
                itemCount: 24,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1/1.4,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  crossAxisCount: 8,
                ),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[300]
                  ),
                ),
              )),
              const SizedBox(height: 10,),
              const Text('244 x 303 px',style: TextStyle(fontSize: 7),)
            ],
          ),
        )
    );

    webLayoutTypeList.add(
        Container(
          height: 90,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: GridView.builder(
                itemCount: 14,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1/1.4,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  crossAxisCount: 7,
                ),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[300]
                  ),
                ),
              )),
              const SizedBox(height: 10,),
              const Text('280 x 326 px',style: TextStyle(fontSize: 7),)

            ],
          ),
        )
    );

    webLayoutTypeList.add(
        Container(
          height: 90,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: GridView.builder(
                itemCount: 16,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1/1.3,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  crossAxisCount: 8,
                ),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[300]
                  ),
                ),
              )
              ),
              const SizedBox(height: 10,),
              const Text('244 x 299 px',style: TextStyle(fontSize: 7),)

            ],
          ),
        )
    );

    webLayoutTypeList.add(
        Container(
          height: 90,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                    child: GridView.builder(
                      itemCount: 8,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          crossAxisCount: 8,
                          childAspectRatio: 1/1.4
                      ),
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey[300]
                        ),
                      ),
                    )
                ),
              ),
              const SizedBox(height: 10,),
              const Text('244 x 316 px',style: TextStyle(fontSize: 7),)
            ],
          ),
        )
    );

    webLayoutTypeList.add(
        Container(
          height: 90,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                    child: GridView.builder(
                      itemCount: 3,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey[300]
                        ),
                      ),
                    )
                ),
              ),
              const SizedBox(height: 10,),
              const Text('600 x 600 px',style: TextStyle(fontSize: 7),)
            ],
          ),
        )
    );

    webLayoutTypeList.add(
        Container(
          height: 90,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                    child: GridView.builder(
                      itemCount: 4,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          crossAxisCount: 2,
                          childAspectRatio: 3/1
                      ),
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey[300]
                        ),
                      ),
                    )
                ),
              ),
              const SizedBox(height: 10,),
              const Text('980 x 300 px',style: TextStyle(fontSize: 7),)
            ],
          ),
        )
    );

    webLayoutTypeList.add(
        Container(
          height: 90,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                    child: GridView.builder(
                      itemCount: 1,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          crossAxisCount: 1,
                          childAspectRatio: 4/1
                      ),
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey[300]
                        ),
                      ),
                    )
                ),
              ),
              const SizedBox(height: 10,),
              const Text('1920 x 525 px',style: TextStyle(fontSize: 7),)
            ],
          ),
        )
    );
    /*  //7
    webLayoutTypeList.add(
        Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: GridView.builder(
                itemCount: 24,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  crossAxisCount: 8,
                ),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[300]
                  ),
                ),
              )
              )
            ],
          ),
        )
    );

    //8
    webLayoutTypeList.add(
        Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: GridView.builder(
                itemCount: 14,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  crossAxisCount: 7,
                ),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[300]
                  ),
                ),
              )
              )
            ],
          ),
        )
    );

    //9
    webLayoutTypeList.add(
        Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: GridView.builder(
                itemCount: 16,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  crossAxisCount: 8,
                ),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[300]
                  ),
                ),
              )
              )
            ],
          ),
        )
    );

    //10
    webLayoutTypeList.add(
        Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: GridView.builder(
                itemCount: 8,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  crossAxisCount: 8,
                ),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[300]
                  ),
                ),
              )
              )
            ],
          ),
        )
    );

    //11
    webLayoutTypeList.add(
        Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
            child:  GridView.builder(
              itemCount: 3,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1/0.5,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.grey[300]
                ),
              ),
            )

        )
    );*/
  }

  selectLayoutType() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 140,
      margin: const EdgeInsets.only(left: 10,right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Select layout type(App)',style: TextStyle(color: Colors.black87,fontSize: 16, ),),
          const SizedBox(height: 20,),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: layoutTypeList.length,
              itemBuilder: (context, index) => GestureDetector(
                  onTap: ()=> {
                    appLayoutListener(index),
                  },
                  child: Container(
                    height: 140,
                    width: 90,
                   // alignment: Alignment.center,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: getAppLayoutDecoration(index),
                    child: layoutTypeList[index],
                  )
              ),
            ),)
        ],
      ),
    );
  }

  selectWebLayoutType() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 140,
      margin: const EdgeInsets.only(left: 10,right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Select layout type(Web)',style: TextStyle(color: Colors.black87,fontSize: 16, ),),
          const SizedBox(height: 20,),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: webLayoutTypeList.length,
              itemBuilder: (context, index) => GestureDetector(
                  onTap: ()=> {
                    webLayoutListener(index),
                  },
                  child: Container(
                    height: 140,
                    width: 90,
                    // alignment: Alignment.center,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: getWebLayoutDecoration(index),
                    child: webLayoutTypeList[index],
                  )
              ),
            ),)
        ],
      ),
    );
  }

  void webLayoutListener(int index){
    setState(() {
      web_layout=index;
    });
  }

  BoxDecoration getWebLayoutDecoration(int index){
    if(index==web_layout){
      return BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.orange,
              width: 2));
    }
    else{
      return BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.blueGrey,
              width: 1));
    }

  }

  BoxDecoration getAppLayoutDecoration(int index){
    if(index==app_layout){
      return BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.orange,
              width: 2));
    }
    else{
      return BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.blueGrey,
              width: 1));
    }

  }

  void appLayoutListener(int index){
    setState(() {
      app_layout=index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setLayouts();

    getBaseUrl();
  }

  bool isAdded(String id){
    for(int i=0;i<selectedMainCategory.length;i++){
      if(selectedMainCategory[i]==id){
        return true;
      }
    }
    return false;
  }

  showInUi(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('  Show In',style: TextStyle(color: Colors.black87,fontSize: 18,fontWeight: FontWeight.bold),),
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width,
          child:  Row(
              mainAxisAlignment:  MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 25,
                  width: 25,
                  child: Checkbox(
                    
                    onChanged: (value) {
                      if(mounted){
                        setState(() {
                          showOnHome=value!;
                        });
                      }
                    },
                    value: showOnHome,
                  ),
                  margin: const EdgeInsets.all(5),
                ),
                const Flexible(
                  child: Text(
                    'Home Screen',
                    style: TextStyle(fontSize: 15, color: Colors.black, ),
                  ),
                )
              ]
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 250,
          child:  GridView.builder(
              itemCount: mainCategoryList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1/0.4,
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) =>
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child:
                    Row(
                        mainAxisAlignment:  MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 25,
                            width: 25,

                            child: Checkbox(
                              
                              onChanged: (value) {
                                if(mounted){
                                  setState(() {
                                    if(isAdded(mainCategoryList[index].id)==true){
                                      selectedMainCategory.remove(mainCategoryList[index].id);
                                    }
                                    else{
                                      selectedMainCategory.add(mainCategoryList[index].id);
                                    }
                                  });
                                }
                              },
                              value: isAdded(mainCategoryList[index].id),
                            ),
                            margin: const EdgeInsets.all(5),
                          ),
                          Flexible(
                            child: Text(
                              //'fjdw[g fpfj jqfp[0j [fjo[',
                              mainCategoryList[index].categoryName,
                              style: const TextStyle(fontSize: 14, color: Colors.black, ),
                            ),
                          )
                        ]
                    ),
                  )

          ),
        )

      ],
    );
  }

  void getMainCategories() async {
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
      Fluttertoast.showToast(msg: "Server error in getting main categoires", backgroundColor: Colors.grey,);
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
        title:const Text('Edit offers',style: TextStyle(color:appBarIconColor,fontFamily:'Lato',fontSize: 16),),
        actions: [
          isEditApiProcessing==true?
          const SizedBox(
            width: 80,
            child: GFLoader(
                type:GFLoaderType.circle
            ),
          ):
          TextButton(
              onPressed: ()=>{
                if(showOnHome==false && selectedMainCategory.length==1){
                  Fluttertoast.showToast(msg: home_component_show_in_msg,
                      backgroundColor: Colors.grey,toastLength:Toast.LENGTH_LONG)
                }
                else{
                  ediHomeComponentApi()
                }
                },
              child: const Text('Save',style: TextStyle(color: appBarIconColor,fontFamily:'Lato',fontSize: 16),)
          )
        ],
      ),
      body: SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            child: Column(
              children: <Widget>[
                isApiCallProcessing==true?
                Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 80,
                    child: GFLoader(
                        type:GFLoaderType.circle
                    ),
                  ),
                ):
                Container(
                      child: Column(
                        children: <Widget>[
                          selectHeaderFont(),
                          selectLayoutType(),
                          const Divider(
                            height: 10,
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('  Background color',style: TextStyle(color: Colors.black87,fontSize: 18,fontWeight: FontWeight.bold),),

                              GestureDetector(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width: 1,color: Colors.black)
                                  ),
                                  margin: EdgeInsets.all(10),
                                  child: Text('Select Background Color',style: TextStyle(color: Colors.black),),
                                ),
                                onTap: () {
                                  showBackgroundColorChooser();
                                },
                              )

                            ],
                          ),
                          const SizedBox(height: 10,),
                          selectWebLayoutType(),
                          const SizedBox(height: 20,),
                          showInUi(),
                        ],
                      ),
                    )
              ],
            )
        ),)
      ,
    );
  }

  selectHeaderFont() {
    appHeaderStyle= GoogleFonts.getFont(appHeaderFont).copyWith(
        fontSize:appFontSize,
        fontWeight: FontWeight.normal,
        color: appHeaderColor);

    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: const Text('Header font',style: TextStyle(color: Colors.black87,fontSize: 16),),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: TextFormField(
                        autofocus: false,
                        controller: _HeaderTextController,
                        style: appHeaderStyle,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                          hintText: 'Please enter header text',
                          hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                        ),
                      )
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: ()=>{
                        visibleHeaderEdit()
                      },
                      icon: const Icon(Icons.edit,color: Colors.orange,),
                    ),
                  )
                ],
              ),
            ],
          ),

          Visibility(
            visible: editHeaderVisible,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                            children: <Widget>[
                              GestureDetector(
                                  child:
                                  Container(
                                    child: Row(
                                      children: const <Widget>[
                                        Icon(Icons.font_download,color: Colors.blue,size: 30,)    ,
                                        SizedBox(width: 10,),
                                        Text("Change Font",style: TextStyle(fontSize: 13),),
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                    ),
                                    margin: const EdgeInsets.all(10),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                  ),
                                  onTap: ()=> {
                                    appHeaderFontChooser()
                                  }
                              ),
                              SelectableText(appHeaderFont,style: TextStyle(color: Colors.black,fontSize: 16,),)
                            ]
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                alignment: Alignment.center,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Icon(Icons.color_lens_outlined,color: Colors.blue,size: 30,),
                                    SizedBox(width: 10,),
                                    Text("Change Color",style: TextStyle(fontSize: 13),),
                                  ],
                                ),
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(5),

                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                              ),
                              onTap: ()=>{appHeaderColorChooser()},
                            ),
                            SelectableText(appHeaderColor.toString().replaceRange(6, 10, '#'),style: TextStyle(color: Colors.black,fontSize: 16,),)
                          ],
                        ),
                      )
                    ],
                  ),

                  Divider(),

                  TitleAlignment(title_alignment, onAlignmentChangeCallback),

                  Divider(),

                  TitleBackground(title_backgroundColor, onTitleBgChangeCallback)
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }

  void onAlignmentChangeCallback(String alignment) {
    if(this.mounted){
      setState(() {
        title_alignment = alignment;
      });
    }
  }

  void onTitleBgChangeCallback(Color color) {
    if(this.mounted){
      setState(() {
        title_backgroundColor = color;
      });
    }
  }

  appHeaderFontChooser(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
              content: SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: FontPicker(
                    showInDialog: true,
                    onFontChanged: (font) {
                      updateAppHeaderTextStyle(font);
                    },
                    //  googleFonts: _myGoogleFonts
                  ),
                ),
              ));
        }
    );
  }

  appHeaderColorChooser() {
    showDialog(
        context: context,
        builder: (context){
          return ShowColorPicker(onSaveCallback: updateAppHeaderColor,pickerColor: appHeaderColor,);
        }
    );
  }

  void updateAppHeaderTextStyle(PickerFont font){
    setState(() {
      appHeaderFont=font.fontFamily;
    });
  }

  void updateAppHeaderColor(Color color){

    if(mounted){
      setState(() {
        appHeaderColor=color;
      });
      Navigator.pop(context);
    }
  }

  visibleHeaderEdit(){
    setState(() {
      editHeaderVisible=true;
    });
  }

  onBackPressed() async{
    widget.onSaveCallback();
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void updateBackgroundColor(Color color){

    setState(() {
      backgroundColor=color;
    });

    Navigator.pop(context);

  }

  showBackgroundColorChooser() {
    showDialog(
        context: context,
        builder: (context){
          return ShowColorPicker(onSaveCallback: updateBackgroundColor, pickerColor: backgroundColor ,);
        }
    );
  }

  Future getOfferDetails() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "component_auto_id":component_id,
      "component_type":OFFERS,
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
        OfferHomeComponetDetails offerHomeComponetDetails=OfferHomeComponetDetails.fromJson(json.decode(response.body));
        offerDetails=offerHomeComponetDetails.getHomeComponentList[0];

        setStyleData(offerDetails);

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

  setStyleData(GetHomeComponentList homeComponent) {

    String showCategory=homeComponent.show_in_category;

    selectedMainCategory=showCategory.split('|');

    if(homeComponent.show_on_home=='true'){
      showOnHome=true;
    }
    else{
      showOnHome=false;
    }

    if(homeComponent.title.isNotEmpty){
      _HeaderTextController.text=homeComponent.title;
      headerTitle=homeComponent.title;
    }
    if(homeComponent.layoutType.isNotEmpty){
      app_layout=int.parse(homeComponent.layoutType);
    }
    if(homeComponent.titleFont.isNotEmpty){
      appHeaderFont=homeComponent.titleFont;
    }
    if(homeComponent.titleColor.isNotEmpty){
      appHeaderColor=Color(int.parse(homeComponent.titleColor));
    }
    if(homeComponent.webLayoutType.isNotEmpty){
      web_layout=int.parse(homeComponent.webLayoutType);
    }
    if(homeComponent.backgroundColor.isNotEmpty){
      backgroundColor=Color(int.parse(homeComponent.backgroundColor));
    }
    if(homeComponent.titleBackground.isNotEmpty){
      title_backgroundColor=Color(int.parse(homeComponent.titleBackground));
    }
    if(homeComponent.titleAlignment.isNotEmpty){
      title_alignment=homeComponent.titleAlignment;
    }

    if(mounted){
      setState(() {});
    }
  }

  Future ediHomeComponentApi() async {
    String mainCategory='';
    for(int i=0;i<selectedMainCategory.length;i++){
      if(i==0){
        mainCategory+=selectedMainCategory[i];
      }
      else{
        mainCategory += '|'+selectedMainCategory[i];
      }
    }

    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      'homecomponent_auto_id':component_id,
      "component_type":OFFERS,
      "title":_HeaderTextController.text,
      "background_color":backgroundColor.value.toString(),
      "height":slider_height.toString(),
      "icon_type":'',
      "layout_type":app_layout.toString(),
      "title_font":appHeaderFont,
      "title_color":appHeaderColor.value.toString(),
      "title_size":appFontSize.toString(),
      "label_font":'',
      "label_color":'',
      "web_background_color":'',
      "web_height":'',
      "web_icon_type":'',
      "web_layout_type":web_layout.toString(),
      "web_title_color":'',
      "web_title_font":'',
      "show_in_category":mainCategory,
      "show_on_home":showOnHome.toString(),
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
      "title_background": title_backgroundColor.value.toString(),
      "title_alignment": title_alignment,
    };

    var url=baseUrl+'api/'+edit_home_component;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      String status=resp['status'];
      if(status=="1"){
        widget.onSaveCallback();
      }
      else{
        if(mounted){
          setState(() {
            isApiCallProcessing=false;
          });
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

