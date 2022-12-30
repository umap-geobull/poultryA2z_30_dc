import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';

import '../Admin_add_Product/Components/Model/size_model.dart';

typedef OnSaveCallback = void Function(String productAutoId,String moq,String size);

class SelectProdSize extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String productAutoId;
  String moq;
  List<ProdSize> size;

  SelectProdSize(this.onSaveCallback,this.productAutoId,this.moq,this.size);

  @override
  _SelectProdSize createState() => _SelectProdSize(size);
}

class _SelectProdSize extends State<SelectProdSize> {
  List<ProdSize> size;

  _SelectProdSize(this.size);

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
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Center(
                      child: Text('Select Size ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(
                    height: 10.0,
                  ),
                  // addSize(),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: 10,
                        bottom: MediaQuery
                            .of(context)
                            .viewInsets
                            .bottom),
                    child: Container(
                      // width: MediaQuery.of(context).size.width,
                      child:addSize(size),
                    ),
                  ),
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

  addSize(List<ProdSize> size){

    if(size.isNotEmpty){
      return Container(
        margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Select Size",
                style: TextStyle(
                    fontSize: 15, color: Colors.black)),
            const SizedBox(
              height: 8,
            ),
            Container(
              // width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(6),
                alignment: Alignment.centerLeft,
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: getSizeList(size),
                )
            ) ,
            Divider(color: Colors.grey.shade300),
          ],
        ),
      );
    }
    else{
      return Container();
    }
  }

  List<Widget> getSizeList(List<ProdSize> size){
    List<Widget> sizeList=[];

    if(size.isNotEmpty){
      for(int index=0;index<size.length;index++){
        sizeList.add(
            GestureDetector(
              onTap: ()=>{
                widget.onSaveCallback(widget.productAutoId,widget.moq, size[index].sizeAutoId),
               // Navigator.of(context).pop()
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 2,right: 2,top: 0),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.5),
                      ),
                      child: Text(size[index].sizeName,
                        textAlign:TextAlign.center,style: const TextStyle(color:Colors.black87,fontSize: 17),),

                    ),
                    /*  pricelist.isNotEmpty && !(pricelist.length <sizelist.length)?
                    Text("₹" +pricelist[index].sizePrice):*/
                  ],
                ),
              ),
            )
        );
      }
    }
  /*  else{
      addToCart(productAutoId,moq,'');
    }*/
    return sizeList;
  }

  onBackPressed() {
    Navigator.of(context).pop();
  }
}

