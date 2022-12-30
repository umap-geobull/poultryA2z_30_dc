// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/constants.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Brand/add_brand_ui.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Brand/edit_brand_ui.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/all_brands_model.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/home_brands_detail.dart';
import 'package:poultry_a2z/Home/Components/component_constants.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import '../../../../Utils/App_Apis.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getwidget/getwidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


typedef OnSaveCallback =Function();

class SelectBrands extends StatefulWidget {
  //OnSaveCallback onSaveCallback;

  OnSaveCallback onSaveCallback;
  String homecomponent_id;

  SelectBrands(this.onSaveCallback,this.homecomponent_id);

  @override
  _SelectBrands createState() => _SelectBrands();
}

class _SelectBrands extends State<SelectBrands> {

  List<String> selectedBrands=[];

  int iconStyle=100,layoutStyle=2;
  Color labelColor=Colors.grey,headerColor=Colors.black87;
  String labelFont='Lato',headerFont='Lato';
  double labelSize=12,headerSize=16;
  String headerTitle='';
  bool isApiCallProcessing=false;
  List<GetBrandslist> brandsList=[];


  TextStyle labelStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:12,
      fontWeight: FontWeight.normal,
      color: Colors.grey);

  TextStyle headerStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:16,
      fontWeight: FontWeight.normal,
      color: Colors.black87);

  bool isAddProcessing=false;


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
      getDetails();
      getBrands();    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
  }

  onBackPressed() async{
    Navigator.pop(context);
  }

  void addHomeBrands() async {

    if(mounted){
      setState(() {
        isAddProcessing=true;
      });
    }
    String brands='';

    for(int i=0;i<selectedBrands.length;i++){
      if(i==0){
        brands+=selectedBrands[i];
      }
      else{
        brands+='|'+selectedBrands[i];
      }
    }

    final body = {
      "brand_auto_id": brands,
      "home_component_auto_id": widget.homecomponent_id,
      "admin_auto_id": admin_auto_id,
      "app_type_id": app_type_id,
    };

    var url=baseUrl+'api/'+add_home_component_brands;
    var uri = Uri.parse(url);
    final response = await http.post(uri,body: body);
    if (response.statusCode == 200) {
      isAddProcessing=false;

      final resp=jsonDecode(response.body);
      String status=resp['status'];
      if(status=="1"){
        widget.onSaveCallback();
      }
      else{
        isAddProcessing=false;
        Fluttertoast.showToast(msg: "Something went wrong. Please try later", backgroundColor: Colors.grey,);
        if(mounted){
          setState(() {});
        }
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color:appBarIconColor,size: 20,),
          onPressed: onBackPressed,
        ),
        title: Text('Brands ('+selectedBrands.length.toString()+'/16)' ,
            style: const TextStyle(color: appBarIconColor,fontFamily:'Lato',fontSize: 16)),
        actions: [
          isAddProcessing==true?
          const SizedBox(
            width: 80,
            child: GFLoader(
                type:GFLoaderType.circle
            ),
          ):
          TextButton(
              onPressed: ()=>{
                addHomeBrands()
              },
              child: const Text('Save',style: TextStyle(color: appBarIconColor,fontFamily:'Lato',fontSize: 16),)
          )
        ],
      ),
      body:Container(
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height,
                child:
                SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 4,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        physics: const ClampingScrollPhysics(),
                        //scrollDirection: Axis.horizontal,
                        children:brandItems()
                    )
                )
            ),

            isApiCallProcessing==true?
            Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: const GFLoader(
                  type:GFLoaderType.circle
              ) ,
            ) :
            Container()
          ],
        ),
      )
    );
  }

  Future getDetails() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "component_auto_id":widget.homecomponent_id,
      "component_type":SHOP_BY_BRANDS,
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
        HomeBrandDetails homeBrandDetails=HomeBrandDetails.fromJson(json.decode(response.body));
        List<Content> selected=homeBrandDetails.getHomeComponentList[0].content;

        for (var element in selected) {
          selectedBrands.add(element.brandAutoId);
        }

        if(mounted){
          setState(() {});
        }
      }
    }
  }

  showShimmer(){
    GFShimmer(
      child: const Text(
        'GF Shimmer',
        style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700),
      ),
      showGradient: true,
      gradient: LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.centerLeft,
        stops: const <double>[0, 0.3, 0.6, 0.9, 1],
        colors: [
          Colors.teal.withOpacity(0.1),
          Colors.teal.withOpacity(0.3),
          Colors.teal.withOpacity(0.5),
          Colors.teal.withOpacity(0.7),
          Colors.teal.withOpacity(0.9),
        ],
      ),
    );
  }

  void getBrands() async {
    var url=baseUrl+'api/'+get_brand_list;
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
        AllBrandsModel allBrandsModel=AllBrandsModel.fromJson(json.decode(response.body));
        brandsList=allBrandsModel.getBrandslist;

        print(brandsList.toString());
        setState(() {});
      }
    }
  }

  setSelected(String id){
    if(isAdded(id) ==true){
      selectedBrands.remove(id);
    }
    else{
      if(selectedBrands.length<16){
        selectedBrands.add(id);
      }
      else{
        Fluttertoast.showToast(msg: "Maximum 16 brands can be selected", backgroundColor: Colors.grey,);
      }
    }

    setState(() {});
  }

  brandItems(){
    List<Widget> items=[];

    items.add(
        GestureDetector(
            onTap: ()=>{
              showAddBrand()
            },
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black12
                    ),
                    margin: const EdgeInsets.all(5),
                    height: 60,
                    width: 60,
                    child:const Icon(Icons.add,color: Colors.black87,))
              ],
            )
        )
    );

    for(int index=0;index<brandsList.length;index++){
      items.add(
          GestureDetector(
            onLongPress: ()=>{
              showEditBrand(brandsList[index])
            },
              onTap: ()=>{
                setSelected(brandsList[index].id)
              },
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: isAdded(brandsList[index].id)==true ? Colors.blue  : Colors.grey,
                              width: 1
                          )
                      ),
                      margin: const EdgeInsets.all(5),
                      height: 60,
                      width: 60,
                      child:Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child:
                            brandsList[index].brandImageApp.isNotEmpty?
                            CachedNetworkImage(
                              fit: BoxFit.fill,
                              height: 60,
                              width: 60,
                              imageUrl: baseUrl+brands_base_url+brandsList[index].brandImageApp,
                              placeholder: (context, url) =>
                                  Container(decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.grey[400],
                                  )),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ):
                            Container(
                                child:const Icon(Icons.error),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.grey[400],
                                )),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child:isAdded(brandsList[index].id)==true?
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.orange[300]
                              ),
                              child: Text(
                                getIndex(brandsList[index].id,),
                                style: const TextStyle(color: Colors.white,fontSize: 10),
                              ),
                            ):
                            Container(),
                          )
                        ],
                      )),
                  Text(
                    brandsList[index].brandName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.black87,fontSize: 11),
                  )
                ],
              )
          )
      );
    }
    return items;
  }

  showAddBrand() {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return AddBrand(onAddListener);
        });
  }

  showEditBrand(GetBrandslist brand) {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return EditBrand(onAddListener,brand);
        });
  }

  onAddListener(){
    Navigator.pop(context);
    getBrands();
  }

  bool isAdded(String id){
    for(int i=0;i<selectedBrands.length;i++){
      if(selectedBrands[i]==id){
        return true;
      }
    }
    return false;
  }

  String getIndex(String id) {
    for(int i=0;i<selectedBrands.length;i++){
      if(selectedBrands[i]==id){
        return (i+1).toString();
      }
    }
    return "";
  }

}