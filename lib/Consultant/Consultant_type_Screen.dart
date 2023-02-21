import 'dart:convert';
import 'package:poultry_a2z/settings/Add_Consultant_Type/Components/Consultant_Type_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Vendor_Module/Vendor_Home/Components/Model/Get_Brand_LIst_Model.dart';
import 'package:poultry_a2z/Vendor_Module/Vendor_add_Product/Components/Model/all_brands_model.dart';
import 'package:http/http.dart' as http;
import '../../Utils/App_Apis.dart';
import 'package:getwidget/getwidget.dart';

typedef OnSaveCallback = void Function(String consultant_types);

class Consultant_Type_Screen extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String selected_type;

  Consultant_Type_Screen(this.onSaveCallback, this.selected_type);

  @override
  _Consultant_Type_ScreenState createState() => _Consultant_Type_ScreenState();
}

class _Consultant_Type_ScreenState extends State<Consultant_Type_Screen> {
  bool isApiCallProcessing = false;
  String baseUrl = '',admin_auto_id='',app_type_id='';
  String user_id = '';
  String selectedConsultantType='';
  late Consulant_Type_model consulant_model;
  List<Consultant_typeList> getconsultant=[];
  List<String> selected_consultant_type = [];
  late Route routes;
  @override
  void initState() {
    super.initState();
    getBaseUrl();
    setData();
  }

  setData(){
    this.selected_consultant_type=widget.selected_type.split(',');
    if(this.mounted){
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 30,
            margin: EdgeInsets.only(top: 0, right: 10,left: 10),
            color: Colors.white,
            alignment: Alignment.bottomRight,
            child:Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap:()
                      {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel", style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    )
                    ,
                    const SizedBox(width: 10,),
                    GestureDetector(
                      onTap:()
                      {
                        widget.onSaveCallback(selectedConsultantType);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Select", style: TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                    )
                  ],
                )
            ),
          ),
        Container(
          height: MediaQuery.of(context).size.height/2.5,
          margin: const EdgeInsets.only(top: 10,bottom: 45),
          child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            child: isApiCallProcessing == false ?
            Container(
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                  itemCount: getconsultant.length,
                  // physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1 / 0.4,
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 22,
                            width: 22,
                            margin: const EdgeInsets.all(5),
                            child: Checkbox(
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() {
                                    if (isAdded(getconsultant[index].consultant_type) == true) {
                                      selected_consultant_type.remove(getconsultant[index].consultant_type);
                                      print(selected_consultant_type.toString());
                                      setCategory();
                                    }
                                    else {
                                      selected_consultant_type.add(getconsultant[index].consultant_type);
                                      print(selected_consultant_type.toString());
                                      setCategory();
                                    }
                                  });
                                }
                              },
                              value: isAdded(getconsultant[index].consultant_type),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              getconsultant[index].consultant_type,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ]),
                  )),
            ):
            getconsultant.isEmpty && isApiCallProcessing == false ?
            const Center(child: Text('No Consultant type')) :
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child:
              GFLoader(type: GFLoaderType.circle),
            ),
          )),
        ],)

    );
  }

  setCategory(){
    selectedConsultantType='';
    for(int index=0;index<selected_consultant_type.length;index++){

      if(index==0 || index==1){
        if(selectedConsultantType!='') {
          selectedConsultantType += ','+selected_consultant_type[index];
        }else{
          selectedConsultantType+=selected_consultant_type[index];
        }
      }
      else{
        selectedConsultantType+= ','+selected_consultant_type[index];
      }
    }
  }

  Future get_consultant_List() async {
    if(mounted){
          setState(() {
            isApiCallProcessing=true;
          });
        }
    var url=baseUrl+'api/'+get_consultant_type;

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
        Consulant_Type_model consultantListModel=Consulant_Type_model.fromJson(json.decode(response.body));
        getconsultant=consultantListModel.data;
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  // void get_consultant_List() async {
  //   if(mounted){
  //     setState(() {
  //       isApiCallProcessing=true;
  //     });
  //   }
  //
  //   var url = baseUrl+'api/' + get_consultant_type;
  //
  //   Uri uri=Uri.parse(url);
  //
  //   final body={
  //     "admin_auto_id":admin_auto_id,
  //   };
  //
  //   final response = await http.post(uri, body: body);
  //
  //   if (response.statusCode == 200) {
  //     final resp = jsonDecode(response.body);
  //
  //     int  status = resp['status'];
  //
  //     if (status == 1) {
  //       isApiCallProcessing=false;
  //       Consulant_Type_model consultantListModel=Consulant_Type_model.fromJson(json.decode(response.body));
  //       List<Consultant_typeList> getconsultant=consultantListModel.data;
  //       // if(Category_list.isNotEmpty)
  //       //   Category_list.clear();
  //       // for (var element in getconsultant) {
  //       //   Category_list.add(element.consultant_type);
  //       // }
  //     }
  //     else {
  //       isApiCallProcessing=false;
  //       print('empty');
  //     }
  //
  //     if(mounted){
  //       setState(() {});
  //     }
  //   }
  // }

  bool isAdded(String id) {
    for (int i = 0; i < selected_consultant_type.length; i++) {
      if (selected_consultant_type[i] == id) {
        return true;
      }
    }
    return false;
  }

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? baseUrl = prefs.getString('base_url');
    String? adminId= prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');
    if (userId != null && baseUrl != null && adminId!=null && apptypeid!=null) {
      setState(() {
        this.baseUrl = baseUrl;
        this.admin_auto_id = adminId;
        this.app_type_id=apptypeid;
        get_consultant_List();
      });
    }
    return null;
  }
}
