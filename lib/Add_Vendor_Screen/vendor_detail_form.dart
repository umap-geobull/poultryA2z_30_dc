import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Home/Home_Screen.dart';
import '../Sign_Up/vendor_catagory_model.dart';
import '../Utils/AppConfig.dart';
import '../Utils/App_Apis.dart';
import 'package:http/http.dart' as http;

class VendorDetailsForm extends StatefulWidget {
  final VendorData vendorData;
  const VendorDetailsForm({Key? key, required this.vendorData})
      : super(key: key);

  @override
  State<VendorDetailsForm> createState() => _VendorDetailsFormState();
}

class _VendorDetailsFormState extends State<VendorDetailsForm> {
  Color appBarColor = Colors.white,
      appBarIconColor = Colors.black,
      primaryButtonColor = Colors.orange,
      secondaryButtonColor = Colors.orangeAccent;
  String token = '';
  FocusNode _focus = FocusNode();
  bool isLocationAllowed = false, isLocationPermissionChecked = false;
  String businessDetailsId = '', businessName = '', businessLogo = '';
  String baseUrl = '', admin_auto_id = '',userType='';
  late List<File> resume_file = [];
  late List<TextEditingController> textController = [];
  bool iscsvProcessing=false;
  bool isApiProcessing = false;
  List<bool> isfileuploaded = [];
  List<String> csvColumn=[];
  void initState() {
    // TODO: implement initState
    super.initState();
    print(
        "Text editing lenth ${textController.length} field length ${widget.vendorData.fields.length}");
    widget.vendorData.fields.forEach((e) => textController.insert(
        textController.length, new TextEditingController()));

    widget.vendorData.fields
        .forEach((e) => resume_file.insert(resume_file.length, new File('')));

    widget.vendorData.fields
        .forEach((e) => isfileuploaded.insert(isfileuploaded.length, false));
    getAppLogo();

    print(
        "Text editing lenth ${textController.length} field length ${widget.vendorData.fields.length}");
    generateFirebaseToken();
    getBaseUrl();
    getappUi();
  }

  void generateFirebaseToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken != null) {
      token = fcmToken;
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  void getappUi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? appBarColor = prefs.getString('appbarColor');
    String? appbarIcon = prefs.getString('appbarIconColor');
    String? primaryButtonColor = prefs.getString('primaryButtonColor');
    String? secondaryButtonColor = prefs.getString('secondaryButtonColor');

    if (appBarColor != null) {
      this.appBarColor = Color(int.parse(appBarColor));
    }

    if (appbarIcon != null) {
      this.appBarIconColor = Color(int.parse(appbarIcon));
    }

    if (primaryButtonColor != null) {
      this.primaryButtonColor = Color(int.parse(primaryButtonColor));
    }

    if (secondaryButtonColor != null) {
      this.secondaryButtonColor = Color(int.parse(secondaryButtonColor));
    }

    if (this.mounted) {
      setState(() {});
    }
  }

  final _formKey = GlobalKey<FormState>();

  void getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');
    String? userType =prefs.getString('user_type');
    String? adminId = prefs.getString('admin_auto_id');

    if (baseUrl != null && adminId != null && userType!=null) {
      if (mounted) {
        setState(() {
          this.baseUrl = baseUrl;
          this.admin_auto_id = adminId;
          this.userType=userType;
        });
      }
    }
    setState(() {});
  }

  getAppLogo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var appLogo = prefs.getString('app_logo');

    if (appLogo != null) {
      if (this.mounted) {
        setState(() {
          businessLogo = appLogo;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryButtonColor,
        title: Text("${widget.vendorData.categoryName}"),
        actions: [
          userType=='Admin'?
          IconButton(
            onPressed: ()=>{
              _displayFromDialog(context)
            },
            icon: Icon(Icons.import_export,color: appBarIconColor,)):
          Container()
          ,],
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 16, bottom: 60),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                          widget.vendorData.fields.length,
                          (index) => widget
                                      .vendorData.fields[index].inputType ==
                                  "File"
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    widget.vendorData.fields[index].required ==
                                            "Yes"
                                        ? Row(
                                            children: [
                                              Text(
                                                  "${widget.vendorData.fields[index].labels.toLowerCase()}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black)),
                                              Text(" *",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.red)),
                                            ],
                                          )
                                        : Text(
                                            "${widget.vendorData.fields[index].labels.toLowerCase()}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                    const SizedBox(
                                      height: 1,
                                    ),

                                    !isfileuploaded[index]
                                        ? GestureDetector(
                                            onTap: () async {
                                              FilePickerResult? result =
                                                  await FilePicker.platform
                                                      .pickFiles(
                                                type: FileType.custom,
                                                allowedExtensions: [
                                                  'jpg',
                                                  'png'
                                                ],
                                              );
                                              if (result != null) {
                                                PlatformFile file =
                                                    result.files.first;
                                                setState(() {
                                                  resume_file[index] =
                                                      File(file.path!);
                                                  print(
                                                      "${resume_file[index].path.isEmpty}");
                                                  isfileuploaded[index] = true;
                                                });

                                                print(file.name);
                                                print(file.bytes);
                                                print(file.size);
                                                print(file.extension);
                                                print(file.path);
                                              } else {
                                                print('No file selected');
                                              }
                                            },
                                            // onTap: showImageDialog,
                                            child:
                                                //      resume_file[index].path.isEmpty
                                                // ?
                                                Container(
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    0.15),
                                                            offset:
                                                                Offset(1, 6),
                                                            blurRadius: 12)
                                                      ],
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 120,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  30),
                                                          // color: Colors.white!,
                                                          child: Image.asset(
                                                              'assets/ic_consultant.png'),
                                                        ),
                                                        Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            //margin: EdgeInsets.only(top: 280),
                                                            //color: Colors.white!,
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              'Upload Image here',
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            ))
                                                      ],
                                                    ))
                                            // :Container(
                                            //         margin: EdgeInsets.only(top: 5),
                                            //         decoration: BoxDecoration(
                                            //           borderRadius: BorderRadius.all(Radius.circular(10)),
                                            //           color: Colors.white,
                                            //           boxShadow: [
                                            //             BoxShadow(
                                            //                 color: Color.fromRGBO(0, 0, 0, 0.15),
                                            //                 offset: Offset(1, 6),
                                            //                 blurRadius: 12)
                                            //           ],
                                            //           border: Border.all(color: Colors.grey),
                                            //         ),
                                            //         child: Stack(children: [
                                            //           Container(
                                            //             width: MediaQuery.of(context).size.width,
                                            //             height: 120,
                                            //             padding: EdgeInsets.all(30),
                                            //             // color: Colors.white!,
                                            //             child: Image.file(File( resume_file[index].path),
                                            //           ),
                                            //           )
                                            //         ],)
                                            //     ),
                                            )
                                        : GestureDetector(
                                            onTap: () async {
                                              FilePickerResult? result =
                                                  await FilePicker.platform
                                                      .pickFiles(
                                                type: FileType.custom,
                                                allowedExtensions: [
                                                  'jpg',
                                                  'png'
                                                ],
                                              );
                                              if (result != null) {
                                                PlatformFile file =
                                                    result.files.first;
                                                setState(() {
                                                  resume_file[index] =
                                                      File(file.path!);
                                                  print(
                                                      "${resume_file[index].path.isEmpty}");
                                                  isfileuploaded[index] = true;
                                                });

                                                print(file.name);
                                                print(file.bytes);
                                                print(file.size);
                                                print(file.extension);
                                                print(file.path);
                                              } else {
                                                print('No file selected');
                                              }
                                            },
                                            // onTap: showImageDialog,
                                            child:
                                                //      resume_file[index].path.isEmpty
                                                // ?
                                                Container(
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      color: Colors.white,
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            color:
                                                                Color.fromRGBO(0, 0, 0, 0.15),
                                                            offset:
                                                                Offset(1, 6),
                                                            blurRadius: 12)
                                                      ],
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 120,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  30),
                                                          // color: Colors.white!,
                                                          child: Image.file(
                                                              File(resume_file[
                                                                      index]
                                                                  .path)),
                                                        ),
                                                        Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            //margin: EdgeInsets.only(top: 280),
                                                            //color: Colors.white!,
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              'Upload Image here',
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            ))
                                                      ],
                                                    ))
                                            // :Container(
                                            //         margin: EdgeInsets.only(top: 5),
                                            //         decoration: BoxDecoration(
                                            //           borderRadius: BorderRadius.all(Radius.circular(10)),
                                            //           color: Colors.white,
                                            //           boxShadow: [
                                            //             BoxShadow(
                                            //                 color: Color.fromRGBO(0, 0, 0, 0.15),
                                            //                 offset: Offset(1, 6),
                                            //                 blurRadius: 12)
                                            //           ],
                                            //           border: Border.all(color: Colors.grey),
                                            //         ),
                                            //         child: Stack(children: [
                                            //           Container(
                                            //             width: MediaQuery.of(context).size.width,
                                            //             height: 120,
                                            //             padding: EdgeInsets.all(30),
                                            //             // color: Colors.white!,
                                            //             child: Image.file(File( resume_file[index].path),
                                            //           ),
                                            //           )
                                            //         ],)
                                            //     ),
                                            ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    widget.vendorData.fields[index].required ==
                                            "Yes"
                                        ? Row(
                                            children: [
                                              Text(
                                                  "${widget.vendorData.fields[index].labels.toLowerCase()}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black)),
                                              Text(" *",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.red)),
                                            ],
                                          )
                                        : Text(
                                            "${widget.vendorData.fields[index].labels.toLowerCase()}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    // SizedBox(
                                    //   height: 45,
                                    //   child: SizedBox(
                                    //     height:
                                    //         MediaQuery.of(context).size.height,
                                    //     child:
                                    TextFormField(
                                      controller: textController[index],
                                      validator: widget.vendorData.fields[index]
                                                  .required ==
                                              'Yes'
                                          ? (name) {
                                              print("Is require");
                                              if (name!.isEmpty) {
                                                print("Is require $name");
                                                return 'please Enter the ${widget.vendorData.fields[index].fieldName.toLowerCase()}';
                                              } else {
                                                if (widget.vendorData.fields[index].inputType=="Email") {
                                                  if( !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                      .hasMatch(name)){
                                                    return 'please Enter the valid ${widget.vendorData.fields[index].fieldName.toLowerCase()}';
                                                  }else{
                                                    return null;
                                                  }
                                                }

                                                if (widget.vendorData.fields[index].inputType=="Number") {
                                                  if(name.length != 10){
                                                    return 'please Enter the valid ${widget.vendorData.fields[index].fieldName.toLowerCase()}';
                                                  }else{
                                                    return null;
                                                  }
                                                }
                                                print("Is not require $name");
                                                return null;
                                              }
                                            }
                                          : (name) {
                                              print("Is Not require");
                                            },
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 15, 0, 0),
                                          hintText:
                                              'Please enter ${widget.vendorData.fields[index].fieldName.toLowerCase()}',
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.red, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.black, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                      // style: AppTheme.form_field_text,
                                      keyboardType: widget.vendorData
                                                  .fields[index].inputType ==
                                              "Email"
                                          ? TextInputType.emailAddress
                                          : widget.vendorData.fields[index]
                                                      .inputType ==
                                                  "Number"
                                              ? TextInputType.number
                                              : widget.vendorData.fields[index]
                                                          .inputType ==
                                                      "Text"
                                                  ? TextInputType.text
                                                  : null,
                                    ),
                                    //   ),
                                    // ),
                                    const SizedBox(height: 20.0),
                                  ],
                                ))),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.white,
                child: isApiProcessing == true
                    ? Container(
                        height: 60,
                        alignment: Alignment.center,
                        width: 80,
                        child: const GFLoader(type: GFLoaderType.circle),
                      )
                    : InkWell(
                        onTap: () async {
                          if (_formKey!.currentState!.validate()) {
                            print("Validate number");
                            await addVendor();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryButtonColor,
                          ),
                          height: 40,
                          padding: EdgeInsets.all(4),
                          alignment: Alignment.center,
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _csvSampleDialog(BuildContext context) async{
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          content: Wrap(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      // Text('Add New '+page_title),
                      Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                                onTap: ()=>{
                                  _displayFromDialog(context)
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 5),
                                  padding: EdgeInsets.only(top:5,bottom: 5,left: 5,right: 5),
                                  decoration: BoxDecoration(
                                    //color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: const Text(
                                    ' For successful import from csv file you have to arrange columns in same format as per in sample sheet',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.blue),
                                  ),
                                )
                            ),
                          )

                      )
                    ],
                  ),
                  SizedBox(width: 12,),
                  // Row(
                  //   children: <Widget>[
                  //     //Text('Add New '+page_title),
                  //     Expanded(child: Container(
                  //       alignment: Alignment.center,
                  //       child: GestureDetector(
                  //           onTap: ()=>{
                  //             generateCsv()
                  //           },
                  //           child: Container(
                  //             margin: EdgeInsets.only(left: 5),
                  //             padding: EdgeInsets.only(top:5,bottom: 5,left: 5,right: 5),
                  //             decoration: BoxDecoration(
                  //               //color: Colors.blue,
                  //                 borderRadius: BorderRadius.circular(5)
                  //             ),
                  //             child: Text(
                  //               'Get Sample .csv file',
                  //               textAlign: TextAlign.center,
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.bold,
                  //                   fontSize: 15,
                  //                   color: Colors.blueGrey),
                  //             ),
                  //           )
                  //       ),
                  //     ))
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('CANCEL'),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                            //Navigator.pop(context);
                          });
                        },
                      ),
                      SizedBox(width: 10,),
                      ElevatedButton(
                        child: Text('OK'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: ()=>{
                          loadCsvFromStorage()
                        },
                      ),
                    ],
                  )
                ],
              )
            ],
          )
      ),
    );
  }

  Future<void> _displayFromDialog(BuildContext context) async{
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          content: Wrap(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      // Text('Add New '+page_title),
                      Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: GestureDetector(
                                onTap: ()=>{
                                  generateCsv()
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 5),
                                  padding: EdgeInsets.only(top:5,bottom: 5,left: 5,right: 5),
                                  decoration: BoxDecoration(
                                    //color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: const Text(
                                    '1. Export Sample .csv',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.blue),
                                  ),
                                )
                            ),
                          )
                      )
                    ],
                  ),
                  SizedBox(width: 10,),
                  Row(
                    children: <Widget>[
                      //Text('Add New '+page_title),
                      Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        child: GestureDetector(
                            onTap: ()=>{
                              _csvSampleDialog(context)
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 5),
                              padding: EdgeInsets.only(top:5,bottom: 5,left: 5,right: 5),
                              decoration: BoxDecoration(
                                //color: Colors.blue,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: Text(
                                '2. Import from .csv',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.blueGrey),
                              ),
                            )
                        ),
                      )
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('CANCEL'),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  )
                ],
              )
            ],
          )
      ),
    );
  }

  generateCsv() async {
    print('1');

    List<List<String>> dataList=[];

    print('2');

    List<String> data=[];

    if(widget.vendorData.fields.isNotEmpty)
    {
      // data.add('Select All');
      for(int i=0;i<widget.vendorData.fields.length;i++)
        data.add(widget.vendorData.fields[i].fieldName);
    }
    dataList.add(data);

    String csvData = ListToCsvConverter().convert(dataList);

    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/sample${DateTime.now()}.csv').create();
    await file.writeAsString(csvData);

    if(file!=null){
      ShareExtend.share(file.path, "file");
    }
  }

  loadCsvFromStorage() async {
    print("call getData from LoadSvg");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['csv'],
      type: FileType.custom,
    );
    String path = result!.files.first.path!;
    //print("filepath"+path);
    final input = new File(path).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
    List<dynamic> title=fields[0];

    print(title.toString());
    print(fields.toString());
    for(int i=0;i<widget.vendorData.fields.length;i++) {
      print("csv"+title[i].toString().trim());
      print("header"+widget.vendorData.fields[i].fieldName.toString());
      if(title[i].toString().trim().toLowerCase()==widget.vendorData.fields[i].fieldName.toString().toLowerCase()){
        //print("inner"+headerColumn[i].columnValue);
        // if(widget.vendorData.fields[i].columnValue.contains("Customer Name") || widget.vendorData.fields[i].columnValue.contains("Name"))
        // {
        //   nameindex=i;
        // }else if(widget.vendorData.fields[i].columnValue.contains("Contact") ||widget.vendorData.fields[i].columnValue.contains("Mobile No")||headerColumn[i].columnValue.contains("Contact no"))
        // {
        //   contactindex=i;
        // }
        // else if(headerColumn[i].columnValue.contains("email") ||headerColumn[i].columnValue.contains("Email"))
        // {
        //   emailindex=i;
        // }
        csvColumn.add(widget.vendorData.fields[i].fieldName.toString());
      }else
      {
        csvColumn.clear();
        Fluttertoast.showToast(msg: "Columns does't match from app and csv file", backgroundColor: Colors.grey,);
        break;
      }
    }
    if(csvColumn.isNotEmpty) {
      if(this.mounted){
        setState(() {
          iscsvProcessing=true;
        });
      }
      double progresscount=(fields.length)/100;
      for (int i = 1;i<fields.length;i++)
      {
        List<dynamic> title=fields[i];
        //addCustomercsv(title[nameindex].toString(),title[emailindex].toString(),title[contactindex].toString());
        addVendorFromcsv(title);
      }
      if(this.mounted){
        setState(() {
          iscsvProcessing=false;
        });
      }
      //Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    //
    }
  }

  Future<List<List<dynamic>>> loadingCsvData(String path) async {
    final csvFile = new File(path).openRead();
    return await csvFile
        .transform(utf8.decoder)
        .transform(
      CsvToListConverter(),
    ).toList();
  }

  Future addVendor() async {
    setState(() {
      isApiProcessing = true;
    });

    // Map<String, dynamic> body = {
    //   request.fields["CATEGORY_AUTO_ID"]: widget.vendorData.id,
    //   request.fields["ADMIN_AUTO_ID"]: widget.vendorData.adminAutoId,
    //   request.fields["APP_TYPE_ID"]: widget.vendorData.appTypeId,
    // };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('user_id');
    // print("login body ${body}");

    print("user id ${userID}");
    var url = AppConfig.grobizBaseUrl + add_pountry_vendor;

    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);
    request.fields["CATEGORY_AUTO_ID"] = widget.vendorData.id;
    request.fields["USER_AUTO_ID"] = userID!;
    request.fields["ADMIN_AUTO_ID"] = widget.vendorData.adminAutoId;
    request.fields["APP_TYPE_ID"] = widget.vendorData.appTypeId;

    for (int i = 0; i < widget.vendorData.fields.length; i++) {
      if (widget.vendorData.fields[i].inputType == "File") {
        try {
          if (resume_file != null) {
            request.files.add(
              http.MultipartFile(
                '${widget.vendorData.fields[i].fieldName}',
                resume_file[i].readAsBytes().asStream(),
                await resume_file[i].length(),
                filename: resume_file[i].path.split('/').last,
              ),
            );
          } else {
            request.fields["${widget.vendorData.fields[i].fieldName}"] = '';
          }
        } catch (exception) {
          print('resume not selected');
          request.fields["${widget.vendorData.fields[i].fieldName}"] = '';
        }
      } else {
        request.fields['${widget.vendorData.fields[i].fieldName}'] =
            textController[i].text;
      }
    }

    http.Response response =
        await http.Response.fromStream(await request.send());

    print("login response  ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        isApiProcessing = false;
      });

      final resp = jsonDecode(response.body);
      int status = resp['status'];

      // if(status=="1"){
      //   Navigator.of(context).push(
      //       MaterialPageRoute(
      //           builder: (context) => OtpScreen(mobileNumber,country_code+'-'+phone_code)));
      // }
      // else if(status=="0"){
      Fluttertoast.showToast(msg: response.statusCode.toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setBool('VENDOR_ADDED', true);

      Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.routeName, (Route<dynamic> route) => false);
      // }
    } else {
      setState(() {
        isApiProcessing = false;
      });

      Fluttertoast.showToast(msg: response.statusCode.toString());
      if (this.mounted) {
        setState(() {});
      }
    }
  }

    Future addVendorFromcsv(List<dynamic> vendorlist) async {
      setState(() {
        isApiProcessing = true;
      });

      // Map<String, dynamic> body = {
      //   request.fields["CATEGORY_AUTO_ID"]: widget.vendorData.id,
      //   request.fields["ADMIN_AUTO_ID"]: widget.vendorData.adminAutoId,
      //   request.fields["APP_TYPE_ID"]: widget.vendorData.appTypeId,
      // };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userID = prefs.getString('user_id');
      // print("login body ${body}");

      print("user id ${userID}");
      var url = AppConfig.grobizBaseUrl + add_pountry_vendor;

      var uri = Uri.parse(url);
      var request = http.MultipartRequest("POST", uri);
      request.fields["CATEGORY_AUTO_ID"] = widget.vendorData.id;
      request.fields["USER_AUTO_ID"] = userID!;
      request.fields["ADMIN_AUTO_ID"] = widget.vendorData.adminAutoId;
      request.fields["APP_TYPE_ID"] = widget.vendorData.appTypeId;

      for (int i = 0; i < widget.vendorData.fields.length; i++) {
        if (widget.vendorData.fields[i].inputType == "File") {
          // try {
          //   if (resume_file != null) {
          //     request.files.add(
          //       http.MultipartFile(
          //         '${widget.vendorData.fields[i].fieldName}',
          //         resume_file[i].readAsBytes().asStream(),
          //         await resume_file[i].length(),
          //         filename: resume_file[i].path.split('/').last,
          //       ),
          //     );
          //   } else {
          //     request.fields["${widget.vendorData.fields[i].fieldName}"] = '';
          //   }
          // } catch (exception) {
          //   print('resume not selected');
          //   request.fields["${widget.vendorData.fields[i].fieldName}"] = '';
          // }
        } else {
          request.fields['${widget.vendorData.fields[i].fieldName}'] =
             vendorlist[i].toString();
        }
      }

      http.Response response =
      await http.Response.fromStream(await request.send());

      print("import  ${response.body}");
      if (response.statusCode == 200) {
        setState(() {
          isApiProcessing = false;
        });

        final resp = jsonDecode(response.body);
        int status = resp['status'];

        Fluttertoast.showToast(msg: "Data imported successfully ");
        SharedPreferences prefs = await SharedPreferences.getInstance();

      } else {
        setState(() {
          isApiProcessing = false;
        });

        Fluttertoast.showToast(msg: response.statusCode.toString());
        if (this.mounted) {
          setState(() {});
        }
      }
    }

  }
