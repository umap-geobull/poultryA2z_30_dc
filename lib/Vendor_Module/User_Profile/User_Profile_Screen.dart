import 'dart:io';

import 'package:flutter/material.dart';

import '../../Admin_add_Product/constants.dart';
import 'package:image_picker/image_picker.dart';
class User_Profile_Screen extends StatefulWidget {
  const User_Profile_Screen({Key? key}) : super(key: key);

  @override
  _User_Profile_ScreenState createState() => _User_Profile_ScreenState();
}

class _User_Profile_ScreenState extends State<User_Profile_Screen> {
  File? profile_img;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text("Profile",
              style: TextStyle(color: Colors.white, fontSize: 16)),
          leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        bottomSheet: Checkout_Section(context),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                SizedBox(
                height: 115,
                width: 115,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                profile_img == null
                ? const CircleAvatar(
                      backgroundImage: AssetImage("assets/profileicon.png"),
                    ):
                CircleAvatar(
                  backgroundImage: FileImage(profile_img!),
                ),
                    Positioned(
                        bottom: -10,
                        right: -25,
                        child: RawMaterialButton(
                          onPressed: () {
                            showImageDialog();
                          },
                          elevation: 2.0,
                          fillColor: const Color(0xFFF5F6F9),
                          child: const Icon(Icons.camera_alt_outlined, color: Colors.blue,),
                          padding: const EdgeInsets.all(8.0),
                          shape: const CircleBorder(),
                        )),
                  ],
                ),
              ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text("User Name",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
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
                                hintText: "Enter the user name",
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
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
                            // style: AppTheme.form_field_text,

                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.text,
                            onChanged: (value) => {

                              setState(() {})
                            },

                          ),
                        ),
                      ),
                      Divider(color: Colors.grey.shade300),
                      const Text("Mobile Number",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
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
                                hintText: "Enter the user mobile number",
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
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
                            // style: AppTheme.form_field_text,


                            keyboardType: TextInputType.number,
                            onChanged: (value) => {

                              setState(() {})
                            },
                            minLines: null,
                            textAlignVertical: TextAlignVertical.top,
                            maxLines: null,
                            // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
                            expands: true,
                          ),
                        ),
                      ),
                      Divider(color: Colors.grey.shade300),
                      const Text("Email",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
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
                                hintText: "Enter the user email",
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
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
                            // style: AppTheme.form_field_text,

                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.text,
                            onChanged: (value) => {

                              setState(() {})
                            },

                          ),
                        ),
                      ),
                      Divider(color: Colors.grey.shade300),
                     /* Text("Address",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 90,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: TextFormField(
                            decoration: InputDecoration(
                                filled: true,
                                hintText: "Enter the user address",
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.blue, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            // style: AppTheme.form_field_text,

                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            onChanged: (value) => {

                              setState(() {})
                            },
                            minLines: null,
                            textAlignVertical: TextAlignVertical.top,
                            maxLines: null,
                            // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
                            expands: true,
                          ),
                        ),
                      ),
                      Divider(color: Colors.grey.shade300),*/

                    ],
                  ),
                ],
              ),
            )));
  }

  Widget Checkout_Section(BuildContext context) {
    return Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () {
              },
              child: const Center(
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        )
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

    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      profile_img = File(image!.path);
    });

  }

  Future getGalleryImage() async {
    Navigator.of(context).pop(false);
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      profile_img = File(image!.path);
    });

  }
}
