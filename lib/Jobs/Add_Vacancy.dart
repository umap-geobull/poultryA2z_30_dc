import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/coustom_bottom_nav_bar.dart';
import '../Utils/enums.dart';

class AddVacancyScreen extends StatefulWidget {
  const AddVacancyScreen({
    super.key,
  });

  @override
  State<AddVacancyScreen> createState() => _AddVacancyScreenState();
}

class _AddVacancyScreenState extends State<AddVacancyScreen> {
  // List<String> Arrival_List = [
  //   'Select category',
  //   'Grocery',
  //   'Flats',
  //   'Clothing',
  //   'Furniture',
  //   'Repair & Services',
  // ];
  // String? selectedValue;
  // String selectedcategory="";
  // bool isApiCallProcessing=false;
  // bool enablesearch=false;
  // List<Specification> specificationlist=[];
  // List<Product_Info_Model> product_info_model_List=[];
  TextEditingController tv_businessnamecontroller = new TextEditingController();
  TextEditingController tv_ownernamecontroller = new TextEditingController();
  TextEditingController tv_discriptioncontroller = new TextEditingController();
  TextEditingController searchcontroller = TextEditingController();
  Color appBarColor = Colors.white,
      appBarIconColor = Colors.black,
      primaryButtonColor = Colors.orange,
      secondaryButtonColor = Colors.orangeAccent;
  String user_id = '';
  String baseUrl = '', admin_auto_id = '';
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
              // product_info_model_List.isNotEmpty?Container(
              //   decoration: BoxDecoration(
              //       border: Border.all(color: Colors.black12)
              //   ),
              //   child:  ImagesUi(),):
              // GestureDetector(
              //     onTap: fetch_images,
              //     child:
                  Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.black12)
                      // ),
                      child: SizedBox(
                        height: 140,width: 140,
                        child:Image.asset('assets/job_vacancy.png'),)),
            // ),
              // const SizedBox(
              //   height: 10,),

              // const Text("Product Name",
              //     style: TextStyle(color: Colors.black, fontSize: 16)),
              // const SizedBox(
              //   height: 8,
              // ),
              // InputText(),
              // const Text("Price Range",
              //     style: TextStyle(color: Colors.black, fontSize: 16)),
              // const SizedBox(
              //   height: 8,
              // ),
              // const SizedBox(
              //   height: 10,),
              // SizedBox(
              //   height: 50,
              //   child: TextField(
              //     // maxLines: 1,
              //     // controller: tv_name,
              //     textAlignVertical: TextAlignVertical.center,
              //     decoration: const InputDecoration(
              //       labelText: "Business Name",
              //       labelStyle: TextStyle(fontWeight: FontWeight.w100),
              //       contentPadding: EdgeInsets.all(15),
              //       border: OutlineInputBorder(),
              //     ),
              //     style: const TextStyle(
              //     ),
              //     keyboardType: TextInputType.text,
              //   ),
              // ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: tv_businessnamecontroller,
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
              // SizedBox(
              //   height: 50,
              //   child: TextField(
              //     // maxLines: 1,
              //     // controller: tv_name,
              //     textAlignVertical: TextAlignVertical.center,
              //     decoration: const InputDecoration(
              //       labelText: "Owner Name",
              //       contentPadding: EdgeInsets.all(15),
              //       border: OutlineInputBorder(),
              //     ),
              //     style: const TextStyle(
              //     ),
              //     keyboardType: TextInputType.text,
              //   ),
              // ),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: tv_businessnamecontroller,
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
                  controller: tv_businessnamecontroller,
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
                  controller: tv_businessnamecontroller,
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
              SizedBox(width: 200,
                child: ElevatedButton(
                  onPressed: () {

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
          ),
        )),
    bottomSheet: CustomBottomNavBar(MenuState.profile,bottomBarColor,bottomMenuIconColor,));
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? baseUrl = prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');

    if (baseUrl != null && userId != null && adminId != null) {
      if (mounted) {
        setState(() {
          user_id = userId;
          this.baseUrl = baseUrl;
          this.admin_auto_id = adminId;
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
}
