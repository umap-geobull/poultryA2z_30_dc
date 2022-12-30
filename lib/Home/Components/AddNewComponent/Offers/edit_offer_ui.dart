import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/constants.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Offers/select_offers.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../MainCategories/main_category_model.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import '../models/all_brands_model.dart';
import '../models/home_offer_details.dart';
import '../models/sub_category_model.dart';
import 'select_offer_products.dart';
import 'package:cached_network_image/cached_network_image.dart';


typedef OnSaveCallback = void Function();

class EditOfferUi extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  HomeOffers offersList;

  EditOfferUi(this.onSaveCallback,this.offersList );

  @override
  _EditOfferUi createState() => _EditOfferUi(offersList);

}

class _EditOfferUi extends State<EditOfferUi> with TickerProviderStateMixin {
  HomeOffers offersList;

  _EditOfferUi(this.offersList);


  final TextEditingController _textEditingController=TextEditingController();

  bool isIconSelected=false;
  final ImagePicker _picker = ImagePicker();

  bool isApiCallProcessing=false;

  List<GetmainCategorylist> mainCategoryList=[];

  List<String> selectedMainCategory=[];
  List<String> selectedSubcategories=[];
  List<String> selectedProducts=[];
  List<String> selectedBrands=[];

  String baseUrl='',admin_auto_id='',app_type_id='';

  String offerPrice='', offer_percentage='';
  int selectedIndex=0;
  int selectedSlider=-1;

  List<File> selectedOfferImg=[];

  List<GetBrandslist> brandsList=[];

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');

    if(baseUrl!=null && adminId!=null && apptypeid!=null){
      this.admin_auto_id=adminId;
      this.baseUrl=baseUrl;
      this.app_type_id=apptypeid;
      setState(() {});

      getMainCategories();
      getBrands();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(this.mounted){
      setState(() {
        offerPrice=offersList.price;
        offer_percentage=offersList.offer;

        if(!offersList.mainCategory.isEmpty){
          selectedMainCategory= offersList.mainCategory.split("|");
        }

        if(!offersList.subcategory.isEmpty){
          selectedSubcategories= offersList.subcategory.split("|");
        }

        if(!offersList.brand.isEmpty){
          selectedBrands= offersList.brand.split("|");
        }

        if(!offersList.product_auto_id.isEmpty){
          selectedProducts= offersList.product_auto_id.split("|");
        }
      });
    }
    getBaseUrl();
  }

  onBackPressed() async{
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,color: Colors.white,size: 20,),
            onPressed: onBackPressed,
          ),
          title: const Text('Edit Offer' ,style: TextStyle(color: Colors.white,fontFamily:'Lato',fontSize: 16)),
        ),

        body: Container(
          padding: EdgeInsets.all(10),
          child: Stack(
            children: <Widget>[
              sliderItems(),

              isApiCallProcessing==true?
              Container(
                height: 200,
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

  sliderItems(){
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child:Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 70),
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 250,
                    child:
                    GestureDetector(
                      onTap: ()=>{
                        getGalleryImage()
                      },
                      child: Container(
                          child:
                          ClipRRect(
                            child:
                            selectedOfferImg.isNotEmpty && selectedOfferImg[0]!=null?
                            Image.file(selectedOfferImg[0], fit: BoxFit.fill,):
                            offersList.componentImage!=''?
                            CachedNetworkImage(
                              fit: BoxFit.fill,
                              height: 300,
                              imageUrl: baseUrl+offer_image_base_url+offersList.componentImage,
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
                  const SizedBox(height: 10,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: (value)=>{
                              offerPrice=value,
                              setState(() {})
                            },
                            initialValue: offerPrice,
                            style: const TextStyle(color:Colors.black,fontSize: 15),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 3.0, top: 3.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                        color: Colors.grey
                                    )
                                ),
                                // hintText: 'Enter price of included products',
                                labelText: 'Enter price',
                                labelStyle: const TextStyle(color: Colors.grey,fontSize: 16)
                            ),
                          ),
                        ),
                      ),
                      const Text(' OR ',style: TextStyle(color: Colors.black),),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          child:
                          TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: (value)=>{
                              offer_percentage=value,
                              setState(() {})
                            },
                            initialValue: offer_percentage,
                            style: const TextStyle(color:Colors.black,fontSize: 15),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 3.0, top: 3.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                        color: Colors.grey
                                    )
                                ),
                                //hintText: 'Enter offer percentage',
                                labelText: 'Enter offer%',
                                labelStyle: const TextStyle(color: Colors.grey,fontSize: 16)
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20,),

                  selectProductsUi(),
                  const SizedBox(height: 10,),

                  brandsList.isNotEmpty?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('Select Brands',style: TextStyle(fontSize: 14,color: Colors.black),),
                      const SizedBox(height: 10,),
                      SizedBox(
                          height: 100,
                          child: GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                              childAspectRatio: 1/2,
                              physics: const ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children:brandItems() )
                      )

                    ],
                  ):
                  Container(),

                  selectCategoriesUi(),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.center,
              height: 70,
              padding: const EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child:Container(
                width: 100,
                margin: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.orange
                ),
                child: GestureDetector(
                  child: const Text('SAVE',style: TextStyle(color:
                  Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                  onTap: ()=> {
                    if(checkValid()==true){
                      editOfferImageApi()
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  bool checkValid(){
    if(offerPrice.isEmpty && offer_percentage.isEmpty){
      Fluttertoast.showToast(msg: "Please enter offer price or offer percentage", backgroundColor: Colors.grey,);
      return false;
    }
    return true;
  }

  Future getGalleryImage() async {
    var pickedFile  = await _picker.pickImage(source: ImageSource.gallery);

    if(pickedFile!=null){
      if(mounted){
        setState(() {
          if(selectedOfferImg.isNotEmpty){
            selectedOfferImg[0]=File(pickedFile.path);
          }
          else{
            selectedOfferImg.add(File(pickedFile.path));
          }
        });
      }
    }
  }

  Future editOfferImageApi() async {
    setState(() {
      isApiCallProcessing=true;
    });

    String brands='',mainCategories='',subCategories='',products='';

    for(int i=0;i<selectedBrands.length;i++){
      if(i==0){
        brands+=selectedBrands[i];
      }
      else{
        brands+='|'+selectedBrands[i];
      }
    }

    for(int i=0;i<selectedMainCategory.length;i++){
      if(i==0){
        mainCategories+=selectedMainCategory[i];
      }
      else{
        mainCategories+='|'+selectedMainCategory[i];
      }
    }

    for(int i=0;i<selectedSubcategories.length;i++){
      if(i==0){
        subCategories+=selectedSubcategories[i];
      }
      else{
        subCategories+='|'+selectedSubcategories[i];
      }
    }

    for(int i=0;i<selectedProducts.length;i++){
      if(i==0){
        products+=selectedProducts[i];
      }
      else{
        products+='|'+selectedProducts[i];
      }
    }


    var url=baseUrl+'api/'+edit_offer_image;

    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);

    try{
      if(selectedOfferImg[0]!=null){
        request.files.add(
          http.MultipartFile(
            'component_image',
            selectedOfferImg[0].readAsBytes().asStream(),
            await selectedOfferImg[0].length(),
            filename: selectedOfferImg[0].path.split('/').last,),);
      }
      else{
        request.fields["component_image"] = offersList.componentImage ;
      }
    }
    catch(exception){
      print('offer pic not selected');
      request.fields["component_image"] = offersList.componentImage ;
    }

    request.fields["image_auto_id"] = offersList.id ;
    request.fields["homecomponent_auto_id"] = offersList.homecomponentAutoId ;
    request.fields["main_category"] = mainCategories ;
    request.fields["subcategory"] = subCategories ;
    request.fields["brand"] = brands ;
    request.fields["price"] = offerPrice ;
    request.fields["offer"] = offer_percentage ;
    request.fields["product_auto_id"]=products;
    request.fields["admin_auto_id"] =admin_auto_id;
    request.fields["app_type_id"] =app_type_id;

    http.Response response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      //String message=resp['msg'];
      int status=resp['status'];

      print('status: '+status.toString());
      if(status==1){
        Fluttertoast.showToast(msg: "Offer edited successfully", backgroundColor: Colors.grey,);
        widget.onSaveCallback();

        if(mounted){
          setState(() {
          });
        }
      }
      else{
        String message=resp['msg'];
        Fluttertoast.showToast(msg: message, backgroundColor: Colors.grey,);

        if(mounted){
          setState(() {
          });
        }

      }
    }
    else if (response.statusCode == 500) {
      isApiCallProcessing=false;
      Fluttertoast.showToast(msg: "Server error", backgroundColor: Colors.grey,);
      if(this.mounted){
        setState(() {});
      }
    }
  }

  //brands
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

  brandItems(){
    List<Widget> items=[];
    for(int index=0;index<brandsList.length;index++){
      items.add(
          GestureDetector(
              onTap: ()=>{
                setSelectedBrand(brandsList[index].id)
              },
              child:
              Container(
                 alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: isBrandAdded(brandsList[index].id)==true ? Colors.blue  : Colors.grey,
                          width: 1
                      )
                  ),
                  //margin: EdgeInsets.all(5),
                  child:Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Text(
                          brandsList[index].brandName,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: const TextStyle(color: Colors.black87,fontSize: 11),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child:isBrandAdded(brandsList[index].id)==true?
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
                  ))
          )
      );
    }

    return items;
  }

  setSelectedBrand(String id){
    if(isBrandAdded(id) ==true){
      selectedBrands.remove(id);
    }
    else{
      selectedBrands.add(id);

      /* if(selectedBrands.length<16){
        selectedBrands.add(id);
      }
      else{
        Fluttertoast.showToast(msg: "Maximum 16 brands can be selected", backgroundColor: Colors.grey,);
      }*/
    }

    setState(() {});
  }

  bool isBrandAdded(String id){
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

  //categories
  selectCategoriesUi(){
    if(mainCategoryList.isNotEmpty){
      return SizedBox(
        height: 4100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20,),
          Text('Select Categories/Subcategories',style: TextStyle(fontSize: 14,color: Colors.black),),
         // SizedBox(height: 5,),
          SizedBox(
              height: 4000,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  cacheExtent: 5000,
                  itemCount: mainCategoryList.length,
                  itemBuilder: (context, index) =>
                      _MainCategory(onChangeSelection,mainCategoryList[index],
                          selectedSubcategories,selectedMainCategory,baseUrl,admin_auto_id,app_type_id)
              )
          )
        ],
      ));
    }
    else{
      return Container();
    }
  }

  onChangeSelection(List<String> selectedSubcategories, List<String> selectedMaincategories){
    this.selectedSubcategories=selectedSubcategories;
    selectedMainCategory=selectedMaincategories;
    if(mounted){
      setState(() {});
    }
  }

  void getMainCategories() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    var url=baseUrl+'api/'+get_main_categories;
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
        MainCategoryModel mainCategoryModel=MainCategoryModel.fromJson(json.decode(response.body));
        mainCategoryList=mainCategoryModel.getmainCategorylist;

        print(mainCategoryList.toString());
        if(mounted){
          setState(() {});
        }
      }
    }
  }

  //products
  selectProductsUi(){
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Select Products',style: TextStyle(fontSize: 14,color: Colors.black),),
            const SizedBox(height: 10,),
            Row(
              children: <Widget>[
                Text(selectedProducts.length.toString()+ ' products selected',style: const TextStyle(fontSize: 13,color: Colors.black54),),

                Expanded(
                    flex:1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.of(context).size.width,
                      child:GestureDetector(
                        onTap: ()=>{
                          showAddProducts()
                        },
                        child: Container(
                          width: 70,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text('Select', style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold,fontSize: 15),),
                        ),
                      ),
                    ))
              ],
            )
          ],
        ));
  }

  showAddProducts() {
    Route routes = MaterialPageRoute(builder: (context) =>
        SelectOfferProducts(onSelectProductlistener,selectedProducts));
    Navigator.push(context, routes);
  }

  void onSelectProductlistener(List<String> productList){
    Navigator.pop(context);
    selectedProducts=productList;

    if(mounted){
      setState(() {});
    }

  }
}

typedef OnchangeSelection =Function(List<String> selectedSubcategories, List<String> selectedMainCategory);

class _MainCategory extends StatefulWidget {
  OnchangeSelection onchangeSelection;
  final GetmainCategorylist mainCategoryList;
  List<String> selectedSubcategories;
  List<String> selectedMainCategory;
  String baseUrl;
  String admin_auto_id;
  String app_type_id;

  _MainCategory(this.onchangeSelection,this.mainCategoryList,this.selectedSubcategories,this.selectedMainCategory,
      this.baseUrl,this.admin_auto_id,this.app_type_id);

  @override
  _MainCategoryState createState() => _MainCategoryState(mainCategoryList,selectedSubcategories,selectedMainCategory,
      baseUrl,admin_auto_id,app_type_id);
}

class _MainCategoryState extends State<_MainCategory> {
  bool isApiCallProcessing=false;
  List<String> selectedSubcategories;
  List<String> selectedMainCategory;
  String baseUrl;
  String admin_auto_id;
  String app_type_id;

  _MainCategoryState(this.mainCategory,this.selectedSubcategories,this.selectedMainCategory,this.baseUrl,this.admin_auto_id, this.app_type_id);

  List<GetmainSubcategorylist> subCategoryList=[];

  final GetmainCategorylist mainCategory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    getSubCategories();
  }

  subCategoryItems(){
    List<Widget> items=[];

    for(int index=0;index<subCategoryList.length;index++){
      items.add(
          GestureDetector(
              onTap: ()=>{
                if(isAdded(subCategoryList[index].id) ==true){
                  selectedSubcategories.remove(subCategoryList[index].id)
                }
                else{
                  selectedSubcategories.add(subCategoryList[index].id)
                },

                widget.onchangeSelection(selectedSubcategories,selectedMainCategory)
                //showEditCategory(subCategoryList[index])
              },
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                //  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: isAdded(subCategoryList[index].id)==true ? Colors.blue  : Colors.grey,
                              width: 1
                          )
                      ),
                      margin: const EdgeInsets.only(bottom: 5),
                      child:Stack(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child:
                            Text(
                              subCategoryList[index].subCategoryName,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11),
                            )
                          ),

                          Container(
                            alignment: Alignment.topRight,
                            child:
                            isAdded(subCategoryList[index].id)==true?
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.orange[300]
                              ),
                              child:const Icon(Icons.check,color: Colors.white,size: 13,)
                            ):
                            Container(),
                          )
                        ],
                      )),
                ],
              )
          )
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10,left: 5,right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                mainCategory.categoryName,style: const TextStyle(color: Colors.black87,fontSize: 16),
              ),

              const SizedBox(width: 10,),
              Container(
                  child: GestureDetector(
                      onTap: ()=>{
                        if(isAddedMainCategory(mainCategory.id) ==true){
                          selectedMainCategory.remove(mainCategory.id)
                        }
                        else{
                          selectedMainCategory.add(mainCategory.id)
                        },

                        widget.onchangeSelection(selectedSubcategories,selectedMainCategory)

                      },
                      child: isAddedMainCategory(mainCategory.id)?
                      const Icon(Icons.check_box,color: Colors.green,size: 18,):
                      const Icon(Icons.check_box_outlined,color: Colors.grey,size: 18,),
                  )
              )
            ],
          ),
          const SizedBox(height: 7,),

          SizedBox(
              height: 100,
              child:
              subCategoryList.isNotEmpty?
              SizedBox(
                // alignment: Alignment.topCenter,
                  height: MediaQuery.of(context).size.height,
                  child:
                  GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      childAspectRatio: 1/2,
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      // crossAxisSpacing: 1,
                      // mainAxisSpacing: 1,
                      children:subCategoryItems() )
              ):
              Container(
                alignment: Alignment.center,
                child: const Text('No data available'),
              )
          )
        ],
      ),
    );
  }

  void getSubCategories() async {
    final body = {
      "main_category_auto_id": mainCategory.id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    var url=baseUrl+'api/'+get_sub_category_list;
    var uri = Uri.parse(url);
    final response = await http.post(uri,body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        SubCategoryModel subCategoryModel=SubCategoryModel.fromJson(json.decode(response.body));
        subCategoryList=subCategoryModel.getmainSubcategorylist;

        print(subCategoryList.toString());
        if(mounted){
          setState(() {});
        }
      }
    }
  }

  bool isAdded(String id){
    if(isAddedMainCategory(mainCategory.id)){
      return true;
    }
    else{
      for(int i=0;i<widget.selectedSubcategories.length;i++){
        if(widget.selectedSubcategories[i]==id){
          return true;
        }
      }
    }
    return false;
  }

  bool isAddedMainCategory(String id){
    for(int i=0;i<widget.selectedMainCategory.length;i++){
      if(widget.selectedMainCategory[i]==id){
        return true;
      }
    }
    return false;
  }

}