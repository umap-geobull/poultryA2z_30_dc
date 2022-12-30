import 'dart:convert';
import 'package:poultry_a2z/Home/Components/AddNewComponent/get_title_alignment.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Offers/edit_offer.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Offers/offer_layouts/offer_0.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Offers/offer_layouts/offer_2.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Offers/select_offers.dart';
import 'package:poultry_a2z/Home/Components/component_constants.dart';
import 'package:http/http.dart' as http;
import '../../../../Utils/App_Apis.dart';
import '../models/home_offer_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'offer_layouts/offer_1.dart';
import 'offer_layouts/offer_3.dart';
import 'offer_layouts/offer_4.dart';
import 'offer_layouts/offer_5.dart';
import 'offer_layouts/offer_6.dart';

typedef OnDeleteCallBack =Function(String id);
typedef OnGoToListCallBack =Function(String type, String offerId);

class HomeOffer extends StatefulWidget{
  String component_id;
  bool isEditSwitched;
  OnDeleteCallBack onDeleteCallBack;
  OnGoToListCallBack goToListCallBack;

  HomeOffer(this.component_id,this.isEditSwitched,this.onDeleteCallBack,this.goToListCallBack);

  @override
  _HomeOffer createState() => _HomeOffer(component_id);
}

class _HomeOffer extends State<HomeOffer> {
  _HomeOffer(this.component_id);

  String component_id;
  late GetHomeComponentList offerDetails;
  String app_layout='';

  bool isApiCallProcessing=false;

  Color slider_color=Colors.transparent,backgroundColor=Colors.white,
      title_backgroundColor=Colors.transparent;

  Alignment titleAlignment = Alignment.centerLeft;

  List<HomeOffers> offerList=[];
  late Route routes;

  TextStyle labelStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:12,
      fontWeight: FontWeight.normal,
      color: Colors.grey);

  TextStyle headerStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:15,
      fontWeight: FontWeight.normal,
      color: Colors.black87);

  String appLabelFont = 'Lato',appHeaderFont='Lato',headerTitle='';
  Color appLabelColor=const Color(0xff443a49),appHeaderColor=Colors.black87;
  double appFontSize=15;


  String baseUrl='',admin_auto_id='',userId='',app_type_id='';

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');
    String? userId = prefs.getString('user_id');
    String? apptypeid= prefs.getString('app_type_id');

    if(baseUrl!=null && adminId!=null && userId!=null && apptypeid!=null){
      this.baseUrl=baseUrl;
      this.admin_auto_id=adminId;
      this.userId=userId;
      this.app_type_id=apptypeid;
      setState(() {});
      getOfferDetails();
    }
  }

  String title='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: 30),
                alignment: titleAlignment,
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: title_backgroundColor,
                  child: Text(title,style: headerStyle,),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    widget.isEditSwitched==true?
                    GestureDetector(
                      onTap: ()=>{
                        widget.onDeleteCallBack(component_id)
                      },
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        child: const Icon(Icons.delete,color: Colors.redAccent,),
                      ),
                    ):
                    Container(),

                    widget.isEditSwitched==true?
                    GestureDetector(
                      onTap: ()=>{
                        showOfferEdit(component_id)
                      },
                      child: Container(
                          padding: const EdgeInsets.all(7),
                          child: const Icon(Icons.edit,color: Colors.orange,)
                      ),):
                    Container(),

                    widget.isEditSwitched==true?
                    GestureDetector(
                      onTap: ()=>{
                        showAddCategory()
                      },
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        child: const Icon(Icons.add_box_rounded,color: Colors.blue,),
                      ),
                    ):
                    Container(),
                  ],
                )
              )
            ],
          ),

          Container(
            padding: EdgeInsets.only(top: 5,bottom: 5),
            child: offerList.isNotEmpty?
            showOffer():
            Container(
              height: 200,
              color: Colors.grey[300],
            ),
          )
        ],
      ),
    );
  }

  showOffer(){
    if(app_layout=='0'){
      return HomeOffer_0(component_id, offerList, baseUrl,goToNextScreen);
    }
    else if(app_layout=='1'){
      return HomeOffer_1(component_id, offerList, baseUrl,goToNextScreen);
    }
    else if(app_layout=='2'){
      return HomeOffer_2(component_id, offerList, baseUrl,goToNextScreen);
    }
    else if(app_layout=='3'){
      return HomeOffer_3(component_id, offerList, baseUrl,goToNextScreen);
    }
    else if(app_layout=='4'){
      return HomeOffer_4(component_id, offerList, baseUrl,goToNextScreen);
    }
    else if(app_layout=='5'){
      return HomeOffer_5(component_id, offerList, baseUrl,goToNextScreen);
    }
    else if(app_layout=='6'){
      return HomeOffer_6(component_id, offerList, baseUrl,goToNextScreen);
    }
    else{
      return Container(
        height: 200,
        color: Colors.grey[300],
      );
    }
  }

  goToNextScreen(String id){
    widget.goToListCallBack("offer",id);
  }

  void onSavelistener(){
    Navigator.pop(context);
    getOfferDetails();
  }

  showAddCategory(){
    routes = MaterialPageRoute(builder: (context) => SelectOffers(onSavelistener,component_id));
    Navigator.push(context, routes);
  }

  showOfferEdit(String id) {
      routes = MaterialPageRoute(builder: (context) => EditOffer(onSavelistener,component_id));
      Navigator.push(context, routes);
  }

  Future getOfferDetails() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "component_auto_id":component_id,
      "component_type":OFFERS,
      "admin_auto_id":admin_auto_id,
      "customer_auto_id":userId,
      "app_type_id": app_type_id,
    };

    var url=baseUrl+'api/'+get_home_component_details;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        OfferHomeComponetDetails offerHomeComponetDetails=OfferHomeComponetDetails.fromJson(json.decode(response.body));

        offerDetails=offerHomeComponetDetails.getHomeComponentList[0];
        offerList=offerHomeComponetDetails.getHomeComponentList[0].content;

        app_layout=offerDetails.layoutType;
        title=offerDetails.title;

        if(offerHomeComponetDetails.getHomeComponentList[0].titleFont.isNotEmpty){
          appHeaderFont=offerHomeComponetDetails.getHomeComponentList[0].titleFont;
        }
        if(offerHomeComponetDetails.getHomeComponentList[0].titleColor.isNotEmpty){
          appHeaderColor=Color(int.parse(offerHomeComponetDetails.getHomeComponentList[0].titleColor));
        }
        if(offerHomeComponetDetails.getHomeComponentList[0].backgroundColor.isNotEmpty){
          backgroundColor=Color(int.parse(offerHomeComponetDetails.getHomeComponentList[0].backgroundColor));
        }

        if(offerHomeComponetDetails.getHomeComponentList[0].titleBackground.isNotEmpty){
          title_backgroundColor=Color(int.parse(offerHomeComponetDetails.getHomeComponentList[0].titleBackground));
        }

        if(offerHomeComponetDetails.getHomeComponentList[0].titleAlignment.isNotEmpty){
          titleAlignment=GetAlignement.getTitleAlignment(offerHomeComponetDetails.getHomeComponentList[0].titleAlignment);
        }

        headerStyle= GoogleFonts.getFont(appHeaderFont).copyWith(
            fontSize:appFontSize,
            fontWeight: FontWeight.normal,
            color: appHeaderColor);

        if(this.mounted){
          setState(() {});
        }
      }
    }
  }

}

