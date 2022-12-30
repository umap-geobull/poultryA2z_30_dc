import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/settings/AddExpressDelivery/Component/ExpressDelivery_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'Component/Rest_Apis.dart';

class Add_Express_Delivery extends StatefulWidget {
  const Add_Express_Delivery({Key? key}) : super(key: key);

  @override
  _Add_Express_DeliveryState createState() => _Add_Express_DeliveryState();
}

class _Add_Express_DeliveryState extends State<Add_Express_Delivery> {
  ExpressDelivery_Model? expressDelivery_Model;
  List<ExpressDelivery>? getExpressCharges_List = [];
  // List<ExpressDelivery>? selectedcharges_List = [];
  bool isApiCallProcessing = false;
  String baseUrl='', admin_auto_id='';

  String user_id = '';
  String charges = "",id="";
  List<String> selected_charges_List = [];

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
            title: const Text("Express Delivery Charges List",
                style: TextStyle(color: appBarIconColor, fontSize: 16)),
            leading: IconButton(
              onPressed: ()=>{Navigator.of(context).pop()},
              icon: const Icon(Icons.arrow_back, color:appBarIconColor),
            ),
            actions: const [
              // IconButton(
              //   onPressed: () {
              //     Add_Express_delivery_Layout();
              //   },
              //   icon: Icon(Icons.add_circle_outline, color: Colors.white),
              // ),
            ]),
        body: Stack(
            children :<Widget>[
              Container(
                margin: const EdgeInsets.all(10),
            height: 230,
            decoration: BoxDecoration(
            border: Border.all(color: Colors.orange)
                ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        height: 60,
                        child:const Text('Express Delivery Charges',
                            style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            )),
                      ),
                      SizedBox(
                        height: 50,
                        child:Text("₹ "+charges,
                            style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 15,
                                )),
                      ),

                      getExpressCharges_List!=null
                          ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height:40,
                              width: 120,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: kPrimaryColor,
                                    textStyle: const TextStyle(fontSize: 20)),
                                onPressed: () {
                                  Update_Express_delivery_Layout();
                                },
                                child: const Center(
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
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
        getExpressDelivery_List();
      });
    }
    return null;
  }

  void Add_Express_delivery_Layout() {
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
                      child: Text('Add Charges ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text("Express Charges",
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

                      children: [

                        SizedBox(
                          height: 40,
                          child: SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height,
                            child: TextFormField(

                              initialValue: charges,
                              // controller: _product_name_controller_,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.fromLTRB(
                                    10, 15, 0, 0),
                                //hintText: "Add multiple colors separated by comma",
                                hintText: "Add amount",
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

                              onChanged: (value) => charges = value,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),

                        Divider(color: Colors.grey.shade300),

                      ],
                    ),
                  ),

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
                              if (charges == "" || charges.isEmpty) {
                                Fluttertoast.showToast(msg: "Enter charges",
                                  backgroundColor: Colors.grey,);
                              }
                              else {
                                Navigator.pop(context);
                                Add_Charges();
                                if(mounted)
                                {
                                  setState(() {
                                    charges = "";
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
            );
          });
        });
  }

  void Update_Express_delivery_Layout() {
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
                      child: Text('Update Charges ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text("Express Charges",
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

                      children: [

                        SizedBox(
                          height: 40,
                          child: SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height,
                            child: TextFormField(

                              initialValue: charges,
                              // controller: _product_name_controller_,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.fromLTRB(
                                    10, 15, 0, 0),
                                //hintText: "Add multiple colors separated by comma",
                                hintText: "Add amount",
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

                              onChanged: (value) => charges = value,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),

                        Divider(color: Colors.grey.shade300),

                      ],
                    ),
                  ),

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
                              if (charges == "" || charges.isEmpty) {
                                Fluttertoast.showToast(msg: "Enter charges",
                                  backgroundColor: Colors.grey,);
                              }
                              else {
                                Navigator.pop(context);
                                Add_Charges();
                                if(mounted)
                                {
                                  setState(() {
                                    charges = "";
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
            );
          });
        });
  }

  void getExpressDelivery_List() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.getExpressCharges(admin_auto_id, baseUrl).then((value) {
      if (value != null) {
        isApiCallProcessing = false;
        getExpressCharges_List = value;

        if(getExpressCharges_List!.isNotEmpty){
          id=getExpressCharges_List![0].id;
          charges=getExpressCharges_List![0].expressDeliveryCharges;
        }

        print('charge length '+getExpressCharges_List!.length.toString());
        if(this.mounted){
          setState(() {

          });
        }
      }
    });
  }

  setSelected(String id) {
    if (isAdded(id) == true) {
      selected_charges_List.remove(id);
    } else {
      if (selected_charges_List.length < 10) {
        selected_charges_List.add(id);
      } else {
        Fluttertoast.showToast(
          msg: "Maximum 5 charges can be selected",
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
    for (int i = 0; i < selected_charges_List.length; i++) {
      if (selected_charges_List[i] == id) {
        return true;
      }
    }
    return false;
  }

  void Add_Charges() {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.Add_Express_Delivery_Api(id,charges, admin_auto_id, baseUrl).then((value) {
      if (value != null) {
        String status = value;

        if (status == "1") {
          isApiCallProcessing = false;
          Fluttertoast.showToast(
            msg: "Express delivery charge updated successfully",
            backgroundColor: Colors.grey,
          );
          getExpressDelivery_List();
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
