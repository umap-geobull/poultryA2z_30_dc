import 'dart:convert';
import 'dart:io';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../Admin_add_Product/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getwidget/getwidget.dart';


typedef OnSaveCallback = void Function();

class EditReview extends StatefulWidget {
  //Getcstomerdata reviewdata;
  String baseUrl,product_auto_id,product_order_auto_id,cusotmer_id,review_auto_id,review,
      finishingRating,qualityRating,sizeFitRating,priceRating, review_image,app_type_id;
  double overallRating;

  EditReview(
      this.baseUrl,
      this.product_auto_id,
      this.product_order_auto_id,
      this.cusotmer_id,
      this.review_auto_id,
      this.review,
      this.overallRating,
      this.finishingRating,
      this.qualityRating,
      this.sizeFitRating,
      this.priceRating,
      this.review_image,this.app_type_id);

  @override
  State<EditReview> createState() => EditReviewState(baseUrl,product_auto_id,product_order_auto_id,
      cusotmer_id,review_auto_id,review,
      overallRating,finishingRating,qualityRating,sizeFitRating,priceRating, review_image,app_type_id);
}

class EditReviewState extends State<EditReview> {
  String baseUrl,product_auto_id,product_order_auto_id,cusotmer_id,review_auto_id,review,
      finishingRating,qualityRating,sizeFitRating,priceRating, review_image,app_type_id;

  double overall_rating;

  EditReviewState(
      this.baseUrl,
      this.product_auto_id,
      this.product_order_auto_id,
      this.cusotmer_id,
      this.review_auto_id,
      this.review,
      this.overall_rating,
      this.finishingRating,
      this.qualityRating,
      this.sizeFitRating,
      this.priceRating,
      this.review_image,this.app_type_id);


  late File icon_img;
  late XFile pickedImageFile;
  final TextEditingController _textReviewController = TextEditingController();
  bool isIconSelected = false;
  final ImagePicker _picker = ImagePicker();

  bool isApiCallProcessing = false;

  int img_width = 0, img_height = 0;
  double finishing_rating=0.0, quality_rating=0.0, size_fit_rating=0.0, price_rating=0.0;

  SetReview() {
    if(finishingRating.isNotEmpty){
      finishing_rating=double.parse(finishingRating);
    }
    if(priceRating.isNotEmpty){
      price_rating=double.parse(priceRating);
    }
    if(sizeFitRating.isNotEmpty){
      size_fit_rating=double.parse(sizeFitRating);
    }
    if(qualityRating.isNotEmpty){
      quality_rating=double.parse(qualityRating);
    }
    _textReviewController.text = review;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SetReview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text('Edit Review',
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
        body:Stack(
          children: <Widget>[
            SingleChildScrollView(
              // controller: ModalScrollController.of(context),
              child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 30),
                  child: AnimatedPadding(
                      padding: MediaQuery.of(context).viewInsets,
                      duration: const Duration(milliseconds: 100),
                      child: Column(
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

                                    )],
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
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.orangeAccent,
                                ),
                                child: const Text('Update'),
                                onPressed: () {
                                  if (checkValid() == true) {
                                    editReviewApi();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ))),
            )
          ],
        )
    );
  }

  bool checkValid() {
    if (overall_rating == 0.0) {
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
      onTap: () => {
        showImageDialog()},
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
              child: isIconSelected ?
              ClipRRect(
                child: Image.file(
                  File(icon_img.path),
                  //  height: 150,
                  // width: 150,
                ),
              ):
                  review_image.isNotEmpty?
                  CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: baseUrl+review_image_base_url+review_image,
                    placeholder: (context, url) =>
                        Container(decoration: BoxDecoration(
                          color: Colors.grey[400],
                        )),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ):
                  const Icon(
                Icons.image,
                size: 20,
              ))),
    );
  }

  Future editReviewApi() async {
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
    print(cusotmer_id);
    print(finishingRating);
    print(priceRating);
    print(qualityRating);
    print(sizeRating);


    var url = baseUrl+'api/'+edit_review;

    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);

    if(isIconSelected==true){
      try {
        if(icon_img!=null){
          request.files.add(
            http.MultipartFile(
              'review_image',
              icon_img.readAsBytes().asStream(),
              await icon_img.length(),
              filename: icon_img.path.split('/').last,),);
        }
        else{
          request.fields["review_image"] = '';
        }
      }
      catch(exception){
        print('profile pic not selected');
        request.fields["review_image"] = '';
      }
    }
    else{
      request.fields["review_image"] = '';
    }
    request.fields["customer_auto_id"]=cusotmer_id;
    request.fields["product_auto_id"]=product_auto_id;
    request.fields["review"] = _textReviewController.text;
    request.fields["rating"]=overAllRating;
    request.fields["review_auto_id"] = review_auto_id;
    request.fields["finishing"] = finishingRating;
    request.fields["product_quality"] = qualityRating;
    request.fields["pricing"] = priceRating;
    request.fields["size_fitting"] = sizeRating;
    request.fields["app_type_id"] =app_type_id;

    http.Response response =
    await http.Response.fromStream(await request.send());
    final resp = jsonDecode(response.body);
    //String message=resp['msg'];
    if (response.statusCode == 200) {
      setState(() {
        isApiCallProcessing = false;
      });
      var status = resp['status'];
      if (status.toString() =='1') {
        Fluttertoast.showToast(
          msg: "Review updated successfully",
          backgroundColor: Colors.grey,
        );
        // widget.onSaveCallback();
        Navigator.pop(context);
      } else {
        var msg = resp['status'];
        Fluttertoast.showToast(
          msg: msg.toString(),
          backgroundColor: Colors.grey,
        );
      }
    }
  }

  showImageDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
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
       /* androidUiSettings: const AndroidUiSettings(
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
