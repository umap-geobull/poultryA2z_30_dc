import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Components/Get_Pincode_List_Model.dart';
import 'Components/Rest_Apis.dart';
import 'package:getwidget/getwidget.dart';


class Add_Pincode_Screen extends StatefulWidget {
  const Add_Pincode_Screen({Key? key}) : super(key: key);

  @override
  _Add_Pincode_ScreenState createState() => _Add_Pincode_ScreenState();
}

class _Add_Pincode_ScreenState extends State<Add_Pincode_Screen> {
  List<GetPincodeList> getpincode_List = [];
  List<GetPincodeList>? selectedpincode_List = [];
  bool isApiCallProcessing = false;
  String baseUrl='';

  String user_id = '',admin_auto_id='';
   String pincode = "",  pincode_price ="";
  List<String> selected_pincode_List = [];

  String currency='';

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
            title: const Text("Pincode List",
                style: TextStyle(color: appBarIconColor, fontSize: 16)),
            leading: IconButton(
              onPressed: ()=>{Navigator.of(context).pop()},
              icon: const Icon(Icons.arrow_back, color: appBarIconColor),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Add_PinCode_Layout();
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
                            itemCount: getpincode_List?.length,
                            itemBuilder: (BuildContext context, int index) {
                              // return item
                              return Pincode_List_Layout(
                                getpincode_List![index].sId,
                                getpincode_List![index].pincode,
                                getpincode_List![index].price,
                                getpincode_List![index].isSelected,
                                index,
                              );
                            }),
                      ),
                      selected_pincode_List.isNotEmpty
                          ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height:40,
                              width: 130,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    textStyle: const TextStyle(fontSize: 20)),
                                onPressed: () {
                                  Edit_PinCode_Layout();
                                  },
                                child: Text(
                                  "Edit (${selected_pincode_List.length})",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20,),
                            SizedBox(
                              height:40,
                              width: 120,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: kPrimaryColor,
                                    textStyle: const TextStyle(fontSize: 20)),
                                onPressed: () {
                                  showAlert(selected_pincode_List);
                                },
                                child: Text(
                                  "Delete (${selected_pincode_List.length})",
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


                  )),

              isApiCallProcessing==false&& getpincode_List.isEmpty?
              Center(child: Text('No pincode added'),):
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
    String? userId = prefs.getString('user_id');
    String? baseUrl = prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');

    if (userId != null && baseUrl!=null && adminId!=null) {
      setState(() {
        this.baseUrl=baseUrl;
        this.user_id=userId;
        this.admin_auto_id=adminId;
        getPin_Code_List();
      });
    }
    return null;
  }

  showAlert(List<String> selectedList) async {
    showDialog(
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
                          'Do you want to delete Pin Code',
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

  void Add_PinCode_Layout() {
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
                      child: Text('Add Pin Code',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text("Pin Codes",
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

                              initialValue: pincode,
                              // controller: _product_name_controller_,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.fromLTRB(
                                    10, 15, 0, 0),
                                hintText: "Add multiple pincode separated by comma",
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

                              onChanged: (value) => pincode = value,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                        Divider(color: Colors.grey.shade300),
                        const Text("Deliver Charges",
                            style: TextStyle(
                                color: Colors.black, fontSize: 16)),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 40,
                          child: SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height,
                            child: TextFormField(
                              initialValue: pincode_price,
                              // controller: _product_name_controller_,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      10, 15, 0, 0),
                                  hintText: "Enter the pincode code price",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.blue, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  )),

                              onChanged: (value) => pincode_price = value,
                              keyboardType: TextInputType.number,
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
                                    primary: kPrimaryColor,
                                    textStyle: const TextStyle(fontSize: 20)),
                                onPressed: () {
                                  setState(() {

                                    if (pincode == "" || pincode.isEmpty) {
                                      Fluttertoast.showToast(msg: "Enter pin code",
                                        backgroundColor: Colors.grey,);
                                    }
                                    else {
                                      Navigator.pop(context);
                                      if (pincode_price == "" ||
                                          pincode_price.isEmpty) {
                                        pincode_price='0';
                                      }
                                      Add_Pin_code(user_id, pincode, pincode_price);
                                      if(mounted)
                                      {
                                        setState(() {
                                          pincode = "";
                                          pincode_price = "";
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

  void Edit_PinCode_Layout() {
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
                      child: Text('Edit Pin Code',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(
                    height: 10.0,
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

                        const Text("Pin Code Price",
                            style: TextStyle(
                                color: Colors.black, fontSize: 16)),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 40,
                          child: SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height,
                            child: TextFormField(
                              initialValue: pincode_price,
                              // controller: _product_name_controller_,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      10, 15, 0, 0),
                                  hintText: "Enter the pincode code price",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.blue, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  )),

                              onChanged: (value) => pincode_price = value,
                              keyboardType: TextInputType.number,
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

                                      Navigator.pop(context);
                                      if (pincode_price == "" ||
                                          pincode_price.isEmpty) {
                                        pincode_price='0';
                                      }
                                      Edit_Pin_Code(user_id, pincode_price);
                                      if(mounted)
                                      {
                                        setState(() {
                                          pincode = "";
                                          pincode_price = "";
                                        });
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

  void getPin_Code_List() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.getPin_CodeList(user_id, admin_auto_id, baseUrl).then((value) {
      if (value != null) {
        isApiCallProcessing = false;
        getpincode_List = value;

        //print('pincode length '+getpincode_List.length.toString());
        if(this.mounted){
          setState(() {
          });
        }
      }
    });
  }

  Widget Pincode_List_Layout(String? pinCodeId, String? pincode,
      String? pincodePrice, bool? isSelected, int index) {
    return Container(
      decoration:  BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300, //                   <--- border color
          width: 1.0,
        ),

      ),
      child: ListTile(

          title: Text(
           "Pincode: " +pincode!,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black
            ),
          ),
          subtitle: Text("Pincode price: "+currency +pincodePrice!,style: const TextStyle(fontSize: 14,
              color: Colors.black),),
          trailing: isAdded(getpincode_List[index].sId as String) == true
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

              setSelected(getpincode_List![index].sId!);
            });
          }),
    );
  }

  setSelected(String id) {
    if (isAdded(id) == true) {
      selected_pincode_List.remove(id);
    } else {
      if (selected_pincode_List.length < 10) {
        selected_pincode_List.add(id);
      } else {
        Fluttertoast.showToast(
          msg: "Maximum 10 pincode can be selected",
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
    for (int i = 0; i < selected_pincode_List.length; i++) {
      if (selected_pincode_List[i] == id) {
        return true;
      }
    }
    return false;
  }

  void Delete_Pin_Code(List<String> selectedList) {
    for(int i = 0; i <= selected_pincode_List.length;i++)
    {
      if(mounted){
        setState(() {
          isApiCallProcessing=true;
        });
      }

      Rest_Apis restApis = Rest_Apis();

      restApis.Delete_Pin_code(selected_pincode_List[i], user_id, admin_auto_id, baseUrl).then((value) {
        if (value != null) {
          int status = value;

          if (status == 1) {
            isApiCallProcessing = false;

            getPin_Code_List();
            selected_pincode_List = [];
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

  void Add_Pin_code(String userId, String pincode, String pincodePrice) {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.Add_Pin_code(userId, admin_auto_id, pincode, pincodePrice,baseUrl).then((value) {
      if (value != null) {
        String status = value;

        if (status == "1") {
          isApiCallProcessing = false;
          getPin_Code_List();
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

  void Edit_Pin_Code(String userId, String pincodePrice) {
    setState(() {
      isApiCallProcessing = true;
    });
    String selectedPincode = '';

    for (int i = 0; i < selected_pincode_List.length; i++) {
      if (i == 0) {
        selectedPincode += selected_pincode_List[i];
      } else {
        selectedPincode += ',' + selected_pincode_List[i];
      }
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.Edit_Pincode_List(userId, admin_auto_id, selectedPincode,pincodePrice,baseUrl ).then((value) {
      if (value != null) {
        isApiCallProcessing = false;

        String status = value;

        if (status == "1") {


          getPin_Code_List();
          selected_pincode_List = [];
          Fluttertoast.showToast(
            msg: "pincode edited successfully",
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
