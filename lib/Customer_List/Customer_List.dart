import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Customer_List/CustomerList_Model.dart';
import 'package:poultry_a2z/Customer_List/Customer_order_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import '../Customer_List/Rest_Apis.dart';
import '../Utils/constants.dart';

class Customer_List extends StatefulWidget {
  @override
  Customer_ListState createState() => Customer_ListState();
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

class Customer_ListState extends State<Customer_List> {
  List<GetCustomerLists> CustomerList = [];
  bool isloading=false;
  String baseUrl='', admin_auto_id='';

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');

    if(baseUrl!=null && userId!=null && adminId!=null){
      if(this.mounted){
        this.admin_auto_id=adminId;
        this.baseUrl=baseUrl;
        get_Custoemrs();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getBaseUrl();
  }

  void get_Custoemrs() async {
    if (mounted) {
      setState(() {
        isloading = true;
        print('isapicall=' + isloading.toString());
      });
    }
    Rest_Apis restApis = Rest_Apis();
    restApis.getCustomersList(baseUrl, admin_auto_id).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            isloading = false;
            CustomerList = value;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text("All Customers",
              style: TextStyle(color: Colors.black, fontSize: 18)),
          leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        body:Stack(
        children: <Widget>[
          CustomerList.isNotEmpty?
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
                                textAlign: TextAlign.left,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                                child: Text(
                                  'Email',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, fontSize: 14),
                                  textAlign: TextAlign.left,
                                ),
                                flex: 3),
                            Expanded(
                                child: Text(
                                  'Mobile No.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, fontSize: 14),
                                  textAlign: TextAlign.left,
                                ),
                                flex: 2),
                            // Expanded(
                            //     child: Text(
                            //       'Have Retail Shop',
                            //       style: TextStyle(
                            //           fontWeight: FontWeight.bold,
                            //           color: Colors.black, fontSize: 15),
                            //       textAlign: TextAlign.center,
                            //     ),
                            //     flex: 2),
                            // Expanded(
                            //     child: Text(
                            //       'Update on whatsapp',
                            //       style: TextStyle(
                            //           fontWeight: FontWeight.bold,
                            //           color: Colors.black, fontSize: 14),
                            //       textAlign: TextAlign.center,
                            //     ),
                            //     flex: 2),
                            //
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
                                  textAlign: TextAlign.left,
                                ),
                                flex: 2),
                            Expanded(
                                child: Text(
                                  'View\nOrders',
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
                              itemCount: CustomerList.length,
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
                                                  CustomerList[index].name,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      //fontWeight: FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                margin: EdgeInsets.only(left: 5,right: 5),
                                              ),
                                              flex: 2,
                                            ),
                                            Expanded(
                                                child:Container(
                                                  margin: EdgeInsets.only(left: 5,right: 5),
                                                  child: Text(
                                                    CustomerList[index].emailId,
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
                                                    CustomerList[index].mobileNumber,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        // fontWeight: FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                flex: 2),
                                            // Expanded(flex: 2,
                                            //   child: Container(
                                            //     alignment: Alignment.center,
                                            //     margin: EdgeInsets.only(left: 5,right: 5),
                                            //     child: Text(
                                            //       CustomerList[index].haveRetailShop,
                                            //       style: TextStyle(
                                            //           fontSize: 14,
                                            //           // fontWeight: FontWeight.bold,
                                            //           color: Colors.black),
                                            //     ),
                                            //   ),
                                            // ),
                                            // Expanded(
                                            //     child:Container(
                                            //       alignment: Alignment.center,
                                            //       margin: EdgeInsets.only(left: 5,right: 5),
                                            //       child: Text(
                                            //         CustomerList[index].updateOnWhatsapp,
                                            //         style: TextStyle(
                                            //             fontSize: 14,
                                            //             //  fontWeight: FontWeight.bold,
                                            //             color: Colors.black),
                                            //       ),
                                            //     ),
                                            //     flex: 2),
                                            Expanded(
                                                child:Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(left: 5,right: 5),
                                                  child: Text(
                                                    CustomerList[index].registerDate,
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
                                                    value: CustomerList[index].status,
                                                    items: dropdownItems,
                                                    onChanged: (String? value) {
                                                      changeVendorStatus(CustomerList[index].id,value!);
                                                      updateStatus(CustomerList[index].id, CustomerList[index].userType, value);
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
                                                    Navigator.of(context).push(MaterialPageRoute(builder:
                                                        (context) => Customer_OrderScreen(CustomerList[index].id)),);
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

          isloading == false && CustomerList.isEmpty ?
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.height,
            height: MediaQuery.of(context).size.width,
            child: Text('No Customers')):
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
    CustomerList.forEach((element) {
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

          get_Custoemrs();
        }
      }
    });
  }
}
