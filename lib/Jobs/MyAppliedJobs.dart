import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Jobs/Model/MyJobs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import '../Utils/App_Apis.dart';

class MyAppliedJobs extends StatefulWidget {
  const MyAppliedJobs({Key? key}) : super(key: key);

  @override
  State<MyAppliedJobs> createState() => _MyAppliedJobsState();
}

class _MyAppliedJobsState extends State<MyAppliedJobs> {
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;
  List<Data> job_list=[];
  String baseUrl='',user_id='', admin_auto_id='',app_type_id='',user_type='';
  bool isApiCallProcessing=false;

  void getappUi() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? appBarColor =prefs.getString('appbarColor');
    String? appbarIcon =prefs.getString('appbarIconColor');
    String? primaryButtonColor =prefs.getString('primaryButtonColor');
    String? secondaryButtonColor =prefs.getString('secondaryButtonColor');

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

    var url=baseUrl+'api/'+get_applied_jobs;

    var uri = Uri.parse(url);

    final body = {
      "user_auto_id":user_id,
    };

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      String status=resp['status'];
      if(status=='1'){
        MyJobs Jobsmodel=MyJobs.fromJson(json.decode(response.body));
        job_list=Jobsmodel.data;
        print(response.body.toString());

        if(mounted){
          setState(() {});
        }
      }else
      {

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
          title: Text("My Applied Jobs",
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
      body:Column(
        children: <Widget>[

          SingleChildScrollView(
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
                                              //showProductDetails(product.productAutoId)
                                            },
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      job_list[index].jobTitle,
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
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    const Flexible(
                                                      flex: 1,
                                                      child: SizedBox(
                                                        height: 35,
                                                        //child:
                                                        /* ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              primary: primaryButtonColor,
                                                              textStyle: const TextStyle(fontSize: 20)),
                                                          onPressed: () {
                                                            //showEditPage(product.productAutoId);
                                                          },
                                                          child: const Center(
                                                            child: Text(
                                                              'Edit',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),*/
                                                      ),
                                                    ),
                                                    // const SizedBox(
                                                    //   width: 5,
                                                    // ),
                                                    // Flexible(
                                                    //   flex: 1,
                                                    //   child: SizedBox(
                                                    //     height: 35,
                                                    //     child:  ElevatedButton(
                                                    //       style: ElevatedButton.styleFrom(
                                                    //           backgroundColor: secondaryButtonColor,
                                                    //           textStyle: const TextStyle(fontSize: 20)),
                                                    //       onPressed: () {
                                                    //         Navigator.push(context,  MaterialPageRoute(builder: (context) => ApplyJobs()));
                                                    //         //showAlert(product.productAutoId);
                                                    //       },
                                                    //       child: const Center(
                                                    //         child: Text(
                                                    //           'Apply',
                                                    //           style: TextStyle(
                                                    //             fontSize: 16,
                                                    //             color: Colors.white,
                                                    //           ),
                                                    //         ),
                                                    //       ),
                                                    //     ) ,
                                                    //   ),
                                                    // ),
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
          ),

          isApiCallProcessing==false && job_list.isEmpty?
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: const Text('No Jobs available')
          ):
          Container(),

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
      )
    );
  }
}
