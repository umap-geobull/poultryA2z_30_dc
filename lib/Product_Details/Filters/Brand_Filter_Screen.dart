import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Vendor_Module/Vendor_Home/Components/Model/Get_Brand_LIst_Model.dart';
import 'package:poultry_a2z/Vendor_Module/Vendor_add_Product/Components/Model/all_brands_model.dart';
import 'package:http/http.dart' as http;
import '../../Utils/App_Apis.dart';
import 'package:getwidget/getwidget.dart';

typedef OnSaveCallback = void Function(List<String> colors);

class Brand_Filter_Screen extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String selectedBrand;

  Brand_Filter_Screen(this.onSaveCallback, this.selectedBrand);

  @override
  _Brand_Filter_ScreenState createState() => _Brand_Filter_ScreenState();
}

class _Brand_Filter_ScreenState extends State<Brand_Filter_Screen> {
  bool isApiCallProcessing = false;
  String baseUrl = '',admin_auto_id='',app_type_id='';
  String user_id = '';
  late Brand_Model brand_model;
  List<GetBrandslist> getBrandslist=[];
  List<String> selectedbrand_id = [];
  late Route routes;
  @override
  void initState() {
    super.initState();
    getBaseUrl();
    setData();
  }

  setData(){
    this.selectedbrand_id=widget.selectedBrand.split('|');
    if(this.mounted){
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.only(top: 10,bottom: 45),
          child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            child: isApiCallProcessing == false ?
            Container(
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                itemCount: getBrandslist.length,
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
                                  if (isAdded(getBrandslist[index].id) == true) {
                                    selectedbrand_id.remove(getBrandslist[index].id);
                                    print(selectedbrand_id.toString());
                                    widget.onSaveCallback(selectedbrand_id);
                                  }
                                  else {
                                    selectedbrand_id.add(getBrandslist[index].id);
                                    print(selectedbrand_id.toString());
                                    widget.onSaveCallback(selectedbrand_id);
                                  }
                                });
                              }
                            },
                            value: isAdded(getBrandslist[index].id),
                          ),
                          margin: const EdgeInsets.all(5),
                        ),
                        Flexible(
                          child: Text(
                            getBrandslist[index].brandName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ]),
                )),
            ):
            getBrandslist.isEmpty && isApiCallProcessing == false ?
            const Center(child: Text('No Brands')) :
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child:
              GFLoader(type: GFLoaderType.circle),
            ),
          )),
    );
  }

  Future getMainBrand() async {
    var url=baseUrl+'api/'+get_brand_list;

    var uri = Uri.parse(url);

    final body={
      "admin_auto_id":admin_auto_id,
      "app_type_id": app_type_id,
    };
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      final resp=jsonDecode(response.body);
      int status=resp['status'];
      if(status==1){
        AllBrandsModel allBrandsModel=AllBrandsModel.fromJson(json.decode(response.body));
        getBrandslist=allBrandsModel.getBrandslist;
      }

      if(mounted){
        setState(() {});
      }
    }
  }

  bool isAdded(String id) {
    for (int i = 0; i < selectedbrand_id.length; i++) {
      if (selectedbrand_id[i] == id) {
        return true;
      }
    }
    return false;
  }

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? baseUrl = prefs.getString('base_url');
    String? adminId= prefs.getString('admin_auto_id');
    String? apptypeid= prefs.getString('app_type_id');
    if (userId != null && baseUrl != null && adminId!=null && apptypeid!=null) {
      setState(() {
        this.baseUrl = baseUrl;
        this.admin_auto_id = adminId;
        this.app_type_id=apptypeid;
        getMainBrand();
      });
    }
    return null;
  }
}
