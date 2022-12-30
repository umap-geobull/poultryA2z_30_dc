import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Vendor_add_Product/Components/Model/Add_Product_Screen.dart';
import '../Utils/App_Apis.dart';
import '../Utils/constants.dart';
import '../Utils/size_config.dart';
import 'Model/SubCat_Product_List_Model.dart';
import 'Rest_Apis.dart';

class Product_List extends StatefulWidget {
  Product_List({Key? key, required this.main_cat_id, required this.sub_cat_id})
      : super(key: key);
  String main_cat_id;
  String sub_cat_id;

  @override
  _Product_ListState createState() => _Product_ListState();
}

class _Product_ListState extends State<Product_List> {
  SubCat_Product_List_Model? subCat_Product_List_Model;
  List<GetAdminSubcategoryProductLists>? getSub_Cat_Product = [];
  bool isDataAvailable = false;
  List<String> selected_List = [];
  bool isApiCallProcessing = false;
  String user_id = "",baseUrl="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
    print("main_cat_id=>"+widget.main_cat_id);
    print("sub_cat_id=>"+widget.sub_cat_id);
    getSubCat_ProductList(widget.sub_cat_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text("Products List",
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
      bottomSheet: Checkout_Section(context),
      body: Container(
        child: GridView.builder(
            itemCount: getSub_Cat_Product!.length,
            physics: const ScrollPhysics(),
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) => CategoryCard(
                getSub_Cat_Product![index].productName as String,
                getSub_Cat_Product![index].productImages![0].productImage as String,

                getSub_Cat_Product![index].isSelected as bool,
                getSub_Cat_Product![index].productPrice as String,
                getSub_Cat_Product![index].offerPercentage as String,
                getSub_Cat_Product![index].moq as String,
                getSub_Cat_Product![index].finalProductPrice as String,
                index)),
      ),
    );
  }

  Future<void> fetch_images() async {
    ImagePicker imagePicker = ImagePicker();
    List<File>? imageFileList = [];
    var selectedImages = await imagePicker.pickMultiImage();

    if(selectedImages!=null) {
      for (var file in selectedImages) {
        File selectedImg = File(file.path);
        imageFileList.add(selectedImg);
      }
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => Add_Product_Screen(
              imageFileList: imageFileList,
              main_cat_id: widget.main_cat_id,
              sub_cat_id: widget.sub_cat_id,
            )),
      );
    }
    /* ImagePicker imagePicker = ImagePicker();
    List<XFile>? imageFileList = [];
    List<XFile>? selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages!.isNotEmpty) {
      imageFileList.addAll(selectedImages);

      print("Image List Length:" + imageFileList.length.toString());
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => Add_Product_Screen(
                  imageFileList: imageFileList,
                  main_cat_id: widget.main_cat_id,
                  sub_cat_id: widget.sub_cat_id,
                )),
      );
    }*/
  }
  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if(baseUrl!=null){
      setState(() {
        this.baseUrl=baseUrl;
      });
    }
    return null;
  }

  void getSubCat_ProductList(String subCatId) async {
    Rest_Apis restApis = Rest_Apis();

    restApis.getSubCat_Product(subCatId,baseUrl).then((value) {
      if (value != null) {
        if(mounted){
          setState(() {
            subCat_Product_List_Model = value;
          });
        }


        if (subCat_Product_List_Model != null) {
          if(mounted)
          {
            setState(() {
              isDataAvailable = true;
              getSub_Cat_Product = subCat_Product_List_Model?.getAdminSubcategoryProductLists;
            });
          }

        } else {
          if(mounted) {

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
        if(mounted)
        {
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

  Widget CategoryCard(String name, String image, bool isSelected, String price,
      String offer, String moq, String finalPrice, int index) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: isAdded(getSub_Cat_Product![index].productAutoId!) == true
                    ? kPrimaryColor
                    : Colors.grey,
                width: 1.5),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 100,
                  child: Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                      height: 90,
                      width: 90,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),

                        child: image != ''
                            ? CachedNetworkImage(
                          height: 100,
                          width: 100,
                          imageUrl: product_img_base_url + image,
                          placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.grey[400],
                              )),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                            : Container(
                            child: const Icon(Icons.error),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey[400],
                            )),
                      )),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 70,
                  color: kPrimaryLightColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            child: Text(
                              name,
                              style:
                              const TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                "₹" + finalPrice,
                                style:
                                const TextStyle(color: Colors.blue, fontSize: 14),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    "₹" + price,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            child: Text(
                              "MOQ - " + moq + " Qunantity",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () => {setSelected(getSub_Cat_Product![index].productAutoId as String)},
    );
  }

  Widget Checkout_Section(BuildContext context) {
    return Container(
      child: isDataAvailable == true
          ? Container(
        height: 60,
        color: Colors.grey.shade50,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: isApiCallProcessing == true
                ? Center(
              child: Container(
                height: 60,
                alignment: Alignment.center,
                width: 80,
                child: const GFLoader(type: GFLoaderType.circle),
              ),
            )
                : SizedBox(
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: kPrimaryColor,
                    textStyle: const TextStyle(fontSize: 20)),
                onPressed: () {
                  if (selected_List.isNotEmpty) {
                    add_ProductList();
                  } else {
                    Fluttertoast.showToast(
                      msg: "Select something",
                      backgroundColor: Colors.grey,
                    );
                  }
                },
                child: const Center(
                  child: Text(
                    'Save Product',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )),
      )
          : Container(),
    );
  }

  setSelected(String id) {
    if (isAdded(id) == true) {
      selected_List.remove(id);
    } else {
      if (selected_List.length < 10) {
        selected_List.add(id);
      } else {
        Fluttertoast.showToast(
          msg: "Maximum 10 brands can be selected",
          backgroundColor: Colors.grey,
        );
      }
    }


  }

  bool isAdded(String id) {
    for (int i = 0; i < selected_List.length; i++) {
      if (selected_List[i] == id) {
        return true;
      }
    }
    return false;
  }

  void add_ProductList() async {
    if(mounted)
    {
      setState(() {
        isApiCallProcessing = true;
      });
    }

    String productList = '';

    for (int i = 0; i < selected_List.length; i++) {
      if (i == 0) {
        productList += selected_List[i];
      } else {
        productList += '|' + selected_List[i];
      }
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.add_BrandList(user_id, productList,baseUrl).then((value) {
      if (value != null) {
        isApiCallProcessing = false;

        String status = value;

        if (status == "1") {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: "Product added successfully",
            backgroundColor: Colors.grey,
          );
        } else {
          Fluttertoast.showToast(
            msg: "Something went wrong",
            backgroundColor: Colors.grey,
          );
        }
      }
    });
  }
}
