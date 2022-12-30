import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Vendor_Module/Vendor_Home/Utils/App_Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Rest_Apis.dart';
import 'Model/Get_Brand_LIst_Model.dart';
import 'Vendor_Products.dart';

class Brand_List extends StatefulWidget {
  late String Vendor_id;
  Brand_List(String id)
  {
    this.Vendor_id=id;
  }
  @override
  State<Brand_List> createState() => _Brand_ListState();
}

class _Brand_ListState extends State<Brand_List> {
  String user_id = "",baseUrl = "";
  Brand_Model? brand_model;
  List<GetVendorBrandLists>? get_Brand_List = [];
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
      getBrandList();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "Brands",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
        SizedBox(
          width: 30,
        ),
        Expanded(
          flex: 8,
          child: Container(
            height: 75,
            width: 250,
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Container(
                    child: get_Brand_List!=null?
                    ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: get_Brand_List!.length,
                        itemBuilder: (context, index) => Brandcard(
                            icon: get_Brand_List![index].brandImageApp,
                            name: get_Brand_List![index].brandName,
                            press: () => {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => Vendor_Products(main_cat_id: '', brand_id: get_Brand_List![index].brandAutoId!, type: "brand", sub_cat_id: '',vendor_id: user_id,)),
                              )
                            })):Container(),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void getBrandList() async {

    Rest_Apis restApis = new Rest_Apis();

    restApis.getBrand_List(user_id,baseUrl).then((value) {
      if (value != null) {
        if(mounted)
        {
          setState(() {

            brand_model = value;
          });
        }


        if (brand_model != null) {
          get_Brand_List = brand_model?.getVendorBrandLists;
        } else {
          Fluttertoast.showToast(
            msg: "No category found",
            backgroundColor: Colors.grey,
          );
        }
      } else {
        get_Brand_List=[];
        // Fluttertoast.showToast(
        //   msg: "Something went wrong",
        //   backgroundColor: Colors.grey,
        // );
      }
    });
  }
}

class Brandcard extends StatelessWidget {
  const Brandcard({
    Key? key,
    required this.icon,
    required this.name,
    required this.press,
  }) : super(key: key);

  final String? icon, name;
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: icon != ''
                              ? CachedNetworkImage(
                            height: 100,
                            width: 100,
                            imageUrl:brands_base_url + icon!,
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
                        ))
                  /*child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      icon!,
                      fit: BoxFit.cover,
                    ),
                  )*/)),

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
