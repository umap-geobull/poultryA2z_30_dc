// ignore: file_names
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/constants.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Brand/add_brand_ui.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Brand/edit_brand_ui.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Products/Choose_Main_Categories.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/models/all_brands_model.dart';
import 'package:poultry_a2z/Home/Components/component_constants.dart';
import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import '../../../../Utils/App_Apis.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getwidget/getwidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/home_product_model.dart';
import 'all_products_model.dart';


typedef OnSaveCallback =Function();

class SelectProducts extends StatefulWidget {

  OnSaveCallback onSaveCallback;
  String homecomponent_id;

  SelectProducts(this.onSaveCallback,this.homecomponent_id);

  @override
  _SelectProducts createState() => _SelectProducts();
}

class _SelectProducts extends State<SelectProducts> {

  List<String> selectedProducts=[];

  int iconStyle=100,layoutStyle=2;
  Color labelColor=Colors.grey,headerColor=Colors.black87;
  String labelFont='Lato',headerFont='Lato';
  double labelSize=12,headerSize=16;
  String headerTitle='';
  bool isApiCallProcessing=false;
  List<ProductModel> productList=[];
  late Route routes;

  TextStyle labelStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:12,
      fontWeight: FontWeight.normal,
      color: Colors.grey);

  TextStyle headerStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:16,
      fontWeight: FontWeight.normal,
      color: Colors.black87);

  bool isAddProcessing=false;


  String baseUrl='',admin_auto_id='',app_type_id='';
  String user_id='';

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');
    String? userId = prefs.getString('user_id');
    String? apptypeid= prefs.getString('app_type_id');

    if(baseUrl!=null && userId!=null && adminId!=null && apptypeid!=null){
      this.baseUrl=baseUrl;
      this.admin_auto_id=adminId;
      this.user_id=userId;
      this.app_type_id=apptypeid;

      setState(() {});

      if(mounted){
        setState(() {
          isApiCallProcessing=true;
        });
      }
      getDetails();
      getProducts();
    }

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

  void addHomeProducts() async {

    if(mounted){
      setState(() {
        isAddProcessing=true;
      });
    }
    String products='';

    for(int i=0;i<selectedProducts.length;i++){
      if(i==0){
        products+=selectedProducts[i];
      }
      else{
        products+='|'+selectedProducts[i];
      }
    }

    final body = {
      "product_auto_id": products,
      "home_component_auto_id": widget.homecomponent_id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    var url=baseUrl+'api/'+add_home_component_products;
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
  FutureOr onGoBack(dynamic value) {
    getProducts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: appBarIconColor,size: 20,),
          onPressed: onBackPressed,
        ),
        title: Text('Products ('+selectedProducts.length.toString()+')' ,
            style: const TextStyle(color:appBarIconColor,fontFamily:'Lato',fontSize: 16)),
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
                addHomeProducts()
              },
              child: const Text('Save',style: TextStyle(color:appBarIconColor,fontFamily:'Lato',fontSize: 16),)
          ),
          IconButton(
            onPressed: () {
              routes = MaterialPageRoute(builder: (context) => Choose_Main_Categories());
              Navigator.push(context, routes).then(onGoBack);
            },
            icon: Icon(Icons.add_circle_outline, color: appBarIconColor),
          )
        ],
      ),
      body:Container(
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height,
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: GridView(
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          childAspectRatio: 1/1.3
                        ),
                        children:productItems()
                    )
                )
            ),

            isApiCallProcessing==false && productList.isEmpty?
            Container(
              height:MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
              Container(

                  alignment: Alignment.center,
                  child:Text('No products available')
              ),
              Container(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                  ),
                  child: const Text('Add Products',style: TextStyle(color: Colors.black87,fontSize: 12),),
                  onPressed: () {
                    Route routes = MaterialPageRoute(builder: (context) => Choose_Main_Categories());
                    Navigator.push(context, routes);
                  },
                ),
                margin: const EdgeInsets.all(5),
              ),],)) :
            Container(),

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
      "component_type":PRODUCTS,
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
        HomeComponentProductDetails homeComponentProductDetails=HomeComponentProductDetails.fromJson(json.decode(response.body));
        List<ProductModel> selected =homeComponentProductDetails.getHomeComponentList[0].content;

        for (var element in selected) {
          selectedProducts.add(element.productAutoId);
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

  void getProducts() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    var url=baseUrl+'api/'+get_admin_products;
    var uri = Uri.parse(url);

    final body={
      "customer_auto_id": user_id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        AllProductsModel allProductsModel=AllProductsModel.fromJson(json.decode(response.body));
        productList=allProductsModel.getProductsLists;
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  setSelected(String id){
    if(isAdded(id) ==true){
      selectedProducts.remove(id);
    }
    else{
      selectedProducts.add(id);
    }

    setState(() {});
  }

  productItems(){
    List<Widget> items=[];

    for(int index=0;index<productList.length;index++){
      items.add(
          GestureDetector(
            onTap: ()=>{
              setSelected(productList[index].productAutoId)
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: isAdded(productList[index].productAutoId)==true ?
                        Colors.blue  : Colors.grey,
                        width: 1
                    )
                ),
                margin: const EdgeInsets.all(5),
                child: Container(
                  margin: const EdgeInsets.all(1),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 7,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Stack(children: [
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                color: Colors.grey[100],
                                child: productList[index].productImages.isNotEmpty
                                    ? CachedNetworkImage(
                                  fit: BoxFit.contain,
                                  imageUrl: baseUrl+product_base_url +
                                      productList[index].productImages[0].productImage,
                                  placeholder: (context, url) => Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                      )),
                                  errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                                ) :
                                Container(
                                    child: const Icon(Icons.error),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                    ))
                            ),
                            /*   productList[index].offerData.isNotEmpty && productList[index].offerData[0].offer.isNotEmpty?
                              Container(
                                height: 15,
                                width: 45,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                ),
                                child:
                                Text(productList[index].offerData[0].offer + "% off",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 11),
                                ),
                              ):
                           */
                            productList[index].offerPercentage.isNotEmpty && productList[index].offerPercentage!="0"?
                            Container(
                              height: 15,
                              width: 45,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                              ),
                              child:
                              Text(productList[index].offerPercentage + "% off",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11),
                              ),
                            ):
                            Container(),
                            Container(
                              alignment: Alignment.topRight,
                              child:isAdded(productList[index].productAutoId)==true?
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.orange[300]
                                ),
                                child: Text(
                                  getIndex(productList[index].productAutoId,),
                                  style: const TextStyle(color: Colors.white,fontSize: 10),
                                ),
                              ):
                              Container(),
                            )

                          ]
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          productList[index].productName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 17,color: Colors.black87),
                                        ),
                                        margin: const EdgeInsets.only(right: 20),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      productList[index].offerPercentage.isNotEmpty && productList[index].offerPercentage!='' && productList[index].offerPercentage!='0'?Text(
                                        "₹" + productList[index].productPrice,
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                            decoration: TextDecoration.lineThrough),
                                      ):Text(''),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "₹" + productList[index].finalProductPrice.toString(),
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                          )
                      ),
                    ],
                  ),

                )
            ),
          )
      );
    }
    return items;
  }

  bool isAdded(String id){
    for(int i=0;i<selectedProducts.length;i++){
      if(selectedProducts[i]==id){
        return true;
      }
    }
    return false;
  }

  String getIndex(String id) {
    for(int i=0;i<selectedProducts.length;i++){
      if(selectedProducts[i]==id){
        return (i+1).toString();
      }
    }
    return "";
  }

}