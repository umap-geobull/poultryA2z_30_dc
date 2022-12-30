import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/add_home_component_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../../Utils/App_Apis.dart';
import '../component_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';


typedef OnSaveCallback = void Function(String type,String componentId);

class SelectType extends StatefulWidget {

  OnSaveCallback onSaveCallback;

  @override
  _SelectType createState() => _SelectType();

  SelectType(this.onSaveCallback,);
}

class _SelectType extends State<SelectType> {

  Color pickerColor = const Color(0xff443a49);

  TextStyle selectedStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:12,
      fontWeight: FontWeight.normal,
      color: Colors.black87);

  TextStyle webSelectedStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:12,
      fontWeight: FontWeight.normal,
      color: Colors.black87);

  List<Widget> iconTypeList=[];

  List<String> componentTypeList=[
    MAIN_CATEGORY,
    SHOP_BY_CATEGORY,
    SHOP_BY_BRANDS,
    PRODUCTS,
    SLIDER,
    BANNER,
    OFFERS,
    RECOMMENDED_PRODUCTS,
    ];

  bool isApiProcessing=false;

  String baseUrl='',admin_auto_id='',app_type_id='';

  Color selectedColor=Colors.transparent;
  Color titleColor=Colors.black87;
  Color labelColor=Colors.black54;

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? adminId= prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');

    if(baseUrl!=null){
      this.baseUrl=baseUrl;
      setState(() {});
    }

    if(adminId!=null){
      if(this.mounted){
        setState(() {
          admin_auto_id=adminId;
          print("admn_id: "+admin_auto_id);
        });
      }
    }
    if(apptypeid!=null){
      if(this.mounted){
        setState(() {
          app_type_id=apptypeid;
          print("apptype_id: "+app_type_id);
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Material(
          child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 100),
              child:Container(
                height: 500,
               // padding: EdgeInsets.only(bottom: 50),
                child:Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: ()=>{Navigator.pop(context)},
                              icon: const Icon(Icons.close),
                            ),
                            const Text('  Select component type',style: TextStyle(color: Colors.black87),),
                          ],
                        ),
                        const Divider(
                          height: 10,
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 10,),
                        Expanded(child:
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                           // scrollDirection: Axis.vertical,
                          //  shrinkWrap: true,
                            itemCount: componentTypeList.length,
                            itemBuilder: (context, index) =>
                                GestureDetector(
                                  onTap: ()=>{
                                    if(isApiProcessing==false){
                                      addHomeComponentApi(componentTypeList[index])
                                    }
                                    // goToNextScreen(componentTypeList[index],'')
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey,
                                            width: 1
                                        ),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Text(componentTypeList[index]),
                                  ),
                                ))
                        )
                      ],
                    ),
                    Center(
                      //alignment: Alignment.center,
                     // height: MediaQuery.of(context).size.height,
                      child:  isApiProcessing==true?
                      const SizedBox(
                        width: 80,
                        child: GFLoader(
                            type:GFLoaderType.circle
                        ),
                      ):
                      Container(),
                    )
                  ],
                )
              )
            ),
          )
      );
    }
    );
  }

  Future addHomeComponentApi(String componentType) async {
    if(mounted){
      setState(() {
        isApiProcessing=true;
      });
    }

    final body = {
      "component_type":componentType,
      "title":componentType,
      "background_color":selectedColor.value.toString(),
      "height":"200",
      "icon_type":'0',
      "layout_type":'0',
      "title_font":'Lato',
      "title_color":titleColor.value.toString(),
      "title_size":'',
      "label_font":'Lato',
      "label_color":labelColor.value.toString(),
      "web_background_color":selectedColor.value.toString(),
      "web_height":'200',
      "web_icon_type":'0',
      "web_layout_type":'0',
      "web_title_color":titleColor.value.toString(),
      "web_title_font":'Lato',
      "show_in_category":"",
      "show_on_home":"true",
      "web_code":'',
      "admin_auto_id": admin_auto_id,
      "app_type_id": app_type_id,
      "title_background": selectedColor.value.toString(),
      "title_alignment": 'start',
    };

    print("admn_id: "+admin_auto_id);
    print("title_color: "+titleColor.value.toString());
    print("bg_color: "+selectedColor.value.toString());
    print("label_color: "+labelColor.value.toString());

    var url=baseUrl+'api/'+add_home_component;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      String status=resp['status'];
      if(status=='1'){
        AddHomeComponetModel addHomeComponentModel=AddHomeComponetModel.fromJson(json.decode(response.body));
        String componentAutoId=addHomeComponentModel.data.id;
        Fluttertoast.showToast(msg: "Component added successfully", backgroundColor: Colors.grey,);
        widget.onSaveCallback(componentType,componentAutoId);
        // Navigator.pop(context);
        // goToNextScreen(component_type,component_auto_id);
        //  Navigator.pop(context);
      }
      else{
        Fluttertoast.showToast(msg: "Something went wrong. Please try later", backgroundColor: Colors.grey,);
        if(mounted){
          setState(() {
            isApiProcessing=false;
          });
        }
      }
    }
    else  if (response.statusCode == 500) {
      Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
      if(mounted){
        setState(() {
          isApiProcessing=false;
        });
      }
    }
  }
}