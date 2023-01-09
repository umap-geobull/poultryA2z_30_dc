import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Product_List.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/show_color_picker.dart';
import 'package:poultry_a2z/AppUi/edit_app_ui.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Banners/Banner.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Banners/edit_banner.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Brand/BrandsNew.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Brand/edit_brand_bottomsheet.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Offers/Offer.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/SubCategory/SubCategoriesNew.dart';
import 'package:poultry_a2z/Home/Components/MainCategories/edit_main_bottomsheet.dart';
import 'package:poultry_a2z/Home/Components/UserLocation/show_user_location.dart';
import 'package:poultry_a2z/AdminDashboard/Vendor_Menu.dart';
import 'package:poultry_a2z/Home/SearchList.dart';
import 'package:poultry_a2z/Home/home_loader.dart';
import 'package:poultry_a2z/Home/whatsapp_ui.dart';
import 'package:poultry_a2z/InAppReview/check_app_review.dart';
import 'package:poultry_a2z/Utils/AppConfig.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/Utils/coustom_bottom_nav_bar.dart';
import 'package:poultry_a2z/Utils/enums.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:poultry_a2z/grobiz_start_pages/UserBusiness/select_applogo_bottomsheet.dart';
import 'package:poultry_a2z/grobiz_start_pages/create_dynamic_link.dart';
import 'package:poultry_a2z/grobiz_start_pages/grobiz_help/contact_us/ContactUsModel.dart';
import 'package:poultry_a2z/grobiz_start_pages/order_history/order_history_model.dart';
import 'package:poultry_a2z/grobiz_start_pages/profile/admin_profile_model.dart';
import 'package:poultry_a2z/grobiz_start_pages/verify_email/email_otp_screen.dart';
import '../Cart/Cart_Screen.dart';
import '../Cart/model/cart_count_model.dart';
import '../Product_Details/Product_List_User.dart';
import '../Sign_Up/vendor_signup_catagory.dart';
import '../Utils/App_Apis.dart';
import '../grobiz_start_pages/welcome/type_app_base_model.dart';
import 'Components/AddNewComponent/Offers/edit_offer.dart';
import 'Components/AddNewComponent/Products/ProductNew.dart';
import 'Components/AddNewComponent/Products/edit_product_bottomsheet.dart';
import 'Components/AddNewComponent/Recommended_Products/RecommendedNew.dart';
import 'Components/AddNewComponent/Recommended_Products/edit_recommendedproducts.dart';
import 'Components/AddNewComponent/Sliders/Slider.dart';
import 'Components/AddNewComponent/Sliders/edit_slider.dart';
import 'Components/AddNewComponent/SubCategory/edit_subcategory_bottomsheet.dart';
import 'Components/AddNewComponent/SubCategory/sub_categories_list_screen.dart';
import 'Components/AddNewComponent/models/home_component_model.dart';
import 'Components/AddNewComponent/select_type_bottomsheet.dart';
import 'Components/MainCategories/categories.dart';
import 'Components/component_constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart';
import 'package:getwidget/getwidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'all_category_types.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = "/home";

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  bool iseditSwitched=false;
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  bool isHomeAvailable=false,isServerError=false;

  bool isApiCallProcessing=false;
  late Route routes;

  String baseUrl='';
  String userType='';
  String user_id='',admin_auto_id='';
  String appName='';

  bool isInitialApiCallProcessing=true,isAllApiCallProcessing=false;

  String cartCount='0';
  List<GetAdminCartProductLists> getAdminCartProductLists=[];

  bool isShutterOpen=false;
  String businessDetailsId='',businessName='',businessLogo='';
  List<GetHomeComponentList> homeComponentList=[];

  String contact_india='',contact_us='', contact_message='', contact_email='';
  String email_verification_status='';
  String purchasePlanStatus='';
  List<GetOrderHistoryList> getOrderHistoryList=[];

  String eraseDataStatus='Yes';

  late File share_app_image;

  Color appBarColor=Colors.white,appBarIconColor=Colors.black;
  String showLocationOnHomeScreen='';
  Color bototmBarColor=Colors.white, bottomMenuIconColor=Color(0xFFFF7643);
  int selectedFromTypes=-1;
  int selectedFromAll=-1;
  bool otherSelected=false;
  List<App_Category> allAppTypes=[];
  List<AppBaseData> ecomAppTypes=[];
  String appType='', app_type_id='';
  //appTypeId='',;
  ScrollController _scrollController = ScrollController();

  void getappUi() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? appBarColor =prefs.getString('appbarColor');
    String? appbarIcon =prefs.getString('appbarIconColor');
    String? showLocation =prefs.getString('showLocationOnHomescreen');

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
      setState(() {});
    }

    if(appbarIcon!=null){
      this.appBarIconColor=Color(int.parse(appbarIcon));
      setState(() {});
    }

    if(showLocation!=null){
      this.showLocationOnHomeScreen=showLocation;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getappUi();
    getBaseUrl();
    getContactUs();

    CheckAppReview.checkReviewOnHome();
  }

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? userType =prefs.getString('user_type');
    String? userId = prefs.getString('user_id');
    String? appName =prefs.getString('app_name');
    String? adminId =prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');

    if(appName!=null){
      this.appName=appName;
      setState(() {});
    }

    print("base url");
    if(userId!=null && adminId!=null && baseUrl!=null && apptypeid!=null && userType!=null){

      if(this.mounted){
        setState(() {
          this.user_id=userId;
          this.baseUrl=baseUrl;
          this.admin_auto_id=adminId;
          this.app_type_id=apptypeid;
          this.userType=userType;

          if(userType == 'Admin'){
            getEditSession();
            getEmailVerificationStatus();
            getAllPlansDetailsApi();

          }
          else{
            iseditSwitched = false;
          }

          getAdminProfile();
          getCartProdList(user_id);

          isInitialApiCallProcessing=true;
          getHomeComponents(baseUrl);
        });
      }
    }
  }

  showHideSetting(){
    if(this.mounted){
      setState(() {
        isShutterOpen=!isShutterOpen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => showAlertExit(),
        child: Scaffold(
          appBar: AppBar(
              toolbarHeight: 50,
              backgroundColor: appBarColor,
              //title:  Text(appName ,style: TextStyle(color: appBarIconColor,fontSize: 18)),
              automaticallyImplyLeading: false,
              title:GestureDetector(
                onTap: ()=>{
                  if(userType=='Admin'){
                    showEditLogo()
                  }
                },
                child: Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(right: 10,top: 10,bottom: 10),
                    //child: SvgPicture.asset('assets/flipkart.svg',alignment: Alignment.centerLeft,),
                    child: businessLogo.isNotEmpty?
                    CachedNetworkImage(
                      imageUrl: app_logo_base_url+businessLogo,
                      placeholder:(context, url) => Container(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ):
                    userType=='Admin' && iseditSwitched==true?
                    Container(
                      padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                      decoration: BoxDecoration(
                          color: Colors.blueAccent.shade100,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Text('+ Logo',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                    ):
                    Container()
                  //Image.asset('assets/app_logo.png',alignment: Alignment.centerLeft,),
                ),
              ),
              actions: [
                userType=='Admin'?
                Switch(
                  onChanged: toggleSwitch,
                  value: iseditSwitched,
                  activeColor: Colors.grey,
                  activeTrackColor: Colors.grey,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ) : Container(),


                user_id==super_id?IconButton(
                  visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    getAllBaseAppsCategory();
                  },
                  icon: Icon(Icons.swap_horiz, color: appBarIconColor),
                )
                    : Container(),

                userType=='Admin'?
                IconButton(
                  visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    showContactInfo();
                  },
                  icon: Icon(Icons.call, color: appBarIconColor),
                ):
                Container(),

                IconButton(
                  visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchList()));
                  },
                  icon: Icon(Icons.search, color: appBarIconColor),
                ),
                // IconButton(
                //   icon: Icon(
                //     Icons.favorite_border,
                //     size: 25,
                //     color:appBarIconColor,
                //   ),
                //   onPressed: () =>
                //       Navigator.pushReplacement(context, MaterialPageRoute(
                //           builder: (context) => Wishlist())),
                // ),
                // _shoppingCartBadge(),
              ]
          ),
          body:Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    iseditSwitched==true?
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child:  isShutterOpen==false?
                      GestureDetector(
                        onTap: ()=>{
                          showHideSetting()
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 15.0,
                                    offset: Offset(0.0, 0.75)
                                )
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5)
                              )
                          ),
                          width: 50,
                          child: const Icon(Icons.keyboard_arrow_down,color: Colors.orange,size: 20,),
                        ),):
                      Container(
                        decoration: const BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.black54,
                                blurRadius: 15.0,
                                offset: Offset(0.0, 0.75)
                            )
                          ],
                          color: Colors.white,
                        ),
                        child: Column(
                          children: <Widget>[
                            // Container(
                            //     margin: const EdgeInsets.only(top: 5, bottom: 5),
                            //     child: Vendor_Menu(user_id,admin_auto_id)),

                            Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child:SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    eraseDataStatus=='No'?
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      child:  ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                        ),
                                        child: Text('Consultant Type',style: TextStyle(color: Colors.white,fontSize: 12)),
                                        onPressed: ()=> {
                                          //showAlertErase()
                                        },
                                      ),
                                    ):
                                    Container(),

                                    eraseDataStatus=='No'?
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      child:  ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                        ),
                                        child: Text('Specialization',style: TextStyle(color: Colors.white,fontSize: 12)),
                                        onPressed: ()=> {
                                          //showAlertErase()
                                        },
                                      ),
                                    ):
                                    Container(),

                                    Container(
                                      margin: const EdgeInsets.all(5),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[100],
                                        ),
                                        child: const Text('Add Component',style: TextStyle(color: Colors.black87,fontSize: 12),),
                                        onPressed: () {
                                          if(eraseDataStatus=='No'){
                                            showAlertAddComponent();
                                          }
                                          else{
                                            showAddComponent();
                                          }
                                        },
                                      ),
                                    ),

                                    Container(
                                      margin: const EdgeInsets.all(5),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[100],
                                        ),
                                        child:Row(
                                          children: const <Widget>[
                                            Icon(Icons.edit,color: black,size: 12,),
                                            Text('App UI',style: TextStyle(color: Colors.black87,fontSize: 12),),
                                          ],
                                        ),
                                        onPressed: () {
                                          gotoAppUi();
                                        },
                                      ),
                                    ),

                                    userType=='Admin'?Container(
                                      child:  ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[100],
                                        ),
                                        child: Text('Import Vendor',style: TextStyle(color: Colors.black87,fontSize: 12)),
                                        onPressed: ()=> {
                                          //checkPlanDetails()
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => VendorSignupCatagory()))
                                        },
                                      ),
                                      margin: EdgeInsets.all(5),
                                    ):Container(),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: ()=>{
                                showHideSetting()
                              },
                              child: Container(
                                child: Icon(Icons.keyboard_arrow_up,color: Colors.orange,size: 30,),
                                width: 50,
                              ),)
                          ],
                        ),
                      ),
                    ):
                    Container(),

                    showLocationOnHomeScreen=='Yes'?
                    UserLocation():
                    Container(),

                    homeComponentList.isNotEmpty?
                    Expanded(
                      flex: 1,
                      child: iseditSwitched==true?
                      ReorderableListView.builder(
                        //physics: NeverScrollableScrollPhysics(),
                        //shrinkWrap: true,
                          cacheExtent: 5000,
                          onReorder: reorderData,
                          itemCount: homeComponentList.length,
                          itemBuilder: (context, index) =>
                              Container(
                                key: ValueKey(homeComponentList[index]),
                                child: getComponentUi(homeComponentList[index]),
                              )
                      ):
                      ListView.builder(
                        // physics: NeverScrollableScrollPhysics(),
                        //shrinkWrap: true,
                          cacheExtent: 5000,
                          itemCount: homeComponentList.length,
                          itemBuilder: (context, index) =>
                              Container(
                                key: ValueKey(homeComponentList[index]),
                                child: getComponentUi(homeComponentList[index]),
                              )
                      ),
                    ):
                    Container()
                  ],
                ),
              ),

              homeComponentList.isEmpty&& isInitialApiCallProcessing==false && isApiCallProcessing==false?
              Center(
                child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('No home components added'),
                        SizedBox(height: 20,),

                        userType == 'Admin'?
                        Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text('+ Add Component',
                                  style: TextStyle(color: Colors.black87,fontSize: 12),),
                                onPressed: () {
                                  if(eraseDataStatus=='No'){
                                    showAlertAddComponent();
                                  }
                                  else{
                                    showAddComponent();
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 10,),

                            Text('OR'),
                            SizedBox(height: 10,),

                          ],
                        ):
                        Container(),

                        ElevatedButton(
                          onPressed: () {
                            if(user_id!=null && admin_auto_id!=null && baseUrl!=null){
                              if(this.mounted){
                                setState(() {
                                  isInitialApiCallProcessing=true;
                                });
                              }
                              getHomeComponents(baseUrl);
                            }
                          },
                          child: const Text("Refresh Page",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            minimumSize: const Size(70, 30),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(2.0)),
                            ),
                          ),
                        )
                      ],
                    )
                ),
              ) :
              Container(),

              isInitialApiCallProcessing==true?
              HomeLoader():
              Container(),

              isServerError==true?
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset('assets/server_error.png'),
                    ),
                    const Text('Server Error.. Please try later')
                  ],
                ),
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
          bottomSheet: CustomBottomNavBar(MenuState.home,
            bototmBarColor,bottomMenuIconColor,),
        ));
  }

  showSelectSuperType() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.green[50],
        title: const Text(
          'Select App Type',
          style: TextStyle(color: Colors.black87,fontSize: 15),
        ),
        content:
        !allAppTypes.isEmpty?
        Container(
            height: 240,
            width: MediaQuery.of(context).size.width,
            child: GridView.count(
              padding: EdgeInsets.zero,
              // shrinkWrap: true,
              crossAxisCount: 2,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: showAllAppBase(),
            )
        ):
        allAppTypes.isEmpty?
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          height: 100,
          child: Text('Sorry..No app found'),):
        Container(),

      ),
    );
  }

  showAllAppType(){
    if(this.mounted){
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 100),
          curve: Curves.bounceIn);

      setState(() {
        //showOthers=false;
        //showAllApptypes=true;
        //getAllBaseApps();
      });
    }
  }

  List<Widget> showAllAppBase(){
    List<Widget> appBase=[];

    for(int index=0;index<allAppTypes.length;index++){
      appBase.add(
          GestureDetector(
            onTap: ()=>{

              selectedFromTypes=-1,
              otherSelected=false,
              selectedFromAll=index,

              selectAppBase(allAppTypes[index].name, allAppTypes[index].id)
            },
            child: Container(
                margin: EdgeInsets.all(3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                  selectedFromAll==index?
                  Border.all(
                    width: 2,
                    color: Colors.green,
                  ):
                  Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                width: 80,
                height:80,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Text(allAppTypes[index].name,style: TextStyle(color: Colors.black54,fontSize: 15),)
                  ],
                )),
          ));
    }
    return appBase;
  }

  selectAppBase(String app_type,String app_type_id) async {
    appType=app_type;
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString("app_type_id", app_type_id);
    //getHomeComponents(baseUrl);
    getBaseUrl();
    Navigator.pop(context);
    if(this.mounted){
      setState(() {
      });
    }

    //playReceiveSound();
  }

  getAllBaseAppsCategory() async {
    if(this.mounted){
      setState(() {
        allAppTypes.clear();
        isAllApiCallProcessing=true;
      });
    }

    var url=AppConfig.grobizBaseUrl+get_all_categories_list;

    print(url);

    var uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      isAllApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      print("all app type status="+status.toString());
      if(status==1){
        AllAppCategoryType app_category=AllAppCategoryType.fromJson(json.decode(response.body));
        allAppTypes=app_category.data;
        SharedPreferences prefs= await SharedPreferences.getInstance();
        app_type_id=allAppTypes[0].id;
        prefs.setString('app_type_id',app_type_id);
        //print('all apps'+allAppTypes.toString());

        showSelectSuperType();
        if(this.mounted){
          setState(() {});
        }
      }
      else{
        allAppTypes=[];
        if(this.mounted){
          setState(() {});
        }
      }
    }

    else if(response.statusCode==500){
      isAllApiCallProcessing=false;

      if(this.mounted){
        setState(() {});
      }
    }
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

  showAlertErase() {
    return showDialog(
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
                      'Do you want to erase demo data?',
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
                                eraseDataApi();
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
                        SizedBox(
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

  Widget _shoppingCartBadge() {
    return Badge(
      badgeColor: Colors.orangeAccent,
      position: BadgePosition.topEnd(top: 0, end: 3),
      animationDuration: const Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
      badgeContent: Text(
        cartCount.toString(),
        style: const TextStyle(color: Colors.white),
      ),
      child: IconButton(
          icon: Icon(Icons.shopping_cart, color: appBarIconColor),
          onPressed: () {
            gotoCartScreen();
          }
      ),
    );
  }

  gotoCartScreen(){
    routes = MaterialPageRoute(builder: (context) => const Cart_Screen());
    Navigator.push(context, routes).then(onGoBackFromCart);
  }

  gotoAppUi(){
    routes = MaterialPageRoute(builder: (context) => EditAppUi());
    Navigator.push(context, routes).then(onGoBackFromAppUi);
  }

  FutureOr onGoBackFromCart(dynamic value) {
    getCartProdList(user_id);
    setState(() {});
  }

  FutureOr onGoBackFromAppUi(dynamic value) {
    getappUi();
    setState(() {});
  }

  goToOfferProductScreen(String type,String offer_id){

    if(userType=='Admin'){
      routes = MaterialPageRoute(
          builder: (context) => Product_List(
            type: type,
            main_cat_id: '',
            sub_cat_id:'',
            brand_id: '',
            home_componet_id: '',
            offer_id: offer_id,));
    }
    else{
      routes = MaterialPageRoute(
          builder: (context) => Product_List_User(
            type: type,
            main_cat_id: '',
            sub_cat_id:'',
            brand_id: '',
            home_componet_id: "",
            offer_id: offer_id,));
    }

    Navigator.push(context, routes).then(onGoBackFromCart);
  }

  goToProductScreen(String type,String main_cat_id,String sub_cat_id,String brand_id){

    print("Nav Function Data ${type} ${brand_id} ${sub_cat_id}");
    if(userType=='Admin'){
      routes = MaterialPageRoute(
          builder: (context) => Product_List(type: type,main_cat_id: main_cat_id,
            sub_cat_id:sub_cat_id,
            brand_id: brand_id,
            home_componet_id: '',
            offer_id: '',));
    }
    else{
      // routes = MaterialPageRoute(
      //     builder: (context) => Product_List_User(type: type,main_cat_id: main_cat_id,
      //         sub_cat_id:sub_cat_id,
      //         brand_id: brand_id,
      //         home_componet_id: "",
      //     offer_id: '',));
      routes = MaterialPageRoute(
          builder: (context) => SubCategoriesListScreen());
    }

    Navigator.push(context, routes).then(onGoBackFromCart);
  }

  void reorderData(int oldindex, int newindex){
    String id=homeComponentList[oldindex].id;

    updateIndexApi(id, oldindex.toString(),newindex.toString());

    setState(() {
      if(newindex>oldindex){
        newindex-=1;
      }
      final items =homeComponentList.removeAt(oldindex);
      homeComponentList.insert(newindex, items);
    });

  }

  getComponentUi(GetHomeComponentList homecomponent){
    if(homecomponent.componentType==SLIDER){
      return Container(
        margin: const EdgeInsets.only(bottom: 2),
        child: Column(
          children: <Widget>[
            HomeSlider(homecomponent.id,iseditSwitched,showAlert,
                double.parse(homecomponent.height),
                Color(int.parse(homecomponent.backgroundColor))
            )
          ],
        ),
      );
    }
    else if(homecomponent.componentType==BANNER){
      return Container(
        margin: const EdgeInsets.only(bottom: 2),
        child: Column(
          children: <Widget>[
            HomeBanner(homecomponent.id,iseditSwitched,showAlert,
                double.tryParse(homecomponent.height)!,
                Color(int.parse(homecomponent.backgroundColor))
            )
          ],
        ),
      );
    }
    else if(homecomponent.componentType==SHOP_BY_CATEGORY){
      return   Container(
        margin: const EdgeInsets.only(bottom: 2),
        child: Column(
          children: <Widget>[
            // gotProducListScreen(),
            SubCategoriesNew(iseditSwitched,showAlert,goToProductScreen,homecomponent.id,userType,homecomponent.iconType,
                homecomponent.layoutType)
          ],
        ),
      );
    }
    else if(homecomponent.componentType==SHOP_BY_BRANDS){
      return Container(
        margin: const EdgeInsets.only(bottom: 2),
        child: Column(
          children: <Widget>[
            BrandsNew(iseditSwitched,showAlert,goToProductScreen,homecomponent.id,
                userType,homecomponent.iconType,homecomponent.layoutType)
          ],
        ),
      );
    }
    else if(homecomponent.componentType==OFFERS){
      return Container(
        margin: const EdgeInsets.only(bottom: 2),
        child: Column(
          children: <Widget>[
            HomeOffer(homecomponent.id,iseditSwitched,showAlert,goToOfferProductScreen)
          ],
        ),
      );
    }
    else if(homecomponent.componentType==RECOMMENDED_PRODUCTS){
      return Container(
        margin: const EdgeInsets.only(bottom: 2),
        child: Column(
          children: <Widget>[
            RecommendedNew(iseditSwitched,showAlert,homecomponent.id,userType,getAdminCartProductLists,addProductToCart,
                homecomponent.iconType,homecomponent.layoutType)
          ],
        ),
      );
    }
    else if(homecomponent.componentType==PRODUCTS){
      return Container(
        margin: const EdgeInsets.only(bottom: 2),
        child: Column(
          children: <Widget>[
            ProductNew(iseditSwitched,showAlert,homecomponent.id,userType,getAdminCartProductLists,addProductToCart,
                homecomponent.iconType,homecomponent.layoutType)
          ],
        ),
      );
    }
    else if(homecomponent.componentType==MAIN_CATEGORY){
      return   Container(
        margin: const EdgeInsets.only(bottom: 2),
        child: Column(
          children: <Widget>[
            // gotProducListScreen(),
            Categories('',iseditSwitched,showAlert,goToProductScreen,homecomponent.id,userType,homecomponent.iconType,
                homecomponent.layoutType)
          ],
        ),
      );
    }
    else{
      return Container();
    }
  }

  addProductToCart(){
    int cart_count=int.parse(cartCount);
    cart_count=cart_count+1;
    cartCount=cart_count.toString();
    if(this.mounted){
      setState(() {});
    }
  }

  void toggleSwitch(bool value) {

    if(iseditSwitched == false)
    {
      iseditSwitched = true;
      print('Switch Button is ON');
    }
    else
    {
      iseditSwitched = false;
      print('Switch Button is OFF');
    }

    if(mounted){
      setState(() {
        saveEditSession();
      });
    }
  }

  showAddComponent() {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SelectType(onAddComponentListener);
        });
  }

  showEditLogo() {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SelectLogo(onAddLogoListener);
        });
  }

  void onAddLogoListener() {
    Navigator.pop(context);
    getAdminProfile();
  }

  saveEditSession() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setBool('isEditSwitched', iseditSwitched);
    print('session set');
  }

  getEditSession() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    bool? iseditSwitched =prefs.getBool('isEditSwitched');

    if(iseditSwitched!=null && userType =='Admin'){
      if(this.mounted){
        this.iseditSwitched=iseditSwitched;
      }
    }
    else{
      if(userType=='Admin'){
        if(this.mounted){
          this.iseditSwitched=true;
        }
      }
    }
  }

  void onAddComponentListener(String type,String id) {
    Navigator.pop(context);

    if(type==SLIDER){
      showSliderEdit(id);
    }
    if(type==BANNER){
      showBannerEdit(id);
    }
    if(type==OFFERS){
      showOfferEdit(id);
    }
    if(type==SHOP_BY_CATEGORY){
      showCategoryEdit(id);
    }
    if(type==SHOP_BY_BRANDS){
      showBrandEdit(id);
    }
    if(type==RECOMMENDED_PRODUCTS){
      showRecommendedEdit(id);
    }
    if(type==PRODUCTS){
      showProductEdit(id);
    }
    if(type==MAIN_CATEGORY){
      showMaincategoryEdit(id);
    }
  }

  void onSavelistener(){
    Navigator.pop(context);
    if(this.mounted){
      setState(() {
        isApiCallProcessing==true;
      });
    }
    getHomeComponents(baseUrl);
    getCartProdList(user_id);

  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
    getCartProdList(user_id);
  }

  showLocationColorChooser() {
    showDialog(
        context: context,
        builder: (context){
          return ShowColorPicker(onSaveCallback: changeLocationcolor,pickerColor: Colors.white,);
        }
    );
  }

  changeLocationcolor(Color color){
    Navigator.of(context).pop();
  }

  FutureOr onGoBack(dynamic value) {
    if(this.mounted){
      setState(() {
        isApiCallProcessing==true;
      });
    }
    getHomeComponents(baseUrl);
    getCartProdList(user_id);
  }

  showSliderEdit(String id) {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return EditSlider(onSavelistener,id);
        });
  }

  void showCategoryEdit(String id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditSubCategoryStyle(onSavelistener,id)));
  }

  void showRecommendedEdit(String id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditRecommendedStyle(onSavelistener,id)));
  }

  void showProductEdit(String id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProductStyle(onSavelistener,id)));
  }

  showBrandEdit(String id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditBrandsStyle(onSavelistener,id)));
  }

  showBannerEdit(String id) {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return EditBanner(onSavelistener,id);
        });
  }

  showOfferEdit(String id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditOffer(onSavelistener,id)));
  }

  showMaincategoryEdit(String id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditMainCategoryStyle(onSavelistener,id)));
  }

  getHomeComponents(String baseUrl) async {
    var url=baseUrl+'api/'+get_home_component_list;

    /* print('home '+url);*/

    var uri = Uri.parse(url);

    final body= {
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };
    /*print('admin_id: '+admin_auto_id+' app_type: '+app_type_id);*/

    try{
      final response = await http.post(uri, body: body);
      print("home response ${response.body}");
      if (response.statusCode == 200) {
        if(this.mounted){
          setState(() {
            isServerError=false;
            isApiCallProcessing=false;
            isInitialApiCallProcessing=false;
          });
        }
        final resp=jsonDecode(response.body);
        int status=resp['status'];

        if(status==1){
          HomeComponentModel homeComponentModel=HomeComponentModel.fromJson(json.decode(response.body));
          List<GetHomeComponentList> homeList=homeComponentModel.getHomeComponentList;
          homeComponentList.clear();
          if(mounted){
            setState(() {
              for (var element in homeList) {
                homeComponentList.add(element);
              }
              //print(homeComponentList);
            });
          }

          CheckAppReview.saveHomeComponentSize(homeComponentList.length);
        }
        else{
          homeComponentList.clear();
        }
      }
      else {
        if(this.mounted){
          setState(() {
            isApiCallProcessing=false;
            isInitialApiCallProcessing=false;
            isServerError=true;
          });
        }
      }
    }
    catch(e){
      print("Home Component List="+e.toString());
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
          isInitialApiCallProcessing=false;
          isServerError=true;
        });
      }
    }
  }

  void showAlert(String id) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: const Text('Are you sure?',style: TextStyle(color: Colors.black87),),
          content:Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    const Text('Do you want to delete this ui component',style: TextStyle(color: Colors.black54),),
                    const SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            child: ElevatedButton(
                              onPressed: (){
                                deleteComponentApi(id);
                                Navigator.pop(context);
                              },
                              child: const Text("Yes",style: TextStyle(color: Colors.black54,fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[200],
                                minimumSize: const Size(70,30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )
                        ),
                        const SizedBox(width: 10,),
                        Container(
                            child: ElevatedButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              child: const Text("No",
                                  style: TextStyle(color: Colors.black54,fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[200],
                                minimumSize: const Size(70,30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  Future deleteComponentApi(String id) async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "homecomponent_auto_id":id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    var url=baseUrl+'api/'+delete_home_component;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      String status=resp['status'];

      print(resp.toString());

      if(status=="1"){
        if(this.mounted){
          setState(() {
            isApiCallProcessing==true;
          });
        }

        getHomeComponents(baseUrl);
      }
      else{
        String msg=resp['msg'];
        Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.grey,);

      }
    }
    else if(response.statusCode ==500){
      if(this.mounted){
        setState(() {
          isApiCallProcessing==false;
        });
      }
      Fluttertoast.showToast(
        msg: 'Server Error',
        backgroundColor: Colors.grey,);

    }
  }

  void updateIndexApi(String id,String oldIndex, String newindex) async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "homecomponent_auto_id":id,
      "previous_index":oldIndex,
      "new_index":newindex,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    var url=baseUrl+'api/'+update_home_component_index;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      String status=resp['status'];
      if(status=="1"){
        if(mounted){
          setState(() {
            isApiCallProcessing=false;
          });
        }
        Fluttertoast.showToast(
          msg: 'Reordering done successfully',
          backgroundColor: Colors.grey,);
      }
      else{
        if(mounted){
          setState(() {
            isApiCallProcessing=false;
          });
        }
        Fluttertoast.showToast(
          msg: 'Error occured while synching component order to server',
          backgroundColor: Colors.grey,);
      }
    }
  }

  getCartProdList(String userId) async {
    final body = {
      "user_auto_id": userId,
      "admin_auto_id": admin_auto_id
    };

    print("user_id=>"+userId);

    var url = baseUrl+'api/' + get_cart_product_count;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      print('cart count: '+response.statusCode.toString());
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      print('cart count: '+status.toString());
      if (status == 1) {
        CartCountModel cartCountModel=CartCountModel.fromJson(json.decode(response.body));
        cartCount=cartCountModel.productCountData.toString();
        getAdminCartProductLists=cartCountModel.getAdminCartProductLists;
      }
      else {
        cartCount='0';
      }

      if(mounted){
        setState(() {});
        cartCount;
      }
    }
  }

  //grobiz

  Future savePaymentDetails(String payment_gateway_name,String clientd,
      String secretkey, String marchant_name,String razorpay_key) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('payment_gateway_name', payment_gateway_name );
    prefs.setString('clientd', clientd );
    prefs.setString('secretkey', secretkey );
    prefs.setString('marchant_name', marchant_name );
    prefs.setString('razorpay_key', razorpay_key );
    print('session set');
  }

  Future getAdminProfile() async {
    final body = {
      "user_auto_id":admin_auto_id,
    };

    var url=AppConfig.grobizBaseUrl+get_admin_profile;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);
    //print(response.statusCode.toString());

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      //print('admin_profile: '+status.toString());
      if(status==1){
        AdminProfileModel adminProfileModel=AdminProfileModel.fromJson(json.decode(response.body));
        businessLogo=adminProfileModel.data[0].appLogo;
        share_app_image= await urlToFile(app_logo_base_url+businessLogo);
        eraseDataStatus= adminProfileModel.data[0].eraseDataStatus;

        saveBusinessLogo(businessLogo);

        savePaymentDetails(
            adminProfileModel.data[0].paymentGatewayName,
            adminProfileModel.data[0].clientId,
            adminProfileModel.data[0].secretKey,
            adminProfileModel.data[0].merchantName,
            adminProfileModel.data[0].razorpayKey);

        if(this.mounted){
          setState(() {
          });
        }
      }

      else {
        String msg=resp['msg'];
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
      }
    }
    else if (response.statusCode == 500) {
      Fluttertoast.showToast(msg: 'Server error', backgroundColor: Colors.grey,);
      setState(() {});
    }
  }

  saveBusinessLogo(String logo) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('app_logo',logo);
  }

  Future<File> urlToFile(String imageUrl) async {
    var rng = Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File(tempPath+ (rng.nextInt(100)).toString() +'.png');
    Uri uri=Uri.parse(imageUrl);
    http.Response response = await http.get(uri);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  getAllPlansDetailsApi() async {
    if(this.mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body={
      "user_auto_id":user_id,
    };

    var url=AppConfig.grobizBaseUrl+orderHistory;
    var uri = Uri.parse(url);
    final response = await http.post(uri,body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      print('plan: '+status.toString());
      if(status==1){
        OrderHistoryModel subscriptionPlanModel=OrderHistoryModel.fromJson(json.decode(response.body));

        getOrderHistoryList=subscriptionPlanModel.getOrderHistoryList;

        if(this.mounted){
          setState(() {});
        }
      }
    }

    else if(response.statusCode==500){
      isApiCallProcessing=false;

      if(this.mounted){
        setState(() {});
      }
    }
  }

  Future getContactUs() async {
    var url=AppConfig.grobizBaseUrl+showContactDetails;

    Uri uri=Uri.parse(url);

    final response = await http.get(uri);
    print(response.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        ContactUs_Model contactUs_Model = ContactUs_Model.fromJson(json.decode(response.body));
        var mainList = contactUs_Model.contactDetails;
        contact_india = mainList[0].contactIndia;
        contact_us = mainList[0].contactUs;
        contact_message = mainList[0].message;
        contact_email = mainList[0].email;
      }
      if(mounted){
        setState(() {});
      }
    }
  }

  shareApp() async{

    print(appName);

    ShareAppLink.shareApp(appName, share_app_image, admin_auto_id);
  }

  showContactInfo() async {
    return await showDialog(
        context: context,
        builder: (context) =>Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            padding: EdgeInsets.all(50),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)
              ),
              child:Wrap(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(5),
                                topLeft: Radius.circular(5))
                        ),
                        width: MediaQuery.of(context).size.width,
                        child:Row(
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.person,color: Colors.orangeAccent,),
                              decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.white),
                              width: 30,
                              height: 30,
                              margin: EdgeInsets.only(right: 10),
                            ),
                            Text(
                              '',
                              style: TextStyle(color: Colors.white,fontSize: 16),
                            ),
                            Expanded(
                              flex:1,
                              child: Container(
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(Icons.close_rounded,color: Colors.white,),
                                  onPressed: ()=>{Navigator.pop(context)},
                                ),
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.centerRight,
                                height: 30,
                              ),
                            )
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                        child:Text(
                          contact_message,
                          style: TextStyle(color: Colors.black,fontSize: 15,),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            contact_india.isNotEmpty?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('India: ', style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                                GestureDetector(
                                    onTap: ()=>{
                                      _makePhoneCall(contact_india)
                                    },
                                    child: Text(contact_india, style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline
                                    )))
                              ],
                            ):
                            Container(),

                            SizedBox(
                              height: 10,
                            ),

                            contact_us.isNotEmpty?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('US: ', style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                                GestureDetector(
                                  onTap: ()=>{
                                    _makePhoneCall(contact_us)
                                  },
                                  child: Text(contact_us, style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline
                                  )),
                                )
                              ],
                            ):
                            Container(),

                            SizedBox(
                              height: 10,
                            ),

                            contact_email.isNotEmpty?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Email: ', style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                                GestureDetector(
                                  onTap: ()=>{
                                    _sendMail(contact_email)
                                  },
                                  child: Text(contact_email, style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline
                                  )),
                                )
                              ],
                            ):
                            Container(),

                            MessageOnWhatsApp(),

                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _sendMail(String mail_id) async {
    final mailtoUri = Uri(
      scheme: 'mailto',
      path: mail_id,
    );

    await launchUrl(mailtoUri);
  }

  showEmailVerification() async {
    return await showDialog(
        context: context,
        builder: (context) =>Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            padding: EdgeInsets.all(50),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)
              ),
              //height: 200,
              child: Wrap(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(5),
                                topLeft: Radius.circular(5))
                        ),
                        width: MediaQuery.of(context).size.width,
                        child:Row(
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.email,color: Colors.orangeAccent,),
                              decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.white),
                              width: 30,
                              height: 30,
                              margin: EdgeInsets.only(right: 10),
                            ),
                            Text(
                              'Verify your Email ID',
                              style: TextStyle(color: Colors.white,fontSize: 16),
                            ),
                            Expanded(
                              flex:1,
                              child: Container(
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(Icons.close_rounded,color: Colors.white,),
                                  onPressed: ()=>{Navigator.pop(context)},
                                ),
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.centerRight,
                                height: 30,
                              ),
                            )
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Your Email ID is not yet verfied', style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black54,)),

                            SizedBox(height: 30,),

                            Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.centerRight,
                              child:  Container(
                                  width: 100,
                                  height: 35,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    child: Text('Verify',style: TextStyle(color: Colors.white),),
                                    onPressed: () {
                                      gotoVerificationScreen();
                                    },
                                  )
                              )  ,
                              margin: const EdgeInsets.all(5),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  gotoVerificationScreen(){
    Navigator.pop(context);

    routes = MaterialPageRoute(builder: (context) => OtpScreen(getOrderHistoryList,
        appName, share_app_image));
    Navigator.push(context, routes).then(goBackFromVerify);
  }

  FutureOr goBackFromVerify(dynamic value){
    getEmailVerificationStatus();
  }

  Future getEmailVerificationStatus() async {
    var url=AppConfig.grobizBaseUrl+get_email_verfication_status;

    final body={
      'user_auto_id':user_id,
    };
print(body.toString());
    Uri uri=Uri.parse(url);
    final response = await http.post(uri,body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      if(status==1) {
        print('email very count: ' + status.toString());
        email_verification_status = resp['email_verification_status'];
        print("status=>"+email_verification_status.toString());
      }else{

      }
      if(mounted){
        setState(() {});
      }
    }
  }

  Future eraseDataApi() async {
    if(this.mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    var url=AppConfig.grobizBaseUrl+update_admin_data_erase_status;

    final body={
      'admin_auto_id':admin_auto_id,
    };
    Uri uri=Uri.parse(url);
    final response = await http.post(uri,body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print('erase data: '+status.toString());
      if(status==1){
        getAdminProfile();
        getHomeComponents(baseUrl);
      }
      else{
        String  msg = resp['msg'];
        Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.grey,
        );
      }
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
    }
    else if (response.statusCode == 500){
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }
      Fluttertoast.showToast(
        msg: 'Server error',
        backgroundColor: Colors.grey,
      );
    }
  }

  checkPlanDetails(){
    if (email_verification_status == 'Not Verified') {
      showEmailVerification();
    }
    else{
      if(getOrderHistoryList.isNotEmpty){
        CheckAppReview.checkReview();
        shareApp();
      }
      else{
        shareApp();
        //Navigator.push(context, MaterialPageRoute(builder: (context) => GrobizPlans()));
      }
    }
  }

  showAlertAddComponent() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          content: Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Please erase demo data before adding your data',
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
                                showAlertErase();
                              },
                              child: const Text("Erase Data",
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
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            child: ElevatedButton(
                              onPressed: () => {Navigator.pop(context)},
                              child: const Text("Close",
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

}
