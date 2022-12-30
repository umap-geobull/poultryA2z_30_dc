import 'dart:async';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/show_color_picker.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Banners/Banner.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Banners/edit_banner.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Brand/BrandsNew.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Brand/edit_brand_bottomsheet.dart';
import 'package:poultry_a2z/Utils/coustom_bottom_nav_bar.dart';
import 'package:poultry_a2z/Utils/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Utils/App_Apis.dart';
import '../Admin_add_Product/Components/Product_List.dart';
import '../Cart/Cart_Screen.dart';
import '../Cart/model/cart_count_model.dart';
import '../Home/Components/AddNewComponent/Offers/Offer.dart';
import '../Home/Components/AddNewComponent/Products/ProductNew.dart';
import '../Home/Components/AddNewComponent/Recommended_Products/RecommendedNew.dart';
import '../Home/Components/AddNewComponent/Sliders/Slider.dart';
import '../Home/Components/AddNewComponent/Sliders/edit_slider.dart';
import '../Home/Components/AddNewComponent/SubCategory/edit_subcategory_bottomsheet.dart';
import '../Home/Components/AddNewComponent/select_type_bottomsheet.dart';
import '../Home/Components/MainCategories/categories.dart';
import '../Home/Components/component_constants.dart';
import '../Home/home_loader.dart';
import '../Product_Details/Product_List_User.dart';
import 'SubCategory/SubCategoriesNew.dart';
import 'catagories_list.dart';
import 'main_category_components.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:badges/badges.dart';
import 'package:getwidget/getwidget.dart';

class MainCategoryScreen extends StatefulWidget {
  String mainCategory_auto_id;
  String mainCategory_name;
  String user_id = '';
  MainCategoryScreen(this.mainCategory_auto_id,this.mainCategory_name);

  @override
  _MainCategoryScreen createState() => _MainCategoryScreen(mainCategory_auto_id,mainCategory_name);
}

class _MainCategoryScreen extends State<MainCategoryScreen> {
  String mainCategory_auto_id;
  String mainCategory_name;

  _MainCategoryScreen(this.mainCategory_auto_id,this.mainCategory_name);

  bool iseditSwitched = true;
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  bool isHomeAvailable=false;

  bool isApiCallProcessing=false;
  late Route routes;

  List<GetMainCategoryComponents> homeComponentList=[];

  String baseUrl='';
  String userType='';
  String cartCount='0';
  List<GetAdminCartProductLists> getAdminCartProductLists=[];
  bool isInitialApiCallProcessing=true,isServerError=false;

  String user_id = '';

  bool isShutterOpen=false;

  Color appBarColor=Colors.white,appBarIconColor=Colors.black;
  Color bototmBarColor=Colors.white, bottomMenuIconColor=Color(0xFFFF7643);

  String admin_auto_id='',app_type_id='';

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');
    String? userType =prefs.getString('user_type');
    String? userId = prefs.getString('user_id');
    String? apptypeid= prefs.getString('app_type_id');

    if(userType!=null){
      this.userType=userType;

      if(userType=='Admin'){
        iseditSwitched=true;
      }
      else{
        iseditSwitched=false;
      }
      if(mounted){
        setState(() {});
      }
    }

    if(baseUrl!=null && adminId!=null && userId!=null && apptypeid!=null){
      this.admin_auto_id=adminId;
      this.baseUrl=baseUrl;
      user_id = userId;
      this.app_type_id=apptypeid;
      setState(() {});
      getCartProdList(user_id);
      getHomeComponents();
    }
  }

  void getappUi() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? appBarColor =prefs.getString('appbarColor');
    String? appbarIcon =prefs.getString('appbarIconColor');

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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getappUi();
    getBaseUrl();
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
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text(mainCategory_name ,style: TextStyle(color: appBarIconColor)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: appBarIconColor,size: 20,),
            onPressed: ()=>{Navigator.of(context).pop()},
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
            )            : Container(),

            // IconButton(
            //   visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
            //   padding: EdgeInsets.zero,
            //   onPressed: () {},
            //   icon: Icon(Icons.search, color: homeMenuIconColor),
            // ),

          /*  IconButton(
              visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: Icon(Icons.notifications, color: homeMenuIconColor),
            ),*/

/*            IconButton(
              visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: const Icon(Icons.favorite_outline_rounded, color: homeMenuIconColor),
            )*/
            // _shoppingCartBadge(),
          ]
      ),
      // drawer: Maindrawer(),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 40),
            child:Column(
              children: [
                iseditSwitched==true?
                Container(
                  child:  isShutterOpen==false?
                  GestureDetector(
                    onTap: ()=>{
                      showHideSetting()
                    },
                    child: Container(
                      child: Icon(Icons.keyboard_arrow_down,color: Colors.orange,size: 20,),
                      decoration: BoxDecoration(
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
                    ),):
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
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
                        Container(
                          child:  ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey[100],
                            ),
                            child: const Text('Add Component',style: TextStyle(color: Colors.black87),),
                            onPressed: () {
                              showAddComponent();
                            },
                          ),
                          margin: const EdgeInsets.all(5),
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
                Container(
                  // child: VendorCatagoriesList(),
                ),

                //Categories(false, iseditSwitched,mainCategory_auto_id),

                Expanded(
                  flex: 1,
                  child: iseditSwitched==true?

                  ReorderableListView.builder(
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
                      cacheExtent: 5000,
                      itemCount: homeComponentList.length,
                      itemBuilder: (context, index) =>
                          Container(
                            key: ValueKey(homeComponentList[index]),
                            child: getComponentUi(homeComponentList[index]),
                          )
                  ),
                )

              ],
            ) ,
          ),

          isInitialApiCallProcessing==true?
          HomeLoader():
          // Container(),
          Container(
            child: VendorCatagoriesList(),
          ),
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
        // bottomSheet:
        // CustomBottomNavBar(
        //   MenuState.home,
        //   bototmBarColor,bottomMenuIconColor,
        // )  //  bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
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

    var url=baseUrl+update_home_component_index;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      String status=resp['status'];
      if(status=="1"){
        Fluttertoast.showToast(
          msg: 'Reordering done successfully',
          backgroundColor: Colors.grey,);
      }
      else{
        Fluttertoast.showToast(
          msg: 'Error occured while synching component order to server',
          backgroundColor: Colors.grey,);
      }
    }
  }

  getCartProdList(String userId) async {
    final body = {
      "user_auto_id": userId,
      "admin_auto_id":admin_auto_id,
    };

    print("user_id=>"+userId);

    var url = baseUrl+'api/' + get_cart_product_count;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      //print("status=>"+status.toString());
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
        //cartCount;
      }
    }
  }

  getComponentUi(GetMainCategoryComponents homecomponent){
    if(homecomponent.componentType==SLIDER){
      return Container(
        margin: const EdgeInsets.only(bottom: 2),
        child: Column(
          children: <Widget>[
            HomeSlider(homecomponent.id,iseditSwitched,showAlert,
                double.tryParse(homecomponent.height)!,
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
            SubCategoriesNew(iseditSwitched,homecomponent.id,showAlert,mainCategory_auto_id,userType,goToProductScreen,
                homecomponent.iconType,homecomponent.layoutType)
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
/*
            BrandsNew(iseditSwitched,homecomponent.id,showAlert,mainCategory_auto_id,userType,goToProductScreen,
                homecomponent.iconType,homecomponent.layoutType)
*/
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
            Categories(mainCategory_auto_id,iseditSwitched,showAlert,goToProductScreen,homecomponent.id,userType,homecomponent.iconType,
                homecomponent.layoutType)
          ],
        ),
      );
    }
    else{
      return Container();
    }
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
            offer_id: '',));
    }
    else{
      routes = MaterialPageRoute(
          builder: (context) => Product_List_User(type: type,main_cat_id: '',
              sub_cat_id:'',
              brand_id: '',
            home_componet_id: '',
            offer_id: '',));
    }

    Navigator.push(context, routes).then(onGoBackFromCart);
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

  void onAddComponentListener(String type,String id) {
    Navigator.pop(context);

    if(type==SLIDER){
      showSliderEdit(id);
    }
    if(type==BANNER){
      showBannerEdit(id);
    }
    if(type==SHOP_BY_CATEGORY){
      showCategoryEdit(id);
    }
    if(type==SHOP_BY_BRANDS){
      showBrandEdit(id);
    }
  }

  void onSavelistener(){
    print(' in save');
    Navigator.pop(context);
    if(this.mounted){
      setState(() {
        isApiCallProcessing==true;
      });
    }
    getHomeComponents();
    getCartProdList(user_id);
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  showLocationColorChooser() {
    showDialog(
        context: context,
        builder: (context){
          return ShowColorPicker(onSaveCallback: updateLocationColor,pickerColor: Colors.black,);
        }
    );
  }

  updateLocationColor(Color color){
    Navigator.of(context).pop();
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

  getHomeComponents() async {
    print('refreshing');

    final body = {
      "main_category_auto_id":mainCategory_auto_id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    var url=baseUrl+'api/'+get_main_cat_component_list;
    var uri = Uri.parse(url);
    final response = await http.post(uri,body: body);
    print("componet: "+response.statusCode.toString());
    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      print(resp.toString());

      String  status=resp['status'];
      if(status=="1"){
        MainCategoryComponets mainCategoryComponets=MainCategoryComponets.fromJson(json.decode(response.body));

        List<GetMainCategoryComponents> homeList=mainCategoryComponets.getMainCategoryComponents;
        homeComponentList.clear();

        for (var element in homeList) {
          homeComponentList.add(element);
        }
        if(this.mounted){
          setState(() {
            isInitialApiCallProcessing =false;
          });
        }
      }
      else{
        homeComponentList.clear();
        if(this.mounted){
          setState(() {
            isInitialApiCallProcessing =false;
          });
        }
      }

    }
    else if(response.statusCode==500){
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
          isInitialApiCallProcessing=false;
          isServerError=true;
        });
      }
    }
  }

  Widget _shoppingCartBadge() {
    return Badge(
      badgeColor: Colors.orangeAccent,
      position: BadgePosition.topEnd(top: 0, end: 3),
      animationDuration: const Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
      badgeContent: Text(
        cartCount.toString(),
        style: TextStyle(color: Colors.white),
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

  FutureOr onGoBackFromCart(dynamic value) {
    getCartProdList(user_id);
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
                                primary: Colors.green[200],
                                onPrimary: Colors.green,
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
                                primary: Colors.blue[200],
                                onPrimary: Colors.blue,
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
      int status=resp['status'];
      if(status==1){
        if(this.mounted){
          setState(() {
            isApiCallProcessing==true;
          });
        }
        getHomeComponents();
      }
    }
  }

  goToProductScreen(String type,String main_cat_id,String sub_cat_id,String brand_id){

    if(userType=='Admin'){
      routes = MaterialPageRoute(
          builder: (context) => Product_List(type: type,main_cat_id: main_cat_id,
            sub_cat_id:sub_cat_id,
            brand_id: brand_id,
            home_componet_id: '',
            offer_id: '',));
    }
    else{
      routes = MaterialPageRoute(
          builder: (context) =>
              Product_List_User(type: type,main_cat_id: main_cat_id,
              sub_cat_id:sub_cat_id,
              brand_id: brand_id,
                home_componet_id: '',
                offer_id: '',
              ));
    }

    Navigator.push(context, routes).then(onGoBackFromCart);
  }

}
