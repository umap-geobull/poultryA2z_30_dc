import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/all_offers_model.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/all_offers.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/settings/AddCurrency/Component/currency_list_model.dart';
import '../../Utils/App_Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import '../../settings/Add_Size/Components/Get_SizeList_Model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

typedef OnSaveCallback = void Function(int i,List<ProductPrice> productPriceList);

class ProductPrice{
  GetCurrencyList currencyList;
  List<GetSizeList> selectedSize;
  List<String> selectedSizePrice;
  String productPrice='';
  Offers? offer;
  String offerPer='0';
  String includingTax='Yes';
  String tax='0';

  ProductPrice(
      this.currencyList,
      this.selectedSize,
      this.selectedSizePrice,
      this.productPrice,
      this.offer,
      this.offerPer,
      this.includingTax,
      this.tax);
}

class AddPrice extends StatefulWidget {
  AddPrice(
      {Key? key,
        required this.product_model_auto_id,
        required this.i,
        required this.onSaveCallback,
        required this.selectedSize,
        required this.selectedCurrencyId,
        required this.getCurrencyList
       })
      : super(key: key);
  String product_model_auto_id;
  int i;
  OnSaveCallback onSaveCallback;
  List<GetSizeList> selectedSize;
  List<String> selectedCurrencyId;
  List<GetCurrencyList> getCurrencyList;

  @override
  _AddPriceState createState() => _AddPriceState(product_model_auto_id,selectedSize,getCurrencyList);
}

class _AddPriceState extends State<AddPrice>{
  String product_model_auto_id;
  List<GetSizeList> selectedSize;
  List<GetCurrencyList> getCurrencyList=[];

  _AddPriceState(this.product_model_auto_id,this.selectedSize, this.getCurrencyList);

  String baseUrl='';
  bool isApiCallProcessing=false;
  String user_id='',admin_auto_id='';
  List<GetCurrencyList> selectedCurrency=[];
  List<String> selectedSizePrice = [];
  Offers? selectedOffer;
  String including_tax='Yes';
  String offerpercent='0';
  List<String> includingTaxList = [
    'Yes',
    'No',
  ];

  TextEditingController priceController=TextEditingController();
  TextEditingController offerController=TextEditingController();
  TextEditingController taxController=TextEditingController();

  List<ProductPrice> productPriceList=[];

  List<ProductPrice> multiSelectedPrice=[];

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? adminId =prefs.getString('admin_auto_id');
    String? userId = prefs.getString('user_id');

    if(baseUrl!=null && adminId!=null && userId != null){
      this.baseUrl=baseUrl;
      this.admin_auto_id=adminId;
      this.user_id = userId;
      setState(() {
      });

      getCurrency();

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setSizePrice();
    getBaseUrl();
  }

  setSizePrice(){
    selectedSize.forEach((element) {
      selectedSizePrice.add('0');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Add Product Price",
            style: TextStyle(color: appBarIconColor,fontFamily:'Lato',fontSize: 16)),
        leading: IconButton(
          onPressed: ()=>{
            Navigator.of(context).pop()
          },
          icon: const Icon(Icons.arrow_back, color: appBarIconColor),
        ),
      ),

      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child:SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  getCurrencyList.isNotEmpty?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Select Currency",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black)),
                          Container(
                            height:100,
                            //width: 200,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children:currencyItem()
                            ),
                          )
                        ],
                      ):
                  Container(),
                  SizedBox(height: 20,),

                  selectedSize.isNotEmpty?
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
                          saveProductPrice()
                        }
                      },
                      child: Center(
                        child: Text(
                          'Add Price',
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
    if(selectedCurrency.isEmpty){
      Fluttertoast.showToast(msg: "Please select currency", backgroundColor: Colors.grey,);
      return false;
    }
    else if (priceController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Enter product price", backgroundColor: Colors.grey,);
      return false;
    }
    else if(including_tax=='No' && taxController.text.isEmpty){
      Fluttertoast.showToast(msg: "Enter tax percentage", backgroundColor: Colors.grey,);
      return false;
    }

    return true;
  }

  saveProductPrice(){
    print('in save');

    for(int i=0;i<selectedCurrency.length;i++){
      if(offerController.text!='')
      {
        offerpercent=offerController.text;
      }
      ProductPrice productPrice=ProductPrice(
          selectedCurrency[i],selectedSize,selectedSizePrice,priceController.text,
          selectedOffer,offerpercent,including_tax,taxController.text
      );

      productPriceList.add(productPrice);
    }

    widget.onSaveCallback(widget.i,productPriceList);
    Navigator.pop(context);
    print('widget called');

  }

  void getCurrency() async {
    var url=baseUrl+'api/'+get_currecy_list;
    var uri = Uri.parse(url);
    final body={
      "admin_auto_id":admin_auto_id,
    };
    final response = await http.post(uri,body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        CurrencyListModel currencyListModel=CurrencyListModel.fromJson(json.decode(response.body));
        getCurrencyList=currencyListModel.getCurrencyList;

        //print(resp.toString());

        if(this.mounted){
          setState(() {});
        }
      }
    }
  }

  currencyItem(){
    List<Widget> items=[];

    for(int index=0;index<getCurrencyList.length;index++){
      bool isCurrencyAdded=false;
      widget.selectedCurrencyId.forEach((element) {
        if(element==getCurrencyList[index].id){
          isCurrencyAdded=true;
        }
      });

      if(isCurrencyAdded==false){
        items.add(
            GestureDetector(
                onTap: ()=>{
                  setSelected(getCurrencyList[index])
                },
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: isAdded(getCurrencyList[index].id)==true ? Colors.blue  : Colors.grey,
                                width: 1
                            )
                        ),
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(7),
                        height: 50,
                        width: 50,
                        child:Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child:
                              Container(
                                  alignment: Alignment.center,
                                  child:const Icon(Icons.flag),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.grey[200],
                                  )),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child:isAdded(getCurrencyList[index].id)==true?
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.orange[300]
                                ),
                                child: Text(
                                  getIndex(getCurrencyList[index].id,),
                                  style: const TextStyle(color: Colors.white,fontSize: 10),
                                ),
                              ):
                              Container(),
                            )
                          ],
                        )),
                    Text(
                      getCurrencyList[index].countryName+'('+getCurrencyList[index].currency+')',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: const TextStyle(color: Colors.black87,fontSize: 12),
                    )
                  ],
                )
            )
        );
      }
    }
    return items;
  }

  setSelected(GetCurrencyList currencyList){
    if(isAdded(currencyList.id) ==true){
      selectedCurrency.remove(currencyList);
    }
    else{
      selectedCurrency.add(currencyList);
    }

    setState(() {});
  }

  bool isAdded(String id){
    for(int i=0;i<selectedCurrency.length;i++){
      if(selectedCurrency[i].id==id){
        return true;
      }
    }
    return false;
  }

  String getIndex(String id) {
    for(int i=0;i<selectedCurrency.length;i++){
      if(selectedCurrency[i].id==id){
        return (i+1).toString();
      }
    }
    return "";
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
            selectedSize.isNotEmpty && selectedSizePrice.isNotEmpty?
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
                value: including_tax,
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
        including_tax = value as String;
      });
    }
  }

  taxPerUi(){
    if(including_tax=='Yes'){
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
          const Text("Product Offer",
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
                      hintText: "Enter offer %",
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
          selectedOffer!=null?
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
                            child:selectedOffer?.componentImage!=''?
                            CachedNetworkImage(
                              fit: BoxFit.fill,
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              imageUrl: baseUrl+offer_image_base_url+selectedOffer!.componentImage,
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
                      alignment: Alignment.bottomRight,
                      child: Container(
                          width: 200,
                          color: Colors.black38,
                          padding: const EdgeInsets.all(10),
                          child: selectedOffer!.offer.isNotEmpty?
                          Text('Offer% : '+selectedOffer!.offer+'%',
                            style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),):
                          Text('Offer Off Price : Rs.'+selectedOffer!.price,
                            style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)
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
              child: const Text('Select Offer',style: TextStyle(color: Colors.blue,fontSize: 17,fontWeight: FontWeight.bold),),
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

    this.selectedOffer=selectedOffer;
    offerController.text='';
    if(this.mounted){
      setState(() {});
    }
  }

  void onSelectSizelistener(GetSizeList size,String price, int i){
    Navigator.pop(context);

    selectedSize.add(size);

    selectedSizePrice.add(price);

    if(price.isNotEmpty){
      price=price;
    }

    setState(() {});
  }

  List<Widget> sizeListWidget(){
    List<Widget> sizelistUi=[];

    for(int index=0;index<selectedSize.length;index++){
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
                  child: Text(selectedSize[index].size),
                ),
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

  showAddSizePrice(int index) async {
    TextEditingController sizepricecontroller=TextEditingController();
    sizepricecontroller.text=selectedSizePrice[index].toString();

    showDialog(
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
        selectedSizePrice[index]=price;
        priceController.text=price;
      });
    }
  }

  removeOffer(){
    selectedOffer=null;
    if(mounted){
      setState(() {});
    }
  }
}
