import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/AdminDashboard/Delivery_Partner/Add_Delivery_Token.dart';
import 'package:poultry_a2z/AdminDashboard/Delivery_Partner/Verify_shiprocket_details.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'Model/Delivery_Partner_Model.dart';

class Select_Delivery_Merchant extends StatefulWidget
{
  @override
  _Select_Delivery_Merchant createState() => _Select_Delivery_Merchant();
}

class _Select_Delivery_Merchant extends State<Select_Delivery_Merchant>{
  late List<DeliveryPartner> deliverymode;
  bool isApiCallProcessing=false;
  bool isServerError=false;
  List<DeliveryPartner> deliverypartners = <DeliveryPartner>[
    DeliveryPartner(
        id:"1",icon:"assets/shiprocket.png",
        title:"Shiprocket",
        Description:"Shiprocket, a product of BigFoot Retail Solution Pvt. Ltd., is one of India's largest tech-enabled logistics and fulfillment platforms that aims to democratise the eCommerce landscape of the country."),

   // DeliveryPartner(id:"2",icon:"assets/delhivery_logo.png",title:"Delhivery", Description:"Delhivery is the largest and fastest-growing fully-integrated player in India by revenue in Fiscal 2021. The company provides a full suite of logistics services such as express parcel transportation, PTL and TL freight, cross-border and supply chain services."),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deliverymode = List.of(deliverypartners);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text("Payment Merchants",
              style: TextStyle(
                  color: appBarIconColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: ()=>{
              Navigator.of(context).pop()
            },
            icon: const Icon(Icons.arrow_back,
              color: appBarIconColor,
            ),
          ),
          actions: [

          ]
      ),
      body:Stack(
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(bottom: 50),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: deliverymode.length,
                  itemBuilder: (context, index) =>
                      PayMentMerchants(deliverymode[index])
              )
          ),
        ],
      ),
    );
  }

  Widget PayMentMerchants(DeliveryPartner paymentmode) {
    return Container(
        height: 150,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            GestureDetector(
              child: SizedBox(
                width: 100,
                child:
                SizedBox(
                    width: 100,
                    height: 100,
                    child: Container(
                        height: 100,
                        width: 100,
                        color: Colors.white,
                        child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              topLeft: Radius.circular(8),
                            ),
                            child: Image.asset(paymentmode.icon)
                        )
                    )
                ),
              ),
              onTap: ()=>{
                if(paymentmode.id=='1')
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Add_Delivery_Token()))
                    // PlaceorderShiprocket()
                  }else{}

              },
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 170,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: ()=>{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Verify_Shiprocket_Details()))
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            paymentmode.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15,color: Colors.black87),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(child:
                                Text(
                                  paymentmode.Description,
                                  softWrap: true,
                                  overflow: TextOverflow.clip,
                                  maxLines: 5,
                                  style:
                                  const TextStyle(color: Colors.black45, fontSize: 12),
                                ),flex: 3,)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
    );
  }

  Future<bool> orderSuccesfullAlert() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          content:Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    const Text('Hey...',style: TextStyle(color: Colors.orangeAccent,fontSize: 20),),
                    const SizedBox(height: 10,),
                    const Text('Your order has been placed successfully',
                      style: TextStyle(color: Colors.black54,fontSize: 15),),
                    const SizedBox(height: 5,),
                    const Text('Keep Shopping',
                      style: TextStyle(color: Colors.orange,fontSize: 16),),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            child: ElevatedButton(
                              onPressed: (){
                                  Navigator.pop(context);
                              },
                              child: const Text("Ok",style: TextStyle(color: Colors.black54,fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[200],
                                // minimumSize: Size(70,30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )
                        ),
                        const SizedBox(width: 10,),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}