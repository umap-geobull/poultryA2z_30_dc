import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Product_Details/model/Product_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/coustom_bottom_nav_bar.dart';
import '../Utils/enums.dart';
import 'Join_as_consultant.dart';
import 'Model/consultant_result_model.dart';

class Consultant_Dashboard extends StatefulWidget {
  Consultant_Dashboard(
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
  _Consultant_DashboardState createState() => _Consultant_DashboardState();
}

class _Consultant_DashboardState extends State<Consultant_Dashboard> {
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
            title: Text("Consultant",
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

              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Join_As_Consultant()));
                },
                icon: Icon(Icons.add_circle_outline, color:appBarIconColor),
              ),
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
            SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height/1.2,
                  padding: const EdgeInsets.only(top: 10),
                  margin: EdgeInsets.only(left: 15,right: 15),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: consultantList.length,
                      itemBuilder: (context, index) =>
                          Container(
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                        flex: 5,
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          height: 220,
                                          child: Image.asset(consultantList[index].logo, fit: BoxFit.fill,),
                                        )),
                                    Expanded(
                                      flex: 1,
                                        child:  Padding(
                                          padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                          child: Text(consultantList[index].consultant_name,
                                            style: TextStyle(color: Colors.blueGrey,fontSize: 20), ),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        child:Padding(
                                          padding: EdgeInsets.only(left: 10,right: 10,bottom: 2,top: 5),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              // Icon(Icons.location_on, color: kMainColor,size: 20,),
                                              // SizedBox(width: 5,),
                                              Flexible(child: Text(consultantList[index].experience+' of experience'))
                                            ],
                                          ),
                                        )
                                    )),
                                    Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        child:Padding(
                                          padding: EdgeInsets.only(left: 10,right: 10,bottom: 2,top:5),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              // Icon(Icons.location_on, color: kMainColor,size: 20,),
                                              // SizedBox(width: 5,),
                                              Flexible(child: Text(consultantList[index].timing))
                                            ],
                                          ),
                                        )
                                    )),
                                    // Expanded(
                                    //     flex: 1,
                                    //     child:
                                    //     SizedBox(
                                    //     width: MediaQuery.of(context).size.width,
                                    //     height: 50,
                                    //     child:
                                    //     Padding(
                                    //       padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                    //       child: Row(
                                    //         //crossAxisAlignment: CrossAxisAlignment.start,
                                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //         crossAxisAlignment: CrossAxisAlignment.center,
                                    //         children: <Widget>[
                                    //           // Icon(Icons.location_on, color: kMainColor,size: 20,),
                                    //           // SizedBox(width: 5,),
                                    //           Flexible(child: Text(consultantList[index].fees)),
                                    //           contactUi()
                                    //         ],
                                    //       ),
                                    //     )
                                    // )
                                    // ),
                                           Padding(
                                             padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                             child: Row(
                                              //crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                // Icon(Icons.location_on, color: kMainColor,size: 20,),
                                                // SizedBox(width: 5,),
                                                Flexible(child: Text(consultantList[index].fees)),
                                                 Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    // Text(
                                                    //   '4',
                                                    //   style: TextStyle(
                                                    //     color: Colors.yellowAccent,
                                                    //     fontSize: 12,
                                                    //   ),
                                                    // ),
                                                    // Icon(
                                                    //   Icons.star,
                                                    //   color: Colors.orangeAccent,
                                                    //   size: 10,
                                                    // ),
                                                    // Text(
                                                    //   '| ' + total_reviews.toString()+"  total reviews",
                                                    //   style: TextStyle(
                                                    //     color: kWhiteColor,
                                                    //     fontSize: 12,
                                                    //   ),
                                                    // ),
                                                    Container(
                                                      width: 100,
                                                      height: 35,
                                                      // color: primaryButtonColor,
                                                      child: ElevatedButton(
                                                        onPressed: () async{

                                                            const url = "tel:8390679867";
                                                            if (await canLaunch(url)) {
                                                              await launch(url);
                                                            } else {
                                                              throw 'Could not launch $url';
                                                            }

                                                        },
                                                        child: const Text('Call'),
                                                        style: ElevatedButton.styleFrom(
                                                          minimumSize: const Size(200,50),
                                                          backgroundColor: primaryButtonColor,
                                                          shape: const StadiumBorder(),
                                                          shadowColor: Colors.grey,
                                                          elevation: 5,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 15,),
                                                    SizedBox(width: 100,
                                                      height: 35,
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          const uri = 'sms:+ 9898765444?body=hello%20there';
                                                          if (await canLaunch(uri)) {
                                                          await launch(uri);
                                                          } else {
                                                          // iOS
                                                          const uri = 'sms:0039-222-060-888?body=hello%20there';
                                                          if (await canLaunch(uri)) {
                                                          await launch(uri);
                                                          } else {
                                                          throw 'Could not launch $uri';
                                                          }
                                                          }
                                                        },
                                                        child: const Text('Message'),
                                                        style: ElevatedButton.styleFrom(
                                                          minimumSize: const Size(200,50),
                                                          backgroundColor: secondaryButtonColor,
                                                          shape: const StadiumBorder(),
                                                          shadowColor: Colors.grey,
                                                          elevation: 5,
                                                        ),
                                                      ),)
                                                  ],
                                                )
                                              ],
                                          ),
                                           ),
                                    Divider(
                                      height: 10,
                                      thickness: 5,
                                      color: Colors.grey[500],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    totalRatingUi(),
                                    InkWell(
                                      onTap: (){
                                        Share.share("${consultantList[index].consultant_name} \n\n ${consultantList[index].experience}\n\n ${consultantList[index].timing}\n\n ${consultantList[index].fees}");
                                      },
                                       child:  Container(
                                         height: 30,
                                         width: 40,
                                         alignment: Alignment.center,
                                         // decoration: BoxDecoration(
                                         //   color: Colors.black.withOpacity(.55),
                                         //   borderRadius: BorderRadius.circular(0),
                                         // ),
                                         child:  Icon(
                                             Icons.share,
                                             color: Colors.black,
                                         ),

                                       )),
                                  ],),
                              ],),
                            ),
                          ),
                  )
              ),
            ),]),
        bottomSheet: CustomBottomNavBar(MenuState.consultant,
        bottomBarColor,bottomMenuIconColor,),
    )
    );
  }

  totalRatingUi() {

      return Container(
        width: MediaQuery.of(context).size.width/5,
        height: 25,
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.only(left: 0, right: 10, bottom: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.55),
            borderRadius: BorderRadius.circular(0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '4',
                style: TextStyle(
                  color: Colors.yellowAccent,
                  fontSize: 12,
                ),
              ),
              Icon(
                Icons.star,
                color: Colors.orangeAccent,
                size: 10,
              ),
              // Text(
              //   '| ' + total_reviews.toString()+"  total reviews",
              //   style: TextStyle(
              //     color: kWhiteColor,
              //     fontSize: 12,
              //   ),
              // ),
            ],
          ),
        ),
      );
  }

  shareUi() {
    return  Container(
        height: 20,
        alignment: Alignment.topRight,
        width: 40,
        child: IconButton(
          icon:  const Icon(
            Icons.share,
            color: Colors.grey,
          ),

          onPressed: () =>
          {

          },
        ),

    );
  }

  contactUi() {

    return Container(
      width: MediaQuery.of(context).size.width/1.5,

      alignment: Alignment.bottomRight,
      margin: const EdgeInsets.only(left: 20, right: 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.bottomRight,
        //padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          //color: Colors.black.withOpacity(.55),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // Text(
            //   '4',
            //   style: TextStyle(
            //     color: Colors.yellowAccent,
            //     fontSize: 12,
            //   ),
            // ),
            // Icon(
            //   Icons.star,
            //   color: Colors.orangeAccent,
            //   size: 10,
            // ),
            // Text(
            //   '| ' + total_reviews.toString()+"  total reviews",
            //   style: TextStyle(
            //     color: kWhiteColor,
            //     fontSize: 12,
            //   ),
            // ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {

                },
                child: const Text('Call'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200,50),
                  backgroundColor: primaryButtonColor,
                  shape: const StadiumBorder(),
                  shadowColor: Colors.grey,
                  elevation: 5,
                ),
              ),),
            SizedBox(width: 15,),
            SizedBox(width: 100,
              child: ElevatedButton(
                onPressed: () {

                },
                child: const Text('Message'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200,50),
                  backgroundColor: secondaryButtonColor,
                  shape: const StadiumBorder(),
                  shadowColor: Colors.grey,
                  elevation: 5,
                ),
              ),)
          ],
        ),
      ),
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
