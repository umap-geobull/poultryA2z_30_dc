import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Utils/App_Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';

import '../../settings/Add_Material/Components/Material_List_Model.dart';

typedef OnSaveCallback = void Function(List<String> materials);

class Material_Filter_Screen extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String selectedSize;

  Material_Filter_Screen(this.onSaveCallback, this.selectedSize);

  @override
  _Material_Filter_ScreenState createState() => _Material_Filter_ScreenState();
}

class _Material_Filter_ScreenState extends State<Material_Filter_Screen> {
  List<GetMaterialData> getSize_List_ = [];
  List<GetMaterialData> selected_Size_model_ = [];
  String user_id = "", size_name = "";
  bool isApiCallProcessing = false;
  String baseUrl = '',admin_auto_id='';
  List<String> selected_size_List = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
    setData();
  }

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');
    String? adminId= prefs.getString('admin_auto_id');

    if (baseUrl != null && adminId!=null) {
      setState(() {
        this.baseUrl = baseUrl;
        this.admin_auto_id = adminId;
        getSizeList(baseUrl);
      });
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(top: 10),
              child: AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                child: Column(
                   children: <Widget>[
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          isApiCallProcessing == false
                              ? SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: showSizeListUi(),
                          )
                              : getSize_List_.isEmpty &&
                              isApiCallProcessing == false
                              ? Center(child: Text('No Sizes available'))
                              : Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child:
                            const GFLoader(type: GFLoaderType.circle),
                          ),
                        ]),
                  ],
                ),
              )),
        ],
      )
    );
  }

  setData(){
    this.selected_size_List=widget.selectedSize.split('|');
    if(this.mounted){
      setState(() {
      });
    }
  }

  showSizeListUi() {
    return
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: GridView.builder(
            itemCount: getSize_List_.length,
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
                      child: Checkbox(
                         onChanged: (value) {
                          if (mounted) {
                            setState(() {
                              if (isAdded(getSize_List_[index].materialName) == true) {
                                selected_size_List.remove(getSize_List_[index].materialName);
                                print(selected_size_List.toString());
                                widget.onSaveCallback(selected_size_List);
                              }
                              else {
                                selected_size_List.add(getSize_List_[index].materialName);
                                print(selected_size_List.toString());
                                widget.onSaveCallback(selected_size_List);
                              }
                            });
                          }
                        },
                        value: isAdded(getSize_List_[index].materialName),
                      ),
                      margin: const EdgeInsets.all(5),
                    ),
                    Flexible(
                      child: Text(
                        getSize_List_[index].materialName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ]),
            )),
      );
  }

  getSizeList(String baseUrl) async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    var url = baseUrl+'api/' + get_material;

    Uri uri=Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
    };
    final response = await http.post(uri, body: body);

    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        MaterialListModel getSizeListModel=MaterialListModel.fromJson(json.decode(response.body));
        getSize_List_=getSizeListModel.data;
      }
      else {
        print('empty');
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  setSelected(String id) {
    if (isAdded(id) == true) {
      selected_size_List.remove(id);
    } else {
      if (selected_size_List.length < 10) {
        selected_size_List.add(id);
      } else {
        Fluttertoast.showToast(
          msg: "Maximum 5 material can be selected",
          backgroundColor: Colors.grey,
        );
      }
    }
    if(mounted)
    {
      setState(() {});
    }
  }

  bool isAdded(String id) {
    for (int i = 0; i < selected_size_List.length; i++) {
      if (selected_size_List[i] == id) {
        return true;
      }
    }
    return false;
  }
}
