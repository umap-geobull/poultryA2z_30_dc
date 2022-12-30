import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/constants.dart';

import 'Components/Body.dart';

class Checkout_Screen extends StatefulWidget {
  const Checkout_Screen({Key? key}) : super(key: key);

  @override
  _Checkout_ScreenState createState() => _Checkout_ScreenState();
}

class _Checkout_ScreenState extends State<Checkout_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text("CheckOut", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          leading: const Icon(Icons.arrow_back, color: Colors.white),
          actions: [


            IconButton(
              visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: const Icon(Icons.call, color: Colors.white),
            ),
            IconButton(
              visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.white),
            ),IconButton(
              visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
            ),


          ]
      ),
      bottomSheet: Checkout_Section(context),
      body: Container(
        margin: const EdgeInsets.only(bottom: 40),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: const [

              Body()
            ],
          ),
        ),
      ),

    );
  }
  Widget Checkout_Section(BuildContext context) {

    return Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(10.0),

        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: SizedBox(
                width: 40,
                height: 40,

                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      RichText(
                        text: const TextSpan(
                            text: 'RS.15000|',
                            style: TextStyle(fontSize: 16, color: Colors.black,),

                            children: <TextSpan>[
                              TextSpan(
                                text: '36 Units',
                                style: TextStyle(
                                  fontSize: 14,

                                ),
                              ),
                            ]
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 3,),
                      const Text("(Price Rs.14000 + GST Rs.1000)", style: TextStyle(fontSize: 10),),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 4,
              child: SizedBox(

                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: kPrimaryColor,
                      textStyle: const TextStyle(fontSize: 20)),
                  onPressed: () {

                  },
                  child: const Center(
                    child: Text(
                      'Proceed',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
