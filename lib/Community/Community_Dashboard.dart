import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/add_home_component_model.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:poultry_a2z/Utils/size_config.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../../../Product_Details/model/Product_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/coustom_bottom_nav_bar.dart';
import '../../Utils/enums.dart';
import 'Add_post_screen.dart';
import 'Community_Menu.dart';
import 'Community_provider.dart';
import 'Model/consultant_result_model.dart';
import 'Write_post.dart';
import 'add_comment_modal.dart';

class Community_Dashboard extends StatefulWidget {
  Community_Dashboard({
    Key? key,
    // required this.type,
    // required this.main_cat_id,
    // required this.sub_cat_id,
    // required this.brand_id,
    // required this.home_componet_id,
    // required this.offer_id
  }) : super(key: key);

  // String type;
  // String main_cat_id;
  // String sub_cat_id;
  // String brand_id;
  // String home_componet_id;
  // String offer_id;

  @override
  _Community_DashboardState createState() => _Community_DashboardState();
}

class _Community_DashboardState extends State<Community_Dashboard> {
  List<ProductModel> productList = [];
  List<ProductModel> productListfilter = [];
  late Route routes;
  bool isApiCallProcessing = false;
  bool isDeleteProcessing = false;
  String baseUrl = '', user_id = '', admin_auto_id = '', app_type_id = '';
  List<String> categories = [];
  bool isfilter = false;

  List<Map<String, dynamic>> vendor_menu_List = [
    {"text": "About Disease"},
    {"text": "About Management"},
    {"text": "About Feed"},
    {"text": "About Farm"},
  ];
  List<ConsultantResult> communitypostList = [];
  //filter
  String colors = '',
      size = '',
      moq = '',
      brand = '',
      min_price = '',
      max_price = '',
      sort_by = '',
      manufacturer = '',
      material = '',
      min_thickness = '',
      max_thickness = '',
      firmness = '',
      max_height = '',
      min_height = '',
      min_width = '',
      max_width = '',
      min_depth = '',
      max_depth = '',
      min_discount = '',
      max_discount = '',
      stock = '',
      min_trial_priod = '',
      max_trial_period = '';

  Color appBarColor = Colors.white,
      appBarIconColor = Colors.black,
      primaryButtonColor = Colors.orange,
      secondaryButtonColor = Colors.orangeAccent;
  Color bottomBarColor = Colors.white, bottomMenuIconColor = Color(0xFFFF7643);

  void getappUi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? appBarColor = prefs.getString('appbarColor');
    String? appbarIcon = prefs.getString('appbarIconColor');
    String? primaryButtonColor = prefs.getString('primaryButtonColor');
    String? secondaryButtonColor = prefs.getString('secondaryButtonColor');
    String? bottomBarColor = prefs.getString('bottomBarColor');
    String? bottombarIcon = prefs.getString('bottomBarIconColor');

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
    if (bottomBarColor != null) {
      this.bottomBarColor = Color(int.parse(bottomBarColor));
      setState(() {});
    }

    if (bottombarIcon != null) {
      this.bottomMenuIconColor = Color(int.parse(bottombarIcon));
      setState(() {});
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  void getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid = prefs.getString('app_type_id');
    String? userType = prefs.getString('user_type');

    if (baseUrl != null &&
        userId != null &&
        adminId != null &&
        apptypeid != null) {
      if (this.mounted) {
        this.admin_auto_id = adminId;
        this.baseUrl = baseUrl;
        this.user_id = userId;
        this.app_type_id = apptypeid;

        // getData();
        // getFilterList();
      }
    }
  }

  late CommunityProvider communityProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    communityProvider = Provider.of<CommunityProvider>(context, listen: false);
    communitypostList = disease;
    getappUi();
    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => showAlertExit(),
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
              backgroundColor: appBarColor,
              title: Text("Community",
                  style: TextStyle(
                      color: appBarIconColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              // leading: IconButton(
              //   onPressed: () => {Navigator.of(context).pop()},
              //   icon: Icon(Icons.arrow_back, color: appBarIconColor),
              // ),
              actions: [

                IconButton(
                  onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => Join_As_Consultant()));
                  },
                  icon: Icon(Icons.notifications, color: appBarIconColor),
                ),
              ]),
          body: SingleChildScrollView(
              child: SizedBox(
            height: MediaQuery.of(context).size.height - 100,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddPostScreen(onGoBacklistener)));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey[100],
                          // color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                    height: 40,
                                    width: 40,
                                    child: Image.asset('assets/consultant1.jpeg'),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.grey[400],
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddPostScreen(onGoBacklistener)));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 100,
                                  height: 40,
                                  padding: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                          width:
                                              MediaQuery.of(context).size.width -
                                                  130,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const TextField(
                                            cursorColor: Colors.black,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    left: 15, right: 15),
                                                fillColor: Colors.white,
                                                hintText: "Add a post.."),
                                          )
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(
                                      //       top: 10.0, bottom: 8),
                                      //   child: SvgPicture.asset(
                                      //     send_icon,
                                      //     height: 15,
                                      //     width: 20,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // Divider(
                          //   height: 2,
                          //   thickness: 1,
                          //   color: Colors.grey[500],
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     InkWell(
                          //         onTap: () async{
                          //           PickedFile? pickedFile = await ImagePicker().getVideo(
                          //             source: ImageSource.gallery,
                          //           );
                          //           if (pickedFile != null) {
                          //             File imageFile = File(pickedFile.path);
                          //             print(imageFile.toString());
                          //           }
                          //
                          //         },
                          //         child: Container(
                          //             width: MediaQuery.of(context).size.width *
                          //                 0.40,
                          //             alignment: Alignment.center,
                          //             child: Text('Add Videos'))),
                          //
                          //     //Divider
                          //     Container(
                          //       height: 20,
                          //       width: 2,
                          //       color: Colors.grey[500],
                          //     ),
                          //
                          //     InkWell(
                          //         onTap: () async{
                          //           PickedFile? pickedFile = await ImagePicker().getImage(
                          //             source: ImageSource.gallery,
                          //             maxWidth: 1800,
                          //             maxHeight: 1800,
                          //           );
                          //           if (pickedFile != null) {
                          //             File imageFile = File(pickedFile.path);
                          //             print(imageFile.toString());
                          //           }
                          //
                          //         },
                          //         child: Container(
                          //             width: MediaQuery.of(context).size.width *
                          //                 0.40,
                          //             alignment: Alignment.center,
                          //             child: Text('Add Images'))),
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),

                  // Expanded(
                  //     flex: 1,
                  //     child: Container(
                  //         height: 80,
                  //         margin: const EdgeInsets.only(top: 5, bottom: 5),
                  //         child: Write_post())) ,

                  // Expanded(flex: 1,
                  //     child:
                  // Container(
                  //   margin: const EdgeInsets.only(top: 5, bottom: 5),
                  //   // child: Community_Menu()
                  //   child: SizedBox(
                  //     height: 40,
                  //     child: ListView.builder(
                  //         scrollDirection: Axis.horizontal,
                  //         itemCount: vendor_menu_List.length,
                  //         itemBuilder: (context, index) => CategoryCard(
                  //               text: vendor_menu_List[index]["text"],
                  //               press: () {
                  //                 if (vendor_menu_List[index]["text"] ==
                  //                     "About Disease") {
                  //                   setState(() {
                  //                     communitypostList = disease;
                  //                   });
                  //                   //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Vendor_Order_Screen()),);
                  //                 } else if (vendor_menu_List[index]["text"] ==
                  //                     "About Management") {
                  //                   setState(() {
                  //                     communitypostList = management;
                  //                   });
                  //                   //Navigator.push(context, MaterialPageRoute(builder: (context) => Approval_Screen()));
                  //                 } else if (vendor_menu_List[index]["text"] ==
                  //                     "About Feed") {
                  //                   setState(() {
                  //                     communitypostList = feed;
                  //                   });
                  //                   //Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
                  //                 } else if (vendor_menu_List[index]["text"] ==
                  //                     "About Farm") {
                  //                   setState(() {
                  //                     communitypostList = farm;
                  //                   });
                  //                   //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Vendors_List()),);
                  //                 } else if (vendor_menu_List[index]["text"] ==
                  //                     "Customer List") {
                  //                   //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Customer_List()));
                  //                 } else if (vendor_menu_List[index]["text"] ==
                  //                     "Products") {
                  //                   //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Admin_Product_List()),);
                  //                 } else if (vendor_menu_List[index]["text"] ==
                  //                     "Sales") {
                  //                   /*Navigator.of(context).push(MaterialPageRoute(builder: (context) => Venders_Sales(s_date: '',e_date: '',
                  //       s_date1: '',e_date1: '',vendor_id:user_id)),);*/
                  //                 } else if (vendor_menu_List[index]["text"] ==
                  //                     "Finance") {
                  //                   /*Navigator.of(context).push(MaterialPageRoute(builder: (context) => Admin_Finance(s_date: '',e_date: '',
                  //       s_date1: '',e_date1: '',vendor_id:user_id)),);*/
                  //                 } else if (vendor_menu_List[index]["text"] ==
                  //                     "Inventory") {
                  //                   /* Navigator.of(context).push(MaterialPageRoute(builder: (context) => Venders_Invetory(vendor_id:user_id,
                  //     admin_id: admin_id,)),);*/
                  //                 } else if (vendor_menu_List[index]["text"] ==
                  //                     "Invoice") {
                  //                   //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Vendor_Invoice_Screen()));
                  //                 } else if (vendor_menu_List[index]["text"] ==
                  //                     "Coupons") {
                  //                   //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Vendor_Coupen_code(Vendor_id: user_id,)));
                  //                 } else if (vendor_menu_List[index]["text"] ==
                  //                     "Payment Gateway") {
                  //                   //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Select_Payment_Merchant()));
                  //                 } else if (vendor_menu_List[index]["text"] ==
                  //                     "Delivery Partner") {
                  //                   //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Select_Delivery_Merchant()));
                  //                 }
                  //               },
                  //             )),
                  //   ),
                  // ),
                  // ),
                  // Expanded(
                  //     flex: 10,
                  //     child:
                  Container(
                      height: MediaQuery.of(context).size.height / 1.4,
                      padding: const EdgeInsets.only(top: 5),
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: communitypostList.length,
                        itemBuilder: (context, index) => Container(
                          height: 300,
                          margin: EdgeInsets.only(bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          totalRatingUi(),
                                          // shareUi(),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 0,
                                                bottom: 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      child: Image.asset(
                                                          'assets/consultant1.jpeg'),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        color: Colors.grey[400],
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  communitypostList[index].name,
                                                  style: TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontSize: 20),
                                                ),
                                              ],
                                            ))),
                                    Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 5,
                                                  bottom: 2),
                                              child: Row(
                                                //crossAxisAlignment: CrossAxisAlignment.start,
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment
                                                //         .spaceBetween,
                                                children: <Widget>[
                                                  // Icon(Icons.location_on, color: kMainColor,size: 20,),
                                                  // SizedBox(width: 5,),
                                                  Flexible(
                                                      child: Text(
                                                          communitypostList[
                                                                  index]
                                                              .description)),
                                                ],
                                              ),
                                            ))),
                                    Expanded(
                                        flex: 4,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 220,
                                          child: Image.asset(
                                            communitypostList[index].logo,
                                            fit: BoxFit.fill,
                                          ),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 2,
                                                  top: 5),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  // Icon(Icons.location_on, color: kMainColor,size: 20,),
                                                  // SizedBox(width: 5,),
                                                  Flexible(
                                                      child: Text(
                                                          communitypostList[
                                                                      index]
                                                                  .likes +
                                                              ' likes')),
                                                  Flexible(
                                                      child: Text(
                                                          communitypostList[
                                                                      index]
                                                                  .comments +
                                                              ' ' +
                                                              'comments'))
                                                ],
                                              ),
                                            ))),
                                    // Expanded(
                                    //     flex: 1,
                                    //     child: SizedBox(
                                    //         width:
                                    //             MediaQuery.of(context).size.width,
                                    //         child: Padding(
                                    //           padding: EdgeInsets.only(
                                    //               left: 10,
                                    //               right: 10,
                                    //               bottom: 2,
                                    //               top: 5),
                                    //           child: Row(
                                    //             crossAxisAlignment:
                                    //                 CrossAxisAlignment.start,
                                    //             children: <Widget>[
                                    //               // Icon(Icons.location_on, color: kMainColor,size: 20,),
                                    //               // SizedBox(width: 5,),
                                    //             ],
                                    //           ),
                                    //         ))),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          bottom: 10,
                                          top: 5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              communityProvider.isLiked
                                                  ? InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          communityProvider
                                                              .unLike();
                                                        });
                                                      },
                                                      child: SvgPicture.asset(
                                                        like_fill_icon,
                                                        height: 20,
                                                        width: 20,
                                                        color:
                                                            Colors.blueAccent,
                                                      ),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          communityProvider
                                                              .like();
                                                        });
                                                      },
                                                      child: SvgPicture.asset(
                                                        like_icon,
                                                        height: 20,
                                                        width: 20,
                                                      ),
                                                    ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AddCommentModal();
                                                      },
                                                    );
                                                  },
                                                  child: SvgPicture.asset(
                                                    comment_icon,
                                                    height: 20,
                                                    width: 20,
                                                  )),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    Share.share(
                                                        "${communitypostList[index].name} \n\n ${communitypostList[index].description}");
                                                  },
                                                  child: SvgPicture.asset(
                                                    share_icon,
                                                    height: 20,
                                                    width: 20,
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                view_icon,
                                                height: 20,
                                                width: 20,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text('300 Views')
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
                              ],
                            ),
                          ),
                        ),
                      ))
                  // ),
                ]),
          )),
          bottomSheet: CustomBottomNavBar(
            MenuState.community,
            bottomBarColor,
            bottomMenuIconColor,
          ),
        ));
  }

  totalRatingUi() {
    return Container(
      width: MediaQuery.of(context).size.width / 5,
      height: 25,
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 0, right: 10, bottom: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          //color: Colors.black.withOpacity(.55),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
          ],
        ),
      ),
    );
  }
  onGoBacklistener(){
    Navigator.pop(context);
    //getMainCategories();
  }
  shareUi() {
    return Container(
      height: 20,
      alignment: Alignment.topRight,
      width: 40,
      child: IconButton(
        icon: const Icon(
          Icons.share,
          color: Colors.grey,
        ),
        onPressed: () => {},
      ),
    );
  }

  contactUi() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: 50,
      alignment: Alignment.bottomRight,
      margin: const EdgeInsets.only(left: 20, right: 0, bottom: 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.bottomRight,
        //padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          //color: Colors.black.withOpacity(.55),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
              width: 80,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Call'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  backgroundColor: primaryButtonColor,
                  shape: const StadiumBorder(),
                  shadowColor: Colors.grey,
                  elevation: 5,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            SizedBox(
              width: 80,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Message'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  backgroundColor: secondaryButtonColor,
                  shape: const StadiumBorder(),
                  shadowColor: Colors.grey,
                  elevation: 5,
                ),
              ),
            )
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
