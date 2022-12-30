import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Sliders/edit_slider.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/home_slider_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:poultry_a2z/Home/Components/component_constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import '../../../../Utils/App_Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnDeleteCallBack =Function(String id);

class HomeSlider extends StatefulWidget{
  String component_id;
  bool isEditSwitched;
  OnDeleteCallBack onDeleteCallBack;
  double slider_height;
  Color slider_color;

  HomeSlider(this.component_id,this.isEditSwitched,this.onDeleteCallBack,this.slider_height,this.slider_color);

  @override
  _HomeSlider createState() => _HomeSlider(component_id,slider_height,slider_color);
}

class _HomeSlider extends State<HomeSlider> {
  _HomeSlider(this.component_id,this.slider_height,this.slider_color);

  String component_id;
  List<Content> sliderList=[];
  late GetHomeComponentList sliderDetails;
  bool isApiCallProcessing=false;

  double slider_height;
  Color slider_color;

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
      getSliderDetails();
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
  }

  showSliderEdit(String id) {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return EditSlider(onSavelistener,id);
        });
  }

  void onSavelistener(){
    Navigator.pop(context);
    getSliderDetails();
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
                  showSliderEdit(component_id)
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
            padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
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
            sliderUi()
        )
      ],
    );
  }

  void getSliderDetails() async {
    final body = {
      "component_auto_id": component_id,
      "component_type": SLIDER,
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

  sliderUi(){
    return Container(
      width: double.infinity,
      height: slider_height,
      padding: const EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
     /* decoration: BoxDecoration(
          color:slider_color
      ),*/
      //margin: EdgeInsets.only(bottom: 20),
      child:
      sliderList.isNotEmpty?
      ImageSlideshow(

        /// Width of the [ImageSlideshow].
        width: MediaQuery.of(context).size.width,

        /// Height of the [ImageSlideshow].
        height: slider_height,

        /// The page to show when first creating the [ImageSlideshow].
        initialPage: 0,

        /// The color to paint the indicator.
        indicatorColor: Colors.blue,

        /// The color to paint behind th indicator.
        indicatorBackgroundColor: Colors.grey,

        /// The widgets to display in the [ImageSlideshow].
        /// Add the sample image file into the images folder
        children: sliderItems(),

        /// Called whenever the page in the center of the viewport changes.
        onPageChanged: (value) {
        },

        /// Auto scroll interval.
        /// Do not auto scroll with null or 0.
        autoPlayInterval: 3000,

        /// Loops back to first slide.
        isLoop: true,
      ):
      SizedBox(
        width: double.infinity,
        height: slider_height,
        child: Center(
          child: ImageSlideshow(

              /// Width of the [ImageSlideshow].
              width: MediaQuery.of(context).size.width,

              /// Height of the [ImageSlideshow].
              height: slider_height,

              /// The page to show when first creating the [ImageSlideshow].
              initialPage: 0,

              /// The color to paint the indicator.
              indicatorColor: Colors.blue,

              /// The color to paint behind th indicator.
              indicatorBackgroundColor: Colors.grey,

              /// The widgets to display in the [ImageSlideshow].
              /// Add the sample image file into the images folder
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: slider_height,
                  margin: const EdgeInsets.symmetric(vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Text(
                      'Slider images not added'
                  ),
                )
              ],

              /// Called whenever the page in the center of the viewport changes.
              onPageChanged: (value) {
              },

              /// Auto scroll interval.
              /// Do not auto scroll with null or 0.
              autoPlayInterval: null,

              /// Loops back to first slide.
              isLoop: true,
            )
        ),
      )

    );
  }

  List<Widget> sliderItems(){
    List<Widget> items=[];

    for(int i=0;i<sliderList.length;i++){
      items.add(
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: slider_height,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: sliderList[i].componentImage!=''?
                CachedNetworkImage(
                  fit: BoxFit.fill,
                  height: slider_height,
                  width: MediaQuery.of(context).size.width,
                  imageUrl: baseUrl+home_slider_base_url+sliderList[i].componentImage,
                  placeholder: (context, url) =>
                      Container(decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[400],
                      )),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ):
                Container(
                    child:const Icon(Icons.error),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey[400],
                    )),
              )

          )
      );
    }

    return items;
  }

}

