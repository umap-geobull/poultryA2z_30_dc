import 'dart:convert';
import 'dart:io';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';
import '../Utils/constants.dart';

typedef OnSaveCallback = void Function();

class AddReview extends StatefulWidget {
  String customerautoid,product_auto_id,baseUrl,product_order_auto_id, admin_auto_id,app_type_id;
  double rating;

  AddReview(this.customerautoid, this.product_auto_id, this.baseUrl,this.product_order_auto_id, this.rating, this.admin_auto_id,this.app_type_id);

  @override
  State<AddReview> createState() => AddReviewState(customerautoid, product_auto_id, baseUrl,product_order_auto_id,rating, admin_auto_id,app_type_id);
}

class AddReviewState extends State<AddReview> {
  String customerautoid,product_auto_id,baseUrl,product_order_auto_id, admin_auto_id,app_type_id;

  AddReviewState(this.customerautoid, this.product_auto_id, this.baseUrl,this.product_order_auto_id,this.overall_rating,this.admin_auto_id,this.app_type_id);

  late File icon_img;
  late XFile pickedImageFile;
  final TextEditingController _textReviewController = TextEditingController();
//  String customerautoid='62ac5ce934b0661121074cd2',product_auto_id='62ab00fd76352c1b3b548462';


  bool isIconSelected = false;
  final ImagePicker _picker = ImagePicker();

  bool isApiCallProcessing = false;

  int img_width = 0, img_height = 0;

  double overall_rating,finishing_rating=0.0, quality_rating=0.0, size_fit_rating=0.0, price_rating=0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: appBarColor,
            title: const Text('Rate & Review Product',
                style: TextStyle(
                    color: appBarIconColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            leading: IconButton(
              onPressed: ()=>{
                Navigator.of(context).pop()
              },
              icon: const Icon(Icons.arrow_back, color: appBarIconColor),
            ),
        ),
      body:Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 30),
                child: AnimatedPadding(
                    padding: MediaQuery.of(context).viewInsets,
                    duration: const Duration(milliseconds: 100),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Column(
                              children: [
                                uploadLogoUi(),
                                Container(margin: const EdgeInsets.all(0),
                                    child:const Text(
                                      'Product image',
                                      style:
                                      TextStyle(color: Colors.black87, fontSize: 12),
                                    )
                                ),
                              ],
                            ),
                            Expanded(
                              flex: 1,
                              child:Column(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.all(10),
                                      child:const Text(
                                        'Rate Product:',
                                        style:
                                        TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                                      )
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child:GFRating(
                                      color: Colors.orangeAccent,
                                      borderColor: Colors.orangeAccent,
                                      value: overall_rating,
                                      size: GFSize.SMALL,
                                      onChanged: (value) {
                                        setState(() {
                                          overall_rating = value;
                                        });
                                      },
                                    ),

                                  )
/*                                  RatingBar.builder(
                                    initialRating: 0,
                                    minRating: 1,
                                    itemSize: 30,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                      this.rating=rating.toString();
                                    },
                                  )*/],
                              ),)
                          ],
                        ),
                        Divider(height: 20,thickness: 2,),
                        Text('Please write your review',style: TextStyle(color: Colors.black,fontSize: 15,),),
                        Container(
                            height: 120,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.only(left: 5, right: 5,top: 5),
                            width: MediaQuery.of(context).size.width,
                            child: TextField(
                              controller: _textReviewController,
                              maxLines: 10,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 5,bottom: 5,left: 5,right: 5),
                                  border: InputBorder.none,
                                  hintText: 'Please enter your review'),
                            )),
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Tell us more about your experience',style: TextStyle(color: Colors.black,fontSize: 15,),),
                              SizedBox(height: 20,),
                              Container(
                                margin: EdgeInsets.all(5),
                                child:Row(
                                  children: <Widget>[
                                    Text('Product quality',
                                        style: TextStyle(color: Colors.black,fontSize: 17)),
                                    Expanded(child:
                                    Container(
                                      alignment: Alignment.centerRight,
                                      width: MediaQuery.of(context).size.width,
                                      child:GFRating(
                                        value: quality_rating,
                                        size: GFSize.SMALL,
                                        onChanged: (value) {
                                          setState(() {
                                            quality_rating = value;
                                          });
                                        },
                                      ),

                                    ))
                                  ],
                                )
                              ),
                              Divider(),
                              Container(
                                  margin: EdgeInsets.all(5),
                                  child:Row(
                                    children: <Widget>[
                                      Text('Product finishing',
                                          style: TextStyle(color: Colors.black,fontSize: 17)),
                                      Expanded(child: Container(
                                        alignment: Alignment.centerRight,
                                        width: MediaQuery.of(context).size.width,
                                        child:GFRating(
                                          value: finishing_rating,
                                          size: GFSize.SMALL,
                                          onChanged: (value) {
                                            setState(() {
                                              finishing_rating = value;
                                            });
                                          },
                                        ),

                                      ))
                                    ],
                                  )
                              ),
                              Divider(),
                              Container(
                                  margin: EdgeInsets.all(5),
                                  child:Row(
                                    children: <Widget>[
                                      Text('Size/Fit',
                                          style: TextStyle(color: Colors.black,fontSize: 17)),
                                      Expanded(child: Container(
                                        alignment: Alignment.centerRight,
                                        width: MediaQuery.of(context).size.width,
                                        child:GFRating(
                                          value: size_fit_rating,
                                          size: GFSize.SMALL,
                                          onChanged: (value) {
                                            setState(() {
                                              size_fit_rating = value;
                                            });
                                          },
                                        ),

                                      ))
                                    ],
                                  )
                              ),
                              Divider(),
                              Container(
                                  margin: EdgeInsets.all(5),
                                  child:Row(
                                    children: <Widget>[
                                      Text('Overall price',
                                          style: TextStyle(color: Colors.black,fontSize: 17)),
                                      Expanded(child: Container(
                                        alignment: Alignment.centerRight,
                                        width: MediaQuery.of(context).size.width,
                                        child:GFRating(
                                          value: price_rating,
                                          size: GFSize.SMALL,
                                          onChanged: (value) {
                                            setState(() {
                                              price_rating = value;
                                            });
                                          },
                                        ),

                                      ))
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          margin: const EdgeInsets.only(top: 45),
                          child: SizedBox(
                            width: 150,
                            child:
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orangeAccent,
                              ),
                              child: const Text('Submit'),
                              onPressed: () {
                                if (checkValid() == true) {
                                  print(checkValid());
                                  addReviewApi();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ))),
          ),
          isApiCallProcessing==true?
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: const GFLoader(
                type:GFLoaderType.circle
            ),
          ):
          Container()
        ],
      )
    );
  }

  bool checkValid() {
    if (overall_rating==0.0) {
      Fluttertoast.showToast(
        msg: "Please add rating",
        backgroundColor: Colors.grey,
      );
      return false;
    }
    return true;
  }

  Widget uploadLogoUi() {
    return GestureDetector(
      onTap: () => {showImageDialog()},
      child:
      Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.grey
            ),
          ),
          height: 80,
          width: 80,
          alignment: Alignment.center,
          child: Container(
              child: isIconSelected
                  ? ClipRRect(
                child: Image.file(
                  File(icon_img.path),

                ),
              )
                  : const Icon(
                Icons.image,
                size: 20,
                color: Colors.grey,
              ))),
    );
  }

  Future addReviewApi() async {
    if(this.mounted){
      setState(() {
        isApiCallProcessing = true;
      });
    }

    String sizeRating='',priceRating='',qualityRating='',finishingRating='',overAllRating='';


    if(size_fit_rating!=0.0){
      sizeRating=size_fit_rating.toString();
    }
    if(finishing_rating!=0.0){
      finishingRating=finishing_rating.toString();
    }
    if(quality_rating!=0.0){
      qualityRating=quality_rating.toString();
    }
    if(price_rating!=0.0){
      priceRating=price_rating.toString();
    }
    if(overall_rating!=0.0){
      overAllRating=overall_rating.toString();
    }

    print(product_auto_id);
    print(customerautoid);
    print(finishingRating);
    print(priceRating);
    print(qualityRating);
    print(sizeRating);

    var url = baseUrl+'api/'+add_review;

    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);
    try {
      if (icon_img != null) {
        request.files.add(http.MultipartFile('review_image', icon_img.readAsBytes().asStream(),await icon_img.length(),
            filename: icon_img.path.split('/').last,
          ),
        );
      }
      else {
        request.fields["review_image"] = '';
      }
    }catch(exception){
      print('profile pic not selected');
      request.fields["review_image"] = '';
    }
    request.fields["customer_auto_id"]=customerautoid;
    request.fields["product_auto_id"]=product_auto_id;
    request.fields["review"] = _textReviewController.text;
    request.fields["rating"]=overAllRating;
    request.fields["product_order_auto_id"] = product_order_auto_id;
    request.fields["finishing"] = finishingRating;
    request.fields["product_quality"] = qualityRating;
    request.fields["pricing"] = priceRating;
    request.fields["size_fitting"] = sizeRating;
    request.fields["admin_auto_id"] = admin_auto_id;
    request.fields["app_type_id"] =app_type_id;

    http.Response response =
        await http.Response.fromStream(await request.send());
      final resp = jsonDecode(response.body);
    print(response.statusCode);

    //String message=resp['msg'];
    if (response.statusCode == 200) {
      setState(() {
        isApiCallProcessing = false;
      });
      var status = resp['status'];
      if (status == 1) {
        Fluttertoast.showToast(
          msg: "Review added successfully",
          backgroundColor: Colors.grey,
        );
        Navigator.pop(context);
      } else {
        String msg= resp['msg'];

        Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.grey,
        );
      }
    }
    else if (response.statusCode==500){
      Fluttertoast.showToast(
        msg: "Server error",
        backgroundColor: Colors.grey,
      );
    }
  }

  showImageDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Upload image from',
            style: TextStyle(color: Colors.black87),
          ),
          content: SizedBox(
            height: 110,
            child: Column(
              children: <Widget>[
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      getCameraImage();
                    },
                    child: const Text("Camera",
                        style: TextStyle(color: Colors.black54, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.blue,
                      minimumSize: const Size(150, 30),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      getGalleryImage();
                    },
                    child: const Text("Gallery",
                        style: TextStyle(color: Colors.black54, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.blue,
                      minimumSize: const Size(150, 30),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future getCameraImage() async {
    Navigator.of(context).pop(false);
    var pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      pickedImageFile = pickedFile;

      File selectedImg = File(pickedImageFile.path);

      icon_img = selectedImg;
      isIconSelected = true;

      getFileSize();
      /*if(selectedImg!=null){
        cropImage(selectedImg);
      }*/
    }
  }

  Future getGalleryImage() async {
    Navigator.of(context).pop(false);
    var pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      pickedImageFile = pickedFile;

      File selectedImg = File(pickedImageFile.path);

      icon_img = selectedImg;
      print(icon_img);
      isIconSelected = true;

      getFileSize();
      /* if(selectedImg!=null){
        cropImage(selectedImg);
      }*/
    }
  }

  cropImage(File icon) async {
    File? croppedFile = (await ImageCropper().cropImage(
        sourcePath: icon.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
      /*  androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        )*/
    )) as File?;

    if (croppedFile != null) {
      icon_img = croppedFile;
      isIconSelected = true;

      getFileSize();
    }
  }

  getFileSize() async {
    var decodedImage = await decodeImageFromList(icon_img.readAsBytesSync());
    img_height = decodedImage.height;
    img_width = decodedImage.width;

    if (mounted) {
      setState(() {});
    }
  }
}
