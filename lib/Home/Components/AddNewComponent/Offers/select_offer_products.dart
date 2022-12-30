// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import '../../../../Utils/App_Apis.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Products/all_products_model.dart';


typedef OnSaveCallback =Function(List<String> productList);

class SelectOfferProducts extends StatefulWidget {
  //OnSaveCallback onSaveCallback;

  OnSaveCallback onSaveCallback;
  List<String> productList;

  SelectOfferProducts(this.onSaveCallback,this.productList);

  @override
  _SelectOfferProducts createState() => _SelectOfferProducts(productList);
}

class _SelectOfferProducts extends State<SelectOfferProducts> {

  List<String> selectedProducts=[];

  _SelectOfferProducts(this.selectedProducts);

  int iconStyle=100,layoutStyle=2;
  Color labelColor=Colors.grey,headerColor=Colors.black87;
  String labelFont='Lato',headerFont='Lato';
  double labelSize=12,headerSize=16;
  String headerTitle='';
  bool isApiCallProcessing=false;
  List<ProductModel> productList=[];

  TextStyle labelStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:12,
      fontWeight: FontWeight.normal,
      color: Colors.grey);

  TextStyle headerStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:16,
      fontWeight: FontWeight.normal,
      color: Colors.black87);

  bool isAddProcessing=false;


  String baseUrl='',admin_auto_id='',user_auto_id='',app_type_id='';

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');
    String? userId = prefs.getString('user_id');
    String? apptypeid= prefs.getString('app_type_id');

    if(baseUrl!=null && adminId!=null && userId!=null && apptypeid!=null){
      this.admin_auto_id=adminId;
      this.baseUrl=baseUrl;
      this.user_auto_id=userId;
      this.app_type_id=apptypeid;

      if(mounted){
        setState(() {});
      }
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

  void addProducts() async {

    String products='';

    for(int i=0;i<selectedProducts.length;i++){
      if(i==0){
        products+=selectedProducts[i];
      }
      else{
        products+='|'+selectedProducts[i];
      }
    }

    widget.onSaveCallback(selectedProducts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: appBarIconColor,size: 20,),
          onPressed: onBackPressed,
        ),
        title: Text('Products ('+selectedProducts.length.toString()+')' ,
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
                addProducts()
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
    var url=baseUrl+'api/'+get_admin_products;
    var uri = Uri.parse(url);

    final body = {
      "admin_auto_id":admin_auto_id,
      "customer_auto_id": user_auto_id,
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
                              productList[index].offerPercentage.isNotEmpty?
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
                                        Text(
                                          "₹" + productList[index].productPrice,
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                              decoration: TextDecoration.lineThrough),
                                        ),
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