import 'dart:convert';
import 'package:poultry_a2z/settings/Add_Consultant_Type/Components/Consultant_Type_model.dart';
import 'package:poultry_a2z/settings/Add_Specialization/Components/SpecializationModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Utils/App_Apis.dart';
import 'package:getwidget/getwidget.dart';

typedef OnSaveCallback = void Function(String specialization_types);

class Specialization_bottomsheet extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String selected_type;

  Specialization_bottomsheet(this.onSaveCallback, this.selected_type);

  @override
  _Specialization_bottomsheetState createState() => _Specialization_bottomsheetState();
}

class _Specialization_bottomsheetState extends State<Specialization_bottomsheet> {
  bool isApiCallProcessing = false;
  String baseUrl = '',admin_auto_id='',app_type_id='';
  String user_id = '';
  String selectedspecialization='';
  List<SpecializationList> getspecialization=[];
  List<String> selected_specialization_list = [];
  late Route routes;
  @override
  void initState() {
    super.initState();
    getBaseUrl();
    setData();
  }

  setData(){
    this.selected_specialization_list=widget.selected_type.split(',');
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
                        widget.onSaveCallback(selectedspecialization);
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
                  itemCount: getspecialization.length,
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
                                    if (isAdded(getspecialization[index].specialization) == true) {
                                      selected_specialization_list.remove(getspecialization[index].specialization);
                                      print(selected_specialization_list.toString());
                                      setCategory();
                                    }
                                    else {
                                      selected_specialization_list.add(getspecialization[index].specialization);
                                      print(selected_specialization_list.toString());
                                      setCategory();
                                    }
                                  });
                                }
                              },
                              value: isAdded(getspecialization[index].specialization),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              getspecialization[index].specialization,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ]),
                  )),
            ):
            getspecialization.isEmpty && isApiCallProcessing == false ?
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
    selectedspecialization='';
    for(int index=0;index<selected_specialization_list.length;index++){

      if(index==0 || index==1){
        if(selectedspecialization!='') {
          selectedspecialization += ','+selected_specialization_list[index];
        }else{
          selectedspecialization+=selected_specialization_list[index];
        }
      }
      else{
        selectedspecialization+= ','+selected_specialization_list[index];
      }
    }
  }

  Future get_specialization_List() async {
    if(mounted){
          setState(() {
            isApiCallProcessing=true;
          });
        }
    var url=baseUrl+'api/'+get_specialization;

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
        SpecializationModel specializationModel=SpecializationModel.fromJson(json.decode(response.body));
        getspecialization=specializationModel.data;
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  bool isAdded(String id) {
    for (int i = 0; i < selected_specialization_list.length; i++) {
      if (selected_specialization_list[i] == id) {
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
        get_specialization_List();
      });
    }
    return null;
  }
}
