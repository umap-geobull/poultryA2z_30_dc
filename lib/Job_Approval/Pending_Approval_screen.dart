import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../../Product_Details/model/Product_Model.dart';
import '../../Utils/App_Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import '../Utils/coustom_bottom_nav_bar.dart';
import '../Utils/enums.dart';
import 'Model/JobApprovalModel.dart';

class Pending_Approval_List extends StatefulWidget {
  Pending_Approval_List(
      {Key? key,
        // required this.type,
        // required this.main_cat_id,
        // required this.sub_cat_id,
        // required this.brand_id,
        // required this.home_componet_id,
        // required this.offer_id
      })
      : super(key: key);
  // String type;
  // String main_cat_id;
  // String sub_cat_id;
  // String brand_id;
  // String home_componet_id;
  // String offer_id;

  @override
  _Pending_Approval_ListState createState() => _Pending_Approval_ListState();
}

class _Pending_Approval_ListState extends State<Pending_Approval_List> {
  late Route routes;
  bool isApiCallProcessing=false;
  bool isDeleteProcessing=false;
  String baseUrl='',user_id='', admin_auto_id='',app_type_id='',user_type='';
  List<String> categories = [];
  bool isfilter=false;
  late File icon_img;
  late XFile pickedImageFile;
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;

  Color bottomBarColor=Colors.white, bottomMenuIconColor=Color(0xFFFF7643);

  List<JobList> job_list=[];

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
        getJobsData();
      }
    }
  }

  void getJobsData() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    var url=baseUrl+'api/'+get_job_approval_list;

    var uri = Uri.parse(url);

    final body = {
      "admin_auto_id":admin_auto_id,
      "user_auto_id":user_id,
    };
    //print(body.toString());
    //print(url);
    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        JobApprovalModel Jobsmodel=JobApprovalModel.fromJson(json.decode(response.body));
        job_list=Jobsmodel.data;

        print(job_list.toString());
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
          backgroundColor: Colors.grey[200],
          body:
          Column(
            children: <Widget>[

              job_list.isNotEmpty?SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height/1.3,
                    padding: const EdgeInsets.only(top: 0),
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: job_list.length,
                        itemBuilder: (context, index) =>
                            Container(
                              height: 250,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                          height: 250,
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: ()=>{
                                                  //Navigator.push(context,  MaterialPageRoute(builder: (context) => Candidate_List(job_list[index].id)))
                                                },
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          job_list[index].jobTitle,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                              fontWeight: FontWeight.w600, fontSize: 18,color: Colors.blue),
                                                        ),
                                                        // user_type=='Admin'?IconButton(onPressed: ()=>{showAlert(job_list[index].id)},
                                                        //     icon: Icon(Icons.delete, color: appBarIconColor)):Container()
                                                      ],),

                                                    Container(
                                                      margin: const EdgeInsets.only(top: 5),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Experience: "+job_list[index].experience,
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
                                                            "Salary: " + job_list[index].salaryExpectations,
                                                            style:
                                                            const TextStyle(color: Colors.black, fontSize: 14),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                        height: 110,
                                                        margin: const EdgeInsets.only(top: 5),
                                                        child:
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            const Text(
                                                              "Description: ",
                                                              style: TextStyle(color: Colors.black, fontSize: 14),
                                                            ),
                                                            SizedBox(height: 3,),
                                                            Text(job_list[index].jobDescription,
                                                              style: const TextStyle(
                                                                  color: Colors.black54,
                                                                  fontSize: 13,
                                                                  overflow: TextOverflow.clip
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  child:Container(
                                                    height: MediaQuery.of(context).size.height,
                                                    alignment: Alignment.bottomCenter,
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          flex: 1,
                                                          child: SizedBox(
                                                            height: 35,
                                                            child:  ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor: primaryButtonColor,
                                                                  textStyle: const TextStyle(fontSize: 20)),
                                                              onPressed: () {
                                                                //Navigator.push(context,  MaterialPageRoute(builder: (context) => ApplyJobs(job_list[index].id)));
                                                                showAlert(job_list[index].id,job_list[index].userAutoId);
                                                              },
                                                              child: const Center(
                                                                child: Text(
                                                                  'Approve',
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    color: Colors.white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ) ,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          flex: 1,
                                                          child: SizedBox(
                                                            height: 35,
                                                            child:  ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor: secondaryButtonColor,
                                                                  textStyle: const TextStyle(fontSize: 20)),
                                                              onPressed: () {
                                                                //Navigator.push(context,  MaterialPageRoute(builder: (context) => ApplyJobs(job_list[index].id)));
                                                                showAlertDisapprove(job_list[index].id,job_list[index].userAutoId);
                                                              },
                                                              child: const Center(
                                                                child: Text(
                                                                  'Disapprove',
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    color: Colors.white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ) ,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                    ,
                                                  ))
                                            ],
                                          )
                                      )
                                  )
                                ],
                              ),

                            )
                    )
                ),
              ):Container(),

              isApiCallProcessing==false && job_list.isEmpty?
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
                //height: MediaQuery.of(context).size.height/2,
                child: const GFLoader(
                    type:GFLoaderType.circle
                ),
              ):
              Container()
            ],
          ),
    );
  }

  Future<void> SendApproval_Job(String job_id,String approval,String userid) async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "job_auto_id": job_id,
      "admin_auto_id":admin_auto_id,
      "user_auto_id":userid,
      "status":approval,
    };
    var url = baseUrl+'api/' + approve_job;
    print(body.toString());
    print(url);
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
          msg: "Job "+approval+" successfully",
          backgroundColor: Colors.grey,
        );
        job_list.clear();
        getJobsData();
      }
      else {
        print('empty');
      }
      // if(mounted){
      //   setState(() {});
      // }
    }else if(response.statusCode==500)
    {
      isApiCallProcessing=false;
      Fluttertoast.showToast(
        msg: "server error",
        backgroundColor: Colors.grey,
      );
    }
  }

  Future<bool> showAlert(String jobid,String userid) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: const Text(
            'Are you sure?',
            style: TextStyle(color: Colors.black87),
          ),
          content: Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Do you want to approve this job',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(
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
                                SendApproval_Job(jobid,'Approved',userid);
                              },
                              child: const Text("Yes",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[200],
                                //minimumSize: Size(70, 30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("No",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[200],
                                // minimumSize: Size(70, 30),
                                shape: const RoundedRectangleBorder(
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

  Future<bool> showAlertDisapprove(String jobid,String userid) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: const Text(
            'Are you sure?',
            style: TextStyle(color: Colors.black87),
          ),
          content: Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Do you want to disapprove this job',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(
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
                                SendApproval_Job(jobid,'Disapproved',userid);
                              },
                              child: const Text("Yes",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[200],
                                minimumSize: const Size(70, 30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                            child: ElevatedButton(
                              onPressed: () => {Navigator.pop(context)},
                              child: const Text("No",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[200],
                                minimumSize: const Size(70, 30),
                                shape: const RoundedRectangleBorder(
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

  FutureOr onGoBack(dynamic value) {
    getJobsData();
  }
}
