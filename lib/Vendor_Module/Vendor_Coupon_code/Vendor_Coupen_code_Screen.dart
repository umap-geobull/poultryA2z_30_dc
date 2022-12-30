import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Vendor_Home/Utils/constants.dart';
import 'Components/Model/Coupen_Code_Info_Model.dart';
import 'Rest_Apis.dart';
import 'Vendor_Add_Coupen_Code.dart';
import 'package:getwidget/getwidget.dart';
class Vendor_Coupen_code extends StatefulWidget {
   Vendor_Coupen_code({Key? key,
    required this.Vendor_id,
  }) : super(key: key);
    String Vendor_id;
  @override
  _Vendor_Coupen_codeState createState() => _Vendor_Coupen_codeState();
}

class _Vendor_Coupen_codeState extends State<Vendor_Coupen_code> {

  Coupen_Code_Info_Model? coupen_code_info_model;
  List<CuponcodeList>? GetcuponcodeList = [];
  bool isApiCallProcessing = false;
  String user_id = '',
      coupen_code_type = "",
      coupen_code = "",
      coupen_code_value = "",
      coupen_code_desc = "",
      start_date = "",
      end_date = "",
      date = "";

  String type = "value_off";

  String baseUrl="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: appBarColor,
            title: Text("Coupon Code List",
                style: TextStyle(color: Colors.black, fontSize: 16)),
            leading: IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: Icon(Icons.arrow_back, color: Colors.black),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => Vendor_add_Coupen_code(Vendor_id: user_id,)),
                  );
                },
                icon: Icon(Icons.add_circle_outline, color: Colors.black),
              ),
            ]
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: isApiCallProcessing == true?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: GFLoader(type: GFLoaderType.circle),
            ):GetcuponcodeList!.isNotEmpty && GetcuponcodeList?.length!='0'?
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: GetcuponcodeList?.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>

                      CategoryCard_(user_id, GetcuponcodeList![index].sId, GetcuponcodeList![index].type,GetcuponcodeList![index].coupenCode,GetcuponcodeList![index].coupenCodeValue,GetcuponcodeList![index].coupenCodeDesc, GetcuponcodeList![index].startDate, GetcuponcodeList![index].endDate )
              ),
            ):Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Text("Coupons are not available", style:  TextStyle(fontSize: 14, color: Colors.black),),
            )
        ));
  }

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseurl =prefs.getString('base_url');

    if(baseurl!=null){
      setState(() {
        this.baseUrl=baseurl;
        user_id=widget.Vendor_id;
        getCoupen_Code_List(user_id);
      });
    }
    return null;
  }



  void getCoupen_Code_List(String userId) async {
    if (this.mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }
    Rest_Apis restApis = new Rest_Apis();

    restApis.getCoupen_CodeList(userId,baseUrl).then((value) {
      if (value != null) {
        setState(() {
          isApiCallProcessing = false;
          coupen_code_info_model = value;
        });

        if (coupen_code_info_model != null) {
          GetcuponcodeList = coupen_code_info_model?.cuponcodeList;
        } else {
          Fluttertoast.showToast(
            msg: "No coupon code found",
            backgroundColor: Colors.grey,
          );
        }
      } else {
        setState(() {
          isApiCallProcessing = false;
        });
        // Fluttertoast.showToast(
        //   msg: "Something went wrong",
        //   backgroundColor: Colors.grey,
        // );
      }
    });
  }

  Widget CategoryCard_(String user_id, String? sId, String? type, String? coupenCode, String? coupenCodeValue, String? coupenCodeDesc, String? startDate, String? endDate, ) {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade100),
                borderRadius: BorderRadius.circular(0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,

                    // changes position of shadow
                  ),
                ],),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                              height: 20,
                              child: Text(
                                coupenCode!,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        GestureDetector(
                          child: Container(
                            alignment: Alignment.topCenter,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(width: 1, color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2.0,
                                  )
                                ]),
                            child: Icon(
                              Icons.edit,
                              size: 20,
                            ),
                          ),
                          onTap: ()=>{
                            setState(() {
                              coupen_code_type = type!;
                              coupen_code = coupenCode;
                              coupen_code_desc =coupenCodeDesc!;
                              coupen_code_value = coupenCodeValue!;
                              start_date = startDate!;
                              end_date = endDate!;
                            }),
                            Add_CoupenCode_Layout(user_id, sId, type, coupenCode, coupenCodeValue, coupenCodeDesc, startDate, endDate)
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: ()=>{
                            showAlert(sId, user_id)
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(width: 1, color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2.0,
                                  )
                                ]),
                            child: Icon(
                              Icons.delete,
                              size: 20,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Wrap(
                      children: [
                        Icon(Icons.calendar_today, size: 18,),
                        SizedBox(width: 5,),
                        Text(startDate! + " - " +
                            endDate!,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            )),
                      ],

                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 20,
                      child: Text(
                        coupenCodeDesc!,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
    );

  }

  void Add_CoupenCode_Layout(String user_id, String? sId, String? type, String? coupenCode, String? coupenCodeValue, String? coupenCodeDesc, String? startDate, String? endDate,) {
    showModalBottomSheet<void>(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                      child: Text('Edit Coupon Code',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  Divider(color: Colors.grey.shade300),
                  SizedBox(
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

                      children: [
                        Text("Coupon Code Type",
                            style: TextStyle(
                                color: Colors.black, fontSize: 16)),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 40,
                          child: Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height,
                            child: TextFormField(
                              enabled: false,
                              initialValue: type,
                              // controller: _product_name_controller_,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.fromLTRB(
                                    10, 15, 0, 0),
                                hintText: "Enter the Coupon Code",
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.blue, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(10),

                                ),
                              ),

                              onChanged: (value) => type = value,
                              keyboardType: TextInputType.name,
                            ),
                          ),
                        ),

                        Divider(color: Colors.grey.shade300),
                        Text("Coupon Code",
                            style: TextStyle(
                                color: Colors.black, fontSize: 16)),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 40,
                          child: Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height,
                            child: TextFormField(
                              initialValue: coupenCode,
                              // controller: _product_name_controller_,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.fromLTRB(
                                      10, 15, 0, 0),
                                  hintText: "Enter the Coupon Code",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.blue, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  )),

                              onChanged: (value) => coupenCode = value,
                              keyboardType: TextInputType.name,
                            ),
                          ),
                        ),
                        Divider(color: Colors.grey.shade300),
                        Text("Coupon Code Value",
                            style: TextStyle(
                                color: Colors.black, fontSize: 16)),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 40,
                          child: Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height,
                            child: TextFormField(
                              initialValue: coupenCodeValue,
                              // controller: _product_name_controller_,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.fromLTRB(
                                      10, 15, 0, 0),
                                  hintText: "Enter the Coupon Code Value",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.blue, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  )),

                              onChanged: (value) => coupenCodeValue = value,

                              keyboardType: TextInputType.name,
                            ),
                          ),
                        ),
                        Divider(color: Colors.grey.shade300),
                        Text("Coupon Code Description",
                            style: TextStyle(
                                color: Colors.black, fontSize: 16)),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 40,
                          child: Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height,
                            child: TextFormField(
                              initialValue: coupenCodeDesc,
                              // controller: _product_name_controller_,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.fromLTRB(
                                      10, 15, 0, 0),
                                  hintText: "Enter the coupon code description",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.blue, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              // style: AppTheme.form_field_text,
                              onChanged: (value) => coupenCodeDesc = value,
                              keyboardType: TextInputType.name,
                            ),
                          ),
                        ),
                        Divider(color: Colors.grey.shade300),
                        Text("Start Date",
                            style: TextStyle(
                                color: Colors.black, fontSize: 16)),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                              Border.all(color: Colors.grey.shade100),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,

                                  // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Wrap(
                                children: [
                                  Icon(Icons.calendar_today, size: 18,),
                                  SizedBox(width: 5,),
                                  Text(start_date,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      )),
                                ],

                              ),
                            ),
                          ),
                          onTap: () =>
                          {
                            FocusScope.of(context).requestFocus(new FocusNode()),
                            show_DatePicker("start_date", state),

                          },
                        ),
                        Divider(color: Colors.grey.shade300),
                        Text("End Date",
                            style: TextStyle(
                                color: Colors.black, fontSize: 16)),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                              Border.all(color: Colors.grey.shade100),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,

                                  // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Wrap(
                                children: [
                                  Icon(Icons.calendar_today, size: 18,),
                                  SizedBox(width: 5,),
                                  Text(end_date,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      )),
                                ],

                              ),
                            ),
                          ),
                          onTap: () =>
                          {
                            FocusScope.of(context).requestFocus(new FocusNode()),
                            show_DatePicker("end_date", state),

                          },
                        ),
                        Divider(color: Colors.grey.shade300),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: ElevatedButton(
                          child: Center(
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                         /* textColor: Colors.white,
                          color: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                      */    onPressed: () {
                            setState(() {


                              if (coupenCode == "" || coupenCode!.isEmpty) {
                                Fluttertoast.showToast(msg: "Enter Coupon code",
                                  backgroundColor: Colors.grey,);
                              }
                              else if (coupenCodeValue == "" ||
                                  coupenCodeValue!.isEmpty) {
                                Fluttertoast.showToast(
                                  msg: "Enter coupon code value",
                                  backgroundColor: Colors.grey,);
                              }
                              else if (coupenCodeDesc == "" ||
                                  coupenCodeDesc!.isEmpty) {
                                Fluttertoast.showToast(
                                  msg: "Enter coupon code description",
                                  backgroundColor: Colors.grey,);
                              }
                              else if (start_date == "" || start_date.isEmpty) {
                                Fluttertoast.showToast(msg: "Select start date",
                                  backgroundColor: Colors.grey,);
                              }
                              else if (end_date == "" || end_date.isEmpty) {
                                Fluttertoast.showToast(msg: "Select end date",
                                  backgroundColor: Colors.grey,);
                              } else {
                                update_Coupen_code(sId!, user_id, type!, coupenCode!, coupenCodeValue!, coupenCodeDesc!,start_date,end_date);
                              }
                            });
                          },
                        ),
                      ))
                ],
              ),
            );
          });
        });
  }
  show_DatePicker(String date_type, StateSetter state) {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2010, 1),
        lastDate: DateTime(2030, 12),
        builder: (context, picker) {
          return Theme(

            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: appBarColor,
                onPrimary: Colors.white,
                surface: appBarColor,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: picker!,);
        })
        .then((selectedDate) {
      date = DateFormat('dd, MMMM yyyy').format(selectedDate!).toString();
      updated(state, date_type, date);
    });
  }

  Future<Null> updated(StateSetter updateState, String datetype,
      String date) async {
    updateState(() {
      if (datetype == "start_date") {
        start_date = date;
      }
      else if (datetype == "end_date") {
        end_date = date;
      }
    });
  }

  void getCurrent_Date() {
    if (mounted) {
      setState(() {
        final DateTime today = DateTime.now();
        start_date = DateFormat('dd, MMMM yyyy').format(today).toString();
        end_date = DateFormat('dd, MMMM yyyy')
            .format(today.add(Duration(days: 30)))
            .toString();
      });
    }
  }
  Future<bool> showAlert(String? sId, String user_id) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: Text(
            'Are you sure?',
            style: TextStyle(color: Colors.black87),
          ),
          content: Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Do you want to delete Coupon Code',
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(
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
                                Delete_Coupen_Code(sId, user_id);
                              },
                              child: Text("Yes",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green[200],
                                onPrimary: Colors.green,
                                minimumSize: Size(70, 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            child: ElevatedButton(
                              onPressed: () => {Navigator.pop(context)},
                              child: Text("No",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue[200],
                                onPrimary: Colors.blue,
                                minimumSize: Size(70, 30),
                                shape: RoundedRectangleBorder(
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


  void update_Coupen_code(String sId, String user_id, String coupen_code_type, String coupen_code, String coupen_code_value, String coupen_code_desc, String start_date, String end_date) {
    setState(() {
      isApiCallProcessing = true;
    });

    Rest_Apis restApis=new Rest_Apis();

    restApis.update_coupen_code(sId, user_id, coupen_code_type, coupen_code, coupen_code_value, coupen_code_desc, start_date, end_date,baseUrl).then((value){
      if(value!=null){


        String status =value;

        if(status=="1"){
          isApiCallProcessing = false;

          Navigator.of(context).pop();
          getCoupen_Code_List(user_id);
          Fluttertoast.showToast(msg: "Coupon updated successfully", backgroundColor: Colors.grey,);
        }
        else if(status=="0"){
          isApiCallProcessing = false;
          // Navigator.pop(context);
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: "Something went wrong", backgroundColor: Colors.grey,);
        }
        else{
          Fluttertoast.showToast(msg: "Something went wrong", backgroundColor: Colors.grey,);

        }
      }
    });
  }

  void Delete_Coupen_Code(String? sId, String user_id) {
    print("data=>"+sId!+" "+user_id);
    setState(() {
      isApiCallProcessing = true;
    });

    Rest_Apis restApis=new Rest_Apis();

    restApis.Delete_coupon_code(sId, user_id,baseUrl).then((value){

      if(value!=null){


        int status =value;

        if(status == 1){

          isApiCallProcessing = false;
          Fluttertoast.showToast(msg: "Coupon deleted successfully", backgroundColor: Colors.grey,);
          getCoupen_Code_List(user_id);

        }
        else if(status==0){
          isApiCallProcessing = false;

          Fluttertoast.showToast(msg: "Something went wrong", backgroundColor: Colors.grey,);
        }
        else{
          Fluttertoast.showToast(msg: "Something went wrong", backgroundColor: Colors.grey,);

        }
      }
    });

  }
}