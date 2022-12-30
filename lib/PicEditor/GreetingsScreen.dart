
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poultry_a2z/PicEditor/BackgroundRemover.dart';
import 'package:poultry_a2z/PicEditor/ImageSubscription.dart';
import 'package:poultry_a2z/PicEditor/utils/styling.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:http/http.dart' as http;
// import 'package:language_builder/language_builder.dart';
import '../Admin_add_Product/Components/GalleryImages.dart';
import '../Admin_add_Product/constants.dart';
import '../ImageSubscription/ImageSubscriptionPlan.dart';
import '../Utils/coustom_bottom_nav_bar.dart';
import '../Utils/enums.dart';
// import '../profile/languages.dart';
import 'EditGreetingsScreen.dart';
import 'GeneralGreetingsModel.dart';
import 'GreetingCategoriesScreen.dart';
import 'NewArrivalModel.dart';
import 'SelectImageScreen.dart';
import 'api/all_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GreetingsScreen extends StatefulWidget{

  @override
  _GreetingsScreenState createState() => _GreetingsScreenState();

}

class _GreetingsScreenState extends State<GreetingsScreen> {
  bool isApiCallProcessing=false;
  List<AllNewArrivalGreetings> newArrivalList = [];
  List<AllGeneralGreetings> generalGreetingList = [];
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;
  Color bototmBarColor=Colors.white, bottomMenuIconColor=Color(0xFFFF7643);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getappUi();
    getGeneralGreetings();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => showAlertExit(),
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: appBarColor,
              title: Text("Editor",
                  style: TextStyle(
                      color: appBarIconColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              automaticallyImplyLeading: false,
              // leading: IconButton(
              //   onPressed: () => {Navigator.of(context).pop()},
              //   icon: const Icon(Icons.arrow_back, color: Colors.white),
              // ),
              actions: [
                IconButton(
                    color: appBarIconColor,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GalleryImages()));
                    },
                    icon: const Icon(Icons.image)),
                IconButton(
                    color: appBarIconColor,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ImageSubscriptionPlan()));
                    },
                    icon: const Icon(Icons.fact_check_rounded)),
              ]),
          body:Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 9,
                      child: ShowMain(),
                    )
                  ],
                ),
              ),

              isApiCallProcessing==true?
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: GFLoader(
                  // loaderColorOne: secondaryColor,
                  // loaderColorTwo:secondaryColor ,
                  // loaderColorThree: secondaryColor,
                    type:GFLoaderType.circle
                ),
              ):
              Container()
            ],
          ),
          // bottomSheet: CustomBottomNavBar(MenuState.picture,
          //   bototmBarColor,bottomMenuIconColor,),
        ));
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
                                primary: Colors.green[200],
                                onPrimary: Colors.green,
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
                                primary: Colors.blue[200],
                                onPrimary: Colors.blue,
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

  // Widget showHeader() {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     height: MediaQuery.of(context).size.height,
  //     decoration: BoxDecoration(
  //         color: primaryColor
  //     ),
  //     child: Container(
  //       padding: EdgeInsets.only(top: 40, left: 10, right: 10),
  //       child: Row(
  //         children: <Widget>[
  //           Expanded(
  //             flex: 1,
  //             child: Text('  Greetings', style: AppTheme.appbar_title_home,),
  //           ),
  //
  //           Expanded(
  //             flex: 1,
  //             child: Container(
  //                 alignment: Alignment.centerRight,
  //                 child: Container(
  //                     height: 40,
  //                     padding: EdgeInsets.all(10),
  //                     child: Icon(Icons.search, color: primaryColor,)
  //                 )
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget ShowMain() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // showNewArrivals(),
            Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: Container(
                        height: 35,
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        child: Text("Customize Images",
                          style: TextStyle(color:Colors.black,fontSize: 16),)),
                  ),

                  Expanded(
                      flex: 3,
                      child: GestureDetector(
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              width: 100,
                              decoration: BoxDecoration(
                                color: kPrimaryLightColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: Text("   Create   ",textAlign: TextAlign.center,),
                            )
                        ),
                        onTap: (){
                          Navigator.push(context,  MaterialPageRoute(builder: (context) => RemoveBackground()));
                        },
                      )
                  )
                ],
              ),),
            showOffer(),
            showBanner(),

          ],
        ),
      ),);
  }

  Widget showNewArrivals() {
    if (newArrivalList != null && newArrivalList.isNotEmpty) {
      return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("New Arrivals", style: AppTheme.home_label_text_style,),
            SizedBox(height: 10,),
            Container(
                height: 90,
                child: new Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: newArrivalList.length,
                      itemBuilder: (context, position) {
                        return Container(
                          width: 90,
                          margin: EdgeInsets.all(3),
                          child: GestureDetector(
                            child: Container(
                                child:
                                ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  child: CachedNetworkImage(
                                    //placeholder: (context, url) => Center(child:Container(height:30,width:30,child: CircularProgressIndicator(),)),
                                    placeholder: (context, url) =>
                                        Container(decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                        )),
                                    imageUrl:GREETING_IMAGES_BASE_URL + newArrivalList[position].greetingImg,
                                    fit: BoxFit.fill,),
                                )
                            ),
                            onTap: () => {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      EditGreetingsScreen(double.parse(newArrivalList[position].xCordinate),
                                          double.parse(newArrivalList[position].yCordinate),
                                          GREETING_IMAGES_BASE_URL + newArrivalList[position].greetingImg))
                              )
                            },
                          ),
                        );
                      },
                    )
                )
            )

          ],
        ),

      );
    }
    else{
      return Container();
    }
  }

  viewMoreCategories() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> GreetingCategoriesScreen()));
  }

  Widget showOffer() {
    if(generalGreetingList!=null && generalGreetingList.isNotEmpty){
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 350,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Container(
                      height: 35,
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.topLeft,
                      child: Text("Offer Images",
                        style: TextStyle(color:Colors.black,fontSize: 16),)),
                ),

                // Expanded(
                //     flex: 3,
                //     child: GestureDetector(
                //       child: Container(
                //           alignment: Alignment.centerRight,
                //           child: Container(
                //             alignment: Alignment.center,
                //             height: 35,
                //             width: 100,
                //             decoration: BoxDecoration(
                //               color: kPrimaryLightColor,
                //               shape: BoxShape.rectangle,
                //               borderRadius: BorderRadius.all(Radius.circular(20.0)),
                //             ),
                //             child: Text("   View All   ",textAlign: TextAlign.center,),
                //           )
                //       ),
                //       onTap: (){
                //         Navigator.push(context,  MaterialPageRoute(builder: (context) => RemoveBackground()));
                //       },
                //     )
                // )


              ],
            )   ,
            Container(
                child: Expanded(
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:generalGreetingList.length>6?
                      6:
                      generalGreetingList.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: (2 / 2.6),
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5),
                      itemBuilder: (context,position){
                        return Container(
                          child: GestureDetector(
                            child:Container(
                              child:Column(
                                children: <Widget>[
                                  Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                        child: CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          errorWidget: (context, url, error ) => Icon(Icons.error),
                                          //placeholder: (context, url) => Center(child:Container(height:30,width:30,child: CircularProgressIndicator(),)),
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                color: Colors.grey[400],
                                              )),
                                          imageUrl:GREETING_CATEGORY_BASE_URL + generalGreetingList[position].grtImg,
                                          fit: BoxFit.fill,),
                                      )
                                  ),
                                  Text(generalGreetingList[position].name,style: AppTheme.fest_date_text_style,),
                                ],
                              ),
                            ),
                            onTap: ()=> {
                              Navigator.push(context,  MaterialPageRoute(builder: (context) => SelectImageScreen('Greetings',generalGreetingList[position].id, generalGreetingList[position].name)))
                            },
                          ),
                        );
                      },
                    )
                )
            )
          ],
        ),
      );
    }
    else{
      return Container();
    }
  }

  Widget showBanner() {
    if(generalGreetingList!=null && generalGreetingList.isNotEmpty){
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 350,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Container(
                      height: 35,
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.topLeft,
                      child: Text("Banner Images",
                        style: TextStyle(color:Colors.black,fontSize: 16),)),
                ),
                // Expanded(
                //     flex: 3,
                //     child: GestureDetector(
                //       child: Container(
                //           alignment: Alignment.centerRight,
                //           child: Container(
                //             alignment: Alignment.center,
                //             height: 35,
                //             width: 100,
                //             decoration: BoxDecoration(
                //               color: kPrimaryLightColor,
                //               shape: BoxShape.rectangle,
                //               borderRadius: BorderRadius.all(Radius.circular(20.0)),
                //             ),
                //             child: Text("   View All   ",textAlign: TextAlign.center,),
                //           )
                //       ),
                //       onTap: (){
                //         Navigator.push(context,  MaterialPageRoute(builder: (context) => RemoveBackground()));
                //       },
                //     )
                // )
              ],
            )   ,
            Container(
                child: Expanded(
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:generalGreetingList.length>6?
                      6:
                      generalGreetingList.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: (2 / 2.6),
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5),
                      itemBuilder: (context,position){
                        return Container(
                          child: GestureDetector(
                            child:Container(
                              child:Column(
                                children: <Widget>[
                                  Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                        child: CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          errorWidget: (context, url, error ) => Icon(Icons.error),
                                          //placeholder: (context, url) => Center(child:Container(height:30,width:30,child: CircularProgressIndicator(),)),
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                color: Colors.grey[400],
                                              )),
                                          imageUrl:GREETING_CATEGORY_BASE_URL + generalGreetingList[position].grtImg,
                                          fit: BoxFit.fill,),
                                      )
                                  ),
                                  Text(generalGreetingList[position].name,style: AppTheme.fest_date_text_style,),
                                ],
                              ),
                            ),
                            onTap: ()=> {
                              Navigator.push(context,  MaterialPageRoute(builder: (context) => SelectImageScreen('Greetings',generalGreetingList[position].id, generalGreetingList[position].name)))
                            },
                          ),
                        );
                      },
                    )
                )
            )
          ],
        ),
      );
    }
    else{
      return Container();
    }
  }

  // //new arrivals
  // Future getNewArrivals() async{
  //   if(this.mounted){
  //     setState(() {
  //       isApiCallProcessing=true;
  //     });
  //   }
  //
  //   var url=BASE_URL+GET_NEW_ARRIVAL_GREETINGS;
  //
  //   var uri = Uri.parse(url);
  //
  //   final response = await http.get(uri);
  //
  //   if (response.statusCode == 200) {
  //     isApiCallProcessing=false;
  //
  //     final resp=jsonDecode(response.body);
  //     // String message=resp['msg'];
  //     int status=resp['status'];
  //     if(status==1){
  //       NewArrivalGreetingModel newArrivalGreetingModel=NewArrivalGreetingModel.fromJson(json.decode(response.body));
  //       newArrivalList=newArrivalGreetingModel.allNewArrivalGreetings;
  //     }
  //
  //     if(this.mounted){
  //       setState(() {
  //       });
  //     }
  //   }
  // }

  void getappUi() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? appBarColor =prefs.getString('appbarColor');
    String? appbarIcon =prefs.getString('appbarIconColor');
    String? primaryButtonColor =prefs.getString('primaryButtonColor');
    String? secondaryButtonColor =prefs.getString('secondaryButtonColor');
    String? bottomBarColor =prefs.getString('bottomBarColor');
    String? bottombarIcon =prefs.getString('bottomBarIconColor');
    if(bottomBarColor!=null){
      this.bototmBarColor=Color(int.parse(bottomBarColor));
      setState(() {});
    }

    if(bottombarIcon!=null){
      this.bottomMenuIconColor=Color(int.parse(bottombarIcon));
      setState(() {});
    }

    if(appBarColor!=null){
      this.appBarColor=Color(int.parse(appBarColor));
    }

    if(appbarIcon!=null){
      this.appBarIconColor=Color(int.parse(appbarIcon));
    }

    if(primaryButtonColor!=null){
      this.primaryButtonColor=Color(int.parse(primaryButtonColor));
      print(this.primaryButtonColor.value.toString());
    }

    if(secondaryButtonColor!=null){
      this.secondaryButtonColor=Color(int.parse(secondaryButtonColor));
      print(this.secondaryButtonColor.value.toString());
    }

    if(this.mounted){
      setState(() {});
    }
  }

  //general greetings
  Future getGeneralGreetings() async{

    if(this.mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    var url=BASE_URL+GET_GREETINGS;

    var uri = Uri.parse(url);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      // String message=resp['msg'];
      int status=resp['status'];
      if(status==1){
        GenerGreetingsModel generGreetingsModel=GenerGreetingsModel.fromJson(json.decode(response.body));
        generalGreetingList=generGreetingsModel.allGeneralGreetings;
      }

      if(this.mounted){
        setState(() {
        });
      }
    }
  }


}