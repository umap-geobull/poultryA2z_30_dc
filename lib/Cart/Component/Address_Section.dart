import 'package:flutter/material.dart';

class Address_section extends StatelessWidget {
  const Address_section({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius:
                                  BorderRadius.circular(100),

                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(1.0),
                                  child: Icon(
                                    Icons.location_on,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                            const TextSpan(
                              text: "  Delivery Address", style: TextStyle(color: Colors.black, fontSize: 16)
                            ),
                          ],
                        ),
                      )),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade100, width: 1),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          "Edit Address",
                          style: TextStyle(fontSize: 14, color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: const EdgeInsets.only(left: 35),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Lorem Ipsum", style: TextStyle(fontSize: 12, color: Colors.black),),
                    SizedBox(height: 5,),
                    Text("Lorem Ipsum",style: TextStyle(fontSize: 12, color: Colors.black),),
                    SizedBox(height: 5,),
                    Text("Lorem Ipsum, ",style: TextStyle(fontSize: 12, color: Colors.black),),
                    SizedBox(height: 5,),
                    Text("Lorem Ipsum - 111111", style: TextStyle(fontSize: 12, color: Colors.black),),


                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
