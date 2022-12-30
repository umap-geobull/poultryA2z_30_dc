import 'dart:async';
import 'dart:convert';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/Rest_Apis.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/show_color_picker.dart';
import 'package:poultry_a2z/AppUi/app_ui_model.dart';
import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import '../../Utils/constants.dart';

class EditAppUi extends StatefulWidget {
  EditAppUi(
      {Key? key,})
      : super(key: key);

  @override
  _EditAppUi createState() => _EditAppUi();
}

class _EditAppUi extends State<EditAppUi> {
  List<ProductModel> productList = [];

  String price='',offer_per='',final_price='';
  bool isServerError=false;
  late Route routes;

  bool isApiCallProcessing = false;
  bool isDeleteProcessing = false;

  String baseUrl = '', admin_auto_id='';
  String user_id = '';

  String icon_type='0';
  List<Widget> iconTypeList=[];

  List<AllAppUiStyle> appUiStyle=[];

  Color _appbarColor=Colors.white,
      _appbarIconColor=Colors.black,
      _primaryButtonColor=Colors.deepOrangeAccent,
      _secondaryButtonColor=Colors.orangeAccent,
      _bottomBarColor=Colors.white,
      _bottombarIconColor=Colors.deepOrangeAccent;

  String app_ui_id='';

  String showLocationOnHomscreen='';

  void getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');

    if (userId != null && baseUrl != null && adminId!=null) {
      setState(() {
        this.baseUrl = baseUrl;
        this.user_id = userId;
        this.admin_auto_id=adminId;
        if(this.mounted){
          setState(() {
          });
        }
        print(baseUrl);

        getAppUiDetails();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text("Edit App Ui",
              style: TextStyle(
                  color: appBarIconColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: () => {Navigator.of(context).pop()},
            icon: const Icon(Icons.arrow_back, color: appBarIconColor),
          ),
          actions: [
            TextButton(
                onPressed: ()=>{
                  addAppUiDetails()
                },
                child: Text('Save',style: TextStyle(color: appBarIconColor),))
          ]),
      body: Stack(
        children: <Widget>[
          Container(
            child:SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  appbarUi(),
                  Divider(height: 5,color: Colors.grey,),
                  showLocationUi(),
                  Divider(height: 5,color: Colors.grey,),
                  bottombarUi(),
                  Divider(height: 5,color: Colors.grey,),
                  buttonUi()
                ],
              ),
            ),
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

          isApiCallProcessing == true
              ? Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: const GFLoader(type: GFLoaderType.circle),
          )
              : Container()
        ],
      ),
    );
  }

  getAppUiDetails() async {
    Rest_Apis restApis = Rest_Apis();

    restApis.getAppUi(admin_auto_id, baseUrl).then((value) {
      if (value != null) {
        if(mounted){
          setState(() {
            isApiCallProcessing=false;
          });
        }

        AppUiModel appUiModel=value;

        if(appUiModel!=null && appUiModel.status==1){
          appUiStyle=appUiModel.allAppUiStyle!;

          print(appUiStyle.toString());

          //icon_type=appUiStyle[0].productLayoutType;

          if(appUiStyle[0].appbarColor.isNotEmpty){
            _appbarColor=Color(int.parse( appUiStyle[0].appbarColor));
          }

          if(appUiStyle[0].appbarIconColor.isNotEmpty){
            _appbarIconColor=Color(int.parse( appUiStyle[0].appbarIconColor));
          }

          if(appUiStyle[0].bottomBarColor.isNotEmpty){
            _bottomBarColor=Color(int.parse( appUiStyle[0].bottomBarColor));
          }

          if(appUiStyle[0].bottomBarIconColor.isNotEmpty){
            _bottombarIconColor=Color(int.parse( appUiStyle[0].bottomBarIconColor));
          }

          if(appUiStyle[0].loginRegisterButtonColor.isNotEmpty){
            _primaryButtonColor=Color(int.parse( appUiStyle[0].loginRegisterButtonColor));
          }

          if(appUiStyle[0].addToCartButtonColor.isNotEmpty){
            _secondaryButtonColor=Color(int.parse( appUiStyle[0].addToCartButtonColor));
          }

          if(appUiStyle[0].showLocationOnHomescreen.isNotEmpty){
            showLocationOnHomscreen=appUiStyle[0].showLocationOnHomescreen;
          }

          if(this.mounted){
            setState(() {
            });
          }
        }
        else{

        }
      }
    });

  }

  addAppUiDetails() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    AllAppUiStyle uiStyle=appUiStyle[0];

    Rest_Apis restApis = Rest_Apis();

    restApis.addAppUi(uiStyle.id,_appbarColor.value.toString(),_appbarIconColor.value.toString(),
        _bottomBarColor.value.toString(),_bottombarIconColor.value.toString(),
        _secondaryButtonColor.value.toString(),_primaryButtonColor.value.toString(),"",
        uiStyle.appFont,showLocationOnHomscreen,uiStyle.productLayoutType, admin_auto_id, baseUrl).then((value) {
      if (value != null) {
        if(mounted){
          setState(() {
            isApiCallProcessing=false;
          });
        }
        if(value==1){
          saveAppUiSession();
          //Navigator.pop(context);
        }
      }
    });
  }

  appbarUi() {
    return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 5,),
            Text('Edit topbar menu ui',
              style: TextStyle(color: Colors.black87,fontWeight:FontWeight.bold,fontSize: 16, ),),
            Container(
              padding: EdgeInsets.all(10),
              child: AppBar(
                  backgroundColor: _appbarColor,
                  title:Text("Title",
                      style: TextStyle(
                          color: _appbarIconColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  leading: IconButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    icon: Icon(Icons.arrow_back, color: _appbarIconColor),
                  ),
                  actions: [
                    TextButton(
                        onPressed: ()=>{
                          addAppUiDetails()
                        },
                        child: Text('Save',style: TextStyle(color: _appbarIconColor),))
                  ]),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orangeAccent,
                      ),
                      child: const Text('Background Color'),
                      onPressed: () {
                        showAppbarColorChooser();
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orangeAccent,
                      ),
                      child: const Text('Icon/Text color'),
                      onPressed: () {
                        showAppbariconColorChooser();
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        )
    );
  }

  showLocationUi() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10,top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 5,),
            Text('Show location on homescreen',
              style: TextStyle(color: Colors.black87,fontWeight:FontWeight.bold,fontSize: 16, ),),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                    child: ListTile(
                  title: const Text('Yes'),
                  leading: Radio(
                    value: 'Yes',
                    groupValue: showLocationOnHomscreen,
                    onChanged: (value) {
                      setState(() {
                        showLocationOnHomscreen = value as String;
                      });
                    },
                  ),
                )
                ),
                Expanded(
                    flex: 1,
                    child: ListTile(
                      title: const Text('No'),
                      leading: Radio(
                        value: 'No',
                        groupValue: showLocationOnHomscreen,
                        onChanged: (value) {
                          setState(() {
                            showLocationOnHomscreen = value as String;
                          });
                        },
                      ),
                    )
                )

              ],
            )
          ],
        )
    );
  }

  bottombarUi() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10,top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 5,),
            Text('Edit bottom menu ui',
              style: TextStyle(color: Colors.black87,fontWeight:FontWeight.bold,fontSize: 16, ),),
            SizedBox(height: 5,),
            Container(
              padding: EdgeInsets.all(10),
              child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: _bottomBarColor,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -15),
                    blurRadius: 20,
                    color: const Color(0xFFDADADA).withOpacity(0.15),
                  ),
                ],
              ),
              child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.home_outlined,
                            size: 25,
                            color:_bottombarIconColor
                          ),
                          onPressed: () =>{}

                        // Navigator.pushNamed(context, HomeScreen.routeName),
                      ),

                      IconButton(
                          icon: Icon(
                            Icons.list_alt_sharp,
                            size: 25,
                            color:_bottombarIconColor
                          ),
                          onPressed: () =>{}
                      ),

                      IconButton(
                        icon: Icon(
                          Icons.favorite_border,
                          size: 25,
                          color: _bottombarIconColor
                        ),
                        onPressed: () =>{}
                      ),

                      IconButton(
                          icon: Icon(
                            Icons.person_outline,
                            size: 25,
                            color:_bottombarIconColor
                          ),
                          onPressed: () =>{}
                        // Navigator.pushNamed(context, ProfileScreen.routeName),
                      ),
                    ],
                  )),
            ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orangeAccent,
                      ),
                      child: const Text('Background Color'),
                      onPressed: () {
                        showbottombarColorChooser();
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orangeAccent,
                      ),
                      child: const Text('Icon/Text color'),
                      onPressed: () {
                        showbottombariconColorChooser();
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        )
    );
  }

  buttonUi() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10,top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 5,),
            Text('App button ui',
              style: TextStyle(color: Colors.black87,fontWeight:FontWeight.bold,fontSize: 16, ),),
            SizedBox(height: 5,),
            Container(
                padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                child: Text('Primary Button Color',
                  style: TextStyle(color: Colors.black87,fontWeight:FontWeight.bold,fontSize: 15, ),),
            ),
            Container(
                padding: EdgeInsets.only(left: 10,right: 10),
                child: Text('Login/Signup/Add To Cart/Save/Edit', style: TextStyle(color: Colors.black87,fontSize: 12, ),)
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 100,right: 100,top: 10,bottom: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: _primaryButtonColor,
                ),
                child: Text('Select Color'),
                onPressed: () {
                  showPrimaryColorChooser();
                },
              ),
            ),

            Container(
                padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                child: Text('Secondary Button Color',
                  style: TextStyle(color: Colors.black87,fontWeight:FontWeight.bold,fontSize: 15, ),),
            ),
            Container(
                padding: EdgeInsets.only(left: 10,right: 10),
                child: Text('Buy Now',style: TextStyle(color: Colors.black87,fontSize: 12, ),)
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 100,right: 100,top: 10,bottom: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: _secondaryButtonColor,
                ),
                child: Text('Select Color'),
                onPressed: () {
                  showSecondaryColorChooser();
                },
              ),
            ),
          ],
        )
    );
  }

  showAppbarColorChooser() {
    showDialog(
        context: context,
        builder: (context){
          return ShowColorPicker(onSaveCallback: updateAppbarColor, pickerColor: _appbarColor,);
        }
    );
  }

  void updateAppbarColor(Color color){
    setState(() {
      _appbarColor=color;
    });

    Navigator.pop(context);

  }

  showAppbariconColorChooser() {
    showDialog(
        context: context,
        builder: (context){
          return ShowColorPicker(onSaveCallback: updateAppbarIconColor, pickerColor: _appbarIconColor,);
        }
    );
  }

  void updateAppbarIconColor(Color color){
    setState(() {
      _appbarIconColor=color;
    });

    Navigator.pop(context);

  }

  showbottombarColorChooser() {
    showDialog(
        context: context,
        builder: (context){
          return ShowColorPicker(onSaveCallback: updatebottombarColor, pickerColor: _bottomBarColor,);
        }
    );
  }

  void updatebottombarColor(Color color){
    setState(() {
      _bottomBarColor=color;
    });

    Navigator.pop(context);

  }

  showbottombariconColorChooser() {
    showDialog(
        context: context,
        builder: (context){
          return ShowColorPicker(onSaveCallback: updatebottombarIconColor,pickerColor: _bottombarIconColor,);
        }
    );
  }

  void updatebottombarIconColor(Color color){
    setState(() {
      _bottombarIconColor=color;
    });

    Navigator.pop(context);

  }

  showPrimaryColorChooser() {
    showDialog(
        context: context,
        builder: (context){
          return ShowColorPicker(onSaveCallback: updatePrimaryColor, pickerColor: _primaryButtonColor,);
        }
    );
  }

  void updatePrimaryColor(Color color){
    setState(() {
      _primaryButtonColor=color;
    });

    Navigator.pop(context);

  }

  showSecondaryColorChooser() {
    showDialog(
        context: context,
        builder: (context){
          return ShowColorPicker(onSaveCallback: updateSecondary,pickerColor: _secondaryButtonColor,);
        }
    );
  }

  void updateSecondary(Color color){
    setState(() {
      _secondaryButtonColor=color;
    });

    Navigator.pop(context);

  }

  Future<void> saveAppUiSession() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();

    prefs.setString('appbarColor', _appbarColor.value.toString());
    prefs.setString('appbarIconColor', _appbarIconColor.value.toString());
    prefs.setString('bottomBarColor', _bottomBarColor.value.toString());
    prefs.setString('bottomBarIconColor', _bottombarIconColor.value.toString());
    prefs.setString('primaryButtonColor', _primaryButtonColor.value.toString());
    prefs.setString('secondaryButtonColor', _secondaryButtonColor.value.toString());
    prefs.setString('showLocationOnHomescreen', showLocationOnHomscreen);
    prefs.setString('productLayoutType', showLocationOnHomscreen);

    print("set");

    Fluttertoast.showToast(msg: "App Ui Updated Successfully", backgroundColor: Colors.grey,);

    Navigator.pop(context);
  }
}