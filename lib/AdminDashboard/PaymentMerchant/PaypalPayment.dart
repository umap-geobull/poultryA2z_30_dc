
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

class PayPalPayment extends StatefulWidget{
  @override
  _PayPalPaymentState createState() => _PayPalPaymentState();
}
class _PayPalPaymentState extends State<PayPalPayment> {
  String ClientId="AY8vHFQ4e0UC0hVMUGl5512lmxdamzRWijiso1TSJ978nBcoRBD69QyOBjt4K2eQem6wPFJKKxqnnyBn";
  String SecretKey="EDSNl2KDq690McIzpH3OIFew4-l2lMNZeC3WZggHD1XNNTJeHeIEwTeimmJtZq3JmrPHdYIUWIUkrXl8";
  String ReturnUrl="https://samplesite.com/return",
      CancelUrl="https://samplesite.com/cancel";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Paypal'),
        ),
        body: Center(
          child: TextButton(
              onPressed: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => UsePaypal(
                        sandboxMode: true,
                        clientId: ClientId,
                        secretKey: SecretKey,
                        returnURL: ReturnUrl,
                        cancelURL: CancelUrl,
                        transactions: const [
                          {
                            "amount": {
                              "total": '10.12',
                              "currency": "USD",
                              "details": {
                                "subtotal": '10.12',
                                "shipping": '0',
                                "shipping_discount": 0
                              }
                            },
                            "description":
                            "The payment transaction description.",
                            // "payment_options": {
                            //   "allowed_payment_method":
                            //       "INSTANT_FUNDING_SOURCE"
                            // },
                            "item_list": {
                              "items": [
                                {
                                  "name": "A demo product",
                                  "quantity": 1,
                                  "price": '10.12',
                                  "currency": "USD"
                                }
                              ],

                              // shipping address is not required though
                              "shipping_address": {
                                "recipient_name": "Jane Foster",
                                "line1": "Travis County",
                                "line2": "",
                                "city": "Austin",
                                "country_code": "IN",
                                "postal_code": "441904",
                                "phone": "9175037546",
                                "state": "Maharashtra"
                              },
                            }
                          }
                        ],
                        note: "Contact us for any questions on your order.",
                        onSuccess: (Map params) async {
                          print("onSuccess: $params");
                        },
                        onError: (error) {
                          print("onError: $error");
                        },
                        onCancel: (params) {
                          print('cancelled: $params');
                        }),
                  ),
                )
              },
              child: const Text("Make Payment")),
        ));
  }
}