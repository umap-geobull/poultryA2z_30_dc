import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Vendor_Home/Utils/constants.dart';
import 'Rest_Apis.dart';
import 'Vendor_Coupen_code_Screen.dart';

class Vendor_add_Coupen_code extends StatefulWidget {
   Vendor_add_Coupen_code({Key? key,
    required this.Vendor_id,
  }) : super(key: key);
  String Vendor_id;
  @override
  _Vendor_add_Coupen_codeState createState() => _Vendor_add_Coupen_codeState();
}

class _Vendor_add_Coupen_codeState extends State<Vendor_add_Coupen_code> {
  String user_id = '',
      coupen_code = "",
      coupen_code_value = "",
      coupen_code_desc = "",
      start_date = "",
      end_date = "",
      date = "";
  bool isApiCallProcess = false;
  String type = "value_off";
  String baseUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
    getCurrent_Date();
    user_id=widget.Vendor_id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Add Coupon Code",
            style: TextStyle(color: Colors.black, fontSize: 16)),
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Coupon Code Type",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Radio<String>(
                                      value: 'percentage_off',
                                      groupValue: type,
                                      onChanged: (value) {
                                        setState(() => {type = value!});
                                      }),
                                  const Expanded(child: Text('Percentage off'))
                                ],
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Radio<String>(
                                      value: 'value_off',
                                      groupValue: type,
                                      onChanged: (value) {
                                        setState(() => {type = value!});
                                      }),
                                  const Expanded(
                                    child: Text('Value off'),
                                  )
                                ],
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                      ),

                      Divider(color: Colors.grey.shade300),
                      const Text("Coupon Code",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 40,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: TextFormField(
                            // controller: _product_name_controller_,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                hintText: "Enter the Coupon Code",
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

                            onChanged: (value) => coupen_code = value,
                            keyboardType: TextInputType.name,
                          ),
                        ),
                      ),
                      Divider(color: Colors.grey.shade300),
                      const Text("Coupon Code Value",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 40,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: TextFormField(
                            // controller: _product_name_controller_,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                hintText: "Enter the Coupon Code Value",
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

                            onChanged: (value) => coupen_code_value = value,
                            keyboardType: TextInputType.name,
                          ),
                        ),
                      ),
                      Divider(color: Colors.grey.shade300),
                      const Text("Coupon Code Description",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 40,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: TextFormField(
                            // controller: _product_name_controller_,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                hintText: "Enter the coupon code description",
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
                            // style: AppTheme.form_field_text,
                            onChanged: (value) => coupen_code_desc = value,
                            keyboardType: TextInputType.name,
                          ),
                        ),
                      ),
                      Divider(color: Colors.grey.shade300),
                      const Text("Start Date",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade100),
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
                                const Icon(
                                  Icons.calendar_today,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(start_date,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        onTap: () => {
                          FocusScope.of(context).requestFocus(FocusNode()),
                          show_DatePicker("start_date"),
                        },
                      ),
                      Divider(color: Colors.grey.shade300),
                      const Text("End Date",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade100),
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
                                const Icon(
                                  Icons.calendar_today,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(end_date,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        onTap: () => {
                          FocusScope.of(context).requestFocus(FocusNode()),
                          show_DatePicker("end_date"),
                        },
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
                            primary: Colors.orangeAccent,
                            textStyle: const TextStyle(fontSize: 20)),
                        onPressed: () {
                          setState(() {

                            if (type == "Select Type" || type == "") {
                              Fluttertoast.showToast(
                                msg: "Select the coupon code type",
                                backgroundColor: Colors.grey,
                              );
                            } else if (coupen_code == "" ||
                                coupen_code.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Enter Coupon code",
                                backgroundColor: Colors.grey,
                              );
                            }
                            else if (coupen_code_value == "" ||
                                coupen_code_value.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Enter Coupon code",
                                backgroundColor: Colors.grey,
                              );
                            }else if (coupen_code_desc == "" ||
                                coupen_code_desc.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Enter coupon code description",
                                backgroundColor: Colors.grey,
                              );
                            } else if (start_date == "" || start_date.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Select start date",
                                backgroundColor: Colors.grey,
                              );
                            } else if (end_date == "" || end_date.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Select end date",
                                backgroundColor: Colors.grey,
                              );
                            } else {
                              Add_Coupen_Code(user_id, type, coupen_code, coupen_code_value, coupen_code_desc, start_date, end_date);
                            }
                          });
                        },
                        child: Center(
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
          ))),
    );
  }

  show_DatePicker(String dateType) {
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
            child: picker!,
          );
        }).then((selectedDate) {
      setState(() {
        if (dateType == "start_date") {
          start_date =
              DateFormat('dd-MMMM-yyyy').format(selectedDate!).toString();
        } else if (dateType == "end_date") {
          end_date =
              DateFormat('dd-MMMM-yyyy').format(selectedDate!).toString();
        }
      });
    });
  }

  void getCurrent_Date() {
    if (mounted) {
      setState(() {
        final DateTime today = DateTime.now();
        start_date = DateFormat('dd-MMMM-yyyy').format(today).toString();
        end_date = DateFormat('dd-MMMM-yyyy')
            .format(today.add(const Duration(days: 30)))
            .toString();
      });
    }
  }

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if(baseUrl!=null){
      setState(() {
        this.baseUrl=baseUrl;
      });
    }
    return null;
  }

  void Add_Coupen_Code(String userId, String type, String coupenCode, String coupenCodeValue, String coupenCodeDesc, String startDate, String endDate) {
    setState(() {
      isApiCallProcess = true;
    });

    Rest_Apis restApis=Rest_Apis();

    restApis.add_coupen_code(userId, type, coupenCode, coupenCodeValue, coupenCodeDesc, startDate, endDate,baseUrl).then((value){
      if(value!=null){


        String status =value;

        if(status=="1"){
          isApiCallProcess = false;
          // Navigator.pop(context);
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Vendor_Coupen_code(Vendor_id: widget.Vendor_id,)));
          Fluttertoast.showToast(msg: "Coupon added successfully", backgroundColor: Colors.grey,);
        }
        else if(status=="0"){
          isApiCallProcess = false;
          // Navigator.pop(context);
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Vendor_Coupen_code(Vendor_id: widget.Vendor_id)));
          Fluttertoast.showToast(msg: "This coupon code Already Exists", backgroundColor: Colors.grey,);
        }
        else{
          Fluttertoast.showToast(msg: "Something went wrong", backgroundColor: Colors.grey,);

        }
      }
    });
  }
  }

