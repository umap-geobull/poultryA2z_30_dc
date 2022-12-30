// ignore: file_names
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/constants.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Offers/edit_offer_ui.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/home_offer_details.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import '../../../../Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';
import '../../MainCategories/main_category_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../component_constants.dart';
import 'add_offer_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

typedef OnSaveCallback =Function();

class OfferData{
  String offer="";
  String price="";
  String mainCategory="";
  String subcategory="";
  String brand="";
  File image;

  OfferData(this.image);
}

class SelectOffers extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String homecomponent_id;

  SelectOffers(this.onSaveCallback,this.homecomponent_id);

  @override
  _SelectOffers createState() => _SelectOffers(homecomponent_id);
}

class _SelectOffers extends State<SelectOffers> with TickerProviderStateMixin {
  bool isApiCallProcessing=false;
  bool isAddProcessing=false;
  String homecomponent_id;

  _SelectOffers(this.homecomponent_id);

  //List<File> selectedImages=[];

  List<OfferData> selectedOffers=[];

  final ImagePicker _picker = ImagePicker();
  List<GetmainCategorylist> mainCategoryList=[];
  List<String> selectedSubcategories=[];

  int selectedIndex=0;

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

  List<HomeOffers> offersList=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
  }

  onBackPressed() async{
    widget.onSaveCallback();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

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
        title: const Text('Offers' ,style: TextStyle(color: appBarIconColor,fontFamily:'Lato',fontSize: 16)),
        actions: [
          isAddProcessing==true?
          const SizedBox(
            width: 80,
            child: GFLoader(
                type:GFLoaderType.circle
            ),
          ):
          IconButton(
            visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
            onPressed: ()=>{
              //showAddOffer()
              getGalleryImage()
            },
            icon: const Icon(Icons.add_box_rounded,color: appBarIconColor,),
          )
        ],
      ),

      body: Container(
        child:Stack(
          children: <Widget>[
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
                                    showEditOffer(offersList[index])
                                  },
                                  child:
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 300,
                                      child: ClipRRect(
                                        // borderRadius: BorderRadius.circular(5),
                                        child:offersList[index].componentImage!=''?
                                        CachedNetworkImage(
                                          // fit: BoxFit.fill,
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
                                Align(
                                  alignment: Alignment.topRight,
                                  child:Container(
                                    height: 25,
                                    width: 25,
                                    margin: const EdgeInsets.all(2),
                                    alignment: Alignment.center,
                                    color: Colors.white,
                                    child: GestureDetector(
                                      child: const Icon(Icons.delete_forever_sharp,color: Colors.black,),
                                      onTap: ()=>{
                                        showAlert(offersList[index].id)
                                      },
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.black38,
                                      padding: const EdgeInsets.all(10),
                                      child: offersList[index].offer.isNotEmpty?
                                      Text('Offer% : '+offersList[index].offer+'%',
                                        style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),):
                                      Text('Offer Off Price : Rs.'+offersList[index].price,
                                        style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            isApiCallProcessing == false &&
                offersList.isEmpty? Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: const Text('No offers added'))
                : Container(),


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
        getOfferDetails();
      }
    }
    else if (response.statusCode == 500) {
      isApiCallProcessing=false;
      Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);

      if(this.mounted){
        setState(() {
        });
      }
    }
  }

  onChangeSelection(List<String> selectedSubcategories){
    this.selectedSubcategories=selectedSubcategories;
    if(mounted){
      setState(() {});
    }
  }

  Future getGalleryImage() async {
    var pickedFileList  = await _picker.pickMultiImage();

    if(pickedFileList!=null){
      for (var file in pickedFileList) {
        File selectedImg = File(file.path);
        selectedOffers.add(OfferData(selectedImg));
      }
    }

    if(mounted){
      setState(() {
      });
    }

    if(selectedOffers.isNotEmpty){
      showAddOffer();
    }
  }

 /* showAddOffer() {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return AddOffer(onAddListener,homecomponent_id,selectedOffers);
        });
  }*/

  showAddOffer(){
    Route routes = MaterialPageRoute(builder: (context) => AddOffer(onAddListener,homecomponent_id,selectedOffers));
    Navigator.push(context, routes);
  }

  showEditOffer(HomeOffers offersList){
    Route routes = MaterialPageRoute(builder: (context) => EditOfferUi(onAddListener,offersList));
    Navigator.push(context, routes);
  }

  onAddListener(){
    Navigator.pop(context);
    getOfferDetails();
  }

  Future getOfferDetails() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "component_auto_id":homecomponent_id,
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

        offersList=offerHomeComponetDetails.getHomeComponentList[0].content;

        if(mounted){
          setState(() {});
        }
      }
    }
  }

}

typedef OnchangeSelection =Function(List<String> selectedSubcategories);

