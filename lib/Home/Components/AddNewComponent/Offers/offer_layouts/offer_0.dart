
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Offers/offer_products.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../Utils/App_Apis.dart';
import '../../models/home_offer_details.dart';


typedef OnGoToListCallBack =Function(String offerId);

class HomeOffer_0 extends StatefulWidget{
  OnGoToListCallBack onGoToListCallBack;
  String component_id;
  List<HomeOffers> offerList=[];
  String baseUrl;

  HomeOffer_0(this.component_id,this.offerList,this.baseUrl,this.onGoToListCallBack);

  @override
  _HomeOffer_0 createState() => _HomeOffer_0(component_id,offerList,baseUrl);
}

class _HomeOffer_0 extends State<HomeOffer_0> {
  _HomeOffer_0(this.component_id,this.offerList,this.baseUrl);
  String component_id;
  List<HomeOffers> offerList=[];
  late Route routes;
  String baseUrl;
Color scrollbarColor=Colors.pinkAccent;
  final ScrollController _controllerOne = ScrollController();
  double scrollbarthickness=2;

  @override
  Widget build(BuildContext context) {
    print('offer '+offerList.length.toString());
    return SizedBox(
      height: 250,
      child:RawScrollbar(
        thickness: scrollbarthickness,
        thumbColor: scrollbarColor,
        trackColor: Colors.grey,
        trackRadius: Radius.circular(10),
        controller: _controllerOne,
        thumbVisibility: true,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: offerList.length,
            itemBuilder: (context, index) =>
                GestureDetector(
                  onTap: ()=>{
                    showOfferProducts(offerList[index].id)
                  },
                  child: Container(
                      margin: const EdgeInsets.all(5),
                      width: 190,
                      height: 250,
                      child: ClipRRect(
                        // borderRadius: BorderRadius.circular(5),
                        child:offerList[index].componentImage!=''?
                        CachedNetworkImage(
                          fit: BoxFit.fill,
                          height: 250,
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
                )
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

