import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';

typedef OnSaveCallback = void Function(int i,String colorName,List<File> colorImage);

class SelectColor extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  int product_index;
  List<File> selectedImage;
  String selected;

  SelectColor(this.onSaveCallback,this.product_index,this.selected,this.selectedImage);

  @override
  _SelectColor createState() => _SelectColor(selected,selectedImage);
}

class _SelectColor extends State<SelectColor> {
  String selected;
  List<File> selectedImage;

  _SelectColor(this.selected, this.selectedImage);

  List<String> colorList=[
    'Select Color Name','Black','White','Red','Yellow','Blue','Pink','Orange','Green'
  ];

  bool isImageSelected=false;

  Future<void> select_Color() async {
    ImagePicker imagePicker = ImagePicker();

    var selectedImages  = await imagePicker.pickImage(source: ImageSource.gallery);

    //  List<XFile> selectedImages = await imagePicker.pickMultiImage();

    if(selectedImages!=null){
        File selectedImg = File(selectedImages.path);
        if(selectedImage.isEmpty){
          selectedImage.add(selectedImg);
        }
        else{
          selectedImage[0]=selectedImg;
        }
        isImageSelected=true;
        //product_info_model_List[i].colorImage=selectedImg;
        //imageColorList![0]=selectedImg;
      }

    if(mounted){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: StatefulBuilder(builder: (context, setState) {
      return Material(
          child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: ()=>{
                            onBackPressed()
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ),
                      const Text(
                        'Add product color',style: TextStyle(color: Colors.black87,fontSize: 14),
                      ),
                    ],
                  ),

                  const Divider(
                    color: Colors.black54,
                  ),

                  Container(
                    margin: const EdgeInsets.only(top:20,left: 20,right: 20,bottom: 20),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("Color Name",
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: DropdownButtonHideUnderline(
                            child: GFDropdown(
                              padding: const EdgeInsets.all(15),
                              borderRadius: BorderRadius.circular(5),
                              border: const BorderSide(
                                  color: Colors.black12, width: 1),
                              dropdownButtonColor: Colors.white,
                              value: selected,
                              onChanged: (newValue) {
                                setState(() {
                                  selected = newValue as String;
                                });
                              },
                              items: colorList.map((value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 20,right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("Color Image",
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                        const SizedBox(height: 10,),
                        selectedImage.isNotEmpty?
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          alignment: Alignment.center,
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: InkWell(
                                    onTap: () {
                                      select_Color();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.grey.shade300, width: 1.5),
                                      ),
                                      child: Image.file(selectedImage[0]),
                                    ),
                                  )

                              ),
                            ],
                          ),
                        ) :
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          alignment: Alignment.center,
                          child:GestureDetector(
                            onTap: ()=>{select_Color()},
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: const Text('Select Color Image'),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.blue,
                                      width: 1
                                  ),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        if(isImageSelected==true){
                          widget.onSaveCallback(widget.product_index,selected,selectedImage);
                        }
                       // Navigator.of(context).pop();
                      },
                      child: const Text("SAVE",
                          style: TextStyle(
                              color: Colors.black54, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange[200],
                        onPrimary: Colors.orange,
                        minimumSize: const Size(100, 40),
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(2.0)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
      );
    }
    ),
        onWillPop: ()=>onBackPressed()
    );

  }

  onBackPressed() {
    Navigator.of(context).pop();
  }
}

