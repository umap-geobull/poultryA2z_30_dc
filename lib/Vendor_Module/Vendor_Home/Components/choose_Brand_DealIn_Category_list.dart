
import 'package:cached_network_image/cached_network_image.dart';
import 'package:poultry_a2z/Vendor_Module/Model/Model.dart';
import 'package:flutter/material.dart';

import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/Utils/App_Apis.dart';
import '/Utils/constants.dart';
import 'Add_Brand_DealsIn_Category_Item.dart';
import 'Model/Brand_List_Model.dart';
import 'Model/MainCat_List_Model.dart';
import 'Rest_Apis.dart';

class choose_Brand_DealIn_Category_list extends StatefulWidget {
  choose_Brand_DealIn_Category_list({Key? key, required this.type})
      : super(key: key);
  String type;

  @override
  _choose_Brand_DealIn_Category_listState createState() =>
      _choose_Brand_DealIn_Category_listState();
}

class _choose_Brand_DealIn_Category_listState
    extends State<choose_Brand_DealIn_Category_list> {
  List<Model> DealIn_List = [
    Model("Mens FootWear", "assets/category/mens_footwear.jpg", false),
    Model("Womens FootWear", "assets/category/womes_footwear.jpg", false),
    Model("Kids FootWear", "assets/category/kids_footwear.jpg", false),
    Model("Mens FootWear", "assets/category/mens_footwear.jpg", false),
    Model("Womens FootWear", "assets/category/womes_footwear.jpg", false),
    Model("Kids FootWear", "assets/category/kids_footwear.jpg", false),
    Model("Mens FootWear", "assets/category/mens_footwear.jpg", false),
    Model("Womens FootWear", "assets/category/womes_footwear.jpg", false),
    Model("Kids FootWear", "assets/category/kids_footwear.jpg", false),
    Model("Mens FootWear", "assets/category/mens_footwear.jpg", false),
    Model("Womens FootWear", "assets/category/womes_footwear.jpg", false),
    Model("Kids FootWear", "assets/category/kids_footwear.jpg", false),
  ];



  bool isApiCallProcessing = false;

  List<Get_Brandslist>? getBrandslist = [];
  List<String> selected_List = [];
  String user_id = '';
  Brand_List_Model? brandList_Model;
  MainCat_List_Model? mainCategory_Model;
  List<Get_mainCategorylist>? mainCategoryList = [];
  String baseUrl="";

  @override
  void initState() {
    getBaseUrl();
    widget.type == 'brand' ? getMainBrand() : getMainCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
              widget.type == 'brand'
                  ? "Choose Brand"
                  : widget.type == 'deals_in'
                  ? "Choose Category"
                  : "Choose Category",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          leading: const Icon(Icons.arrow_back, color: Colors.white),
          actions: [

            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => Add_Brand_DealsIn_Category_Item(
                        type: widget.type,
                      )),
                );
              },
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            ),
          ]),
      bottomSheet: Checkout_Section(context),
      body: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.only(bottom: 50),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                        physics: const ScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          crossAxisCount: 4,
                        ),
                        itemCount: widget.type == 'brand'
                            ? getBrandslist!.length
                            : widget.type == 'deals_in'
                            ? DealIn_List.length
                            : mainCategoryList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          // return item
                          return Card_Item(
                            widget.type == 'brand'
                                ? getBrandslist![index].brandName!
                                : widget.type == 'deals_in'
                                ? DealIn_List[index].name
                                : mainCategoryList![index].categoryName!,
                            widget.type == 'brand'
                                ? getBrandslist![index].brandImageApp!
                                : widget.type == 'deals_in'
                                ? DealIn_List[index].img
                                : mainCategoryList![index]
                                .categoryImageApp!,
                            widget.type == 'brand'
                                ? getBrandslist![index].isSelected!
                                : widget.type == 'deals_in'
                                ? DealIn_List[index].isSelected
                                : mainCategoryList![index].isSelected!,
                            index,
                          );
                        }),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget Card_Item(String name, String image, bool isSelected, int index) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: widget.type == 'brand'
                    ? isAdded(getBrandslist![index].sId as String) == true
                    ? kPrimaryColor
                    : Colors.grey
                    : isAdded(mainCategoryList![index].sId as String) == true
                    ? kPrimaryColor
                    : Colors.grey,
                width: 1.5),
          ),
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: SizedBox(
                        height: 45,
                        width: 45,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: image != ''
                              ? CachedNetworkImage(
                            height: 100,
                            width: 100,
                            imageUrl: widget.type == 'brand'
                                ? brands_base_url + image
                                : main_categories_base_url + image,
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
                SizedBox(
                  height: 15,
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 10, color: black),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () => {
        widget.type == 'brand'
            ? setSelected(getBrandslist![index].sId as String)
            : setSelected(mainCategoryList![index].sId as String)
      },
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
    if(mounted)
      {
        setState(() {});
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

  Widget Checkout_Section(BuildContext context) {
    return Container(
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
                print("selected_item=>" + selected_List.toString());
                if (selected_List.isNotEmpty) {
                  widget.type == 'brand'
                      ? addBrandList()
                      : addCatrgoryList();
                } else {
                  Fluttertoast.showToast(
                    msg: "Select something",
                    backgroundColor: Colors.grey,
                  );
                }
              },
              child: const Center(
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )),
    );
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
  void addBrandList() async {
    setState(() {
      isApiCallProcessing = true;
    });
    String brands = '';

    for (int i = 0; i < selected_List.length; i++) {
      if (i == 0) {
        brands += selected_List[i];
      } else {
        brands += '|' + selected_List[i];
      }
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.add_BrandList(user_id, brands,baseUrl).then((value) {
      if (value != null) {
        isApiCallProcessing = false;

        String status = value;

        if (status == "1") {

          Navigator.of(context).pop();
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Vendor_Home()));

          Fluttertoast.showToast(
            msg: "Brand added successfully",
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

  void addCatrgoryList() async {
    setState(() {
      isApiCallProcessing = true;
    });
    String category = '';

    for (int i = 0; i < selected_List.length; i++) {
      if (i == 0) {
        category += selected_List[i];
      } else {
        category += '|' + selected_List[i];
      }
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.add_CategoryList(user_id, category,baseUrl).then((value) {
      if (value != null) {
        isApiCallProcessing = false;

        String status = value;

        if (status == "1") {
          Navigator.of(context).pop();
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Vendor_Home()));

          Fluttertoast.showToast(
            msg: "Category added successfully",
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

  void getMainBrand() async {
    Rest_Apis restApis = Rest_Apis();

    restApis.getBrandList(baseUrl).then((value) {
      if (value != null) {
        setState(() {
          isApiCallProcessing = false;
          brandList_Model = value;
        });

        if (brandList_Model != null) {
          getBrandslist = brandList_Model?.getBrandslist;
        } else {
          Fluttertoast.showToast(
            msg: "No brand found",
            backgroundColor: Colors.grey,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Something went wrong",
          backgroundColor: Colors.grey,
        );
      }
    });
  }

  void getMainCategory() async {
    Rest_Apis restApis = Rest_Apis();

    restApis.getCategoryList(baseUrl).then((value) {
      if (value != null) {
        setState(() {
          isApiCallProcessing = false;
          mainCategory_Model = value;
        });

        if (mainCategory_Model != null) {
          mainCategoryList = mainCategory_Model?.getmainCategorylist;
        } else {
          Fluttertoast.showToast(
            msg: "No category found",
            backgroundColor: Colors.grey,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Something went wrong",
          backgroundColor: Colors.grey,
        );
      }
    });

  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> brand_list = [
    'CONSTRAIN',
    'STOAT SHOES',
    'RED WINGS SHOES',
    'PUMA FOOTWEAR',
    'SPARX FOOTWEAR',
    'SPARX FOOTWEAR',
    'NIKE',
    'ADIDAS',
    'GOODFOOT FOOTWEAR',
    'RED WINGS SHOES'
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var brand in brand_list) {
      if (brand.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(brand);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (BuildContext context, int index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var brand in brand_list) {
      if (brand.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(brand);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (BuildContext context, int index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}

