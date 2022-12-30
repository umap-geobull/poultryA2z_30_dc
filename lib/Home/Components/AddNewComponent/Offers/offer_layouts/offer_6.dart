
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../Utils/App_Apis.dart';
import '../../models/home_offer_details.dart';

import '../offer_products.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';


typedef OnGoToListCallBack =Function(String offerId);

class HomeOffer_6 extends StatefulWidget{
  OnGoToListCallBack onGoToListCallBack;
  String component_id;
  List<HomeOffers> offerList=[];
  String baseUrl;

  HomeOffer_6(this.component_id,this.offerList,this.baseUrl,this.onGoToListCallBack);

  @override
  _HomeOffer_6 createState() => _HomeOffer_6(component_id,offerList,baseUrl);
}

class _HomeOffer_6 extends State<HomeOffer_6> {
  _HomeOffer_6(this.component_id,this.offerList,this.baseUrl);

  String component_id;
  List<HomeOffers> offerList=[];
  late Route routes;
  String baseUrl;
  double slider_height=250;
  Color slider_color=Colors.transparent;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:slider_height,
      width: MediaQuery.of(context).size.width,
      child:offerList.isNotEmpty && offerList[0]!=null?
      GestureDetector(
        onTap: ()=>{showOfferProducts(offerList[0].id)},
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: slider_height,
              padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
              decoration: BoxDecoration(
                  color:slider_color
              ),
              child: sliderUi()
          )
      ):
          Container(
            color: Colors.grey[100],
          )
    );
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
        offerList.isNotEmpty?
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

    for(int i=0;i<offerList.length;i++){
      items.add(
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: slider_height,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: offerList[i].componentImage!=''?
                CachedNetworkImage(
                  fit: BoxFit.fill,
                  height: slider_height,
                  width: MediaQuery.of(context).size.width,
                  imageUrl: baseUrl+offer_image_base_url+offerList[i].componentImage,
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

  showOfferProducts(String id){
    widget.onGoToListCallBack(id);
    /*  Navigator.push(context, MaterialPageRoute(builder:
        (context) => Offer_Products(offer_id: id)));*/
  }

}

