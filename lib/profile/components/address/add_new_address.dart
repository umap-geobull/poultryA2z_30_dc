import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Admin_add_Product/constants.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';


class AddNewAddress extends StatefulWidget {


  @override
  _AddNewAddress createState() => _AddNewAddress();
}

Future<void> deleteData(String addressId) async {

}
class _AddNewAddress extends State<AddNewAddress> {
  late String cname, mobile, pincode, area, latitude='1.2546', longitude='2.4586',city,state='Maharashtra',country='India',address,addtype='Home';

  TextEditingController tv_name = TextEditingController();
  TextEditingController tv_mobile = TextEditingController();
  TextEditingController tv_pincode = TextEditingController();
  TextEditingController tv_address = TextEditingController();
  TextEditingController tv_area = TextEditingController();
  // TextEditingController tv_latitude = TextEditingController();
  // TextEditingController tv_longitude = TextEditingController();
  TextEditingController tv_city = TextEditingController();
  TextEditingController tv_state = TextEditingController();
  TextEditingController tv_country = TextEditingController();
  TextEditingController tv_address_type = TextEditingController();


  String user_id='';
  String baseUrl='', admin_auto_id='';
  bool isApiCallProcessing=false;

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
        });
      }
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
          title: const Text("Add New Address", style: TextStyle(color: appBarIconColor, fontSize: 18, fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(Icons.arrow_back, color: appBarIconColor),
          )
      ),
      body: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                    /*  Container(
                        margin: EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: Text('Select location from map',style: TextStyle(color: Colors.white,fontSize: 15),),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orangeAccent,
                          ),
                        ),
                      ),
*/
                      const SizedBox(height: 15),

                      SizedBox(
                        height: 50,
                        child: TextField(
                          // maxLines: 1,
                          controller: tv_name,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            labelText: "Full Name",
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 70,
                        child: TextField(
                          maxLength: 10,
                          controller: tv_mobile,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            labelText: "Mobile No.",
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(),
                            // hintText: 'Mobile No.',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: tv_pincode,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            // prefixIcon: Icon(Icons.description),
                            border: OutlineInputBorder(),
                            labelText: 'Pincode',
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: tv_area,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            // prefixIcon: Icon(Icons.description),
                            border: OutlineInputBorder(),
                            labelText: 'Area',
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(height: 15),

                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: tv_city,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            // prefixIcon: Icon(Icons.description),
                            border: OutlineInputBorder(),
                            labelText: 'City',
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(height: 15),

                     /* SizedBox(
                        height: 50,
                        child: TextField(
                          controller: tv_state,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            // prefixIcon: Icon(Icons.description),
                            border: OutlineInputBorder(),
                            labelText: 'State',
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(height: 15),

                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: tv_country,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            // prefixIcon: Icon(Icons.description),
                            border: OutlineInputBorder(),
                            labelText: 'Country',
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(height: 15),*/

                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: tv_address,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              // prefixIcon: Icon(Icons.description),
                              border: OutlineInputBorder(),
                              labelText: 'Address Details'),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 0,
                            right: 0,
                            top: 5,
                            bottom: 5),
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Address Type:',
                              style:
                              TextStyle(color: Colors.black87, fontSize: 14),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [

                                Expanded(
                                  child: RadioListTile(
                                      dense: true,
                                      title: const Text('Home'),
                                      value: 'Home',
                                      groupValue: addtype,
                                      onChanged: (value) {
                                        setState(() {
                                          addtype = value.toString();
                                        });
                                      }),
                                  flex: 2,),
                                Expanded(
                                  child:  RadioListTile(
                                      dense: true,
                                      title: const Text('Office'),
                                      value: 'Office',
                                      groupValue: addtype,
                                      onChanged: (value) {
                                        setState(() {
                                          addtype = value.toString();
                                        });
                                      }
                                      ),

                                  flex: 2,)
                                ,
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: () {
                          if(checkValidations()==true){
                            addUserAddress();
                          }
                        },
                        child: const Text('Save'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150,50),
                          primary: Colors.deepOrangeAccent,
                          shape: const StadiumBorder(),
                          shadowColor: Colors.grey,
                          elevation: 5,
                        ),
                      ),
                    ],
                  )),

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
          ]),
    );
  }

  addUserAddress() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    var url = Uri.parse(baseUrl+'api/'+add_user_address);

    final body = {
      "user_auto_id": user_id,
      "name": tv_name.text,
      "mobile_no":tv_mobile.text,
      "pincode":tv_pincode.text,
      "latitude": latitude,
      "longitude": longitude,
      "area": tv_area.text,
      "city": tv_city.text,
      "state": state,
      "country": country,
      "address_details": tv_address.text,
      "address_type": addtype,
      "admin_auto_id":admin_auto_id,
    };
    var response = await http.post(url,body: body);

    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      String status = resp['status'];

      if(status=="1"){
        Fluttertoast.showToast(
          msg: 'Address added successfully',
          backgroundColor: Colors.black,
        );

        Navigator.of(context).pop();
      }
      else{
        String  msg = resp['msg'];
        Fluttertoast.showToast(
          msg:msg,
          backgroundColor: Colors.black,
        );
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  bool checkValidations(){

    if(tv_name.text.isEmpty){
      Fluttertoast.showToast(
        msg: 'Please add name',
        backgroundColor: Colors.black,
      );
      return false;
    }
    else  if(tv_mobile.text.isEmpty){
      Fluttertoast.showToast(
        msg: 'Please add mobile number',
        backgroundColor: Colors.black,
      );
      return false;
    }
    else  if(tv_pincode.text.isEmpty){
      Fluttertoast.showToast(
        msg: 'Please add pincode',
        backgroundColor: Colors.black,
      );
      return false;
    }
    else  if(tv_city.text.isEmpty){
      Fluttertoast.showToast(
        msg: 'Please add city',
        backgroundColor: Colors.black,
      );
      return false;
    }
    else  if(tv_address.text.isEmpty){
      Fluttertoast.showToast(
        msg: 'Please add address details',
        backgroundColor: Colors.black,
      );
      return false;
    }
    return true;
  }
}
