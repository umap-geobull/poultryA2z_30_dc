import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import '../Utils/App_Apis.dart';
import '../Utils/coustom_bottom_nav_bar.dart';
import '../Utils/enums.dart';
import 'package:http/http.dart' as http;

class AddVacancyScreen extends StatefulWidget {
  const AddVacancyScreen({
    super.key,
  });

  @override
  State<AddVacancyScreen> createState() => _AddVacancyScreenState();
}

class _AddVacancyScreenState extends State<AddVacancyScreen> {

  TextEditingController jobtitle_controller = new TextEditingController();
  TextEditingController experience_controller = new TextEditingController();
  TextEditingController salary_controller = new TextEditingController();
  TextEditingController description_controller = TextEditingController();

  bool isApiCallProcessing=false;
  Color appBarColor = Colors.white,
      appBarIconColor = Colors.black,
      primaryButtonColor = Colors.orange,
      secondaryButtonColor = Colors.orangeAccent;
  String user_id = '';
  String baseUrl = '', admin_auto_id = '',app_type_id='';
  Color bottomBarColor=Colors.white, bottomMenuIconColor=Color(0xFFFF7643);

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
            title: Text(
              'Add Vacancy',
              style: TextStyle(color: appBarIconColor),
            ),
            leading: IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(Icons.arrow_back, color: Colors.grey),
            )),
        body: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

                  Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.black12)
                      // ),
                      child: SizedBox(
                        height: 140,width: 140,
                        child:Image.asset('assets/job_vacancy.png'),)),

              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: jobtitle_controller,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    labelText: 'Job Title',
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(),
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: experience_controller,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    labelText: 'Experience',
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(),
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: salary_controller,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    labelText: 'Salary Expectation',
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(),
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 100,
                child: TextField(
                  controller: description_controller,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(),
                  keyboardType: TextInputType.text,
                  maxLines: 5,
                ),
              ),
              const SizedBox(
                height: 15,
              ),

              isApiCallProcessing==false?SizedBox(width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    if(isValid())
                      {
                        _onSave();
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
                ),):
              isApiCallProcessing==true?
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: const GFLoader(
                    type:GFLoaderType.circle
                ),
              ):
              Container()
            ],
          ),
        )),
    bottomSheet: CustomBottomNavBar(MenuState.profile,bottomBarColor,bottomMenuIconColor,));
  }


  bool isValid()
  {
    if (jobtitle_controller.text == ""|| jobtitle_controller.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter job title ", backgroundColor: Colors.grey,);
      return false;
    }
    else if (experience_controller.text == ""|| experience_controller.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter experience", backgroundColor: Colors.grey,);
      return false;
    }
    else if (salary_controller.text == ""|| salary_controller.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter salary expectations", backgroundColor: Colors.grey,);
      return false;
    }
    else if (description_controller.text == ""|| description_controller.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter job description", backgroundColor: Colors.grey,);
      return false;
    }
    return true;
  }
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? baseUrl = prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');

    if (baseUrl != null && userId != null && adminId != null && apptypeid!=null) {
      if (mounted) {
        setState(() {
          user_id = userId;
          this.baseUrl = baseUrl;
          this.admin_auto_id = adminId;
          this.app_type_id=apptypeid;
        });
      }
    }
    return null;
  }

  void getappUi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? appBarColor = prefs.getString('appbarColor');
    String? appbarIcon = prefs.getString('appbarIconColor');
    String? primaryButtonColor = prefs.getString('primaryButtonColor');
    String? secondaryButtonColor = prefs.getString('secondaryButtonColor');
    String? bottomBarColor =prefs.getString('bottomBarColor');
    String? bottombarIcon =prefs.getString('bottomBarIconColor');

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
    if(bottomBarColor!=null){
      this.bottomBarColor=Color(int.parse(bottomBarColor));
      setState(() {});
    }

    if(bottombarIcon!=null){
      this.bottomMenuIconColor=Color(int.parse(bottombarIcon));
      setState(() {});
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  Future<void> _onSave() async {

    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "job_title": jobtitle_controller.text,
      "experience":experience_controller.text,
      "salary_expectations":salary_controller.text,
      "job_description":description_controller.text,
      "user_auto_id":user_id,
      "admin_auto_id":admin_auto_id,
      "app_type_id":app_type_id,
    };

    var url = baseUrl+'api/' + add_job_vacancy;
// //print(body.toString());
// //print(url);
    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        Fluttertoast.showToast(
          msg: "Job send for approval.please wait till your admin approve it...",
          backgroundColor: Colors.black87,
        );
        Navigator.pop(context);
      }
      else {
        print('empty');
      }
      if(mounted){
        setState(() {});
      }
    }else if(response.statusCode==500)
      {
        isApiCallProcessing=false;
        Fluttertoast.showToast(
          msg: "server error",
          backgroundColor: Colors.grey,
        );
      }
  }

}
