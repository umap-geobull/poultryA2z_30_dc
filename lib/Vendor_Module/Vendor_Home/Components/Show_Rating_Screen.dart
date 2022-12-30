import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Show_Rating_Screen extends StatelessWidget {
  const Show_Rating_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10, left: 15),
              child: Text("Seller Rating by Viewer", style: TextStyle(fontSize: 16, color: Colors.black),),
            ),
            Divider(color: Colors.grey.shade300),
            Container(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "Seller Rating",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text('4.4',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black)),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "On Grobiz Since Jan 2021",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      Text(
                        "Rated by 378 verified Buyers",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider(color: Colors.grey.shade300),
            Container(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            "Product Quality",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "4.3",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          RatingBar.builder(
                            itemSize: 20,
                            initialRating: 4.3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.5),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            "Packaging Quality",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "4.1",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          RatingBar.builder(
                            itemSize: 20,
                            initialRating: 4.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.5),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Customer Feedback",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.left,
                    ))),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 10),
                          child: Text("What Customers liked",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black))),
                      Expanded(
                        child: Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(right: 10,top:5),
                            child: Icon(Icons.favorite,color: Colors.red,size: 25,)
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: Image.asset(
                          //     'assets/happy_emoji.png', height: 25, width: 25,),
                          //   alignment: Alignment.centerRight,
                          // ),
                        ),
                      )
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                    child: Row(

                      children: [
                        Wrap(
                          children: [
                            Icon(Icons.fiber_manual_record, size: 13, color: Colors.grey,),
                            SizedBox(width: 5,),
                            Text("Finishing", style: TextStyle(fontSize: 13, color: Colors.black),)
                          ],
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text("8% Customers", style: TextStyle(fontSize: 13, color: Colors.black),),
                          ),
                        )

                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(

                      children: [
                        Wrap(
                          children: [
                            Icon(Icons.fiber_manual_record, size: 13, color: Colors.grey,),
                            SizedBox(width: 5,),
                            Text("Material Quality", style: TextStyle(fontSize: 13, color: Colors.black),)
                          ],
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text("16% Customers", style: TextStyle(fontSize: 13, color: Colors.black),),
                          ),
                        )

                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(

                      children: [
                        Wrap(
                          children: [
                            Icon(Icons.fiber_manual_record, size: 13, color: Colors.grey,),
                            SizedBox(width: 5,),
                            Text("Pricing", style: TextStyle(fontSize: 13, color: Colors.black),)
                          ],
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text("9% Customers", style: TextStyle(fontSize: 13, color: Colors.black),),
                          ),
                        )

                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(

                      children: [
                        Wrap(
                          children: [
                            Icon(Icons.fiber_manual_record, size: 13, color: Colors.grey,),
                            SizedBox(width: 5,),
                            Text("Size/Fitting", style: TextStyle(fontSize: 13, color: Colors.black),)
                          ],
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text("8% Customers", style: TextStyle(fontSize: 13, color: Colors.black),),
                          ),
                        )

                      ],
                    ),
                  ),
                  SizedBox(height: 15,),

                ],
              ),
            ),
            Divider(color: Colors.grey.shade300),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 10),
                          child: Text("What Customers did not like",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black))),
                      Expanded(
                        child: Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(right: 10,top:5),
                            child: Icon(Icons.thumb_down,size: 25,)
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: Image.asset(
                          //     'assets/sad_emoji.png', height: 25, width: 25,),
                          //   alignment: Alignment.centerRight,
                          // ),
                        ),
                      )
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10,top:10),
                    child: Row(

                      children: [
                        Wrap(
                          children: [
                            Icon(Icons.fiber_manual_record, size: 13, color: Colors.grey,),
                            SizedBox(width: 5,),
                            Text("Finishing", style: TextStyle(fontSize: 13, color: Colors.black),)
                          ],
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text("2% Customers", style: TextStyle(fontSize: 13, color: Colors.black),),
                          ),
                        )

                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(

                      children: [
                        Wrap(
                          children: [
                            Icon(Icons.fiber_manual_record, size: 13, color: Colors.grey,),
                            SizedBox(width: 5,),
                            Text("Material Quality", style: TextStyle(fontSize: 13, color: Colors.black),)
                          ],
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text("4% Customers", style: TextStyle(fontSize: 13, color: Colors.black),),
                          ),
                        )

                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(

                      children: [
                        Wrap(
                          children: [
                            Icon(Icons.fiber_manual_record, size: 13, color: Colors.grey,),
                            SizedBox(width: 5,),
                            Text("Pricing", style: TextStyle(fontSize: 13, color: Colors.black),)
                          ],
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text("2% Customers", style: TextStyle(fontSize: 13, color: Colors.black),),
                          ),
                        )

                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(

                      children: [
                        Wrap(
                          children: [
                            Icon(Icons.fiber_manual_record, size: 13, color: Colors.grey,),
                            SizedBox(width: 5,),
                            Text("Size/Fitting", style: TextStyle(fontSize: 13, color: Colors.black),)
                          ],
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text("1% Customers", style: TextStyle(fontSize: 13, color: Colors.black),),
                          ),
                        )

                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
