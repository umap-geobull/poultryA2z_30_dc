import 'package:flutter/material.dart';

typedef OnSaveCallback = void Function(String sortBy);

class Sort_By_Filter_Screen extends StatefulWidget {

  OnSaveCallback onSaveCallback;
  String selected;

  Sort_By_Filter_Screen(this.onSaveCallback, this.selected);

  @override
  State<Sort_By_Filter_Screen> createState() => _Sort_By_Filter_ScreenState(selected);
}

class SortByClass{
  String title;
  String value;
  SortByClass(this.title, this.value);
}

class _Sort_By_Filter_ScreenState extends State<Sort_By_Filter_Screen> {
  String sort_by;
  _Sort_By_Filter_ScreenState(this.sort_by);

  List<SortByClass> sortByList=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setData();
  }
 /*
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(bottom: 45),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2/1
        ),
        children: [
          ListTile(
            title: const Text('Price Low To High'),
            leading: Radio(
              value: 'price_low_to_high',
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
          ListTile(
            title: const Text('Price high To Low'),
            leading: Radio(
              value: 'price_high_to_low',
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
          ListTile(
            title: const Text('Bestselling'),
            leading: Radio(
              value: 'best_selling',
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
          ListTile(
            title: const Text('New to Old'),
            leading: Radio(
              value: 'new_to_old',
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
          ListTile(
            title: const Text('Old To New'),
            leading: Radio(
              value: 'old_to_new',
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
          ListTile(
            title: const Text('Most Favourites'),
            leading: Radio(
              value: 'most_favourite',
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
          ListTile(
            title: const Text('Popularity'),
            leading: Radio(
              value: 'popularity',
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
          ListTile(
            title: const Text('Product Rating'),
            leading: Radio(
              value: 'product_rating',
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
        ],
      ),
    );
  }
*/


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

    sortByList.add(SortByClass('Price Low to High','price_low_to_high'));
    sortByList.add(SortByClass('Price High to Low','price_high_to_low'));
    sortByList.add(SortByClass('Bestselling','best_selling'));
    sortByList.add(SortByClass('New To Old','new_to_high'));
    sortByList.add(SortByClass('Old To New','old_to_new'));
    sortByList.add(SortByClass('Most Favourite','most_favourite'));
    sortByList.add(SortByClass('Popularity','popularity'));
    sortByList.add(SortByClass('Product Rating','product_rating'));


    if(this.mounted){
      setState(() {
      });
    }
  }
}
