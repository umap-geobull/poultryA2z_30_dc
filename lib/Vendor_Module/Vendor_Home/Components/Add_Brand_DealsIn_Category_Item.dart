import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/App_Apis.dart';
import '../Utils/constants.dart';
import 'choose_Brand_DealIn_Category_list.dart';

class Add_Brand_DealsIn_Category_Item extends StatefulWidget {
  Add_Brand_DealsIn_Category_Item({Key? key, required this.type})
      : super(key: key);
  String type;

  @override
  _Add_Brand_DealsIn_Category_ItemState createState() =>
      _Add_Brand_DealsIn_Category_ItemState();
}

class _Add_Brand_DealsIn_Category_ItemState
    extends State<Add_Brand_DealsIn_Category_Item> {
  File? _brand_img;
  final ImagePicker _picker = ImagePicker();
  String brand_name = "", user_id = "";
  bool isApiCallProcess = false;
  String baseUrl="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
            widget.type == 'brand'
                ? "Add Brand"
                /* : widget.type == 'deals_in'
              ? "Add Category"*/
                : "Add Category",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      bottomSheet: Checkout_Section(context),
      body: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.type == 'brand'
                          ? "Add Brand Image"
                          /* : widget.type == 'deals_in'
                        ? "Add Category Image"*/
                          : "Add Category Image",
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        showImageDialog();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          width: 150,
                          height: 150,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: _brand_img != null
                              ? Image.file(
                                  _brand_img!,
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.fitHeight,
                                )
                              : SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      'assets/upload_image.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey.shade300),
                    Text(
                        widget.type == 'brand'
                            ? "Brand name"
                            /*: widget.type == 'deals_in'
                        ? "Category Name"*/
                            : "Category Name",
                        style: const TextStyle(color: Colors.black, fontSize: 16)),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 45,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: TextFormField(
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                              hintText: widget.type == 'brand'
                                  ? "Enter the brand Name"
                                  /* : widget.type == 'deals_in'
                                  ? "Enter the Category Name"*/
                                  : "Enter the Category Name",
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onChanged: (value) => brand_name = value,
                          // style: AppTheme.form_field_text,
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey.shade300),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget Checkout_Section(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () {
                if (_brand_img == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Select image"),
                  ));
                } else if (brand_name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Enter the name"),
                  ));
                } else {

                  widget.type == 'brand' ? add_Newbrand() : add_NewCategory();
                }
                /* Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => choose_Brand_DealIn_Category_list(type: 'brand',)),
                );*/
              },
              child: Center(
                  child: Text(
                    widget.type == 'brand'
                        ? "Add Brand"
                    /*: widget.type == 'deals_in'
                    ? "Add Category"*/
                        : "Add Category",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),

            ),
          )),
    );
  }

  showImageDialog() {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Upload image from'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              getCameraImage();
            },
            child: const Text('Camera'),
          ),
          SimpleDialogOption(
            onPressed: () {
              getGalleryImage();
            },
            child: const Text('Gallery'),
          ),
        ],
      ),
    );
  }

  Future getCameraImage() async {
    Navigator.of(context).pop(false);

    var image = await _picker.pickImage(source: ImageSource.camera);
    if (mounted) {
      setState(() {
        _brand_img = File(image!.path);
      });
    }
  }

  Future getGalleryImage() async {
    Navigator.of(context).pop(false);
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (mounted) {
      setState(() {
        // _brand_img = image as File;
        _brand_img = File(image!.path);
      });
    }
  }

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl =prefs.getString('base_url');

    if(baseUrl!=null){
      setState(() {
        this.baseUrl=baseUrl;
      });
    }
    return null;
  }

  void add_Newbrand() async {
    var request = http.MultipartRequest(
        "POST", Uri.parse(baseUrl+'api/'+ add_new_brand_vendor));
    request.fields["user_auto_id"] = user_id;
    request.fields["brand_name"] = brand_name;
    request.fields["brand_image_web"] = '';

    if (_brand_img != null) {
      var imageStream = http.ByteStream(_brand_img!.openRead());
      var imageLength = await _brand_img!.length();
      print("img_certificate_img=>" + _brand_img.toString());
      var gstFile = http.MultipartFile(
          'brand_image_app', imageStream, imageLength,
          filename: brand_name + '_img.jpg');
      request.files.add(gstFile);
    } else {
      print("img_certificate_img=>" + _brand_img.toString());
    }

    var response = await request.send();

    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);

    final body = json.decode(responseString);

    final int status = body['status'];
    // final String msg = body['msg'];
    if (status == 1) {
      Navigator.pop(context);

      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => choose_Brand_DealIn_Category_list(
                  type: 'brand',
                )),
      );
      Fluttertoast.showToast(
        msg: "Brand added successfully",
        backgroundColor: Colors.grey,
      );
    } else {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('failed'),
      ));
    }
  }

  Future<void> add_NewCategory() async {
    var request = http.MultipartRequest(
        "POST", Uri.parse(baseUrl+'api/' + add_new_category_vendor));
    request.fields["user_auto_id"] = user_id;
    request.fields["category_name"] = brand_name;
    request.fields["category_image_web"] = '';

    if (_brand_img != null) {
      var imageStream = http.ByteStream(_brand_img!.openRead());
      var imageLength = await _brand_img!.length();
      print("img_certificate_img=>" + _brand_img.toString());
      var gstFile = http.MultipartFile(
          'category_image_app', imageStream, imageLength,
          filename: brand_name + '_img.jpg');
      request.files.add(gstFile);
    } else {
      print("img_certificate_img=>" + _brand_img.toString());
    }

    var response = await request.send();

    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);

    final body = json.decode(responseString);

    final int status = body['status'];
    // final String msg = body['msg'];
    if (status == 1) {
      Navigator.pop(context);

      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => choose_Brand_DealIn_Category_list(
                  type: 'category',
                )),
      );
      Fluttertoast.showToast(
        msg: "Category added successfully",
        backgroundColor: Colors.grey,
      );
    } else {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('failed'),
      ));
    }
  }
}
