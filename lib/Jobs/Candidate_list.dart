import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Jobs/Model/MyJobs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import '../Utils/App_Apis.dart';
import 'Model/JobApplicantsModel.dart';

class Candidate_List extends StatefulWidget {
  String job_id;
  Candidate_List(this.job_id);

  @override
  State<Candidate_List> createState() => _Candidate_ListState();
}

class _Candidate_ListState extends State<Candidate_List> {
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;
  List<GetJobApplicants> candidate_list=[];
  String baseUrl='',user_id='', admin_auto_id='',app_type_id='',user_type='';
  bool isApiCallProcessing=false;

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
    if(this.mounted){
      setState(() {});
    }
  }

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');
    String? userType =prefs.getString('user_type');

    if(baseUrl!=null && userId!=null && adminId!=null && apptypeid!=null && userType!=null){
      if(this.mounted){
        this.admin_auto_id=adminId;
        this.baseUrl=baseUrl;
        this.user_id=userId;
        this.app_type_id=apptypeid;
        this.user_type=userType;
        getCandidateData();
      }
    }
  }

  void getCandidateData() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    var url=baseUrl+'api/'+get_jobs_details;

    var uri = Uri.parse(url);

    final body = {
      "job_auto_id":widget.job_id,
    };

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      //print(body.toString());
      //print(url);
      final resp=jsonDecode(response.body);
      String status=resp['status'];
      if(status=='1'){
        JobApplicants Jobsmodel=JobApplicants.fromJson(json.decode(response.body));
        candidate_list=Jobsmodel.data;
        print(response.body.toString());

        if(mounted){
          setState(() {});
        }
      }else
      {
        isApiCallProcessing=false;
        if(mounted){
          setState(() {});
        }
      }
    }
    else if(response.statusCode==500){
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
      Fluttertoast.showToast(msg: "Server error ", backgroundColor: Colors.grey,);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getappUi();
    getBaseUrl();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: appBarColor,
            title: Text("Candidates List",
                style: TextStyle(
                    color: appBarIconColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            leading: IconButton(
                onPressed: ()=>{
                  Navigator.pop(context)
                },
                icon: Icon(Icons.arrow_back,color: appBarIconColor,)),
            actions: [
              // IconButton(
              //     onPressed: ()=>{
              //       //showFilter()
              //     },
              //     icon: Icon(Icons.filter_alt_outlined,color: appBarIconColor,)),

              // IconButton(
              //   onPressed: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => Job_List_Ui()));
              //   },
              //   icon: Icon(Icons.edit, color:appBarIconColor),
              // ),
              //
              // widget.type != "brand" ?
              // IconButton(
              //   onPressed: () {
              //     fetch_images();
              //   },
              //   icon: Icon(Icons.add_circle_outline, color: appBarIconColor),
              // ):
              // Container(),
            ]
        ),
        body:
        Column(
          children: <Widget>[

            candidate_list.isNotEmpty?SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height/1.3,
                  padding: const EdgeInsets.only(top: 0),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: candidate_list.length,
                      itemBuilder: (context, index) =>
                          Container(
                            height: 110,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              //borderRadius: BorderRadius.circular(8),
                              border: Border(
                                bottom: BorderSide(color: Colors.grey,width: 1),
                              ),
                              // boxShadow: [
                              //   BoxShadow(
                              //       color: Colors.grey,
                              //       offset: Offset(10,20),
                              //     blurRadius: 10
                              //   )
                              // ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                        height: 110,
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: ()=>{
                                                //showProductDetails(product.productAutoId)
                                              },
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        candidate_list[index].candidateName,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.w600, fontSize: 18,color: Colors.blue),
                                                      ),
                                                    ],),

                                                  Container(
                                                    margin: const EdgeInsets.only(top: 5),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Experience:  "+candidate_list[index].experience,
                                                          style:
                                                          const TextStyle(color: Colors.black, fontSize: 14),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(top: 5),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Expected Salary:  " + candidate_list[index].expectedSalary,
                                                          style:
                                                          const TextStyle(color: Colors.black, fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(top: 5),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Mobile No:  " + candidate_list[index].mobileNo,
                                                          style:
                                                          const TextStyle(color: Colors.black, fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // Container(
                                                  //     height: 40,
                                                  //     margin: const EdgeInsets.only(top: 5),
                                                  //     child:
                                                  //     Row(
                                                  //       mainAxisAlignment: MainAxisAlignment.start,
                                                  //       crossAxisAlignment: CrossAxisAlignment.start,
                                                  //       children: [
                                                  //         const Text(
                                                  //           "Mobile No:  ",
                                                  //           style: TextStyle(color: Colors.black, fontSize: 14),
                                                  //         ),
                                                  //         SizedBox(height: 3,),
                                                  //         Text(candidate_list[index].mobileNo,
                                                  //           style: const TextStyle(
                                                  //               color: Colors.black87,
                                                  //               fontSize: 14,
                                                  //               overflow: TextOverflow.clip
                                                  //           ),
                                                  //         )
                                                  //       ],
                                                  //     )
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                    )
                                )
                              ],
                            ),
                          )
                  )
              ),
            ):
            Container(),

            isApiCallProcessing==false && candidate_list.isEmpty?
            Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/1.3,
                child: const Text('No Jobs available')
            ):
            Container(),

            isApiCallProcessing==true?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.3,
              child: const GFLoader(
                  type:GFLoaderType.circle
              ),
            ):
            Container()
          ],
        )
    );
  }
}
