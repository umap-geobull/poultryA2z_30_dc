import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/App_Apis.dart';
import 'Model/Get_Category_List_Model.dart';
import 'Rest_Apis.dart';
import 'Vendor_Products.dart';

class Category_List extends StatefulWidget {
  late String Vendor_id;
  Category_List(String id)
  {
    this.Vendor_id=id;
  }

  @override
  _Category_ListState createState() => _Category_ListState();
}

class _Category_ListState extends State<Category_List> {
  Category_List_Model? category_list_model;
  List<GetVendorCategoryLists>? getCategory_List = [];
  String user_id = "",baseUrl = "";
  bool isDataAvilable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user_id=widget.Vendor_id;
    getBaseUrl();
  }
  void getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');

    if (baseUrl != null) {
      this.baseUrl = baseUrl;
      getCategoryList();
    }
  }
  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "Category",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
        SizedBox(
          width: 30,
        ),
        Expanded(
          flex: 8,
          child: Container(
            height: 70,
            width: 250,
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Container(
                    child: isDataAvilable == true
                        ?ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: getCategory_List!.length,
                        itemBuilder: (context, index) => CategoryCard(
                            icon: getCategory_List![index].categoryImageApp,
                            name: getCategory_List![index].categoryName,
                            press: () => {
                              print("id=>"+getCategory_List![index].sId.toString()),
                              Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Vendor_Products(main_cat_id: getCategory_List![index].sId.toString(), brand_id: '', type: "category", sub_cat_id: '',vendor_id: user_id,)))
                            }))
                        :Container(),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void getCategoryList() async {

    Rest_Apis restApis = new Rest_Apis();

    restApis.getCategory_List(user_id,baseUrl).then((value) {
      if (value != null) {
        if(mounted)
          {
            setState(() {

              category_list_model = value;
            });
          }


        if (category_list_model != null) {
          if(mounted)
            {
              setState(() {
                isDataAvilable = true;
                getCategory_List = category_list_model?.getVendorCategoryLists;
              });
            }


        } else {
          if(mounted)
            {
              setState(() {
                isDataAvilable = false;
              });
            }

          Fluttertoast.showToast(
            msg: "No category found",
            backgroundColor: Colors.grey,
          );
        }
      } else {
        if(mounted)
          {
            setState(() {
              isDataAvilable = false;
            });
          }


      }
    });
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.name,
    required this.press,
  }) : super(key: key);

  final String? icon,  name;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: press,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(

                  height: 40,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                     /* child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          icon!,
                          fit: BoxFit.cover,
                        ),
                      )*/
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: icon != ''
                            ? CachedNetworkImage(
                          height: 100,
                          width: 100,
                          imageUrl: main_categories_base_url + icon!,
                          placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.grey[400],
                              )),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )
                            : Container(
                            child: Icon(Icons.error),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey[400],
                            )),
                      )
                  )),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              name!,
              style: TextStyle(
                fontSize: 12,
              ),
            )
          ],
        ));
  }
}

