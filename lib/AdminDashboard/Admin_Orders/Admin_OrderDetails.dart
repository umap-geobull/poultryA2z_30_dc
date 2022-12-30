import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/PicEditor/utils/colors.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../MyOrders/OrderDetail_Model.dart';
import '../../Utils/App_Apis.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'Components/Rest_Apis.dart';

class Order_detail extends StatefulWidget {
  String orderId;
  String productOrderAutoId;

  Order_detail(this.orderId, this.productOrderAutoId);

  @override
  State<StatefulWidget> createState() => OrderDetailState(orderId, productOrderAutoId);
}

class OrderDetailState extends State<Order_detail> {
  String orderId, productOrderAutoId;
  OrderDetailState(this.orderId, this.productOrderAutoId);


  int _index = 0, currentindex = 0;
  double rating=0;
  bool isloading = false;
  bool hide = true;
  late List<OrderDetailsData> orderDetailsData = [];
  late List<ProductDetails> mainProduct = [];
  late List<ProductDetails> otherProduct = [];
  late List<GetRatingLists> getrating = [];
  late List<GetRatingLists> getratingother = [];
  String user_id='',select_color='Select Color Name';
  String baseUrl='', admin_auto_id='',app_type_id='';
  List<String> Order_status_list = [
    'Accept',
    'Reject',
    'Prepared',
    'Dispatched',
    'Completed',
    'Cancelled',
  ];
  String? order_status;
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
        getOrderDetails();
      });
    }
  }

  getOrderDetails() async {
    if(mounted){
      setState(() {
        isloading=true;
      });
    }

    final body = {
      "customer_auto_id": user_id,
      "order_id": orderId,
      "admin_auto_id" : admin_auto_id,
    };

    print("user_id=>"+user_id);
    print("order_id=>"+orderId);
    print("amin_id=>"+admin_auto_id);

    var url = baseUrl+'api/' + get_order_details;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isloading=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        OrderDetailsModel orderDetailsModel = OrderDetailsModel.fromJson(json.decode(response.body));
        orderDetailsData = orderDetailsModel.data;

        for (int i = 0; i < orderDetailsData[0].productDetails.length; i++) {
          if (orderDetailsData[0].productDetails[i].productOrderAutoId ==
              productOrderAutoId) {
            mainProduct.add(orderDetailsData[0].productDetails[i]);

            if(orderDetailsData[0].getRatingLists.isNotEmpty){
              getrating.add(orderDetailsData[0].getRatingLists[i]);
            }
          } else {
            otherProduct.add(orderDetailsData[0].productDetails[i]);
            if(orderDetailsData[0].getRatingLists.isNotEmpty){
              //getratingother.add(orderDetailsData[0].getRatingLists[i]);
            }
          }
        }

        SetActiveStatus(mainProduct[0].orderStatus);
      }
      else{
        orderDetailsData=[];
      }

      if(mounted){
        setState(() {});
      }
    }
    else if (response.statusCode == 500) {
      isloading=false;
      Fluttertoast.showToast(
        msg: "Server error",
        backgroundColor: Colors.grey,
      );

      if(mounted){
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
  }

  void SetActiveStatus(String status) {
    switch (status) {
      case 'Received':
        _index = 0;
        break;
      case 'Accept':
        _index = 1;
        break;
      case 'Reject':
        _index = 1;
        break;
      case 'Prepared':
        _index = 2;
        break;
      case 'Dispatched':
        _index = 3;
        break;
      case 'Completed':
        _index = 4;
        break;
      case 'Returned':
        _index = 5;
        break;

      default:
        _index = 0;
    }
  }

  bool getIsActive(int currentIndex, int index) {
    if (currentIndex <= index) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text("Order details", style: TextStyle(color: appBarIconColor,fontSize: 18)),
          leading: IconButton(
            onPressed:  Navigator.of(context).pop,
            icon: const Icon(Icons.arrow_back, color: appBarIconColor),
          ),
        ),
        body:Container(
          padding: EdgeInsets.only(bottom: 50),
            height: MediaQuery.of(context).size.height,
            child:
            isloading==true?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: const GFLoader(
                  type:GFLoaderType.circle
              ),
            ):
            orderDetailsData.isNotEmpty?
            ListView(
              children: uiData(),
            ):
            Container()
        ),
      bottomSheet: Checkout_Section(context),
    );
  }

  List<Widget> uiData(){
    List<Widget> otherList=[];

    if(mainProduct.isNotEmpty){

      otherList.add(
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            child:Row(
              children: [
                const Text(
                  'Order Status:  ',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 15,
                  ),
                ),
               /* Text(
                  mainProduct[0].orderStatus,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                  ),
                )*/
                Center(
                  child: Container(
                    width: 250,
                    child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'Select Order Status',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: Order_status_list.map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )).toList(),
                      value: order_status,
                      onChanged: (value) {
                        setState(() {
                          order_status = value as String;
                        });
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                      ),
                      iconEnabledColor: Colors.black,
                      iconDisabledColor: Colors.grey,
                      buttonHeight: 45,
                      buttonWidth: 250,
                      buttonPadding:
                      const EdgeInsets.only(left: 14, right: 14),
                      buttonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                      ),
                      itemHeight: 30,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 150,
                      dropdownWidth: 250,
                      dropdownPadding: const EdgeInsets.only(left: 10, right: 10),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      dropdownElevation: 8,
                      scrollbarRadius: const Radius.circular(40),
                      scrollbarThickness: 1,
                      scrollbarAlwaysShow: true,
                    ),
                  ),),
                ),
              ],
            ),
          ));

      otherList.add(
          Container(
            color: Colors.grey[100],
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment:MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Order ID:  ',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      mainProduct[0].orderId,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment:MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Date:  ',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      mainProduct[0].orderDate,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),

              ],
            ),
          ));

      otherList.add(
          Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 50),
          child:Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      mainProduct[0].productName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                      softWrap: true,
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Quantity: ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,),
                        ),
                        Text(
                          mainProduct[0].quantity,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    mainProduct[0].colorName!=select_color?Row(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Color: ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          mainProduct[0].colorName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ):Container(),
                    const SizedBox(
                      height: 5,
                    ),
                    mainProduct[0].size!=''?Row(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Size: ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          mainProduct[0].size,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ):Container(),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        mainProduct[0].productPrice.toString()!=mainProduct[0].productFinalPrice.toString()? Text(
                          "₹" + mainProduct[0].productPrice,
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                              decoration: TextDecoration.lineThrough),
                        ):Text(''),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "₹" + mainProduct[0].productFinalPrice.toString(),
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        mainProduct[0].productOfferPercentage!='0'?Text(
                          " (" + mainProduct[0].productOfferPercentage+'%OFF)',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 10,
                          ),
                        ):Text('')
                      ],
                    )

                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 100,
                  child: mainProduct[0].productImage.isNotEmpty?
                  CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: baseUrl+product_base_url+mainProduct[0].productImage,
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
              ),
            ],
          ))
      );
    }

    /* otherList.add( Container(
        padding: EdgeInsets.all(10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Order Status',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
                textScaleFactor: 1,
                softWrap: true,
              ),
              const Divider(color: Colors.black12, height: 15,),
              Container(
                child:
                Stepper(
                  physics: NeverScrollableScrollPhysics(),
                  type: StepperType.vertical,
                  currentStep: _index,
                  steps: <Step>[
                    Step(
                      title: Text('Order Received ('+orderDetailsData[0].orderDate+')'),
                      content: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('')),
                      isActive: getIsActive(0, _index),
                    ),
                    Step(
                      title: Text('Order Accepted'),
                      content: Container(
                          alignment: Alignment.centerLeft,
                          child: const Text('')),
                      isActive: getIsActive(1, _index),
                    ),
                    Step(
                      title: Text('Order Prepared'),
                      content: Container(
                          alignment: Alignment.centerLeft,
                          child: const Text('')),
                      isActive: getIsActive(2, _index),
                    ),
                    Step(
                      title: Text('Order Dispatched'),
                      content: Container(
                          alignment: Alignment.centerLeft,
                          child: const Text('')),
                      isActive: getIsActive(3, _index),
                    ),
                    Step(
                      title: Text('Order Delivered'),
                      content: Container(
                          alignment: Alignment.centerLeft,
                          child: const Text('')),
                      isActive: getIsActive(4, _index),
                    ),
                  ],
                  controlsBuilder: (BuildContext context, ControlsDetails details) {
                    return Container(
                    );
                  },
                ),
              ),
            ])
    ));*/
    if(getrating.isNotEmpty) {
      rating=double.parse(getrating[0].rating);
      otherList.add(Container(
        // margin: EdgeInsets.only(left: 10,right: 10,top: 50,bottom: 10),
          padding: const EdgeInsets.all(10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Review',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                  textScaleFactor: 1,
                  softWrap: true,
                ),
                const Divider(color: Colors.black12, height: 15,),
                Row(children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child:
                    RatingBar.builder(
                      initialRating: rating,
                      minRating: 1,
                      itemSize: 30,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) =>
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        // this.rating=rating.toString();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => EditReview(orderHistory.orderId,orderHistory.productOrderAutoId)),
                        // );
                      },
                    ),
                  ),
                  const Spacer(),
                  // GestureDetector(
                  //   onTap:() {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => AddReview(user_id,mainProduct[0].productAutoId,baseUrl,productOrderAutoId)),
                  //     );
                  //   },
                  //   // child: Text(
                  //   //   'Write Review',
                  //   //   style: TextStyle(
                  //   //     color: Colors.blue,
                  //   //     fontSize: 16,
                  //   //   ),
                  //   // ),
                  // )
                ],),
                /*getrating[0].review!=null?Text(
                  getrating[0].review,
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 14,
                  ),
                )://
                GestureDetector(
                  onTap:() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddReview(user_id,mainProduct[0].productAutoId,baseUrl,productOrderAutoId,rating, admin_auto_id,app_type_id)),
                    );
                  },
                  child: const Text(
                    'Write Review',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),*/
              ])
      ));
    }
    otherList.add(Container(
      // margin: EdgeInsets.only(left: 10,right: 10,top: 50,bottom: 10),
        padding: const EdgeInsets.all(10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shipping Address',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
                textScaleFactor: 1,
                softWrap: true,
              ),
              const Divider(color: Colors.black12, height: 15,),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child:
                Text(
                  orderDetailsData[0].address + '\n' +
                      orderDetailsData[0].city +
                      ',' +
                      orderDetailsData[0].state +
                      ' - ' +
                      orderDetailsData[0].usedPincode +
                      '\n' +
                      orderDetailsData[0].country,
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.left,
                  softWrap: true,
                ),
              ),
            ])
    ));

    if(otherProduct.isNotEmpty){
      otherList.add(
          Container(
            child: const Text(
              'Other products in this order',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.left,
              textScaleFactor: 1,
              softWrap: true,
            ),
            margin: const EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 10),
          ));
    }

    for(int index=0;index<otherProduct.length;index++){
      otherList.add(
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Order_detail(otherProduct[index].orderId,otherProduct[index].productOrderAutoId)),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(left: 10,right: 5,bottom: 10),
              padding: const EdgeInsets.all(10),
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.shade300
                        )
                    ),
                    height: 80,
                    width: 80,
                    child: otherProduct[index].productImage.isNotEmpty?
                    CachedNetworkImage(
                      fit: BoxFit.contain,
                      imageUrl: baseUrl+product_base_url+otherProduct[index].productImage,
                      placeholder: (context, url) =>
                          Container(decoration: BoxDecoration(
                            color: Colors.grey[400],
                          )),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ) :
                    Container(
                        child:const Icon(Icons.error),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                        )),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(otherProduct[index].productName,
                          style: const TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold
                          ),),

                        const SizedBox(height: 10,),
                        Text(otherProduct[index].size,
                          style: const TextStyle(color: Colors.black, fontSize: 15,
                          ),),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            otherProduct[index].productPrice!=otherProduct[index].productFinalPrice.toString()?Text(
                              "₹" + otherProduct[index].productPrice,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                  decoration: TextDecoration.lineThrough),
                            ):Text(''),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "₹" + otherProduct[index].productFinalPrice.toString(),
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            orderDetailsData[0].promocodeValueOffOnOrder!='0'?Text(
                              " (" + otherProduct[index].productOfferPercentage+'%OFF)',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 10,
                              ),
                            ):Text('')
                          ],
                        ),

                      ],
                    ),
                  ),
                  Expanded(
                      child:
                      Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: ()=>{

                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,size: 15,color: Colors.black87,
                          ),
                        ),))
                ],
              ),
            )
            ,
          )
      );
    }

    otherList.add(
      Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Payment Details',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                  textScaleFactor: 1,
                  softWrap: true,
                ),
              ),
              margin: const EdgeInsets.only(left: 0),
            ),
            const Divider(
              thickness: 1,
              // thickness of the line
              indent: 0,
              // empty space to the leading edge of divider.
              endIndent: 0,
              // empty space to the trailing edge of the divider.
              color: Colors.black12,
              // The color to use when painting the line.
              height: 15, // The divider's height extent.
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payment Mode:',
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  orderDetailsData[0].paymentMode,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Original Price:',
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '\u{20B9}' ' '+ orderDetailsData[0].totalPrice,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            orderDetailsData[0].promocodeValueOffOnOrder!='0'?Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Offer Price:',
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '\u{20B9}' ' '+ orderDetailsData[0].promocodeValueOffOnOrder,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ):Container(),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Delivery Charges:',
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '\u{20B9}' ' '+ orderDetailsData[0].pincodeDeliveryCharge,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Order Total:',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '\u{20B9}' ' '+ orderDetailsData[0].totalPaidPrice,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return otherList;
  }

  Widget Checkout_Section(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.grey.shade50,
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () {
                Change_Order_Status(widget.productOrderAutoId, user_id, order_status as String);
              },
              child: const Center(
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            )

          )),
    );
  }

  void Change_Order_Status(String orderAutoId, String userAutoId, String status) {
    if(status == 'Accept')
    {
      setState(() {
        status = "Prepared";
      });
    }

    Rest_Apis restApis=Rest_Apis();

    restApis.Change_Order_Status(orderAutoId, userAutoId, admin_auto_id, status,baseUrl).then((value){

      if(value!=null){
        int status =value;

        if(status == 1){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Status changed successfully", backgroundColor: Colors.grey,);
         // getOrderDetails();

        }
        else if(status==0){

          Fluttertoast.showToast(msg: "Something went wrong", backgroundColor: Colors.grey,);
        }
        else{
          Fluttertoast.showToast(msg: "Something went wrong", backgroundColor: Colors.grey,);
        }
      }
    });

  }
}
