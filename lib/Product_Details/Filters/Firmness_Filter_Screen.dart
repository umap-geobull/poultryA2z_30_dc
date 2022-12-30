import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/App_Apis.dart';
import '../../settings/Add_Firmness/Components/Firmness_List_Model.dart';
import '../../settings/Add_Manufacturer/Components/Manufacturer_List_Model.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;

typedef OnSaveCallback = void Function(List<String> manufacturer);

class Firmness_Filter_Screen extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String selectedFirmness;

  Firmness_Filter_Screen(this.onSaveCallback, this.selectedFirmness);

  @override
  _Firmness_Filter_ScreenState createState() => _Firmness_Filter_ScreenState();
}

class _Firmness_Filter_ScreenState extends State<Firmness_Filter_Screen> {
  _Firmness_Filter_ScreenState();

  List<String> selected_firmness_type=[];
  bool isApiCallProcessing = false;
  String baseUrl = '',admin_auto_id='';
  String user_id = '';
  List<GetFirmnessData> getfirmness_type_List = [];


  @override
  void initState() {
    super.initState();
    getBaseUrl();
    setData();
  }

  setData(){
    this.selected_firmness_type=widget.selectedFirmness.split('|');
    if(this.mounted){
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children:[
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
                            isApiCallProcessing == false ?

                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: showFirmnesslistUi(),
                            ) :

                            getfirmness_type_List.isEmpty && isApiCallProcessing == false ?
                            Center(child: Text('No Firmness')) :
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              child:
                              const GFLoader(type: GFLoaderType.circle),
                            ),
                          ]),
                    ],
                  ),
                )),
          ]
          ),
    );
  }

  showFirmnesslistUi() {
    return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: GridView.builder(
              itemCount: getfirmness_type_List.length,
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
                                    if (isAdded(getfirmness_type_List[index].firmnessType) == true)
                                    {
                                      selected_firmness_type.remove(getfirmness_type_List[index].firmnessType);
                                      print(selected_firmness_type.toString());
                                      widget.onSaveCallback(selected_firmness_type);
                                    }
                                    else {
                                      selected_firmness_type.add(getfirmness_type_List[index].firmnessType);
                                      widget.onSaveCallback(selected_firmness_type);
                                    }
                                  });
                                }
                              },
                              value: isAdded(getfirmness_type_List[index].firmnessType),
                            ),
                            margin: const EdgeInsets.all(5),
                          ),
                          Flexible(
                            child: Text(
                              getfirmness_type_List[index].firmnessType,
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


  getFirmness_List(String baseUrl) async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    var url = baseUrl+'api/' + get_firmness;

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
        FirmnessListModel getfirmnessListModel=FirmnessListModel.fromJson(json.decode(response.body));
        getfirmness_type_List=getfirmnessListModel.data;
      }
      else {
        print('empty');
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? baseUrl = prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');

    if (userId != null && baseUrl != null && adminId!=null) {
      setState(() {
        this.baseUrl = baseUrl;
        this.admin_auto_id = adminId;
        getFirmness_List(baseUrl);
      });
    }
    return null;
  }

  bool isAdded(String id) {
    for (int i = 0; i < selected_firmness_type.length; i++) {
      if (selected_firmness_type[i] == id) {
        return true;
      }
    }
    return false;
  }
}
