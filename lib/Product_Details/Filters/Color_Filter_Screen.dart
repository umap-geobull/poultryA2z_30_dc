import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../settings/Add_Color/Components/Color_List_Model.dart';
import '../../settings/Add_Color/Components/Rest_Apis.dart';
import 'package:getwidget/getwidget.dart';

typedef OnSaveCallback = void Function(List<String> colors);

class Color_Filter_Screen extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String selectedColors;

  Color_Filter_Screen(this.onSaveCallback, this.selectedColors);

  @override
  _Color_Filter_ScreenState createState() => _Color_Filter_ScreenState();
}

class _Color_Filter_ScreenState extends State<Color_Filter_Screen> {
  _Color_Filter_ScreenState();

  List<String> selectedcolor_id=[];
  bool isApiCallProcessing = false;
  String baseUrl = '',admin_auto_id='';
  String user_id = '';
  List<GetColorList> getcolor_List = [];

  @override
  void initState() {
    super.initState();
    getBaseUrl();
    setData();
  }

  setData(){
    this.selectedcolor_id=widget.selectedColors.split('|');
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

                            getcolor_List.isEmpty && isApiCallProcessing == false ?
                            Center(child: Text('No colors')) :
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
              itemCount: getcolor_List.length,
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
                                    if (isAdded(getcolor_List[index].colorName) == true)
                                    {
                                      selectedcolor_id.remove(getcolor_List[index].colorName);
                                      print(selectedcolor_id.toString());
                                      widget.onSaveCallback(selectedcolor_id);
                                    }
                                    else {
                                      selectedcolor_id.add(getcolor_List[index].colorName);
                                      widget.onSaveCallback(selectedcolor_id);
                                    }
                                  });
                                }
                              },
                              value: isAdded(getcolor_List[index].colorName),
                            ),
                            margin: const EdgeInsets.all(5),
                          ),
                          Flexible(
                            child: Text(
                              getcolor_List[index].colorName,
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

  void getColor_List() async {
    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

      restApis.getColorList(admin_auto_id, baseUrl).then((value) {
        print(value.toString());
        if (value != null) {
          isApiCallProcessing = false;
          getcolor_List = value;

          if(this.mounted){
            setState(() {

            });
          }
        }
        else {
          getcolor_List=[];

          if(this.mounted){
            setState(() {

            });
          }
          Fluttertoast.showToast(
            msg: "No Colors found",
            backgroundColor: Colors.grey,
          );
        }

      });
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
        getColor_List();
      });
    }
    return null;
  }

  bool isAdded(String id) {
    for (int i = 0; i < selectedcolor_id.length; i++) {
      if (selectedcolor_id[i] == id) {
        return true;
      }
    }
    return false;
  }
}
