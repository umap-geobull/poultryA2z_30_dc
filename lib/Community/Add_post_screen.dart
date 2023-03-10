import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/App_Apis.dart';
import '../profile/Myaccount/Myprofile_model.dart';
import 'package:http/http.dart' as http;

class AddPoatScreen extends StatefulWidget {
  const AddPoatScreen({Key? key}) : super(key: key);

  @override
  State<AddPoatScreen> createState() => _AddPoatScreenState();
}

class _AddPoatScreenState extends State<AddPoatScreen> {
  Color appBarColor = Colors.white,
      appBarIconColor = Colors.black,
      primaryButtonColor = Colors.orange,
      secondaryButtonColor = Colors.orangeAccent;
  Color bottomBarColor = Colors.white, bottomMenuIconColor = Color(0xFFFF7643);
  String baseUrl = '', user_id = '', admin_auto_id = '', app_type_id = '';
  bool isApiCallProcessing=false;
  late MyProfile_model profile_model;
  TextEditingController tv_name = TextEditingController();
  TextEditingController tv_email = TextEditingController();
  TextEditingController tv_mobile = TextEditingController();
  TextEditingController post = TextEditingController();
  late File resume_file;
  bool isfileuploaded = false;
  bool isApiProcessing = false;

  void getappUi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? appBarColor = prefs.getString('appbarColor');
    String? appbarIcon = prefs.getString('appbarIconColor');
    String? primaryButtonColor = prefs.getString('primaryButtonColor');
    String? secondaryButtonColor = prefs.getString('secondaryButtonColor');
    String? bottomBarColor = prefs.getString('bottomBarColor');
    String? bottombarIcon = prefs.getString('bottomBarIconColor');

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
    if (bottomBarColor != null) {
      this.bottomBarColor = Color(int.parse(bottomBarColor));
      setState(() {});
    }

    if (bottombarIcon != null) {
      this.bottomMenuIconColor = Color(int.parse(bottombarIcon));
      setState(() {});
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  void getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid = prefs.getString('app_type_id');
    String? userType = prefs.getString('user_type');

    if (baseUrl != null &&
        userId != null &&
        adminId != null &&
        apptypeid != null) {
      if (this.mounted) {
        this.admin_auto_id = adminId;
        this.baseUrl = baseUrl;
        this.user_id = userId;
        this.app_type_id = apptypeid;

        // getData();
        // getFilterList();
        GetProfileData();
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getappUi();
    getBaseUrl();
  }

  GetProfileData() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    var url = baseUrl+'api/' + get_user_profile;

    Uri uri=Uri.parse(url);

    final body = {
      "user_auto_id": user_id,
    };
    var response = await http.post(uri, body: body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {

      profile_model = MyProfile_model.fromJson(json.decode(response.body));
      var userDataList = profile_model.data;
      var status =profile_model.status;
      print(status);
      if(status=='1') {
        tv_name.text = userDataList.name;
        tv_email.text = userDataList.emailId;
        tv_mobile.text = userDataList.mobileNumber;
        admin_auto_id=userDataList.admin_auto_id!;
        setState(() {
          isApiCallProcessing = false;
        });
      }else{
        print('Data not available');
      }
    } else {
      throw Exception('Unexpected error occured!');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text("Add New Post",
              style: TextStyle(
                  color: appBarIconColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: () => {Navigator.of(context).pop()},
            icon: Icon(Icons.arrow_back, color: appBarIconColor),
          ),
         ),
      body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height -100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(""
                        "Select Image to upload",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),

                    SizedBox(height: 10,),
                    !isfileuploaded
                        ? GestureDetector(
                        onTap: () async {
                          FilePickerResult? result =
                          await FilePicker.platform
                              .pickFiles(
                            type: FileType.custom,
                            allowedExtensions: [
                              'jpg',
                              'png',
                            ],
                          );
                          if (result != null) {
                            PlatformFile file =
                                result.files.first;
                            setState(() {
                              resume_file =
                                  File(file.path!);
                              print(
                                  "${resume_file.path.isEmpty}");
                              isfileuploaded = true;
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
                              border: Border.all(
                                  color: Colors.grey),
                              // boxShadow: [
                              //   BoxShadow(
                              //       color:
                              //       Color.fromRGBO(
                              //           0,
                              //           0,
                              //           0,
                              //           0.15),
                              //       offset:
                              //       Offset(1, 6),
                              //       blurRadius: 12)
                              // ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(
                                      context)
                                      .size
                                      .width,
                                  height: 200,
                                  padding:
                                  EdgeInsets.all(
                                      30),
                                  // color: Colors.white!,
                                  child: Icon(Icons.image,size: 70,color: Colors.grey,),
                                ),

                              ],
                            ))
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
                              resume_file =
                                  File(file.path!);
                              print(
                                  "${resume_file.path.isEmpty}");
                              isfileuploaded = true;
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
                        child:
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
                              // border: Border.all(
                              //     color: Colors.grey),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(
                                      context)
                                      .size
                                      .width,
                                  height: 200,
                                  padding:
                                  EdgeInsets.all(
                                      4),
                                  // color: Colors.white!,
                                  child: ClipRRect(

                                    borderRadius:
                                    const BorderRadius.all(
                                        Radius.circular(
                                            10)),
                                    child: Image.file(
                                        File(resume_file
                                            .path),fit: BoxFit.fill,),
                                  ),
                                ),

                              ],
                            ))
                    ),

                    SizedBox(height: 20,),
                    const Text("Add Post description",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),

                    SizedBox(height: 10,),

                    TextFormField(
                      controller: post,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                          const EdgeInsets.fromLTRB(
                              10, 15, 0, 0),
                          hintText:
                          'Add post description',
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
                        maxLines: 5,
                        // decoration: InputDecoration(
                        //     border: InputBorder.none,
                        //     focusedBorder: InputBorder.none,
                        //     enabledBorder: InputBorder.none,
                        //     errorBorder: InputBorder.none,
                        //     disabledBorder: InputBorder.none,
                        //     contentPadding: EdgeInsets.only(
                        //         left: 15, right: 15),
                        //     fillColor: Colors.white,
                        //     hintText: "Add a post.."),
                      // style: AppTheme.form_field_text,
                      keyboardType: TextInputType.text

                    ),
                    // Divider(color: Colors.grey,),
                    Container(
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
                          // if (_formKey!.currentState!.validate()) {
                          //   print("Validate number");
                          //   await addVendor();
                          // }
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
                            "Post",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ]),
            ),
          )
      ),
    );
  }
}
