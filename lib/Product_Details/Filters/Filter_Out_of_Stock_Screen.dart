import 'package:flutter/material.dart';

typedef OnSaveCallback = void Function(String stock);

class Filter_Out_of_Stock_Screen extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String selectedtype;

  Filter_Out_of_Stock_Screen(this.onSaveCallback, this.selectedtype);

  @override
  _Filter_Out_of_Stock_ScreenState createState() => _Filter_Out_of_Stock_ScreenState(selectedtype);
}
class SortByClass{
  String title;
  String value;
  SortByClass(this.title, this.value);
}
class _Filter_Out_of_Stock_ScreenState extends State<Filter_Out_of_Stock_Screen> {
  String sort_by;
  _Filter_Out_of_Stock_ScreenState(this.sort_by);

  List<SortByClass> sortByList=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(bottom: 45,left: 20,right: 10,top: 20),
      child: GridView.builder(
          itemCount: sortByList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4/1
          ),
          itemBuilder: (context,index)=>
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 20,
                    width: 20,
                    child: Radio(
                      value: sortByList[index].value,
                      groupValue: sort_by,
                      onChanged: (value) {
                        setState(() {
                          sort_by = value as String;
                          widget.onSaveCallback(sort_by);
                          print(sort_by);
                        });
                      },
                    ),
                  ),
                  Text(sortByList[index].title,style: TextStyle(color: Colors.black54,fontSize: 15),),
                ],
              )

      ),
    );
  }

  void setData() {

    // sortByList.add(SortByClass('In Stock','In_stock'));
    sortByList.add(SortByClass('Include Out of Stock','Include_out_of_stock'));

    if(this.mounted){
      setState(() {
      });
    }
  }
}
