
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../Utils/App_Apis.dart';
import '../../models/home_offer_details.dart';

import '../offer_products.dart';


typedef OnGoToListCallBack =Function(String offerId);

class HomeOffer_4 extends StatefulWidget{
  OnGoToListCallBack onGoToListCallBack;
  String component_id;
  List<HomeOffers> offerList=[];
  String baseUrl;

  HomeOffer_4(this.component_id,this.offerList,this.baseUrl,this.onGoToListCallBack);

  @override
  _HomeOffer_4 createState() => _HomeOffer_4(component_id,offerList,baseUrl);
}

class _HomeOffer_4 extends State<HomeOffer_4> {
  _HomeOffer_4(this.component_id,this.offerList,this.baseUrl);

  String component_id;
  List<HomeOffers> offerList=[];
  late Route routes;
  String baseUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:100,
      width: MediaQuery.of(context).size.width,
      child:offerList.isNotEmpty && offerList[0]!=null?
      GestureDetector(
        onTap: ()=>{showOfferProducts(offerList[0].id)},
        child: Container(
            child:
            ClipRRect(
              // borderRadius: BorderRadius.circular(5),
              child:offerList[0].componentImage!=''?
              CachedNetworkImage(
                fit: BoxFit.fill,
                height: 150,
                imageUrl: baseUrl+offer_image_base_url+offerList[0].componentImage,
                placeholder: (context, url) =>
                    Container(decoration: BoxDecoration(
                      //borderRadius: BorderRadius.circular(5),
                      color: Colors.grey[400],
                    )),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ):
              Container(
                  child:const Icon(Icons.error),
                  decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(5),
                    color: Colors.grey[400],
                  )),
            )
        ),
      ):
          Container(
            color: Colors.grey[100],
          )
    );
  }

  showOfferProducts(String id){
    widget.onGoToListCallBack(id);
    /*  Navigator.push(context, MaterialPageRoute(builder:
        (context) => Offer_Products(offer_id: id)));*/
  }
}

