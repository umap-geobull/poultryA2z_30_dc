import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/AdminDashboard/PaymentMerchant/PayPal/Verify_PayPal_Merchant.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'Model/PaymentMerchantModel.dart';
import 'RazorPay/Verify_Razorpay_Merchant.dart';
import 'package:url_launcher/url_launcher.dart';


class Select_Payment_Merchant extends StatefulWidget
{
  @override
  _Select_Payment_Merchant createState() => _Select_Payment_Merchant();
}

class _Select_Payment_Merchant extends State<Select_Payment_Merchant>{
  late List<PaymentMerchant> paymentmode;

  List<PaymentMerchant> paymentmodes = <PaymentMerchant>[
  PaymentMerchant(id:"1",icon:"assets/razorpay.png",title:"RazorPay",
      Description:"Razorpay, our online payment partner, built a white label closed wallet solution which enabled"
          " us to create & offer cashbacks and easily refund payments. This improved customer loyalty and the trust in our brand.",
      link: "https://easy.razorpay.com/onboarding?recommended_product=payment_gateway"),
 // PaymentMerchant(id:"2",icon:"assets/stripe_logo.png",title:"Stripe",Description:"Stripe's products power payments for online and in-person retailers, subscriptions businesses, software platforms and marketplaces, and everything in between. We also help companies beat fraud, send invoices, issue virtual and physical cards, get financing, manage business spend, and much more."),
  PaymentMerchant(id:"3",icon:"assets/paypal_logo1.png",title:"PayPal",
      Description:"PayPal is an online payment system that makes paying for things online and sending and "
          "receiving money safe and secure. When you link your bank account, credit card or debit card to"
          " your PayPal account, you can use PayPal to make purchases online with participating stores.",
      link: "https://www.paypal.com/in/webapps/mpp/account-selection"),];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentmode = List.of(paymentmodes);
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
            icon: const Icon(Icons.arrow_back, color: appBarIconColor),
          ),
      ),
      body:Stack(
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(bottom: 50),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: paymentmode.length,
                  itemBuilder: (context, index) =>
                      PayMentMerchants(paymentmode[index])
              )
          ),
        ],
      ),
    );
  }

  Widget PayMentMerchants(PaymentMerchant paymentmode)
  {
    return GestureDetector(
        onTap: ()=>{
          if(paymentmode.id=='1'){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Verify_Razorpay_Merchant()),)
          }
          else if(paymentmode.id=='2'){
            /* Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Verify_Stripe_Merchant()),)
            */
          }
          else if(paymentmode.id=='3'){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Verify_PayPal_Merchant()),)
            }
        },
      child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
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
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(20),
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
                             // maxLines: 4,
                              style:
                              const TextStyle(color: Colors.black45, fontSize: 12),
                            ),flex: 3,)

                          ],
                        ),
                      ),

                      SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Text(
                          "Don't have account on "+paymentmode.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                               fontSize: 12,color: Colors.black),
                        ),
                      ),
                      InkWell(
                          onTap: ()=>{
                            _launchUrl(paymentmode.link)
                          },
                          child:Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            child: Text("Click Here To Create An Acount",
                              style: TextStyle(fontSize:15,color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline), )
                            ,
                          ))                    ],
                  ),
                ),
              )
            ],
          )
      ),
    );
  }

  Future<void> _launchUrl(String link) async {
    final Uri _url = Uri.parse(link);

    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}