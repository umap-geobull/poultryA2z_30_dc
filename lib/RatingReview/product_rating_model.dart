class GetRatingLists {
  GetRatingLists({
    required this.ratingAutoId,
    required this.productAutoId,
    required this.productName,
    required this.customerAutoId,
    required this.customerName,
    required this.emailId,
    required this.mobileNumber,
    required this.rating,
    required this.finishing,
    required this.productQuality,
    required this.pricing,
    required this.sizeFitting,
    required this.review,
    required this.reviewImage,
    required this.date,
  });
  late final String ratingAutoId;
  late final String productAutoId;
  late final String productName;
  late final String customerAutoId;
  late final String customerName;
  late final String emailId;
  late final String mobileNumber;
  late final String rating;
  late final String finishing;
  late final String productQuality;
  late final String pricing;
  late final String sizeFitting;
  late final String review;
  late final String reviewImage;
  late final String date;

  GetRatingLists.fromJson(Map<String, dynamic> json){
    ratingAutoId = json['rating_auto_id'];
    productAutoId = json['product_auto_id'];
    productName = json['product_name'];
    customerAutoId = json['customer_auto_id'];
    customerName = json['customer_name'];
    emailId = json['email_id'];
    mobileNumber = json['mobile_number'];
    rating = json['rating'];
    finishing = json['finishing'];
    productQuality = json['product_quality'];
    pricing = json['pricing'];
    sizeFitting = json['size_fitting'];
    review = json['review'];
    reviewImage = json['review_image'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['rating_auto_id'] = ratingAutoId;
    _data['product_auto_id'] = productAutoId;
    _data['product_name'] = productName;
    _data['customer_auto_id'] = customerAutoId;
    _data['customer_name'] = customerName;
    _data['email_id'] = emailId;
    _data['mobile_number'] = mobileNumber;
    _data['rating'] = rating;
    _data['finishing'] = finishing;
    _data['product_quality'] = productQuality;
    _data['pricing'] = pricing;
    _data['size_fitting'] = sizeFitting;
    _data['review'] = review;
    _data['review_image'] = reviewImage;
    _data['date'] = date;
    return _data;
  }
}