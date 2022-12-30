import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:poultry_a2z/Admin_add_Product/Components/Edit_Product_List_Ui.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Model/Rest_Apis.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Update_ProductNew.dart';
import 'package:poultry_a2z/Home/Components/AddNewComponent/Products/all_products_model.dart';
import 'package:poultry_a2z/Product_Details/Filters/filter_bottomsheet.dart';
import 'package:poultry_a2z/Product_Details/model/Filtered_Products_model.dart';
import 'package:poultry_a2z/Product_Details/model/Product_Model.dart';
import 'package:poultry_a2z/Product_Details/product_details_screen.dart';
import 'package:poultry_a2z/settings/Select_Filter/Components/filter_menu_model.dart';
import 'package:poultry_a2z/Admin_add_Product/Components/Product_Card_Admin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../../Home/Components/AddNewComponent/Products/Choose_Main_Categories.dart';
import '../../Utils/App_Apis.dart';
import '../../Utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';

class Admin_Product_List extends StatefulWidget {
  @override
  _Admin_Product_ListState createState() => _Admin_Product_ListState();
}

class _Admin_Product_ListState extends State<Admin_Product_List> {
  List<ProductModel> productList=[];
  late Route routes;

  bool isApiCallProcessing=false;
  bool isDeleteProcessing=false;

  String baseUrl='',admin_auto_id='',app_type_id='';
 // String userType='';
  List<String> categories = [];
  bool isServerError=false;
  String user_id='';

  //filter
  String main_cat_id='',sub_cat_id='',colors='', size='', moq='',  brand='',  min_price='', max_price='', sort_by='';
  String manufacturer='', material='',min_thickness='',max_thickness='',firmness='',max_height='',
      min_height='',min_width='',max_width='',min_depth='',max_depth='',min_discount='',max_discount='',stock='',min_trial_priod='',max_trial_period='';

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
        this.user_id=userId;
        this.app_type_id=apptypeid;
        getFilterList();
        getProducts();
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
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            backgroundColor: appBarColor,
            title: const Text("Products List",
                style: TextStyle(
                    color: appBarIconColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            leading: IconButton(
              onPressed: ()=>{
                Navigator.of(context).pop()
              },
              icon: Icon(Icons.arrow_back, color: appBarIconColor),

            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Product_List_Ui()));
                },
                icon: Icon(Icons.edit, color:appBarIconColor),
              ),

              IconButton(
                  onPressed: ()=>{
                    showFilter()
                  },
                  icon: Icon(Icons.filter_alt_outlined,color: appBarIconColor,)),
              IconButton(
                onPressed: () {
                  routes = MaterialPageRoute(builder: (context) => Choose_Main_Categories());
                  Navigator.push(context, routes).then(onGoBack);
                },
                icon: Icon(Icons.add_circle_outline, color: appBarIconColor),
              )
            ]
        ),
        body:Stack(
          children: <Widget>[
            productList.length!='0'?Container(
              child:
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: productList.length,
                    itemBuilder: (context, index) =>
                        ProductCardAdmin(
                            baseUrl:baseUrl,
                            user_id: "",
                            product: productList[index],
                            onDeleteCallback: showAlert,
                            editCallback: showEditPage,
                            showDetailsCallback: showProductDetails)
                )
            ):Container(),

            isApiCallProcessing==false && productList.isEmpty ?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: const Text('No products available')
            ):
            Container(),

            isServerError==true?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset('assets/server_error.png'),
                  ),
                  const Text('Server Error.. Please try later')
                ],
              ),
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
      //bottomSheet: filter_Section(context),
    );
  }

  getFilterList() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body={
      "customer_auto_id": user_id,
      "admin_auto_id":admin_auto_id,

    };

    var url = baseUrl+'api/' + get_filter_menu;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        FilterMenuModel filterMenuModel=FilterMenuModel.fromJson(json.decode(response.body));
        filterMenuModel.allfiltermenus.forEach((element) {
          categories.add(element.filterMenuName);
        });
      }
      else {
        print('empty');
      }
      if(mounted){
        setState(() {});
      }
    }
  }

  showFilter() {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return FilterBottomsheet(onApplyFilterListener,onClearFilterListener,categories,
              colors, size, moq, brand, min_price, max_price, sort_by,manufacturer,
              material,min_thickness,max_thickness,firmness,min_height,max_height,min_width,max_width,min_depth,max_depth,min_discount,max_discount,stock,min_trial_priod,max_trial_period);
        });
  }

  onApplyFilterListener(String colors,String size,String moq,
      String brand, String min_price,String max_price,String sort_by,String manufacturer,String material,
      String firmness,String min_thickness,String max_thickness,String min_height,String max_height,String min_width,String max_width,String min_depth,
      String max_depth,String min_discount,String max_discount,String stock,String min_trial_priod,String max_trial_period){
    this.colors=colors;
    this.size=size;
    this.moq=moq;
    this.brand=brand;
    this.min_price=min_price;
    this.max_price=max_price;
    this.sort_by=sort_by;
    this.manufacturer=manufacturer;
    this.material=material;
    this.min_thickness=min_thickness;
    this.max_thickness=max_thickness;
    this.firmness=firmness;
    this.min_height=min_height;
    this.max_height=max_height;
    this.min_width=min_width;
    this.max_width=max_width;
    this.min_depth=min_depth;
    this.max_depth=max_depth;
    this.min_discount=min_discount;
    this.max_discount=max_discount;
    this.stock=stock;
    this.min_trial_priod=min_trial_priod;
    this.max_trial_period=max_trial_period;

    if(this.mounted){
      setState(() {
      });
    }

    getFilter_Product();
  }

  onClearFilterListener(){
    print('clear filter');

    this.colors='';
    this.size='';
    this.moq='';
    this.brand='';
    this.min_price='';
    this.max_price='';
    this.sort_by='';
    this.manufacturer='';
    this.material='';
    this.min_thickness='';
    this.max_thickness='';
    this.firmness='';
    this.min_height='';
    this.max_height='';
    this.min_width='';
    this.max_width='';
    this.min_depth='';
    this.max_depth='';
    this.min_discount='';
    this.max_discount='';
    this.stock='';
    this.min_trial_priod='';
    this.max_trial_period='';

    if(this.mounted){
      setState(() {
      });
    }

    getProducts();
  }

  getFilter_Product() async {
    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }

    final body = {
      "min_price": min_price,
      "max_price": max_price,
      "brand_id": brand,
      "moq": moq,
      "color_name": colors,
      "size_id": size,
      "main_category_id": main_cat_id,
      "sub_category_id": sub_cat_id,
      "app_type_id": app_type_id,
      "admin_auto_id":admin_auto_id,
      "customer_auto_id": user_id,
      "manufacturer_name":manufacturer,
      "material_name":material,
      "firmness_type":firmness,
      "min_thickness":min_thickness,
      "max_thickness":max_thickness,
      "min_height":min_height,
      "max_height":max_height,
      "min_width":min_width,
      "max_width":max_width,
      "min_depth":min_depth,
      "max_depth":max_depth,
      "min_discount":min_discount,
      "max_discount":max_discount,
      "min_trial_period":min_trial_priod,
      "max_trial_period":max_trial_period,
      "out_of_stock":stock,
    };

    var url = baseUrl + 'api/' + get_filter_products;

    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      int status = resp['status'];
      print("status=>" + status.toString());

      productList.clear();
      if (status == 1) {
        FilteredProducts_Model filteredProductsModel = FilteredProducts_Model.fromJson(json.decode(response.body));
        productList = filteredProductsModel.getAdminOfferProductLists!;
        print(productList[0].productName);
        print(productList.length);
        //isfilter=true;
      }
      else {
        productList=[];
      }

      if (mounted) {
        setState(() {
          isApiCallProcessing = false;
          isServerError=false;
        });
      }
    }
    else if (response.statusCode == 500) {
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
          isServerError=true;
        });
      }
    }
  }

  void Delete_Product(String productId) {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.Delete_Product(productId, admin_auto_id, baseUrl,app_type_id).then((value) {
      if (value != null) {
        isApiCallProcessing=false;
        int status = value;
        print("status=>"+status.toString());
        if (status == 1) {

          Fluttertoast.showToast(
            msg: "Product Deleted successfully",
            backgroundColor: Colors.grey,
          );

          getProducts();

        }
        else {
          Fluttertoast.showToast(
            msg: "Something went wrong",
            backgroundColor: Colors.grey,
          );
        }

        if(mounted){
          setState(() {
          });
        }
      }


    });
  }

  FutureOr onGoBack(dynamic value) {
    getProducts();
  }

  void getProducts() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body={
      "customer_auto_id": user_id,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };

    var url=baseUrl+'api/'+get_admin_products;
    var uri = Uri.parse(url);
    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        AllProductsModel allProductsModel=AllProductsModel.fromJson(json.decode(response.body));
        productList=allProductsModel.getProductsLists;
      }
      else {
          productList=[];
        }

      if(mounted){
        setState(() {
          isApiCallProcessing=false;
          isServerError=false;
        });
      }
    }
    else if (response.statusCode == 500) {
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
          isServerError=true;
        });
      }
    }
  }

  showEditPage(String productId){
    routes = MaterialPageRoute(builder: (context) => Update_Product(product_id: productId,));
    Navigator.push(context, routes).then(onGoBack);
  }

  showProductDetails(String productId){
    routes = MaterialPageRoute(builder: (context) => ProductDetailScreen(productId));
    Navigator.push(context, routes).then(onGoBack);
  }

  Future<bool> showAlert(String productId) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: const Text(
            'Are you sure?',
            style: TextStyle(color: Colors.black87),
          ),
          content: Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Do you want delete this product',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                //widget.onDeleteCallback(productId);
                                Delete_Product(productId);
                              },
                              child: const Text("Yes",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green[200],
                                onPrimary: Colors.green,
                                //minimumSize: Size(70, 30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("No",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue[200],
                                onPrimary: Colors.blue,
                                // minimumSize: Size(70, 30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

}