import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:getwidget/getwidget.dart';
import '../../settings/Add_Size/Components/Get_SizeList_Model.dart';
import 'package:fluttertoast/fluttertoast.dart';


typedef OnSaveCallback = void Function(String title,String value,int index);

class AddSpecification extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  int product_index;

  AddSpecification(this.onSaveCallback, this.product_index);

  @override
  _AddSpecification createState() => _AddSpecification();
}

class _AddSpecification extends State<AddSpecification> {

  var titleController = TextEditingController();
  var valueController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              child: Container(
                  child: Column(
                     children: [
                      Center(
                        child:Container(
                          padding: EdgeInsets.only(top: 10,bottom: 10),
                          child: Text('Add Specification', style:
                          TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Divider(),
                      Container(
                        padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: <Widget>[
                            Text("Title",
                                style:
                                TextStyle(fontSize: 16, color: Colors.black)),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 45,
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                child: TextFormField(
                                  controller: titleController,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                      EdgeInsets.fromLTRB(10, 15, 0, 0),
                                      hintText: 'Enter specification title',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      )),

                                  // style: AppTheme.form_field_text,
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text("Description",
                                style:
                                TextStyle(fontSize: 16, color: Colors.black)),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 45,
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                child: TextFormField(
                                  controller: valueController,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                      EdgeInsets.fromLTRB(10, 15, 0, 0),
                                      hintText: 'Please enter specification description',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      )),

                                  // style: AppTheme.form_field_text,
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),

                            GestureDetector(
                              onTap: () {
                                if (titleController.text.isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: "Enter specification",
                                    backgroundColor: Colors.grey,
                                  );
                                }
                                else if (valueController.text.isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: "Enter specification value",
                                    backgroundColor: Colors.grey,
                                  );
                                }
                                else {
                                  Navigator.of(context).pop();
                                  widget.onSaveCallback(titleController.text,valueController.text,widget.product_index);
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                height: 45,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        (new Color(0xffF5591F)),
                                        new Color(0xffF2861E)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[200],
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 10),
                                        blurRadius: 50,
                                        color: Color(0xffEEEEEE)),
                                  ],
                                ),
                                child: Text(
                                  "Add Specification",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                      ],
                  )
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

