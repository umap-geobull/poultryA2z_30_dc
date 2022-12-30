import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/profile/components/address/edit_address.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../Cart/model/user_address_model.dart';
import '../../../Utils/App_Apis.dart';
import 'package:getwidget/getwidget.dart';
import 'add_new_address.dart';


class MyAddress extends StatefulWidget {
  @override
  State<MyAddress> createState() => MyAddressState();
}

class MyAddressState extends State<MyAddress> {
  String user_id='';
  String baseUrl='', admin_auto_id='';
  bool isApiCallProcessing=false;

  List<UserAddressDetails> userAddressDetails=[];
  List dropdownItemList = [
    {'label': 'Edit', 'value': '1'}, // label is required and unique
    {'label': 'Delete', 'value': '2'},
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? baseUrl =prefs.getString('base_url');
    String? adminId =prefs.getString('admin_auto_id');

    if (baseUrl!=null && userId != null && adminId!=null) {
      if(mounted){
        setState(() {
          user_id = userId;
          this.baseUrl=baseUrl;
          this.admin_auto_id=adminId;

          getAddressList();
        });
      }
    }
    return null;
  }

  getAddressList() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "user_auto_id": user_id,
      "admin_auto_id":admin_auto_id,
    };

    print('User_id: '+user_id);

    var url = baseUrl+'api/' + get_user_address;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        UserAddressModel userAddressModel=UserAddressModel.fromJson(json.decode(response.body));
        userAddressDetails=userAddressModel.userAddressDetails;
      }
      else {
        userAddressDetails=[];
      }

      if(mounted){
        setState(() {});
      }
    }
    else if(response.statusCode==500){
      if(mounted){
        setState(() {
          isApiCallProcessing=false;
          Fluttertoast.showToast(
            msg: 'Server error',
            backgroundColor: Colors.grey,
          );
        });
      }
    }
  }

  deleteAddress(String addressAutoId) async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "user_auto_id": user_id,
      "address_auto_id": addressAutoId,
      "admin_auto_id":admin_auto_id,
    };

    print('User_id: '+user_id);

    var url = baseUrl+'api/' + delete_user_address;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        getAddressList();
      }
      else {
        String  msg = resp['msg'];
        Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.grey,
        );
      }

      if(mounted){
        setState(() {});
      }
    }
    else if(response.statusCode==500){
      if(mounted){
        setState(() {
          isApiCallProcessing=false;
          Fluttertoast.showToast(
            msg: 'Server error',
            backgroundColor: Colors.grey,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: appBarColor,
            title: const Text("My Address", style: TextStyle(color: appBarIconColor, fontSize: 18, fontWeight: FontWeight.bold)),
            leading: IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(Icons.arrow_back, color: appBarIconColor),
            ),
            actions: [
              IconButton(
                  onPressed: ()=>{
                    goToAddAddress()
                  },
                  icon: const Icon(Icons.add_location_alt,color: appBarIconColor,))
            ]
        ),
        body:Stack(
          children: <Widget>[
            Container(
                margin: const EdgeInsets.all(5),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: userAddressDetails.length,
                    itemBuilder: (BuildContext context, int index) {
                      return addressCard(userAddressDetails[index]);
                    }
                    )
            ),

            isApiCallProcessing==false && userAddressDetails.isEmpty?
            Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('No address added',style: TextStyle(color: Colors.black,fontSize: 15),),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1,
                            color: Colors.grey.shade300
                        )
                    ),
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child:GestureDetector(
                      onTap: ()=>{
                        goToAddAddress()
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(2),
                              child: Icon(
                                Icons.add_location,
                                size: 15, color: Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text('Add Address',
                              style:
                              TextStyle(fontSize: 14, color: Colors.blue)),
                        ],
                      ),
                    ),
                  )
                ],
              )
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
        ));
  }

  goToAddAddress(){
    Route routes = MaterialPageRoute(builder: (context) => AddNewAddress());
    Navigator.push(context, routes).then(onGoBack);

  }

  goToEditAddress(UserAddressDetails addressDetails){
    Route routes = MaterialPageRoute(builder: (context) => EditAddress(addressDetails));
    Navigator.push(context, routes).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    getAddressList();
  }

  void _showDeleteDialog(BuildContext context, String addressId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Confirm'),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text('Do you want to remove this address?'),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Confirm'),
              onPressed: () {
                print('Confirmed');
                print(addressId);
                deleteAddress(addressId);
                const CircularProgressIndicator();
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  addressCard(UserAddressDetails userAddressDetails){
    return
      Card(
          shadowColor: Colors.orangeAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 10,
          child:Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 60,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color:
                            userAddressDetails.addressType=='Home'?
                            Colors.orangeAccent:
                            Colors.blue,
                            width: 2
                        )
                    ),
                    child: Text(userAddressDetails.addressType,
                      textAlign:TextAlign.center,style: const TextStyle(fontSize: 13,color: Colors.black,),),
                  ),
                ),
                Text(userAddressDetails.name,
                  style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                Text(userAddressDetails.addressDetails+', '+userAddressDetails.area,
                  style: const TextStyle(color: Colors.black54,fontSize: 14),),
                Text(userAddressDetails.city+', '+userAddressDetails.pincode,
                  style: const TextStyle(color: Colors.black54,fontSize: 14),),
                Text(userAddressDetails.mobileNo,style: const TextStyle(color: Colors.black54,fontSize: 14),),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child:
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1,
                                  color: Colors.grey.shade300
                              )
                          ),
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child:GestureDetector(
                            onTap: ()=>{
                              goToEditAddress(userAddressDetails)
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.edit,
                                      size: 15, color: Colors.blue,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text('Edit',
                                    style:
                                    TextStyle(fontSize: 14, color: Colors.blue)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1,
                                  color: Colors.grey.shade300
                              )
                          ),
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child:GestureDetector(
                            onTap: ()=>{
                              _showDeleteDialog(context, userAddressDetails.id)
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.delete, color: Colors.red,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text('Delete',
                                    style:
                                    TextStyle(fontSize: 14, color: Colors.red)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

/*                  Container(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 150,
                          height: 30,
                          child: TextButton.icon(
                              label: Text(
                                'Update location',
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.orangeAccent),
                              ),
                              icon: Icon(
                                Icons.edit_location_alt,color: Colors.amber,),
                              onPressed: () {}),
                        )),
                  )*/
              ],
            ),
          ));
  }
}
