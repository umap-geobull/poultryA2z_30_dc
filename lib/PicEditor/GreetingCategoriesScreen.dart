
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/PicEditor/utils/images.dart';
import 'package:poultry_a2z/PicEditor/utils/styling.dart';
import 'package:http/http.dart' as http;
import 'GeneralGreetingsModel.dart';
import 'SelectImageScreen.dart';
import 'api/all_urls.dart';


class GreetingCategoriesScreen extends StatefulWidget{

  @override
  _GreetingCategoriesScreenState createState() => _GreetingCategoriesScreenState();

}

class _GreetingCategoriesScreenState extends State<GreetingCategoriesScreen>{
  bool isApiCallProcess=false;
  List<AllGeneralGreetings> specialCategoryList=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getGeneralGreetings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget> [
              Expanded(
                flex:1,
                child: showHeader(),
              ),

              Expanded(
                  flex:9,
                  child:showSpecialCategories()
              ),

            ],
          ),
        ),
      )
    );

  }

  Widget showHeader() {
    return  Container(
      height: 70,
      padding: EdgeInsets.all(10),
      child:Container(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.all(10),
                  child: Image.asset('assets/backpress.png'),
                ),
                onTap: ()=> _onBackPressed(),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text('General Categories',style: AppTheme.appbar_title,)
              ),
            ),
          ],
        ),
      ),
    );

  }

  Widget showSpecialCategories() {
    if(isApiCallProcess){
      return Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: 500,
        child: CircularProgressIndicator(),
      );
    }
    else{
      if(specialCategoryList!=null && specialCategoryList.isNotEmpty){
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  child: Expanded(
                      child: GridView.builder(
                       // physics: NeverScrollableScrollPhysics(),
                        itemCount: specialCategoryList.length,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: (2 / 2.8),
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            //mainAxisSpacing: 5
                        ),
                        itemBuilder: (context,position){
                          return Container(
                            child: GestureDetector(
                              child:Container(
                                child:Column(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.fill,
                                          //placeholder: (context, url) => Center(child:Container(height:30,width:30,child: CircularProgressIndicator(),)),
                                          placeholder: (context, url) =>
                                              Container(decoration: BoxDecoration(
                                                color: Colors.grey[400],
                                              )),
                                        imageUrl:GREETING_CATEGORY_BASE_URL + specialCategoryList[position].grtImg),
                                    ),
                                    Text(specialCategoryList[position].name,style: AppTheme.fest_date_text_style,textAlign: TextAlign.center,),
                                  ],
                                ),
                              ),
                              onTap: ()=> {
                                Navigator.push(context,  MaterialPageRoute(builder: (context) => SelectImageScreen('Greetings',specialCategoryList[position].id, specialCategoryList[position].name)))

                              },
                            ),
                          );
                        },
                      )
                  )
              )
            ],
          ),
        );
      }
      else{
        return Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 500,
          child: Text('No special categories posts available',style:AppTheme.no_data_text_style,),
        );
      }
    }

  }

  Future getGeneralGreetings() async{

    var url=BASE_URL+GET_GREETINGS;

    var uri = Uri.parse(url);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      // String message=resp['msg'];
      int status=resp['status'];
      if(status==1){
        setState(() {
          GenerGreetingsModel generGreetingsModel=GenerGreetingsModel.fromJson(json.decode(response.body));
          specialCategoryList=generGreetingsModel.allGeneralGreetings;
        });
      }
    }
  }

  _onBackPressed() async{
    Navigator.pop(context);
  }
}