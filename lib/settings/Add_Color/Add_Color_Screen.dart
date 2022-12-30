import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'Components/Color_List_Model.dart';
import 'Components/Rest_Apis.dart';


class Add_Color_Screen extends StatefulWidget {
  const Add_Color_Screen({Key? key}) : super(key: key);

  @override
  _Add_Color_ScreenState createState() => _Add_Color_ScreenState();
}

class _Add_Color_ScreenState extends State<Add_Color_Screen> {
  ColorListModel? colorListModel;
  List<GetColorList>? getcolor_List = [];
  //List<GetColorList>? selectedcolor_List = [];
  bool isApiCallProcessing = false;
  String baseUrl='',admin_auto_id='';

   String color = "";
  List<String> selected_color_List = [];

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
            title: const Text("Color List",
                style: TextStyle(color: appBarIconColor, fontSize: 16)),
            leading: IconButton(
              onPressed: ()=>{Navigator.of(context).pop()},
              icon: const Icon(Icons.arrow_back, color: appBarIconColor),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Add_Color_Layout();
                },
                icon: const Icon(Icons.add_circle_outline, color: appBarIconColor),
              ),
            ]),
        body: Stack(
            children :<Widget>[
              Container(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: getcolor_List?.length,
                            itemBuilder: (BuildContext context, int index) {
                              // return item
                              return Color_List_Layout(
                                getcolor_List![index].id,
                                getcolor_List![index].colorName,
                                getcolor_List![index].isSelected,
                                index,
                              );
                            }),
                      ),

                      selected_color_List.isNotEmpty
                          ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height:40,
                              width: 120,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: kPrimaryColor,
                                    textStyle: const TextStyle(fontSize: 20)),
                                onPressed: () {
                                  showAlert(selected_color_List);
                                },
                                child: Text(
                                  "Delete (${selected_color_List.length})",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          : Container(),
                    ],


                  )
              ),

              isApiCallProcessing==false && getcolor_List!.isEmpty?
              Center(
                child: Text('No colors added'),
              ):
              Container(),

              isApiCallProcessing==true?
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: const GFLoader(
                    type:GFLoaderType.circle
                ),
              ):
              Container()
            ]
        ));
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');

    if (baseUrl!=null && adminId!=null) {
      setState(() {
        this.baseUrl=baseUrl;
        this.admin_auto_id=adminId;
        print(admin_auto_id+' '+baseUrl);
        getColor_List();
      });
    }
    return null;
  }

  Future<bool> showAlert(List<String> selectedList) async {
    return await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
              backgroundColor: Colors.yellow[50],
              title: const Text(
                'Are you sure?',
                style: TextStyle(color: Colors.black87),
              ),
              content: Wrap(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Do you want to delete color',
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Delete_Pin_Code(selectedList);
                                  },
                                  child: const Text("Yes",
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 13)),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green[200],
                                    onPrimary: Colors.green,
                                    minimumSize: const Size(70, 30),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(2.0)),
                                    ),
                                  ),
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                                child: ElevatedButton(
                                  onPressed: () => {Navigator.pop(context)},
                                  child: const Text("No",
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 13)),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue[200],
                                    onPrimary: Colors.blue,
                                    minimumSize: const Size(70, 30),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(2.0)),
                                    ),
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )),
    );
  }

  void Add_Color_Layout() {
    showModalBottomSheet<void>(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Center(
                      child: Text('Add Color ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text("Color Name",
                      style: TextStyle(
                          color: Colors.black, fontSize: 16)),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery
                            .of(context)
                            .viewInsets
                            .bottom),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        SizedBox(
                          height: 40,
                          child: SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height,
                            child: TextFormField(

                              initialValue: color,
                              // controller: _product_name_controller_,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.fromLTRB(
                                    10, 15, 0, 0),
                                //hintText: "Add multiple colors separated by comma",
                                hintText: "Add color name",
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.blue, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(10),

                                ),
                              ),

                              onChanged: (value) => color = value,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),

                        Divider(color: Colors.grey.shade300),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    textStyle: const TextStyle(fontSize: 20)),
                                onPressed: () {
                                  setState(() {

                                    if (color == "" || color.isEmpty) {
                                      Fluttertoast.showToast(msg: "Enter color name",
                                        backgroundColor: Colors.grey,);
                                    }
                                    else {
                                      Navigator.pop(context);
                                      Add_Color();
                                      if(mounted)
                                      {
                                        setState(() {
                                          color = "";
                                        });
                                      }
                                    }
                                  });
                                },
                                child: const Center(
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  void getColor_List() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.getColorList(admin_auto_id, baseUrl).then((value) {
      print(value.toString());
      if (value != null) {
        isApiCallProcessing = false;
        getcolor_List = value;

        print('color length '+getcolor_List!.length.toString());
        if(this.mounted){
          setState(() {

          });
        }
      }
    });
  }

  Widget Color_List_Layout(String? id, String? colorName,
      bool? isSelected, int index) {
    return Container(
      decoration:  BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300, //                   <--- border color
          width: 1.0,
        ),

      ),
      child: ListTile(

          title: Text(
           colorName!,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black
            ),
          ),

          trailing: isAdded(getcolor_List![index].id) == true
              ? Icon(
            Icons.check_circle,
            color: Colors.green[700],
          )
              : const Icon(
            Icons.check_circle_outline,
            color: Colors.grey,
          ),
          onTap: () {
            setState(() {

              setSelected(getcolor_List![index].id);
            });
          }),
    );
  }

  setSelected(String id) {
    if (isAdded(id) == true) {
      selected_color_List.remove(id);
    } else {
      if (selected_color_List.length < 10) {
        selected_color_List.add(id);
      } else {
        Fluttertoast.showToast(
          msg: "Maximum 10 brands can be selected",
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
    for (int i = 0; i < selected_color_List.length; i++) {
      if (selected_color_List[i] == id) {
        return true;
      }
    }
    return false;
  }

  void Delete_Pin_Code(List<String> selectedList) {
    for(int i = 0; i <= selected_color_List.length;i++)
    {
      if(mounted){
        setState(() {
          isApiCallProcessing=true;
        });
      }

      Rest_Apis restApis = Rest_Apis();

      restApis.Delete_Color(selected_color_List[i], admin_auto_id, baseUrl).then((value) {
        if (value != null) {
          int status = value;

          if (status == 1) {
            isApiCallProcessing = false;

            getColor_List();
            selected_color_List = [];
          } else if (status == 0) {
            isApiCallProcessing = false;

            Fluttertoast.showToast(
              msg: "Something went wrong",
              backgroundColor: Colors.grey,
            );
          } else {
            Fluttertoast.showToast(
              msg: "Something went wrong",
              backgroundColor: Colors.grey,
            );
          }
        }
      });
    }
  }

  void Add_Color() {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.Add_Color_Api(color, admin_auto_id, baseUrl).then((value) {
      if (value != null) {
        String status = value;

        if (status == "1") {
          isApiCallProcessing = false;
          getColor_List();
        } else if (status == 0) {
          isApiCallProcessing = false;

          Fluttertoast.showToast(
            msg: "Something went wrong",
            backgroundColor: Colors.grey,
          );
        } else {
          Fluttertoast.showToast(
            msg: "Something went wrong",
            backgroundColor: Colors.grey,
          );
        }
      }
    });
  }

}
