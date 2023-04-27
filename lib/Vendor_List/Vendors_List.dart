import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Vendor_List/VendorList_Model.dart';
import 'package:poultry_a2z/Vendor_Module/Vendor_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import '../Customer_List/Rest_Apis.dart';
import '../Utils/constants.dart';

class Vendors_List extends StatefulWidget {
  @override
  Vendors_ListState createState() => Vendors_ListState();
}

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(
        child: Text("Block", style: TextStyle(color: Colors.red),),
        value: "Block"),
    DropdownMenuItem(child: Text("Unblock"), value: "Unblock"),
  ];
  return menuItems;
}

void _showMyDialog(BuildContext context, String product_id) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text('Do you want to change status?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              print('Confirmed');
              // deleteData(product_id);
              CircularProgressIndicator();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class Vendors_ListState extends State<Vendors_List> {
  late List<GetVendorLists> Vendorlist=[];
  String selectedValue = "";
  bool isloading=false;
  String baseUrl='';

  @override
  void initState() {
    super.initState();

    getBaseUrl();
  }

  void get_Vendor_Sales_Report_Data() async {
    if (mounted) {
      setState(() {
        isloading = true;
        print('isapicall=' + isloading.toString());
      });
    }
    Rest_Apis restApis = Rest_Apis();
    restApis.getVendorsList(baseUrl).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            isloading = false;
            print('isapicall=' + isloading.toString());
          });
        }

        VendorList_Model vendorList_Model = value;

        if(vendorList_Model.status==1){
          Vendorlist = vendorList_Model.getVendorLists;
          if(this.mounted){
            setState(() {});
          }
        }
      }
    });
  }

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if(baseUrl!=null){
      this.baseUrl=baseUrl;
      print(baseUrl);
      if(this.mounted){
        setState(() {
          get_Vendor_Sales_Report_Data();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text("All Vendors",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body:Stack(
        children: <Widget>[
          Vendorlist.isNotEmpty?
          Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.2,
                  width: 1000,
                  child: Column(
                    children: [
                      Container(
                          height: 55,
                          padding: EdgeInsets.all(10),
                          //  color: Colors.black12,
                          child: Row(children: [
                            Expanded(
                              child: Text(
                                'Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                    color: Colors.black, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                              flex: 3,
                            ),
                            Expanded(
                                child: Text(
                                  'Email',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black, fontSize: 14),
                                    textAlign: TextAlign.center,
                                ),
                                flex: 3),
                            Expanded(
                                child: Text(
                                  'Mobile No.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                                flex: 2),
                            Expanded(
                                child: Text(
                                  'Have Retail Shop',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                                flex: 2),
                            Expanded(
                                child: Text(
                                  'Update on whatsapp',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                                flex: 2),
                            Expanded(
                                child: Text(
                                  'Register \nDate',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                                flex: 2),
                            Expanded(
                                child: Text(
                                  'Status',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                                flex: 2),
                            Expanded(
                                child: Text(
                                  'View\nDetails',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                                flex: 2)
                          ])),
                      Divider(height: 2,),
                      Expanded(
                          child: ListView.builder(
                              itemCount: Vendorlist.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    //height: 35,
                                    margin: EdgeInsets.only(
                                        left: 2, right: 2 ),
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10),
                                       /* left: 2, right: 2, top: 2, bottom: 2),
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 2, bottom: 2),*/
                                    // color: Colors.white,
                                    child:Column(
                                      children: <Widget>[
                                        Container(
                                          child: Row(children: [
                                            Expanded(
                                              child:Container(
                                                child: Text(
                                                  Vendorlist[index].name,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      //fontWeight: FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                margin: EdgeInsets.only(left: 5,right: 5),
                                              ),
                                              flex: 3,
                                            ),
                                            Expanded(
                                                child:Container(
                                                  margin: EdgeInsets.only(left: 5,right: 5),
                                                  child: Text(
                                                    Vendorlist[index].emailId,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                       // fontWeight: FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                flex: 3
                                            ),
                                            Expanded(
                                                child:Container(
                                                  margin: EdgeInsets.only(left: 5,right: 5),
                                                  child: Text(
                                                    Vendorlist[index].mobileNumber,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                       // fontWeight: FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                flex: 2),
                                            Expanded(flex: 2,

                                              child: Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.only(left: 5,right: 5),
                                                child: Text(
                                                  Vendorlist[index].haveRetailShop,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                     // fontWeight: FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                child:Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(left: 5,right: 5),
                                                  child: Text(
                                                    Vendorlist[index].updateOnWhatsapp,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                      //  fontWeight: FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                flex: 2),
                                            Expanded(
                                                child:Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(left: 5,right: 5),
                                                  child: Text(
                                                    Vendorlist[index].registerDate,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                       // fontWeight: FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                flex: 2),
                                            Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(left: 5,right: 5),
                                                  width: 30,
                                                  height: 50,
                                                  child: DropdownButton(
                                                    value: selectedValue =
                                                        Vendorlist[index].status,
                                                    items: dropdownItems,
                                                    onChanged: (String? value) {
                                                      changeVendorStatus(Vendorlist[index].id,value!);
                                                      updateStatus(Vendorlist[index].id, Vendorlist[index].userType, value!);
                                                      // selectedValue=value;
                                                      //   _showMyDialog(context,value);
                                                      // );
                                                    },
                                                  ),
                                                )// Text(data[index].status, style: TextStyle(
                                                //     fontSize: 14,
                                                //     fontWeight: FontWeight.bold,color: Colors.black45),)
                                                ,
                                                flex: 2),
                                            Expanded(
                                                child:
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                                        Vendor_details(Vendorlist[index].id)),);
                                                  },
                                                  child: Container(
                                                   // margin: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.white,
                                                        width: 10,
                                                      ),
                                                        color: Colors.orangeAccent,
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                    alignment: Alignment.center,
                                                    width: 30,
                                                    height: 50,
                                                    child: Text('View',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                                                        fontSize: 15),),
                                                  ),
                                                ),
                                                flex: 2),
                                          ]
                                          ),
                                        ),
                                        Divider(height: 2,)
                                      ],
                                    ));
                              })
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ):
          Container(),

          isloading == false && Vendorlist.isEmpty ?
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.height,
            height: MediaQuery.of(context).size.width,
            child: Text('No Vendors')):
          Container(),

          isloading == true ?
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.height,
            height: MediaQuery.of(context).size.width,
            child: const GFLoader(type: GFLoaderType.circle),):
          Container()
        ],
      )
    );
  }

  changeVendorStatus(String id, String status){
    Vendorlist.forEach((element) {
      if(element.id==id){
        if(this.mounted){
          element.status=status;
        }
      }
    });
  }

  void updateStatus(String user_id, String user_type,String status) async {
    print(' in update status');

    if(this.mounted){
      setState(() {
        isloading=true;
      });
    }
    Rest_Apis restApis = Rest_Apis();
    restApis.updateStatus(baseUrl,user_id,user_type,status).then((value) {
      if (value != null) {
        if(value==1){
          print('update success');

          get_Vendor_Sales_Report_Data();
        }
      }
    });
  }
}
