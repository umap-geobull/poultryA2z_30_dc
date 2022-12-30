import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Home/SearchListModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Product_Details/Product_List_User.dart';
import '../Product_Details/product_details_screen.dart';
import '../Utils/App_Apis.dart';
import 'package:http/http.dart' as http;

class SearchList extends StatefulWidget {
  @override
  SearchListState createState() => SearchListState();
}

class SearchListState extends State<SearchList> {
  TextEditingController controller = TextEditingController();

  String baseUrl = "",admin_auto_id='';
  bool isApiCallProcessing = true;
  List<Allsearchlist> searchListData = [];
  final List<Allsearchlist> _searchResult = [];
  late String result;
  String user_id = '',app_type_id='';

  void getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    String? adminId = prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');

    if (baseUrl != null && adminId!=null && apptypeid!=null) {
      this.baseUrl = baseUrl;
      this.admin_auto_id=adminId;
      this.app_type_id=apptypeid;
      setState(() {});
      getSearchList();
    }
    if (userId != null && baseUrl != null) {
      user_id = userId;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: new AppBar(
      //   title: new Text(''),
      //   elevation: 0.0,
      // ),
      body:SafeArea(
        child: Column(
          children: <Widget>[
            Card(
        child:Row(
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.all(0),
              onPressed: Navigator.of(context).pop,
              icon: Icon(Icons.arrow_back, color: Colors.black),
            ),

            Expanded(
                child: ListTile(
                  focusColor: Colors.black,
                  title: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                        hintText: 'Search', border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      controller.clear();
                      onSearchTextChanged('');
                    },
                  ),
                )
            )
          ],
        )
      ),
            Expanded(
                child:

                controller.text.isNotEmpty?
                _searchResult.isNotEmpty ?
                ListView.builder(
                  itemCount: _searchResult.length,
                  itemBuilder: (context, i) {
                    return Card(
                        child: GestureDetector(
                          onTap: () => {
                            addSearchData(user_id, _searchResult[i].id,
                                _searchResult[i].title, _searchResult[i].type),
                          },
                          child: ListTile(
                            leading: const Icon(Icons.search),
                            title: Text(_searchResult[i].title),
                          ),
                        ));
                  },
                ):
                Center(
                  child: Text('No Search Results Found'),
                ) :
                Container()
            ),
          ],
        ),
      ));
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var searchDetail in searchListData) {
      late String TitleFromList = searchDetail.title.toLowerCase(),
          TitleFromResult = text.toLowerCase();
      print(TitleFromList + "" + TitleFromResult);
      if (TitleFromList.contains(TitleFromResult)) {
        _searchResult.add(searchDetail);
      }
    }

    setState(() {});
  }

  getSearchList() async {
    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }

    var url = baseUrl + 'api/' + Get_Search_List;

    Uri uri = Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };
    print(body);
    final response = await http.post(uri,body: body);

    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing = false;

      final resp = jsonDecode(response.body);
      int status = resp['status'];
      print("status=>" + status.toString());
      if (status == 1) {
        SearchListModel searchListModel =
            SearchListModel.fromJson(json.decode(response.body));
        searchListData = searchListModel.allsearchlist;
      } else {
        print('empty');
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  addSearchData(String userId, String id, String title, String type) async {
    controller.text = title;
    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }

    var url = baseUrl + 'api/' + search;

    Uri uri = Uri.parse(url);
    final body = {
      "customer_auto_id": userId,
      "id": id,
      "title": title,
      "type": type,
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };
    /*print('custid:' + userId);
    print('id:' + id);
    print('title:' + title);
    print('type:' + type);
    print('admin_auto_id:' + admin_auto_id);
    print('app_type_id:' + app_type_id);*/

    final response = await http.post(uri, body: body);
    //print(response);
    if (response.statusCode == 200) {
      isApiCallProcessing = false;

      final resp = jsonDecode(response.body);
      int status = resp['status'];
      print("status=>" + status.toString());
      if (status == 1) {
        print('search added');
        if (type == 'Product') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProductDetailScreen(id)));
        } else if (type == 'Subcategory') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Product_List_User(
                    type: type,
                    main_cat_id: '',
                    sub_cat_id: id,
                    brand_id: '',
                      home_componet_id: "",
                    offer_id: '',
                  )));
        } else if (type == 'Brand') {
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => Product_List_User(
                    type: type,
                    main_cat_id: '',
                    sub_cat_id: '',
                    brand_id: id,
                      home_componet_id: "",
                    offer_id: '',
                  )));
        }else if (type == 'category'){
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => Product_List_User(
                    type: type,
                    main_cat_id: id,
                    sub_cat_id: '',
                    brand_id: '',
                      home_componet_id: "",
                    offer_id: '',
                  )));
        }
      } else {
        print('empty');
      }
      if (mounted) {
        setState(() {});
      }
    }
  }
}
