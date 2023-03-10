import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'package:file_picker/file_picker.dart';
import '../Utils/coustom_bottom_nav_bar.dart';
import '../Utils/enums.dart';

class ApplyJobs extends StatefulWidget {
String job_id;
ApplyJobs(this.job_id);
  @override
  _ApplyJobs createState() => _ApplyJobs();
}

Future<void> deleteData(String addressId) async {

}

class _ApplyJobs extends State<ApplyJobs> {
  late String cname, mobile, pincode, area, latitude='1.2546', longitude='2.4586',city,state='Maharashtra',country='India',address,addtype='Home';

  TextEditingController tv_name = TextEditingController();
  TextEditingController tv_mobile = TextEditingController();
  TextEditingController tv_experience = TextEditingController();
  TextEditingController tv_expected_salary = TextEditingController();
  TextEditingController tv_category = TextEditingController();
  TextEditingController tv_state = TextEditingController();
  TextEditingController tv_country = TextEditingController();
  TextEditingController tv_address_type = TextEditingController();
  List<String> selected_categories=[];
  String selectedJobs='';
  bool isfileuploaded=false;

  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;

  Color bottomBarColor=Colors.white, bottomMenuIconColor=Color(0xFFFF7643);
  String user_id='';
  String baseUrl='', admin_auto_id='';
  bool isApiCallProcessing=false;
  List<String> Category_list = [
    'Veterinarian',
    'Feed Plant',
    'Breeder and Hatchery',
    'Pharma',
    'Integration',
    'Farm Manager',
    'Other'
  ];
  String category='Select Category';
  bool loaded = false;
  bool isaddApiCallProcessing=false;
  late File resume_file;
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? baseUrl =prefs.getString('base_url');
    String? adminId =prefs.getString('admin_auto_id');

    if (baseUrl!=null && userId != null && adminId!=null) {
      if(mounted){
        setState(() {
          user_id = userId;
          this.baseUrl=baseUrl;
          this.admin_auto_id=adminId;
        });
      }
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getappUi();
    getUserId();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
          title: const Text("Apply Jobs", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          )
      ),
      body: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                    /*  Container(
                        margin: EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: Text('Select location from map',style: TextStyle(color: Colors.white,fontSize: 15),),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orangeAccent,
                          ),
                        ),
                      ),
*/
                      const SizedBox(height: 15),

                      SizedBox(
                        height: 50,
                        child: TextField(
                          // maxLines: 1,
                          controller: tv_name,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            labelText: "Full Name",
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 70,
                        child: TextField(
                          maxLength: 10,
                          controller: tv_mobile,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            labelText: "Mobile No.",
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(),
                            // hintText: 'Mobile No.',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: tv_experience,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            // prefixIcon: Icon(Icons.description),
                            border: OutlineInputBorder(),
                            labelText: 'Experience',
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: tv_expected_salary,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            // prefixIcon: Icon(Icons.description),
                            border: OutlineInputBorder(),
                            labelText: 'Expected Salary',
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: showSelectcategory,
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: tv_category,
                            enabled: false,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              // prefixIcon: Icon(Icons.description),
                              border: OutlineInputBorder(),
                              labelText: 'Select Category',
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),

                      !isfileuploaded?GestureDetector(
                          onTap: showImageDialog,
                            child:
                            Container(
                                margin: EdgeInsets.only(top: 20),
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Stack(children: [
                                  Container(
                                    width: 300,
                                    height: 120,
                                    padding: EdgeInsets.all(30),
                                   // color: Colors.white!,
                                    child: Image.asset('assets/upload_cv.png'),
                                  ),
                                  Container(
                                      width: 300,
                                      //margin: EdgeInsets.only(top: 280),
                                      //color: Colors.white!,
                                      alignment: Alignment.center,
                                      child:Text('Upload cv',style: TextStyle(fontSize: 16),)
                                  )
                                ],)
                            ),
                          ):Text(resume_file.path.toString()),

                      const SizedBox(height: 15),
                      SizedBox(width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          if(checkValidations()==true){
                            //addUserAddress();
                            apply_job();
                          }
                        },
                        child: const Text('Save'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200,50),
                          backgroundColor: primaryButtonColor,
                          shape: const StadiumBorder(),
                          shadowColor: Colors.grey,
                          elevation: 5,
                        ),
                      ),)
                    ],
                  )),

            ),

            isApiCallProcessing==true?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: const GFLoader(
                  type:GFLoaderType.circle
              ),
            ):
            Container()
          ]),
      bottomSheet: CustomBottomNavBar(MenuState.profile,
        bottomBarColor,bottomMenuIconColor,),
    );
  }

  showSelectcategory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.green[50],
        title: const Text(
          'Select Job Type',
          style: TextStyle(color: Colors.black87,fontSize: 15),
        ),
        content:
        //!allAppTypes.isEmpty?
        Container(
            height: 320,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                   SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: showcolorlistUi(),
                      ),
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setCategory();
                    },
                    child: const Text("ok",
                        style: TextStyle(color: Colors.black54, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryButtonColor,
                      minimumSize: const Size(80, 30),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),

                      // getmanufaturer_List.isEmpty && isApiCallProcessing == false ?
                      // Center(child: Text('No Manufacturers')) :
                      // Container(
                      //   alignment: Alignment.center,
                      //   width: MediaQuery.of(context).size.width,
                      //   child:
                      //   const GFLoader(type: GFLoaderType.circle),
                      // ),

              ],
            ),
        )
      ),
    );
  }

  Future apply_job() async {
    if(mounted) {
      setState(() {
       isaddApiCallProcessing = true;
      });
    }
    var url = baseUrl + 'api/' + apply_jobs;

    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);

    try {
      if (resume_file != null) {
        request.files.add(
          http.MultipartFile(
            'resume',
            resume_file.readAsBytes().asStream(),
            await resume_file.length(),
            filename: resume_file.path.split('/').last,
          ),
        );
      } else {
        request.fields["resume"] = '';
      }
    } catch (exception) {
      print('resume not selected');
      request.fields["resume"] = '';
    }
    request.fields["candidate_name"] = tv_name.text;
    request.fields["mobile_no"] = tv_mobile.text;
    request.fields["experience"] = tv_experience.text;
    request.fields["expected_salary"] = tv_expected_salary.text;
    request.fields["category"] = tv_category.text;
    request.fields["user_auto_id"] = user_id;
    request.fields["job_auto_id"] = widget.job_id;
    print(request.fields.toString());
    http.Response response =
    await http.Response.fromStream(await request.send());
    print(response.statusCode.toString());

    if (response.statusCode == 200) {
      setState(() {
        isaddApiCallProcessing = false;
      });
      final resp = jsonDecode(response.body);
      //String message=resp['msg'];
      int status = resp['status'];
      if (status == 1) {
        Fluttertoast.showToast(
          msg: "Applied successfully",
          backgroundColor: Colors.grey,
        );
        // widget.onSaveCallback();
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: "Something went wrong.Please try later",
          backgroundColor: Colors.grey,
        );
      }
    }
  }

  showcolorlistUi() {
    return SizedBox(
      width: MediaQuery.of(context).size.width/2,
      height: 260,
      child: GridView.builder(
          itemCount: Category_list.length,
          // physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 5,
            crossAxisCount: 1,
          ),
          itemBuilder: (context, index) => SizedBox(
            //width: MediaQuery.of(context).size.width/2,
            height: 20,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 22,
                    width: 22,
                    margin: const EdgeInsets.all(5),
                    child: Checkbox(
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {
                            if (isAdded(Category_list[index]) == true)
                            {
                              selected_categories.remove(Category_list[index]);
                              print(selected_categories.toString());
                             // widget.onSaveCallback(selected_manufacturer_id);
                            }
                            else {
                              selected_categories.add(Category_list[index]);
                             // widget.onSaveCallback(selected_manufacturer_id);
                            }
                          });
                        }
                      },
                      value: isAdded(Category_list[index]),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      Category_list[index],
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

  bool isAdded(String id) {
    for (int i = 0; i < selected_categories.length; i++) {
      if (selected_categories[i] == id) {
        return true;
      }
    }
    return false;
  }

  setData(){
    this.selected_categories=selectedJobs.split(',');
    if(this.mounted){
      setState(() {
      });
    }
  }

  setCategory(){
    for(int index=0;index<selected_categories.length;index++){
      if(index==0 || index==1){
        if(selectedJobs!='') {
          selectedJobs += ','+selected_categories[index];
        }else{
          selectedJobs+=selected_categories[index];
        }
      }
      else{
        selectedJobs+= ','+selected_categories[index];
      }
    }
    tv_category.text=selectedJobs;
    if(this.mounted){
      setState(() {
      });
    }
  }

  bool checkValidations(){

    if(tv_name.text.isEmpty){
      Fluttertoast.showToast(
        msg: 'Please add name',
        backgroundColor: Colors.black,
      );
      return false;
    }
    else  if(tv_mobile.text.isEmpty){
      Fluttertoast.showToast(
        msg: 'Please add mobile number',
        backgroundColor: Colors.black,
      );
      return false;
    }
    else  if(tv_experience.text.isEmpty){
      Fluttertoast.showToast(
        msg: 'Please add experience',
        backgroundColor: Colors.black,
      );
      return false;
    }
    else  if(tv_category.text.isEmpty){
      Fluttertoast.showToast(
        msg: 'Please select category',
        backgroundColor: Colors.black,
      );
      return false;
    }
    else  if(tv_expected_salary.text.isEmpty){
      Fluttertoast.showToast(
        msg: 'Please add expected salary',
        backgroundColor: Colors.black,
      );
      return false;
    }
    return true;
  }

  showImageDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: const Text(
            'Upload CV from',
            style: TextStyle(color: Colors.black87),
          ),
          content: SizedBox(
            height: 110,
            child: Column(
              children: <Widget>[
                Container(
                  child: ElevatedButton(
                    onPressed: () async {
                      //get(ImageSource.camera);
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'doc'],
                        allowMultiple: false
                      );
                      if (result != null) {
                        PlatformFile file = result.files.first;
                        resume_file=File(file.path!);
                        isfileuploaded=true;
                        print(file.name);
                        print(file.bytes);
                        print(file.size);
                        print(file.extension);
                        print(file.path);
                      } else {
                        print('No file selected');
                      }
                      Navigator.pop(context);
                    },
                    child: const Text("File Manager",
                        style: TextStyle(color: Colors.black54, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryButtonColor,
                      minimumSize: const Size(150, 30),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Container(
                //   child: ElevatedButton(
                //     onPressed: () {
                //       //getImage(ImageSource.gallery);
                //     },
                //     child: const Text("Drive",
                //         style: TextStyle(color: Colors.white, fontSize: 13)),
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: secondaryButtonColor,
                //       minimumSize: const Size(150, 30),
                //       shape: const RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          )),
    );
  }

  void getappUi() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? appBarColor =prefs.getString('appbarColor');
    String? appbarIcon =prefs.getString('appbarIconColor');
    String? primaryButtonColor =prefs.getString('primaryButtonColor');
    String? secondaryButtonColor =prefs.getString('secondaryButtonColor');
    String? bottomBarColor =prefs.getString('bottomBarColor');
    String? bottombarIcon =prefs.getString('bottomBarIconColor');

    if(appBarColor!=null){
      this.appBarColor=Color(int.parse(appBarColor));
    }

    if(appbarIcon!=null){
      this.appBarIconColor=Color(int.parse(appbarIcon));
    }

    if(primaryButtonColor!=null){
      this.primaryButtonColor=Color(int.parse(primaryButtonColor));
    }

    if(secondaryButtonColor!=null){
      this.secondaryButtonColor=Color(int.parse(secondaryButtonColor));
    }
    if(bottomBarColor!=null){
      this.bottomBarColor=Color(int.parse(bottomBarColor));
      setState(() {});
    }

    if(bottombarIcon!=null){
      this.bottomMenuIconColor=Color(int.parse(bottombarIcon));
      setState(() {});
    }
    if(this.mounted){
      setState(() {});
    }
  }
}
