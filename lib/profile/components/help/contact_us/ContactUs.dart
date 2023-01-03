import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../Utils/App_Apis.dart';
import 'Edit_Contactus.dart';
import 'ContactUsModel.dart';
import 'package:url_launcher/url_launcher.dart';


class Contactus extends StatefulWidget {
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;

  Contactus(this.appBarColor, this.appBarIconColor, this.primaryButtonColor,
      this.secondaryButtonColor);

  @override
  State<Contactus> createState() => ContactusState(appBarColor,appBarIconColor,primaryButtonColor,secondaryButtonColor);
}

class ContactusState extends State<Contactus> {
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;


  ContactusState(this.appBarColor, this.appBarIconColor, this.primaryButtonColor,
      this.secondaryButtonColor);


  TextEditingController tv_name = TextEditingController();
  TextEditingController tv_email = TextEditingController();
  TextEditingController tv_mobile = TextEditingController();
  late ContactUs_Model contactUs_Model;

  late String contact_id='',contact_address='',
      contact_email='',
      contact_mobile='';
  bool isloading=false;
  String user_id='';
  String user_type='';
  String baseUrl='', admin_auto_id='';

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? userType =prefs.getString('user_type');
    String? baseUrl =prefs.getString('base_url');
    String? adminId =prefs.getString('admin_auto_id');

    if(userId!=null && userType!=null){
      user_id=userId;
      user_type=userType;

      if(mounted){
        setState(() {});
      }
    }

    if (baseUrl!=null && adminId!=null) {
      if(mounted){
        setState(() {
          this.baseUrl=baseUrl;
          this.admin_auto_id = adminId;
          getContactUs();
        });
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text("Contact Us", style: TextStyle(color: appBarIconColor, fontSize: 18, fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: Icon(Icons.arrow_back, color: appBarIconColor),
          ),

            actions: [
              user_type=='Admin'?
              IconButton(
                onPressed: () {
                  goToEdit();
                },
                icon: Icon(
                  Icons.edit,
                  color: appBarIconColor,
                ),
              ):
              Container(),
            ]
        ),
        body:Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 20),
              // color: Colors.white,
              child: Column(
                children: [

                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 5),
                    child: const Text(
                        'You can reach our customer support team to address any of your queries or complaints related to product',
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45)),
                  ),


                  SizedBox(height: 20,),

                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //mb no
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.call, color: Colors.black,size: 16,),
                            const SizedBox(width: 10,),
                            const Text('Contact Number', style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black)),
                          ],
                        ),
                        SizedBox(height: 10,),
                        contact_mobile.isNotEmpty?
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('India:', style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                            SizedBox(width: 10,),
                            InkWell(
                              onTap: ()=>{
                                _makePhoneCall(contact_mobile)
                              },
                              child: Text(contact_mobile, style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline)),
                            )
                          ],
                        ):
                        Container(),

                        const Divider(
                          thickness: 1,
                          // thickness of the line
                          indent: 20,
                          // empty space to the leading edge of divider.
                          endIndent: 20,
                          // empty space to the trailing edge of the divider.
                          color: Colors.black12,
                          // The color to use when painting the line.
                          height: 30, // The divider's height extent.
                        ),

                        //SizedBox(height: 20,),

                        //email
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.email, color: Colors.black,size: 16,),
                            const SizedBox(width: 10,),
                            const Text('Email ID', style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                          ],
                        ),
                        SizedBox(height: 10,),
                        InkWell(
                          onTap: ()=>{
                            _sendMail(contact_email)
                          },
                          child: Text(contact_email, style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              decoration: TextDecoration.underline)),
                        ),

                        // SizedBox(height: 20,),
                        const Divider(
                          thickness: 1,
                          // thickness of the line
                          indent: 20,
                          // empty space to the leading edge of divider.
                          endIndent: 20,
                          // empty space to the trailing edge of the divider.
                          color: Colors.black12,
                          // The color to use when painting the line.
                          height: 30, // The divider's height extent.
                        ),

                        //address
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on_rounded,color: Colors.black,size: 16,),
                            const SizedBox(width: 10,),
                            const Text('Address', style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Text(contact_address,style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.black)
                        ),
                      ],
                    ),
                  ),
                  // )
                ],
              ),
            ),


            isloading==true?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: const GFLoader(
                  type:GFLoaderType.circle
              ),
            ):
            Container()
          ],
        )
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text("Contact Us", style: TextStyle(color: appBarIconColor, fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: Icon(Icons.arrow_back, color: appBarIconColor),
        ),
        actions: [
          user_type=='Admin'?
          IconButton(
            onPressed: () {
              goToEdit();
            },
            icon: Icon(
              Icons.edit,
              color: appBarIconColor,
            ),
          ):
          Container()
        ],
      ),
      body:Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 20),
            // color: Colors.white,
            child: Column(
              children: [
               Container(
                  margin: const EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 5),
                  child: const Text(
                      'You can reach our customer support team to address any of your queries or complaints related to product and services on below ',
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45)),
                ),
                const Divider(
                  thickness: 1,
                  // thickness of the line
                  indent: 20,
                  // empty space to the leading edge of divider.
                  endIndent: 20,
                  // empty space to the trailing edge of the divider.
                  color: Colors.black12,
                  // The color to use when painting the line.
                  height: 15, // The divider's height extent.
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height:50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.call, color: Colors.black45,size: 20,),
                              const SizedBox(width: 10,),
                              const Text('Call us on:', style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45)),
                              const SizedBox(width: 10,),
                              Text(contact_mobile, style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87))
                            ],
                          )
                      ),
                      SizedBox(
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.email, color: Colors.black45,),
                              const SizedBox(width: 10,),
                              const Text('Email us at :', style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45)),
                              const SizedBox(width: 10,),
                              Text(contact_email, style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87))
                            ],
                          )
                      ),
                      SizedBox(
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on_rounded,color: Colors.black45,),
                              const SizedBox(width: 10,),
                              const Text('Address :', style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45)),
                              const SizedBox(width: 10,),
                              Text(contact_address,style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87))
                            ],
                          )
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  // thickness of the line
                  indent: 20,
                  // empty space to the leading edge of divider.
                  endIndent: 20,
                  // empty space to the trailing edge of the divider.
                  color: Colors.black12,
                  // The color to use when painting the line.
                  height: 15, // The divider's height extent.
                ),

                // )
              ],
            ),
          ),


          isloading==true?
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: const GFLoader(
                type:GFLoaderType.circle
            ),
          ):
          Container()
        ],
      )
    );
  }
*/

  goToEdit(){
    Route routes = MaterialPageRoute(builder: (context) => Edit_Contactus(contact_id,contact_mobile,contact_email,contact_address));
    Navigator.push(context, routes).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    getContactUs();
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  getContactUs() async {
    if(mounted){
      setState(() {
        isloading=true;
      });
    }

    var url = baseUrl+'api/' + Show_Contact_Details;

    Uri uri=Uri.parse(url);

    final body={
      "admin_auto_id" : admin_auto_id,
    };

    final response = await http.post(uri,body: body);

    print(response.toString());
    if (response.statusCode == 200) {
      isloading=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        contactUs_Model = ContactUs_Model.fromJson(json.decode(response.body));
        var mainList = contactUs_Model.allcontactDetails;

        if(mounted){
          setState(() {
            contact_id=mainList[0].id;
            contact_mobile = mainList[0].contact;
            contact_email = mainList[0].email;
            contact_address = mainList[0].address;
            isloading=false;
          });
        }
      }
      else {
        if(mounted){
          setState(() {
            contact_id='';
            contact_mobile = '';
            contact_email ='';
            contact_address = '';
            isloading=false;
          });
        }
      }

      if(mounted){
        setState(() {});
      }
    }

    else if(response.statusCode==500){
      if(mounted){
        setState(() {
          isloading=false;
          Fluttertoast.showToast(
            msg: 'Server error',
            backgroundColor: Colors.grey,
          );
        });
      }
    }
  }


  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _sendMail(String mail_id) async {
    final mailtoUri = Uri(
      scheme: 'mailto',
      path: mail_id,
    );

    await launchUrl(mailtoUri);
  }

}
