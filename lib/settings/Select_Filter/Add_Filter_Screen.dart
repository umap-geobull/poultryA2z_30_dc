import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Utils/App_Apis.dart';
import 'Components/filter_menu_model.dart';
import 'Components/Rest_Apis.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';


class SelectFilter extends StatefulWidget {
  const SelectFilter({Key? key}) : super(key: key);

  @override
  _SelectFilterState createState() => _SelectFilterState();
}

class _SelectFilterState extends State<SelectFilter> {
  String user_id = "", size_name = "";
  bool isApiCallProcessing = false;
  String baseUrl='', admin_auto_id='';

  List<String> selectedFilter=[];

  List<String> filterList=[
    // 'Sort By',
    'Price',
    'Moq',
    'Size',
    'Color',
    'Brand',
    'Manufacturers',
    'Material',
    'Dimension',
    'Thickness',
    'Firmness',
    'Discount',
    'Out of stock'
  ];

  String id='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text("Filter List",
              style: TextStyle(color: appBarIconColor, fontSize: 16)),
          leading: IconButton(
            onPressed: ()=>{Navigator.of(context).pop()},
            icon: const Icon(Icons.arrow_back, color: appBarIconColor),
          ),
        ),
        body:Stack(
          children: <Widget>[
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child:
              GridView.builder(
                  physics: const ScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    crossAxisCount: 3,
                    childAspectRatio: 1/0.5
                  ),
                  itemCount: filterList.length,

                  itemBuilder: (context, index) =>
                      SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child:  Row(
                        mainAxisAlignment:  MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 25,
                            width: 25,

                            child: Checkbox(
                              onChanged: (value) {
                                if(mounted){
                                  setState(() {
                                    if(isAdded(filterList[index])==true){
                                      selectedFilter.remove(filterList[index]);
                                    }
                                    else{
                                      selectedFilter.add(filterList[index]);
                                    }
                                  });
                                }
                              },
                              value: isAdded(filterList[index]),
                            ),
                            margin: const EdgeInsets.all(5),
                          ),
                          Flexible(
                            child: Text(
                              filterList[index],
                              style: const TextStyle(fontSize: 14, color: Colors.black, ),
                            ),
                          )
                        ]
                    ),
                  )

              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(10),
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 45,
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor,
                        textStyle: const TextStyle(fontSize: 20)),
                    onPressed: () {
                      add_Filter_List();
                      //Update_Express_delivery_Layout();
                    },
                    child: const Center(
                      child: Text(
                        'SAVE',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
              ),
            ),

            isApiCallProcessing==true?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: const GFLoader(
                  type:GFLoaderType.circle
              ),
            ):
            Container()],
        ));
  }

  bool isAdded(String filter){
    for(int i=0;i<selectedFilter.length;i++){
      if(selectedFilter[i]==filter){
        return true;
      }
    }
    return false;
  }

  getFilterList() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    final body={
      "admin_auto_id":admin_auto_id,
    };

    var url = baseUrl+'api/' + get_filter_menu;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;

      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        FilterMenuModel filterMenuModel=FilterMenuModel.fromJson(json.decode(response.body));

        id=filterMenuModel.id!;
        filterMenuModel.allfiltermenus.forEach((element) {
          selectedFilter.add(element.filterMenuName);
        });
      }
      else {
        print('empty');
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  void add_Filter_List() {

    String filter='';

    for(int i=0;i<selectedFilter.length;i++){
      if(i==0){
        filter+=selectedFilter[i];
        print('i=0 '+filter);
      }
      else{
        filter += '|'+selectedFilter[i];
        print(filter);
      }
    }


    print(filter);

    setState(() {
      isApiCallProcessing = true;
    });

    Rest_Apis restApis=Rest_Apis();

    restApis.Add_Filter(id,filter,baseUrl,admin_auto_id).then((value){

      if(value!=null){


        int status =value;

        if(status == 1){
          Fluttertoast.showToast(msg: "Filter added successfully", backgroundColor: Colors.grey,);

          Navigator.pop(context);
        }

        isApiCallProcessing = false;
      }
    });
  }

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');

    if (baseUrl!=null && adminId!=null) {
      setState(() {
        this.baseUrl=baseUrl;
        this.admin_auto_id=adminId;
        getFilterList();
      });
    }
    return null;
  }

}
