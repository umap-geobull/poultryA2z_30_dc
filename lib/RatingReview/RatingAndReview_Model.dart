import 'package:poultry_a2z/RatingReview/product_rating_model.dart';

class RatingAndReviewModel {
  RatingAndReviewModel({
    required this.status,
    required this.getalldata,
    required this.getcstomerdata,
    required this.totalNoOfReviews,
    required this.avgRating,
    required this.avgFinishing,
    required this.avgProductQuality,
    required this.avgPricing,
    required this.avgSizeFitting,
  });
  late final int status;
  late final List<GetRatingLists> getalldata;
  late final List<GetRatingLists> getcstomerdata;
  late final int totalNoOfReviews;
  late final int avgRating;
  late final int avgFinishing;
  late final int avgProductQuality;
  late final int avgPricing;
  late final int avgSizeFitting;

  RatingAndReviewModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    getalldata = List.from(json['getalldata']).map((e)=>GetRatingLists.fromJson(e)).toList();
    getcstomerdata = List.from(json['getcstomerdata']).map((e)=>GetRatingLists.fromJson(e)).toList();
    totalNoOfReviews = json['total_no_of_reviews'];
    avgRating = json['avg_rating'];
    avgFinishing = json['avg_finishing'];
    avgProductQuality = json['avg_product_quality'];
    avgPricing = json['avg_pricing'];
    avgSizeFitting = json['avg_size_fitting'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['getalldata'] = getalldata.map((e)=>e.toJson()).toList();
    _data['getcstomerdata'] = getcstomerdata.map((e)=>e.toJson()).toList();
    _data['total_no_of_reviews'] = totalNoOfReviews;
    _data['avg_rating'] = avgRating;
    _data['avg_finishing'] = avgFinishing;
    _data['avg_product_quality'] = avgProductQuality;
    _data['avg_pricing'] = avgPricing;
    _data['avg_size_fitting'] = avgSizeFitting;
    return _data;
  }
}


/*
class GetallReviewdata {
  GetallReviewdata({
    required this.id,
    required this.productAutoId,
    required this.customerAutoId,
    required this.name,
    required this.emailId,
    required this.mobileNumber,
    required this.rating,
    required this.review,
    required this.reviewImage,
    required this.rdate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String productAutoId;
  late final String customerAutoId;
  late final String name;
  late final String emailId;
  late final String mobileNumber;
  late final String rating;
  late final String review;
  late final String reviewImage;
  late final String rdate;
  late final String updatedAt;
  late final String createdAt;

  GetallReviewdata.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    productAutoId = json['product_auto_id'];
    customerAutoId = json['customer_auto_id'];
    name = json['name'];
    emailId = json['email_id'];
    mobileNumber = json['mobile_number'];
    rating = json['rating'];
    review = json['review'];
    reviewImage = json['review_image'];
    rdate = json['rdate'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['product_auto_id'] = productAutoId;
    _data['customer_auto_id'] = customerAutoId;
    _data['name'] = name;
    _data['email_id'] = emailId;
    _data['mobile_number'] = mobileNumber;
    _data['rating'] = rating;
    _data['review'] = review;
    _data['review_image'] = reviewImage;
    _data['rdate'] = rdate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}

class Getcstomerdata {
  Getcstomerdata({
    required this.id,
    required this.productAutoId,
    required this.customerAutoId,
    required this.name,
    required this.emailId,
    required this.mobileNumber,
    required this.rating,
    required this.review,
    required this.reviewImage,
    required this.rdate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String productAutoId;
  late final String customerAutoId;
  late final String name;
  late final String emailId;
  late final String mobileNumber;
  late final String rating;
  late final String review;
  late final String reviewImage;
  late final String rdate;
  late final String updatedAt;
  late final String createdAt;

  Getcstomerdata.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    productAutoId = json['product_auto_id'];
    customerAutoId = json['customer_auto_id'];
    name = json['name'];
    emailId = json['email_id'];
    mobileNumber = json['mobile_number'];
    rating = json['rating'];
    review = json['review'];
    reviewImage = json['review_image'];
    rdate = json['rdate'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['product_auto_id'] = productAutoId;
    _data['customer_auto_id'] = customerAutoId;
    _data['name'] = name;
    _data['email_id'] = emailId;
    _data['mobile_number'] = mobileNumber;
    _data['rating'] = rating;
    _data['review'] = review;
    _data['review_image'] = reviewImage;
    _data['rdate'] = rdate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}*/
