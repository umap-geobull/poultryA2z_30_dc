// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/all_offers_model.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import '../../../../Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';


typedef OnSaveCallback =Function(int i,Offers selectedOffer);

class SelectOffers extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  int i;

  SelectOffers(this.onSaveCallback,this.i);

  @override
  _SelectOffers createState() => _SelectOffers();
}

class _SelectOffers extends State<SelectOffers> with TickerProviderStateMixin {
  bool isApiCallProcessing=false;
  String baseUrl='', admin_auto_id='',app_type_id='';
  List<Offers> offersList=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
  }

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');

    if(baseUrl!=null && userId!=null && adminId!=null && apptypeid!=null){
      if(this.mounted){
        this.admin_auto_id=adminId;
        this.baseUrl=baseUrl;
        this.app_type_id=apptypeid;
        getAllOffer();
      }
    }
  }

  onBackPressed() async{
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: appBarIconColor,size: 20,),
          onPressed: onBackPressed,
        ),
        title: const Text('Select Offer' ,
            style: TextStyle(color: appBarIconColor,fontFamily:'Lato',fontSize: 16)),
      ),

      body: Container(
        child:Stack(
          children: <Widget>[
            isApiCallProcessing==false?
                offersList.isNotEmpty?
            ListView.builder(
              itemCount: offersList.length,
                itemBuilder: (context, index) =>
                    Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            child: Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: ()=>{
                                    //selectedSlider=i,
                                    //getGalleryImage()
                                  },
                                  child:
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 300,
                                      child: ClipRRect(
                                       // borderRadius: BorderRadius.circular(5),
                                        child:offersList[index].componentImage!=''?
                                        CachedNetworkImage(
                                        //  fit: BoxFit.fill,
                                          height: 300,
                                          width: MediaQuery.of(context).size.width,
                                          imageUrl: baseUrl+offer_image_base_url+offersList[index].componentImage,
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
                              /*  Align(
                                  alignment: Alignment.topRight,
                                  child:Container(
                                    height: 25,
                                    width: 25,
                                    margin: EdgeInsets.all(2),
                                    alignment: Alignment.center,
                                    color: Colors.white,
                                    child: GestureDetector(
                                      child: Icon(Icons.delete_forever_sharp,color: Colors.black,),
                                      onTap: ()=>{
                                        showAlert(offersList[index].id)
                                      },
                                    ),
                                  ),
                                ),*/

                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                      width: 200,
                                      color: Colors.black38,
                                      padding: const EdgeInsets.all(10),
                                      child: offersList[index].offer.isNotEmpty?
                                      Text('Offer% : '+offersList[index].offer+'%',
                                        style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),):
                                      Text('Offer Off Price : Rs.'+offersList[index].price,
                                        style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)
                                  ),
                                ),

                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child:Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        widget.onSaveCallback(widget.i,offersList[index]);
                                      },
                                      child: const Text("Select",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 13)),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        primary: Colors.orange,
                                        onPrimary: Colors.orange,
                                        minimumSize: const Size(70, 30),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(2.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
            ):
            Container(
              alignment: Alignment.center,
              child: Text('No offers available'),
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
        ),
      )
    );
  }

  showAlert(String id) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: const Text('Are you sure?',style: TextStyle(color: Colors.black87),),
          content:Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    const Text('Do you want to delete this slider image',style: TextStyle(color: Colors.black54),),
                    const SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            child:
                            ElevatedButton(
                              onPressed: (){
                                deleteOfferApi(id);
                                Navigator.pop(context);
                              },
                              child: const Text("Yes",style: TextStyle(color: Colors.black54,fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green[200],
                                onPrimary: Colors.green,
                                minimumSize: const Size(70,30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )
                        ),
                        const SizedBox(width: 10,),
                        Container(
                            child: ElevatedButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              child: const Text("No",
                                  style: TextStyle(color: Colors.black54,fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue[200],
                                onPrimary: Colors.blue,
                                minimumSize: const Size(70,30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  Future deleteOfferApi(String id) async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "image_auto_id":id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    var url=baseUrl+'api/'+delete_offer_image;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        getAllOffer();
      }
    }
  }

  Future getAllOffer() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    var url=baseUrl+'api/'+get_all_offers;

    var uri = Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        AllOffers allOffers=AllOffers.fromJson(json.decode(response.body));

        offersList=allOffers.data;
      }
      else{
        offersList=[];
      }

      if(mounted){
        setState(() {});
      }
    }
    else if (response.statusCode == 500) {
      Fluttertoast.showToast(msg: 'Server error', backgroundColor: Colors.grey,);

      isApiCallProcessing=false;
      if(mounted){
        setState(() {});
      }
    }
  }
}

typedef OnchangeSelection =Function(List<String> selectedSubcategories);

