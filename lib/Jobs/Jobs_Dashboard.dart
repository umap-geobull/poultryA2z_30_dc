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
import 'Add_Vacancy.dart';
import 'ApplyJobs.dart';
import 'Model/Jobs_Model.dart';
import 'Model/job_result_model.dart';

class Job_List extends StatefulWidget {
  Job_List(
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
  _Job_ListState createState() => _Job_ListState();
}

class _Job_ListState extends State<Job_List> {
  List<ProductModel> productList = [];
  List<ProductModel> productListfilter = [];
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

  List<GetJobDetails> job_list=[];

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
        // getFilterList();
      }
    }
  }

  void getJobsData() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    var url=baseUrl+'api/'+get_job_vacancy;

    var uri = Uri.parse(url);

    final body = {
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      String status=resp['status'];
      if(status=='1'){
        JobsModel Jobsmodel=JobsModel.fromJson(json.decode(response.body));
        job_list=Jobsmodel.data;

        print(job_list.toString());
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
      Fluttertoast.showToast(msg: "Server error in getting main categories", backgroundColor: Colors.grey,);
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
    return WillPopScope(
        onWillPop: () => showAlertExit(),
    child:Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            backgroundColor: appBarColor,
            title: Text("Jobs",
                style: TextStyle(
                    color: appBarIconColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                  onPressed: ()=>{
                    //showFilter()
                  },
                  icon: Icon(Icons.filter_alt_outlined,color: appBarIconColor,)),

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
            Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: Container(
                            alignment: Alignment.center,
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              width: 100,
                              decoration: BoxDecoration(
                                color: secondaryButtonColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Text("  Apply Jobs   ",textAlign: TextAlign.center,style: TextStyle(color: appBarIconColor)),
                            )
                        ),
                        onTap: (){
                          Navigator.push(context,  MaterialPageRoute(builder: (context) => ApplyJobs()));
                        },
                      )
                  ),

                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: Container(
                            alignment: Alignment.center,
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              width: 100,
                              decoration: BoxDecoration(
                                color: secondaryButtonColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Text("  Add Vacancy   ",textAlign: TextAlign.center,style: TextStyle(color: appBarIconColor),),
                            )
                        ),
                        onTap: (){
                          Navigator.push(context,  MaterialPageRoute(builder: (context) => AddVacancyScreen()));
                        },
                      )
                  )
                ],
              ),),
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
                                // GestureDetector(
                                //   child: SizedBox(
                                //     width: 120,
                                //     child: Stack(children: [
                                //       SizedBox(
                                //           width: 120,
                                //           height: 170,
                                //           child: Container(
                                //               color: Colors.grey[100],
                                //               child: ClipRRect(
                                //                 borderRadius: const BorderRadius.only(
                                //                   bottomLeft: Radius.circular(8),
                                //                   topLeft: Radius.circular(8),
                                //                 ),
                                //                 child: productList.productImages.isNotEmpty
                                //                     ? CachedNetworkImage(
                                //                   fit: BoxFit.fill,
                                //                   imageUrl: baseUrl+product_base_url + product.productImages[0].productImage,
                                //                   placeholder: (context, url) => Container(
                                //                       decoration: BoxDecoration(
                                //                         color: Colors.grey[400],
                                //                       )),
                                //                   errorWidget: (context, url, error) =>
                                //                   const Icon(Icons.error),
                                //                 ) :
                                //                 Container(
                                //                     child: const Icon(Icons.error),
                                //                     decoration: BoxDecoration(
                                //                       color: Colors.grey[400],
                                //                     )),
                                //               )
                                //           )
                                //       ),
                                //       product.offerData.isNotEmpty && product.offerData[0].offer.isNotEmpty && product.offerData[0].offer!='0'?
                                //       Container(
                                //         height: 15,
                                //         width: 45,
                                //         alignment: Alignment.center,
                                //         decoration: const BoxDecoration(
                                //           borderRadius: BorderRadius.only(
                                //             topLeft: Radius.circular(8),
                                //           ),
                                //           color: Colors.green,
                                //         ),
                                //         child: Text(
                                //           product.offerData[0].offer + "% off",
                                //           style: const TextStyle(
                                //               color: Colors.white, fontSize: 11),
                                //         ),
                                //       ):
                                //       product.offerPercentage.isNotEmpty && product.offerPercentage!='0'?
                                //       Container(
                                //         height: 15,
                                //         width: 45,
                                //         alignment: Alignment.center,
                                //         decoration: const BoxDecoration(
                                //           borderRadius: BorderRadius.only(
                                //             topLeft: Radius.circular(8),
                                //           ),
                                //           color: Colors.green,
                                //         ),
                                //         child: Text(
                                //           product.offerPercentage + "% off",
                                //           style: const TextStyle(
                                //               color: Colors.white, fontSize: 11),
                                //         ),
                                //       ):
                                //       Container(),
                                //       Align(
                                //           alignment: Alignment.bottomRight,
                                //           child:product.totalNoOfReviews!=0?Container(
                                //             width: 65,
                                //             height: 30,
                                //             alignment: Alignment.bottomRight,
                                //             child: totalRatingUi(product.avgRating,product.totalNoOfReviews),
                                //           ):Container())
                                //     ]),
                                //   ),
                                //   onTap: ()=>{
                                //     showProductDetails(product.productAutoId)
                                //   },
                                // ),
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
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                    job_list[index].jobTitle,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.w600, fontSize: 18,color: Colors.blue),
                                                  ),
                                                  user_type=='Admin'?IconButton(onPressed: ()=>{showAlert(job_list[index].id)},
                                                      icon: Icon(Icons.delete, color: appBarIconColor)):Container()
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
                                                          Text(
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
                                                              //showAlert(product.productAutoId);
                                                            },
                                                            child: const Center(
                                                              child: Text(
                                                                'Apply',
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
        ),
      bottomSheet: CustomBottomNavBar(MenuState.jobs,
        bottomBarColor,bottomMenuIconColor,),
    )
    );
  }

  Future<void> Delete_Job(String job_id) async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "job_auto_id": job_id,
      "admin_auto_id":admin_auto_id,
      "app_type_id":app_type_id,
    };
    var url = baseUrl+'api/' + delete_job_vacancy;
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
          msg: "Job deleted successfully",
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

  Future<bool> showAlert(String jobid) async {
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
                      'Do you want delete this Job post',
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
                                Delete_Job(jobid);
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

  Future<bool> showAlertExit() async {
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
                      'Do you want to exit App',
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
                                SystemNavigator.pop();
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
