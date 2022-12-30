import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:getwidget/getwidget.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Get_SizeList_Model.dart';


typedef OnSaveCallback = void Function(GetSizeList size,String price,int index);

class SelectSize extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  int product_index;
  List<GetSizeList> size_List;

  SelectSize(this.onSaveCallback, this.product_index,this.size_List);

  @override
  _SelectSize createState() => _SelectSize(size_List[0]);
}

class _SelectSize extends State<SelectSize> {

  GetSizeList selectedSize;

  TextEditingController priceController=TextEditingController();

  _SelectSize(this.selectedSize);

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
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          'Add product size',style: TextStyle(color: Colors.black87,fontSize: 14),
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
                          const Text("Select Size",
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
                                value: selectedSize,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedSize = newValue as GetSizeList;
                                  });
                                },
                                items: widget.size_List.map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value.size),
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
                          const Text("Price",
                              style: TextStyle(color: Colors.black, fontSize: 16)),
                          const SizedBox(height: 10,),
                          Container(
                            child: Container(
                              child: TextFormField(
                                controller: priceController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                    hintText: "Please enter price",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      const BorderSide(color: Colors.blue, width: 1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      const BorderSide(color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(8),
                                    )),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(bottom: 100),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {

                          if(selectedSize!=null){
                           // ProductSize productSize=ProductSize(selectedSize, "1", priceController.text);
                            widget.onSaveCallback(selectedSize,priceController.text,widget.product_index,);
                          }
                          else{
                            Fluttertoast.showToast(
                              msg: "Please select size",
                            );
                          }
                          // Navigator.of(context).pop();
                        },
                        child: const Text("SAVE",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange[200],
                          onPrimary: Colors.orange,
                          minimumSize: const Size(70, 30),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(2.0)),
                          ),
                        ),
                      ),
                    )
                    ],
                )
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

