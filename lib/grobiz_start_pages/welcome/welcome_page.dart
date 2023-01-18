import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poultry_a2z/Utils/AppConfig.dart';
import 'package:poultry_a2z/grobiz_start_pages/welcome/countries.dart';
import 'package:poultry_a2z/grobiz_start_pages/welcome/country_picker.dart';
import 'package:poultry_a2z/grobiz_start_pages/welcome/phone_field.dart';
import 'package:poultry_a2z/grobiz_start_pages/welcome/type_app_base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Home/Home_Screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import '../../Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'app_base_list_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:location/location.dart' as location_permission;


class WelcomePage extends StatefulWidget {

  @override
  _WelcomePage createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {

  TextEditingController _appTypeController=new TextEditingController();
  TextEditingController _businessNameController=new TextEditingController();
  TextEditingController _mobileController=new TextEditingController();

  String baseUrl='';
  String user_id='';

  int screenType=1;

  bool showOthers=true;
  bool loadLast=false;
  bool locationservicedenied=false;

  location_permission.Location location = new location_permission.Location();

  bool showAllApptypes=false,showSelectedAppTypes=false;

  bool showSendBusinessName=false;
  bool showSendAppType=false,showSendCountry=false,showSendCity=false,showSaveMobile=false;
  bool _showMobileNo=false,_showCountry=false,showSave=false;

  String businessName='',appType='',appTypeId='',category_id='';
  String country_code = '', phone_code='',mobile_number='';

  String? country_name='India';
  String? stateValue;
  String? cityValue;
  String? address;

  ScrollController _scrollController = ScrollController();

 // List<String> allAppTypes=['Amazon','Flipcart','Myntra','Licious','Groffers','JioMart','Ajio','Clovia','Big Basket'];

  //List<String> ecomAppTypes=['Amazon','Flipcart','Myntra','Ajio'];

  int selectedFromTypes=-1;
  int selectedFromAll=-1;
  bool otherSelected=false;

  //id is used for other apptype
  String multicategory_id='6332f92602ab8d5e9c294602';

  FocusNode _focus = FocusNode();
  bool isLocationAllowed=false,isLocationPermissionChecked=false;

  //bool isTypeApiCallProcessing=false;
  bool isAllApiCallProcessing=false,isPreferceApiProcessing=false;

  List<AllAppData> allAppTypes=[];
  List<AppBaseData> ecomAppTypes=[];
  late AssetsAudioPlayer audioPlayer;

  bool isTypeDataAvailable=false;

  bool isGetTypeAppApiProcessing=false;

 // late List<Country> _countryList;
  Country? _selectedCountry;
  late List<Country> filteredCountries;
  late String number;

  String? validatorMessage;

  List<String?> _cities = [];
  List<String?> _country = [];
  List<String?> _states = [];

 /* String _selectedCity = 'City';
  String _selectedState = 'State';
 */
  var responses;

  late List<Country> countryList;

  playSendSound() async {

    FlutterBeep.beep();

   // var soundId = (Platform.isAndroid) ? 24 : 1200;
   // FlutterBeep.playSysSound(soundId);

    // print('in send');

/*    await audioPlayer.open(
      Audio(
        'assets/sound_send.mp3',
      ),
    );*/
  }

  playReceiveSound() async {
    Future.delayed(Duration.zero, () {
      audioPlayer.open(
        Audio(
          'assets/sound_receive.mp3',
        ),
      );
    });
  }

  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    audioPlayer.dispose();
  }

  void _onFocusChange() {
    if(isLocationAllowed==false && isLocationPermissionChecked==false && locationservicedenied==false){
      _getCurrentLocation();
    }
    debugPrint("Focus: ${_focus.hasFocus.toString()}");
  }

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    //String? appName =prefs.getString('app_name');
    String? user_id =prefs.getString('user_id');

    if(user_id!=null){
      if(this.mounted){
        setState(() {
          this.user_id=user_id;
          //print (user_id);
        });
      }
    }

    if(baseUrl!=null){
      if(this.mounted){
        setState(() {
          this.baseUrl=baseUrl;
         // print (baseUrl);
        });
      }
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    countryList = countries;
    // getCountries();

    audioPlayer = AssetsAudioPlayer();

    playReceiveSound();

    _focus.addListener(_onFocusChange);

    _appTypeController.text='I want to build ';
    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child:SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        height: 200,
                        child: Image.asset('assets/welcome_bot.gif'),
                      ),
                    ),

                    firstScreen(),

                    businessName.isNotEmpty?
                    secondScreen():
                    Container(),

                    isGetTypeAppApiProcessing==true?
                    Container(
                      margin: EdgeInsets.only(top: 50,bottom: 10),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: GFLoader(type: GFLoaderType.circle),
                    ) :
                    isGetTypeAppApiProcessing==false && appType.isNotEmpty?
                    ecomAppTypes.length==0?
                    appTypeNotAvailable():
                    thirdScreen():
                    Container(),

                    /*  appType.isNotEmpty && isTypeDataAvailable==true?
                  thirdScreen():
                  Container(),*/

                    showAllApptypes==true && ecomAppTypes.isEmpty?
                    fourthScreen():
                    Container(),

                    _showMobileNo==true?
                    mobileScreen():
                    Container(),

                    _showCountry==true?
                    Container(
                      margin: EdgeInsets.only(top: 15,left: 1,right: 1),
                      child: CSCPicker(
                        ///Enable disable state dropdown [OPTIONAL PARAMETER]
                        showStates: true,
                        /// Enable disable city drop down [OPTIONAL PARAMETER]
                        showCities: true,

                        ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                        flagState: CountryFlag.DISABLE,

                        ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                        dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                            border:
                            Border.all(color: Colors.grey.shade300, width: 1)),

                        ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                        disabledDropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            //color: Colors.grey.shade300,
                            color: Colors.white,
                            border:
                            Border.all(color: Colors.grey.shade300, width: 1)),

                        ///placeholders for dropdown search field
                        countrySearchPlaceholder: "Country",
                        stateSearchPlaceholder: "State",
                        citySearchPlaceholder: "City",

                        ///labels for dropdown
                        countryDropdownLabel: "Select Country",
                        stateDropdownLabel: "Select State",
                        cityDropdownLabel: "Select City",

                        currentCountry: country_name,
                        currentState: stateValue,
                        currentCity: cityValue,
                        selectedItemStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),

                        ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                        dropdownHeadingStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),

                        ///DropdownDialog Item style [OPTIONAL PARAMETER]
                        dropdownItemStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),

                        ///Dialog box radius [OPTIONAL PARAMETER]
                        dropdownDialogRadius: 10.0,

                        ///Search bar radius [OPTIONAL PARAMETER]
                        searchBarRadius: 10.0,

                        ///triggers once country selected in dropdown
                        onCountryChanged: (value) {
                          print('country '+value);
                          setState(() {
                            country_name = value;
                          });
                        },

                        ///triggers once state selected in dropdown
                        onStateChanged: (value) {
                          print('state '+value!);
                          setState(() {
                            ///store value in state variable
                            stateValue = value;
                          });
                        },

                        ///triggers once city selected in dropdown
                        onCityChanged: (value) {
                          print('city '+value!);
                          setState(() {
                            print("city"+value);
                            ///store value in city variable
                            cityValue = value;
                          });
                        },
                      ),
                    ):
                    Container(),

                    /*_showCountry == true?
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(child: countryDropdown()),

                              SizedBox(
                                width: 10.0,
                              ),

                              Expanded(child: stateDropdown())
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          cityDropdown()
                        ],
                      ),
                    ):
                    Container(),
*/
                    showSave==true?
                    saveScreen():
                    Container(),

                    loadLast==true?
                    lastScreen():
                    Container(),

                    SizedBox(height: 200,)

                  ],
                ),
              )
          )
      ),
    );
  }

  firstScreen(){
    return Container(
      alignment: Alignment.center,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 10,top: 20),
            child: Text('Welcome to Grobiz',
              style: TextStyle(color: Colors.orangeAccent,fontSize: 25,fontWeight: FontWeight.bold,fontFamily: 'Lato'),),
          ),

          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 40),
            child: Text('Lets help build your app',
              style: TextStyle(color: Colors.black87,fontSize: 16,fontWeight: FontWeight.bold),),
          ),

          Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text('Enter your business name',
                      style: TextStyle(color: Colors.black87,fontSize: 15),),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex:6,
                          child: Container(
                            height: 45,
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              child:
                              TextFormField(
                                onChanged: (value)=>{
                                  _showSendBusinessName()
                                },
                                controller: _businessNameController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                                    hintText: 'Please enter your business name here',

                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    )

                                ),
                                // style: AppTheme.form_field_text,
                                keyboardType: TextInputType.name,
                              ),
                            ),
                          ),
                        ),

                        showSendBusinessName==true?
                        Expanded(
                          flex:1,
                          child: Container(
                            margin: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orangeAccent
                            ),
                            padding: EdgeInsets.all(4),
                            child: IconButton(
                                onPressed: ()=>{
                                  playSendSound(),
                                  FocusManager.instance.primaryFocus?.unfocus(),
                                  saveBusinessName(),
                                },
                                icon: Image.asset('assets/send_message.png')
                            ),
                          ),
                        ):
                        Container()
                      ],
                    ),
                  )
                ],

              )
          ),
        ],
      ),
    );
  }

  _showSendBusinessName(){

    if(_businessNameController.text.isNotEmpty){
      if(this.mounted){
        setState(() {
          showSendBusinessName=true;
        });
      }
    }
    else{
      if(this.mounted){
        setState(() {
          showSendBusinessName=false;
        });
      }
    }
  }

  saveBusinessName(){
    if(this.mounted){
      setState(() {
        showSendBusinessName=false;
        businessName=_businessNameController.text;
        playReceiveSound();

      });
    }
  }

  secondScreen(){
    return Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10,top: 20),
              child: Text('Well, It sounds cool',
                style: TextStyle(color: Colors.orange,fontSize: 17,fontWeight: FontWeight.bold),),
            ),

            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text('Which kind of ecommerce app you want to build?',
                style: TextStyle(color: Colors.black87,fontSize: 15),),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text('(For reference. Amazon, Flipcart, Licious, Myntra etc)',
                style: TextStyle(color: Colors.black54,fontSize: 12),),
            ),

            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:6,
                    child: Container(
                      height: 45,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child:
                        TextFormField(
                          onChanged: (value)=>{
                            showAppType()
                          },
                          controller: _appTypeController,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                              hintText: 'Please enter your app type',

                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              )

                          ),
                          // style: AppTheme.form_field_text,
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ),
                  ),

                  showSendAppType==true?
                  Expanded(
                    flex:1,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orangeAccent
                      ),
                      padding: EdgeInsets.all(4),
                      child: IconButton(
                          onPressed: ()=>{
                            playSendSound(),
                            FocusManager.instance.primaryFocus?.unfocus(),
                            saveAppType()
                          },
                          icon: Image.asset('assets/send_message.png')
                      ),
                    ),
                  ):
                  Container()
                ],
              ),
            ),

          ],
        )
    );
  }

  showAppType(){
    if(this.mounted){
      setState(() {
        showSendAppType=true;
      });
    }
  }

  saveAppType(){
    if(this.mounted){
      setState(() {
        showSendAppType=false;
        appType=_appTypeController.text;
        isGetTypeAppApiProcessing=true;
        getTypeBaseApps(appType);
      });
    }
  }

  appTypeNotAvailable(){
    // loadData();
    return Container(
      margin: EdgeInsets.only(top: 50,bottom: 10),
      alignment: Alignment.center,
      child: Text('Sorry..No app found for entered type\nYou can try re-entering your app type'),
    );
  }

  thirdScreen(){
   // loadData();
    return Container(
      alignment: Alignment.center,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top:20,bottom: 10),
            child: Text('Hmm thats great idea',
              style: TextStyle(color: Colors.orange,fontSize: 17,fontWeight: FontWeight.bold),),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text('Let me suggest you few options to select from as a reference to better understand your idea',
              style: TextStyle(color: Colors.black87,fontSize: 15),),
          ),

          ecomAppTypes.isNotEmpty?
          Container(
              height: 125,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: ecomAppTypes.length,
                itemBuilder: (context, index) =>
                    GestureDetector(
                      onTap: ()=>{
                        showOthers=false,
                        otherSelected=false,
                        selectedFromAll=-1,
                        selectedFromTypes=index,
                        selectAppBase(ecomAppTypes[index].appName, ecomAppTypes[index].id,ecomAppTypes[index].category_id)
                      },
                      child: Container(
                        margin: EdgeInsets.all(3),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:selectedFromTypes==index?
                            Border.all(
                              width: 2,
                              color: Colors.green,
                            ):
                            Border.all(
                              width: 1,
                              color: Colors.orangeAccent,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          width: 115,
                          height:115,
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 50,
                                width: 50,
                                child: ecomAppTypes[index].appImage!=''?
                                CachedNetworkImage(
                                  height: 80,
                                  width: 80,
                                  imageUrl: app_base_type_base_url+ecomAppTypes[index].appImage,
                                  placeholder: (context, url) =>
                                      Container(decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.grey[400],
                                      )),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ):
                                Container(
                                  child:Icon(Icons.error),
                                ),
                              ),
                              SizedBox(height: 5,),
                              Text(ecomAppTypes[index].appName,style: TextStyle(color: Colors.black54,fontSize: 15),)
                            ],
                          )),
                    ),
              )
          ):
          Container(),

         /* isTypeApiCallProcessing==false &&ecomAppTypes.isEmpty?
          Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height:100,
                    child: Text('Sorry..No app found for entered type\n'),
                  ),
                ],
              )):
          Container(),
*/

          showOthers==true?
          Container(
            margin: EdgeInsets.only(top: 30,),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Text('Are these useful?',
                    style: TextStyle(color: Colors.black87,fontSize: 16,fontWeight: FontWeight.bold),),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 10),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            ecomAppTypes=[];

                            showAllAppType();
                            //showNext();
                          },
                          child: Container(
                            width: 100,
                            alignment: Alignment.center,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.orangeAccent,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 10),
                                    blurRadius: 50,
                                    color: Color(0xffEEEEEE)),
                              ],
                            ),
                            child: Text(
                              "No",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () {
                            // showNext();
                          },
                          child: Container(
                            width: 100,
                            alignment: Alignment.center,
                            height: 30,
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(10),
                              color: Colors.greenAccent,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 10),
                                    blurRadius: 50,
                                    color: Color(0xffEEEEEE)),
                              ],
                            ),
                            child: Text(
                              "Yes",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                      ],
                    )
                )
              ],
            ),
          ):
          Container()
        ],
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
        showOthers=false;
        showAllApptypes=true;
        getAllBaseApps();
      });
    }
  }

  fourthScreen(){
    return Container(
      alignment: Alignment.center,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top:40,bottom: 10),
            child: Text('No worries!!',
              style: TextStyle(color: Colors.orange,fontSize: 17,fontWeight: FontWeight.bold),),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Text('Lets try it, It may help you  ',
              style: TextStyle(color: Colors.black87,fontSize: 17),),
          ),

          isAllApiCallProcessing==true?
          Container(
            margin: EdgeInsets.only(top: 50,bottom: 50),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: GFLoader(type: GFLoaderType.circle),
          ) :
          allAppTypes.isNotEmpty?
          Container(
            height: 240,
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

        ],
      ),
    );
  }

  List<Widget> showAllAppBase(){
    List<Widget> appBase=[];

    appBase.add(
        GestureDetector(
          onTap: ()=>{
            playSendSound(),
            selectedFromTypes=-1,
            selectedFromAll=-1,
            otherSelected=true,
            selectAppBase('Other', "",multicategory_id)
          },
          child: Container(
              margin: EdgeInsets.all(3),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border:otherSelected==true?
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
              width: 115,
              height:115,
              child: Text('Other',style: TextStyle(color: Colors.black54,fontSize: 15),)),
        )
    );

    for(int index=0;index<allAppTypes.length;index++){
      appBase.add(GestureDetector(
        onTap: ()=>{
          playSendSound(),
          selectedFromTypes=-1,
          otherSelected=false,
          selectedFromAll=index,
          selectAppBase(allAppTypes[index].appName, allAppTypes[index].id,allAppTypes[index].category_id)
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
            width: 115,
            height:115,
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  child: allAppTypes[index].appImage!=''?
                  CachedNetworkImage(
                    height: 80,
                    width: 80,
                    imageUrl: app_base_type_base_url+allAppTypes[index].appImage,
                    placeholder: (context, url) =>
                        Container(decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey[400],
                        )),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ):
                  Container(
                    child:Icon(Icons.error),
                  ),
                ),
                SizedBox(height: 5,),
                Text(allAppTypes[index].appName,style: TextStyle(color: Colors.black54,fontSize: 15),)
              ],
            )),
      ));
    }
    return appBase;

  }

  selectAppBase(String app_type,String app_type_id,String category_Id){
    appType=app_type;
    appTypeId=app_type_id;
    category_id=category_Id;

    _showMobileNo=true;
   // loadLast=true;

    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.bounceIn);

    if(this.mounted){
      setState(() {
      });
    }

    playReceiveSound();
  }

  mobileScreen(){
    return Container(
      alignment: Alignment.center,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top:40,bottom: 20),
            child: Text('Please help us with following information to serve you better',
              style: TextStyle(color: Colors.orange,fontSize: 16,fontWeight: FontWeight.bold),),
          ),

          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text('Please enter country code & mobile number',
              style: TextStyle(color: Colors.black87,fontSize: 15),),
          ),

          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex:6,
                   child: IntlPhoneField(
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                            hintText: 'Please enter your mobile no',

                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            )

                        ),
                        onChanged: (mobile) {
                          showMobile();
                        },
                        focusNode: _focus,
                        initialCountryCode: country_code,
                        controller: _mobileController,
                        onCountryChanged: (country) {
                          setCountryChanged(country);
                        },
                      ),
                ),

                //showSaveMobile==true?
                Expanded(
                    flex:1,
                    child:
                    Container(
                      margin: EdgeInsets.only(left: 5,right: 5),
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orangeAccent
                      ),
                      padding: EdgeInsets.all(4),
                      child: IconButton(
                          onPressed: ()=>{
                            if(validations() == true){
                              playSendSound(),
                              FocusManager.instance.primaryFocus?.unfocus(),
                              saveMobile()
                            }
                          },
                          icon: Image.asset('assets/send_message.png')
                      ),
                    )
                )
                //Container()
              ],
            ),
          ),
        ],
      ),
    );
  }

  setCountryChanged(Country country){
    if(this.mounted){
      setState(() {
        if(_selectedCountry!= country){
          _showCountry = false;
        }
        _selectedCountry = country;
        country_code = country.code;
        phone_code = country.dialCode;
        country_name = country.name;

        print(_selectedCountry!.code);
        print(_selectedCountry!.dialCode);
        print(_selectedCountry!.minLength);
        print(_selectedCountry!.maxLength);
      });
    }
  }

  bool validations(){
    print(_mobileController.text.toString());

    if(country_code.isEmpty || phone_code.isEmpty){
      Fluttertoast.showToast(msg: 'Please select country code');
      return false;
    }
    else if(checkMobileValidations() == false){
      Fluttertoast.showToast(msg: 'Please enter valid mobile number');
      return false;
    }

    return true;
  }

  bool checkMobileValidations(){
    if(_selectedCountry!=null && _mobileController.text != null &&
        _mobileController.text.length >= _selectedCountry!.minLength &&
            _mobileController.text.length <= _selectedCountry!.maxLength ){

      print(_selectedCountry!.minLength.toString());
      print(_selectedCountry!.maxLength.toString());
      print(_mobileController.text.toString());
      return true;
    }

    return false;
  }

  showMobile(){
    if(this.mounted){
      setState(() {
        showSaveMobile=true;
      });
    }
  }

  saveMobile(){
    if(this.mounted){
      setState(() {
        //loadLast=true;
        _showCountry=true;
        showSave=true;
        showSaveMobile=false;
        mobile_number=_mobileController.text;
      });
    }
  }

  saveScreen(){
    return Container(
      alignment: Alignment.center,
      child:
      Container(
        margin: EdgeInsets.all(20),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        child:Column(
          children: <Widget>[
            isPreferceApiProcessing==true?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: GFLoader(type: GFLoaderType.circle),
            ) :
            Container(),

            loadLast==false && isPreferceApiProcessing==false?
            GestureDetector(
              onTap: () {
                if(country_code.isEmpty){
                  Fluttertoast.showToast(msg: 'Please select your country code', backgroundColor: Colors.grey,);
                }
                if(_mobileController.text.isEmpty){
                  Fluttertoast.showToast(msg: 'Please enter your mobile no.', backgroundColor: Colors.grey,);
                }
                else if(country_name!.isEmpty || country_name=='Country'){
                  Fluttertoast.showToast(msg: 'Please add country name', backgroundColor: Colors.grey,);
                }
               /* else if(stateValue!.isEmpty || stateValue=='State'){
                  Fluttertoast.showToast(msg: 'Please select your state name', backgroundColor: Colors.grey,);
                }
                else if(cityValue!.isEmpty || cityValue=='City'){
                  Fluttertoast.showToast(msg: 'Please select your city name', backgroundColor: Colors.grey,);
                }
               */
                else{
                  addUserPrferencesApi();
                }
              },
              child: Container(
                width: 200,
                alignment: Alignment.center,
                height: 40,
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orangeAccent,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 50,
                        color: Color(0xffEEEEEE)),
                  ],
                ),
                child: Text(
                  "Save Choices",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ) :
            Container(),
          ],
        )
      ),
    );
  }

  lastScreen(){
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text('Enjoy shaping your dream into reality',
              style: TextStyle(color: Colors.black87,fontSize: 17,fontWeight: FontWeight.bold),),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 40),
            child: Text('We wish you a great business  ',
              style: TextStyle(color: Colors.orange,fontSize: 17,fontWeight: FontWeight.bold),),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,

            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(HomeScreen.routeName, (Route<dynamic> route) => false);

              },
              child: Container(
                width: 200,
                alignment: Alignment.center,
                height: 40,
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orangeAccent,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 50,
                        color: Color(0xffEEEEEE)),
                  ],
                ),
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ) ,
          )

        ],
      ),
    );
  }

  _getCurrentLocation() async {
   // var googleGeocoding = GoogleGeocoding("Your-Key");

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();

        if (!serviceEnabled) {
          locationservicedenied = true;
          isLocationAllowed=false;
          isLocationPermissionChecked=true;
          return Future.error('Location services are disabled.');
        }
      }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if(this.mounted){
          isLocationAllowed=false;
          isLocationPermissionChecked=true;
          setState(() {});
        }
        return Future.error('Location permissions are denied');
      }

      else if (permission == LocationPermission.deniedForever) {
        if(this.mounted){
          isLocationAllowed=false;
          isLocationPermissionChecked=true;
          setState(() {});
        }
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      else{
        isLocationAllowed=true;
        isLocationPermissionChecked=true;

        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        if(position!=null){
          double latitude=position.latitude;
          double longitude=position.longitude;
          List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude,localeIdentifier: 'en',);
          if(placemarks!=null){
            print(placemarks.toString());
            String city=placemarks[0].locality.toString();
            if(city=="")
              {
                city=placemarks[0].subAdministrativeArea.toString();
              }
            String state=placemarks[0].administrativeArea.toString();
            String country=placemarks[0].country.toString();
            String countrycode=placemarks[0].isoCountryCode.toString();

            country_code=countrycode;

            print(country_code);
            print('IN');

            if(country_code=='IN'){
              phone_code='91';
            }
            country_name=country;
            stateValue=state;
            cityValue=city;

            countryList.forEach((element) {
              if(element.name == country_name){
                _selectedCountry = element;
              }
            });

            print(city);
            print(country);
            print(state);

            if(this.mounted){
              setState(() {
              });
            }
          }
        }
      }
    }

    else if (permission == LocationPermission.deniedForever) {
      if(this.mounted){
        setState(() {});
      }
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    else{
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      if(position!=null){
        double latitude=position.latitude;
        double longitude=position.longitude;

        List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude,localeIdentifier: 'en');
        print(placemarks.toString());
        if(placemarks!=null){
          String city=placemarks[0].locality.toString();
          if(city=="")
          {
            city=placemarks[0].subAdministrativeArea.toString();
          }
          String state=placemarks[0].administrativeArea.toString();
          String country=placemarks[0].country.toString();
          String countryCode=placemarks[0].isoCountryCode.toString();

          country_code=countryCode;

          if(country_code=='IN'){
            phone_code='91';
          }

          country_name=country;
          stateValue=state;
          cityValue=city;



          countryList.forEach((element) {
            if(element.name == country_name){
              _selectedCountry = element;
            }
          });

          print(city);
          print(country);
          print(state);

          if(this.mounted){
            setState(() {
            });
          }
        }
      }
    }
  }

  saveData() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('app_type', appType);
    prefs.setString('app_type_id',category_id);

    print("set");
}

  showSelection(){
    if(this.mounted){
      setState(() {
        showOthers=true;
      });
    }
  }

  showNext(){
    screenType=screenType+1;
    if(this.mounted){
      setState(() {});
    }
  }

  showPrevious(){
    if(screenType!=1){
      screenType=screenType-1;
    }
    else{
      Navigator.pop(context);
    }

    if(this.mounted){
      setState(() {});
    }
  }

  getAllBaseApps() async {
    if(this.mounted){
      setState(() {
        allAppTypes.clear();
        isAllApiCallProcessing=true;
      });
    }

    var url=AppConfig.grobizBaseUrl+get_all_app_base;

    var uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      isAllApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        AppBaseListModel appBaseListModel=AppBaseListModel.fromJson(json.decode(response.body));
        allAppTypes=appBaseListModel.allAppData;

        print('all apps'+allAppTypes.toString());

        if(this.mounted){
          setState(() {});
        }
        playReceiveSound();
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

  getTypeBaseApps(String type) async {

    String keyword=type.replaceAll('I want to build ', '');

/*
    if(this.mounted){
      setState(() {
        isTypeApiCallProcessing=true;
      });
    }
*/

    final body = {
      "type_keyword": keyword,
    };

    var url=AppConfig.grobizBaseUrl+get_app_base;

    //print(url);
    print(type);

    var uri = Uri.parse(url);
    final response = await http.post(uri,body: body);
    if (response.statusCode == 200) {
      //isTypeApiCallProcessing=false;
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        TypeAppBaseModel typeAppBaseModel=TypeAppBaseModel.fromJson(json.decode(response.body));
        ecomAppTypes=typeAppBaseModel.appBaseData;

        if(ecomAppTypes.length==0){
          if(this.mounted){
            setState(() {
              isGetTypeAppApiProcessing=false;
            });
          }
          showAllAppType();
        }
        else{
          if(this.mounted){
            setState(() {
              isGetTypeAppApiProcessing=false;
            });
          }
          playReceiveSound();
        }

        print(ecomAppTypes.toString());
      }
      else{
        ecomAppTypes=[];

        showAllAppType();

        if(this.mounted){
          setState(() {
            isGetTypeAppApiProcessing=false;
          });
        }
      }
    }

    else if(response.statusCode==500){
      //isTypeApiCallProcessing=false;

      if(this.mounted){
        setState(() {
          isGetTypeAppApiProcessing=false;
        });
      }
    }
  }

  addUserPrferencesApi() async {
    if(phone_code.isEmpty && country_code=='IN'){
      phone_code='91';
    }
    setState(() {
      isPreferceApiProcessing=true;
    });

    final body = {
      "user_auto_id":user_id,
      "app_name":businessName,
      "app_type":appType,
      "country_code":country_code+'-'+phone_code,
      "contact":_mobileController.text,
      //"country":_countryController.text,
      //"city":_cityController.text,
      "state" : stateValue== null? '' : stateValue,
      "country":country_name,
      "city":cityValue == null? '' : cityValue,
      "app_logo":'',
      "app_type_id":appTypeId,
      "category_id":category_id,
    };

    var url=AppConfig.grobizBaseUrl+add_customer_preferences;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      isPreferceApiProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];

      if(status==1){
        print('sign up success');
        if(this.mounted){
          setState(() {
            saveData();
            loadLast=true;
          });
        }

        playReceiveSound();
      }
      else {
        String msg=resp['msg'];
        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey,);
        if(this.mounted){
          setState(() {});
        }

        playReceiveSound();
      }
    }

    else if(response.statusCode==500){
      isPreferceApiProcessing=false;
      Fluttertoast.showToast(msg: "Server Error", backgroundColor: Colors.grey,);

      if(this.mounted){
        setState(() {});
      }
    }
  }

  Future<dynamic> getResponse() async {
    var res = await rootBundle
        .loadString('packages/csc_picker/lib/assets/country.json');
    return jsonDecode(res);
  }

  final CountryFlag flagState = CountryFlag.ENABLE;

}
