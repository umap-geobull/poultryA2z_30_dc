// ignore: file_names
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/get_title_alignment.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../../Admin_add_Product/Components/Model/size_model.dart';
import '../../../../Admin_add_Product/constants.dart';
import '../../../../Cart/model/cart_count_model.dart';
import '../../../../Product_Details/Product_List_User.dart';
import '../../../../Product_Details/model/Product_Model.dart';
import '../../../../Product_Details/product_details_screen.dart';
import '../../../../Product_Details/select_prod_size_bottomsheet.dart';
import '../../../../Utils/App_Apis.dart';
import '../../component_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'RecommendedProductsList.dart';
import 'Recommended_HomeModel.dart';
import 'Recommended_ListModel.dart';
import 'edit_recommendedproducts.dart';
import 'package:fluttertoast/fluttertoast.dart';


typedef OnDeleteCallBack =Function(String id);
typedef OnAddToCartCallBack =Function();

class RecommendedNew extends StatefulWidget {
  bool iseditSwitched;
  OnDeleteCallBack onDeleteCallBack;
  String component_id;
  String user_type;
  List<GetAdminCartProductLists> getAdminCartProductLists;
  OnAddToCartCallBack onAddToCartCallBack;
  String iconType;
  String layoutType;


  RecommendedNew(this.iseditSwitched, this.onDeleteCallBack,this.component_id,this.user_type,
      this.getAdminCartProductLists,this.onAddToCartCallBack,this.iconType,this.layoutType);

  @override
  _RecommendedNew createState() => _RecommendedNew(iseditSwitched,component_id,iconType,layoutType);
}

class _RecommendedNew extends State<RecommendedNew> {
  String iconType;
  String layoutType;

  bool iseditSwitched;
  String component_id;
  String user_id='';
  List<ProductModel> recommended_products=[];

  _RecommendedNew(this.iseditSwitched,this.component_id,this.iconType,this.layoutType);

  bool isApiCallProcessing=false;

  TextStyle headerStyle= GoogleFonts.getFont('Lato').copyWith(
      fontSize:16,
      fontWeight: FontWeight.normal,
      color: Colors.black87);

  late Route routes;

  String title='';

  bool isUiAvailable=false;


  String appHeaderFont='Lato';
  Color appHeaderColor=Colors.black87;
  double appFontSize=15;
  Color scrollbarColor=Colors.pinkAccent;
  final ScrollController _controllerOne = ScrollController();
  double scrollbarthickness=2;
  Color backgroundColor=Colors.transparent, title_backgroundColor=Colors.transparent;

  Alignment titleAlignment = Alignment.centerLeft;

  String baseUrl='',admin_auto_id='',app_type_id='';

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');

    if(baseUrl!=null && adminId!=null && userId != null && apptypeid!=null){
      if(this.mounted){

        setState(() {
          this.user_id = userId;
          this.admin_auto_id=adminId;
          this.baseUrl=baseUrl;
          this.app_type_id=apptypeid;
          getRecommended_Product();
          getrecommendedhome_details();
        });
      }
    }
  }

  getRecommended_Product() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "customer_auto_id": user_id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    print("customer_auto_id=>"+user_id);

    var url = baseUrl+'api/' + get_recommended_products;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing = false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());

      if (status == 1) {
        Recommended_ListModel recommendedListModel=Recommended_ListModel.fromJson(json.decode(response.body));
        recommended_products=recommendedListModel.getRecommendedProductsLists;
      }
      else {
      }

      if(mounted){
        setState(() {});
      }
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
        child: recommended_products.isEmpty&& widget.user_type!='Admin'?
        Container():
        Column(
          children: [

            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 30),
                  alignment: titleAlignment,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: title_backgroundColor,
                    child: Text(title,style: headerStyle,),
                  ),
                ),
                Container(
                    alignment: Alignment.centerRight,
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        iseditSwitched==true?
                        GestureDetector(
                          onTap: ()=>{
                            widget.onDeleteCallBack(component_id)
                          },
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            child: const Icon(Icons.delete,color: Colors.redAccent,),
                          ),
                        ):
                        Container(),

                        iseditSwitched==true?
                        GestureDetector(
                          onTap: ()=>{
                            showRecommendedEdit()
                          },
                          child: Container(
                              padding: const EdgeInsets.all(7),
                              child: const Icon(Icons.edit,color: Colors.orange,)
                          ),):
                        Container(),

                        GestureDetector(
                          onTap: ()=>{
                            showMoreProducts()
                          },
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            child: const Icon(Icons.arrow_forward),
                          ),)
                      ],
                    )
                )
              ],
            ),

            SizedBox(
                width: 1000,
                child: getUi()
            ),
          ],
        )
    );
  }

  showRecommendedEdit() {
    routes = MaterialPageRoute(builder: (context) => EditRecommendedStyle(onSavelistener,component_id));
    Navigator.push(context, routes);
  }

  void onSavelistener(){
    Navigator.pop(context);
    getrecommendedhome_details();
  }

  FutureOr onGoBack(dynamic value) {
    getRecommended_Product();
  }

  productCard0(ProductModel product){
    return
      Container(
        height: 180,
        width: 180,
        color: Colors.white,
        margin: const EdgeInsets.all(5),
        child:GestureDetector(
          onTap: ()=>{
            showProductDetails(product.productAutoId)
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Stack(children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.grey[100],
                  child: product.productImages.isNotEmpty
                      ? CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: baseUrl+product_base_url + product.productImages[0].productImage,
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
              Container(
                height: 15,
                width: 45,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.green,
                ),
                child: Text(
                  product.offerPercentage + "% off",
                  style: const TextStyle(
                      color: Colors.white, fontSize: 11),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black38,
                  child: Text(
                    product.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 17,color: Colors.white),
                  ),
                ),
              )
            ]
            ),
          ),
        ),

      );
  }

  productCard1(ProductModel product){
    return
      Container(
        height: 300,
        width: 190,
        margin: const EdgeInsets.all(1),
        color: Colors.white,
        child:GestureDetector(
          onTap: ()=>{
            showProductDetails(product.productAutoId)
          },
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
                        child: product.productImages.isNotEmpty
                            ? CachedNetworkImage(
                          fit: BoxFit.contain,
                          imageUrl: baseUrl+product_base_url + product.productImages[0].productImage,
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
                    product.offerData.isNotEmpty && product.offerData[0].offer.isNotEmpty?
                    Container(
                      height: 15,
                      width: 45,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                      ),
                      child:
                      Text(product.offerData[0].offer + "% off",
                        style: const TextStyle(
                            color: Colors.white, fontSize: 11),
                      ),
                    ):
                    product.offerPercentage.isNotEmpty?
                    Container(
                      height: 15,
                      width: 45,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                      ),
                      child:
                      Text(product.offerPercentage + "% off",
                        style: const TextStyle(
                            color: Colors.white, fontSize: 11),
                      ),
                    ):
                    Container(),

                    /*  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.bottomRight,
                    child: totalRatingUi(),
                  ),*/
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
                                  product.productName,
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
                                "₹" + product.productPrice,
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "₹" + product.finalProductPrice.toString(),
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            flex:1,
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                children: [
                                  product.isAdedToCart==true?
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(2)),
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.only(
                                          top: 5,
                                        ),
                                        alignment: Alignment.center,
                                        child:Text("Added In Cart",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12))
                                    ),
                                  ):
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius: BorderRadius.circular(2)),
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.only(
                                          top: 5,
                                        ),
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: () {
                                            if(product.size.isNotEmpty){
                                              showSeleceCartSize(product.productAutoId,product.moq,product.size);
                                              //Select_Size_Layout(product.productAutoId,product.moq,product.size);
                                            }
                                            else{
                                              addToCart(product.productAutoId,product.moq,'');
                                            }
                                          },
                                          child: Text("Add To Cart",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12)),
                                        )
                                    ),
                                  ),

                                  SizedBox(width: 5,),
                                  Expanded(
                                    flex: 1,
                                    child:Container(
                                      decoration: BoxDecoration(
                                          color: Colors.orangeAccent,
                                          borderRadius: BorderRadius.circular(2)
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      margin: const EdgeInsets.only(top: 5,),
                                      alignment: Alignment.center,
                                      child: GestureDetector(
                                        onTap: (){
                                        },
                                        child: const Text("Buy Now",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white,
                                                fontWeight: FontWeight.bold,fontSize: 13)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                  )
              ),
            ],
          ),
        ),

      );
  }

  showProductDetails(String productId){
    routes = MaterialPageRoute(builder: (context) => ProductDetailScreen(productId));
    Navigator.push(context, routes).then(onGoBack);
  }

  showMoreProducts(){
    routes = MaterialPageRoute(
        builder: (context) =>
            Product_List_User(type: 'recommended',main_cat_id: '',
                sub_cat_id:'',
                brand_id: '',
                home_componet_id: '',
            offer_id: '',));

    Navigator.push(context, routes).then(onGoBack);
  }

  Future getrecommendedhome_details() async {

    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "component_auto_id":component_id,
      "component_type":RECOMMENDED_PRODUCTS,
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
        Recommended_Model homerecommendedDetails=Recommended_Model.fromJson(json.decode(response.body));
        GetHomeComponentList homeComponent=homerecommendedDetails.getHomeComponentList[0];

        isUiAvailable=true;

        if(homeComponent.titleFont.isNotEmpty){
          appHeaderFont=homeComponent.titleFont;
        }
        if(homeComponent.titleColor.isNotEmpty){
          appHeaderColor=Color(int.parse(homeComponent.titleColor));
        }

        if(homeComponent.backgroundColor.isNotEmpty){
          backgroundColor=Color(int.parse(homeComponent.backgroundColor));
        }

        if(homeComponent.titleBackground.isNotEmpty){
          title_backgroundColor=Color(int.parse(homeComponent.titleBackground));
        }

        if(homeComponent.titleAlignment.isNotEmpty){
          titleAlignment=GetAlignement.getTitleAlignment(homeComponent.titleAlignment);
        }

        headerStyle= GoogleFonts.getFont(appHeaderFont).copyWith(
            fontSize:appFontSize,
            fontWeight: FontWeight.normal,
            color: appHeaderColor);

        if(homeComponent.iconType.isNotEmpty){
          iconType=homeComponent.iconType;
        }
        if(homeComponent.layoutType.isNotEmpty){
          layoutType=homeComponent.layoutType;
        }


        title=homerecommendedDetails.getHomeComponentList[0].title;

        if(mounted){
          setState(() {});
        }
      }
    }
  }

  getUi(){
    if(layoutType=='0'){
      if(recommended_products.isEmpty){
        if(iconType=='0'){
          return SizedBox(
            height:190,
            width: MediaQuery.of(context).size.width,
            child:
            ListView(
              scrollDirection: Axis.horizontal ,
              controller: _controllerOne,
              children: <Widget>[
                Container(
                  height: 300,
                  width: 190,
                  margin: const EdgeInsets.all(1),
                  color: Colors.grey[300],
                ),
                Container(
                  height: 300,
                  width: 190,
                  margin: const EdgeInsets.all(1),
                  color: Colors.grey[300],
                ),
                Container(
                  height: 300,
                  width: 190,
                  margin: const EdgeInsets.all(1),
                  color: Colors.grey[300],
                )

              ],
            ),
          );
        }
        else{
          return SizedBox(
            height:300,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal ,
              controller: _controllerOne,
              children: <Widget>[
                Container(
                  height: 300,
                  width: 190,
                  margin: const EdgeInsets.all(1),
                  color: Colors.grey[300],
                ),
                Container(
                  height: 300,
                  width: 190,
                  margin: const EdgeInsets.all(1),
                  color: Colors.grey[300],
                ),
                Container(
                  height: 300,
                  width: 190,
                  margin: const EdgeInsets.all(1),
                  color: Colors.grey[300],
                )

              ],
            ),
          );
        }
      }
      else{
        if(iconType=='0'){
          return  SizedBox(
            height: 180,
            child:RawScrollbar(
              thickness: scrollbarthickness,
              thumbColor: scrollbarColor,
              trackColor: Colors.grey,
              trackRadius: Radius.circular(10),
              controller: _controllerOne,
              thumbVisibility: true,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal ,
                  controller: _controllerOne,
                  itemCount: recommended_products.length,
                  itemBuilder: (context, index) =>
                      productCard0(recommended_products[index])
              ),
            ),
          );
        }
        else{
          return  SizedBox(
            height:300,
            width: MediaQuery.of(context).size.width,
            child:RawScrollbar(
              thickness: scrollbarthickness,
              thumbColor: scrollbarColor,
              trackColor: Colors.grey,
              trackRadius: Radius.circular(10),
              controller: _controllerOne,
              thumbVisibility: true,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal ,
                  controller: _controllerOne,
                  itemCount: recommended_products.length,
                  itemBuilder: (context, index) =>
                      productCard1(recommended_products[index])
              ),
            ),
          );
        }
      }
    }
    else{
      if(iconType=='0'){
        return  SizedBox(
          height: 300,
          child:RawScrollbar(
            thickness: scrollbarthickness,
            thumbColor: scrollbarColor,
            trackColor: Colors.grey,
            trackRadius: Radius.circular(10),
            controller: _controllerOne,
            thumbVisibility: true,
            child: GridView.count(
                crossAxisCount: 2,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal ,
                controller: _controllerOne,
                children:getLayout()
            ),
          ),
        );
      }
      else{
        return  SizedBox(
          height: 600,
          child:RawScrollbar(
            thickness: scrollbarthickness,
            thumbColor: scrollbarColor,
            trackColor: Colors.grey,
            trackRadius: Radius.circular(10),
            controller: _controllerOne,
            thumbVisibility: true,
            child: GridView.count(
                childAspectRatio:1/0.65,
                crossAxisCount: 2,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal ,
                controller: _controllerOne,
                children:getLayout()
            ),
          ),
        );
      }
    }
  }

  getLayout(){
    List<Widget> widgetList=[];
    if(recommended_products.isEmpty){
      for(int i=0;i<6;i++){
        if(iconType=="0"){
          widgetList.add(
              Container(
                height: 100,
                width: 100,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
              )
          );
        }
        else{
          {
            widgetList.add(
                Container(
                  height: 150,
                  width: 100,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                )
            );
          }
        }
      }
    }
    else{
      for(int index=0;index<recommended_products.length;index++){
        if(iconType=='0'){
          widgetList.add(Container(
            //height: 180,
            width: 180,
            color: Colors.white,
            margin: const EdgeInsets.all(5),
            child:GestureDetector(
              onTap: ()=>{
                showProductDetails(recommended_products[index].productAutoId)
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Stack(children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.grey[100],
                      child: recommended_products[index].productImages.isNotEmpty
                          ? CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl: baseUrl+product_base_url + recommended_products[index].productImages[0].productImage,
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
                  Container(
                    height: 15,
                    width: 45,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                    ),
                    child: Text(
                      recommended_products[index].offerPercentage + "% off",
                      style: const TextStyle(
                          color: Colors.white, fontSize: 11),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black38,
                      child: Text(
                        recommended_products[index].productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14,color: Colors.white),
                      ),
                    ),
                  )
                ]
                ),
              ),
            ),

          ));
        }
        else{
          widgetList.add(Container(
            //height: 300,
            //width: 180,
            margin: const EdgeInsets.all(1),
            color: Colors.white,
            child:GestureDetector(
              onTap: ()=>{
                showProductDetails(recommended_products[index].productAutoId)
              },
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
                            child: recommended_products[index].productImages.isNotEmpty
                                ? CachedNetworkImage(
                              fit: BoxFit.contain,
                              imageUrl: baseUrl+product_base_url + recommended_products[index].productImages[0].productImage,
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
                        recommended_products[index].offerData.isNotEmpty && recommended_products[index].offerData[0].offer.isNotEmpty?
                        Container(
                          height: 15,
                          width: 45,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                          ),
                          child:
                          Text(recommended_products[index].offerData[0].offer + "% off",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
                          ),
                        ):
                        recommended_products[index].offerPercentage.isNotEmpty?
                        Container(
                          height: 15,
                          width: 45,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                          ),
                          child:
                          Text(recommended_products[index].offerPercentage + "% off",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
                          ),
                        ):
                        Container(),

                        /*  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.bottomRight,
                    child: totalRatingUi(),
                  ),*/
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
                                      recommended_products[index].productName,
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
                                    "₹" + recommended_products[index].productPrice,
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "₹" + recommended_products[index].finalProductPrice.toString(),
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
                                ],
                              ),
                              Expanded(
                                flex:1,
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    children: [
                                      recommended_products[index].isAdedToCart==true?
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.circular(2)),
                                            padding: const EdgeInsets.all(5),
                                            margin: const EdgeInsets.only(
                                              top: 5,
                                            ),
                                            alignment: Alignment.center,
                                            child:Text("Added In Cart",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12))
                                        ),
                                      ):
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                borderRadius: BorderRadius.circular(2)),
                                            padding: const EdgeInsets.all(5),
                                            margin: const EdgeInsets.only(
                                              top: 5,
                                            ),
                                            alignment: Alignment.center,
                                            child: GestureDetector(
                                              onTap: () {
                                                if(recommended_products[index].size.isNotEmpty){
                                                  showSeleceCartSize(recommended_products[index].productAutoId,recommended_products[index].moq,
                                                      recommended_products[index].size);
                                                  //Select_Size_Layout(product.productAutoId,product.moq,product.size);
                                                }
                                                else{
                                                  addToCart(recommended_products[index].productAutoId,recommended_products[index].moq,'');
                                                }
                                              },
                                              child: Text("Add To Cart",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12)),
                                            )
                                        ),
                                      ),

                                      const SizedBox(width: 5,),
                                      Expanded(
                                        flex: 1,
                                        child:Container(
                                          decoration: BoxDecoration(
                                              color: Colors.orangeAccent,
                                              borderRadius: BorderRadius.circular(2)
                                          ),
                                          padding: const EdgeInsets.all(5),
                                          margin: const EdgeInsets.only(top: 5,),
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            onTap: (){
                                            },
                                            child: const Text("Buy Now",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.white,
                                                    fontWeight: FontWeight.bold,fontSize: 13)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                      )
                  ),
                ],
              ),
            ),
          ));
        }
      }
    }

    return widgetList;
  }

  addToCart(String productAutoId, String moq,String size) async {

    widget.onAddToCartCallBack();

    for(int i=0;i<recommended_products.length;i++){
      if(productAutoId==recommended_products[i].productAutoId){
        recommended_products[i].isAdedToCart=true;
      }
    }

    String cartQty='1';
    String size='';

    if(moq.isNotEmpty){
      cartQty=moq;
    }

    /* if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }*/


    final body = {
      "product_auto_id": productAutoId,
      "user_auto_id": user_id,
      "size": size,
      "cart_quantity": cartQty,
      "admin_auto_id":admin_auto_id,
    };

    print("prod_id=>"+productAutoId);
    print("cart qty=>"+cartQty);
    print("Size=>"+size);

    var url = baseUrl+'api/' + add_to_cart;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      String  status = resp['status'];
      print("status=>"+status.toString());
      if (status == '1') {
        /*  AddToCartModel addToCartModel=AddToCartModel.fromJson(json.decode(response.body));
        isAddedTocart=true;
        getCartProdList();
        isAddedTocart=false;
        selectedSize=-1;
        productsDetails.clear();*/

      }
      else {
        String msg=resp['msg'];
        Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.grey,
        );
      }

      if(mounted){
        setState(() {});
      }
    }else if(response.statusCode==500){
      isApiCallProcessing=false;
      if(mounted){
        setState(() {});
      }
    }
  }

  showSeleceCartSize(String productAutoId, String moq,List<ProdSize> size) {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SelectProdSize(onAddToCartListener,productAutoId,moq,size);
        });
  }

  void onAddToCartListener(String productAutoId, String moq, String size) {
    addToCart(productAutoId, moq, size);
    Navigator.of(context).pop();
  }

}
