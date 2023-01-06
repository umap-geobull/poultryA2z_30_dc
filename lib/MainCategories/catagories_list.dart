import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Consultant/Model/consultant_result_model.dart';
import '../poultry_vendor/Vendor_details_with_edit.dart';
import 'package:getwidget/getwidget.dart';

class VendorCatagoriesList extends StatefulWidget {
  VendorCatagoriesList(
      {Key? key,
        required this.type,
        required this.main_cat_id,
      })
      : super(key: key);
  String type;
  String main_cat_id;

  @override
  State<VendorCatagoriesList> createState() => _VendorCatagoriesListState();
}

class _VendorCatagoriesListState extends State<VendorCatagoriesList> {
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;
  Color bottomBarColor=Colors.white, bottomMenuIconColor=Color(0xFFFF7643);
  bool isInitialApiCallProcessing=true,isServerError=false,isApiCallProcessing=false;

  String user_id = '';
  String baseUrl='';
  String userType='';

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
      //getHomeComponents();
    }
  }

  void getappUi() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? appBarColor =prefs.getString('appbarColor');
    String? appbarIcon =prefs.getString('appbarIconColor');

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text('Vendor List' ,style: TextStyle(color: appBarIconColor)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: appBarIconColor,size: 20,),
            onPressed: ()=>{Navigator.of(context).pop()},
          ),

      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height/1.15,
                padding: const EdgeInsets.only(top: 10),
                margin: EdgeInsets.only(left: 15,right: 15),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: vendorList.length,
                  itemBuilder: (context, index) =>
                      InkWell(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => VendorDetailsWithEdit("")));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height/3,
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
                                        child: Image.asset(vendorList[index].image, fit: BoxFit.fill,),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child:  Padding(
                                        padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                        child: Text(vendorList[index].name,
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
                                                Flexible(child: Text("Supplier: "+vendorList[index].supplier))
                                              ],
                                            ),
                                          )
                                      )),


                                  Padding(
                                    padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                    child: Row(
                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        // Icon(Icons.location_on, color: kMainColor,size: 20,),
                                        // SizedBox(width: 5,),
                                        Flexible(child: Text("Price: "+vendorList[index].minMaxPrice)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              width: 80,
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
                                            SizedBox(width: 10,),
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
                                      Share.share("${vendorList[index].name} \n\n Supplier: ${vendorList[index].supplier}\n\n Min-Max Price: ${vendorList[index].minMaxPrice}");
                                    },
                                    child: Container(
                                      height: 30,
                                      alignment: Alignment.center,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.55),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      child:   const Icon(
                                        Icons.share,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],),
                            ],),
                          ),
                        ),
                      ),
                )
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
      ));
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
    return Container(
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
}
