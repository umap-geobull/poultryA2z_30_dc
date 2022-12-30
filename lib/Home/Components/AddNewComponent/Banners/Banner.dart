import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/home_slider_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:poultry_a2z/Home/Components/component_constants.dart';
import 'package:http/http.dart' as http;
import '../../../../Utils/App_Apis.dart';
import 'edit_banner.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnDeleteCallBack =Function(String id);

class HomeBanner extends StatefulWidget{
  String component_id;
  bool isEditSwitched;
  OnDeleteCallBack onDeleteCallBack;
  double slider_height;
  Color slider_color;

  HomeBanner(this.component_id,this.isEditSwitched,this.onDeleteCallBack,this.slider_height,this.slider_color);

  @override
  _HomeBanner createState() => _HomeBanner(component_id,slider_height,slider_color);
}

class _HomeBanner extends State<HomeBanner> {
  _HomeBanner(this.component_id,this.slider_height,this.slider_color);

  String component_id;
  late GetHomeComponentList sliderDetails;
  bool isApiCallProcessing=false;

  double slider_height;
  Color slider_color;
  List<Content> sliderList=[];
  late Route routes;

  String baseUrl='',admin_auto_id='',user_id='',app_type_id='';

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');
    String? userId = prefs.getString('user_id');
    String? apptypeid= prefs.getString('app_type_id');
    if(baseUrl!=null && adminId!=null && userId!=null && apptypeid!=null){
      this.baseUrl=baseUrl;
      this.admin_auto_id=adminId;
      this.user_id=userId;
      this.app_type_id=apptypeid;
      setState(() {});
      getBannerDetails();
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
    return Column(
      children: <Widget>[
        widget.isEditSwitched==true?
        Container(
          alignment: Alignment.topCenter,
          child:Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: ()=>{
                  widget.onDeleteCallBack(component_id)
                },
                child: Container(
                  padding: const EdgeInsets.all(7),
                  child: const Icon(Icons.delete,color: Colors.redAccent,),
                ),
              ),
              GestureDetector(
                onTap: ()=>{
                  showBannerEdit(component_id)
                },
                child: Container(
                    padding: const EdgeInsets.all(7),
                    child: const Icon(Icons.edit,color: Colors.orange,)
                ),),
            ],
          ),
        ):
        Container(),


        Container(
            width: MediaQuery.of(context).size.width,
            height: slider_height,
            padding: const EdgeInsets.only(left: 2,right: 2,top: 10,bottom: 10),
            decoration: BoxDecoration(
                color:slider_color
            ),
            child: isApiCallProcessing?
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                //borderRadius: BorderRadius.circular(5)
              ),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: slider_height,
            ):
            sliderList.isNotEmpty?
            Container(
                width: double.infinity,
                height: slider_height,
                margin: const EdgeInsets.symmetric(vertical: 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child:  ClipRRect(
                 // borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    height: slider_height,
                    width: MediaQuery.of(context).size.width,
                    imageUrl: baseUrl+home_slider_base_url+sliderList[0].componentImage,
                    placeholder: (context, url) =>
                        Container(decoration: BoxDecoration(
                          //borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[400],
                        )),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  )

                )

            ):
            Container(
                width: double.infinity,
                height: slider_height,
                margin: const EdgeInsets.symmetric(vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
                alignment: Alignment.center,
                child:const Text('Banner image not added')
            )
        )
      ],
    );
  }

  void onSavelistener(){
    Navigator.pop(context);
    getBannerDetails();
  }

  showBannerEdit(String id) {
     return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return EditBanner(onSavelistener,id);
        });
  }

  void getBannerDetails() async {
    if(this.mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "component_auto_id": component_id,
      "component_type": BANNER,
      "admin_auto_id":admin_auto_id,
      "customer_auto_id":user_id,
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
        HomeSliderDetails homeSliderDetails=HomeSliderDetails.fromJson(json.decode(response.body));
        sliderDetails=homeSliderDetails.getHomeComponentList[0];
        sliderList=sliderDetails.content;

        if(sliderDetails.height.isNotEmpty){
          slider_height=double.tryParse(sliderDetails.height)!;
        }
        if(sliderDetails.backgroundColor.isNotEmpty){
          slider_color= Color(int.parse(sliderDetails.backgroundColor));
        }

        if(mounted){
          setState(() {});
        }
      }
    }
  }

}

