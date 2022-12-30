import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../../Product_Details/model/Product_Model.dart';
import '../../Utils/App_Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';

import '../Utils/coustom_bottom_nav_bar.dart';
import '../Utils/enums.dart';
import 'Add_Vacancy.dart';
import 'ApplyJobs.dart';
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
  String baseUrl='',user_id='', admin_auto_id='',app_type_id='';
  List<String> categories = [];
  bool isfilter=false;
  //filter
  String colors='', size='', moq='',  brand='',  min_price='', max_price='', sort_by='',manufacturer='',
      material='',min_thickness='',max_thickness='',firmness='',max_height='', min_height='',min_width='',max_width='',min_depth='',max_depth='',min_discount='',max_discount='',stock='',min_trial_priod='',max_trial_period='';

  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;
  Color bottomBarColor=Colors.white, bottomMenuIconColor=Color(0xFFFF7643);

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

    if(baseUrl!=null && userId!=null && adminId!=null && apptypeid!=null){
      if(this.mounted){
        this.admin_auto_id=adminId;
        this.baseUrl=baseUrl;
        this.user_id=userId;
        this.app_type_id=apptypeid;

        // getData();
        // getFilterList();
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
            // leading: IconButton(
            //   onPressed: ()=>{
            //     Navigator.of(context).pop()
            //   },
            //   icon: Icon(Icons.arrow_back, color: appBarIconColor),
            // ),
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
                      itemCount: searchList.length,
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
                                                  Text(
                                                    searchList[index].job_name,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.w600, fontSize: 18,color: Colors.blue),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(top: 5),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Experience: "+searchList[index].experience,
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
                                                          "Salary: " + searchList[index].salary,
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
                                                          Text(searchList[index].description,
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
                                                      Flexible(
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
            )

            // isApiCallProcessing==false && productList.isEmpty?
            // Container(
            //   alignment: Alignment.center,
            //   width: MediaQuery.of(context).size.width,
            //   child: const Text('No products available')
            // ):
            // Container(),
            //
            // isApiCallProcessing==true?
            // Container(
            //   alignment: Alignment.center,
            //   width: MediaQuery.of(context).size.width,
            //   child: const GFLoader(
            //       type:GFLoaderType.circle
            //   ),
            // ):
            // Container()
          ],
        ),
      bottomSheet: CustomBottomNavBar(MenuState.jobs,
        bottomBarColor,bottomMenuIconColor,),
    )
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
    //getData();
  }
}
