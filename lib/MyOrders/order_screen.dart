import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/MyOrders/Order_Details.dart';
import 'package:poultry_a2z/MyOrders/return_order_bottomsheet.dart';
import 'package:poultry_a2z/RatingReview/AddReview.dart';
import 'package:poultry_a2z/RatingReview/EditReview.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import '../Utils/coustom_bottom_nav_bar.dart';
import '../Utils/enums.dart';
import 'Order_HistoryModel.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'cancel_order_bottomsheet.dart';

class OrderScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => OrderScreenState();
}

class OrderScreenState extends State<OrderScreen> {
  bool isApiCallProcessing=false,isServerError=false;
  String user_id='',select_color='Select Color Name';
  String baseUrl='', admin_auto_id='',app_type_id='';

  static const String RECEIVED='Received';
  static const String ACCEPTED='Accept';
  static const String REJECTED='Reject';
  static const String PREPARED='Prepared';
  static const String DISPATCHED='Dispatched';
  static const String CANCELLED='Cancelled';
  static const String COMPLETED='Completed';
  static const String RETURNED='Returned';


  List<OrderHistory> orderHistory=[];

  Color appBarColor=Colors.white,appBarIconColor=Colors.black;
  Color bototmBarColor=Colors.white, bottomMenuIconColor=Color(0xFFFF7643);

  void getappUi() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? appBarColor =prefs.getString('appbarColor');
    String? appbarIcon =prefs.getString('appbarIconColor');
    String? bottomBarColor =prefs.getString('bottomBarColor');
    String? bottombarIcon =prefs.getString('bottomBarIconColor');
    if(bottomBarColor!=null){
      this.bototmBarColor=Color(int.parse(bottomBarColor));
      setState(() {});
    }

    if(bottombarIcon!=null){
      this.bottomMenuIconColor=Color(int.parse(bottombarIcon));
      setState(() {});
    }

    if(appBarColor!=null){
      this.appBarColor=Color(int.parse(appBarColor));
      setState(() {});
    }

    if(appbarIcon!=null){
      this.appBarIconColor=Color(int.parse(appbarIcon));
      setState(() {});
    }

    if(appbarIcon!=null){
      this.appBarIconColor=Color(int.parse(appbarIcon));
      setState(() {});
    }

    if(appbarIcon!=null){
      this.appBarIconColor=Color(int.parse(appbarIcon));
      setState(() {});
    }
  }

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');
    if (userId != null && baseUrl!=null && adminId!=null && apptypeid!=null) {
      setState(() {
        user_id = userId;
        this.baseUrl=baseUrl;
        this.admin_auto_id = adminId;
        this.app_type_id=apptypeid;
        getOrderHistory();
      });
    }
  }

  getOrderHistory() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "customer_auto_id": user_id,
      "admin_auto_id" : admin_auto_id,
    };

    print("user_id=>"+user_id);

    var url = baseUrl+'api/' + get_order_history;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      isServerError=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        OrderHistoryModel orderHistoryModel=OrderHistoryModel.fromJson(json.decode(response.body));
        orderHistory=orderHistoryModel.data;
      }
      else{
        orderHistory=[];
      }

      if(mounted){
        setState(() {});
      }
    }
    else if (response.statusCode == 500) {
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
          isServerError=true;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getappUi();
    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: appBarColor,
        title: Text("Orders" ,style: TextStyle(color:appBarIconColor,fontSize: 18)),
        automaticallyImplyLeading: false,
      ),
      body:Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: ListView.builder(
                itemCount: orderHistory.length,
                itemBuilder: (BuildContext context, int index) {
                  return getOrderUi(orderHistory[index]);
                }
            ),
          ),

          isApiCallProcessing==false && orderHistory.isEmpty?
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: const Text('Order history not available')
          ):
          Container(),

          isServerError==true?
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/server_error.png'),
                ),
                const Text('Server Error.. Please try later')
              ],
            ),
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
      ),
    );
  }

  getOrderUi(OrderHistory orderHistory){
    String orderStatus=orderHistory.orderStatus;

    if(orderStatus==RECEIVED || orderStatus==ACCEPTED || orderStatus==PREPARED || orderStatus==DISPATCHED ){
      return orderItemCancel(orderHistory);
    }
    else if(orderStatus==REJECTED || orderStatus==CANCELLED){
      return orderItemRejected(orderHistory);
    }
    else if(orderStatus==COMPLETED){
      return orderItemCompleted(orderHistory);
    }
    else if(orderStatus==RETURNED){
      return orderItemReturned(orderHistory);
    }

  }

  orderItem(OrderHistory orderHistory){
    return Container(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Order_details(orderHistory.orderId,orderHistory.productOrderAutoId)),
            );
          },
          child: Card(
            shadowColor: Colors.orangeAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: orderHistory.productImage.isNotEmpty?
                          CachedNetworkImage(
                            fit: BoxFit.contain,
                            imageUrl: baseUrl+product_base_url+orderHistory.productImage,
                            placeholder: (context, url) =>
                                Container(decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                )),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ):
                          Container(
                              child:const Icon(Icons.error),
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                              )),
                        ),
                        orderHistory.colorName!=select_color?Container(
                            margin: const EdgeInsets.only(left: 15),
                            child:Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Color:',
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),

                                Text(
                                  orderHistory.colorName,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )):Container(),
                        orderHistory.size!=""?Container(
                            margin: const EdgeInsets.only(left: 15),
                            child:
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Size:',
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  orderHistory.size,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )):Container()
                      ],
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [ Text(
                            orderHistory.productName,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                            textScaleFactor: 1,
                            softWrap: true,
                          ),],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Quantity: ',
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.bold),
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  orderHistory.quantity,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.bold),
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                  child: Text(
                                    'Order Date:',
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                SizedBox(
                                  height: 20,
                                  child: Text(
                                    orderHistory.orderDate,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Order Status: ',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                  fontWeight:
                                  FontWeight.bold),
                              textAlign: TextAlign.left,
                              softWrap: true,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              orderHistory.orderStatus,
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                  fontWeight:
                                  FontWeight.bold),
                              textAlign: TextAlign.left,
                              softWrap: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: const [
                        Icon(Icons.arrow_forward_ios,
                            size: 20, color: Colors.black),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )    );
  }

  orderItemRejected(OrderHistory orderHistory){
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Order_details(orderHistory.orderId,orderHistory.productOrderAutoId)),
          );
        },
        child: Card(
          shadowColor: Colors.orangeAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          child:Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: orderHistory.productImage.isNotEmpty?
                          CachedNetworkImage(
                            fit: BoxFit.contain,
                            imageUrl: baseUrl+product_base_url+orderHistory.productImage,
                            placeholder: (context, url) =>
                                Container(decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                )),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ):
                          Container(
                              child:const Icon(Icons.error),
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                              )),
                        ),
                        orderHistory.colorName!=select_color?Container(
                            margin: const EdgeInsets.only(left: 15),
                            child:Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Color:',
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  orderHistory.colorName,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )):Container(),
                        orderHistory.size!=""?Container(
                            margin: const EdgeInsets.only(left: 15),
                            child:
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Size:',
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  orderHistory.size,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )):Container()
                      ],
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [ Text(
                            orderHistory.productName,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                            textScaleFactor: 1,
                            softWrap: true,
                          ),],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Quantity: ',
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.bold),
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  orderHistory.quantity,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.bold),
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                  child: Text(
                                    'Order Date:',
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                SizedBox(
                                  height: 20,
                                  child: Text(
                                    orderHistory.orderDate,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        orderHistory.orderStatus==CANCELLED?
                        const Text(
                          'Order cancelled',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight:
                              FontWeight.bold
                          ),
                          textAlign: TextAlign.left,
                          softWrap: true,
                        ) :
                        const Text(
                          'Order Rejected By Seller',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight:
                              FontWeight.bold
                          ),
                          textAlign: TextAlign.left,
                          softWrap: true,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: const [
                        Icon(Icons.arrow_forward_ios,
                            size: 20, color: Colors.black),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),

    );
  }

  orderItemReturned(OrderHistory orderHistory){
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Order_details(orderHistory.orderId,orderHistory.productOrderAutoId)),
          );
        },
        child: Card(
          shadowColor: Colors.orangeAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          child:Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: orderHistory.productImage.isNotEmpty?
                          CachedNetworkImage(
                            fit: BoxFit.contain,
                            imageUrl: baseUrl+product_base_url+orderHistory.productImage,
                            placeholder: (context, url) =>
                                Container(decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                )),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ):
                          Container(
                              child:const Icon(Icons.error),
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                              )),
                        ),
                        orderHistory.colorName!=select_color?Container(
                            margin: const EdgeInsets.only(left: 15),
                            child:Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Color:',
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  orderHistory.colorName,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )):Container(),
                        orderHistory.size!=""?Container(
                            margin: const EdgeInsets.only(left: 15),
                            child:
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Size:',
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  orderHistory.size,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )):Container()
                      ],
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [ Text(
                            orderHistory.productName,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                            textScaleFactor: 1,
                            softWrap: true,
                          ),],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Quantity: ',
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.bold),
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  orderHistory.quantity,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.bold),
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                  child: Text(
                                    'Order Date:',
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                SizedBox(
                                  height: 20,
                                  child: Text(
                                    orderHistory.orderDate,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        const Text(
                          'Product returned to seller',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight:
                              FontWeight.bold
                          ),
                          textAlign: TextAlign.left,
                          softWrap: true,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: const [
                        Icon(Icons.arrow_forward_ios,
                            size: 20, color: Colors.black),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),

    );
  }

  orderItemCancel(OrderHistory orderHistory){
    return Container(
      child: Card(
        shadowColor: Colors.orangeAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        child:Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child:GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Order_details(orderHistory.orderId,orderHistory.productOrderAutoId)),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: orderHistory.productImage.isNotEmpty?
                              CachedNetworkImage(
                                fit: BoxFit.contain,
                                imageUrl: baseUrl+product_base_url+orderHistory.productImage,
                                placeholder: (context, url) =>
                                    Container(decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                    )),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ):
                              Container(
                                  child:const Icon(Icons.error),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                  )),
                            ),
                            orderHistory.colorName!=select_color?Container(
                                margin: const EdgeInsets.only(left: 15),
                                child:Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Color:',
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      orderHistory.colorName,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )):Container(),
                            orderHistory.size!=''?Container(
                                margin: const EdgeInsets.only(left: 15),
                                child:
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Size:',
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      orderHistory.size,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )):Container()
                          ],
                        ),
                      )
                  ),
                  flex: 1,
                ),
                Expanded(
                  flex: 2,
                  child:
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Order_details(orderHistory.orderId,orderHistory.productOrderAutoId)),
                            );
                          },
                          child:  Container(
                            child: Column(
                                children:<Widget>[
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [ Text(
                                      orderHistory.productName,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                      textScaleFactor: 1,
                                      softWrap: true,
                                    ),],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Quantity: ',
                                            style: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.bold),
                                            textAlign: TextAlign.left,
                                            softWrap: true,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            orderHistory.quantity,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.bold),
                                            textAlign: TextAlign.left,
                                            softWrap: true,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                            child: Text(
                                              'Order Date:',
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,
                                              softWrap: true,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          SizedBox(
                                            height: 20,
                                            child: Text(
                                              orderHistory.orderDate,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Order Status: ',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 14,
                                            fontWeight:
                                            FontWeight.bold),
                                        textAlign: TextAlign.left,
                                        softWrap: true,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        orderHistory.orderStatus,
                                        style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 14,
                                            fontWeight:
                                            FontWeight.bold),
                                        textAlign: TextAlign.left,
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ]
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: ()=>{
                            showCancelOrder(orderHistory)
                          },
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(
                                    color: Colors.grey,
                                  )
                              ),
                              child: const Text('CANCEL ORDER',style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 15),)),
                        ),
                      ],
                    ),
                  ),
                ),
/*
              SizedBox(
                width: 40,
                child: Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.arrow_forward_ios,
                          size: 20, color: Colors.black),
                    ],
                  ),
                ),
              )
*/
              ],
            )
        ),
      ),
    );
  }

  orderItemCompleted(OrderHistory orderHistory){
    double rating=0.0;
    if(orderHistory.getRatingLists.isNotEmpty)
    {
      rating = double.parse(orderHistory.getRatingLists[0].rating);
    }

    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Order_details(orderHistory.orderId,orderHistory.productOrderAutoId)),
          );
        },
        child: Card(
          shadowColor: Colors.orangeAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          child:Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: orderHistory.productImage.isNotEmpty?
                              CachedNetworkImage(
                                fit: BoxFit.contain,
                                imageUrl: baseUrl+product_base_url+orderHistory.productImage,
                                placeholder: (context, url) =>
                                    Container(decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                    )),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ):
                              Container(
                                  child:const Icon(Icons.error),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                  )),
                            ),
                            orderHistory.colorName!=select_color?Container(
                                margin: const EdgeInsets.only(left: 10),
                                child:Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Color:',
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      orderHistory.colorName,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )):Container(),
                            orderHistory.size!=""?Container(
                                margin: const EdgeInsets.only(left: 10),
                                child:
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Size:',
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      orderHistory.size,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )):Container()
                          ],
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [ Text(
                                orderHistory.productName,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                                textScaleFactor: 1,
                                softWrap: true,
                              ),],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Quantity: ',
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 14,
                                          fontWeight:
                                          FontWeight.bold),
                                      textAlign: TextAlign.left,
                                      softWrap: true,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      orderHistory.quantity,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight:
                                          FontWeight.bold),
                                      textAlign: TextAlign.left,
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                      child: Text(
                                        'Order Date:',
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                        softWrap: true,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    SizedBox(
                                      height: 20,
                                      child: Text(
                                        orderHistory.orderDate,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Order Status: ',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.bold),
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  orderHistory.orderStatus,
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.bold),
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex:1,
                        child:Container(
                          width: MediaQuery.of(context).size.width,
                          child:GFRating(
                            color: Colors.pinkAccent,
                            borderColor: Colors.pinkAccent,
                            value: rating,
                            size: GFSize.SMALL,
                            onChanged: (value) {
                              if(rating==0.0){
                                rating = value;
                                showAddReview(user_id,orderHistory.productAutoId, baseUrl,
                                    orderHistory.productOrderAutoId,rating);
                              }
                              else{
                                rating = value;
                                showEditReview(baseUrl,orderHistory.productAutoId,orderHistory.productOrderAutoId,
                                    user_id,orderHistory.getRatingLists[0].ratingAutoId,orderHistory.getRatingLists[0].review,
                                    rating,orderHistory.getRatingLists[0].finishing,
                                    orderHistory.getRatingLists[0].productQuality,orderHistory.getRatingLists[0].sizeFitting,
                                    orderHistory.getRatingLists[0].pricing,orderHistory.getRatingLists[0].reviewImage);
                              }
                            },
                          ),

                        )
                    ),

                    Expanded(
                        flex:1,
                        child: GestureDetector(
                          onTap: ()=>{
                            showReturnOrder(orderHistory)
                          },
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.only(left: 5,right: 5,top: 10),
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(
                                    color: Colors.grey,
                                  )
                              ),
                              child: const Text('RETURN PRODUCT',style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 14),)),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showCancelOrder(OrderHistory orderHistory) async {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return CancelOrderBottomsheet(onCancelOrderListener,orderHistory.orderId,orderHistory.productOrderAutoId,user_id, admin_auto_id,baseUrl);
        });
  }

  showReturnOrder(OrderHistory orderHistory) async {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return ReturnOrderBottomsheet(onCancelOrderListener,orderHistory.orderId,
              orderHistory.productOrderAutoId,user_id, admin_auto_id, baseUrl);
        });
  }

  void onCancelOrderListener(){
    Navigator.pop(context);
    getOrderHistory();
  }

  showAddReview( String customerautoid,String product_auto_id,String baseUrl,String product_order_auto_id, double rating) {
    Route routes = MaterialPageRoute(builder: (context) =>
        AddReview( customerautoid,product_auto_id,baseUrl,product_order_auto_id,rating, admin_auto_id,app_type_id)
    );
    Navigator.push(context, routes).then(onGoBack);
  }

  showEditReview( String baseUrl,String product_auto_id,String product_order_auto_id,String cusotmer_id,String review_auto_id, String
  review,double overallRating,String finishingRating,String qualityRating,String sizeFitRating,String priceRating, String review_image) {

    Route routes = MaterialPageRoute(builder: (context) =>
        EditReview( baseUrl,product_auto_id,product_order_auto_id,cusotmer_id,review_auto_id,review,
            overallRating,finishingRating,qualityRating,sizeFitRating,priceRating,review_image,app_type_id)
    );

    Navigator.push(context, routes).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    getOrderHistory();
  }
}

