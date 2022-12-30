
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../Utils/App_Apis.dart';
import '../../models/home_offer_details.dart';

import '../offer_products.dart';


typedef OnGoToListCallBack =Function(String offerId);

class HomeOffer_1 extends StatefulWidget{
  OnGoToListCallBack onGoToListCallBack;
  String component_id;
  List<HomeOffers> offerList=[];
  String baseUrl;

  HomeOffer_1(this.component_id,this.offerList,this.baseUrl,this.onGoToListCallBack);

  @override
  _HomeOffer_1 createState() => _HomeOffer_1(component_id,offerList,baseUrl);
}

class _HomeOffer_1 extends State<HomeOffer_1> {
  _HomeOffer_1(this.component_id,this.offerList,this.baseUrl);

  String component_id;
  List<HomeOffers> offerList=[];
  late Route routes;
  String baseUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: offerList.length<4?
      150: 300,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: offerList.length>8? 8:offerList.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white
          ),
          child: GestureDetector(
            onTap: ()=>{
              showOfferProducts(offerList[index].id)
            },
            child:
            Container(
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(5),
                  child:offerList[index].componentImage!=''?
                  CachedNetworkImage(
                    fit: BoxFit.fill,
                    height: 150,
                    imageUrl: baseUrl+offer_image_base_url+offerList[index].componentImage,
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
          ),
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 1/1.3
        ),
      ),
    );
  }

  showOfferProducts(String id){
    widget.onGoToListCallBack(id);
    /*  Navigator.push(context, MaterialPageRoute(builder:
        (context) => Offer_Products(offer_id: id)));*/
  }
}

