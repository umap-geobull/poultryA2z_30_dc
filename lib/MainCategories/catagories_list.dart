import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Consultant/Model/consultant_result_model.dart';
import '../Vendor_Module/Vendor_details.dart';

class VendorCatagoriesList extends StatefulWidget {
  const VendorCatagoriesList({Key? key}) : super(key: key);

  @override
  State<VendorCatagoriesList> createState() => _VendorCatagoriesListState();
}

class _VendorCatagoriesListState extends State<VendorCatagoriesList> {
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;
  Color bottomBarColor=Colors.white, bottomMenuIconColor=Color(0xFFFF7643);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height/1.15,
            padding: const EdgeInsets.only(top: 10),
            margin: EdgeInsets.only(left: 15,right: 15),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: vendorList.length,
              itemBuilder: (context, index) =>
                  InkWell(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Vendor_details("123")));
                    },
                    child: Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  flex: 5,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 220,
                                    child: Image.asset(vendorList[index].image, fit: BoxFit.fill,),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child:  Padding(
                                    padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                    child: Text(vendorList[index].name,
                                      style: TextStyle(color: Colors.blueGrey,fontSize: 20), ),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child:Padding(
                                        padding: EdgeInsets.only(left: 10,right: 10,bottom: 2,top: 5),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            // Icon(Icons.location_on, color: kMainColor,size: 20,),
                                            // SizedBox(width: 5,),
                                            Flexible(child: Text("Supplier: "+vendorList[index].supplier))
                                          ],
                                        ),
                                      )
                                  )),


                              Padding(
                                padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    // Icon(Icons.location_on, color: kMainColor,size: 20,),
                                    // SizedBox(width: 5,),
                                    Flexible(child: Text("Price: "+vendorList[index].minMaxPrice)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        // Text(
                                        //   '4',
                                        //   style: TextStyle(
                                        //     color: Colors.yellowAccent,
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        // Icon(
                                        //   Icons.star,
                                        //   color: Colors.orangeAccent,
                                        //   size: 10,
                                        // ),
                                        // Text(
                                        //   '| ' + total_reviews.toString()+"  total reviews",
                                        //   style: TextStyle(
                                        //     color: kWhiteColor,
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        Container(
                                          width: 80,
                                          height: 35,
                                          // color: primaryButtonColor,
                                          child: ElevatedButton(
                                            onPressed: () async{

                                              const url = "tel:8390679867";
                                              if (await canLaunch(url)) {
                                                await launch(url);
                                              } else {
                                                throw 'Could not launch $url';
                                              }

                                            },
                                            child: const Text('Call'),
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(200,50),
                                              backgroundColor: primaryButtonColor,
                                              shape: const StadiumBorder(),
                                              shadowColor: Colors.grey,
                                              elevation: 5,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        SizedBox(width: 100,
                                          height: 35,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              const uri = 'sms:+ 9898765444?body=hello%20there';
                                              if (await canLaunch(uri)) {
                                                await launch(uri);
                                              } else {
                                                // iOS
                                                const uri = 'sms:0039-222-060-888?body=hello%20there';
                                                if (await canLaunch(uri)) {
                                                  await launch(uri);
                                                } else {
                                                  throw 'Could not launch $uri';
                                                }
                                              }
                                            },
                                            child: const Text('Message'),
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(200,50),
                                              backgroundColor: secondaryButtonColor,
                                              shape: const StadiumBorder(),
                                              shadowColor: Colors.grey,
                                              elevation: 5,
                                            ),
                                          ),)
                                      ],
                                    )
                                  ],
                                ),
                              ),

                              // Expanded(
                              //     flex: 1,
                              //     child:
                              //     SizedBox(
                              //     width: MediaQuery.of(context).size.width,
                              //     height: 50,
                              //     child:
                              //     Padding(
                              //       padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                              //       child: Row(
                              //         //crossAxisAlignment: CrossAxisAlignment.start,
                              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //         crossAxisAlignment: CrossAxisAlignment.center,
                              //         children: <Widget>[
                              //           // Icon(Icons.location_on, color: kMainColor,size: 20,),
                              //           // SizedBox(width: 5,),
                              //           Flexible(child: Text(vendorList[index].fees)),
                              //           contactUi()
                              //         ],
                              //       ),
                              //     )
                              // )
                              // ),

                              Divider(
                                height: 10,
                                thickness: 5,
                                color: Colors.grey[500],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              totalRatingUi(),
                              InkWell(
                                onTap: (){
                                  Share.share("${vendorList[index].name} \n\n Supplire: ${vendorList[index].supplier}\n\n Min-Max Price: ${vendorList[index].minMaxPrice}");
                                },
                                child: Container(
                                  height: 30,
                                  alignment: Alignment.center,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(.55),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child:   const Icon(
                                      Icons.share,
                                      color: Colors.white,
                                    ),




                                ),
                              )
                            ],),
                        ],),
                      ),
                    ),
                  ),
            )
        ),

    );
  }

  totalRatingUi() {

    return Container(
      width: MediaQuery.of(context).size.width/5,
      height: 25,
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 0, right: 10, bottom: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.55),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '4',
              style: TextStyle(
                color: Colors.yellowAccent,
                fontSize: 12,
              ),
            ),
            Icon(
              Icons.star,
              color: Colors.orangeAccent,
              size: 10,
            ),
            // Text(
            //   '| ' + total_reviews.toString()+"  total reviews",
            //   style: TextStyle(
            //     color: kWhiteColor,
            //     fontSize: 12,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  shareUi() {
    return Container(
      height: 20,
      alignment: Alignment.topRight,
      width: 40,
      child: IconButton(
        icon:  const Icon(
          Icons.share,
          color: Colors.grey,
        ),

        onPressed: () =>
        {

        },
      ),
    );
  }
}
