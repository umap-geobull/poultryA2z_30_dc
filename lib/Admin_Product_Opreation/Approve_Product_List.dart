import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/Vendor_Module/Vendor_add_Product/Components/Model/Update_ProductNew.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/App_Apis.dart';
import 'Model/Approve_ProductList_Model.dart';
import 'Model/Rest_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';

class Approve_Product_List extends StatefulWidget {
  @override
  State<Approve_Product_List> createState() => _Product_listState();
}

class _Product_listState extends State<Approve_Product_List> {
  List<GetVendorProductApprovalLists> approveProductList = [];

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
                  itemCount: approveProductList.length,
                  itemBuilder: (context, index) => productCard(approveProductList[index],)
              ),
            ),

            isApiCallProcessing==false && approveProductList.isEmpty?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child:Text('No products added for approval'),
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
    var url = baseUrl +'api/'+ get_vendor_product_approval_list;
    var uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      int status = resp['status'];
      if (status == 1) {
        ApproveProductListModel approve_productList_Model  = ApproveProductListModel.fromJson(json.decode(response.body));
        approveProductList=approve_productList_Model.getVendorProductApprovalLists;
      }
      else{
        approveProductList=[];
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

  void Approve_Product(String user_auto_id, String product_id) {
    setState(() {
      //isApiCallProcess = true;
    });

    Rest_Apis restApis = new Rest_Apis();

    restApis.approve_product(user_auto_id, product_id,baseUrl).then((value) {
      if (value != null) {
        int status = value;

        if (status == 1) {
          Fluttertoast.showToast(
            msg: "Product approved successfully",
            backgroundColor: Colors.grey,
          );
          approveProductList.clear();
          getApprove_Productlist();
        } else {
          Fluttertoast.showToast(
            msg: "No Approval product found",
            backgroundColor: Colors.grey,
          );
        }
      }
    });
  }

  productCard(GetVendorProductApprovalLists getVendorProductApprovalLists){
    return Container(
      height: 185,
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
                width: 120,
                    height: 100,
                    child: Container(
                        color: Colors.grey[100],
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            topLeft: Radius.circular(8),
                          ),
                          child: getVendorProductApprovalLists.productImages.length!=0
                              ? CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: baseUrl+product_base_url + getVendorProductApprovalLists.productImages[0].productImage,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                alignment: Alignment.topLeft,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.red,
                                ),
                                width: 60,
                                height: 25,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    getVendorProductApprovalLists
                                        .offerPercentage +
                                        "% off",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                )),
                            SizedBox(
                              width: 25,
                            ),
                            // Container(
                            //     alignment: Alignment.topRight,
                            //     width: 35,
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(5),
                            //       color: kPrimaryColor,
                            //     ),
                            //     height: 20,
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(3.0),
                            //       child: Text(
                            //         getVendorProductApprovalLists.brandAutoId,
                            //         style: TextStyle(
                            //             color: Colors.white, fontSize: 12),
                            //       ),
                            //     )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Align(
                            child: Container(
                              margin: EdgeInsets.only(top: 95),
                              child: Row(
                                children: [
                                  Container(
                                      alignment: Alignment.bottomCenter,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      width: 50,
                                      height: 25,
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          "₹" + getVendorProductApprovalLists.productPrice,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              decoration:
                                              TextDecoration.lineThrough),
                                        ),
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      alignment: Alignment.topRight,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      height: 25,
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          "₹" + getVendorProductApprovalLists.finalProductPrice as String,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                      /*child:
                        ),
                      ),*/
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
                              getVendorProductApprovalLists.productName
                              as String,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ),
                          // Material(
                          //   color: Colors.transparent,
                          //   child: InkWell(
                          //     borderRadius: BorderRadius.circular(20.0),
                          //     // splashColor: ,
                          //     onTap: () {},
                          //     child: Container(
                          //       height: 30,
                          //       width: 40,
                          //       child: Icon(
                          //         Icons.favorite,
                          //         color: Color(0xFFEF7532),
                          //         size: 22,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      getVendorProductApprovalLists.size.isNotEmpty?
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Size: ",
                              style:
                              TextStyle(color: Colors.black, fontSize: 14),
                            ),
                            Text(
                              " | "+getVendorProductApprovalLists.size[0].sizeName,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 13),
                            )
                          ],
                        ),
                      ):
                      Container(),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Color: " +
                                  getVendorProductApprovalLists.colorName,
                              style:
                              TextStyle(color: Colors.black45, fontSize: 15),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "MOQ: " +getVendorProductApprovalLists.moq,
                              style:
                              TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            Text(
                              " | Quantity: " +
                                  getVendorProductApprovalLists
                                      .quantity,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 13),
                            )
                          ],
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       getVendorProductApprovalLists.colorName,
                      //       style:
                      //       TextStyle(color: Theme.of(context).accentColor),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left:30,right:30),
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
                            getVendorProductApprovalLists.userAutoId,
                            getVendorProductApprovalLists.productAutoId);
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
                  child:
                  Container(
                    height: 35,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: kPrimaryColor,
                          textStyle: const TextStyle(fontSize: 20)),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                            Update_Product(product_id: getVendorProductApprovalLists.productAutoId,
                              vendor_id: getVendorProductApprovalLists.userAutoId,)),);
                      },
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
                            getVendorProductApprovalLists.userAutoId,
                            getVendorProductApprovalLists.productAutoId);

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
                      'Do you want disapprove this product',
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
                                DisApprove_Product(user_auto_id, product_id);
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

  void DisApprove_Product(String user_auto_id, String product_id) {
    setState(() {
      //isApiCallProcess = true;
    });

    Rest_Apis restApis = new Rest_Apis();

    restApis.disapprove_product(user_auto_id, product_id,baseUrl).then((value) {
      if (value != null) {
        int status = value;

        if (status == 1) {
          Fluttertoast.showToast(
            msg: "Product disapproved successfully",
            backgroundColor: Colors.grey,
          );
          approveProductList.clear();
          getApprove_Productlist();
        } else {
          Fluttertoast.showToast(
            msg: "No Approval product found",
            backgroundColor: Colors.grey,
          );
        }
      }
    });
  }

}
