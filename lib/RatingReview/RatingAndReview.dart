import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/RatingReview/product_rating_model.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../Admin_add_Product/constants.dart';
import 'RatingAndReview_Model.dart';
import 'package:intl/intl.dart';


class RatingAndReview extends StatefulWidget {
  String product_id;
  String user_id;
  String app_type_id;

  RatingAndReview(this.product_id, this.user_id,this.app_type_id);

  @override
  State<RatingAndReview> createState() => RatingAndReviewState(product_id,user_id,app_type_id);
}

class RatingAndReviewState extends State<RatingAndReview> {
  String product_auto_id;
  String user_id,app_type_id='';


  RatingAndReviewState(this.product_auto_id, this.user_id,this.app_type_id);


  bool isApiCallProcessing = false;
  int total_reviews = 0, avg_rating = 0;
  List<GetRatingLists> RatingAndReviewList = [];
  String baseUrl = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
  }

  void getBaseUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if(baseUrl!=null){
      if(this.mounted){
        setState(() {
          this.baseUrl=baseUrl;
          GetRatingandReviewData();
        });
      }
    }
  }


  void GetRatingandReviewData() async {
    isApiCallProcessing = true;
    var url = baseUrl + 'api/' +Show_Ratings;

    var uri = Uri.parse(url);
    final body = {
      "product_auto_id": product_auto_id,
      "app_type_id": app_type_id,
    };
    var response = await http.post(uri, body: body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      RatingAndReviewModel ratingAndReviewModel =
          RatingAndReviewModel.fromJson(json.decode(response.body));
      RatingAndReviewList = ratingAndReviewModel.getalldata;
      var status = ratingAndReviewModel.status;
      total_reviews = ratingAndReviewModel.totalNoOfReviews;
      avg_rating = ratingAndReviewModel.avgRating;
      if (status == 1) {
        setState(() {
          isApiCallProcessing = false;
        });
      } else {
        RatingAndReviewList = [];
      }
      if (mounted) {
        setState(() {});
      }
    } else if (response.statusCode == 500) {
      if (mounted) {
        setState(() {
          isApiCallProcessing = false;
          Fluttertoast.showToast(
            msg: 'Server error',
            backgroundColor: Colors.grey,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text("Ratings & Reviews",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: ()=>{
              Navigator.of(context).pop()
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body:SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Container(
            child: ListView(
              children: getUiList(),
            ),
          ),
        ));
  }

  ratingReviewUi(){
    return Container(
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                color: Colors.grey[100],
                width: MediaQuery.of(context).size.width,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(avg_rating.toString(),
                            style: const TextStyle(
                                fontSize: 40,
                                color: Colors.black)
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.orangeAccent,
                          size: 20,
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                    Text(total_reviews.toString()+' Verified Buyers',
                        style: const TextStyle(
                            fontSize: 12,
                            //fontWeight: FontWeight.bold,
                            color: Colors.black54))
                  ],
                )
            ),
            const Text(
              'Customer Reviews',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),

            Expanded(
                child: ListView.builder(
                  //  physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    itemCount: RatingAndReviewList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RatingUi(RatingAndReviewList[index]);
                    }
                )
            )
          ],
        )
    );
  }

  List<Widget> getUiList(){
    List<Widget> uiLIst=[];

    uiLIst.add(Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        color: Colors.grey[100],
        width: MediaQuery.of(context).size.width,
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Text(avg_rating.toString(),
                    style: const TextStyle(
                        fontSize: 40,
                        color: Colors.black)
                ),
                const Icon(
                  Icons.star,
                  color: Colors.orangeAccent,
                  size: 20,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            Text(total_reviews.toString()+' Verified Buyers',
                style: const TextStyle(
                    fontSize: 12,
                    //fontWeight: FontWeight.bold,
                    color: Colors.black54))
          ],
        )
    ),);
    uiLIst.add(const Text(
      'Customer Reviews',
      style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black87),
    ),);

    for(int index=0;index<RatingAndReviewList.length;index++){
      uiLIst.add(RatingUi(RatingAndReviewList[index]));
    }

    return uiLIst;
  }

  FutureOr onGoBack(dynamic value) {
    GetRatingandReviewData();
  }

  String getupdatedDate(String rdate)
  {
  late String updatedon,updateday;
  updatedon=rdate;
  var inputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  var date1 = inputFormat.parse(updatedon);

  var outputFormat = DateFormat('dd-MM-yyyy');
  var date2 = outputFormat.format(date1);
  updateday =date2.toString();
  return updateday;
}

  RatingUi(GetRatingLists ratinglist) {
    return Container(
        child: GestureDetector(
            onTap: () => {
            //  showReviewDetails(ratinglist)
            },
            child: Container(
                margin: const EdgeInsets.all(10),
                /*  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26)
                ),*/
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          border:Border.all(
                              color: Colors.orangeAccent
                          ),
                          borderRadius: BorderRadius.circular(2)
                      ),
                      child: Row(
                        children: [
                          Text(ratinglist.rating),
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 15,
                          ),
                        ],
                      ) ,
                    ),
                    Expanded(
                      child:Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ratinglist.review,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.left,
                              textScaleFactor: 1,
                              softWrap: true,
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              height: 90,
                              width: 90,
                              child: ratinglist.reviewImage.isNotEmpty
                                  ? CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: baseUrl+review_image_base_url + ratinglist.reviewImage,
                                placeholder: (context, url) => Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black12,
                                    )),
                                errorWidget: (context, url, error) => const Icon(
                                  Icons.error,
                                  color: Colors.black26,
                                ),
                              )
                                  : Container(
                                  child: const Icon(Icons.error),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                  )),
                            ),
                            Container(
                              height: 25,
                              margin: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    ratinglist.customerName,
                                    style: const TextStyle(color: Colors.black87,fontSize: 12),
                                  ),
                                  const VerticalDivider(
                                    color: Colors.black87,
                                    thickness: 1,
                                    width: 10,
                                    indent: 4,
                                    endIndent: 0,
                                  ),
                                  Text(
                                    getupdatedDate(ratinglist.date),
                                    style: const TextStyle(color: Colors.black87,fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                              color: Colors.black54,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ))));
  }
}
