import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/AppConfig.dart';
import '../Utils/App_Apis.dart';
import 'package:http/http.dart' as http;
typedef TapNameCallback =  void Function();
class AddProduct extends StatefulWidget {
  final TapNameCallback getProduct;
  const AddProduct({Key? key, required this.getProduct}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  bool isAddProductProcessing = false;
  TextEditingController nameTxt = TextEditingController();
  late File product ;
  bool isfileuploaded = false;
  String user_id = "", baseUrl = "";
  bool isApiCallProcess = false;
  var shopnameController = TextEditingController();
  var shopAddressController = TextEditingController();
  var shopCityController = TextEditingController();
  var shopMin_OrderController = TextEditingController();
  var shopPrice_RangeController = TextEditingController();

  Color appBarColor = Colors.white,
      appBarIconColor = Colors.black,
      primaryButtonColor = Colors.orange,
      secondaryButtonColor = Colors.orangeAccent;
  Color bottomBarColor = Colors.white, bottomMenuIconColor = Color(0xFFFF7643);
  bool isApiCallProcessing = true;
  String admin_auto_id = '63b2612f9821ce37456a4b31';

  void getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');

    if (baseUrl != null) {
      this.baseUrl = baseUrl;
      // get_Vendor_Info();
    }

  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();

  }

  Future addProduct() async {
    setState(() {
      isAddProductProcessing = true;
    });


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('user_id');
    // print("login body ${body}");

    print("user id ${userID}");
    var url = AppConfig.grobizBaseUrl + add_vproduct;

    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);
    request.fields["user_auto_id"] = userID!;
    request.fields["product_name"] = nameTxt.text!;

    try {
      if (product != null) {
        request.files.add(
          http.MultipartFile(
            'product_image',
            product.readAsBytes().asStream(),
            await product.length(),
            filename: product.path.split('/').last,
          ),
        );
      } else {
        request.fields["product_image"] = '';
      }
    } catch (exception) {
      print('resume not selected');
      request.fields["product_image"] = '';
    }


    http.Response response =
    await http.Response.fromStream(await request.send());

    print("product response  ${response.body}");
    if (response.statusCode == 200) {


      final resp = jsonDecode(response.body);
      int status = resp['status'];
      widget.getProduct();
      Fluttertoast.showToast(msg: response.statusCode.toString());


      setState(() {
        isAddProductProcessing = false;
      });
      Navigator.pop(context);

    } else {
      setState(() {
        isAddProductProcessing = false;
      });

      Fluttertoast.showToast(msg: response.statusCode.toString());
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      color: Colors.transparent, //could change this to Color(0xFF737373),
      //so you don't have to change MaterialApp canvasColor
      child: SingleChildScrollView(
        child: Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0))),
            child:
            Center(child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Add Product",style: TextStyle(fontSize: 18,color: Colors.black ,fontWeight: FontWeight.bold),),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.close,color: primaryButtonColor,),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Divider(
                  color: Colors.grey[200],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          // width: 70,
                            child: Text(
                              "Add new Product",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                            )),
                        SizedBox(height: 5,),
                        InkWell(
                          onTap: () async {

                            FilePickerResult? result =
                            await FilePicker.platform
                                .pickFiles(
                              type: FileType.custom,
                              allowedExtensions: [
                                'jpg',
                                'png'
                              ],
                            );
                            if (result != null) {
                              PlatformFile file =
                                  result.files.first;
                              setState(() {
                                product =
                                    File(file.path!);
                                print(
                                    "${product.path.isEmpty}");
                                isfileuploaded = true;
                              });

                              print(file.name);
                              print(file.bytes);
                              print(file.size);
                              print(file.extension);
                              print(file.path);
                            } else {
                              print('No file selected');
                            }
                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(
                                    Radius.circular(
                                        10)),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      color:
                                      Color.fromRGBO(0, 0, 0, 0.15),
                                      offset:
                                      Offset(1, 6),
                                      blurRadius: 12)
                                ],
                                border: Border.all(
                                    color: Colors.grey),
                              ),
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              child: isfileuploaded == true ? Image.file(
                                  File(product.path)):Icon(Icons.image,color: Colors.grey[300],size: 40,)),
                        ),
                        const SizedBox(height: 15),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                child: Text(
                                  "Enter Product Name",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                                )),
                            SizedBox(height: 5,),

                            TextFormField(
                                controller: nameTxt,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding:
                                    const EdgeInsets.fromLTRB(
                                        10, 15, 0, 0),
                                    hintText:
                                    'Please enter Product Name',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1),
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1),
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 1),
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    )),
                                // style: AppTheme.form_field_text,
                                keyboardType: TextInputType.text

                            ),
                          ],
                        ),

                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.all(16),
                          color: Colors.white,
                          child: isAddProductProcessing == true
                              ? Container(
                            height: 60,
                            alignment: Alignment.center,
                            width: 80,
                            child: const GFLoader(type: GFLoaderType.circle),
                          )
                              : InkWell(
                            onTap: () async {
                              if (nameTxt.text.isNotEmpty && product.path.isNotEmpty) {
                                print("Validate number");
                                await addProduct();
                              }else{
                                Fluttertoast.showToast(msg: "Please enter product name and image");
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: primaryButtonColor,
                              ),
                              height: 40,
                              padding: EdgeInsets.all(4),
                              alignment: Alignment.center,
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ))),
      ),
    );
  }
}
