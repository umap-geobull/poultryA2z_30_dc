import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/App_Apis.dart';
import '../../settings/Add_Manufacturer/Components/Manufacturer_List_Model.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;

typedef OnSaveCallback = void Function(List<String> manufacturer);

class Manufacturer_Filter_Screen extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String selectedManufacturer;

  Manufacturer_Filter_Screen(this.onSaveCallback, this.selectedManufacturer);

  @override
  _Manufacturer_Filter_ScreenState createState() => _Manufacturer_Filter_ScreenState();
}

class _Manufacturer_Filter_ScreenState extends State<Manufacturer_Filter_Screen> {
  _Manufacturer_Filter_ScreenState();

  List<String> selected_manufacturer_id=[];
  bool isApiCallProcessing = false;
  String baseUrl = '',admin_auto_id='';
  String user_id = '';
  List<GetManufacturerList> getmanufaturer_List = [];


  @override
  void initState() {
    super.initState();
    getBaseUrl();
    setData();
  }

  setData(){
    this.selected_manufacturer_id=widget.selectedManufacturer.split('|');
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
                              child: showcolorlistUi(),
                            ) :

                            getmanufaturer_List.isEmpty && isApiCallProcessing == false ?
                            Center(child: Text('No Manufacturers')) :
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

  showcolorlistUi() {
    return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: GridView.builder(
              itemCount: getmanufaturer_List.length,
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
                                    if (isAdded(getmanufaturer_List[index].manufacturerName) == true)
                                    {
                                      selected_manufacturer_id.remove(getmanufaturer_List[index].manufacturerName);
                                      print(selected_manufacturer_id.toString());
                                      widget.onSaveCallback(selected_manufacturer_id);
                                    }
                                    else {
                                      selected_manufacturer_id.add(getmanufaturer_List[index].manufacturerName);
                                      widget.onSaveCallback(selected_manufacturer_id);
                                    }
                                  });
                                }
                              },
                              value: isAdded(getmanufaturer_List[index].manufacturerName),
                            ),
                            margin: const EdgeInsets.all(5),
                          ),
                          Flexible(
                            child: Text(
                              getmanufaturer_List[index].manufacturerName,
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

  /*void getManufaturer_List() async {
    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

      restApis.Get_Manufacturer_List(admin_auto_id, baseUrl).then((value) {
        print(value.toString());
        if (value != null) {
          isApiCallProcessing = false;
          getmanufaturer_List = value;
          print('manufacturer list'+getmanufaturer_List.length.toString());

          if(this.mounted){
            setState(() {

            });
          }
        }
        else {
          getmanufaturer_List=[];

          if(this.mounted){
            setState(() {

            });
          }
          Fluttertoast.showToast(
            msg: "No Maufacturer found",
            backgroundColor: Colors.grey,
          );
        }

      });
  }
*/
  getManufaturer_List(String baseUrl) async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    var url = baseUrl+'api/' + get_manufacturer;

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
        Manufacturer_List_Model getmanufacturerListModel=Manufacturer_List_Model.fromJson(json.decode(response.body));
        getmanufaturer_List=getmanufacturerListModel.data;
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
        getManufaturer_List(baseUrl);
      });
    }
    return null;
  }

  bool isAdded(String id) {
    for (int i = 0; i < selected_manufacturer_id.length; i++) {
      if (selected_manufacturer_id[i] == id) {
        return true;
      }
    }
    return false;
  }
}
