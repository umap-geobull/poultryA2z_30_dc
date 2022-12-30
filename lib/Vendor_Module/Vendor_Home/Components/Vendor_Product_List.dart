import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import '../../../Admin_add_Product/Components/Add_Product_Screen.dart';
import '../Utils/App_Apis.dart';
import '../Utils/constants.dart';
import '../../Vendor_add_Product/Components/Model/Update_ProductNew.dart';
import 'Model/Main_Cat_Size_Model.dart';
import 'Model/Get_Vendor_Product_Model.dart';
import 'Model/Vender_Brand_Product_Model.dart';
import 'Model/Vender_MainCat_Product_Model.dart';
import 'Rest_Apis.dart';

class Vendor_Product_List extends StatefulWidget {
  Vendor_Product_List(
      {Key? key,
        required this.main_cat_id,
        required this.sub_cat_id,
        required this.brand_id,
        required this.type})
      : super(key: key);
  String main_cat_id;
  String sub_cat_id;
  String brand_id;
  String type;

  @override
  _Vendor_Product_ListState createState() => _Vendor_Product_ListState();
}

class _Vendor_Product_ListState extends State<Vendor_Product_List> {
  Vender_Cat_Product_Model? vender_cat_product_model;
  List<GetVendorCategoryProductLists>? getMain_Cat_Product = [];
  List<Product_Size_List_Model>? sizeList = [];
  Vender_Brand_Product_Model? vender_brand_product_model;
  List<GetVendorBrandProductLists>? getBrand_Product = [];
  bool isDeleteProcessing=false;
  Get_Vendor_Product_Model? _get_vendor_product_model;
  List<GetVendorProductLists>? getProduct_List = [];

  bool isDataAvailable = false;
  List<String> selected_List = [];
  bool isApiCallProcessing = false;
  String user_id = "",baseUrl='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text("Products list",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                fetch_images();
              },
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            ),
          ]),
      body: Container(
        child: ListView.builder(
            scrollDirection: Axis.vertical,

            itemCount: getMain_Cat_Product!.length,
            physics: const ScrollPhysics(),
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,

            itemBuilder: (context, index) => productBrandCard(
                getMain_Cat_Product![index].productAutoId as String,
                getMain_Cat_Product![index].productName as String,
                getMain_Cat_Product![index].productImages![0].productImage as String,
                getMain_Cat_Product![index].productPrice as String,
                getMain_Cat_Product![index].offerPercentage as String,
                getMain_Cat_Product![index].moq as String,

                getMain_Cat_Product![index].finalProductPrice as String,
                getMain_Cat_Product![index].size! ,
                index))

      ),
    );
  }

  productBrandCard(String id, String name, String image, String price, String offer, String moq, String finalPrice,List<Product_Size_List_Model>? sizeList,  int index){
    return Container(
      height: 170,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Stack(children: [
              SizedBox(
                  width: 120,
                  height: 170,
                  child: Container(
                      color: Colors.grey[100],
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          topLeft: Radius.circular(8),
                        ),
                        child: image != ''
                            ? CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: product_img_base_url + image,
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
                            )),
                      )
                  )
              ),
              Container(
                height: 15,
                width: 45,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                  ),
                  color: Colors.green,
                ),
                child: Text(
                  offer + "% off",
                  style: const TextStyle(
                      color: Colors.white, fontSize: 11),
                ),
              ),
            ]),
          ),
          Expanded(
            flex: 1,
            child: Container(
                height: 170,

                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16,color: Colors.black87),
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Text(
                            "Sizes: " + getProdSize(sizeList!),
                            style:
                            const TextStyle(color: Colors.black, fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Text(
                            "MOQ: " + moq,
                            style:
                            const TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          const Text(
                            "Price: ",
                            style:
                            TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          Text(
                            "₹" + price,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "₹" + finalPrice,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(child:Container(
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 35,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: kPrimaryColor,
                                    textStyle: const TextStyle(fontSize: 20)),
                                onPressed: () {
                                  showEditPage(id);
                                },
                                child: const Center(
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            flex: 1,
                            child:
                            isDeleteProcessing==true?
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              child: const GFLoader(
                                  type:GFLoaderType.circle
                              ),
                            ):
                            SizedBox(
                              height: 35,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: kPrimaryColor,
                                    textStyle: const TextStyle(fontSize: 20)),
                                onPressed: () {
                                  showAlert(id);
                                },
                                child: const Center(
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                      ,
                    ))

                  ],
                )
            ),
          )
        ],
      ),

    );
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

  void Delete_Product(String productId) {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.Delete_Product(productId,baseUrl).then((value) {
      if (value != null) {
        isApiCallProcessing=false;
        int status = value;
        if (status == 1) {

          Fluttertoast.showToast(
            msg: "Product Deleted successfully",
            backgroundColor: Colors.grey,
          );

          getCat_ProductList(widget.main_cat_id, user_id);

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

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if(baseUrl!=null){
      setState(() {
        this.baseUrl=baseUrl;
        getCat_ProductList(widget.main_cat_id, user_id);
      });
    }
    return null;
  }

  void getCat_ProductList(String mainCatId, String userId) async {
    Rest_Apis restApis = Rest_Apis();

    restApis.getVender_MainCat_Product(mainCatId, userId,baseUrl).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            vender_cat_product_model = value;
          });
        }

        if (vender_cat_product_model != null) {
          if (mounted) {
            setState(() {
              isDataAvailable = true;
              getMain_Cat_Product =
                  vender_cat_product_model?.getVendorCategoryProductLists;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isDataAvailable = false;
            });
          }

          Fluttertoast.showToast(
            msg: "No product found",
            backgroundColor: Colors.grey,
          );
        }
      } else {
        if (mounted) {
          setState(() {
            isDataAvailable = false;
          });
        }

        Fluttertoast.showToast(
          msg: "No product found",
          backgroundColor: Colors.grey,
        );
      }
    });
  }


  Future<void> fetch_images() async {
    ImagePicker imagePicker = ImagePicker();
    List<File>? imageFileList = [];
    var selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages != null) {
      for (var file in selectedImages) {
        File selectedImg = File(file.path);
        imageFileList.add(selectedImg);
      }
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => Add_Product_Screen(
              imageFileList: imageFileList,
              main_cat_id: widget.main_cat_id,
              sub_cat_id: widget.sub_cat_id,
            )),
      );
    }

  }

  showEditPage(String producyId){
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => Update_Product(product_id: producyId,vendor_id: user_id,)),
    );
    /*routes = MaterialPageRoute(builder: (context) => Update_Product(product_id: producyId,));
    Navigator.push(context, routes).then(onGoBack);*/
  }

  String getProdSize(List<Product_Size_List_Model> sizeLists){
    String size='';

    for(int i=0;i<sizeLists.length;i++){
      if(i==0){
        size+=sizeLists[i].sizeName! ;
      }
      else {
        size+=','+ sizeLists[i].sizeName! ;
      }
    }
    return size;
  }
}
