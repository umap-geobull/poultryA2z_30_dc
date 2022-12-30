import 'dart:async';
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:getwidget/getwidget.dart';
import '../../AdminDashboard/Admin_Coupon_code/Vendor_Add_Coupen_Code.dart';
import '../../Admin_add_Product/constants.dart';
import '../../Utils/App_Apis.dart';
import 'all_coupon_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

typedef OnSaveCallback = void Function(CuponcodeList couponcode);

class SelectCouponScreen extends StatefulWidget {

  OnSaveCallback onSaveCallback;
  SelectCouponScreen(this.onSaveCallback);

  @override
  _SelectCouponScreen createState() => _SelectCouponScreen();
}

class _SelectCouponScreen extends State<SelectCouponScreen> {
  String user_id='';
  bool isApiCallProcessing=false;
  List<CuponcodeList> cuponcodeList=[];
  final List<CuponcodeList> _searchResult=[];
  String baseUrl='', admin_auto_id='';
  bool iscouponavailable=false;
  String userType='';
  late Route routes;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Coupons", style: TextStyle(color: appBarIconColor, fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.arrow_back, color: appBarIconColor),
        ),
      ),
      body:Stack(
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      height: 40,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black45,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(3)
                      ),
                      child:Row(
                        children: <Widget>[
                          SizedBox(
                            width: 200,
                            child: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                hintText: 'Enter coupon code',
                                border: InputBorder.none,
                                enabledBorder: null,
                                focusedBorder: null,
                              ),
                              onChanged: onSearchTextChanged,

                            ),
                          ),
                          Expanded(
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  child: const Text('CHECK',
                                    style: TextStyle(color: Colors.orange,fontSize: 17,
                                        fontWeight: FontWeight.bold),),
                                  onPressed: () {
                                    if(iscouponavailable==false)
                                    {
                                      if(userType=='Admin')
                                        {
                                          couponEmptyAlert();
                                        }else {
                                        Fluttertoast.showToast(
                                          msg: "Sorry, coupon code is currently not available",
                                          backgroundColor: Colors.grey,
                                        );
                                      }
                                    }
                                  },
                                )
                            ),
                          )

                        ],
                      )

                  ),
                  iscouponavailable==true && _searchResult.isNotEmpty?ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _searchResult.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                        },
                        child: couponCard(
                          _searchResult[index],
                        ),
                      )):ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cuponcodeList.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {

                        },
                        child: couponCard(
                          cuponcodeList[index],
                        ),
                      )),
                ],
              ),
            ),
          ),

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
    );
  }

  void couponEmptyAlert() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.yellow[50],
        content:Wrap(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Text('Coupon is Not available,Please add ...',
                    style: TextStyle(color: Colors.black54),),
                ],
              ),
            )
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
              gotoCouponScreen();
              // Navigator.push(context, MaterialPageRoute(builder: (context) => Vendor_add_Coupen_code(Vendor_id: admin_auto_id,)));
            },
            child: const Text("Ok",
                style: TextStyle(color: Colors.white,fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(70,30),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
              ),
            ),
          )
        ],),
    );
  }

  gotoCouponScreen(){
    routes = MaterialPageRoute(builder: (context) => Vendor_add_Coupen_code(Vendor_id: admin_auto_id));
    Navigator.push(context, routes).then(onGoBackFromCart);
  }

  FutureOr onGoBackFromCart(dynamic value) {
    getCouponList();
    if(this.mounted) {
      setState(() {});
    }
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    iscouponavailable=false;
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var searchDetail in cuponcodeList) {
      late String TitleFromList = searchDetail.coupenCode.toLowerCase(),
          TitleFromResult = text.toLowerCase();
      print(TitleFromList + "" + TitleFromResult);
      if (TitleFromList==TitleFromResult) {
        iscouponavailable=true;
        _searchResult.add(searchDetail);
        setState(){}
      }
    }
    setState(() {});
  }

  couponCard(CuponcodeList cuponcodeList){
    return GestureDetector(
      onTap: ()=>{
         },
      child:
      Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        child:Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(cuponcodeList.coupenCode,
                    style: const TextStyle(color: Colors.black87,fontSize: 17,fontWeight: FontWeight.bold),)  ,
                  const SizedBox(height: 5,),

                  Text('Get upto '+cuponcodeList.coupenCodeValue+ ' off',
                    style: const TextStyle(color: Colors.black87,fontSize: 13),)  ,
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: const Text('Apply',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blueAccent,fontSize: 11,
                          fontWeight: FontWeight.bold),),
                    onPressed: ()=> {
                      widget.onSaveCallback(cuponcodeList),
                      Navigator.pop(context)
                    },
                  )
              ),
            )
          ],
        ),
      )
    );
  }

  getCouponList() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "admin_auto_id": admin_auto_id
    };

    var url = baseUrl+'api/' + get_all_coupen_code_list;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
   // print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      //print("status=>"+status.toString());
      if (status == 1) {
        AllCouponModel allCouponModel=AllCouponModel.fromJson(json.decode(response.body));
        cuponcodeList=allCouponModel.allCuponcodeList;
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');
    String? userType =prefs.getString('user_type');

    if(baseUrl!=null && userId != null && adminId!=null && userType!=null){
      this.baseUrl=baseUrl;
      this.admin_auto_id = adminId;
      user_id = userId;
      this.userType=userType;
      getCouponList();
    }
  }
}
