import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Admin_add_Product/constants.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Offers/select_offers.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../MainCategories/main_category_model.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import '../models/all_brands_model.dart';
import '../models/sub_category_model.dart';
import 'select_offer_products.dart';


typedef OnSaveCallback = void Function();

class AddOffer extends StatefulWidget {
  String componnet_id;
  OnSaveCallback onSaveCallback;
  List<OfferData> selectedOffers;

  AddOffer(this.onSaveCallback,this.componnet_id,this.selectedOffers );

  @override
  _AddOffer createState() => _AddOffer(componnet_id,selectedOffers);

}

class _AddOffer extends State<AddOffer> with TickerProviderStateMixin {
  String componnet_id;
  List<OfferData> selectedOffers=[];

  _AddOffer(this.componnet_id,this.selectedOffers);


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
          backgroundColor: appBarColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: appBarIconColor,size: 20,),
            onPressed: onBackPressed,
          ),
          title: const Text('Add Offer' ,style: TextStyle(color: appBarIconColor,fontFamily:'Lato',fontSize: 16)),
          actions: [
            TextButton(
              onPressed: ()=>{
                if(checkValid()==true){
                  addOfferImageApi()
                }
              },
              child: Text('SAVE'),
            )
          ],
        ),

        body: Container(
          child: Stack(
            children: <Widget>[
              sliderUi(),

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

  sliderUi(){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 15),
      margin: const EdgeInsets.only(bottom: 20),
      child:
      selectedOffers.isNotEmpty?
      ImageSlideshow(

        /// Width of the [ImageSlideshow].
        width: MediaQuery.of(context).size.width,

        /// Height of the [ImageSlideshow].
        height: MediaQuery.of(context).size.height,

        /// The page to show when first creating the [ImageSlideshow].
        initialPage: selectedSlider!=-1?
        selectedSlider:
        0,

        /// The color to paint the indicator.
       // indicatorColor: Colors.blue,

        /// The color to paint behind th indicator.
       // indicatorBackgroundColor: Colors.grey,

        /// The widgets to display in the [ImageSlideshow].
        /// Add the sample image file into the images folder
        children: sliderItems(),

        /// Called whenever the page in the center of the viewport changes.
        onPageChanged: (value) {
        },

        /// Auto scroll interval.
        /// Do not auto scroll with null or 0.
        autoPlayInterval: null,

        /// Loops back to first slide.
       // isLoop: true,
      ):
      Container(),
    );
  }

  List<Widget> sliderItems(){
    List<Widget> items=[];

    for(int i=0;i<selectedOffers.length;i++){
      items.add(
          SizedBox(
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
                          child: Stack(
                            children: <Widget>[
                              GestureDetector(
                                onTap: ()=>{
                                  selectedSlider=i,
                                  //getGalleryImage()
                                },
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 250,
                                    child:
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: selectedOffers[i].image!=''?
                                      Image.file(selectedOffers[i].image,
                                        //fit: BoxFit.fill,
                                      ):
                                      Container(
                                          child:const Icon(Icons.error),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
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
                                      showAlert()
                                    },
                                  ),
                                ),
                              )
                            ],
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
                                    selectedOffers[i].price=value,
                                    selectedIndex=i,
                                    setState(() {})
                                  },
                                  initialValue: selectedOffers[i].price,
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
                                    selectedOffers[i].offer=value,
                                    selectedIndex=i,
                                    setState(() {})
                                  },
                                  initialValue: selectedOffers[i].offer,
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
                                    // crossAxisSpacing: 1,
                                    // mainAxisSpacing: 1,
                                    children:brandItems() )

                               /* child: GridView.count(
                                    shrinkWrap: true,
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 2,
                                    crossAxisSpacing: 2,
                                    physics: const ClampingScrollPhysics(),
                                    //scrollDirection: Axis.horizontal,
                                    childAspectRatio: 1/0.4,
                                    children:brandItems()
                                )*/
                            )

                          ],
                        ):
                        Container(),

                        selectCategoriesUi(),
                      ],
                    ),
                  ),
                ),
               /* Align(
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
                            addOfferImageApi()
                          }
                        },
                      ),
                    ),
                  ),
                )*/
              ],
            ),
          )
      );
    }

    return items;
  }

  showAlert() async {
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
                                removeOffer();
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

  bool checkValid(){
    if(selectedOffers[selectedIndex].image==null){
      Fluttertoast.showToast(msg: "Please select offer image", backgroundColor: Colors.grey,);
      return false;
    }
    else if(selectedOffers[selectedIndex].price.isEmpty && selectedOffers[selectedIndex].offer.isEmpty){
      Fluttertoast.showToast(msg: "Please enter offer price or offer percentage", backgroundColor: Colors.grey,);
      return false;
    }
    return true;
  }

  Future addOfferImageApi() async {
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


    var url=baseUrl+'api/'+add_offer_image;

    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);

    try{
      request.files.add(
        http.MultipartFile(
          'component_image',
          selectedOffers[selectedIndex].image.readAsBytes().asStream(),
          await selectedOffers[selectedIndex].image.length(),
          filename: selectedOffers[selectedIndex].image.path.split('/').last,),);
    }

    catch(exception){
      print('offer pic not selected');
    }

    request.fields["homecomponent_auto_id"] = componnet_id ;
    request.fields["main_category"] = mainCategories ;
    request.fields["subcategory"] = subCategories ;
    request.fields["brand"] = brands ;
    request.fields["price"] = selectedOffers[selectedIndex].price ;
    request.fields["offer"] = selectedOffers[selectedIndex].offer ;
    request.fields["product_auto_id"]=products;
    request.fields["admin_auto_id"] =admin_auto_id;
    request.fields["app_type_id"] =app_type_id;

    http.Response response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      //String message=resp['msg'];
      String status=resp['status'];
      if(status=='1'){
        Fluttertoast.showToast(msg: "Offer added successfully", backgroundColor: Colors.grey,);

        selectedOffers.removeAt(selectedIndex);

        if(selectedOffers.isEmpty){
          widget.onSaveCallback();
        //  Navigator.pop(context);
        }
        else{
          selectedIndex=0;
        }

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
  }

  void removeOffer() {
    selectedOffers.removeAt(selectedIndex);

    if(selectedOffers.isEmpty){
      Navigator.pop(context);
    }

    if(mounted){
      setState(() {});
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
          const Text('Select Categories/Subcategories',style: TextStyle(fontSize: 14,color: Colors.black),),
          const SizedBox(height: 10,),
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


  _MainCategoryState(this.mainCategory,this.selectedSubcategories,this.selectedMainCategory,this.baseUrl,this.admin_auto_id,this.app_type_id);

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