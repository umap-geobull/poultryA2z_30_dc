import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Cart/model/user_address_model.dart';
import '../../../../Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';

import '../../profile/components/address/add_new_address.dart';


typedef OnSaveCallback = void Function(UserAddressDetails userAddressDetails);

class SelectAddress extends StatefulWidget {

  OnSaveCallback onSaveCallback;

  SelectAddress(this.onSaveCallback);

  @override
  _SelectAddress createState() => _SelectAddress();
}

class _SelectAddress extends State<SelectAddress> {
  bool isApiCallProcessing=false;
  String baseUrl='',admin_auto_id='';
  String user_id='';

  String address_id='';

  List<UserAddressDetails> userAddressDetails=[];

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');

    if(baseUrl!=null && userId!=null && adminId!=null){
      this.baseUrl=baseUrl;
      user_id=userId;
      this.admin_auto_id=adminId;

      setState(() {
        getUserAddress();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
  }

  void getUserAddress() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body = {
      "user_auto_id": user_id,
      "admin_auto_id" : admin_auto_id,
    };

    var url=baseUrl+'api/'+get_user_address;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        UserAddressModel userAddressModel=UserAddressModel.fromJson(json.decode(response.body));
        userAddressDetails=userAddressModel.userAddressDetails;
      }
      else{
        userAddressDetails=[];
      }

      if(mounted){
        setState(() {});
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: StatefulBuilder(builder: (context, setState) {
          return Material(
              child: SingleChildScrollView(
                controller: ModalScrollController.of(context),
                child: AnimatedPadding(
                    padding: MediaQuery.of(context).viewInsets,
                    duration: const Duration(milliseconds: 100),
                    child:SizedBox(
                      height: 400,
                      width: MediaQuery.of(context).size.width,
                      child:Stack(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: IconButton(
                                      onPressed: ()=>{
                                        onBackPressed()
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                                  ),
                                  const Text(
                                    'Select Delivery Address',style: TextStyle(color: Colors.black87,fontSize: 14),
                                  ),
                                  Expanded(
                                    flex:1,
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                         child: Container(
                                            width: 100,
                                            height: 50,
                                            alignment: Alignment.bottomCenter,
                                            child: GestureDetector(
                                                onTap: ()=>{
                                                  goToAddAddress()
                                                },
                                                child:Container(
                                                  alignment: Alignment.center,
                                                  height: 35,
                                                  width: MediaQuery.of(context).size.width,
                                                  margin: const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(
                                                          color: Colors.black45,
                                                          width: 1
                                                      )
                                                  ),
                                                  child: const Text('+ Address',
                                                    style: TextStyle(color: Colors.black87,fontSize: 17),),
                                                )
                                            ),
                                          )
                                  ))

                                ],
                              ),

                              Expanded(
                                flex: 1,
                                  child: ListView.builder(
                                  itemCount: userAddressDetails.length,
                                  itemBuilder: (context, index) => addressCard(
                                      userAddressDetails[index])
                              )),
                            ],
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
                    )),
              )
          );
        }
        ),
        onWillPop: ()=>onBackPressed()
    );
  }

  addressCard(UserAddressDetails userAddressDetails){
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: ()=>{
          saveAddressSession(userAddressDetails)
        },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 10,right: 10,top: 5),
                child: Icon(Icons.circle,size: 10,
                color: address_id==userAddressDetails.id?
                Colors.green:
                Colors.grey,),
              ),
              Expanded(
                flex: 1,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(userAddressDetails.name,
                          style: const TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.bold),),
                        Text(userAddressDetails.addressDetails+', '+userAddressDetails.area,
                          style: const TextStyle(color: Colors.black54,fontSize: 14),),
                        Text(userAddressDetails.city+', '+userAddressDetails.pincode,
                          style: const TextStyle(color: Colors.black54,fontSize: 14),),
                        Text(userAddressDetails.mobileNo,style: const TextStyle(color: Colors.black54,fontSize: 14),),
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
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                          height: 10,
                        )
                      ],
                    ),
                  )
              )
            ],
          ),
      ),
    );
  }

  goToAddAddress(){
    Route routes = MaterialPageRoute(builder: (context) => AddNewAddress());
    Navigator.push(context, routes).then(onGoBack);

  }

  FutureOr onGoBack(dynamic value) {
    getUserAddress();
  }

  onBackPressed() async{
    Navigator.pop(context);
  }

  Future<void> saveAddressSession(UserAddressDetails userAddressDetails) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();

    bool result = await prefs.setString('user_address', jsonEncode(userAddressDetails));

    if(result==true){
      widget.onSaveCallback(userAddressDetails);
      print("set");
    }
  }
}

