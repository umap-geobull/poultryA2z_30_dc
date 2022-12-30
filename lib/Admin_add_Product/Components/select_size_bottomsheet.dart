import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:getwidget/getwidget.dart';
import '../../settings/Add_Size/Components/Get_SizeList_Model.dart';
import 'package:fluttertoast/fluttertoast.dart';


//typedef OnSaveCallback = void Function(GetSizeList size,String price,int index);

typedef OnSaveCallback = void Function(List<GetSizeList> size,int index);

class SelectSize extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  int product_index;
  List<GetSizeList> size_List;
  List<GetSizeList> selectedSize;

  SelectSize(this.onSaveCallback, this.product_index,this.size_List, this. selectedSize);

  @override
  _SelectSize createState() => _SelectSize(size_List,selectedSize);
}

class _SelectSize extends State<SelectSize> {


 // GetSizeList? selectedSize;
  List<GetSizeList> selectedSize;
  List<GetSizeList> size_List;

  _SelectSize(this.size_List,this.selectedSize);


  TextEditingController priceController=TextEditingController();

  onBackPressed() {
    Navigator.of(context).pop();
  }

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
                    child:Container(
                      height: 400,
                      child: Column(
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
                              Expanded(child: Container(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  child: Text('SAVE'),
                                  onPressed: ()=>{
                                    widget.onSaveCallback(selectedSize,widget.product_index)
                                  },
                                ),
                              ))
                            ],
                          ),

                          Divider(
                            color: Colors.black54,
                          ),

                          Expanded(
                            flex: 1,
                            child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                ),
                                itemCount: size_List.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // return item
                                  return sizeItem(size_List[index]);
                                }),
                          ),
                        ],
                      ),
                    )),
              )
          );
        }
        ),
        onWillPop: ()=>onBackPressed()
    );

  }


  sizeItem(GetSizeList sizeList){
    return GestureDetector(

        onTap: ()=>{
          setSelected(sizeList)
        },
        child: Column(
          children: [
            Container(
              width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: isAdded(sizeList)==true ? Colors.green  : Colors.grey,
                        width: 2
                    )
                ),
                child: Text(
                  sizeList.size,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.black87,fontSize: 15,),
                )),
          ],
        )
    );

  }

  setSelected(GetSizeList size){
    if(isAdded(size) ==true){
      selectedSize.remove(size);
    }
    else{
      selectedSize.add(size);
    }
    setState(() {});
  }

  bool isAdded(GetSizeList size){
    for(int i=0;i<selectedSize.length;i++){
      if(selectedSize[i]==size){
        return true;
      }
    }
    return false;
  }
}

