import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Admin_Product_Opreation/Model/Approve_CategoryList_Model.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/App_Apis.dart';
import 'Model/Approve_ProductList_Model.dart';
import 'Model/Rest_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';

class Approve_Category_List extends StatefulWidget {
  @override
  State<Approve_Category_List> createState() => _Approve_Category_ListState();
}

class _Approve_Category_ListState extends State<Approve_Category_List> {
  List<GetVendorCategoryApprovalLists> approveCategoryList = [];

  String baseUrl='';

  bool isApiCallProcessing=false;

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if(baseUrl!=null){
      this.baseUrl=baseUrl;
      print(baseUrl);
      setState(() {
        getApprove_Productlist();
      });
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
        // appBar: AppBar(
        //   backgroundColor: kPrimaryColor,
        //   title: Text("Approval Products List",
        //       style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 18,
        //           fontWeight: FontWeight.bold)),
        //   leading: IconButton(
        //     onPressed:  Navigator.of(context).pop,
        //     icon: Icon(Icons.arrow_back, color: Colors.white),
        //   ),
        // ),
        body:Stack(
          children: <Widget>[
            Container(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: approveCategoryList.length,
                  itemBuilder: (context, index) => productCard(approveCategoryList[index],)
              ),
            ),

            isApiCallProcessing==false && approveCategoryList.isEmpty?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child:Text('No categories added for approval'),
            ):
            Container(),


            isApiCallProcessing==true?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: GFLoader(
                  type:GFLoaderType.circle
              ),
            ):
            Container()
          ],
        ));
  }

  void getApprove_Productlist() async {

    if(this.mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    var url = baseUrl +'api/'+ get_vendor_category_approval_list;
    var uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      int status = resp['status'];
      if (status == 1) {
        Approve_CategoryModel approve_categoryModel  = Approve_CategoryModel.fromJson(json.decode(response.body));
        approveCategoryList=approve_categoryModel.getVendorCategoryApprovalLists;
      }
      else{
        approveCategoryList=[];
      }
    }
    else if(response.statusCode == 500){
      Fluttertoast.showToast(msg: "Server Error", backgroundColor: Colors.grey,);
    }else {
      Fluttertoast.showToast(msg: "Something went wrong,please try later", backgroundColor: Colors.grey,);
    }

    if(this.mounted){
      setState(() {

      });
    }
  }

  void Approve_Product(String user_auto_id, String category_id) {
    setState(() {
      //isApiCallProcess = true;
    });

    Rest_Apis restApis = new Rest_Apis();

    restApis.approve_category(user_auto_id, category_id,baseUrl).then((value) {
      if (value != null) {
        int status = value;
        if (status == 1) {
          Fluttertoast.showToast(
            msg: "Category approved successfully",
            backgroundColor: Colors.grey,
          );
          approveCategoryList.clear();
          getApprove_Productlist();
        } else {
          Fluttertoast.showToast(
            msg: "Category can't be approved",
            backgroundColor: Colors.grey,
          );
        }
      }
    });
  }

  productCard(GetVendorCategoryApprovalLists getVendorBrandApprovalLists){
    return Container(
      height: 150,
      margin: EdgeInsets.only(top: 5, right: 5, left: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                            width: 110,
                            height: 90,
                            child: Container(
                                color: Colors.grey[100],
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    topLeft: Radius.circular(8),
                                  ),
                                  child: getVendorBrandApprovalLists.categoryImageApp.length!=0
                                      ? CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    imageUrl: baseUrl + main_categories_base_url + getVendorBrandApprovalLists.categoryImageApp,
                                    placeholder: (context, url) => Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                        )),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )
                                      : Container(
                                      child: Icon(Icons.error),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                      )),
                                ))),
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              getVendorBrandApprovalLists.categoryName
                              as String,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Approval Status: ",
                              style:
                              TextStyle(color: Colors.black45, fontSize: 15),
                            ),
                            getVendorBrandApprovalLists.adminApproval=='No'?Text(
                              'Pending',
                              style:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                            ): Text(
                              " ",
                              style:
                              TextStyle(color: Colors.black45, fontSize: 15),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left:20,right:20,top: 5),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 35,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: kPrimaryColor,
                          textStyle: const TextStyle(fontSize: 20)),
                      onPressed: () {
                        showAlert(
                            getVendorBrandApprovalLists.userAutoId,
                            getVendorBrandApprovalLists.id);
                      },
                      child: Text(
                        'Approve',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 35,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: kPrimaryColor,
                          textStyle: const TextStyle(fontSize: 20)),
                      onPressed: () {},
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 35,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: kPrimaryColor,
                          textStyle: const TextStyle(fontSize: 20)),
                      onPressed: () {
                        showDisapproveAlert(
                            getVendorBrandApprovalLists.userAutoId,
                            getVendorBrandApprovalLists.id);
                      },
                      child: Text(
                        'Disapprove',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<bool> showAlert(String user_auto_id, String product_id) async {
    return await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: Text(
            'Are you sure?',
            style: TextStyle(color: Colors.black87),
          ),
          content: Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Do you want approve this product',
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            child:
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Approve_Product(user_auto_id, product_id);
                              },
                              child: Text("Yes",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green[200],
                                onPrimary: Colors.green,
                                minimumSize: Size(70, 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("No",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue[200],
                                onPrimary: Colors.blue,
                                minimumSize: Size(70, 30),
                                shape: RoundedRectangleBorder(
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

  Future<bool> showDisapproveAlert(String user_auto_id, String product_id) async {
    return await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: Text(
            'Are you sure?',
            style: TextStyle(color: Colors.black87),
          ),
          content: Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Do you want disapprove this category',
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            child:
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                DisapproveApprove_Product(user_auto_id, product_id);
                              },
                              child: Text("Yes",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green[200],
                                onPrimary: Colors.green,
                                minimumSize: Size(70, 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("No",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue[200],
                                onPrimary: Colors.blue,
                                minimumSize: Size(70, 30),
                                shape: RoundedRectangleBorder(
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

  void DisapproveApprove_Product(String user_auto_id, String category_id) {
   if(this.mounted){
     setState(() {
       isApiCallProcessing = true;
     });
   }

    Rest_Apis restApis = new Rest_Apis();

    restApis.disapprove_category(user_auto_id, category_id,baseUrl).then((value) {
      if (value != null) {
        int status = value;
        if (status == 1) {
          approveCategoryList.clear();
          getApprove_Productlist();
          isApiCallProcessing=false;
        } else {
          Fluttertoast.showToast(
            msg: "Category can't be approved",
            backgroundColor: Colors.grey,
          );
          isApiCallProcessing=false;
        }
      }
    });
  }

}
