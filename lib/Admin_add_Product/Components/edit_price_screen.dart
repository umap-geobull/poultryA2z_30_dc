import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/Rest_Apis.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/all_offers_model.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/product_price_model.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/size_model.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/all_offers.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SizePriceModel{
  String size;
  String price;

  SizePriceModel(this.size, this.price);
}

typedef OnSaveCallback = void Function();

class EditPrice extends StatefulWidget {
  EditPrice(
      {Key? key,
        required this.productPriceList,
        required this.onSaveCallback,
        required this.size
       })
      : super(key: key);
  OnSaveCallback onSaveCallback;
  List<ProdSize> size;
  GetCountryProductPriceList productPriceList;

  @override
  _EditPriceState createState() => _EditPriceState(productPriceList,size);
}

class _EditPriceState extends State<EditPrice> {
  GetCountryProductPriceList productPriceList;
  List<ProdSize> size;

  _EditPriceState(this.productPriceList,this.size);

  String baseUrl='',admin_auto_id='';
  bool isApiCallProcessing=false;
  String user_id = "";
  List<String> includingTaxList = [
    'Yes',
    'No',
  ];

  List<SizePriceModel> sizePriceList = [];

  TextEditingController priceController=TextEditingController();
  TextEditingController offerController=TextEditingController();
  TextEditingController taxController=TextEditingController();

 // Offers? selectedOffer;
  String selected_offer_auto_id='',app_type_id='';
 // List<String> selectedSizePrice = [];

  List<String> prevPrice = [];

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
      }
    }

    if (userId != null) {
      setState(() {
        user_id = userId;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    priceController.text=productPriceList.productPrice;
    taxController.text=productPriceList.taxPercentage;
    offerController.text=productPriceList.offerPercentage;

    setSizePrice();
    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Edit Product Price",
            style: TextStyle(color: appBarIconColor,fontFamily:'Lato',fontSize: 16)),
        leading: IconButton(
          onPressed: ()=>{
            Navigator.of(context).pop()
          },
          icon: const Icon(Icons.arrow_back, color: appBarIconColor),
        ),
        actions: [
          TextButton(
              onPressed: ()=>{
                deleteProductPrice()
              },
              child: Text('Delete',
                style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 16),))
        ],
      ),

      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child:SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  sizePriceList.isNotEmpty?
                  productSizeUi():
                  Container(),
                  priceUi(),
                  includingTaxUi(),
                  taxPerUi(),
                  offerPriceUi(),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: kPrimaryColor,
                          textStyle: const TextStyle(fontSize: 20)),
                      onPressed: ()=> {
                        print('save pressed'),
                        if(validations()==true){
                          editProductPrice()
                        }
                      },
                      child: Center(
                        child: Text(
                          'Edit Price',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),
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
    );
  }

  bool validations(){
    if (priceController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Enter product price", backgroundColor: Colors.grey,);
      return false;
    }
    else if(productPriceList.includingTax=='No' && taxController.text.isEmpty){
      Fluttertoast.showToast(msg: "Enter tax percentage", backgroundColor: Colors.grey,);
      return false;
    }

    return true;
  }

  Future editProductPrice() async{
   // print('clicked');
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    String selectedPrice = "";

   /* for (int index = 0; index < size.length; index++) {
      if(index==0){
        selectedPrice += selectedSizePrice[index].toString();
      }
      else {
        selectedPrice += '|' + selectedSizePrice[index].toString();
      }
    }
*/

    for (int index = 0; index < sizePriceList.length; index++) {
      if(index==0){
        selectedPrice += sizePriceList[index].price.toString();
      }
      else {
        selectedPrice += '|' + sizePriceList[index].price.toString();
      }
    }


    restApis.edit_product_price(productPriceList.countryPriceAutoId,user_id,productPriceList.currencyAutoId,
        productPriceList.productAutoId, priceController.text, offerController.text, selectedPrice,
        productPriceList.includingTax,
        taxController.text, selected_offer_auto_id, admin_auto_id, baseUrl,app_type_id).then((value) {
      if (value != null) {
        if(mounted){
          setState(() {
            isApiCallProcessing=false;
          });
        }

        if(value=='1'){
          Navigator.pop(context);
          widget.onSaveCallback();
        }
      }
    });

  }

  Future deleteProductPrice() async{
    //print('clicked');
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.delete_product_price(productPriceList.countryPriceAutoId,user_id,productPriceList.currencyAutoId,
        productPriceList.productAutoId, admin_auto_id, baseUrl,app_type_id).then((value) {
      if (value != null) {
        if(mounted){
          setState(() {
            isApiCallProcessing=false;
          });
        }

        if(value==1){
          Navigator.pop(context);
          widget.onSaveCallback();
        }
      }
    });

  }

  priceUi(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Product Price",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 45,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: TextFormField(
                controller: priceController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                      hintText: "Enter product price",
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      )),
                  // style: AppTheme.form_field_text,
                  keyboardType: TextInputType.number,
              ),
            ),
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  productSizeUi(){
    return
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Product Size Price",
                style: TextStyle(
                    fontSize: 16, color: Colors.black)),
            SizedBox(
              height: 8,
            ),
            sizePriceList.isNotEmpty?
            Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: sizeListWidget(),
                )
            ):
            Container(),
            Divider(color: Colors.grey.shade300),
          ],
        ),
      );
  }

  includingTaxUi(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Including tax",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
          Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                items: includingTaxList.map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )).toList(),
                value: productPriceList.includingTax,
                onChanged: (value) {
                  setTax(value as String);
                },
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                ),
                iconEnabledColor: Colors.black,
                iconDisabledColor: Colors.grey,
                buttonHeight: 45,
                buttonWidth: MediaQuery.of(context).size.width,
                buttonPadding:
                const EdgeInsets.only(left: 14, right: 14),
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.black26,
                  ),
                ),
                itemHeight: 30,
                itemPadding: const EdgeInsets.only(left: 14, right: 14),
                dropdownMaxHeight: 150,
                dropdownWidth: MediaQuery.of(context).size.width,
                dropdownPadding: const EdgeInsets.only(left: 10, right: 10),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                dropdownElevation: 8,
                scrollbarRadius: const Radius.circular(40),
                scrollbarThickness: 1,
                scrollbarAlwaysShow: true,
              ),
            ),
          ),
          Divider(color: Colors.grey.shade300),

        ],
      ),
    );
  }

  setTax(String value){
    if(this.mounted){
      setState(() {
        productPriceList.includingTax = value as String;
      });
    }
  }

  taxPerUi(){
    if(productPriceList.includingTax=='Yes'){
      return Container();
    }
    else{
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Tax(%)",
                style: TextStyle(color: Colors.black, fontSize: 16)),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 45,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: TextFormField(
                    controller: taxController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                        hintText: "Enter the tax percentage",
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        )),
                    keyboardType: TextInputType.number,
                ),
              ),
            ),
            Divider(color: Colors.grey.shade300),

          ],
        ),
      );
    }
  }

  offerPriceUi(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Product Offer(%)",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 45,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: TextFormField(
                  controller: offerController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                      hintText: "Enter offer%",
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      )),
                  // style: AppTheme.form_field_text,
                  keyboardType: TextInputType.number,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: const Text(' OR '),
          ),
          productPriceList.offerData!=null && productPriceList.offerData.isNotEmpty?
          Container(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: ()=>{
                        showSelectOffer()
                      },
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          child: ClipRRect(
                            // borderRadius: BorderRadius.circular(5),
                            child:
                            CachedNetworkImage(
                              fit: BoxFit.fill,
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              imageUrl: baseUrl+offer_image_base_url+productPriceList.offerData[0].componentImage,
                              placeholder: (context, url) =>
                                  Container(decoration: BoxDecoration(
                                    //borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[400],
                                  )),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            )
                          )

                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                          width: 200,
                          color: Colors.black38,
                          padding: const EdgeInsets.all(10),
                          child: productPriceList.offerData[0].offer.isNotEmpty?
                          Text('Offer% : '+productPriceList.offerData[0].offer+'%',
                            style: const TextStyle(color: Colors.white,fontSize: 16,
                                fontWeight: FontWeight.bold),):
                          Text('Offer Off Price : Rs.'+productPriceList.offerData[0].price,
                            style: const TextStyle(color: Colors.white,fontSize: 16,
                                fontWeight: FontWeight.bold),)
                      ),
                    ),

                    Align(
                      alignment: Alignment.topRight,
                      child:Container(
                        margin: const EdgeInsets.only(left: 10),
                        child:IconButton(
                          onPressed: ()=>{removeOffer()},
                          icon: const Icon(Icons.clear,color: Colors.orange),),
                      ),
                    ),
                  ],
                ),
              )
          ):
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey,
                    width: 1
                ),
                borderRadius: BorderRadius.circular(10)
            ),
            alignment: Alignment.center,
            height: 100,
            child: TextButton(
              onPressed: ()=>{showSelectOffer()},
              child: const Text('Select Offer',
                style: TextStyle(color: Colors.blue,fontSize: 17,
                    fontWeight: FontWeight.bold),),
            ),
          ),

          Divider(color: Colors.grey.shade300),

        ],
      ),
    );
  }

  showSelectOffer(){
    Route routes = MaterialPageRoute(builder: (context) => SelectOffers(onSaveOfferCallback,0));
    Navigator.push(context, routes);
  }

  onSaveOfferCallback(int i,Offers selectedOffer){
    Navigator.of(context).pop();

    OfferData offerData = OfferData(
        offerAutoId: selectedOffer.id,
        homecomponentAutoId: '',
        componentImage: selectedOffer.componentImage,
        mainCategory: '',
        subcategory: '',
        brand: '',
        price: selectedOffer.price,
        offer: selectedOffer.offer,
        rdate: '');

    if(productPriceList.offerData.isEmpty){
      productPriceList.offerData.add(offerData);
    }
    else if(productPriceList.offerData.isEmpty){
      productPriceList.offerData[0]=offerData;
    }

    this.selected_offer_auto_id = selectedOffer.id;
    offerController.text='';
    if(this.mounted){
      setState(() {});
    }
  }

  List<Widget> sizeListWidget(){
    List<Widget> sizelistUi=[];

    for(int index=0;index<sizePriceList.length;index++){
      sizelistUi.add(
          GestureDetector(
            onTap: ()=>{
              showAddSizePrice(index)
            },
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left:2,right: 2,top: 7),
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:Border.all(
                          color: Colors.grey,
                          width: 1
                      )
                  ),
                  child: Text(sizePriceList[index].size),
                ),
                Text(sizePriceList[index].price,style: const TextStyle(color: Colors.black54,fontSize: 12),)
              ],
            ),
          )
      );
    }
    return sizelistUi;
  }

/*
  List<Widget> sizeListWidget(){
    List<Widget> sizelistUi=[];

    for(int index=0;index<size.length;index++){
      sizelistUi.add(
          GestureDetector(
            onTap: ()=>{
              showAddSizePrice(index)
            },
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left:2,right: 2,top: 7),
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:Border.all(
                          color: Colors.grey,
                          width: 1
                      )
                  ),
                  child: Text(size[index].sizeName),
                ),

                selectedSizePrice.isEmpty || selectedSizePrice.length<index?
                Container():
                selectedSizePrice[index].isNotEmpty && selectedSizePrice!='0'?
                Text(selectedSizePrice[index].toString(),style: const TextStyle(color: Colors.black54,fontSize: 12),):
                Container()
              ],
            ),
          )
      );
    }
    return sizelistUi;
  }
*/

  Future<bool> showAddSizePrice(int index) async {
    TextEditingController sizepricecontroller=TextEditingController();
    sizepricecontroller.text=sizePriceList[index].price.isEmpty? '' :sizePriceList[index].price.toString();

    return await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
              backgroundColor: Colors.yellow[50],
              title: const Text(
                'Add Size Price',
                style: TextStyle(color: Colors.black87,fontSize: 17),
              ),
              content:Wrap(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                          child: TextFormField(
                            controller: sizepricecontroller,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                hintText: "Enter price",
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.blue, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Container(
                            child: ElevatedButton(
                              onPressed: () {
                                addSizePrice(index,sizepricecontroller.text);
                                Navigator.pop(context);
                              },
                              child: const Text("Save",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green[200],
                                onPrimary: Colors.green,
                                minimumSize: const Size(70, 30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              )),
    );
  }

  addSizePrice(int index,String price){
    if(this.mounted){
      setState(() {
        sizePriceList[index].price=price;
        priceController.text=price;
      });
    }
  }

  removeOffer(){
    productPriceList.offerData.clear();
    if(mounted){
      setState(() {});
    }
  }

  setSizePrice(){
    List<String> priceList = [];

    if(productPriceList.sizePrice.isNotEmpty){
      priceList=productPriceList.sizePrice.split('|');
    }

    for(int i= 0;i<size.length ;i++){
      String _size = size[i].sizeName;
      String _price = priceList.isNotEmpty && priceList.length>= i-1 ? priceList[i] : '0';

      sizePriceList.add(SizePriceModel(_size, _price));
    }

    bool isEmpty = productPriceList.sizePrice.isEmpty;
  }

}
