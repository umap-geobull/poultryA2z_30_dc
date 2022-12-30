import 'package:flutter/material.dart';

class Delivery_Address extends StatelessWidget {
  const Delivery_Address({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Delivery Address",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  Divider(color: Colors.grey.shade300),
                  const Text(
                    "Lorem Ipsum",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Lorem Ipsum",
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Lorem Ipsum",
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Lorem Ipsum - 111111",
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Ph.No: +919999999999",
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5,),
          Container(
            decoration: BoxDecoration(

                // border: Border.(color: Colors.grey.shade100, width: 1),
                border: Border(
              top: BorderSide(color: Colors.grey.shade100, width: 1),
              bottom: BorderSide(color: Colors.grey.shade100, width: 1),
            )),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(2),
                              child: Icon(
                                Icons.add,
                                size: 15,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text('Add New Address',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.blue)),
                          const VerticalDivider(
                            color: Colors.black,
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: 30,
                    child: VerticalDivider(color: Colors.grey.shade300)),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(2),
                              child: Icon(
                                Icons.edit,
                                size: 15,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text('Change Address',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.blue)),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
