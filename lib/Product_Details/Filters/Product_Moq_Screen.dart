import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

typedef OnSaveCallback = void Function(List<String> moq);

class Product_Moq_Screen extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String selectedMoq;

  Product_Moq_Screen(this.onSaveCallback, this.selectedMoq);

  @override
  _Product_Moq_ScreenState createState() => _Product_Moq_ScreenState();
}

class _Product_Moq_ScreenState extends State<Product_Moq_Screen> {
 /* bool isCheck = false, isCheck1 = false, isCheck2 = false, isCheck3 = false;
  bool isCheck4 = false, isCheck5 = false,isCheck6 = false, isCheck7 = false;
*/

  List<String> selectedmoq=[];

 /* @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 1,
              child:
              Container(
                child: Row(
                    mainAxisAlignment:  MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(value: isCheck, onChanged: (bool? checkBoxState){
                        if (checkBoxState != null) {
                          setState(() {
                            isCheck = checkBoxState;
                          });
                        }
                      }),

                      const Text("1",
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, color: Colors.black, ),
                          maxLines: 2),
                    ]
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(

                  child: Row(
                      mainAxisAlignment:  MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(value: isCheck1, onChanged: (bool? checkBoxState){
                          if (checkBoxState != null) {
                            setState(() {
                              isCheck1 = checkBoxState;
                            });
                          }
                        }),

                        const Text("5",
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, color: Colors.black, ),
                            maxLines: 2),
                      ]
                  )
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                  child: Row(
                      mainAxisAlignment:  MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(value: isCheck2, onChanged: (bool? checkBoxState){
                          if (checkBoxState != null) {
                            setState(() {
                              isCheck2 = checkBoxState;
                            });
                          }
                        }),

                        const Text("2",
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, color: Colors.black, ),
                            maxLines: 2),
                      ]

                  )
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(

                  child: Row(
                      mainAxisAlignment:  MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(value: isCheck3, onChanged: (bool? checkBoxState){
                          if (checkBoxState != null) {
                            setState(() {
                              isCheck3 = checkBoxState;
                            });
                          }
                        }),

                        const Text("6",
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, color: Colors.black, ),
                            maxLines: 2),
                      ]
                  )
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                  child: Row(
                      mainAxisAlignment:  MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(value: isCheck4, onChanged: (bool? checkBoxState){
                          if (checkBoxState != null) {
                            setState(() {
                              isCheck4= checkBoxState;
                            });
                          }
                        }),

                        const Text("3",
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, color: Colors.black, ),
                            maxLines: 2),
                      ]
                  )
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(

                  child: Row(
                      mainAxisAlignment:  MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(value: isCheck5, onChanged: (bool? checkBoxState){
                          if (checkBoxState != null) {
                            setState(() {
                              isCheck5 = checkBoxState;
                            });
                          }
                        }),

                        const Text("7",
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, color: Colors.black, ),
                            maxLines: 2),
                      ]

                  )
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                  child: Row(
                      mainAxisAlignment:  MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(value: isCheck6, onChanged: (bool? checkBoxState){
                          if (checkBoxState != null) {
                            setState(() {
                              isCheck6 = checkBoxState;
                            });
                          }
                        }),

                        const Text("4",
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, color: Colors.black, ),
                            maxLines: 2),
                      ]
                  )
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(

                  child: Row(
                      mainAxisAlignment:  MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(value: isCheck7, onChanged: (bool? checkBoxState){
                          if (checkBoxState != null) {
                            setState(() {
                              isCheck7 = checkBoxState;
                            });
                          }
                        }),

                        const Text("8",
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, color: Colors.black, ),
                            maxLines: 2),
                      ]
                  )
              ),
            ),
          ],
        ),
        Align(

          alignment : Alignment.bottomRight,
          child: Container(
            width: 240,
            margin: const EdgeInsets.only(top: 15, right: 10),
            alignment: Alignment.topRight,
            child: Row(
              children: const [
                Text(
                  "CLEAR FILTER", style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                SizedBox(width: 10,),
                Text(
                  "APPLY FILTER", style: TextStyle(fontSize: 14, color: Colors.blue),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
 */

  @override
  void initState() {
    super.initState();
    setData();
  }

  setData(){
    this.selectedmoq=widget.selectedMoq.split('|');
    if(this.mounted){
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children:[
            Container(
                margin: const EdgeInsets.only(top: 10),
                child: AnimatedPadding(
                  padding: MediaQuery.of(context).viewInsets,
                  duration: const Duration(milliseconds: 100),
                  child: Column(
                    children: <Widget>[
                      showcolorlistUi(),
                    ],
                  ),
                )),
          ]
      ),
    );
  }

  showcolorlistUi() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
          itemCount: 8,
          // physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1 / 0.4,
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) => SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 22,
                    width: 22,
                    child: Checkbox(
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {
                            if (isAdded((index+1).toString()) == true) {
                              selectedmoq.remove((index+1).toString());
                              widget.onSaveCallback(selectedmoq);
                            }
                            else {
                              selectedmoq.add((index+1).toString());
                              widget.onSaveCallback(selectedmoq);
                            }
                          });
                        }
                      },
                      value: isAdded((index+1).toString()),
                    ),
                    margin: const EdgeInsets.all(5),
                  ),
                  Flexible(
                    child: Text(
                       (index+1).toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  )
                ]),
          )),
    );
  }

  bool isAdded(String id) {
    for (int i = 0; i < selectedmoq.length; i++) {
      if (selectedmoq[i] == id) {
        return true;
      }
    }
    return false;
  }
}
