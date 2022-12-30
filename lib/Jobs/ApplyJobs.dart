import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';

import '../Utils/coustom_bottom_nav_bar.dart';
import '../Utils/enums.dart';

class ApplyJobs extends StatefulWidget {

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
  TextEditingController tv_address = TextEditingController();
  TextEditingController tv_expected_salary = TextEditingController();
  // TextEditingController tv_latitude = TextEditingController();
  // TextEditingController tv_longitude = TextEditingController();
  TextEditingController tv_category = TextEditingController();
  TextEditingController tv_state = TextEditingController();
  TextEditingController tv_country = TextEditingController();
  TextEditingController tv_address_type = TextEditingController();
  List<String> selected_categories=[];
  String selectedJobs='';

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

                      GestureDetector(
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
                          ),

                      const SizedBox(height: 15),
                      SizedBox(width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          if(checkValidations()==true){
                            //addUserAddress();
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
                    child: Checkbox(
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {
                            if (isAdded(Category_list[index]) == true)
                            {
                              selected_categories.remove(Category_list[index]);
                              //print(selected_manufacturer_id.toString());
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
                    margin: const EdgeInsets.all(5),
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
        msg: 'Please add pincode',
        backgroundColor: Colors.black,
      );
      return false;
    }
    else  if(tv_category.text.isEmpty){
      Fluttertoast.showToast(
        msg: 'Please add city',
        backgroundColor: Colors.black,
      );
      return false;
    }
    else  if(tv_address.text.isEmpty){
      Fluttertoast.showToast(
        msg: 'Please add address details',
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
                    onPressed: () {
                     // getImage(ImageSource.camera);
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
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      //getImage(ImageSource.gallery);
                    },
                    child: const Text("Drive",
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryButtonColor,
                      minimumSize: const Size(150, 30),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
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
