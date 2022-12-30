import 'package:flutter/material.dart';

class Coupen_Code_Screen extends StatelessWidget {
  const Coupen_Code_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10.0, top: 5),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Apply Coupon Code",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1),
              ),
              child: Row(
                children: [
                  const Expanded(
                    flex:3,
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all( 10.0),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'Enter Coupon Code',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 40,
                      color: Colors.blue,
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: Text(
                            "APPLY",
                            style:
                            TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
