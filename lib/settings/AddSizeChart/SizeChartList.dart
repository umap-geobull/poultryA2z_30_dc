import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/settings/AddSizeChart/AddSizeChart.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:getwidget/components/loader/gf_loader.dart';

import '../../Utils/App_Apis.dart';
import 'EditSizeChart.dart';
import 'Component/SizeChartModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Admin_add_Product/constants.dart';

class SizeChartList extends StatefulWidget {
  @override
  State<SizeChartList> createState() => SizeChartListState();
}

class SizeChartListState extends State<SizeChartList> {
  String baseUrl='', admin_auto_id='',app_type_id='';
  String user_id='',user_type='';
  bool isApiCallProcessing = false,isaddchart=false;
  List<GetSizeChartdata> sizeChartList = [];

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');
    String? userId = prefs.getString('user_id');
    String? userType =prefs.getString('user_type');
    String? apptypeid= prefs.getString('app_type_id');
    if (baseUrl!=null && adminId!=null && userId!=null && userType!=null && apptypeid!=null) {
      setState(() {
        this.user_id = userId;
        this.baseUrl=baseUrl;
        this.admin_auto_id=adminId;
        this.app_type_id=apptypeid;
        if(userType=='Admin'){
          isaddchart=true;
        }
        else{
          isaddchart=false;
        }
        getSizeCharts();
      });
    }
    return null;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBaseUrl();
  }

  void getSizeCharts() async {
    isApiCallProcessing = true;
    var url = baseUrl + 'api/' + get_size_chart_list;
    var uri = Uri.parse(url);
    final body={
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      isApiCallProcessing = false;

      final resp = jsonDecode(response.body);
      String status = resp['status'];
      if (status == '1') {
        SizeChartModel sizeChartModel =
            SizeChartModel.fromJson(json.decode(response.body));
        sizeChartList = sizeChartModel.getalldata;
        print(sizeChartList.toString());
        if (mounted) {
          setState(() {});
        }
      }
      else {
        sizeChartList = [];
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Size Charts",
            style: TextStyle(color: appBarIconColor, fontSize: 16)),
          leading: IconButton(
            onPressed: ()=>{Navigator.of(context).pop()},
            icon: const Icon(Icons.arrow_back, color: appBarIconColor),
          ),
        actions: [
          isaddchart==true?IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddSizeChart()),
              ).then(onGoBack);
            },
            icon: const Icon(
              Icons.add_circle_outline,
              color: appBarIconColor,
            ),
          ):const Text(''),
        ],
      ),
        body:Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                    child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: sizeChartList.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1 / 1.4,
                            crossAxisCount: 2,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 2.0),
                        itemBuilder:
                            (BuildContext context, int index) {
                          return SizeCard(sizeChartList[index]);
                        })
                )
              ],
            ),

            isApiCallProcessing==false&& sizeChartList.isEmpty?
            Center(child: Text('No size charts added'),):
            Container(),

            isApiCallProcessing==true?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: const GFLoader(
                  type:GFLoaderType.circle
              ),
            ):
            Container()],
        ),
    );
  }

  FutureOr onGoBack(dynamic value) {
    getSizeCharts();
  }

  showSizechartDetails(GetSizeChartdata sizechart) {
    Route routes =
    MaterialPageRoute(builder: (context) => EditSizeChart(sizechart));
    Navigator.push(context, routes).then(onGoBack);
  }

  SizeCard(GetSizeChartdata sizechart) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[100],
        child:GestureDetector(
        onTap: ()=>{
          showSizechartDetails(sizechart)
    },
    child: sizechart.chartImage.isNotEmpty
            ? CachedNetworkImage(
                fit: BoxFit.contain,
                imageUrl: baseUrl+sizechart_image_base_url + sizechart.chartImage,
                placeholder: (context, url) => Container(
                    decoration: BoxDecoration(
                  color: Colors.grey[400],
                )),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            : Container(
                child: const Icon(Icons.error),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                )))
    );
  }
}
